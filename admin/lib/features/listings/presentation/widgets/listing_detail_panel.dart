import 'package:admin/core/l10n/admin_locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketplace_shared/marketplace_shared.dart';

class ListingDetailPanel extends ConsumerWidget {
  const ListingDetailPanel({
    required this.listing,
    required this.onClose,
    super.key,
  });

  final ListingModel listing;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.str;
    final localeCode = ref.watch(adminLocaleProvider).code;

    return Material(
      elevation: 8,
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      listing.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (listing.images.isNotEmpty)
                    SizedBox(
                      height: 180,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: listing.images.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              listing.images[index],
                              width: 240,
                              height: 180,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 240,
                                color: Colors.grey.shade200,
                                child: const Icon(Icons.broken_image),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  const SizedBox(height: 16),
                  _InfoRow(
                    label: s.price,
                    value: '\$${listing.price.toStringAsFixed(0)}',
                  ),
                  _InfoRow(
                    label: s.category,
                    value: listing.category.localizedLabel(s),
                  ),
                  _InfoRow(
                    label: s.city,
                    value: MarketGeography.localityLabel(
                      listing.city,
                      localeCode,
                    ),
                  ),
                  _InfoRow(label: s.owner, value: listing.ownerName),
                  _InfoRow(
                    label: s.status,
                    value: s.listingStatus(listing.status.value),
                  ),
                  _InfoRow(
                    label: s.viewsLabel,
                    value: '${listing.viewCount}',
                  ),
                  const SizedBox(height: 16),
                  Text(
                    s.description,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(listing.description),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
