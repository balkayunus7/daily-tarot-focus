import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract final class Sp {
  static const double none = 0;
  static const double tiny = 4;
  static const double xsmall = 8;
  static const double small = 12;
  static const double medium = 16;
  static const double large = 20;
  static const double xlarge = 24;
  static const double xxlarge = 32;
  static const double xxxlarge = 48;
  static const double huge = 64;

  // Semantic aliases
  static const double screen = large;
  static const double button = medium;
  static const double input = small;
  static const double cont = 54;
}

abstract final class CardSp {
  static const double flipHeight = 190;
  static const double flipWidth = 110;
  static const double wheelItemExtent = 140;
  static const double wheelDiameterRatio = 1.5;
  static const double wheelPerspective = 0.0008;
  static const double wheelSqueeze = 1.5;
  static const int totalCards = 50;
  static const double shadowBlurRadius = 20;
  static const double shadowSpreadRadius = 10;
  static const double selectedCardWidth = 120;
  static const double selectedCardHeight = 180;
  static const double unselectedCardWidth = 65;
  static const double unselectedCardHeight = 100;

  static const Duration flipAnimation = Duration(milliseconds: 500);
  static const Duration revealAnimation = Duration(milliseconds: 7500);
  static const Duration wheelAnimation = Duration(milliseconds: 500);
  static const Duration flipCard = Duration(seconds: 3);
}

extension SizingX on num {
  SizedBox get heightBox => SizedBox(height: toDouble().h);
  SizedBox get widthBox => SizedBox(width: toDouble().w);
}

extension PaddingX on num {
  EdgeInsets get padAllR => EdgeInsets.all(toDouble().r);
  EdgeInsets get padHR => EdgeInsets.symmetric(horizontal: toDouble().w);
  EdgeInsets get padVR => EdgeInsets.symmetric(vertical: toDouble().h);
  EdgeInsets get padXR => padHR;
  EdgeInsets get padYR => padVR;
  EdgeInsets get padTopR => EdgeInsets.only(top: toDouble().h);
  EdgeInsets get padBottomR => EdgeInsets.only(bottom: toDouble().h);
  EdgeInsets get padLeftR => EdgeInsets.only(left: toDouble().w);
  EdgeInsets get padRightR => EdgeInsets.only(right: toDouble().w);

  EdgeInsets padOnlyR({bool t = false, bool b = false, bool l = false, bool r = false}) =>
      EdgeInsets.only(
        top: t ? toDouble().h : 0,
        bottom: b ? toDouble().h : 0,
        left: l ? toDouble().w : 0,
        right: r ? toDouble().w : 0,
      );
}

extension AsymmetricPaddingX on num {
  EdgeInsets padHVR(double v) => EdgeInsets.symmetric(horizontal: toDouble().w, vertical: v.h);
  EdgeInsets padVHR(double h) => EdgeInsets.symmetric(vertical: toDouble().h, horizontal: h.w);

  EdgeInsets padSymR({double? h, double? v}) => EdgeInsets.symmetric(
    horizontal: (h ?? toDouble()).w,
    vertical: (v ?? 0).h,
  );
}

extension RadiusX on num {
  BorderRadius get radiusR => BorderRadius.circular(toDouble().r);
  Radius get rRadius => Radius.circular(toDouble().r);

  BorderRadius radiusOnlyR({
    bool tl = false,
    bool tr = false,
    bool bl = false,
    bool br = false,
  }) {
    final r = Radius.circular(toDouble().r);
    return BorderRadius.only(
      topLeft: tl ? r : Radius.zero,
      topRight: tr ? r : Radius.zero,
      bottomLeft: bl ? r : Radius.zero,
      bottomRight: br ? r : Radius.zero,
    );
  }
}

extension FontSizeX on num {
  double get textSp => toDouble().sp;
}

extension DurationX on num {
  Duration get ms => Duration(milliseconds: round());
  Duration get seconds => Duration(seconds: round());
}

extension ContextSizingX on BuildContext {
  double get suWidth => ScreenUtil().screenWidth;
  double get suHeight => ScreenUtil().screenHeight;
}
