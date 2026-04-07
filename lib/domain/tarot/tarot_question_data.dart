import 'package:daily_tarot_focus/domain/auth/tarot_user.dart';
import 'package:daily_tarot_focus/domain/tarot/tarot_data.dart';

class TarotQuestionData {
  const TarotQuestionData({
    required this.user,
    required this.topic,
    required this.question,
    required this.drawnCards,
    required this.drawnCardReversedStates,
    required this.language,
  });

  final TarotUser user;
  final String topic;
  final String? question;
  final List<TarotCard> drawnCards;
  final List<bool> drawnCardReversedStates;
  final String language;

  Map<String, dynamic> toMap() {
    final positions = drawnCards.length == 1 ? ['present'] : ['past', 'present', 'future'];

    return {
      'user': {
        'zodiac': user.zodiac?.localizedName,
        'relationship_status': user.relationshipStatus?.localizedName,
        'birth_date': user.birthDate?.toIso8601String(),
        'age': user.age,
      },
      'reading': {
        'topic': topic,
        'question': question,
        'card_count': drawnCards.length,
        'cards': List.generate(drawnCards.length, (i) {
          final card = drawnCards[i];
          final isReversed = i < drawnCardReversedStates.length && drawnCardReversedStates[i];

          final topicKey = switch (topic.toLowerCase()) {
            'love' => 'love',
            'career' => 'career',
            'health' || 'spirituality' => 'spirituality',
            _ => 'general',
          };

          return {
            'id': card.id,
            'title': card.title,
            'position': positions[i],
            'is_reversed': isReversed,
            'contextual_meaning': card.contextualMeanings.byTopic(topicKey),
            'advice': card.advice,
            'affirmation': card.affirmation,
          };
        }),
      },
      'language': language,
    };
  }
}
