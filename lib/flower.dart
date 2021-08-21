import 'package:flutter/material.dart';
import 'dart:math';

const kCanvasSize = 300.0;

class FlowerPage extends StatefulWidget {
  const FlowerPage({Key? key}) : super(key: key);

  @override
  _FlowerPageState createState() => _FlowerPageState();
}

class _FlowerPageState extends State<FlowerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: kCanvasSize,
          width: kCanvasSize,
          child: CustomPaint(
            child: Container(),
            painter: RectangularFlowerPainter(),
          ),
        ),
      ),
    );
  }
}

class RectangularFlowerPainter extends CustomPainter {
  Paint green_paint = Paint()..color = Color(0xff00ff00);
  Paint yellow_paint = Paint()..color = Color(0xffebe834);
  Paint white_paint = Paint()..color = Color(0xffFFFFFF);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), white_paint);

    canvas.translate(0, 300);
    // Draw stem
    Rect stem = Rect.fromLTWH(100, 0, 10, 200);
    canvas.drawRect(stem, green_paint);

    // Draw rotated leaf
    canvas.save();
    canvas.translate(110, 100);
    canvas.rotate(135 * pi / 180);
    Rect leaf1 = Rect.fromLTWH(0, 0, 40, 40);
    canvas.drawRect(leaf1, green_paint);

    canvas.restore();

    // Draw rotated leaf
    canvas.save();
    canvas.translate(100, 150);
    canvas.rotate(315 * pi / 180);

    canvas.drawRect(leaf1, green_paint);
    canvas.restore();

    // Draw petals
    canvas.save();
    canvas.translate(100, 0);
    int petalsCount = 20;
    Rect petal = Rect.fromLTWH(0, 0, 40, 40);
    for (int i = 0; i < petalsCount; i++) {
      canvas.save();
      canvas.rotate((360.0 * i / petalsCount) * pi / 180);
      canvas.drawRect(petal, yellow_paint);
      canvas.restore();
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
