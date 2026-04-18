import 'package:daily_tarot_focus/core/util/supabase_helper.dart';
import 'package:daily_tarot_focus/core/util/tarot_routes.dart';
import 'package:daily_tarot_focus/features/tarot/data/tarot/i_tarot_remote_data_source.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_daily_cards_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_daily_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/reading_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/reading_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/record_daily_card_request_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/record_daily_card_response_model.dart';
import 'package:mobile_boilerplate/domain/common/http_utilities.dart';
import 'package:mobile_boilerplate/extensions.dart';
import 'package:supabase/supabase.dart' hide Session;

class ImplTarotRemoteDataSource implements ITarotRemoteDataSource {
  ImplTarotRemoteDataSource(this._supabaseClient);

  @override
  Future<RecordDailyCardResponse> requestRecordDailyCard({
    required RecordDailyCardRequest request,
  }) async {
    final responseOrFail = await supabaseClient.secureInvoke(
      route: SAVE_DAILY_CARD,
      method: HttpMethod.post,
      body: {'card_id': request.cardId},
      session: request.session,
    );
    if (responseOrFail.isLeft()) throw Exception();

    final response = responseOrFail.getRightOrCrash();
    final map = decodeSupabaseResponse(response.data);
    final success = map['success'] as bool? ?? false;

    if (!success) throw Exception();

    return RecordDailyCardResponse.fromMap();
  }

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
    return FetchDailyCardsResponse.fromList(response.data as List);
  }

  @override
  Future<ReadingResponse> requestReading({required ReadingRequest request}) async {
    final responseOrFail = await supabaseClient.secureInvoke(
      route: ASK_QUESTION,
      method: HttpMethod.post,
      session: request.session,
      body: request.data.toMap(),
    );

    if (responseOrFail.isLeft()) throw Exception();

    final response = responseOrFail.getRightOrCrash();
    return ReadingResponse.fromMap(decodeSupabaseResponse(response.data));
  }

  @override
  Future<FetchAllCardsResponse> requestAllCards({required FetchAllCardsRequest request}) async {
    final responseOrFail = await supabaseClient.secureInvoke(
      route: GET_ALL_CARDS,
      session: request.session,
    );

    if (responseOrFail.isLeft()) throw Exception();

    final response = responseOrFail.getRightOrCrash();
    return FetchAllCardsResponse.fromMap(decodeSupabaseResponse(response.data));
  }

  final SupabaseClient _supabaseClient;
  SupabaseClient get supabaseClient => _supabaseClient;
}
