import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/application/network_time/network_time_provider.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

class RestartableApp extends StatefulWidget {
  const RestartableApp({required this.child, super.key});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartableAppState>()?.restartApp();
  }

  @override
  State<RestartableApp> createState() => _RestartableAppState();
}

class _RestartableAppState extends State<RestartableApp> {
  Key key = UniqueKey();

  void restartApp() => setState(() => key = UniqueKey());

  @override
  Widget build(BuildContext context) {
    return Provider<NetworkTimeProvider>(
      create: (_) => getIt<NetworkTimeProvider>(),
      child: KeyedSubtree(key: key, child: widget.child),
    );
  }
}
