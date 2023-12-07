import 'dart:math';

import './FreeMotionStroke.dart';

import "../../Geometry/Vector.dart";

class Stroke extends FreeMotionStroke {
  late double intensity;

  Stroke(Vector? destinationPoint, double intensity) : super(destinationPoint) {
    this.intensity = intensity;
  }
}
