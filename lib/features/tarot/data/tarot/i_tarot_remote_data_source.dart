import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_daily_cards_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_daily_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/reading_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/reading_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/record_daily_card_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/record_daily_card_response_model.dart';

abstract class ITarotRemoteDataSource {
  Future<RecordDailyCardResponse> requestRecordDailyCard({required RecordDailyCardRequest request});
  Future<FetchDailyCardsResponse> requestFetchDailyCards({required FetchDailyCardsRequest request});
  Future<ReadingResponse> requestReading({required ReadingRequest request});
}
