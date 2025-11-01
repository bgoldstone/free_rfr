import 'package:flutter/material.dart';

class Grid extends StatelessWidget {
  final int columns;
  final List<Widget> children;
  final double scale; // for padding between cells

  const Grid(
    this.columns,
    this.children, {
    this.scale = 8.0,
    super.key,
  });

  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        if (children.isEmpty) {
          return SizedBox.shrink();
        }
        // Compute number of rows based on how many items and columns
        final rows = (children.length / columns).ceil();

        // Subtract spacing so we can divide evenly
        final totalHorizontalSpacing = (columns - 1) * scale;
        final totalVerticalSpacing = (rows - 1) * scale;

        final itemWidth = (width - totalHorizontalSpacing) / columns;
        final itemHeight = (height - totalVerticalSpacing) / rows;

        final aspectRatio = itemWidth / itemHeight;

        return GridView.count(
          crossAxisCount: columns,
          mainAxisSpacing: scale,
          crossAxisSpacing: scale,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          childAspectRatio: aspectRatio,
          children: children,
        );
      },
    );
  }
}
