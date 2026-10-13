import 'package:flutter/animation.dart';

/// Spacing on a 4-point grid. Use these instead of literal paddings.
abstract final class Space {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  /// Side padding for full-width screen content.
  static const double screen = 20;
}

abstract final class Radii {
  static const double chip = 12;
  static const double card = 16;
  static const double sheet = 24;
  static const double pill = 999;
}

/// Short, soft motion. Charts animate in once and never loop.
abstract final class Motion {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 250);
  static const Duration chart = Duration(milliseconds: 700);
  static const Curve curve = Curves.easeOutCubic;
}

/// Minimum size for anything tappable (Material guidance is 48 dp).
const double minTapTarget = 48;
