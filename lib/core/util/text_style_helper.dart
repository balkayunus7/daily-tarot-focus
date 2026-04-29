import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

const String montserratFontFamily = 'Montserrat';

TextStyle buildTextStyle(
  BuildContext context, {
  required double fontSize,
  required FontWeight fontWeight,
}) => TextStyle(
  fontFamily: montserratFontFamily,
  fontSize: fontSize,
  fontWeight: fontWeight,
  color: context.colors.textPrimary,
);

TextStyle m8w400(BuildContext context) =>
    buildTextStyle(context, fontSize: 8, fontWeight: FontWeight.w400);

TextStyle m8w700(BuildContext context) =>
    buildTextStyle(context, fontSize: 8, fontWeight: FontWeight.w700);

TextStyle m9w400(BuildContext context) =>
    buildTextStyle(context, fontSize: 9, fontWeight: FontWeight.w400);

TextStyle m9w700(BuildContext context) =>
    buildTextStyle(context, fontSize: 9, fontWeight: FontWeight.w700);

TextStyle m10w400(BuildContext context) =>
    buildTextStyle(context, fontSize: 10, fontWeight: FontWeight.w400);

TextStyle m10w500(BuildContext context) =>
    buildTextStyle(context, fontSize: 10, fontWeight: FontWeight.w500);

TextStyle m10w600(BuildContext context) =>
    buildTextStyle(context, fontSize: 10, fontWeight: FontWeight.w600);

TextStyle m10w700(BuildContext context) =>
    buildTextStyle(context, fontSize: 10, fontWeight: FontWeight.w700);

TextStyle m11w400(BuildContext context) =>
    buildTextStyle(context, fontSize: 11, fontWeight: FontWeight.w400);

TextStyle m11w500(BuildContext context) =>
    buildTextStyle(context, fontSize: 11, fontWeight: FontWeight.w500);

TextStyle m12w400(BuildContext context) =>
    buildTextStyle(context, fontSize: 12, fontWeight: FontWeight.w400);

TextStyle m12w500(BuildContext context) =>
    buildTextStyle(context, fontSize: 12, fontWeight: FontWeight.w500);

TextStyle m12w600(BuildContext context) =>
    buildTextStyle(context, fontSize: 12, fontWeight: FontWeight.w600);

TextStyle m13w400(BuildContext context) =>
    buildTextStyle(context, fontSize: 13, fontWeight: FontWeight.w400);

TextStyle m13w500(BuildContext context) =>
    buildTextStyle(context, fontSize: 13, fontWeight: FontWeight.w500);

TextStyle m14w400(BuildContext context) =>
    buildTextStyle(context, fontSize: 14, fontWeight: FontWeight.w400);

TextStyle m14w500(BuildContext context) =>
    buildTextStyle(context, fontSize: 14, fontWeight: FontWeight.w500);

TextStyle m14w600(BuildContext context) =>
    buildTextStyle(context, fontSize: 14, fontWeight: FontWeight.w600);

TextStyle m14w700(BuildContext context) =>
    buildTextStyle(context, fontSize: 14, fontWeight: FontWeight.w700);

TextStyle m15w400(BuildContext context) =>
    buildTextStyle(context, fontSize: 15, fontWeight: FontWeight.w400);

TextStyle m15w500(BuildContext context) =>
    buildTextStyle(context, fontSize: 15, fontWeight: FontWeight.w500);

TextStyle m15w600(BuildContext context) =>
    buildTextStyle(context, fontSize: 15, fontWeight: FontWeight.w600);

TextStyle m15w700(BuildContext context) =>
    buildTextStyle(context, fontSize: 15, fontWeight: FontWeight.w700);

TextStyle m16w400(BuildContext context) =>
    buildTextStyle(context, fontSize: 16, fontWeight: FontWeight.w400);

TextStyle m16w500(BuildContext context) =>
    buildTextStyle(context, fontSize: 16, fontWeight: FontWeight.w500);

TextStyle m16w600(BuildContext context) =>
    buildTextStyle(context, fontSize: 16, fontWeight: FontWeight.w600);

TextStyle m16w700(BuildContext context) =>
    buildTextStyle(context, fontSize: 16, fontWeight: FontWeight.w700);

TextStyle m17w700(BuildContext context) =>
    buildTextStyle(context, fontSize: 17, fontWeight: FontWeight.w700);

TextStyle m18w500(BuildContext context) =>
    buildTextStyle(context, fontSize: 18, fontWeight: FontWeight.w500);

TextStyle m18w600(BuildContext context) =>
    buildTextStyle(context, fontSize: 18, fontWeight: FontWeight.w600);

TextStyle m18w700(BuildContext context) =>
    buildTextStyle(context, fontSize: 18, fontWeight: FontWeight.w700);

TextStyle m20w600(BuildContext context) =>
    buildTextStyle(context, fontSize: 20, fontWeight: FontWeight.w600);

TextStyle m20w700(BuildContext context) =>
    buildTextStyle(context, fontSize: 20, fontWeight: FontWeight.w700);

TextStyle m20w800(BuildContext context) =>
    buildTextStyle(context, fontSize: 20, fontWeight: FontWeight.w800);

TextStyle m21w600(BuildContext context) =>
    buildTextStyle(context, fontSize: 21, fontWeight: FontWeight.w600);

TextStyle m24w600(BuildContext context) =>
    buildTextStyle(context, fontSize: 24, fontWeight: FontWeight.w600);

TextStyle m24w700(BuildContext context) =>
    buildTextStyle(context, fontSize: 24, fontWeight: FontWeight.w700);

TextStyle m24w900(BuildContext context) =>
    buildTextStyle(context, fontSize: 24, fontWeight: FontWeight.w900);

TextStyle m26w600(BuildContext context) =>
    buildTextStyle(context, fontSize: 26, fontWeight: FontWeight.w600);

TextStyle m28w600(BuildContext context) =>
    buildTextStyle(context, fontSize: 28, fontWeight: FontWeight.w600);

TextStyle m32w600(BuildContext context) =>
    buildTextStyle(context, fontSize: 32, fontWeight: FontWeight.w600);

TextStyle m38w400(BuildContext context) =>
    buildTextStyle(context, fontSize: 38, fontWeight: FontWeight.w400);

TextStyle m64w700(BuildContext context) =>
    buildTextStyle(context, fontSize: 64, fontWeight: FontWeight.w700);
