import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_compatibility_request_model.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_compatibility_response_model.dart';

abstract class IZodiacRemoteDataSource {
  Future<GenerateCompatibilityResponse> requestGenerateCompatibility({
    required GenerateCompatibilityRequest request,
  });
}
