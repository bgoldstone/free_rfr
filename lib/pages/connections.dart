import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Connections extends StatefulWidget {
  final Function(Map<String, dynamic> activeConnection) setActiveConnection;
  const Connections(this.setActiveConnection, {super.key});

  @override
  State<Connections> createState() => _ConnectionsState();
}

class _ConnectionsState extends State<Connections> {
  Map<String, dynamic> config = {
    "connections": [
      {'name': 'Free RFR', 'ip': '192.168.1.1'}
    ]
  };

  final String configFile = 'free_rfr.json';
  int currentConnection = -1;
  Directory path = Directory('');

  @override
  void initState() {
    super.initState();
  }

  Future<bool> getConfig() async {
    path = await getApplicationDocumentsDirectory();
    if (!path.existsSync()) {
      path.createSync(recursive: true);
    }
    File file = File('${path.path}/$configFile');
    if (!file.existsSync()) {
      file.createSync();
      file.writeAsString(jsonEncode(config), encoding: utf8);
      return false;
    }
    file.readAsString(encoding: utf8).then((data) {
      config = jsonDecode(data);
    });
    return true;
  }

  void saveConnections() {
    File file = File('${path.path}/$configFile');
    file.writeAsString(jsonEncode(config), encoding: utf8);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getConfig(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  showDialog(context: context, builder: createConnection);
                },
                tooltip: 'Add Connection',
                backgroundColor: Colors.black,
                child: Icon(
                  Icons.add,
                  color: Theme.of(context).primaryColor,
                  size: 30,
                ),
              ),
              body: ListView.builder(
                  itemCount: config.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(config['connections'][index]['name']),
                        subtitle: Text(config['connections'][index]['ip']),
                        onTap: () {
                          setState(() {
                            widget.setActiveConnection(
                                config['connections'][index]);
                            if (currentConnection != index) {
                              currentConnection = index;
                            } else {
                              currentConnection = -1;
                            }
                          });
                        },
                        tileColor: index == currentConnection
                            ? Colors.blueGrey
                            : Colors.grey,
                      ),
                    );
                  }),
            );
          }
        });
  }

  AlertDialog createConnection(BuildContext context) {
    String consoleName = '';
    String consoleIP = '';
    return AlertDialog(
      title: const Text('Add Connection'),
      content: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Console Name',
            ),
            onChanged: (value) {
              consoleName = value;
            },
          ),
          TextField(
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Console IP',
            ),
            onChanged: (value) {
              consoleIP = value;
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {
              config['connections'].add({'name': consoleName, 'ip': consoleIP})[
                  'connections']({'name': consoleName, 'ip': consoleIP});
              saveConnections();
            });
          },
          child: const Text('Add'),
        )
      ],
    );
  }
}
