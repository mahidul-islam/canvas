import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

class BlurView extends StatefulWidget {
  final String imagePath;
  const BlurView(this.imagePath);

  @override
  _BlurViewState createState() => _BlurViewState();
}

class _BlurViewState extends State<BlurView> {
  ui.Image? image;

  @override
  void initState() {
    super.initState();
    _load(widget.imagePath);
  }

  void _load(String path) async {
    var bytes = await rootBundle.load(path);
    image = await decodeImageFromList(bytes.buffer.asUint8List());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<Offset> notifier = ValueNotifier(Offset.infinite);
    return Listener(
      onPointerDown: (event) => notifier.value = event.localPosition,
      onPointerMove: (event) => notifier.value = event.localPosition,
      child: CustomPaint(
        painter: BlurPaint(notifier, image),
        child: SizedBox.expand(),
      ),
    );
  }
}

class BlurPaint extends CustomPainter {
  final ValueNotifier<Offset> notifier;
  ui.Image? image;
  late Size imageSize;
  late Matrix4 matrix;
  Paint shaderPaint = Paint();
  Paint framePaint = Paint();
  late Rect clip;

  BlurPaint(this.notifier, this.image) : super(repaint: notifier) {
    framePaint
      ..color = Color(0xffaa0000)
      ..style = PaintingStyle.stroke
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4)
      ..strokeWidth = 6;
    if (image != null)
      imageSize = Size(image!.width.toDouble(), image!.height.toDouble());
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    if (image != null) {
      // sizeToRect: https://gist.github.com/pskink/6ef88df64d7764fd0efcd60aa618f0c0
      matrix = sizeToRect(imageSize, Offset.zero & size);
      // inverseMatrix = Matrix4.copy(matrix)..invert();
      shaderPaint.shader =
          ImageShader(image!, TileMode.clamp, TileMode.clamp, matrix.storage);
      clip = MatrixUtils.transformRect(matrix, Offset.zero & imageSize);
    }
    if (image == null) return;

    canvas.clipRect(clip);
    canvas.drawRect(clip,
        shaderPaint..imageFilter = ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8));
    var frame = Rect.fromCenter(
        center: notifier.value, width: clip.width / 3, height: clip.height / 3);
    Path path = Path()
      ..addRRect(RRect.fromRectAndCorners(frame,
          topLeft: Radius.circular(36), bottomRight: Radius.circular(24)));
    canvas.drawPath(path, framePaint);
    canvas.drawPath(path, shaderPaint..imageFilter = null);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

Matrix4 sizeToRect(Size src, Rect dst,
    {BoxFit fit = BoxFit.contain, Alignment alignment = Alignment.center}) {
  FittedSizes fs = applyBoxFit(fit, src, dst.size);
  double scaleX = fs.destination.width / fs.source.width;
  double scaleY = fs.destination.height / fs.source.height;
  Size fittedSrc = Size(src.width * scaleX, src.height * scaleY);
  Rect out = alignment.inscribe(fittedSrc, dst);

  return Matrix4.identity()
    ..translate(out.left, out.top)
    ..scale(scaleX, scaleY);
}

/// Like [sizeToRect] but accepting a [Rect] as [src]
Matrix4 rectToRect(Rect src, Rect dst,
    {BoxFit fit = BoxFit.contain, Alignment alignment = Alignment.center}) {
  return sizeToRect(src.size, dst, fit: fit, alignment: alignment)
    ..translate(-src.left, -src.top);
}
