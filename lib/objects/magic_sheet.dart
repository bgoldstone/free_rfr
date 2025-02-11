import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:charset/charset.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:free_rfr/extensions/Extensions.dart';
import 'package:free_rfr/free_rfr.dart';
import 'package:free_rfr/objects/parameters.dart';
import 'package:xml/xml.dart';

import '../widgets/button.dart';
import 'osc_control.dart';

abstract class MagicSheetObject {
  final String name;
  final String targetId;
  final String type;
  final double positionX;
  final double positionY;
  final double rotation;
  final String? svgObject;

  MagicSheetObject({
    required this.name,
    required this.targetId,
    required this.type,
    required this.positionX,
    required this.positionY,
    required this.rotation,
    required this.svgObject,
  });

  void function(MagicSheet sheet);
  void display();

  Widget getWidget(MagicSheet sheet) {
    if(svgObject == null) {
      return Container();
    }else {
      var target = int.parse(targetId);
      var svg = SvgPicture.asset(svgObject!, width: 50, height: 50, colorFilter: sheet.channels.where((e) => e.number == target).isNotEmpty ? ColorFilter.mode(sheet.channels.where((e) => e.number == target).first.constructColor(), BlendMode.srcIn): null,);
      return RotatedBox(quarterTurns: //rotation is in degree
        rotation.toInt() ~/ 90
        , child:
              GestureDetector(
                onTap: () {
                  function(sheet);
                },
                child: Container(
                  decoration: !sheet.osc.isChannelSelected(int.parse(targetId)) ? null: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: svg,
                )
        ));
    }

  }

  @override
  String toString() {
    return 'MagicSheetObject{name: $name, targetId: $targetId, type: $type, rotation: $rotation}';
  }

  static String findSvgObject(String targetId) {
    debugPrint("targetId: " + targetId);
   if(targetId.contains("/")) {
     targetId = targetId.split("/").last;
   }else {
      targetId = targetId.split("\\").last;
   }
    debugPrint("targetId: " + targetId);
    return "assets/symbols/"+targetId;
  }

  factory MagicSheetObject.fromXml(XmlElement element) {
    final key = element.getAttribute('KEY') ?? '';

    final targetId = element.firstElementChild?.findElements("MAGICSHEET").first.findElements('TARGET').first.getAttribute('TARGETID') ?? '';

    final positionX = double.parse(element.getAttribute('POSX') ?? "0") ;
    final positionY = double.parse(element.getAttribute('POSY') ?? "0");
    final rotation = double.parse(element.getAttribute('ROT') ?? '0');
    final String type = element.getAttribute('TYPE') ?? 'Symbol';
    String svgObject = '';
    if(element.firstElementChild!.findElements("IMG").isNotEmpty) {
      debugPrint(element.firstElementChild?.findElements("IMG").first.innerXml .toString());
      svgObject = element.firstElementChild?.findElements("IMG").first.innerXml ?? '';
    }


    if(key == 'Symbol') {
      return Symbol(
        name: key,
        targetId: targetId,
        type: 'Symbol',
        positionX: positionX,
        positionY: positionY,
        svgObject: findSvgObject(svgObject),
        rotation: rotation,
      );
    } else if(key == 'Clock') {
      return Clock(
        name: key,
        targetId: targetId,
        type: 'Clock',
        positionX: positionX,
        positionY: positionY,
        svgObject: findSvgObject(svgObject),
        rotation: rotation,
      );
    } else if(key == 'MacroButton') {
      return Macro(
        name: key,
        targetId: targetId,
        type: 'Macro',
        positionX: positionX,
        positionY: positionY,
        svgObject: findSvgObject(svgObject),
        rotation: rotation,
      );
    } else {
      throw Exception('Unknown type: $type');
    }
  }
}

class MagicSheet extends StatefulWidget{
  final List<MagicSheetObject> objects;
  final List<Channel> channels = [];
  MagicSheetState? state;
  final OSC osc;
  Size size = Size(0, 0);

  MagicSheet({required this.objects, required this.osc, super.key});

