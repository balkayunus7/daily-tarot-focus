import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_horoscope_response_model.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/horoscope_period_enum.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';
import 'package:mobile_boilerplate/extensions.dart';

class CachedHoroscope extends Equatable {
  const CachedHoroscope({required this.response, required this.validUntil});

  factory CachedHoroscope.fromMap(Map<String, dynamic> map) {
    return CachedHoroscope(
      response: HoroscopeResponseModel.fromMap(map['response'] as Map<String, dynamic>),
      validUntil: DateTime.parse(map['valid_until'] as String),
    );
  }

  final HoroscopeResponseModel response;
  final DateTime validUntil;

  bool get isExpired => DateTime.now().isAfter(validUntil);

  Map<String, dynamic> toMap() {
    return {
      'response': response.toMap(),
      'valid_until': validUntil.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [response, validUntil];

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
    required this.isGeneratingHoroscope,
    required this.fetchHoroscopeFailureOrResult,
    required this.horoscopeCache,
  });

  factory ZodiacState.initial() => const ZodiacState(
    isGeneratingHoroscope: false,
    fetchHoroscopeFailureOrResult: None(),
    horoscopeCache: {},
  );

  final bool isGeneratingHoroscope;
  final Option<FailureOr<HoroscopeResponseModel>> fetchHoroscopeFailureOrResult;
  final Map<String, CachedHoroscope> horoscopeCache;

  bool get hasGeneratedHoroscopeSucceeded =>
      fetchHoroscopeFailureOrResult.getOrNull()?.getRightOrNull() != null;

  bool get hasGeneratedHoroscopeFailed =>
      fetchHoroscopeFailureOrResult.getOrNull()?.getLeftOrNull() != null;

  ZodiacState copyWith({
    bool? isGeneratingHoroscope,
    Option<FailureOr<HoroscopeResponseModel>>? fetchHoroscopeFailureOrResult,
    Map<String, CachedHoroscope>? horoscopeCache,
  }) {
    return ZodiacState(
      isGeneratingHoroscope: isGeneratingHoroscope ?? this.isGeneratingHoroscope,
      fetchHoroscopeFailureOrResult:
          fetchHoroscopeFailureOrResult ?? this.fetchHoroscopeFailureOrResult,
      horoscopeCache: horoscopeCache ?? this.horoscopeCache,
    );
  }

  @override
  List<Object?> get props => [
    isGeneratingHoroscope,
    fetchHoroscopeFailureOrResult,
    horoscopeCache,
  ];
}
