import 'package:daily_tarot_focus/config/app_config.dart';
import 'package:daily_tarot_focus/config/env.config.dart';
import 'package:daily_tarot_focus/config/restartable_app.dart';
import 'package:daily_tarot_focus/config/setup_bindings.dart';
import 'package:daily_tarot_focus/config/setup_dependieces.dart';
import 'package:daily_tarot_focus/config/setup_firebase.dart';
import 'package:daily_tarot_focus/tarot_app.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/core_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.load();
  await setupBindings();
  await setupCoreApp(TarotAppConfig());
  await setupFirebase();
  await setupDependencies();
  runApp(const RestartableApp(child: TarotApp()));
}
