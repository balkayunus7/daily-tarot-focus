import 'dart:async';

import 'package:daily_tarot_focus/features/zodiac/bloc/zodiac/zodiac_event.dart';
import 'package:daily_tarot_focus/features/zodiac/bloc/zodiac/zodiac_state.dart';
import 'package:daily_tarot_focus/features/zodiac/data/impl_zodiac_cache_service.dart';
import 'package:daily_tarot_focus/features/zodiac/data/impl_zodiac_repository.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_horoscope_request_model.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

class ZodiacBloc extends Bloc<ZodiacEvent, ZodiacState> {
  ZodiacBloc(this._zodiacRepository, this._zodiacCacheService) : super(ZodiacState.initial()) {
    on<ZodiacEvent>(
      (event, emit) async {
        if (event is ZodiacGenerateHoroscopeRequested) {
          await _onGenerateHoroscopeRequested(event, emit);
        }
      },
      transformer: sequential(),
    );
  }

  void addGenerateHoroscopeRequested({required GenerateHoroscopeRequestModel request}) =>
      add(ZodiacGenerateHoroscopeRequested(request: request));

  Future<void> _onGenerateHoroscopeRequested(
    ZodiacGenerateHoroscopeRequested event,
    Emitter<ZodiacState> emit,
  ) async {
    final key = event.request.cacheKey;

    if (!_hasLoadedCache) {
      final persistentCache = await _zodiacCacheService.getHoroscopeCache();
      if (persistentCache != null && persistentCache.isNotEmpty) {
        emit(state.copyWith(horoscopeCache: persistentCache));
      }
      _hasLoadedCache = true;
    }

    final cached = state.horoscopeCache[key];
    if (cached != null && !cached.isExpired) {
      return;
    }

    emit(
      state.copyWith(isGeneratingHoroscope: true, fetchHoroscopeFailureOrResult: none()),
    );

    final result = await _zodiacRepository.requestGenerateHoroscope(request: event.request);

    final updatedCache = Map<String, CachedHoroscope>.from(state.horoscopeCache);
    result.fold((_) {}, (response) {
      updatedCache[key] = CachedHoroscope(
        response: response,
        validUntil: CachedHoroscope.expiryFor(event.request.period),
      );
    });

    emit(
      state.copyWith(
        isGeneratingHoroscope: false,
        fetchHoroscopeFailureOrResult: some(result),
        horoscopeCache: updatedCache,
      ),
    );

    await _zodiacCacheService.saveHoroscopeCache(updatedCache);
  }

  final ImplZodiacRepository _zodiacRepository;
  final ImplZodiacCacheService _zodiacCacheService;
  bool _hasLoadedCache = false;
}
