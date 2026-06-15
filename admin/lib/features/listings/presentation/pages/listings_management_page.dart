import 'package:admin/features/listings/presentation/providers/admin_listings_provider.dart';
import 'package:admin/features/listings/presentation/widgets/listing_detail_panel.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class ListingsManagementPage extends ConsumerStatefulWidget {
  const ListingsManagementPage({super.key});

  @override
  ConsumerState<ListingsManagementPage> createState() =>
      _ListingsManagementPageState();
}

class _ListingsManagementPageState
    extends ConsumerState<ListingsManagementPage> {
  ListingStatus? _statusFilter;
  final _selectedIds = <String>{};
  ListingModel? _detailListing;

  @override
  Widget build(BuildContext context) {
    final listingsAsync = ref.watch(adminListingsProvider);

    return listingsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
      data: (rawListings) {
        final sorted = sortListingsDefault(rawListings);
        final listings = filterListingsByStatus(sorted, _statusFilter);

        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _StatusTabs(
                  selected: _statusFilter,
                  onChanged: (status) => setState(() => _statusFilter = status),
                ),
                if (_selectedIds.isNotEmpty)
                  _BulkActionsBar(
                    count: _selectedIds.length,
                    onApprove: () => _bulkApprove(),
                    onReject: () => _bulkReject(),
                    onClear: () => setState(_selectedIds.clear),
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: DataTable2(
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      minWidth: 1100,
                      headingRowColor: WidgetStateProperty.all(
                        Colors.grey.shade100,
                      ),
                      columns: const [
                        DataColumn2(label: Text(''), fixedWidth: 48),
                        DataColumn2(label: Text(''), fixedWidth: 56),
                        DataColumn2(label: Text('Title'), size: ColumnSize.L),
                        DataColumn2(label: Text('Category'), size: ColumnSize.S),
                        DataColumn2(label: Text('City'), size: ColumnSize.S),
                        DataColumn2(label: Text('Price'), size: ColumnSize.S),
                        DataColumn2(label: Text('Owner'), size: ColumnSize.M),
                        DataColumn2(label: Text('Status'), size: ColumnSize.S),
                        DataColumn2(label: Text('Date'), size: ColumnSize.S),
                        DataColumn2(label: Text('Actions'), fixedWidth: 220),
                      ],
                      rows: listings.map((listing) {
                        final date =
                            DateFormat.yMMMd().format(listing.createdAt);
                        return DataRow2(
                          selected: _selectedIds.contains(listing.id),
                          onTap: () =>
                              setState(() => _detailListing = listing),
                          color: WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return Colors.blue.shade50;
                            }
                            return null;
                          }),
                          cells: [
                            DataCell(
                              Checkbox(
                                value: _selectedIds.contains(listing.id),
                                onChanged: (checked) {
                                  setState(() {
                                    if (checked ?? false) {
                                      _selectedIds.add(listing.id);
                                    } else {
                                      _selectedIds.remove(listing.id);
                                    }
                                  });
                                },
                              ),
                            ),
                            DataCell(_Thumbnail(imageUrl: listing.images.firstOrNull)),
                            DataCell(
                              Text(
                                listing.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            DataCell(Text(listing.category.label)),
                            DataCell(Text(listing.city)),
                            DataCell(
                              Text('\$${listing.price.toStringAsFixed(0)}'),
                            ),
                            DataCell(Text(listing.ownerName)),
                            DataCell(_StatusChip(status: listing.status)),
                            DataCell(Text(date)),
                            DataCell(
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (listing.status != ListingStatus.approved)
                                    TextButton(
                                      onPressed: () => _approve(listing.id),
                                      child: const Text('Approve'),
                                    ),
                                  if (listing.status != ListingStatus.rejected)
                                    TextButton(
                                      onPressed: () => _reject(listing.id),
                                      child: const Text('Reject'),
                                    ),
                                  IconButton(
                                    tooltip: 'Delete',
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _delete(listing),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            if (_detailListing != null)
              Positioned.fill(
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _detailListing = null),
                        child: Container(color: Colors.black26),
                      ),
                    ),
                    SizedBox(
                      width: 420,
                      child: ListingDetailPanel(
                        listing: _detailListing!,
                        onClose: () => setState(() => _detailListing = null),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _approve(String id) async {
    await ref.read(adminListingsControllerProvider).approve(id);
  }

  Future<void> _reject(String id) async {
    await ref.read(adminListingsControllerProvider).reject(id);
  }

  Future<void> _bulkApprove() async {
    await ref
        .read(adminListingsControllerProvider)
        .approveMany(_selectedIds.toList());
    setState(_selectedIds.clear);
  }

  Future<void> _bulkReject() async {
    await ref
        .read(adminListingsControllerProvider)
        .rejectMany(_selectedIds.toList());
    setState(_selectedIds.clear);
  }

  Future<void> _delete(ListingModel listing) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete listing?'),
        content: Text(
          'Permanently delete "${listing.title}"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await ref.read(adminListingsControllerProvider).delete(listing.id);
    if (_detailListing?.id == listing.id) {
      setState(() => _detailListing = null);
    }
    setState(() => _selectedIds.remove(listing.id));
  }
}

class _StatusTabs extends StatelessWidget {
  const _StatusTabs({
    required this.selected,
    required this.onChanged,
  });

  final ListingStatus? selected;
  final ValueChanged<ListingStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: SegmentedButton<ListingStatus?>(
        segments: const [
          ButtonSegment(value: null, label: Text('All')),
          ButtonSegment(
            value: ListingStatus.pendingReview,
            label: Text('Pending'),
          ),
          ButtonSegment(
            value: ListingStatus.approved,
            label: Text('Approved'),
          ),
          ButtonSegment(
            value: ListingStatus.rejected,
            label: Text('Rejected'),
          ),
        ],
        selected: {selected},
        onSelectionChanged: (values) => onChanged(values.first),
      ),
    );
  }
}

class _BulkActionsBar extends StatelessWidget {
  const _BulkActionsBar({
    required this.count,
    required this.onApprove,
    required this.onReject,
    required this.onClear,
  });

  final int count;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Text('$count selected'),
            const SizedBox(width: 16),
            FilledButton(
              onPressed: onApprove,
              child: const Text('Approve selected'),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: onReject,
              child: const Text('Reject selected'),
            ),
            const Spacer(),
            TextButton(onPressed: onClear, child: const Text('Clear')),
          ],
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.image_not_supported, size: 20),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Image.network(
        imageUrl!,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 40,
          height: 40,
          color: Colors.grey.shade200,
          child: const Icon(Icons.broken_image, size: 20),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final ListingStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ListingStatus.pendingReview => ('Pending', Colors.amber.shade800),
      ListingStatus.approved => ('Approved', Colors.green.shade700),
      ListingStatus.rejected => ('Rejected', Colors.red.shade700),
      ListingStatus.draft => ('Draft', Colors.grey.shade700),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
