import 'package:flutter/material.dart';
import 'package:free_rfr/pages/facepanel.dart';

class FreeRFR extends StatefulWidget {
  const FreeRFR({super.key});

  @override
  State<FreeRFR> createState() => _FreeRFRState();
}

class _FreeRFRState extends State<FreeRFR> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = const [
      FacePanel(key: Key('Facepanel')),
      Placeholder(),
      Placeholder(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Free RFR',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: pages.isEmpty ? const CircularProgressIndicator() : pages[index],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.keyboard), label: 'Facepanel'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Controls'),
          BottomNavigationBarItem(
              icon: Icon(Icons.list_alt), label: 'Cue List'),
        ],
        selectedItemColor: Colors.yellow,
        currentIndex: index,
        unselectedItemColor:
            MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.white
                : Colors.black,
        onTap: (i) => setState(() {
          index = i;
          debugPrint('index: $index');
        }),
      ),
    );
  }
}
