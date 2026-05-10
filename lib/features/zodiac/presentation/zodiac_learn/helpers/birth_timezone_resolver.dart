import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:timezone/data/latest_all.dart' as tz_data;

class BirthTimezoneResolver {
  const BirthTimezoneResolver._();

  static List<dynamic>? _cache;
  static bool _tzInitialized = false;

  static Future<void> preload() async {
    if (!_tzInitialized) {
      tz_data.initializeTimeZones();
      _tzInitialized = true;
    }
    if (_cache != null) return;
    final raw = await rootBundle
        .loadString('packages/country_state_city/lib/assets/country.json');
    _cache = jsonDecode(raw) as List;
  }

  /// Returns the IANA zone name (e.g. `Europe/Istanbul`) for the city, picking
  /// the entry whose standard-time offset is nearest to longitude/15 within the
  /// country's timezone list. Used by the timezone package to compute a fully
  /// DST-aware UTC conversion at the birth date.
  static String? zoneName({
    required String countryIsoCode,
    required double longitude,
  }) {
    final countries = _cache;
    if (countries == null) return null;
    Map<String, dynamic>? country;
    for (final c in countries) {
      if ((c as Map<String, dynamic>)['isoCode'] == countryIsoCode) {
        country = c;
        break;
      }
    }
    if (country == null) return null;
    final tzs = country['timezones'] as List?;
    if (tzs == null || tzs.isEmpty) return null;
    if (tzs.length == 1) {
      return (tzs.first as Map<String, dynamic>)['zoneName'] as String?;
    }
    final targetHours = longitude / 15.0;
    String? bestName;
    var bestDelta = double.infinity;
    for (final tz in tzs) {
      final entry = tz as Map<String, dynamic>;
      final offset = entry['gmtOffset'] as int?;
      final name = entry['zoneName'] as String?;
      if (offset == null || name == null) continue;
      final delta = (offset / 3600.0 - targetHours).abs();
      if (delta < bestDelta) {
        bestDelta = delta;
        bestName = name;
      }
    }
    return bestName;
  }
}
