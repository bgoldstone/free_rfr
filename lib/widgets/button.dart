import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final double? fontSize;
  final double padding;

  const Button(this.text, this.onPressed,
      {super.key, this.fontSize = 20, this.padding = 8.0});

  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      backgroundColor: Colors.blueGrey,
    );
    double aspectRatio = MediaQuery.of(context).size.aspectRatio;
    return Padding(
      padding: EdgeInsets.all(padding),
      child: ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: (fontSize! * aspectRatio * 1),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
