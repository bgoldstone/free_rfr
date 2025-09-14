import 'package:flutter/material.dart';

Future<void> ignoreErrors() async {
  FlutterError.onError = (
    FlutterErrorDetails? details, {
    bool forceReport = false,
  }) {
    assert(details != null);
    assert(details?.exception != null);
    // ---

    bool ifIsOverflowError = false;

    // Detect overflow error.
    var exception = details?.exception;
    if (exception is FlutterError) {
      ifIsOverflowError = !exception.diagnostics.any(
          (e) => e.value.toString().startsWith("A RenderFlex overflowed by"));
    }

    // Ignore if is overflow error.
    if (ifIsOverflowError) {
      debugPrint('Overflow error.');
    } else {
      FlutterError.dumpErrorToConsole(details!, forceReport: forceReport);
    }
  };
}
