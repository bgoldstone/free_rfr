import 'dart:ui';

import 'package:material_ui/material_ui.dart';

class FreeRFRScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
