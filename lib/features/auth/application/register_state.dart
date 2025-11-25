part of 'register_cubit.dart';

class RegisterState extends Equatable {
  final ZodiacSign? zodiac;
  final RelationshipStatus? relationshipStatus;
  final DateTime? birthDate;
  final Failure? failure;
  final RegisterStatus registerStatus;

  const RegisterState({
    this.zodiac,
    this.relationshipStatus,
    this.birthDate,
    this.failure,
    required this.registerStatus,
  });

  factory RegisterState.initial() {
    return const RegisterState(registerStatus: RegisterStatus.initial);
  }

  bool get isRegisterNotCompleted {
    return (zodiac == null || relationshipStatus == null || birthDate == null);
  }

  RegisterState copyWith({
    ZodiacSign? zodiac,
    RelationshipStatus? relationshipStatus,
    DateTime? birthDate,
    Failure? failure,
    RegisterStatus? registerStatus,
  }) {
    return RegisterState(
      zodiac: zodiac ?? this.zodiac,
      relationshipStatus: relationshipStatus ?? this.relationshipStatus,
      birthDate: birthDate ?? this.birthDate,
      registerStatus: registerStatus ?? this.registerStatus,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    zodiac,
    relationshipStatus,
    birthDate,
    registerStatus,
    failure,
  ];
}
