import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

Future<void> setupBindings() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  for (final renderView in binding.renderViews) {
    renderView.automaticSystemUiAdjustment = false;
  }
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );
}
