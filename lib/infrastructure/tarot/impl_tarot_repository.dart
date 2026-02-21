import 'package:daily_tarot_focus/core/util/supabase_helper.dart';
import 'package:daily_tarot_focus/core/util/tarot_routes.dart';
import 'package:daily_tarot_focus/domain/tarot/daily_tarot_record.dart';
import 'package:daily_tarot_focus/domain/tarot/i_tarot_repository.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/session.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';
import 'package:mobile_boilerplate/domain/common/http_utilities.dart';
import 'package:mobile_boilerplate/extensions.dart';
import 'package:mobile_boilerplate/infrastructure/http/http_failure_handler.dart';
import 'package:supabase/supabase.dart' hide Session;

class ImplTarotRepository extends ITarotRepository with HttpFailureHandlerMixin {
  ImplTarotRepository(this._supabaseClient, this._httpFailureHandler);

  @override
  Future<FailureOr<Unit>> saveDailyCard({
    required Session session,
    required String cardId,
  }) async {
    try {
      final responseOrFail = await supabaseClient.secureInvoke(
        route: SAVE_DAILY_CARD,
        method: HttpMethod.post,
        body: {'card_id': cardId},
      );
      if (responseOrFail.isLeft()) return left(const UnknownFailure());
      final response = responseOrFail.getRightOrCrash();

      final data = decodeSupabaseResponse(response.data);
      final generalFailure = handleResult(response.status, data);
      if (generalFailure != null) return left(generalFailure);

      return right(unit);
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  @override
  Future<FailureOr<List<DailyTarotRecord>>> getDailyCards({
    required Session session,
  }) async {
    try {
      final responseOrFail = await supabaseClient.secureInvoke(route: GET_DAILY_CARDS);
      if (responseOrFail.isLeft()) return left(const UnknownFailure());
      final response = responseOrFail.getRightOrCrash();

      final data = response.data;
      final records =
          (data as List)
              .map((item) => DailyTarotRecord.fromMap(item as Map<String, dynamic>))
              .toList();

      return right(records);
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  final SupabaseClient _supabaseClient;
  final HttpFailureHandler _httpFailureHandler;

  @override
  HttpFailureHandler get httpFailureHandler => _httpFailureHandler;
  SupabaseClient get supabaseClient => _supabaseClient;
}
