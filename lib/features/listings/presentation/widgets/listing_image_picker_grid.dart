import 'package:bazaar/core/widgets/cached_network_image.dart';
import 'package:bazaar/config/theme/app_colors.dart';
import 'package:bazaar/features/listings/presentation/providers/create_listing_state.dart';
import 'package:flutter/material.dart';

class ListingImagePickerGrid extends StatelessWidget {
  const ListingImagePickerGrid({
    required this.images,
    required this.maxImages,
    required this.photosLabel,
    required this.galleryLabel,
    required this.cameraLabel,
    required this.onAddGallery,
    required this.onAddCamera,
    required this.onRemove,
    super.key,
  });

  final List<SelectedListingImage> images;
  final int maxImages;
  final String photosLabel;
  final String galleryLabel;
  final String cameraLabel;
  final VoidCallback onAddGallery;
  final VoidCallback onAddCamera;
  final void Function(String imageId) onRemove;

  @override
  Widget build(BuildContext context) {
    final canAddMore = images.length < maxImages;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          photosLabel,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: images.length + (canAddMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == images.length) {
              return _AddImageTile(
                galleryLabel: galleryLabel,
                cameraLabel: cameraLabel,
                onGallery: onAddGallery,
                onCamera: onAddCamera,
              );
            }

            final image = images[index];
            return _ImageTile(
              image: image,
              onRemove: () => onRemove(image.id),
            );
          },
        ),
      ],
    );
  }
}

class _ImageTile extends StatelessWidget {
  const _ImageTile({required this.image, required this.onRemove});

  final SelectedListingImage image;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: image.isRemoteOnly
              ? AppCachedNetworkImage(imageUrl: image.downloadUrl!)
              : Image.memory(image.bytes, fit: BoxFit.cover),
        ),
        if (image.isUploading || image.uploadProgress < 1)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  LinearProgressIndicator(
                    value: image.uploadProgress > 0 ? image.uploadProgress : null,
                    backgroundColor: Colors.white24,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        if (image.error != null)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.error_outline, color: Colors.white),
            ),
          ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddImageTile extends StatelessWidget {
  const _AddImageTile({
    required this.galleryLabel,
    required this.cameraLabel,
    required this.onGallery,
    required this.onCamera,
  });

  final String galleryLabel;
  final String cameraLabel;
  final VoidCallback onGallery;
  final VoidCallback onCamera;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onGallery,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(8),
          color: AppColors.primary.withValues(alpha: 0.05),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_photo_alternate_outlined, color: AppColors.primary),
            const SizedBox(height: 4),
            Text(galleryLabel, style: const TextStyle(fontSize: 11)),
            TextButton(
              onPressed: onCamera,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(cameraLabel, style: const TextStyle(fontSize: 11)),
            ),
          ],
        ),
      ),
    );
  }
}
