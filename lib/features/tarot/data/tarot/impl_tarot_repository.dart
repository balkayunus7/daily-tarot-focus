import 'package:daily_tarot_focus/features/tarot/data/tarot/i_tarot_remote_data_source.dart';
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
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';

class ImplTarotRepository {
  ImplTarotRepository(this._tarotRemoteDataSource);

  Future<FailureOr<RecordDailyCardResponse>> requestRecordDailyCard({
    required RecordDailyCardRequest request,
  }) async {
    try {
      final response = await tarotRemoteDataSource.requestRecordDailyCard(request: request);
      return right(response);
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  Future<FailureOr<FetchDailyCardsResponse>> requestFetchDailyCards({
    required FetchDailyCardsRequest request,
  }) async {
    try {
      final response = await tarotRemoteDataSource.requestFetchDailyCards(request: request);
      return right(response);
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  Future<FailureOr<FetchAllCardsResponse>> requestAllCards({
    required FetchAllCardsRequest request,
  }) async {
    try {
      final response = await tarotRemoteDataSource.requestAllCards(request: request);
      return right(response);
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  Future<FailureOr<FetchSpreadsResponse>> requestFetchSpreads({
    required FetchSpreadsRequest request,
  }) async {
    try {
      final response = await tarotRemoteDataSource.requestSpreadCategories(request: request);
      return right(response);
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  Future<FailureOr<FetchReadersResponse>> requestFetchReaders({
    required FetchReadersRequest request,
  }) async {
    try {
      final response = await tarotRemoteDataSource.requestReaders(request: request);
      return right(response);
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  Future<FailureOr<GenerateReadingResponse>> requestGenerateReading({
    required GenerateReadingRequest request,
  }) async {
    try {
      final response = await tarotRemoteDataSource.requestGenerateReading(request: request);
      return right(response);
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  final ITarotRemoteDataSource _tarotRemoteDataSource;
  ITarotRemoteDataSource get tarotRemoteDataSource => _tarotRemoteDataSource;
}
