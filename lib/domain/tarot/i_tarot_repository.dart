import 'package:daily_tarot_focus/domain/tarot/daily_tarot_record.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_question_data.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/auth_session.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';

abstract class ITarotRepository {
  Future<FailureOr<Unit>> saveDailyCard({
    required AuthSession session,
    required String cardId,
  });

  Future<FailureOr<List<DailyTarotRecord>>> getDailyCards({
    required AuthSession session,
  });

  Future<FailureOr<Unit>> askQuestion({
    required AuthSession session,
    required TarotQuestionData data,
  });
}
