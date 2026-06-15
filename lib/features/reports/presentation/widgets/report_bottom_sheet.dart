import 'package:bazaar/features/reports/presentation/providers/report_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

enum ReportTarget {
  listing,
  user,
}

class ReportBottomSheet extends ConsumerStatefulWidget {
  const ReportBottomSheet({
    required this.target,
    this.listingId,
    this.reportedUserId,
    super.key,
  }) : assert(
          target == ReportTarget.listing
              ? listingId != null
              : reportedUserId != null,
        );

  final ReportTarget target;
  final String? listingId;
  final String? reportedUserId;

  @override
  ConsumerState<ReportBottomSheet> createState() => _ReportBottomSheetState();
}

class _ReportBottomSheetState extends ConsumerState<ReportBottomSheet> {
  ReportReason? _selectedReason;
  final _detailsController = TextEditingController();
  var _isSubmitting = false;

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  String get _title => switch (widget.target) {
        ReportTarget.listing => 'Report this listing',
        ReportTarget.user => 'Report this seller',
      };

  Future<void> _submit() async {
    if (_selectedReason == null || _isSubmitting) return;

    setState(() => _isSubmitting = true);

    final controller = ref.read(reportControllerProvider);
    final details = _detailsController.text.trim();

    final result = switch (widget.target) {
      ReportTarget.listing => await controller.submitListingReport(
          listingId: widget.listingId!,
          reason: _selectedReason!,
          details: details.isEmpty ? null : details,
        ),
      ReportTarget.user => await controller.submitUserReport(
          reportedUserId: widget.reportedUserId!,
          reason: _selectedReason!,
          details: details.isEmpty ? null : details,
        ),
    };

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    switch (result) {
      case ReportSubmitResult.success:
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.target == ReportTarget.listing
                  ? "Thanks — we'll review this listing"
                  : "Thanks — we'll review this report",
            ),
          ),
        );
      case ReportSubmitResult.alreadyReported:
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Already reported')),
        );
      case ReportSubmitResult.notSignedIn:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please sign in to report.')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ReportReason.values.map((reason) {
              return ChoiceChip(
                label: Text(reason.label),
                selected: _selectedReason == reason,
                onSelected: _isSubmitting
                    ? null
                    : (selected) {
                        setState(() {
                          _selectedReason = selected ? reason : null;
                        });
                      },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _detailsController,
            enabled: !_isSubmitting,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Add details (optional)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _selectedReason == null || _isSubmitting ? null : _submit,
            child: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Submit'),
          ),
        ],
      ),
    );
  }
}

Future<void> showReportListingSheet(
  BuildContext context, {
  required String listingId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => ReportBottomSheet(
      target: ReportTarget.listing,
      listingId: listingId,
    ),
  );
}

Future<void> showReportUserSheet(
  BuildContext context, {
  required String reportedUserId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => ReportBottomSheet(
      target: ReportTarget.user,
      reportedUserId: reportedUserId,
    ),
  );
}
