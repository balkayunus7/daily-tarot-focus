import 'package:flutter/material.dart';
import 'package:mobile_core/application/network_time/network_time_provider.dart';
import 'package:mobile_core/common_dependencies.dart';

class RestartableApp extends StatefulWidget {
  const RestartableApp({super.key, required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartableAppState>()?.restartApp();
  }

  @override
  // ignore: library_private_types_in_public_api
  _RestartableAppState createState() => _RestartableAppState();
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
