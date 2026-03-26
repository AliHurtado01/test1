import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClusterIcon {
  static const String _basePath = 'lib/public/markers/cluster.png';
  static const double _iconSize = 42.0;

  ui.Image? _baseImage;

  Future<BitmapDescriptor> paint(int count) async {
    await _loadBaseImage();

    final text = _formatCount(count);
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);

    if (_baseImage != null) {
      paintImage(
        canvas: canvas,
        rect: Rect.fromLTWH(0, 0, _iconSize, _iconSize),
        image: _baseImage!,
        fit: BoxFit.contain,
      );
    }

    _drawText(canvas, text);

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(_iconSize.toInt(), _iconSize.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List());
  }

  Future<void> _loadBaseImage() async {
    if (_baseImage != null) return;

    final data = await rootBundle.load(_basePath);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    _baseImage = frame.image;
  }

  String _formatCount(int count) {
    return count > 99 ? '99+' : count.toString();
  }

  void _drawText(Canvas canvas, String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    final offset = Offset(
      (_iconSize - textPainter.width) / 2,
      (_iconSize - textPainter.height) / 2,
    );

    textPainter.paint(canvas, offset);
  }
}
