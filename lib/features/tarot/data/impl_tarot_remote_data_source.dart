import 'package:daily_tarot_focus/core/util/supabase_helper.dart';
import 'package:daily_tarot_focus/core/util/tarot_routes.dart';
import 'package:daily_tarot_focus/features/tarot/data/i_tarot_remote_data_source.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/delete_reading_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_daily_cards_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_daily_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_readers_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_readers_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_saved_readings_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_saved_readings_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_spreads_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_spreads_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/generate_daily_pick_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/generate_daily_pick_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/generate_reading_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/generate_reading_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/record_daily_card_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/record_daily_card_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/save_reading_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/save_reading_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/update_reading_note_request_model.dart';
import 'package:mobile_boilerplate/domain/common/http_utilities.dart';
import 'package:mobile_boilerplate/extensions.dart';
import 'package:supabase/supabase.dart' hide Session;

class ImplTarotRemoteDataSource implements ITarotRemoteDataSource {
  ImplTarotRemoteDataSource(this._supabaseClient);

  /// REQUEST RECORD DAILY CARD
  @override
  Future<RecordDailyCardResponse> requestRecordDailyCard({
    required RecordDailyCardRequest request,
  }) async {
    final responseOrFail = await supabaseClient.secureInvoke(
      route: SAVE_DAILY_CARD,
      method: HttpMethod.post,
      body: request.toMap(),
      session: request.session,
    );
    if (responseOrFail.isLeft()) throw Exception();

    final response = responseOrFail.getRightOrCrash();
    final map = decodeSupabaseResponse(response.data);

    final cardId = map['card_id'] as String?;
    if (cardId == null) throw Exception();

    return RecordDailyCardResponse.fromMap();
  }

  /// REQUEST FETCH DAILY CARDS
  @override
  Future<FetchDailyCardsResponse> requestFetchDailyCards({
    required FetchDailyCardsRequest request,
  }) async {
    final responseOrFail = await supabaseClient.secureInvoke(
      route: GET_DAILY_CARDS,
      session: request.session,
    );

    if (responseOrFail.isLeft()) throw Exception();

    final response = responseOrFail.getRightOrCrash();
    return FetchDailyCardsResponse.fromMap(
      decodeSupabaseResponse(response.data),
    );
  }

  /// REQUEST FETCH ALL CARDS
  @override
  Future<FetchAllCardsResponse> requestAllCards({
    required FetchAllCardsRequest request,
  }) async {
    final responseOrFail = await supabaseClient.secureInvoke(
      route: GET_ALL_CARDS,
      method: HttpMethod.post,
      session: request.session,
      body: {'locale': request.locale},
    );

    if (responseOrFail.isLeft()) {
      throw Exception();
    }

    final response = responseOrFail.getRightOrCrash();
    return FetchAllCardsResponse.fromMap(decodeSupabaseResponse(response.data));
  }

  final SupabaseClient _supabaseClient;
  SupabaseClient get supabaseClient => _supabaseClient;

  /// REQUEST FETCH SPREADS
  @override
  Future<FetchSpreadsResponse> requestSpreadCategories({
    required FetchSpreadsRequest request,
  }) async {
    final responseOrFail = await supabaseClient.secureInvoke(
      route: GET_SPREADS,
      method: HttpMethod.post,
      session: request.session,
      body: {'locale': request.locale},
    );

    if (responseOrFail.isLeft()) {
      throw Exception();
    }

    final response = responseOrFail.getRightOrCrash();
    return FetchSpreadsResponse.fromMap(decodeSupabaseResponse(response.data));
  }

  /// REQUEST FETCH READERS
  @override
  Future<FetchReadersResponse> requestReaders({
    required FetchReadersRequest request,
  }) async {
    final responseOrFail = await supabaseClient.secureInvoke(
      route: GET_READERS,
      method: HttpMethod.post,
      session: request.session,
      body: {'locale': request.locale},
    );

    if (responseOrFail.isLeft()) {
      throw Exception();
    }

    final response = responseOrFail.getRightOrCrash();
    return FetchReadersResponse.fromMap(decodeSupabaseResponse(response.data));
  }

  /// REQUEST GENERATE READING
  @override
  Future<GenerateReadingResponse> requestGenerateReading({
    required GenerateReadingRequest request,
  }) async {
    final responseOrFail = await supabaseClient.secureInvoke(
      route: ASK_QUESTION,
      method: HttpMethod.post,
      body: request.toMap(),
      session: request.session,
    );

    if (responseOrFail.isLeft()) {
      throw Exception();
    }

    final response = responseOrFail.getRightOrCrash();
    return GenerateReadingResponse.fromMap(
      decodeSupabaseResponse(response.data),
    );
  }

  /// REQUEST GENERATE DAILY PICK
  @override
  Future<GenerateDailyPickResponse> requestGenerateDailyPick({
    required GenerateDailyPickRequest request,
  }) async {
    final responseOrFail = await supabaseClient.secureInvoke(
      route: GENERATE_DAILY_PICK,
      method: HttpMethod.post,
      body: request.toMap(),
      session: request.session,
    );

    if (responseOrFail.isLeft()) {
      throw Exception();
    }

    final response = responseOrFail.getRightOrCrash();
    return GenerateDailyPickResponse.fromMap(
      decodeSupabaseResponse(response.data),
    );
  }

  /// REQUEST SAVE READING
  @override
  Future<SaveReadingResponse> requestSaveReading({
    required SaveReadingRequest request,
  }) async {
    final responseOrFail = await supabaseClient.secureInvoke(
      route: SAVE_READING,
      method: HttpMethod.post,
      body: request.toMap(),
      session: request.session,
    );

    if (responseOrFail.isLeft()) throw Exception();

    final response = responseOrFail.getRightOrCrash();
    return SaveReadingResponse.fromMap(decodeSupabaseResponse(response.data));
  }

  /// REQUEST FETCH SAVED READINGS
  @override
  Future<FetchSavedReadingsResponse> requestFetchSavedReadings({
    required FetchSavedReadingsRequest request,
  }) async {
    final responseOrFail = await supabaseClient.secureInvoke(
      route: GET_SAVED_READINGS,
      session: request.session,
    );

    if (responseOrFail.isLeft()) throw Exception();

    final response = responseOrFail.getRightOrCrash();
    return FetchSavedReadingsResponse.fromMap(
      decodeSupabaseResponse(response.data),
    );
  }

  /// REQUEST UPDATE READING NOTE
  @override
  Future<void> requestUpdateReadingNote({
    required UpdateReadingNoteRequest request,
  }) async {
    final responseOrFail = await supabaseClient.secureInvoke(
      route: UPDATE_READING_NOTE,
      method: HttpMethod.patch,
      body: request.toMap(),
      session: request.session,
    );

    if (responseOrFail.isLeft()) throw Exception();
  }

  /// REQUEST DELETE READING
  @override
  Future<void> requestDeleteReading({
    required DeleteReadingRequest request,
  }) async {
    final responseOrFail = await supabaseClient.secureInvoke(
      route: DELETE_READING,
      method: HttpMethod.delete,
      body: request.toMap(),
      session: request.session,
    );

    if (responseOrFail.isLeft()) throw Exception();
  }
}
