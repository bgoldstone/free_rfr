import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function() onPressed;
  final String text;
  final double? fontSize;

  const Button(this.text, this.onPressed, {super.key, this.fontSize = 20});

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
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: buttonStyle,
        child: FittedBox(
          fit: BoxFit.fill,
          child: text.length > 10
              ? Column(
                  children: text
                      .split(' ')
                      .map(
                        (e) => Text(
                          e,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: (fontSize! * aspectRatio * 1.5)),
                          maxLines: null,
                        ),
                      )
                      .toList())
              : Text(
                  text,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: (fontSize! * aspectRatio * 1.5)),
                ),
        ),
      ),
    );
  }
}
