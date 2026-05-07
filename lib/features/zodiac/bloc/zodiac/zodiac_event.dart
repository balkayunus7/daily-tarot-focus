import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_compatibility_request_model.dart';

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
