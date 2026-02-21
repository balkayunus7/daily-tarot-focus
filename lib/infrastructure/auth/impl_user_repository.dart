import 'package:daily_tarot_focus/core/util/supabase_helper.dart';
import 'package:daily_tarot_focus/core/util/tarot_routes.dart';
import 'package:daily_tarot_focus/domain/auth/tarot_user.dart';
import 'package:daily_tarot_focus/domain/auth/tarot_user_properties.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/i_user_repository.dart';
import 'package:mobile_boilerplate/domain/auth/session.dart';
import 'package:mobile_boilerplate/domain/auth/user.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';
import 'package:mobile_boilerplate/domain/common/http_utilities.dart';
import 'package:mobile_boilerplate/extensions.dart';
import 'package:mobile_boilerplate/infrastructure/http/http_failure_handler.dart';
import 'package:supabase/supabase.dart' hide Session, User;

class ImplUserRepository extends IUserRepository with HttpFailureHandlerMixin {
  ImplUserRepository(this._supabaseClient, this._httpFailureHandler);

  @override
  Future<FailureOr<User>> getUser({required Session session}) async {
    try {
      final responseOrFail = await supabaseClient.secureInvoke(route: GET_USER);
      if (responseOrFail.isLeft()) return left(const UnknownFailure());
      final response = responseOrFail.getRightOrCrash();

      final data = decodeSupabaseResponse(response.data);
      final user = TarotUser.fromMap(data);

      return right(user);
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  @override
  Future<FailureOr<Unit>> deleteUser({required Session session}) async {
    try {
      return right(unit);
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  @override
  Future<FailureOr<Unit>> setFcmToken({
    required Session session,
    required String fcmToken,
  }) async {
    return right(unit);
  }

  @override
  Future<FailureOr<Unit>> updateUser({
    required Session session,
    required covariant TarotUserProperties properties,
  }) async {
    try {
      final responseOrFail = await supabaseClient.secureInvoke(
        route: UPDATE_USER,
        body: properties.toMap(),
        method: HttpMethod.patch,
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

  final HttpFailureHandler _httpFailureHandler;
  final SupabaseClient _supabaseClient;

  @override
  HttpFailureHandler get httpFailureHandler => _httpFailureHandler;
  SupabaseClient get supabaseClient => _supabaseClient;
}
