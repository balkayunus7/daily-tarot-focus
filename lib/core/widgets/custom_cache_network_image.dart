import 'package:daily_tarot_focus/core/widgets/custom_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

class CustomCacheNetworkImage extends StatelessWidget {
  const CustomCacheNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.indicatorSize,
  });
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final double? indicatorSize;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit ?? BoxFit.cover,
      width: width,
      height: height,
      placeholder: (context, url) {
        return CustomLoadingIndicator(indicatorSize: indicatorSize);
      },
      errorWidget: (context, url, error) {
        return Container(
          width: width,
          height: height,
          color: context.colors.background,
        );
      },
    );
  }
}
