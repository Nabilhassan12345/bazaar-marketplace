import 'package:bazaar/config/routes/route_names.dart';
import 'package:bazaar/config/theme/app_colors.dart';
import 'package:bazaar/core/utils/formatters.dart';
import 'package:bazaar/core/utils/time_ago.dart';
import 'package:bazaar/core/widgets/empty_state.dart';
import 'package:bazaar/features/listings/presentation/providers/listing_providers.dart';
import 'package:bazaar/features/listings/presentation/widgets/listing_fullscreen_gallery.dart';
import 'package:bazaar/features/listings/presentation/widgets/listing_image_gallery.dart';
import 'package:bazaar/features/listings/presentation/widgets/listing_card.dart';
import 'package:bazaar/features/listings/presentation/widgets/owner_card.dart';
import 'package:bazaar/features/listings/presentation/widgets/report_listing_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class ListingDetailPage extends ConsumerStatefulWidget {
  const ListingDetailPage({required this.listingId, super.key});

  final String listingId;

  @override
  ConsumerState<ListingDetailPage> createState() => _ListingDetailPageState();
}

class _ListingDetailPageState extends ConsumerState<ListingDetailPage> {
  var _viewCountIncremented = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_incrementViewCount);
  }

  Future<void> _incrementViewCount() async {
    if (_viewCountIncremented) return;
    _viewCountIncremented = true;
    try {
      await ref.read(listingRepositoryProvider).incrementViewCount(widget.listingId);
    } catch (_) {
      _viewCountIncremented = false;
    }
  }

  Future<void> _launchUrl(Uri uri) async {
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open link.')),
        );
      }
    }
  }

  void _callSeller(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seller phone number not available.')),
      );
      return;
    }
    final digits = phone.replaceAll(RegExp(r'[^\d+]'), '');
    _launchUrl(Uri.parse('tel:$digits'));
  }

  void _whatsappSeller(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seller phone number not available.')),
      );
      return;
    }
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    _launchUrl(Uri.parse('https://wa.me/$digits'));
  }

  @override
  Widget build(BuildContext context) {
    final listingAsync = ref.watch(listingDetailProvider(widget.listingId));

    return Scaffold(
      appBar: AppBar(title: const Text('Listing')),
      body: listingAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(16),
          child: ListingCard(isLoading: true, listing: null),
        ),
        error: (error, _) => ErrorStateView(
          onRetry: () => ref.invalidate(listingDetailProvider(widget.listingId)),
        ),
        data: (listing) {
          if (listing == null) {
            return const EmptyStateView(
              icon: Icons.search_off,
              title: 'Listing not found',
            );
          }

          final ownerAsync = ref.watch(userProfileProvider(listing.ownerId));
          final price = Formatters.formatPrice(listing.price);

          return ListView(
            children: [
              ListingImageGallery(
                images: listing.images,
                onImageTap: (index) {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ListingFullscreenGallery(
                        images: listing.images,
                        initialIndex: index,
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      listing.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        _MetaChip(
                          icon: Icons.location_on_outlined,
                          label: listing.city,
                        ),
                        _MetaChip(
                          icon: Icons.category_outlined,
                          label: listing.category.label,
                        ),
                        _MetaChip(
                          icon: Icons.schedule,
                          label: formatTimeAgo(listing.createdAt),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      listing.description,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    OwnerCard(
                      displayName: listing.ownerName,
                      photoUrl: listing.ownerPhoto,
                      subtitle: 'View seller profile',
                      onTap: () => context.pushNamed(
                        RouteKeys.sellerProfile,
                        pathParameters: {'id': listing.ownerId},
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              final owner = ownerAsync.valueOrNull;
                              _callSeller(owner?.phone);
                            },
                            icon: const Icon(Icons.phone),
                            label: const Text('Call Seller'),
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              minimumSize: const Size.fromHeight(48),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              final owner = ownerAsync.valueOrNull;
                              _whatsappSeller(owner?.phone);
                            },
                            icon: const Icon(Icons.chat),
                            label: const Text('WhatsApp'),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextButton.icon(
                      onPressed: () => showReportListingSheet(
                        context,
                        listingId: listing.id,
                      ),
                      icon: const Icon(Icons.flag_outlined, color: Colors.red),
                      label: const Text(
                        'Report listing',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}
