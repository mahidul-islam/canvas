import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';
import 'package:flutter/src/material/colors.dart' as Color;

class CustomPainterRotatble extends StatefulWidget {
  @override
  _CustomPainterRotatbleState createState() => _CustomPainterRotatbleState();
}

class _CustomPainterRotatbleState extends State<CustomPainterRotatble> {
  double _angle = 0.5;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {},
      onPanEnd: (details) {},
      onPanUpdate: (details) {},
      child: Container(
        color: Color.Colors.white,
        child: CustomPaint(
          child: Container(),
          painter: RectanglePainter(angle: _angle),
        ),
      ),
    );
  }
}

class RectanglePainter extends CustomPainter {
  final double angle;
  final Offset offset = Offset(50, 50);
  final Offset offset2 = Offset(50, 200);

  RectanglePainter({required this.angle});

  @override
  void paint(Canvas canvas, Size size) {
    final fill = TextPainter(
        text: TextSpan(
            text: 'This is a test',
            style: TextStyle(fontSize: 80, color: Color.Colors.blueAccent)),
        textDirection: TextDirection.rtl);

    fill.layout();
    canvas.save();
    final pivot = fill.size.center(offset);
    canvas.translate(pivot.dx, pivot.dy);
    canvas.rotate(angle);
    canvas.translate(-pivot.dx, -pivot.dy);
    fill.paint(canvas, offset);
    canvas.restore();

    final fill2 = TextPainter(
        text: TextSpan(
            text: 'This is a test',
            style: TextStyle(fontSize: 80, color: Color.Colors.blueAccent)),
        textDirection: TextDirection.rtl);

    fill2.layout();
    canvas.save();
    final pivot2 = fill2.size.center(offset);
    canvas.translate(pivot2.dx, pivot2.dy);
    canvas.rotate(angle + 0.5);
    canvas.translate(-pivot2.dx, -pivot2.dy);
    fill.paint(canvas, offset2);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
