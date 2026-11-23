import 'package:material_ui/material_ui.dart';

class Button extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final double padding;
  final bool isSelected;
  final Function()? onLongPress;

  const Button(this.text, this.onPressed,
      {super.key,
      this.padding = 8.0,
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
    );
    return Padding(
      padding: EdgeInsets.all(padding),
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
