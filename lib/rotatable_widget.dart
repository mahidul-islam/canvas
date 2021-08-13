import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m;
import 'package:vector_math/vector_math.dart';

class CustomPainterRotatble extends StatefulWidget {
  @override
  _CustomPainterRotatbleState createState() => _CustomPainterRotatbleState();
}

class _CustomPainterRotatbleState extends State<CustomPainterRotatble> {
  var xPos = 0.0;
  var yPos = 0.0;
  final width = 100.0;
  final height = 100.0;
  // bool _dragging = false;
  double angle = 0.0;

  @override
  void initState() {
    _initCoOrdinate();
    super.initState();
  }

  Future<void> _initCoOrdinate() async {
    await Future<void>.delayed(Duration(milliseconds: 10));
    xPos = MediaQuery.of(context).size.width / 2 - (width / 2);
    yPos = MediaQuery.of(context).size.height / 2 - (height / 2);
    setState(() {});
  }

  /// Is the point (x, y) inside the rect?
  // bool _insideRect(double x, double y) =>
  //     x >= xPos && x <= xPos + width && y >= yPos && y <= yPos + height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {},
      onPanEnd: (details) {},
      onPanUpdate: (details) {
        final gx = details.globalPosition.dx;
        final gy = details.globalPosition.dy;
        final dx = details.delta.dx;
        final dy = details.delta.dy;

        // print('x =' + gx.toStringAsFixed(2) + ', y = ' + gy.toStringAsFixed(2));
        // print(
        //     'dx =' + dx.toStringAsFixed(2) + ', dy = ' + dy.toStringAsFixed(2));

        final v1 = Vector2(gx - xPos, gy - yPos);
        final v2 = Vector2(gx - xPos + dx, gy - yPos + dy);

        setState(() {
          angle += v1.angleToSigned(v2);
        });
      },
      child: Container(
        color: m.Colors.white,
        child: CustomPaint(
          painter: RectanglePainter(
              rect: Rect.fromLTWH(xPos, yPos, width, height),
              cx: xPos + (width / 2),
              cy: yPos + (height / 2),
              angle: angle),
        ),
      ),
    );
  }
}

class RectanglePainter extends CustomPainter {
  RectanglePainter(
      {required this.rect,
      required this.cx,
      required this.cy,
      required this.angle});
  final Rect rect;
  final double angle;
  final double cx;
  final double cy;

  @override
  void paint(Canvas canvas, Size size) {
    Paint greenBrush = Paint()..color = m.Colors.greenAccent;
    canvas.save();
    rotate(canvas: canvas, cx: cx, cy: cy, angle: angle);
    canvas.drawRect(rect, greenBrush);
    canvas.restore();
  }

  void rotate(
      {required Canvas canvas,
      required double cx,
      required double cy,
      required double angle}) {
    canvas.translate(cx, cy);
    canvas.rotate(angle);
    canvas.translate(-cx, -cy);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
