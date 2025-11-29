import 'package:daily_tarot_focus/domain/auth/register_enum.dart';
import 'package:daily_tarot_focus/domain/auth/tarot_user_properties.dart';
import 'package:daily_tarot_focus/domain/auth/tarot_user_relations_enum.dart';
import 'package:daily_tarot_focus/domain/auth/tarot_user_zodiac_enum.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/auth/i_user_repository.dart';
import 'package:mobile_boilerplate/domain/auth/session.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._userRepository) : super(RegisterState.initial());

  void selectZodiac(ZodiacSign zodiac) {
    emit(state.copyWith(zodiac: zodiac));
  }

  void selectRelationshipStatus(RelationshipStatus status) {
    emit(state.copyWith(relationshipStatus: status));
  }

  void selectBirthDate(DateTime birthDate) {
    emit(state.copyWith(birthDate: birthDate));
  }

  Future<void> submitRegistration(Session session) async {
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

    final properties = TarotUserProperties(
      zodiac: state.zodiac!,
      relationshipStatus: state.relationshipStatus!,
      birthDate: state.birthDate!,
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
