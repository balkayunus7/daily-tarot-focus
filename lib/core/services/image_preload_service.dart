import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImagePreloadService {
  ImagePreloadService._();
  static final instance = ImagePreloadService._();

  final ValueNotifier<double> progress = ValueNotifier(0);

  bool _hasStarted = false;
  bool get hasStarted => _hasStarted;
  bool get isCompleted => progress.value >= 1.0;

  Future<void> preload(List<String> urls) async {
    if (_hasStarted) return;
    final filtered = urls.where((u) => u.isNotEmpty).toList();
    if (filtered.isEmpty) return;
    _hasStarted = true;
    await _run(filtered);
  }

  Future<void> _run(List<String> urls) async {
    var completed = 0;
    const batchSize = 5;

    for (var i = 0; i < urls.length; i += batchSize) {
      final batch = urls.skip(i).take(batchSize).toList();
      await Future.wait(
        batch.map(
          (url) => DefaultCacheManager()
              .getSingleFile(url)
              .then((_) {
                completed++;
                progress.value = completed / urls.length;
              })
              .catchError((_) {
                completed++;
                progress.value = completed / urls.length;
              }),
        ),
      );
    }
  }

  Future<void> waitForCompletion() {
    if (isCompleted) return Future.value();
    final completer = Completer<void>();
    void listener() {
      if (progress.value >= 1.0) {
        progress.removeListener(listener);
        completer.complete();
      }
    }

    progress.addListener(listener);
    return completer.future;
  }
}
