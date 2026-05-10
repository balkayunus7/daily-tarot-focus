import 'dart:math';

import 'package:daily_tarot_focus/core/util/locale_keys.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_zodiac_enum.dart';
import 'package:easy_localization/easy_localization.dart';

enum DiscoverZodiacType { moon, rising }

extension DiscoverZodiacTypeExt on DiscoverZodiacType {
  bool get isRising => this == DiscoverZodiacType.rising;
  bool get isMoon => this == DiscoverZodiacType.moon;

  String get title {
    switch (this) {
      case DiscoverZodiacType.rising:
        return LocaleKeys.zodiac_page_discover_rising.tr();
      case DiscoverZodiacType.moon:
        return LocaleKeys.zodiac_page_discover_moon.tr();
    }
  }

  String get description {
    switch (this) {
      case DiscoverZodiacType.rising:
        return LocaleKeys.zodiac_page_desc_rising.tr();
      case DiscoverZodiacType.moon:
        return LocaleKeys.zodiac_page_desc_moon.tr();
    }
  }
}

class ZodiacLearnHelper {
  const ZodiacLearnHelper._();

  static ZodiacSign moonSign(DateTime birthDateTimeUtc) {
    final jd = _julianDay(birthDateTimeUtc);
    final longitude = _moonLongitude(jd);
    return _longitudeToSign(longitude);
  }

  static ZodiacSign risingSign(
    DateTime birthDateTimeUtc,
    double latitude,
    double longitude,
  ) {
    final jd = _julianDay(birthDateTimeUtc);
    final asc = _ascendant(jd, latitude, longitude);
    return _longitudeToSign(asc);
  }

  static double _julianDay(DateTime utc) {
    var y = utc.year;
    var m = utc.month;
    final d = utc.day + (utc.hour + (utc.minute + utc.second / 60.0) / 60.0) / 24.0;
    if (m <= 2) {
      y--;
      m += 12;
    }
    final a = y ~/ 100;
    final b = 2 - a + (a ~/ 4);
    return (365.25 * (y + 4716)).floor() + (30.6001 * (m + 1)).floor() + d + b - 1524.5;
  }

  static double _moonLongitude(double jd) {
    final t = (jd - 2451545.0) / 36525.0;

    final l0 = _norm(
      218.3164477 +
          481267.88123421 * t -
          0.0015786 * t * t +
          t * t * t / 538841.0 -
          t * t * t * t / 65194000.0,
    );
    final d = _rad(
      _norm(
        297.8501921 +
            445267.1114034 * t -
            0.0018819 * t * t +
            t * t * t / 545868.0 -
            t * t * t * t / 113065000.0,
      ),
    );
    final mSun = _rad(
      _norm(
        357.5291092 + 35999.0502909 * t - 0.0001536 * t * t + t * t * t / 24490000.0,
      ),
    );
    final mMoon = _rad(
      _norm(
        134.9633964 +
            477198.8675055 * t +
            0.0087414 * t * t +
            t * t * t / 69699.0 -
            t * t * t * t / 14712000.0,
      ),
    );
    final f = _rad(
      _norm(
        93.2720950 +
            483202.0175233 * t -
            0.0036539 * t * t -
            t * t * t / 3526000.0 +
            t * t * t * t / 863310000.0,
      ),
    );
    final e = 1.0 - 0.002516 * t - 0.0000074 * t * t;

    // Table 47.A main terms: [D_mul, M_mul, M'_mul, F_mul, sigma_l * 1e6]
    const terms = [
      [0, 0, 1, 0, 6288774],
      [2, 0, -1, 0, 1274027],
      [2, 0, 0, 0, 658314],
      [0, 0, 2, 0, 213618],
      [0, -1, 0, 0, -185116],
      [0, 0, 0, 2, -114332],
      [2, 0, -2, 0, 58793],
      [2, -1, -1, 0, 57066],
      [2, 0, 1, 0, 53322],
      [2, -1, 0, 0, 45758],
      [0, 1, -1, 0, -40923],
      [1, 0, 0, 0, 34720],
      [0, 1, 1, 0, 30403],
      [2, 0, 0, -2, 15327],
      [0, 0, 1, 2, -12528],
      [0, 0, 1, -2, 10980],
      [4, 0, -1, 0, 10675],
      [0, 0, 3, 0, 10034],
      [4, 0, -2, 0, 8548],
      [2, 1, -1, 0, -7888],
      [2, 1, 0, 0, -6766],
      [1, 0, -1, 0, -5163],
      [1, 1, 0, 0, 4987],
      [2, -1, 1, 0, 4036],
      [2, 0, 2, 0, 3994],
      [4, 0, 0, 0, 3861],
      [2, 0, -3, 0, 3665],
      [0, 1, -2, 0, -2689],
      [2, 0, -1, 2, -2602],
      [2, -1, -2, 0, 2390],
    ];

    var sigmaL = 0.0;
    for (final termRow in terms) {
      final arg = termRow[0] * d + termRow[1] * mSun + termRow[2] * mMoon + termRow[3] * f;
      var coeff = termRow[4].toDouble();
      final mAbs = termRow[1].abs();
      if (mAbs == 1) coeff *= e;
      if (mAbs == 2) coeff *= e * e;
      sigmaL += coeff * sin(arg);
    }

    return _norm(l0 + sigmaL * 1e-6);
  }

  static double _ascendant(double jd, double lat, double lon) {
    final t = (jd - 2451545.0) / 36525.0;
    final gmst = _norm(
      280.46061837 +
          360.98564736629 * (jd - 2451545.0) +
          0.000387933 * t * t -
          t * t * t / 38710000.0,
    );
    final ramc = _rad(_norm(gmst + lon));
    final eps = _rad(23.439291111 - 0.013004167 * t);
    final latR = _rad(lat.clamp(-89.9, 89.9));
    final num = -cos(ramc);
    final den = sin(ramc) * cos(eps) + tan(latR) * sin(eps);
    var asc = _deg(atan2(num, den));
    // atan2 returns one of two roots 180° apart; pick the eastern (rising) one.
    // Derived condition: atan2 root is the descendant when cos(ε) + sin(ε)·tan(φ)·sin(RAMC) > 0.
    if (cos(eps) + sin(eps) * tan(latR) * sin(ramc) > 0) {
      asc += 180;
    }
    return _norm(asc);
  }

  static ZodiacSign _longitudeToSign(double lon) => ZodiacSign.values[(lon / 30).floor() % 12];

  static double _norm(double d) {
    final normalized = d % 360;
    return normalized < 0 ? normalized + 360 : normalized;
  }

  static double _rad(double d) => d * pi / 180.0;
  static double _deg(double r) => r * 180.0 / pi;
}
