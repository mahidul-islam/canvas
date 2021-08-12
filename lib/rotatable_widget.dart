import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';
import 'package:flutter/src/material/colors.dart' as Color;

class CustomPainterRotatble extends StatefulWidget {
  @override
  _CustomPainterRotatbleState createState() => _CustomPainterRotatbleState();
}

class _CustomPainterRotatbleState extends State<CustomPainterRotatble> {
  var xPos = 0.0;
  var yPos = 0.0;
  final width = 100.0;
  final height = 100.0;
  bool _dragging = false;
  double angle = 0.0;

  @override
  void initState() {
    _initCoOrdinate();
    super.initState();
  }

  Future<void> _initCoOrdinate() async {
    await Future<void>.delayed(Duration(milliseconds: 100));
    xPos = MediaQuery.of(context).size.width / 2 - (width / 2);
    yPos = MediaQuery.of(context).size.height / 2 - (height / 2);
    setState(() {});
  }

  /// Is the point (x, y) inside the rect?
  bool _insideRect(double x, double y) =>
      x >= xPos && x <= xPos + width && y >= yPos && y <= yPos + height;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) => _dragging = _insideRect(
        details.globalPosition.dx,
        details.globalPosition.dy,
      ),
      onPanEnd: (details) {
        _dragging = false;
      },
      onPanUpdate: (details) {
        if (_dragging) {
          final nowX = details.globalPosition.dx;
          final nowY = details.globalPosition.dy;
          final goX = details.globalPosition.dx + details.delta.dx;
          final goY = details.globalPosition.dy + details.delta.dy;
          final v1 = Vector2(nowX - xPos, nowY - yPos);
          final v2 = Vector2(goX - xPos, goY - yPos);

          setState(() {
            angle = v1.angleTo(v2);
            print(angle);
          });

          // setState(() {
          //   xPos += details.delta.dx;
          //   yPos += details.delta.dy;
          // });
        }
      },
      child: Container(
        color: Color.Colors.amberAccent,
        child: CustomPaint(
          painter: RectanglePainter(Rect.fromLTWH(xPos, yPos, width, height)),
          child: Container(),
        ),
      ),
    );
  }
}

class RectanglePainter extends CustomPainter {
  RectanglePainter(this.rect);
  final Rect rect;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(rect, Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
