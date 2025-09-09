import 'package:flutter/material.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/widgets/grid.dart';
import 'package:provider/provider.dart';

class DirectSelects extends StatelessWidget {
  final OSC osc;
  const DirectSelects({super.key, required this.osc});

  @override
  Widget build(BuildContext context) {
    final ctx = context.watch<FreeRFRContext>();
    return Column(
      children: [
        // Top pane: row of buttons
        Container(
          height: 80, // adjust as needed
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: () {}, child: Text('Btn 1')),
              ElevatedButton(onPressed: () {}, child: Text('Btn 2')),
              ElevatedButton(onPressed: () {}, child: Text('Btn 3')),
            ],
          ),
        ),

        // Bottom row
        Expanded(
          child: Row(
            children: [
              // Bottom left: grid of buttons
              Expanded(
                flex: 3, // makes it wider
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: GridView.count(
                      crossAxisCount: 3, // 3 columns
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 1,
                      children: [
                        Text("DS 1"),
                        Text("DS 2"),
                        Text("DS 3"),
                      ]),
                ),
              ),

              // Bottom right: up/down arrows
              Expanded(
                flex: 1, // narrower
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_upward),
                        iconSize: 75,
                        tooltip: "Page Up",
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 75,
                        tooltip: "Page Down",
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
