import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

class CustomCacheNetworkImage extends StatelessWidget {
  const CustomCacheNetworkImage({
    required this.imageUrl,
    super.key,
    this.width,
    this.height,
    this.fit,
    this.indicatorSize,
    this.color,
  });
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double? indicatorSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: CachedNetworkImageProvider(imageUrl),
      fit: fit ?? BoxFit.cover,
      width: width,
      height: height,
      color: color,
      gaplessPlayback: true,
    );
  }
}
