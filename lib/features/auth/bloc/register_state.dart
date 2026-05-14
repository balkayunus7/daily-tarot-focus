part of 'register_cubit.dart';

class RegisterState extends Equatable {
  const RegisterState({
    required this.registerStatus,
    this.relationshipStatus,
    this.careerStatus,
    this.name,
    this.birthDate,
    this.birthTime,
    this.location,
    this.latitude,
    this.longitude,
    this.zoneName,
    this.failure,
  });

  factory RegisterState.initial() {
    return const RegisterState(registerStatus: RegisterStatus.initial);
  }

  final RelationshipStatus? relationshipStatus;
  final CareerStatus? careerStatus;
  final String? name;
  final DateTime? birthDate;
  final TimeOfDay? birthTime;
  final String? location;
  final double? latitude;
  final double? longitude;
  final String? zoneName;
  final Failure? failure;
  final RegisterStatus registerStatus;

  bool get isRegisterNotCompleted {
    return relationshipStatus == null ||
        careerStatus == null ||
        (name == null || name!.trim().isEmpty) ||
        birthDate == null ||
        birthTime == null ||
        (location == null || location!.trim().isEmpty) ||
        latitude == null ||
        longitude == null;
  }

  bool get isRelationshipStatusSelected => relationshipStatus != null;
  bool get isCareerStatusSelected => careerStatus != null;
  bool get isNameBirthValid =>
      name != null && name!.trim().isNotEmpty && birthDate != null && birthTime != null;
  bool get isLocationValid =>
      location != null && location!.trim().isNotEmpty && latitude != null && longitude != null;

  RegisterState copyWith({
    RelationshipStatus? relationshipStatus,
    CareerStatus? careerStatus,
    String? name,
    DateTime? birthDate,
    TimeOfDay? birthTime,
    String? location,
    double? latitude,
    double? longitude,
    String? zoneName,
    Failure? failure,
    RegisterStatus? registerStatus,
  }) {
    return RegisterState(
      relationshipStatus: relationshipStatus ?? this.relationshipStatus,
      careerStatus: careerStatus ?? this.careerStatus,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      birthTime: birthTime ?? this.birthTime,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      zoneName: zoneName ?? this.zoneName,
      registerStatus: registerStatus ?? this.registerStatus,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    relationshipStatus,
    careerStatus,
    name,
    birthDate,
    birthTime,
    location,
    latitude,
    longitude,
    zoneName,
    registerStatus,
    failure,
  ];
}
