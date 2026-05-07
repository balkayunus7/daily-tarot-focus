import 'package:daily_tarot_focus/features/zodiac/data/i_zodiac_remote_data_source.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_compatibility_request_model.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_compatibility_response_model.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';

class ImplZodiacRepository {
  ImplZodiacRepository(this._zodiacRemoteDataSource);

  final IZodiacRemoteDataSource _zodiacRemoteDataSource;

  Future<FailureOr<GenerateCompatibilityResponse>> requestGenerateCompatibility({
    required GenerateCompatibilityRequest request,
  }) async {
    try {
      final response = await _zodiacRemoteDataSource.requestGenerateCompatibility(request: request);
      return right(response);
    } on Exception {
      return left(const UnknownFailure());
    }
  }
}
