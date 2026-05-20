import 'package:daily_tarot_focus/features/zodiac/data/i_zodiac_remote_data_source.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_horoscope_request_model.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_horoscope_response_model.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';

class ImplZodiacRepository {
  ImplZodiacRepository(this._zodiacRemoteDataSource);

  Future<FailureOr<HoroscopeResponseModel>> requestGenerateHoroscope({
    required GenerateHoroscopeRequest request,
  }) async {
    try {
      final response = await zodiacRemoteDataSource.requestGenerateHoroscope(request: request);
      return right(response);
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  final IZodiacRemoteDataSource _zodiacRemoteDataSource;
  IZodiacRemoteDataSource get zodiacRemoteDataSource => _zodiacRemoteDataSource;
}
