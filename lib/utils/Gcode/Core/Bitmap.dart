import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:ui' as ui;

class Cac {}

extension BrightnessExtension on Color {
  double get brightness {
    double r = this.red / 255.0;
    double g = this.green / 255.0;
    double b = this.blue / 255.0;

    double max = [r, g, b].reduce(math.max);
    double min = [r, g, b].reduce(math.min);

    return (max + min) / 2.0;
  }
}

class Bitmap {
  late ui.Image image;
  ByteData? _byteData;

  ui.Image get _image => image;
  int get width => image.width;
  int get height => image.height;
  Future<ui.Image> fromByteData(ByteData byteData) async {
    ui.Codec codec =
        await ui.instantiateImageCodec(byteData.buffer.asUint8List());
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    image = frameInfo.image;
    _byteData = await image.toByteData();
    return image;
  }

  Future<ui.Image> fromDevice() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      throw Exception('No image selected.');
    }

    final List<int> bytes = await pickedFile.readAsBytes();
    final Uint8List uint8bytes = Uint8List.fromList(bytes);
    final ui.Codec codec = await ui.instantiateImageCodec(uint8bytes);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();

    image = frameInfo.image;
    _byteData = await image.toByteData();
    return image;
  }

  Future<ui.Image> fromFile(String path) async {
    _byteData = await rootBundle.load('assets/$path');

    ui.Codec codec =
        await ui.instantiateImageCodec(_byteData!.buffer.asUint8List());
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    ui.Image image = frameInfo.image;
    _byteData = await image.toByteData();
    return image;
  }

  Color getPixel(int x, int y) {
    if (_byteData == null) {
      throw Exception('Failed to get ByteData from image.');
    }
    final int pixel32 = _byteData!.getInt32((x + y * image.width) * 4);
    final int hex = abgrToArgb(pixel32); // Convert ABGR to ARGB
    return Color(hex);
  }

  int abgrToArgb(int abgrColor) {
    final r = (abgrColor >> 24) & 0xFF;
    final g = (abgrColor >> 16) & 0xFF;
    final b = (abgrColor >> 8) & 0xFF;
    final a = abgrColor & 0xFF;
    return (a << 24) | (r << 16) | (g << 8) | b;
  }
}
