import 'package:daily_tarot_focus/features/tarot/domain/models/generate_daily_pick_response_model.dart';
import 'package:mobile_boilerplate/domain/auth/auth_session.dart';

typedef RecordDailyCardRequest = RecordDailyCardRequestModel;

class RecordDailyCardRequestModel {
  const RecordDailyCardRequestModel({
    required this.session,
    required this.cardId,
    this.isReversed,
    this.dailyPick,
    this.locale,
    this.date,
  });

  final AuthSession session;
  final String cardId;
  final bool? isReversed;
  final GenerateDailyPickResponse? dailyPick;
  final String? locale;
  final DateTime? date;

  Map<String, dynamic> toMap() {
    return {
      'card_id': cardId,
      if (isReversed != null) 'is_reversed': isReversed,
      if (locale != null) 'locale': locale,
      if (date != null) 'date': date!.toIso8601String(),
      if (dailyPick != null) ...{
        'general_text': dailyPick!.generalText,
        'daily_advice': dailyPick!.dailyAdvice,
        'categories':
            dailyPick!.categories
                .map(
                  (category) => {
                    'label_key': category.labelKey,
                    'description': category.description,
                  },
                )
                .toList(),
      },
    };
  }
}
