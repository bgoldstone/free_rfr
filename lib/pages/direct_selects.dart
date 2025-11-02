import 'package:flutter/material.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:free_rfr/shortcuts.dart';
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
  //Initial State
  String type = 'group';
  int page = 1;

  @override
  void initState() {
    callDS(context.read<FreeRFRContext>());
    super.initState();
  }

  void callDS(FreeRFRContext ctx) async {
    await widget.osc.sendOSCMessage(OSCMessage(
        '/eos/ds/1/$type/flexi/$page/${DirectSelects.pageSize}',
        arguments: []));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ctx = context.watch<FreeRFRContext>();

    debugPrint("Direct Selects: ${ctx.directSelects}");

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
                      ctx.clearDirectSelects();
                      callDS(ctx);
                    });
                  },
                  padding: 1,
                  isSelected: type == entry.key,
                );
              }).toList(),
              scale: 2),
        ),

        // Bottom row
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bottom left: grid of buttons
              Expanded(
                flex: 3, // makes it wider
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Selector<FreeRFRContext, Map<int, DS>>(
                    selector: (_, ctx) => ctx.directSelects,
                    builder: (context, directSelects, _) {
                      return Grid(
                          4,
                          directSelects.entries.map((ds) {
                            var address = '/eos/ds/1/${ds.key}';
                            return Button(
                              "${ds.value.name}\n(${ds.value.objectNumber})",
                              () {
                                widget.osc.send(
                                  address,
                                  [1],
                                );
                                callDS(ctx);
                              },
                              padding: 2,
                              onLongPress: () {
                                if (type != 'chan') {
                                  showEditLabelDialog(
                                    context,
                                    type,
                                    ds.value.objectNumber.toString(),
                                    widget.osc,
                                  );
                                  callDS(ctx);
                                }
                              },
                            );
                          }).toList(),
                          scale: 2);
                    },
                  ),
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
                            ctx.clearDirectSelects();
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
                          ctx.clearDirectSelects();
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

  void showEditLabelDialog(
      BuildContext context, String dsType, String objectNumber, OSC osc) {
    String text = '';
    final ctx = context.read<FreeRFRContext>();
    unregisterHotKeys(context);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Edit Label'),
            content: TextField(
              onChanged: (value) {
                text = value;
              },
              decoration: const InputDecoration(hintText: "Enter new label"),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    ctx.hasHotKeyBeenUninitialized = true;
                    registerHotKeys(osc);
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    String? dsName = DirectSelects.dsTypes[dsType];
                    if (dsName == null) {
                      dsName = "";
                    } else {
                      //make singular and add space at end.
                      dsName = "${dsName.substring(0, dsName.length - 1)} ";
                    }
                    // strip trailing .0 from object number if present.
                    if (objectNumber.endsWith('.0')) {
                      objectNumber = objectNumber.split('.').first;
                    }
                    osc.send(
                        "/eos/newcmd", ["$dsName$objectNumber Label $text#"]);
                    ctx.hasHotKeyBeenUninitialized = true;
                    registerHotKeys(osc);
                    Navigator.pop(context);
                  },
                  child: const Text('OK')),
            ],
          );
        });
  }
}
