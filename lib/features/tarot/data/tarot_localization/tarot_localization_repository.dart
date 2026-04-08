import 'package:daily_tarot_focus/features/tarot/data/tarot_localization/i_tarot_localization_service.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_card_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_category_enum.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';

class ImplTarotLocalizationRepository {
  ImplTarotLocalizationRepository(this._tarotLocalizationService);

  Future<FailureOr<List<TarotCardModel>>> getCards(String languageCode) async {
    try {
      return right(await tarotLocalizationService.getCards(languageCode));
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  Future<FailureOr<TarotCardModel>> drawRandomCard(String languageCode) async {
    try {
      return right(await tarotLocalizationService.drawRandomCard(languageCode));
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  Future<FailureOr<TarotCardModel?>> findCardByTitle(String languageCode, String title) async {
    try {
      return right(await tarotLocalizationService.findCardByTitle(languageCode, title));
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  Future<FailureOr<TarotCardModel?>> findCardById(String languageCode, String id) async {
    try {
      return right(await tarotLocalizationService.findCardById(languageCode, id));
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  Future<FailureOr<List<TarotCardModel>>> getCardsByCategory(
    String languageCode,
    TarotCategory category,
  ) async {
    try {
      return right(
        await tarotLocalizationService.getCardsByCategory(languageCode, category),
      );
    } on Exception {
      return left(const UnknownFailure());
    }
  }

  void clearCache() => tarotLocalizationService.clearCache();

  final ITarotLocalizationService _tarotLocalizationService;
  ITarotLocalizationService get tarotLocalizationService => _tarotLocalizationService;
}
