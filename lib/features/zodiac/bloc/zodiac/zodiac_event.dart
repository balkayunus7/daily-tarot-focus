import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_compatibility_request_model.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_horoscope_request_model.dart';

sealed class ZodiacEvent {
  const ZodiacEvent();
  List<Object?> get props => [];
}

final class ZodiacGenerateCompatibilityRequested extends ZodiacEvent {
  const ZodiacGenerateCompatibilityRequested({required this.request});
  final GenerateCompatibilityRequestModel request;

  @override
  List<Object?> get props => [request.mySign, request.partnerSign, request.session];
}

final class ZodiacGenerateHoroscopeRequested extends ZodiacEvent {
  const ZodiacGenerateHoroscopeRequested({required this.request});
  final GenerateHoroscopeRequestModel request;

  @override
  List<Object?> get props => [request.sign, request.period, request.session];
}
