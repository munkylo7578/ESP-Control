import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:ecommerce/utils/Gcode/Core/ImageProcessModel.dart';
import 'package:ecommerce/utils/Gcode/Engine/GCodeGeneration/BaseGCode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/rendering.dart';

class DrawingScreen extends StatefulWidget {
  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  final ImageProcessorModel _imageProcessorModel =
      ImageProcessorModel(ObserverList<BaseGCode>());
  final GlobalKey _boundaryKey = GlobalKey();
  ui.Image? pickedImage;
  List<Offset?> points = [];
  double strokeWidth = 5.0;
  bool isErasing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildSpeedDial(),
      appBar: AppBar(
        title: Text('CNC'),
        backgroundColor: Color.fromARGB(255, 169, 83, 184),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                points.clear();
              });
            },
          ),
        ],
      ),
      body: Stack(children: [
        Builder(
          builder: (context) => GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                RenderBox renderBox = context.findRenderObject() as RenderBox;
                points.add(renderBox.globalToLocal(details.globalPosition));
              });
            },
            onPanEnd: (details) {
              points.add(null);
            },
            child: RepaintBoundary(
              key: _boundaryKey,
              child: CustomPaint(
                painter: MyPainter(points, strokeWidth, isErasing),
                child: Container(),
              ),
            ),
          ),
        ),
        /*  if (pickedImage != null)
          Positioned.fill(
            child: Opacity(
              opacity: 1.0,
              child: AspectRatio(
                aspectRatio: pickedImage!.width / pickedImage!.height,
                child: RawImage(image: pickedImage!),
              ),
            ),
          ), */
      ]),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return SingleChildScrollView(
      child: Container(
        height: 60.0, // Set a fixed height for the bottom bar
        padding: EdgeInsets.symmetric(vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, -1),
              blurRadius: 8.0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.brush),
              onPressed: () {
                setState(() {
                  isErasing = false;
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.create),
              onPressed: () {
                setState(() {
                  isErasing = true;
                });
              },
            ),
            Flexible(
              child: Container(
                width: MediaQuery.of(context).size.width *
                    0.4, // 40% of screen width
                child: Slider(
                  value: strokeWidth,
                  min: 1.0,
                  max: 10.0,
                  onChanged: (value) {
                    setState(() {
                      strokeWidth = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SpeedDial _buildSpeedDial() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      children: [
        // Add your buttons here. For example:
        SpeedDialChild(
          child: Icon(Icons.save),
          label: 'Lưu bức vẽ',
          onTap: _saveToFile,
        ),
        SpeedDialChild(
          child: Icon(Icons.camera_alt_rounded),
          label: 'Chọn ảnh',
          onTap: pickImage,
        ),
      ],
    );
  }

  void pickImage() async {
    await _imageProcessorModel.openImage();
    /*   if (_imageProcessorModel.pickedImage != null) {
      setState(() {
        pickedImage = _imageProcessorModel.pickedImage;
      });
    } */
    generateGcode();
  }

  void generateGcode() {
    _imageProcessorModel.generate();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Lưu File .ngc vào thư mục download thành công!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  Future<void> _saveToFile() async {
    RenderRepaintBoundary boundary = _boundaryKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(pixelRatio: 3.0);

    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      print("Failed to get byte data!");
      return;
    }
    await _imageProcessorModel.saveImageAndGen(byteData);
    generateGcode();
  }
}

class MyPainter extends CustomPainter {
  final List<Offset?> points;
  final double strokeWidth;
  final bool isErasing;

  MyPainter(this.points, this.strokeWidth, this.isErasing);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw a white background
    Paint backgroundPaint = Paint()..color = Colors.white;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Now draw the image
    Paint paint = Paint()
      ..color = isErasing ? Colors.white : Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
