import 'package:bazaar/core/widgets/cached_network_image.dart';
import 'package:flutter/material.dart';

class ListingImageGallery extends StatefulWidget {
  const ListingImageGallery({
    required this.images,
    this.onImageTap,
    super.key,
  });

  final List<String> images;
  final ValueChanged<int>? onImageTap;

  @override
  State<ListingImageGallery> createState() => _ListingImageGalleryState();
}

class _ListingImageGalleryState extends State<ListingImageGallery> {
  final _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.images.isEmpty) {
      return AspectRatio(
        aspectRatio: 4 / 3,
        child: Container(
          color: Colors.grey.shade200,
          child: const Icon(Icons.image_not_supported_outlined, size: 48),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => widget.onImageTap?.call(index),
                child: AppCachedNetworkImage(imageUrl: widget.images[index]),
              );
            },
          ),
          if (widget.images.length > 1)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.images.length, (index) {
                  final isActive = index == _currentPage;
                  return Container(
                    width: isActive ? 10 : 8,
                    height: isActive ? 10 : 8,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? Colors.white : Colors.white54,
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}
