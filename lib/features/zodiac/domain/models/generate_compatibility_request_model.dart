import 'package:daily_tarot_focus/core/util/tarot_app_assets.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_zodiac_enum.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/auth_session.dart';

typedef GenerateCompatibilityRequest = GenerateCompatibilityRequestModel;

class GenerateCompatibilityRequestModel with EquatableMixin {
  const GenerateCompatibilityRequestModel({
    required this.session,
    required this.mySign,
    required this.myGender,
    required this.partnerSign,
    required this.partnerGender,
  });

  final AuthSession session;
  final ZodiacSign mySign;
  final CompatGender myGender;
  final ZodiacSign partnerSign;
  final CompatGender partnerGender;

  Map<String, dynamic> toMap() => {
    'my_sign': mySign.name,
    'my_gender': myGender.value,
    'partner_sign': partnerSign.name,
    'partner_gender': partnerGender.value,
  };

  @override
  List<Object?> get props => [session, mySign, myGender, partnerSign, partnerGender];
}

enum CompatGender {
  female('Female'),
  male('Male'),
  nonBinary('Non Binary');

  const CompatGender(this.value);

  factory CompatGender.fromString(String value) =>
      CompatGender.values.firstWhere((e) => e.value == value);

  String get emoji {
    return switch (this) {
      CompatGender.female => TarotAppAssets.female.path,
      CompatGender.male => TarotAppAssets.male.path,
      CompatGender.nonBinary => TarotAppAssets.nonBinary.path,
    };
  }

  final String value;

  bool get isFemale => this == CompatGender.female;
  bool get isMale => this == CompatGender.male;
  bool get isNonBinary => this == CompatGender.nonBinary;
}
