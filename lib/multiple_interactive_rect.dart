import 'package:flutter/material.dart';
import 'dart:math' as math;

const DEFAULT_HEIGHT = 100.0;
const DEFAULT_ANGLE = 0.0;

class MultipleRectangle extends StatefulWidget {
  @override
  _MultipleRectangleState createState() => _MultipleRectangleState();
}

class _MultipleRectangleState extends State<MultipleRectangle> {
  final math.Random rd = math.Random();
  final int numColors = Colors.primaries.length;

  List<Rect?> _rect = [];
  List<bool> _dragging = [];
  List<bool> _rotating = [];
  List<bool> _scaling = [];
  List<double> _height = [];
  List<double> _angle = [];
  List<Color> _color = [];
  int currentRect = 0;

  @override
  void initState() {
    _addRectangle();
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

  Future<void> _addRectangle() async {
    await Future<void>.delayed(Duration(milliseconds: 10));
    final _sHeight = MediaQuery.of(context).size.width;
    final _sWidth = MediaQuery.of(context).size.height;
    final _offset = Offset(
      rd.nextDouble() * _sHeight,
      rd.nextDouble() * _sWidth,
    );
    Rect _r = _offset & Size(DEFAULT_HEIGHT, DEFAULT_HEIGHT);
    _rect.add(_r);
    _dragging.add(false);
    _scaling.add(false);
    _rotating.add(false);
    _angle.add(DEFAULT_ANGLE);
    _height.add(DEFAULT_HEIGHT);
    _color.add(Colors.primaries[rd.nextInt(numColors)]);
    setState(() {});
  }

  /// Is the point (x, y) inside the rect?
  bool _insideRect({required Offset tapped, required int index}) {
    if (_rect[index] == null) {
      return false;
    } else {
      final _radious =
          (_rect[index]!.center - _rect[index]!.bottomCenter).distance;
      Rect _insideCircleRect = Rect.fromCircle(
          center: _rect[index]!.center, radius: _radious / math.sqrt(2));
      return _insideCircleRect.contains(tapped);
    }
  }

  bool _insideTopRightCircle({required Offset tapped, required int index}) {
    if (_rect[index] == null) {
      return false;
    } else {
      Offset _center = _rect[index]!.center;
      Offset _centerToTopRight = _rect[index]!.topRight - _center;
      final temp = Offset.fromDirection(
          _centerToTopRight.direction + _angle[index],
          _centerToTopRight.distance);
      final _rotated = temp.translate(_center.dx, _center.dy);
      final _newRect = Rect.fromCircle(center: _rotated, radius: 10);
      return _newRect.contains(tapped);
    }
  }

  bool _insideTopLeftCircle({required Offset tapped, required int index}) {
    if (_rect[index] == null) {
      return false;
    } else {
      Offset _center = _rect[index]!.center;
      Offset _centerToTopLeft = _rect[index]!.topLeft - _center;
      final temp = Offset.fromDirection(
          _centerToTopLeft.direction + _angle[index],
          _centerToTopLeft.distance);
      final _rotated = temp.translate(_center.dx, _center.dy);
      final _newRect = Rect.fromCircle(center: _rotated, radius: 10);
      return _newRect.contains(tapped);
    }
  }

  bool _insideBottomLeftCircle({required Offset tapped, required int index}) {
    if (_rect[index] == null) {
      return false;
    } else {
      Offset _center = _rect[index]!.center;
      Offset _centerToBottomLeft = _rect[index]!.bottomLeft - _center;
      final temp = Offset.fromDirection(
          _centerToBottomLeft.direction + _angle[index],
          _centerToBottomLeft.distance);
      final _rotated = temp.translate(_center.dx, _center.dy);
      final _newRect = Rect.fromCircle(center: _rotated, radius: 10);
      return _newRect.contains(tapped);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        // print('pan start');
        for (int i = _rect.length - 1; i >= 0; i--) {
          if (_insideTopRightCircle(tapped: details.globalPosition, index: i)) {
            _rotating[i] = true;
            currentRect = i;
            break;
          } else if (_insideTopLeftCircle(
              tapped: details.globalPosition, index: i)) {
            _rect[i] = null;
            setState(() {});
            break;
          } else if (_insideBottomLeftCircle(
              tapped: details.globalPosition, index: i)) {
            _scaling[i] = true;
            currentRect = i;
            break;
          } else if (_insideRect(tapped: details.globalPosition, index: i)) {
            _dragging[i] = true;
            currentRect = i;
            break;
          }
        }
      },
      onPanEnd: (details) {
        for (int i = 0; i < _rect.length; i++) {
          _dragging[i] = false;
          _rotating[i] = false;
          _scaling[i] = false;
        }
      },
      onPanUpdate: (details) {
        // _printRect(rect);
        if (_rotating[currentRect] && _rect[currentRect] != null) {
          // Determine the angle to be rotated.
          Offset _center = _rect[currentRect]!.center;
          Offset _tap = details.globalPosition;
          Offset _delta = details.delta;

          Offset _centerToDelta = (_tap + _delta) - _center;
          Offset _centerToTap = _tap - _center;

          setState(() {
            _angle[currentRect] +=
                _centerToDelta.direction - _centerToTap.direction;
          });
        } else if (_scaling[currentRect] && _rect[currentRect] != null) {
          // Determine the value to be scaled.
          Offset _center = _rect[currentRect]!.center;
          Offset _tap = details.globalPosition;
          Offset _delta = details.delta;

          Offset _centerToDelta = (_tap + _delta) - _center;
          Offset _centerToTap = _tap - _center;
          double _ratio;
          // TODO: bug fix scaling
          _ratio = _centerToDelta.distance / _centerToTap.distance;

          // print(_ratio);
          setState(() {
            if (_ratio >= 1 || _height[currentRect] > 50) {
              _height[currentRect] *= _ratio;
              _rect[currentRect] = Rect.fromCircle(
                  center: _rect[currentRect]!.center,
                  radius: _height[currentRect] / 2);
            }
          });
        } else if (_dragging[currentRect] && _rect[currentRect] != null) {
          setState(() {
            _rect[currentRect] = Rect.fromCircle(
                center: _rect[currentRect]!.center + details.delta,
                radius: (_rect[currentRect]!.center -
                        _rect[currentRect]!.bottomCenter)
                    .distance);
          });
        }
      },
      child: Container(
        color: Colors.white,
        child: CustomPaint(
          painter: RectanglePainter(_rect, _angle, _color),
          child: Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.only(top: 80),
            child: MaterialButton(
              color: Colors.amberAccent,
              onPressed: () {
                _addRectangle();
              },
              child: Text('Add Rect'),
            ),
          ),
        ),
      ),
    );
  }
}

class RectanglePainter extends CustomPainter {
  RectanglePainter(this.rect, this.angle, this.color);

  final List<Rect?> rect;
  final List<double> angle;
  final List<Color> color;
  final Paint greenBrush = Paint()..color = Colors.greenAccent;
  final Paint redBrush = Paint()..color = Colors.redAccent;
  final Paint yellowBrush = Paint()..color = Colors.yellowAccent;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < rect.length; i++) {
      if (rect[i] != null) {
        final stroke = Paint()..color = color[i];
        canvas.save();
        rotate(canvas: canvas, os: rect[i]!.center, angle: angle[i]);
        canvas.drawRect(rect[i]!, stroke);
        canvas.drawCircle(rect[i]!.topRight, 20, greenBrush);
        canvas.drawCircle(rect[i]!.topLeft, 20, redBrush);
        canvas.drawCircle(rect[i]!.bottomLeft, 20, yellowBrush);
        canvas.restore();
      }
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
