import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PlanetaryLocationModel {
  const PlanetaryLocationModel({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.zoneName,
  });

  factory PlanetaryLocationModel.fromMap(Map<String, dynamic> map) {
    return PlanetaryLocationModel(
      name: map['name'] as String,
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      zoneName: map['zone_name'] as String?,
    );
  }

  final String name;
  final double latitude;
  final double longitude;
  final String? zoneName;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      if (zoneName != null) 'zone_name': zoneName,
    };
  }
}

class PlanetaryLocationService {
  const PlanetaryLocationService._();

  static const _key = 'planetary_hours.location';

  static Future<PlanetaryLocationModel?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    try {
      return PlanetaryLocationModel.fromMap(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } on Object catch (_) {
      return null;
    }
  }

  static Future<void> save(PlanetaryLocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(location.toMap()));
  }
}
