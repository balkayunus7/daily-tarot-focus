import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_zodiac_enum.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/horoscope_period_enum.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/auth_session.dart';

typedef GenerateHoroscopeRequest = GenerateHoroscopeRequestModel;

class GenerateHoroscopeRequestModel with EquatableMixin {
  const GenerateHoroscopeRequestModel({
    required this.session,
    required this.sign,
    required this.period,
  });

  final AuthSession session;
  final ZodiacSign sign;
  final HoroscopePeriod period;

  String get cacheKey => '${sign.name}_${period.name}';

  Map<String, dynamic> toMap() => {
    'sign': sign.name,
    'period': period.name,
  };

  @override
  List<Object?> get props => [session, sign, period];
}
