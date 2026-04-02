import 'package:flutter/material.dart';

class ScaleableImage extends StatelessWidget {
  const ScaleableImage({required this.imagePath, this.scaleFactor, super.key});
  final String imagePath;
  final double? scaleFactor;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      height: MediaQuery.of(context).size.height * (scaleFactor ?? 0.5),
      child: Image.asset(imagePath, fit: BoxFit.cover),
    );
  }
}
