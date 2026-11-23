import 'package:material_ui/material_ui.dart';

class Button extends StatelessWidget {
  static const _innerPadding = EdgeInsets.symmetric(horizontal: 4, vertical: 2);

  final Function() onPressed;
  final String text;
  final EdgeInsetsGeometry padding;
  final bool isSelected;
  final Function()? onLongPress;

  const Button(this.text, this.onPressed,
      {super.key,
      this.padding = const EdgeInsets.all(2),
      this.isSelected = false,
      this.onLongPress = null});

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? Colors.yellow : Colors.white;
    final labelStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ) ??
        TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        );
    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      backgroundColor: Colors.blueGrey,
      padding: _innerPadding,
      minimumSize: Size.zero,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
    return Padding(
      padding: padding,
      child: ElevatedButton(
        onPressed: onPressed,
        onLongPress: onLongPress == null ? () {} : onLongPress,
        style: buttonStyle,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            text,
            style: labelStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
