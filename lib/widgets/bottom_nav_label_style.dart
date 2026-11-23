import 'package:material_ui/material_ui.dart';

TextStyle bottomNavLabelStyle(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  return TextStyle(
    fontSize: width < 600
        ? 10
        : width < 1000
            ? 12
            : 14,
  );
}
