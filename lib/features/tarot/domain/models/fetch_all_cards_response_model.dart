import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_card_model.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

typedef FetchAllCardsResponse = FetchAllCardsResponseModel;

class FetchAllCardsResponseModel with EquatableMixin {
  const FetchAllCardsResponseModel({required this.cards});

  factory FetchAllCardsResponseModel.fromMap(Map<String, dynamic> map) {
    return FetchAllCardsResponseModel(
      cards: KtList.from(
        (map['cards'] as List<dynamic>?)
                ?.map((e) => TarotCardModel.fromMap(e as Map<String, dynamic>))
                .toList() ??
            [],
      ),
    );
  }

  final KtList<TarotCardModel> cards;

  @override
  List<Object?> get props => [cards];
}
