import 'package:daily_tarot_focus/core/widgets/custom_cache_network_image.dart';
import 'package:flutter/material.dart';

class ScaleableImage extends StatelessWidget {
  const ScaleableImage({required this.imagePath, this.scaleFactor = 0.5, super.key});
  final String imagePath;
  final double scaleFactor;

  @override
  Widget build(BuildContext context) {
    final displayHeight = MediaQuery.of(context).size.height * scaleFactor;

    return Positioned(
      left: 0,
      right: 0,
      height: displayHeight,
      child: CustomCacheNetworkImage(
        imageUrl: imagePath,
        fit: BoxFit.cover,
        height: displayHeight,
      ),
    );
  }
}
