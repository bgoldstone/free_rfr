import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:free_rfr/configurations/context.dart';
import 'package:osc/osc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/button.dart';

class Connections extends StatefulWidget {
  final void Function(
          Map<String, dynamic> activeConnection, int index, FreeRFRContext ctx)
      setActiveConnection;
  final int currentConnectionIndex;
  const Connections(this.setActiveConnection,
      {super.key, required this.currentConnectionIndex});

  @override
  State<Connections> createState() => _ConnectionsState();
}

class _ConnectionsState extends State<Connections> {
  Map<String, dynamic> config = {"connections": []};

  final String configFile = 'free_rfr.json';
  Directory path = Directory('');
  int listLength = 0;
  TextEditingController userIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userIdController.text = '0';
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
      setState(() {
        config = config;
      });
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
      appBar: AppBar(
        title: const Text('Free RFR'),
        actions: [
          donateButton(context),
          IconButton(
            icon: const Icon(Icons.help),
            onPressed: showHelpDialog,
            tooltip: 'Help',
          )
        ],
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
      body: Column(
        children: [
          Button("start server", () {
            OSCSocket socket = OSCSocket(
              serverAddress: InternetAddress("0.0.0.0"),
              serverPort: 8000,
            );
            socket.listen((OSCMessage message) {
              debugPrint("Message received: ${message.address}");
            });
          }),
          Expanded(
            child: connectionsList(context.read<FreeRFRContext>()),
          )
        ],
      ),
    );
  }

  void showHelpDialog() async {
    Image helpImage = Image.asset('assets/osc_config.png');
    AlertDialog helpDialog = AlertDialog(
      title: const Text('Help'),
      content: Column(children: [
        const Text(
            "Please Configure your Eos Console OSC Settings Like the image below:"),
        FittedBox(
          fit: BoxFit.contain,
          child: helpImage,
        )
      ]),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
    showDialog(context: context, builder: (context) => helpDialog);
  }

  FutureBuilder connectionsList(FreeRFRContext ctx) {
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
                        subtitle: Text("""
                            Host: ${config['connections'][index]['ip']}
                            User ID: ${config['connections'][index]['userId']}"""),
                        onTap: () {
                          if (currentConnection != index) {
                            currentConnection = index;
                          } else {
                            currentConnection = -1;
                          }
                          widget.setActiveConnection(
                              config['connections'][index],
                              currentConnection,
                              ctx);
                          Navigator.of(context).pushNamed('/home');
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
            return const Center(child: Text('No Connections'));
          }
        });
  }

  AlertDialog createConnection(BuildContext context) {
    String consoleName = '';
    String consoleIP = '';
    int userId = 0;

    return AlertDialog(
      title: const Text('Add Connection'),
      content: Column(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Console Name',
              ),
              onChanged: (value) {
                consoleName = value;
              },
            ),
          ),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Console IP',
              ),
              onChanged: (value) {
                consoleIP = value;
              },
              keyboardType: TextInputType.text,
            ),
          ),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'User ID',
              ),
              controller: userIdController,
              onChanged: (value) {
                try {
                  userId = int.parse(value).abs();
                  userIdController.text = userId.toString();
                } catch (e) {
                  userId = 0;
                }
                userIdController.text = userId.toString();
              },
              keyboardType: TextInputType.number,
            ),
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
            config['connections']
                .add({'name': consoleName, 'ip': consoleIP, 'userId': userId});
            saveConnections();
            setState(() {});
          },
          child: const Text('Add'),
        )
      ],
    );
  }
}

IconButton donateButton(BuildContext context) {
  return IconButton(
    onPressed: () {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Donate'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Like What I do? Please consider making a donation!",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        icon: const FaIcon(FontAwesomeIcons.paypal),
                        onPressed: () => launchUrl(
                            Uri.parse("https://paypal.me/BenjaminGoldstone")),
                        tooltip: 'Paypal',
                        iconSize: 100,
                        color: Colors.blue[900]),
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.vimeo),
                      onPressed: () => launchUrl(
                          Uri.parse("https://www.venmo.com/bgoldstone")),
                      tooltip: 'Venmo',
                      iconSize: 100,
                      color: Colors.blue,
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                      child: const Text('OK'),
                      onPressed: () => Navigator.of(context).pop())
                ],
              ));
    },
    icon: const Icon(Icons.monetization_on),
    tooltip: 'Donate',
  );
}
