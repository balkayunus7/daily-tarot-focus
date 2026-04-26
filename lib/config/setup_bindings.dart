import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> setupBindings() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();

  for (final renderView in binding.renderViews) {
    renderView.automaticSystemUiAdjustment = false;
  }
  PaintingBinding.instance.imageCache.maximumSize = 2000;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 1024 * 1024 * 300;
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );
}
