import 'package:daily_tarot_focus/domain/auth/lyrics_user.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/i_user_repository.dart';
import 'package:mobile_boilerplate/domain/auth/session.dart';
import 'package:mobile_boilerplate/domain/auth/user.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';
import 'package:mobile_boilerplate/infrastructure/http/http_failure_handler.dart';
import 'package:supabase/supabase.dart' hide User, Session;

class ImplUserRepository extends IUserRepository with HttpFailureHandlerMixin {
  ImplUserRepository(this._supabaseClient, this._httpFailureHandler);

  @override
  Future<FailureOr<User>> getUser({required Session session}) async {
    try {
      final response =
          await supabaseClient
              .from('users')
              .select()
              .eq('user_id', session.userId)
              .single();

      return right(LyricsUser.fromMap(response));
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        return left(const NotFoundFailure());
      }
      return left(UnknownFailure());
    } catch (e) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<FailureOr<Unit>> deleteUser({required Session session}) async {
    try {
      return right(unit);
    } catch (e) {
      return left(UnknownFailure());
    }
  }

  @override
  Future<FailureOr<Unit>> setFcmToken({
    required Session session,
    required String fcmToken,
  }) async {
    try {
      await supabaseClient
          .from('users')
          .update({'firebase_token': fcmToken})
          .eq('user_id', session.userId);

      return right(unit);
    } catch (e) {
      return left(UnknownFailure());
    }
  }

  final HttpFailureHandler _httpFailureHandler;
  final SupabaseClient _supabaseClient;

  @override
  HttpFailureHandler get httpFailureHandler => _httpFailureHandler;
  SupabaseClient get supabaseClient => _supabaseClient;
}
