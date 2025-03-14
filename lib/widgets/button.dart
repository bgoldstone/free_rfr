import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final double? fontSize;
  final Color? color;

  const Button(this.text, this.onPressed, {super.key, this.fontSize = 20, this.color = Colors.blueGrey});

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      backgroundColor: color,
    );
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: (fontSize! * aspectRatio * 1.5),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
