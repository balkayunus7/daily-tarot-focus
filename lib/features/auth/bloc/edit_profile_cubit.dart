import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_career_enum.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_properties.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_relations_enum.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/zodiac_learn/helpers/astrology_helper.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/auth_session.dart';
import 'package:mobile_boilerplate/domain/auth/i_user_repository.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  EditProfileCubit(this._userRepository, TarotUser user)
      : super(EditProfileState.fromUser(user));

  final IUserRepository _userRepository;

  void setName(String name) => emit(state.copyWith(name: name));
  void setBirthDate(DateTime date) => emit(state.copyWith(birthDate: date));
  void setBirthTime(TimeOfDay time) => emit(state.copyWith(birthTime: time));
  void setRelationship(RelationshipStatus status) =>
      emit(state.copyWith(relationship: status));
  void setCareer(CareerStatus status) => emit(state.copyWith(career: status));

  Future<void> save({
    required AuthSession session,
    required TarotUser currentUser,
  }) async {
    emit(state.copyWith(status: EditProfileStatus.loading));

    final birthDate = state.birthDate ?? currentUser.birthDate ?? DateTime.now();
    final birthTime = state.birthTime;

    final combinedDate = birthTime != null
        ? DateTime(
            birthDate.year,
            birthDate.month,
            birthDate.day,
            birthTime.hour,
            birthTime.minute,
          )
        : birthDate;

    final sunSign = ZodiacLearnHelper.sunSign(birthDate);

    final properties = TarotUserProperties(
      name: (state.name ?? currentUser.name ?? '').trim(),
      birthDate: combinedDate,
      location: currentUser.location ?? '',
      relationshipStatus: state.relationship ??
          currentUser.relationshipStatus ??
          RelationshipStatus.preferNotToSay,
      careerStatus:
          state.career ?? currentUser.careerStatus ?? CareerStatus.preferNotToSay,
      zodiac: sunSign,
      moonSign: currentUser.moonSign,
      risingSign: currentUser.risingSign,
    );

    final result = await _userRepository.updateUser(
      session: session,
      properties: properties,
    );

    result.fold(
      (failure) =>
          emit(state.copyWith(status: EditProfileStatus.failure, failure: failure)),
      (_) => emit(state.copyWith(status: EditProfileStatus.success)),
    );
  }
}
