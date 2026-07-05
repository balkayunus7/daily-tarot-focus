import 'package:daily_tarot_focus/core/util/user_location_codec.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/register_enum.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_career_enum.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_properties.dart';
import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user_relations_enum.dart';
import 'package:daily_tarot_focus/features/zodiac/presentation/zodiac_learn/helpers/astrology_helper.dart';
import 'package:flutter/material.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/auth_session.dart';
import 'package:mobile_boilerplate/domain/auth/i_user_repository.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._userRepository) : super(RegisterState.initial());

  void selectRelationshipStatus(RelationshipStatus status) {
    emit(state.copyWith(relationshipStatus: status));
  }

  void selectCareerStatus(CareerStatus status) {
    emit(state.copyWith(careerStatus: status));
  }

  void setName(String name) {
    emit(state.copyWith(name: name));
  }

  void setBirthDate(DateTime birthDate) {
    emit(state.copyWith(birthDate: birthDate));
  }

  void setBirthTime(TimeOfDay time) {
    emit(state.copyWith(birthTime: time));
  }

  void setCity(String name, double lat, double lon, String? zoneName) {
    emit(state.copyWith(location: name, latitude: lat, longitude: lon, zoneName: zoneName));
  }

  Future<void> submitRegistration(AuthSession session) async {
    if (state.isRegisterNotCompleted) {
      emit(
        state.copyWith(
          registerStatus: RegisterStatus.failure,
          failure: const UnknownFailure(),
        ),
      );
      return;
    }

    emit(state.copyWith(registerStatus: RegisterStatus.loading));

    final birthDate = state.birthDate!;
    final birthTime = state.birthTime!;

    final sunSign = ZodiacLearnHelper.sunSign(birthDate);

    final utc = ZodiacLearnHelper.birthToUtc(
      birthDate: birthDate,
      birthHour: birthTime.hour,
      birthMinute: birthTime.minute,
      longitude: state.longitude!,
      zoneName: state.zoneName,
    );
    final moonSign = ZodiacLearnHelper.moonSign(utc);
    final risingSign = ZodiacLearnHelper.risingSign(utc, state.latitude!, state.longitude!);

    final properties = TarotUserProperties(
      relationshipStatus: state.relationshipStatus!,
      careerStatus: state.careerStatus!,
      name: state.name!.trim(),
      birthDate: birthDate,
      location: UserLocationCodec.encode(
        name: state.location!.trim(),
        latitude: state.latitude!,
        longitude: state.longitude!,
        zoneName: state.zoneName,
      ),
      zodiac: sunSign,
      moonSign: moonSign,
      risingSign: risingSign,
    );

    final updateFailureOrUnit = await userRepository.updateUser(
      session: session,
      properties: properties,
    );

    updateFailureOrUnit.fold(
      (failure) => emit(
        state.copyWith(
          registerStatus: RegisterStatus.failure,
          failure: failure,
        ),
      ),
      (unit) => emit(state.copyWith(registerStatus: RegisterStatus.success)),
    );
  }

  void reset() {
    emit(RegisterState.initial());
  }

  final IUserRepository _userRepository;
  IUserRepository get userRepository => _userRepository;
}
