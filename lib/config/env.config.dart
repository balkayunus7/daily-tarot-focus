import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static final EnvConfig _instance = EnvConfig._internal();
  factory EnvConfig() => _instance;

  EnvConfig._internal();

  static Future<void> load() async {
    await dotenv.load(fileName: ".env.keys");
  }

  String get(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw Exception("Missing environment variable: $key");
    }
    return value;
  }

  String get revenuecatApiKey => get('REVENUECAT_API_KEY');
  String get adjustSdkKey => get('ADJUST_SDK_KEY');
}
