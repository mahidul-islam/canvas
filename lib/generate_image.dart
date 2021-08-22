import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:image_downloader/image_downloader.dart';

const kCanvasSize = 200.0;

class ImageGenerator extends StatefulWidget {
  final Random rd;
  final int numColors;

  ImageGenerator()
      : rd = Random(),
        numColors = Colors.primaries.length;

  @override
  _ImageGeneratorState createState() => _ImageGeneratorState();
}

class _ImageGeneratorState extends State<ImageGenerator> {
  ByteData? imgBytes;
  Random rd = Random(5);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: MaterialButton(
                    color: Colors.amber[50],
                    child: Text('Generate image'),
                    onPressed: generateImage),
              ),
              Visibility(
                visible: imgBytes != null &&
                    defaultTargetPlatform == TargetPlatform.android,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: MaterialButton(
                      color: Colors.amber[50],
                      child: Text('Download image'),
                      onPressed: saveImage),
                ),
              )
            ],
          ),
          imgBytes != null
              ? Center(
                  child: Image.memory(
                  Uint8List.view(imgBytes!.buffer),
                  width: kCanvasSize,
                  height: kCanvasSize,
                ))
              : Container()
        ],
      ),
    );
  }

  Future<void> saveImage() async {
    final directoryName = "Generated";
    final fileName = 'hello' + rd.nextInt(1000).toString();

    Directory? directory = await getExternalStorageDirectory();
    // Directory? directory = await getTemporaryDirectory();
    String path = directory!.path;
    await Directory('$path/$directoryName').create(recursive: true);

    print('$path/$directoryName/$fileName.png');

    File('$path/$directoryName/$fileName.png')
        .writeAsBytesSync(imgBytes!.buffer.asInt8List());

    // await requestPermissions([PermissionGroup.storage]);
    // await GallerySaver.saveImage('$path/$directoryName/$fileName.png');
  }

  void generateImage() async {
    final color = Colors.primaries[widget.rd.nextInt(widget.numColors)];

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder,
        Rect.fromPoints(Offset(0.0, 0.0), Offset(kCanvasSize, kCanvasSize)));

    final stroke = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke;

    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, kCanvasSize, kCanvasSize), stroke);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
        Offset(
          widget.rd.nextDouble() * kCanvasSize,
          widget.rd.nextDouble() * kCanvasSize,
        ),
        20.0,
        paint);

    final picture = recorder.endRecording();
    final img = await picture.toImage(200, 200);
    final pngBytes = await img.toByteData(format: ui.ImageByteFormat.png);

    setState(() {
      imgBytes = pngBytes!;
    });
  }
}
