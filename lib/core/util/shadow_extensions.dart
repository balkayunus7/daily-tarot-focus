import 'package:flutter/material.dart';

// This extension is used to get the shadow of a color.
extension ShadowExtensions on Color {
  List<BoxShadow> get softShadow => AppShadows.soft(this);
  List<BoxShadow> get mediumShadow => AppShadows.medium(this);
  List<BoxShadow> get hardShadow => AppShadows.high(this);
  List<BoxShadow> get glowShadow => AppShadows.glow(this);
  List<BoxShadow> get cardShadow => AppShadows.card(this);

  List<BoxShadow> customShadow({
    double alpha = 0.2,
    double blurRadius = 12,
    double spreadRadius = 2,
    Offset offset = const Offset(0, 4),
  }) => AppShadows.custom(
    this,
    alpha: alpha,
    blurRadius: blurRadius,
    spreadRadius: spreadRadius,
    offset: offset,
  );
}

class AppShadows {
  AppShadows._();

  /// Soft elevation shadows
  static List<BoxShadow> soft(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.1),
      blurRadius: 8,
      spreadRadius: 1,
      offset: const Offset(0, 2),
    ),
  ];

  /// Medium elevation shadows
  static List<BoxShadow> medium(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.15),
      blurRadius: 10,
      spreadRadius: 2,
      offset: const Offset(0, 3),
    ),
    BoxShadow(
      color: color.withValues(alpha: 0.1),
      blurRadius: 6,
      spreadRadius: 1,
      offset: const Offset(0, 1),
    ),
  ];

  /// High elevation shadows
  static List<BoxShadow> high(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.2),
      blurRadius: 16,
      spreadRadius: 3,
      offset: const Offset(0, 6),
    ),
    BoxShadow(
      color: color.withValues(alpha: 0.12),
      blurRadius: 8,
      spreadRadius: 2,
      offset: const Offset(0, 2),
    ),
  ];

  /// Glow effect (no offset)
  static List<BoxShadow> glow(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.5),
      blurRadius: 20,
      spreadRadius: 5,
    ),
  ];

  /// Card shadow
  static List<BoxShadow> card(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.5),
      blurRadius: 20,
      spreadRadius: 5,
    ),
  ];

  /// Custom shadow
  static List<BoxShadow> custom(
    Color color, {
    double alpha = 0.2,
    double blurRadius = 12,
    double spreadRadius = 2,
    Offset offset = const Offset(0, 4),
  }) => [
    BoxShadow(
      color: color.withValues(alpha: alpha),
      blurRadius: blurRadius,
      spreadRadius: spreadRadius,
      offset: offset,
    ),
  ];
}
