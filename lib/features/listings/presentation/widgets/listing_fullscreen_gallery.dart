import 'package:bazaar/core/widgets/cached_network_image.dart';
import 'package:flutter/material.dart';

class ListingFullscreenGallery extends StatefulWidget {
  const ListingFullscreenGallery({
    required this.images,
    required this.initialIndex,
    super.key,
  });

  final List<String> images;
  final int initialIndex;

  @override
  State<ListingFullscreenGallery> createState() =>
      _ListingFullscreenGalleryState();
}

class _ListingFullscreenGalleryState extends State<ListingFullscreenGallery> {
  late final PageController _controller;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text('${_currentIndex + 1} / ${widget.images.length}'),
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: widget.images.length,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: Center(
              child: AppCachedNetworkImage(
                imageUrl: widget.images[index],
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}
