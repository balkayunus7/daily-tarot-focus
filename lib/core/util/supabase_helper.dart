import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/tarot_session.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';
import 'package:supabase/supabase.dart';

extension SupabaseHelper on SupabaseClient {
  Future<FailureOr<FunctionResponse>> secureInvoke({
    required String route,
    required TarotSession session,
    Object? body,
    HttpMethod method = HttpMethod.get,
  }) async {
    if (session.idToken.isEmpty) return left(const UnknownFailure());

    return right(
      await functions.invoke(
        route,
        method: method,
        headers: {'authorization': 'Bearer ${session.idToken}'},
        body: body,
      ),
    );
  }
}
