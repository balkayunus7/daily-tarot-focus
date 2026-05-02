import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_daily_cards_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_daily_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_readers_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_readers_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_spreads_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_spreads_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/generate_reading_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/generate_reading_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/record_daily_card_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/record_daily_card_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_saved_readings_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_saved_readings_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/save_reading_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/save_reading_response_model.dart';

abstract class ITarotRemoteDataSource {
  Future<RecordDailyCardResponse> requestRecordDailyCard({required RecordDailyCardRequest request});
  Future<FetchDailyCardsResponse> requestFetchDailyCards({required FetchDailyCardsRequest request});
  Future<FetchAllCardsResponse> requestAllCards({required FetchAllCardsRequest request});
  Future<FetchSpreadsResponse> requestSpreadCategories({required FetchSpreadsRequest request});
  Future<FetchReadersResponse> requestReaders({required FetchReadersRequest request});
  Future<GenerateReadingResponse> requestGenerateReading({required GenerateReadingRequest request});
  Future<SaveReadingResponse> requestSaveReading({required SaveReadingRequest request});
  Future<FetchSavedReadingsResponse> requestFetchSavedReadings({required FetchSavedReadingsRequest request});
}
