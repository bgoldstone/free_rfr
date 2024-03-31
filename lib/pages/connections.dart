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
  Map<String, dynamic> config = {"connections": []};

  final String configFile = 'free_rfr.json';
  int currentConnection = -1;
  Directory path = Directory('');
  int listLength = 0;

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
    getConfig();
  }

  @override
  Widget build(BuildContext context) {
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
      body: connectionsList(),
    );
  }

  FutureBuilder connectionsList() {
    debugPrint(config.toString());
    final Future<bool> didGetConfig = getConfig();
    return FutureBuilder(
        future: didGetConfig,
        builder: (context, snapshot) {
          debugPrint(snapshot.data.toString());
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (config['connections'].length > 0) {
            return ListView.builder(
                itemCount: config['connections'].length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key('Connection ${index}'),
                    child: Card(
                      child: ListTile(
                        title: Text(config['connections'][index]['name']),
                        subtitle: Text(config['connections'][index]['ip']),
                        onTap: () {
                          widget.setActiveConnection(
                              config['connections'][index]);
                          if (currentConnection != index) {
                            currentConnection = index;
                          } else {
                            currentConnection = -1;
                          }
                        },
                        tileColor: index == currentConnection
                            ? Colors.blueGrey
                            : Colors.grey,
                      ),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        config['connections'].removeAt(index);
                        saveConnections();
                      });
                    },
                  );
                });
          } else {
            return Center(child: Text('No Connections'));
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
            config['connections'].add({'name': consoleName, 'ip': consoleIP});
            saveConnections();
            setState(() {});
          },
          child: const Text('Add'),
        )
      ],
    );
  }
}