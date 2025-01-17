import 'package:flutter/material.dart';

class Grid extends StatelessWidget {
  final int columns;
  final List<Widget> children;
  final double scale;
  const Grid(this.columns, this.children, this.scale, {super.key});

  @override
  Widget build(BuildContext context) {
    return GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          childAspectRatio: MediaQuery.of(context).size.aspectRatio * 2),
      children: children,
    );
  }
}
