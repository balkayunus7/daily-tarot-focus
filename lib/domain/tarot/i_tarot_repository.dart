import 'package:daily_tarot_focus/domain/tarot/daily_tarot_record.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/tarot_session.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';

abstract class ITarotRepository {
  Future<FailureOr<Unit>> saveDailyCard({
    required TarotSession session,
    required String cardId,
  });

  Future<FailureOr<List<DailyTarotRecord>>> getDailyCards({
    required TarotSession session,
  });
}
