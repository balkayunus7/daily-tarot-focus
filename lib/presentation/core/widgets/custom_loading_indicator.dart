import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mobile_core/presentation/extensions/build_context_theme_ext.dart';

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key, this.indicatorSize, this.color});
  final double? indicatorSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFadingCircle(
        color: color ?? context.colors.primary,
        size: indicatorSize ?? 48.0,
      ),
    );
  }
}
