import 'package:flutter/material.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/widgets/button.dart';
import 'package:free_rfr/widgets/grid.dart';
import 'package:osc/osc.dart';
import 'package:provider/provider.dart';

class DirectSelects extends StatefulWidget {
  final OSC osc;
  static const int pageSize = 16;
  //ID, Display Name
  static const Map<String, String> dsTypes = {
    'chan': 'Channels',
    'group': 'Groups',
    'macro': 'Macros',
    'preset': 'Presets',
    'ip': 'Intensity Palettes',
    'fp': 'Focus Palettes',
    'cp': 'Color Palettes',
    'bp': 'Beam Palettes',
    'curve': 'Curves',
    'snap': 'Snapshots',
    'fx': 'Effects',
    'pixmap': 'Pixel Maps',
    'scene': 'Scenes'
  };
  const DirectSelects({super.key, required this.osc});

  @override
  State<DirectSelects> createState() => _DirectSelectsState();
}

class _DirectSelectsState extends State<DirectSelects> {
  String type = 'group';
  int page = 1;

  @override
  void initState() {
    super.initState();
    callDS(context.read<FreeRFRContext>());
  }

  void callDS(FreeRFRContext ctx) {
    ctx.directSelects.clear();
    widget.osc.sendOSCMessage(OSCMessage(
        '/eos/ds/1/$type/flexi/$page/${DirectSelects.pageSize}',
        arguments: []));
  }

  @override
  Widget build(BuildContext context) {
    final ctx = context.watch<FreeRFRContext>();

    return Column(
      children: [
        // Top pane: row of buttons
        Expanded(
          child: Grid(
              5,
              DirectSelects.dsTypes.entries.map((entry) {
                return Button(
                  entry.value,
                  () {
                    setState(() {
                      type = entry.key;
                      page = 1;
                      callDS(ctx);
                    });
                  },
                  fontSize: 10,
                  isSelected: type == entry.key,
                );
              }).toList(),
              2.2),
        ),

        // Bottom row
        Expanded(
          child: Row(
            children: [
              // Bottom left: grid of buttons
              Expanded(
                flex: 3, // makes it wider
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Grid(
                      4,
                      ctx.directSelects.entries.map((ds) {
                        return Button(
                          "${ds.value.name} (${ds.value.objectNumber})",
                          () {
                            widget.osc.sendOSCMessage(OSCMessage(
                                '/eos/ds/1/${ds.key}',
                                arguments: [1]));
                            // callDS(ctx);
                          },
                          fontSize:
                              5 * MediaQuery.of(context).size.aspectRatio / 2,
                        );
                      }).toList(),
                      4),
                ),
              ),

              // Bottom right: up/down arrows
              Expanded(
                flex: 1, // narrower
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (page > 1) {
                          setState(() {
                            page--;
                            callDS(ctx);
                          });
                        }
                      },
                      icon: const Icon(Icons.arrow_upward),
                      iconSize: 75,
                      tooltip: "Page Up",
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Page: $page"),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          page++;
                          callDS(ctx);
                        });
                      },
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 75,
                      tooltip: "Page Down",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
