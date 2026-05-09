import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_compatibility_response_model.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_horoscope_response_model.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/horoscope_period_enum.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';
import 'package:mobile_boilerplate/extensions.dart';

class CachedHoroscope extends Equatable {
  const CachedHoroscope({required this.response, required this.validUntil});
  final HoroscopeResponseModel response;
  final DateTime validUntil;

  bool get isExpired => DateTime.now().isAfter(validUntil);

  @override
  List<Object?> get props => [response, validUntil];

  /// Calculates the expiry timestamp for the given period.
  static DateTime expiryFor(HoroscopePeriod period) {
    final now = DateTime.now();
    switch (period) {
      case HoroscopePeriod.daily:
        return DateTime(now.year, now.month, now.day + 1);
      case HoroscopePeriod.weekly:
        final daysUntilMonday = (DateTime.monday - now.weekday + 7) % 7;
        final nextMonday = daysUntilMonday == 0 ? 7 : daysUntilMonday;
        return DateTime(now.year, now.month, now.day + nextMonday);
      case HoroscopePeriod.monthly:
        return DateTime(now.year, now.month + 1);
    }
  }
}

class ZodiacState extends Equatable {
  const ZodiacState({
    required this.isGeneratingCompatibility,
    required this.fetchCompatibilityFailureOrResult,
    required this.compatibilityCache,
    required this.isGeneratingHoroscope,
    required this.fetchHoroscopeFailureOrResult,
    required this.horoscopeCache,
  });

  factory ZodiacState.initial() => const ZodiacState(
    isGeneratingCompatibility: false,
    fetchCompatibilityFailureOrResult: None(),
    compatibilityCache: {},
    isGeneratingHoroscope: false,
    fetchHoroscopeFailureOrResult: None(),
    horoscopeCache: {},
  );

  final bool isGeneratingCompatibility;
  final Option<FailureOr<GenerateCompatibilityResponse>> fetchCompatibilityFailureOrResult;
  final Map<String, GenerateCompatibilityResponse> compatibilityCache;

  final bool isGeneratingHoroscope;
  final Option<FailureOr<HoroscopeResponseModel>> fetchHoroscopeFailureOrResult;
  final Map<String, CachedHoroscope> horoscopeCache;

  bool get hasGeneratedCompatibilitySucceeded =>
      fetchCompatibilityFailureOrResult.getOrNull()?.getRightOrNull() != null;

  bool get hasGeneratedCompatibilityFailed =>
      fetchCompatibilityFailureOrResult.getOrNull()?.getLeftOrNull() != null;

  GenerateCompatibilityResponse? get compatibilityResponseOrNull =>
      fetchCompatibilityFailureOrResult.getOrNull()?.getRightOrNull();

  bool get hasGeneratedHoroscopeSucceeded =>
      fetchHoroscopeFailureOrResult.getOrNull()?.getRightOrNull() != null;

  bool get hasGeneratedHoroscopeFailed =>
      fetchHoroscopeFailureOrResult.getOrNull()?.getLeftOrNull() != null;

  ZodiacState copyWith({
    bool? isGeneratingCompatibility,
    Option<FailureOr<GenerateCompatibilityResponse>>? fetchCompatibilityFailureOrResult,
    Map<String, GenerateCompatibilityResponse>? compatibilityCache,
    bool? isGeneratingHoroscope,
    Option<FailureOr<HoroscopeResponseModel>>? fetchHoroscopeFailureOrResult,
    Map<String, CachedHoroscope>? horoscopeCache,
  }) {
    return ZodiacState(
      isGeneratingCompatibility: isGeneratingCompatibility ?? this.isGeneratingCompatibility,
      fetchCompatibilityFailureOrResult:
          fetchCompatibilityFailureOrResult ?? this.fetchCompatibilityFailureOrResult,
      compatibilityCache: compatibilityCache ?? this.compatibilityCache,
      isGeneratingHoroscope: isGeneratingHoroscope ?? this.isGeneratingHoroscope,
      fetchHoroscopeFailureOrResult:
          fetchHoroscopeFailureOrResult ?? this.fetchHoroscopeFailureOrResult,
      horoscopeCache: horoscopeCache ?? this.horoscopeCache,
    );
  }

  @override
  List<Object?> get props => [
    isGeneratingCompatibility,
    fetchCompatibilityFailureOrResult,
    compatibilityCache,
    isGeneratingHoroscope,
    fetchHoroscopeFailureOrResult,
    horoscopeCache,
  ];
}
