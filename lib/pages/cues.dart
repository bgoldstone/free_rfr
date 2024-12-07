import 'package:flutter/material.dart';
import 'package:free_rfr/objects/osc_control.dart';

class Cues extends StatefulWidget {
  final OSC osc;
  final double previousCue;
  final double currentCue;
  final double nextCue;
  final int currentCueList;
  final String previousCueText;
  final String currentCueText;
  final String nextCueText;
  const Cues(
      {required this.osc,
      super.key,
      required this.previousCue,
      required this.currentCue,
      required this.nextCue,
      required this.previousCueText,
      required this.currentCueText,
      required this.nextCueText,
      required this.currentCueList});

  @override
  State<Cues> createState() => _CuesState();
}

class _CuesState extends State<Cues> {
  List<Cue> cueList = [];
  int currentCue = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Text(
            'Cue List: ${widget.currentCueList}',
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
              title: const Text('Current Cue'),
              subtitle: Text(widget.currentCueText),
              onTap: () {
                editLabel(context, widget.nextCue);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
              title: const Text('Next Cue'),
              subtitle: Text(widget.nextCueText),
              onTap: () {
                editLabel(context, widget.nextCue);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: ListTile(
                title: const Text('Previous Cue'),
                subtitle: Text(widget.previousCueText),
                onTap: () {
                  editLabel(context, widget.previousCue);
                }),
          ),
        ),
        Wrap(
          alignment: WrapAlignment.spaceAround,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () => widget.osc.sendKey('stop'),
                  onLongPress: () {
                    editLabel(context, widget.previousCue);
                  },
                  style: const ButtonStyle(
                      foregroundColor:
                          WidgetStatePropertyAll<Color>(Colors.red)),
                  child: const Text('Stop/Back')),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () => widget.osc.sendKey('go_0'),
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
                  widget.osc.setLabel(cueNumber, text);
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
