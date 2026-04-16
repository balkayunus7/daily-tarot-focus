part of 'register_cubit.dart';

class RegisterState extends Equatable {
  const RegisterState({
    required this.registerStatus,
    this.zodiac,
    this.relationshipStatus,
    this.careerStatus,
    this.failure,
  });

  factory RegisterState.initial() {
    return const RegisterState(registerStatus: RegisterStatus.initial);
  }

  final ZodiacSign? zodiac;
  final RelationshipStatus? relationshipStatus;
  final CareerStatus? careerStatus;
  final Failure? failure;
  final RegisterStatus registerStatus;

  bool get isRegisterNotCompleted {
    return zodiac == null || relationshipStatus == null || careerStatus == null;
  }

  bool get isZodiacSelected => zodiac != null;
  bool get isRelationshipStatusSelected => relationshipStatus != null;
  bool get isCareerStatusSelected => careerStatus != null;

  RegisterState copyWith({
    ZodiacSign? zodiac,
    RelationshipStatus? relationshipStatus,
    CareerStatus? careerStatus,
    Failure? failure,
    RegisterStatus? registerStatus,
  }) {
    return RegisterState(
      zodiac: zodiac ?? this.zodiac,
      relationshipStatus: relationshipStatus ?? this.relationshipStatus,
      careerStatus: careerStatus ?? this.careerStatus,
      registerStatus: registerStatus ?? this.registerStatus,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    zodiac,
    relationshipStatus,
    careerStatus,
    registerStatus,
    failure,
  ];
}
