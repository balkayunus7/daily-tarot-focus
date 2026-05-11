import 'dart:async';

import 'package:daily_tarot_focus/features/zodiac/bloc/zodiac/zodiac_event.dart';
import 'package:daily_tarot_focus/features/zodiac/bloc/zodiac/zodiac_state.dart';
import 'package:daily_tarot_focus/features/zodiac/data/impl_zodiac_cache_service.dart';
import 'package:daily_tarot_focus/features/zodiac/data/impl_zodiac_repository.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_compatibility_request_model.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_compatibility_response_model.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_horoscope_request_model.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

class ZodiacBloc extends Bloc<ZodiacEvent, ZodiacState> {
  ZodiacBloc(this._zodiacRepository, this._zodiacCacheService) : super(ZodiacState.initial()) {
    on<ZodiacEvent>(
      (event, emit) async {
        if (event is ZodiacGenerateCompatibilityRequested) {
          await _onGenerateCompatibilityRequested(event, emit);
        } else if (event is ZodiacGenerateHoroscopeRequested) {
          await _onGenerateHoroscopeRequested(event, emit);
        }
      },
      transformer: sequential(),
    );
  }

  void addGenerateCompatibilityRequested({required GenerateCompatibilityRequestModel request}) =>
      add(ZodiacGenerateCompatibilityRequested(request: request));

  void addGenerateHoroscopeRequested({required GenerateHoroscopeRequestModel request}) =>
      add(ZodiacGenerateHoroscopeRequested(request: request));

  Future<void> _onGenerateCompatibilityRequested(
    ZodiacGenerateCompatibilityRequested event,
    Emitter<ZodiacState> emit,
  ) async {
    if (!_hasLoadedCompatibilityCache) {
      final persistentCache = await _zodiacCacheService.getCompatibilityCache();
      if (persistentCache != null && persistentCache.isNotEmpty) {
        emit(state.copyWith(compatibilityCache: persistentCache));
      }
      _hasLoadedCompatibilityCache = true;
    }

    final key = event.request.cacheKey;

    if (state.compatibilityCache.containsKey(key)) {
      return;
    }

    emit(
      state.copyWith(isGeneratingCompatibility: true, fetchCompatibilityFailureOrResult: none()),
    );

    final result = await _zodiacRepository.requestGenerateCompatibility(request: event.request);

    final updatedCache = Map<String, GenerateCompatibilityResponse>.from(state.compatibilityCache);
    result.fold((_) {}, (response) => updatedCache[key] = response);

    emit(
      state.copyWith(
        isGeneratingCompatibility: false,
        fetchCompatibilityFailureOrResult: some(result),
        compatibilityCache: updatedCache,
      ),
    );

    if (result.isRight()) {
      await _zodiacCacheService.saveCompatibilityCache(updatedCache);
    }
  }

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
  bool _hasLoadedCompatibilityCache = false;
}
