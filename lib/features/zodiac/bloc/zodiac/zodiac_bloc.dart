import 'dart:async';

import 'package:daily_tarot_focus/features/zodiac/bloc/zodiac/zodiac_event.dart';
import 'package:daily_tarot_focus/features/zodiac/bloc/zodiac/zodiac_state.dart';
import 'package:daily_tarot_focus/features/zodiac/data/impl_zodiac_repository.dart';
import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_compatibility_request_model.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

class ZodiacBloc extends Bloc<ZodiacEvent, ZodiacState> {
  ZodiacBloc(this._zodiacRepository) : super(ZodiacState.initial()) {
    on<ZodiacEvent>(
      (event, emit) async {
        if (event is ZodiacGenerateCompatibilityRequested) {
          await _onGenerateCompatibilityRequested(event, emit);
        }
      },
      transformer: sequential(),
    );
  }

  void addGenerateCompatibilityRequested({required GenerateCompatibilityRequestModel request}) =>
      add(ZodiacGenerateCompatibilityRequested(request: request));

  Future<void> _onGenerateCompatibilityRequested(
    ZodiacGenerateCompatibilityRequested event,
    Emitter<ZodiacState> emit,
  ) async {
    emit(
      state.copyWith(isGeneratingCompatibility: true, fetchCompatibilityFailureOrResult: none()),
    );

    final result = await _zodiacRepository.requestGenerateCompatibility(request: event.request);

    emit(
      state.copyWith(
        isGeneratingCompatibility: false,
        fetchCompatibilityFailureOrResult: some(result),
      ),
    );
  }

  final ImplZodiacRepository _zodiacRepository;
}
