import 'package:flutter/material.dart';

class Grid extends StatelessWidget {
  final int crossAxisCount;
  final List<Widget> children;
  const Grid(this.crossAxisCount, this.children, {super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: MediaQuery.of(context).size.aspectRatio * 2,
      children: children,
    );
  }
}
