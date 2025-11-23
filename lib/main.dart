import 'package:daily_tarot_focus/config/env.config.dart';
import 'package:daily_tarot_focus/setup_bindings.dart';
import 'package:flutter/material.dart';
import 'package:mobile_core/core_app.dart';
import 'package:daily_tarot_focus/config/app_config.dart';
import 'package:daily_tarot_focus/restartable_app.dart';
import 'package:daily_tarot_focus/setup_dependieces.dart';
import 'package:daily_tarot_focus/lyrics_app.dart';

Future<void> main() async {
  await EnvConfig.load();
  setupBindings();
  await setupCoreApp(LyricsAppConfig());
  await setupDependencies();
  runApp(RestartableApp(child: const LyricsApp()));
}
