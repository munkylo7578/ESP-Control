import 'package:flutter/material.dart';
import '../BaseGCode.dart';
import '../CoordinateMotion.dart';
import '../ImageProcessor/FreeMotionStroke.dart';
import '../ImageProcessor/IdleStroke.dart';
import '../ImageProcessor/Stroke.dart';
import '../RapidMotion.dart';
import '../../Geometry/Vector.dart';

class MotionFactoryImage {
  late int _minFeed;
  late int _maxFeed;
  late int _maxPower;
  late int _minPower;

  MotionFactoryImage(int minFeed, int maxFeed, int maxPower, int minPower) {
    _minPower = minPower;
    _maxPower = maxPower;
    _maxFeed = maxFeed;
    _minFeed = minFeed;
  }
  Iterable<BaseGCode> createMotion(FreeMotionStroke stroke) sync* {
    if (stroke is IdleStroke) {
      yield CoordinateMotion(
          stroke.destinationPoint, 0, _maxFeed, Color(0xFF00FFFF))
        ..comment = "Idle motion";
    }
    if (stroke is Stroke) {
      int colorIntensity = (255 * (stroke).intensity).toInt();
      yield CoordinateMotion(
        stroke.destinationPoint,
        ((_minPower + (_maxPower - _minPower) * stroke.intensity)).round(),
        ((_minFeed + (_maxFeed - _minFeed) * (1 - stroke.intensity))).round(),
        Color.fromRGBO(colorIntensity, colorIntensity, colorIntensity, 1),
      );
    }
    if (stroke is FreeMotionStroke) {
      yield RapidMotion(stroke.destinationPoint)..comment = 'New line move';
    }
  }
}
