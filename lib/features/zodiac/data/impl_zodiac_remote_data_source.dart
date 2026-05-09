import 'package:daily_tarot_focus/core/util/supabase_helper.dart';
import 'package:daily_tarot_focus/core/util/tarot_routes.dart';
import 'package:daily_tarot_focus/features/zodiac/data/i_zodiac_remote_data_source.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_compatibility_request_model.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_compatibility_response_model.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_horoscope_request_model.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_horoscope_response_model.dart';
import 'package:mobile_boilerplate/domain/common/http_utilities.dart';
import 'package:mobile_boilerplate/extensions.dart';
import 'package:supabase/supabase.dart' hide Session;

class ImplZodiacRemoteDataSource implements IZodiacRemoteDataSource {
  ImplZodiacRemoteDataSource(this._supabaseClient);

  final SupabaseClient _supabaseClient;
  SupabaseClient get supabaseClient => _supabaseClient;

  @override
  Future<GenerateCompatibilityResponse> requestGenerateCompatibility({
    required GenerateCompatibilityRequest request,
  }) async {
    final responseOrFail = await supabaseClient.secureInvoke(
      route: GENERATE_COMPATIBILITY,
      method: HttpMethod.post,
      body: request.toMap(),
      session: request.session,
    );

    if (responseOrFail.isLeft()) throw Exception();

    final response = responseOrFail.getRightOrCrash();
    return GenerateCompatibilityResponse.fromMap(decodeSupabaseResponse(response.data));
  }

  @override
  Future<HoroscopeResponseModel> requestGenerateHoroscope({
    required GenerateHoroscopeRequest request,
  }) async {
    final responseOrFail = await supabaseClient.secureInvoke(
      route: GENERATE_HOROSCOPE,
      method: HttpMethod.post,
      body: request.toMap(),
      session: request.session,
    );

    if (responseOrFail.isLeft()) throw Exception();

    final response = responseOrFail.getRightOrCrash();
    return HoroscopeResponseModel.fromMap(decodeSupabaseResponse(response.data));
  }
}
