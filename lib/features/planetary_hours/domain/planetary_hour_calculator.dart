import 'dart:math';

import 'package:timezone/timezone.dart' as tz;

enum PlanetaryRuler {
  sun,
  moon,
  mars,
  mercury,
  jupiter,
  venus,
  saturn;

  String get symbol {
    switch (this) {
      case PlanetaryRuler.sun:
        return 'S';
      case PlanetaryRuler.moon:
        return 'M';
      case PlanetaryRuler.mars:
        return 'Ma';
      case PlanetaryRuler.mercury:
        return 'Me';
      case PlanetaryRuler.jupiter:
        return 'J';
      case PlanetaryRuler.venus:
        return 'V';
      case PlanetaryRuler.saturn:
        return 'Sa';
    }
  }
}

class PlanetaryHour {
  const PlanetaryHour({
    required this.ruler,
    required this.start,
    required this.end,
    required this.index,
    required this.isDaylight,
  });

  final PlanetaryRuler ruler;
  final DateTime start;
  final DateTime end;
  final int index;
  final bool isDaylight;

  bool contains(DateTime date) =>
      !date.isBefore(start) && date.isBefore(end);
}

class PlanetaryHourSchedule {
  const PlanetaryHourSchedule({
    required this.date,
    required this.sunrise,
    required this.sunset,
    required this.hours,
    required this.dayRuler,
    required this.zoneName,
  });

  final DateTime date;
  final DateTime sunrise;
  final DateTime sunset;
  final List<PlanetaryHour> hours;
  final PlanetaryRuler dayRuler;
  final String? zoneName;

  PlanetaryHour currentHour(DateTime now) {
    final direct = hours.where((hour) => hour.contains(now)).firstOrNull;
    if (direct != null) return direct;
    if (now.isBefore(hours.first.start)) return hours.first;
    return hours.last;
  }
}

class PlanetaryHourCalculator {
  const PlanetaryHourCalculator._();

  static const List<PlanetaryRuler> _chaldeanOrder = [
    PlanetaryRuler.saturn,
    PlanetaryRuler.jupiter,
    PlanetaryRuler.mars,
    PlanetaryRuler.sun,
    PlanetaryRuler.venus,
    PlanetaryRuler.mercury,
    PlanetaryRuler.moon,
  ];

  static PlanetaryHourSchedule calculate({
    required DateTime date,
    required double latitude,
    required double longitude,
    String? zoneName,
  }) {
    final location = _safeLocation(zoneName);
    final localDate = _localDate(date, location);
    final today = DateTime(localDate.year, localDate.month, localDate.day);
    final tomorrow = today.add(const Duration(days: 1));

    final sunriseUtc = _solarEventUtc(
      date: today,
      latitude: latitude,
      longitude: longitude,
      isSunrise: true,
    );
    final sunsetUtc = _solarEventUtc(
      date: today,
      latitude: latitude,
      longitude: longitude,
      isSunrise: false,
    );
    final nextSunriseUtc = _solarEventUtc(
      date: tomorrow,
      latitude: latitude,
      longitude: longitude,
      isSunrise: true,
    );

    final sunrise = _fromUtc(sunriseUtc, location);
    final sunset = _fromUtc(sunsetUtc, location);
    final nextSunrise = _fromUtc(nextSunriseUtc, location);

    final dayRuler = _dayRuler(localDate.weekday);
    final startIndex = _chaldeanOrder.indexOf(dayRuler);
    final dayLength = sunset.difference(sunrise);
    final nightLength = nextSunrise.difference(sunset);
    final dayHour = Duration(
      milliseconds: (dayLength.inMilliseconds / 12).round(),
    );
    final nightHour = Duration(
      milliseconds: (nightLength.inMilliseconds / 12).round(),
    );

    final hours = <PlanetaryHour>[
      for (var i = 0; i < 12; i++)
        PlanetaryHour(
          ruler: _chaldeanOrder[(startIndex + i) % _chaldeanOrder.length],
          start: sunrise.add(dayHour * i),
          end: i == 11 ? sunset : sunrise.add(dayHour * (i + 1)),
          index: i + 1,
          isDaylight: true,
        ),
      for (var i = 0; i < 12; i++)
        PlanetaryHour(
          ruler: _chaldeanOrder[(startIndex + 12 + i) % _chaldeanOrder.length],
          start: sunset.add(nightHour * i),
          end: i == 11 ? nextSunrise : sunset.add(nightHour * (i + 1)),
          index: i + 13,
          isDaylight: false,
        ),
    ];

    return PlanetaryHourSchedule(
      date: localDate,
      sunrise: sunrise,
      sunset: sunset,
      hours: hours,
      dayRuler: dayRuler,
      zoneName: zoneName,
    );
  }

