import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_all_cards_response_model.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/fetch_spreads_response_model.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';

class TarotSelectedReadingCard with EquatableMixin {
  const TarotSelectedReadingCard({
    required this.positionIndex,
    required this.card,
    required this.position,
    required this.isReversed,
  });

  final int positionIndex;
  final TarotCardModel card;
  final TarotSpreadPositionModel position;
  final bool isReversed;

  TarotSelectedReadingCard copyWith({
    int? positionIndex,
    TarotCardModel? card,
    TarotSpreadPositionModel? position,
    bool? isReversed,
  }) {
    return TarotSelectedReadingCard(
      positionIndex: positionIndex ?? this.positionIndex,
      card: card ?? this.card,
      position: position ?? this.position,
      isReversed: isReversed ?? this.isReversed,
    );
  }

  @override
  List<Object?> get props => [positionIndex, card, position, isReversed];
}
