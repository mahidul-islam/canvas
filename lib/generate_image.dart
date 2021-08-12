import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:path_provider/path_provider.dart';

import 'package:image_downloader/image_downloader.dart';

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
                visible: imgBytes != null,
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
    final fileName = 'hello';

    Directory? directory = await getExternalStorageDirectory();
    String path = directory!.path;
    await Directory('$path/$directoryName').create(recursive: true);

    File('$path/$directoryName/$fileName.png')
        .writeAsBytesSync(imgBytes!.buffer.asInt8List());
  }

  // void downLoadImage() async {
  //   try {
  //     // showLoadingDialog(context);
  //     // Saved with this method.
  //     var imageId = await ImageDownloader.downloadImage(
  //         "https://raw.githubusercontent.com/wiki/ko2ic/image_downloader/images/bigsize.jpg");
  //     if (imageId == null) {
  //       return;
  //     }

  //     //
  //     var documentDirectory = await getApplicationDocumentsDirectory();
  //     var firstPath = documentDirectory.path + "/images";
  //     var filePathAndName = documentDirectory.path + '/images/pic.jpg';
  //     //comment out the next three lines to prevent the image from being saved
  //     //to the device to show that it's coming from the internet
  //     await Directory(firstPath).create(recursive: true); // <-- 1
  //     File file2 = new File(filePathAndName); // <-- 2
  //     file2.writeAsBytesSync(imgBytes!.buffer); // <-- 3
  //     setState(() {
  //       imageData = filePathAndName;
  //       dataLoaded = true;
  //     });
  //     //

  //     // Below is a method of obtaining saved image information.
  //     var fileName = await ImageDownloader.findName(imageId);
  //     var path = await ImageDownloader.findPath(imageId);
  //     var size = await ImageDownloader.findByteSize(imageId);
  //     var mimeType = await ImageDownloader.findMimeType(imageId);
  //     Navigator.pop(context);
  //     // showToast('Image downloaded.');
  //   } on PlatformException catch (error) {
  //     print(error);
  //   }
  // }

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
    final pngBytes = await img.toByteData(format: ImageByteFormat.png);

    setState(() {
      imgBytes = pngBytes!;
    });
  }
}
