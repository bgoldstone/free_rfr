import 'package:flutter/material.dart';

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
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.yellow : Colors.white,
            fontWeight: FontWeight.bold,
            // fontSize: (fontSize! * aspectRatio),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
