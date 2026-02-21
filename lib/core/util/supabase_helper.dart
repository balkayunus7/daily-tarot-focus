import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';
import 'package:supabase/supabase.dart';

extension SupabaseHelper on SupabaseClient {
  String? get _liveToken => auth.currentSession?.accessToken;

  Future<FailureOr<FunctionResponse>> secureInvoke({
    required String route,
    Object? body,
    HttpMethod method = HttpMethod.get,
  }) async {
    if (_liveToken == null) return left(const UnknownFailure());

    return right(
      await functions.invoke(
        route,
        method: method,
        headers: {'authorization': 'Bearer $_liveToken'},
        body: body,
      ),
    );
  }
}
