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

  void _printRect(Rect? rectangle) {
    print('\t\tleft = ' +
        (rectangle?.left.toStringAsFixed(2) ?? '') +
        ' *** right = ' +
        (rectangle?.right.toStringAsFixed(2) ?? '') +
        '\n\t\t\t\ttop = ' +
        (rectangle?.top.toStringAsFixed(2) ?? '') +
        ' *** bottom = ' +
        (rectangle?.bottom.toStringAsFixed(2) ?? ''));
  }

  void _printOffset(Offset? offset) {
    print('dx = ' +
        (offset?.dx.toStringAsFixed(2) ?? '') +
        ' *** dy = ' +
        (offset?.dy.toStringAsFixed(2) ?? ''));
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
    if (rect == null) {
      return false;
    } else {
      final _radious = (rect!.center - rect!.bottomCenter).distance;
      Rect _insideCircleRect = Rect.fromCircle(
          center: rect!.center, radius: _radious / math.sqrt(2));
      return _insideCircleRect.contains(tapped);
    }
  }

  bool _insideTopRightCircle(Offset tapped) {
    if (rect == null) {
      return false;
    } else {
      // center of rect.
      Offset _center = rect!.center;

      // from center of rect to tapped vector
      // Offset _centerToTap = tapped - _center;

      Offset _centerToTopRight = rect!.topRight - _center;

      // rotate topRight Cornar offset of the rect
      final temp = Offset.fromDirection(
          _centerToTopRight.direction + angle, _centerToTopRight.distance);

      final _rotated = temp.translate(_center.dx, _center.dy);

      // _printOffset(rect!.topRight);
      // _printOffset(temp);
      // _printOffset(_rotated);

      final _newRect = Rect.fromCircle(center: _rotated, radius: 10);
      // _printRect(rect);
      // _printRect(_newRect);

      return _newRect.contains(tapped);
    }
  }

  bool _insideTopLeftCircle(Offset tapped) {
    if (rect == null) {
      return false;
    } else {
      // center of rect.
      Offset _center = rect!.center;

      // from center of rect to tapped vector
      // Offset _centerToTap = tapped - _center;

      Offset _centerToTopLeft = rect!.topLeft - _center;

      // rotate topRight Cornar offset of the rect
      final temp = Offset.fromDirection(
          _centerToTopLeft.direction + angle, _centerToTopLeft.distance);

      final _rotated = temp.translate(_center.dx, _center.dy);

      // _printOffset(rect!.topRight);
      // _printOffset(temp);
      // _printOffset(_rotated);

      final _newRect = Rect.fromCircle(center: _rotated, radius: 10);
      // _printRect(rect);
      // _printRect(_newRect);

      return _newRect.contains(tapped);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        if (_insideTopRightCircle(details.globalPosition)) {
          _rotating = true;
        } else if (_insideTopLeftCircle(details.globalPosition)) {
          rect = null;
          setState(() {});
        } else if (_insideRect(details.globalPosition)) {
          _dragging = true;
        }
      },
      onPanEnd: (details) {
        _dragging = false;
        _rotating = false;
      },
      onPanUpdate: (details) {
        // _printRect(rect);
        if (_rotating && rect != null) {
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
        } else if (_dragging && rect != null) {
          setState(() {
            rect = Rect.fromCircle(
                center: rect!.center + details.delta,
                radius: (rect!.center - rect!.bottomCenter).distance);
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
  final Paint redBrush = Paint()..color = m.Colors.redAccent;

  @override
  void paint(Canvas canvas, Size size) {
    if (rect != null) {
      canvas.save();
      rotate(canvas: canvas, os: rect!.center, angle: angle);
      canvas.drawRect(rect!, Paint());
      canvas.drawCircle(rect!.topRight, 20, greenBrush);
      canvas.drawCircle(rect!.topLeft, 20, redBrush);
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
