import 'dart:developer';

import 'package:daily_tarot_focus/application/tarot/tarot_event.dart';
import 'package:fishfinder/domain/fish/fish_data.dart';
import 'package:fishfinder/domain/fish/i_fish_repository.dart';
import 'package:mobile_core/common_dependencies.dart';
import 'package:mobile_core/domain/auth/session.dart';
import 'package:mobile_core/domain/common/failure.dart';
import 'package:mobile_core/extensions.dart';


class FishBloc extends Bloc<TarotEvent, FishState> {
  FishBloc(this._fishRepository) : super(FishState.initial()) {
    on<TarotEvent>((event, emit) async {
      if (event is FishPopularFishesFetched) {
        await _onPopularFishesFetched(event, emit);
      } else if (event is FishPopularFishesLoaded) {
        await _onPopularFishesLoaded(event, emit);
      } else if (event is FishIdentified) {
        await _onFishIdentified(event, emit);
      } else if (event is FishSavedToLibrary) {
        await _onFishSavedToLibrary(event, emit);
      } else if (event is FishNotesAdded) {
        await _onFishNotesAdded(event, emit);
      } else if (event is FishDeletedFromLibrary) {
        await _onFishDeletedFromLibrary(event, emit);
      }
    }, transformer: sequential());
  }

  void addPopularFishesFetched({required Session session}) {
    add(FishPopularFishesFetched(session: session));
  }

  void addPopularFishesLoaded({required Session session}) {
    add(FishPopularFishesLoaded(session: session));
  }

  void addFishIdentified({
    required String fishImage,
    required Session session,
  }) {
    add(FishIdentified(fishImage: fishImage, session: session));
  }

  void addFishSavedToLibrary({
    required String fishId,
    required Session session,
  }) {
    add(FishSavedToLibrary(fishId: fishId, session: session));
  }

  void addFishNotesAdded({
    required String fishId,
    required String note,
    required Session session,
  }) {
    add(FishNotesAdded(fishId: fishId, note: note, session: session));
  }

  void addFishDeletedFromLibrary({
    required String fishId,
    required Session session,
  }) {
    add(FishDeletedFromLibrary(fishId: fishId, session: session));
  }

  Future<void> _onPopularFishesFetched(
    FishPopularFishesFetched event,
    Emitter<FishState> emit,
  ) async {
    emit(
      state.copyWith(
        isPopularFishesFetching: true,
        fetchFailureOrPopularFishes: none(),
      ),
    );

    final failOrPopularFishes = await fishRepository.fetchPopularFishes(
      session: event.session,
    );

    final newState = await failOrPopularFishes.fold(
      (failure) async {
        return state.copyWith(
          fetchFailureOrPopularFishes: some(left(failure)),
          isPopularFishesFetching: false,
        );
      },
      (popularFishes) async {
        return state.copyWith(
          fetchFailureOrPopularFishes: some(right(popularFishes)),
          isPopularFishesFetching: false,
        );
      },
    );
    emit(newState);
  }

  Future<void> _onPopularFishesLoaded(
    FishPopularFishesLoaded event,
    Emitter<FishState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoadingPopularFishes: true,
        loadFailureOrPopularFishes: none(),
      ),
    );

    final failOrUnit = await fishRepository.loadPopularFishes(
      session: event.session,
    );

    final newState = await failOrUnit.fold(
      (failure) async {
        return state.copyWith(
          loadFailureOrPopularFishes: some(left(failure)),
          isLoadingPopularFishes: false,
        );
      },
      (unit) async {
        return state.copyWith(
          loadFailureOrPopularFishes: some(right(unit)),
          isLoadingPopularFishes: false,
        );
      },
    );
    emit(newState);
  }

  Future<void> _onFishIdentified(
    FishIdentified event,
    Emitter<FishState> emit,
  ) async {
    emit(
      state.copyWith(isIdentifyingFish: true, identifyFailureOrFish: none()),
    );

    final failOrFish = await fishRepository.identifyFish(
      fishImage: event.fishImage,
      session: event.session,
    );

    final newState = await failOrFish.fold(
      (failure) async {
        return state.copyWith(
          identifyFailureOrFish: some(left(failure)),
          isIdentifyingFish: false,
        );
      },
      (fish) async {
        return state.copyWith(
          identifyFailureOrFish: some(right(fish)),
          isIdentifyingFish: false,
        );
      },
    );
    emit(newState);
  }

  Future<void> _onFishSavedToLibrary(
    FishSavedToLibrary event,
    Emitter<FishState> emit,
  ) async {
    emit(state.copyWith(isSavingToLibrary: true, saveFailureOrUnit: none()));

    final failOrUnit = await fishRepository.saveToLibrary(
      fishId: event.fishId,
      session: event.session,
    );

    final newState = await failOrUnit.fold(
      (failure) async {
        return state.copyWith(
          saveFailureOrUnit: some(left(failure)),
          isSavingToLibrary: false,
        );
      },
      (unit) async {
        return state.copyWith(
          saveFailureOrUnit: some(right(unit)),
          isSavingToLibrary: false,
        );
      },
    );
    emit(newState);
  }

  Future<void> _onFishNotesAdded(
    FishNotesAdded event,
    Emitter<FishState> emit,
  ) async {
    emit(state.copyWith(isAddingNote: true, addNoteFailureOrUnit: none()));

    final failOrUnit = await fishRepository.addNotesToFish(
      fishId: event.fishId,
      note: event.note,
      session: event.session,
    );

    final newState = await failOrUnit.fold(
      (failure) async {
        return state.copyWith(
          addNoteFailureOrUnit: some(left(failure)),
          isAddingNote: false,
        );
      },
      (unit) async {
        return state.copyWith(
          addNoteFailureOrUnit: some(right(unit)),
          isAddingNote: false,
        );
      },
    );
    emit(newState);
  }

  Future<void> _onFishDeletedFromLibrary(
    FishDeletedFromLibrary event,
    Emitter<FishState> emit,
  ) async {
    emit(
      state.copyWith(
        isDeletingFromLibrary: true,
        deleteFromLibraryFailureOrUnit: none(),
      ),
    );

    final failOrUnit = await fishRepository.deleteFromLibrary(
      fishId: event.fishId,
      session: event.session,
    );

    final newState = await failOrUnit.fold(
      (failure) async {
        return state.copyWith(
          deleteFromLibraryFailureOrUnit: some(left(failure)),
          isDeletingFromLibrary: false,
        );
      },
      (unit) async {
        return state.copyWith(
          deleteFromLibraryFailureOrUnit: some(right(unit)),
          isDeletingFromLibrary: false,
        );
      },
    );
    emit(newState);
  }

  IFishRepository get fishRepository => _fishRepository;
  final IFishRepository _fishRepository;
}
