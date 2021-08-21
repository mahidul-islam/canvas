import 'package:flutter/material.dart' as m;
import 'package:flutter/material.dart';
// import 'package:vector_math/vector_math.dart';
import 'dart:math' as math;

class OptimizedDraggable extends StatefulWidget {
  @override
  _OptimizedDraggableState createState() => _OptimizedDraggableState();
}

class _OptimizedDraggableState extends State<OptimizedDraggable> {
  Rect? rect;
  bool _dragging = false;
  bool _rotating = false;
  double height = 100, width = 100;
  double angle = 0;

  @override
  void initState() {
    _initCoOrdinate();
    super.initState();
  }

  Future<void> _initCoOrdinate() async {
    await Future<void>.delayed(Duration(milliseconds: 10));
    final x = MediaQuery.of(context).size.width / 2 - (width / 2);
    final y = MediaQuery.of(context).size.height / 2 - (height / 2);
    rect = Offset(x, y) & Size(height, width);
    setState(() {});
  }

  /// Is the point (x, y) inside the rect?
  bool _insideRect(Offset tapped) {
    // print('tapX = ' + x.toStringAsFixed(2) + ' tapY = ' + y.toStringAsFixed(2));
    // print('\t\tleft = ' +
    //     (rect?.left.toStringAsFixed(2) ?? '') +
    //     ' *** right = ' +
    //     (rect?.right.toStringAsFixed(2) ?? '') +
    //     '\n\t\t\t\ttop = ' +
    //     (rect?.top.toStringAsFixed(2) ?? '') +
    //     ' *** bottom = ' +
    //     (rect?.bottom.toStringAsFixed(2) ?? ''));
    // print('Contains : ' + (rect?.contains(Offset(x, y)) ?? false).toString());
    // Offset cal = Offset(x, y) - rect!.center;
    // print('angle : ' +
    //     angle.toStringAsFixed(2) +
    //     'cal : ' +
    //     cal.direction.toStringAsFixed(2));

    final _radious = (rect!.center - rect!.bottomCenter).distance;
    Rect _insideCircleRect =
        Rect.fromCircle(center: rect!.center, radius: _radious / math.sqrt(2));
    return _insideCircleRect.contains(tapped);
    // return rect?.contains(Offset(x, y)) ?? false;
  }

  bool insideCircle(Offset tapped) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        _dragging = _insideRect(details.globalPosition);
        _rotating = insideCircle(details.globalPosition);
      },
      onPanEnd: (details) {
        _dragging = false;
      },
      onPanUpdate: (details) {
        // print('\t\tleft = ' +
        //     (rect?.left.toStringAsFixed(2) ?? '') +
        //     ' *** right = ' +
        //     (rect?.right.toStringAsFixed(2) ?? '') +
        //     '\n\t\t\t\ttop = ' +
        //     (rect?.top.toStringAsFixed(2) ?? '') +
        //     ' *** bottom = ' +
        //     (rect?.bottom.toStringAsFixed(2) ?? ''));
        if (_dragging && rect != null) {
          setState(() {
            rect = Rect.fromCircle(
                center: rect!.center + details.delta,
                radius: (rect!.center - rect!.bottomCenter).distance);
          });
        } else {
          // Determine the angle to be rotated.
          Offset _center = rect!.center;
          Offset _tap = details.globalPosition;
          Offset _delta = details.delta;

          Offset _centerToDelta = (_tap + _delta) - _center;
          Offset _centerToTap = _tap - _center;

          setState(() {
            angle += _centerToDelta.direction - _centerToTap.direction;
            // print(angle.toStringAsFixed(2));
          });
        }
      },
      child: Container(
        color: m.Colors.white,
        child: CustomPaint(
          painter: RectanglePainter(rect, angle),
          child: Container(),
        ),
      ),
    );
  }
}

class RectanglePainter extends CustomPainter {
  RectanglePainter(this.rect, this.angle);
  final Rect? rect;
  final double angle;
  final Paint greenBrush = Paint()..color = m.Colors.greenAccent;

  @override
  void paint(Canvas canvas, Size size) {
    if (rect != null) {
      canvas.save();
      rotate(canvas: canvas, os: rect!.center, angle: angle);
      canvas.drawRect(rect!, Paint());
      canvas.drawCircle(rect!.topRight, 20, greenBrush);
      canvas.restore();
    }
  }

  void rotate(
      {required Canvas canvas, required Offset os, required double angle}) {
    canvas.translate(os.dx, os.dy);
    canvas.rotate(angle);
    canvas.translate(-os.dx, -os.dy);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