  static PlanetaryRuler _dayRuler(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return PlanetaryRuler.moon;
      case DateTime.tuesday:
        return PlanetaryRuler.mars;
      case DateTime.wednesday:
        return PlanetaryRuler.mercury;
      case DateTime.thursday:
        return PlanetaryRuler.jupiter;
      case DateTime.friday:
        return PlanetaryRuler.venus;
      case DateTime.saturday:
        return PlanetaryRuler.saturn;
      case DateTime.sunday:
      default:
        return PlanetaryRuler.sun;
    }
  }

  static tz.Location? _safeLocation(String? zoneName) {
    if (zoneName == null || zoneName.isEmpty) return null;
    try {
      return tz.getLocation(zoneName);
    } on Object catch (_) {
      return null;
    }
  }

  static DateTime _localDate(DateTime date, tz.Location? location) {
    if (location == null) return date;
    return tz.TZDateTime.from(date.toUtc(), location);
  }

  static DateTime _fromUtc(DateTime utc, tz.Location? location) {
    if (location == null) return utc.toLocal();
    return tz.TZDateTime.from(utc, location);
  }

  static DateTime _solarEventUtc({
    required DateTime date,
    required double latitude,
    required double longitude,
    required bool isSunrise,
  }) {
    final day = _dayOfYear(date);
    final lngHour = longitude / 15;
    final targetHour = isSunrise ? 6 : 18;
    final t = day + ((targetHour - lngHour) / 24);
    final meanAnomaly = _normalizeDegrees(0.9856 * t - 3.289);
    final trueLongitude = _normalizeDegrees(
      meanAnomaly +
          1.916 * sin(_degToRad(meanAnomaly)) +
          0.020 * sin(2 * _degToRad(meanAnomaly)) +
          282.634,
    );

    var rightAscension = _radToDeg(
      atan(0.91764 * tan(_degToRad(trueLongitude))),
    );
    rightAscension = _normalizeDegrees(rightAscension);
    final longitudeQuadrant = (trueLongitude / 90).floor() * 90;
    final ascensionQuadrant = (rightAscension / 90).floor() * 90;
    rightAscension = (rightAscension + longitudeQuadrant - ascensionQuadrant) / 15;

    final sinDeclination = 0.39782 * sin(_degToRad(trueLongitude));
    final cosDeclination = cos(asin(sinDeclination));
    final cosHourAngle =
        (cos(_degToRad(90.833)) -
            sinDeclination * sin(_degToRad(latitude))) /
        (cosDeclination * cos(_degToRad(latitude)));

    final safeCosHourAngle = cosHourAngle.clamp(-1.0, 1.0);
    final hourAngle =
        (isSunrise
            ? 360 - _radToDeg(acos(safeCosHourAngle))
            : _radToDeg(acos(safeCosHourAngle))) /
        15;

    final localMeanTime =
        hourAngle + rightAscension - 0.06571 * t - 6.622;
    final utcHour = _normalizeHours(localMeanTime - lngHour);

    final hour = utcHour.floor();
    final minuteDecimal = (utcHour - hour) * 60;
    final minute = minuteDecimal.floor();
    final second = ((minuteDecimal - minute) * 60).round();

    return DateTime.utc(date.year, date.month, date.day, hour, minute, second);
  }

  static int _dayOfYear(DateTime date) =>
      date.difference(DateTime(date.year)).inDays + 1;

  static double _normalizeDegrees(double value) {
    var normalized = value % 360;
    if (normalized < 0) normalized += 360;
    return normalized;
  }

  static double _normalizeHours(double value) {
    var normalized = value % 24;
    if (normalized < 0) normalized += 24;
    return normalized;
  }

  static double _degToRad(double degrees) => degrees * pi / 180;
  static double _radToDeg(double radians) => radians * 180 / pi;
}