  @override
  State<StatefulWidget> createState()  => state = MagicSheetState();

  void update() {
    state?.update();
  }
}

class MagicSheetState extends State<MagicSheet> {

  void update() {
    if(!mounted) return;
    setState(() {});
  }

  @override
  void initState() {
    if(widget.channels.every((e) => e.color == null)) {
      widget.osc.getColorsForEveryChannel(widget.objects.map((e) => int.parse(e.targetId)).toList().reduce(max)).then((v) {
        update();
      });
    }
    if(widget.objects.any((element) => element is Clock)) {
      Timer.periodic(Duration(seconds: 1), (timer) {
        update();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
      return Stack(
        children: widget.objects.map((object) {
          return Positioned(
            left: object.positionX + widget.size.width / 3.5,
            top: object.positionY/2 + widget.size.height / 2,
            child: object.getWidget(widget),
          );
        }).toList(
      ),
    );
  }
}

class Symbol extends MagicSheetObject {
  Symbol({
    required String name,
    required String targetId,
    required String type,
    required double positionX,
    required double positionY,
    required double rotation,
    required String svgObject,
  }) : super(
    name: name,
    targetId: targetId,
    type: type,
    positionX: positionX,
    positionY: positionY,
    rotation: rotation,
    svgObject: svgObject,
  );

  @override
  void function(MagicSheet sheet) {
    var osc = sheet.osc;
    osc.sendKey("chan");
    osc.sendNumber(int.parse(targetId));
  }

  @override
  void display() {
    print('Displaying symbol');
  }
}

class Clock extends MagicSheetObject {
  Clock({
    required String name,
    required String targetId,
    required String type,
    required double positionX,
    required double positionY,
    required double rotation,
    required String svgObject,
  }) : super(
    name: name,
    targetId: targetId,
    type: type,
    positionX: positionX,
    positionY: positionY,
    rotation: rotation,
    svgObject: svgObject,
  );

  @override
  void function(MagicSheet sheet) {
    print('Clock function');
  }

  @override
  void display() {
    print('Displaying symbol');
  }

  Widget getWidget(MagicSheet sheet) {
    return Text(DateTime.now().toString());
  }
}

class Macro extends MagicSheetObject {
  Macro({
    required String name,
    required String targetId,
    required String type,
    required double positionX,
    required double positionY,
    required double rotation,
    required String svgObject,
  }) : super(
    name: name,
    targetId: targetId,
    type: type,
    positionX: positionX,
    positionY: positionY,
    rotation: rotation,
    svgObject: svgObject,
  );

  @override
  void function(MagicSheet sheet) {
    print('Macro function');
  }

  @override
  void display() {
    print('Displaying symbol');
  }

  @override
  Widget getWidget(MagicSheet sheet) {
    // TODO: implement getWidget
    return Container();
  }
}

List<MagicSheetObject> parseMagicSheet(XmlDocument document) {
  final items = document.findAllElements('ITEM');

  List<MagicSheetObject> magicSheetObjects = [];

  for (var item in items) {
    magicSheetObjects.add(MagicSheetObject.fromXml(
      item
    ));
    debugPrint('MagicSheetObject: ${magicSheetObjects.last}');
  }

  return magicSheetObjects;
}


class MagicSheetController extends StatefulWidget {
  final OSC osc;
  MagicSheetController({required this.osc, super.key});

  @override
  State<MagicSheetController> createState() => MagicSheetControllerState();
}

class MagicSheetControllerState extends State<MagicSheetController> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
        child: Column(
      children: [
        Button("test", () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles();
          if (result != null) {
            for (var f in result.files) {
              File file = File(f.path!);
              var data = utf16.decode(file.readAsBytesSync());
              XmlDocument document = XmlDocument.parse(data);
              FreeRFR.sheet = MagicSheet(objects: parseMagicSheet(document), osc: widget.osc,)..size = MediaQuery.sizeOf(context);;
              setState(() {

              });
            }
          }
        }),
        SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height * 0.8,
          child: FreeRFR.sheet == null ? Container() : FreeRFR.sheet!,
        )
      ],

    ));
  }
}