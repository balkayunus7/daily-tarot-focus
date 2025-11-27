import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/presentation/extensions/build_context_theme_ext.dart';

const String geistFontFamily = 'Geist';

TextStyle geistFontTextStyle(
  BuildContext context, {
  required double fontSize,
  required FontWeight fontWeight,
}) => TextStyle(
  fontFamily: geistFontFamily,
  fontSize: fontSize,
  fontWeight: fontWeight,
  color: context.colors.textPrimary,
);

TextStyle n10w500(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 10, fontWeight: FontWeight.w500);

TextStyle n10w600(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 10, fontWeight: FontWeight.w600);

TextStyle n10w700(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 10, fontWeight: FontWeight.w700);

TextStyle n9w400(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 9, fontWeight: FontWeight.w400);

TextStyle n11w500(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 11, fontWeight: FontWeight.w500);

TextStyle n12w400(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 12, fontWeight: FontWeight.w400);

TextStyle n12w500(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 12, fontWeight: FontWeight.w500);

TextStyle n13w500(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 13, fontWeight: FontWeight.w500);

TextStyle n14w400(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 14, fontWeight: FontWeight.w400);

TextStyle n14w500(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 14, fontWeight: FontWeight.w500);

TextStyle n14w600(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 14, fontWeight: FontWeight.w600);

TextStyle n14w700(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 14, fontWeight: FontWeight.w700);

TextStyle n15w400(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 15, fontWeight: FontWeight.w400);

TextStyle n15w500(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 15, fontWeight: FontWeight.w500);

TextStyle n15w700(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 15, fontWeight: FontWeight.w700);

TextStyle n16w400(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 16, fontWeight: FontWeight.w400);

TextStyle n16w500(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 16, fontWeight: FontWeight.w500);

TextStyle n16w600(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 16, fontWeight: FontWeight.w600);

TextStyle n16w700(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 16, fontWeight: FontWeight.w700);

TextStyle n18w500(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 18, fontWeight: FontWeight.w500);

TextStyle n18w600(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 18, fontWeight: FontWeight.w600);

TextStyle n18w700(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 18, fontWeight: FontWeight.w700);

TextStyle n20w800(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 20, fontWeight: FontWeight.w800);

TextStyle n21w600(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 21, fontWeight: FontWeight.w600);

TextStyle n24w700(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 24, fontWeight: FontWeight.w700);

TextStyle n24w900(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 24, fontWeight: FontWeight.w900);

TextStyle n32w600(BuildContext context) =>
    geistFontTextStyle(context, fontSize: 32, fontWeight: FontWeight.w600);
