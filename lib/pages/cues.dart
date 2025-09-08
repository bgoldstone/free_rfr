import 'package:flutter/material.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:free_rfr/objects/osc_control.dart';
import 'package:provider/provider.dart';

class Cues extends StatelessWidget {
  final OSC osc;
  const Cues({required this.osc, super.key});

  @override
  Widget build(BuildContext context) {
    final ctx = context.watch<FreeRFRContext>();
    const currentCueStyle = TextStyle(fontWeight: FontWeight.bold);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Text(
            'Cue List: ${ctx.currentCueList}',
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
                title: const Text('Previous Cue'),
                subtitle: Text(ctx.previousCueText),
                onLongPress: () {
                  editLabel(context, ctx.previousCue);
                }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            color: Theme.of(context).secondaryHeaderColor,
            child: ListTile(
              title: const Text(
                'Current Cue',
                style: currentCueStyle,
              ),
              subtitle: Text(
                ctx.currentCueText,
                style: currentCueStyle,
              ),
              onLongPress: () {
                editLabel(context, ctx.currentCue);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
              title: const Text('Next Cue'),
              subtitle: Text(ctx.nextCueText),
              onLongPress: () {
                editLabel(context, ctx.nextCue);
              },
            ),
          ),
        ),
        Wrap(
          alignment: WrapAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () => osc.sendKey('stop'),
                  onLongPress: () {
                    editLabel(context, ctx.previousCue);
                  },
                  style: const ButtonStyle(
                      foregroundColor:
                          WidgetStatePropertyAll<Color>(Colors.red)),
                  child: const Text('Stop/Back')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () => osc.sendKey('go_0'),
                  style: const ButtonStyle(
                      foregroundColor:
                          WidgetStatePropertyAll<Color>(Colors.green)),
                  child: const Text('Go')),
            ),
          ],
        ),
      ],
    );
  }

  void editLabel(BuildContext context, double cueNumber) {
    String text = '';
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Modify Cue'),
            content: TextField(
                decoration: const InputDecoration(label: Text('New Label')),
                onChanged: (newText) => text = newText),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Ok'),
                onPressed: () {
                  osc.setLabel(cueNumber, text);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}

class Cue {
  final OSC osc;
  final String name;
  final String label;
  final double cueNumber;
  final String scene;
  const Cue(this.osc, this.name, this.cueNumber,
      {this.label = '', this.scene = ''});
}
