import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:free_rfr/helpers/discovery.dart';
import 'package:path_provider/path_provider.dart';

class Connections extends StatefulWidget {
  final void Function(Map<String, dynamic> activeConnection, int index)
      setActiveConnection;
  final int currentConnectionIndex;
  // ignore: prefer_const_constructors_in_immutables
  Connections(this.setActiveConnection,
      {super.key, required this.currentConnectionIndex});

  @override
  State<Connections> createState() => _ConnectionsState();
}

class _ConnectionsState extends State<Connections> {
  Map<String, dynamic> config = {"connections": []};

  final String configFile = 'free_rfr.json';
  Directory path = Directory('');
  int listLength = 0;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> getConfig() async {
    path = await getApplicationDocumentsDirectory();
    final newPath = Directory('${path.path}/FreeRFR');
    if (!newPath.existsSync()) {
      newPath.createSync(recursive: true);
    }
    File file = File('${newPath.path}/$configFile');
    if (!file.existsSync()) {
      file.createSync();
      file.writeAsString(jsonEncode(config), encoding: utf8);
      return false;
    }
    file.readAsString(encoding: utf8).then((data) {
      config = jsonDecode(data);
    });

    List<String>? discoveredHosts = await getHosts();

    for (String ip in discoveredHosts) {
      debugPrint("Found discovered host: $ip");
      InternetAddress host = await InternetAddress(ip).reverse();
      bool exists = false;
      for (Map<String, dynamic> connection in config['connections']) {
        if (connection['ip'] == host.host) {
          exists = true;
        }
      }
      if (!exists) {
        config['connections'].add({
          'name': '${host.host} (Auto Discovery)',
          'ip': ip,
        });
      }
    }

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
      appBar: AppBar(
        title: const Text('Free RFR'),
      ),
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
    final Future<bool> configRetrival = getConfig();
    int currentConnection = widget.currentConnectionIndex;
    return FutureBuilder(
        future: configRetrival,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (config['connections'].length > 0) {
            return ListView.builder(
                itemCount: config['connections'].length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key('Connection $index'),
                    child: Card(
                      child: ListTile(
                        title: Text(config['connections'][index]['name']),
                        subtitle: Text(config['connections'][index]['ip']),
                        onTap: () {
                          if (currentConnection != index) {
                            currentConnection = index;
                          } else {
                            currentConnection = -1;
                          }
                          widget.setActiveConnection(
                              config['connections'][index], currentConnection);
                          Navigator.of(context).pushNamed('/home');
                        },
                        tileColor: Colors.grey,
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
            return const Center(child: Text('No Connections'));
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
            keyboardType: TextInputType.number,
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
