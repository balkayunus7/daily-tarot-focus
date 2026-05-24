part of 'edit_profile_cubit.dart';

enum EditProfileStatus { initial, loading, success, failure }

class EditProfileState extends Equatable {
  const EditProfileState({
    required this.status,
    this.name,
    this.birthDate,
    this.birthTime,
    this.relationship,
    this.career,
    this.failure,
  });

  factory EditProfileState.fromUser(TarotUser user) {
    final bd = user.birthDate;
    return EditProfileState(
      status: EditProfileStatus.initial,
      name: user.name,
      birthDate: bd != null ? DateTime(bd.year, bd.month, bd.day) : null,
      birthTime: bd != null && (bd.hour != 0 || bd.minute != 0)
          ? TimeOfDay(hour: bd.hour, minute: bd.minute)
          : null,
      relationship: user.relationshipStatus,
      career: user.careerStatus,
    );
  }

  final EditProfileStatus status;
  final String? name;
  final DateTime? birthDate;
  final TimeOfDay? birthTime;
  final RelationshipStatus? relationship;
  final CareerStatus? career;
  final Failure? failure;

  bool get isLoading => status == EditProfileStatus.loading;
  bool get isSuccess => status == EditProfileStatus.success;
  bool get isFailure => status == EditProfileStatus.failure;

  EditProfileState copyWith({
    EditProfileStatus? status,
    String? name,
    DateTime? birthDate,
    TimeOfDay? birthTime,
    RelationshipStatus? relationship,
    CareerStatus? career,
    Failure? failure,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      name: name ?? this.name,
      birthDate: birthDate ?? this.birthDate,
      birthTime: birthTime ?? this.birthTime,
      relationship: relationship ?? this.relationship,
      career: career ?? this.career,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
        status,
        name,
        birthDate,
        birthTime,
        relationship,
        career,
        failure,
      ];
}
