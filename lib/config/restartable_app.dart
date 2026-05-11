import 'package:daily_tarot_focus/config/setup_dependieces.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/application/network_time/network_time_provider.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

class RestartableApp extends StatefulWidget {
  const RestartableApp({required this.child, super.key});
  final Widget child;

  static Future<void> restartApp(BuildContext context) async {
    await context.findAncestorStateOfType<_RestartableAppState>()?.restartApp();
  }

  @override
  State<RestartableApp> createState() => _RestartableAppState();
}

class _RestartableAppState extends State<RestartableApp> {
  Key key = UniqueKey();

  Future<void> restartApp() async {
    await getIt.reset();
    await setupDependencies();
    await EasyLocalization.ensureInitialized();
    if (!mounted) return;
    setState(() => key = UniqueKey());
  }

  @override
  Widget build(BuildContext context) {
    return Provider<NetworkTimeProvider>(
      create: (_) => getIt<NetworkTimeProvider>(),
      child: KeyedSubtree(key: key, child: widget.child),
    );
  }
}
