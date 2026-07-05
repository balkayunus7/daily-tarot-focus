class UserLocationInfo {
  const UserLocationInfo({
    required this.name,
    this.latitude,
    this.longitude,
    this.zoneName,
  });

  final String name;
  final double? latitude;
  final double? longitude;
  final String? zoneName;

  bool get hasCoordinates => latitude != null && longitude != null;
}

/// The backend `location` column is a single string. New records embed the
/// coordinates picked at registration as `name|lat,lon|zoneName`; legacy
/// records hold only the plain city name. [decode] accepts both.
class UserLocationCodec {
  const UserLocationCodec._();

  static const _separator = '|';

  static String encode({
    required String name,
    required double latitude,
    required double longitude,
    String? zoneName,
  }) {
    return [name, '$latitude,$longitude', zoneName ?? ''].join(_separator);
  }

  static UserLocationInfo decode(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return const UserLocationInfo(name: '');
    }
    final parts = raw.split(_separator);
    final name = parts.first.trim();
    if (parts.length < 2) return UserLocationInfo(name: name);

    double? latitude;
    double? longitude;
    final coords = parts[1].split(',');
    if (coords.length == 2) {
      latitude = double.tryParse(coords[0]);
      longitude = double.tryParse(coords[1]);
    }
    final zoneName = parts.length > 2 && parts[2].trim().isNotEmpty ? parts[2].trim() : null;
    if (latitude == null || longitude == null) {
      return UserLocationInfo(name: name, zoneName: zoneName);
    }
    return UserLocationInfo(
      name: name,
      latitude: latitude,
      longitude: longitude,
      zoneName: zoneName,
    );
  }

  static String displayName(String? raw) => decode(raw).name;
}
