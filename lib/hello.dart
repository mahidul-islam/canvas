// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:ui' as ui;

// class ImageInsideCanvasPage extends StatefulWidget {
//   @override
//   _ImageInsideCanvasPageState createState() => _ImageInsideCanvasPageState();
// }

// class _ImageInsideCanvasPageState extends State<ImageInsideCanvasPage> {
//   ui.Image? image;

//   @override
//   void initState() {
//     // Add your own asset image link
//     _load('assets/img.png');
//     super.initState();
//   }

//   void _load(String path) async {
//     var bytes = await rootBundle.load(path);
//     image = await decodeImageFromList(bytes.buffer.asUint8List());
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           child: CustomPaint(
//             painter: ImageInsideCanvas(image: image),
//             child: SizedBox.expand(),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ImageInsideCanvas extends CustomPainter {
//   ImageInsideCanvas({required this.image});
//   ui.Image? image;

//   @override
//   void paint(Canvas canvas, Size size) async {
//     Paint greenBrush = Paint()..color = Colors.greenAccent;
//     canvas.save();
//     canvas.drawImage(image!, Offset(0, 0), greenBrush);
//     canvas.restore();
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }
