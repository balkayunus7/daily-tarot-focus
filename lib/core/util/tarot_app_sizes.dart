import 'package:flutter/material.dart';

class SpacingConsts {
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

  static const double defaultPadding = medium;
  static const double cardPadding = large;
  static const double screenPadding = large;
  static const double buttonPadding = medium;
  static const double inputPadding = small;
  static const double contSize = 54;
}

class Spacing {
  static const Widget tinyW = SizedBox(width: SpacingConsts.tiny);
  static const Widget xsmallW = SizedBox(width: SpacingConsts.xsmall);
  static const Widget smallW = SizedBox(width: SpacingConsts.small);
  static const Widget mediumW = SizedBox(width: SpacingConsts.medium);
  static const Widget largeW = SizedBox(width: SpacingConsts.large);
  static const Widget xlargeW = SizedBox(width: SpacingConsts.xlarge);
  static const Widget xxlargeW = SizedBox(width: SpacingConsts.xxlarge);
  static const Widget xxxlargeW = SizedBox(width: SpacingConsts.xxxlarge);

  static const Widget tinyH = SizedBox(height: SpacingConsts.tiny);
  static const Widget xsmallH = SizedBox(height: SpacingConsts.xsmall);
  static const Widget smallH = SizedBox(height: SpacingConsts.small);
  static const Widget mediumH = SizedBox(height: SpacingConsts.medium);
  static const Widget largeH = SizedBox(height: SpacingConsts.large);
  static const Widget xlargeH = SizedBox(height: SpacingConsts.xlarge);
  static const Widget xxlargeH = SizedBox(height: SpacingConsts.xxlarge);
  static const Widget xxxlargeH = SizedBox(height: SpacingConsts.xxxlarge);
  static const Widget hugeH = SizedBox(height: SpacingConsts.huge);

  static BorderRadius tinyBorderRadius = BorderRadius.circular(
    SpacingConsts.tiny,
  );
  static BorderRadius xsmallBorderRadius = BorderRadius.circular(
    SpacingConsts.xsmall,
  );
  static BorderRadius smallBorderRadius = BorderRadius.circular(
    SpacingConsts.small,
  );
  static BorderRadius defaultBorderRadius = BorderRadius.circular(
    SpacingConsts.medium,
  );
  static BorderRadius largeBorderRadius = BorderRadius.circular(
    SpacingConsts.large,
  );
  static BorderRadius xlargeBorderRadius = BorderRadius.circular(
    SpacingConsts.xlarge,
  );
  static BorderRadius circularBorderRadius = BorderRadius.circular(100);
  static BorderRadius xxlargeBorderRadius = BorderRadius.circular(40);
  static const EdgeInsets screenPadding = EdgeInsets.all(
    SpacingConsts.screenPadding,
  );
  static const EdgeInsets cardPadding = EdgeInsets.all(
    SpacingConsts.cardPadding,
  );
  static const EdgeInsets defaultPadding = EdgeInsets.all(
    SpacingConsts.defaultPadding,
  );

  static const EdgeInsets tinyPadding = EdgeInsets.all(SpacingConsts.tiny);
  static const EdgeInsets smallPadding = EdgeInsets.all(SpacingConsts.small);
  static const EdgeInsets xsmallPadding = EdgeInsets.all(SpacingConsts.xsmall);
  static const EdgeInsets noPadding = EdgeInsets.zero;

  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double get buttonHeight => 54;
  static double get contHeight => 54;
}
