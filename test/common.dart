import 'package:material_ui/material_ui.dart';

Future<void> ignoreErrors() async {
  FlutterError.onError = (
    FlutterErrorDetails? details, {
    bool forceReport = false,
  }) {
    assert(details != null);
    assert(details?.exception != null);

    final exception = details?.exception;
    var isOverflowError = false;
    if (exception is FlutterError) {
      isOverflowError = exception.diagnostics.any(
        (diagnostic) => diagnostic.value.toString().startsWith(
              'A RenderFlex overflowed by',
            ),
      );
    }

    if (!isOverflowError) {
      FlutterError.dumpErrorToConsole(details!, forceReport: forceReport);
    }
  };
}
