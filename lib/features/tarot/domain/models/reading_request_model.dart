import 'package:daily_tarot_focus/features/auth/domain/models/tarot_user.dart';
import 'package:daily_tarot_focus/features/tarot/domain/models/tarot_card_model.dart';
import 'package:mobile_boilerplate/domain/auth/auth_session.dart';

typedef ReadingRequest = ReadingRequestModel;

class ReadingRequestModel {
  const ReadingRequestModel({
    required this.session,
    required this.data,
  });

  final AuthSession session;
  final TarotQuestionData data;
}

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
  final List<TarotCardModel> drawnCards;
  final List<bool> drawnCardReversedStates;
  final String language;

  Map<String, dynamic> toMap() => {
    'user': _userMap,
    'reading': _readingMap,
    'language': language,
  };

  Map<String, dynamic> get _userMap => {
    'zodiac': user.zodiac?.localizedName,
    'relationship_status': user.relationshipStatus?.localizedName,
    'career_status': user.careerStatus?.localizedName,
  };

  Map<String, dynamic> get _readingMap => {
    'topic': topic,
    'question': question,
    'card_count': drawnCards.length,
    'cards': _cardMaps,
  };

  List<Map<String, dynamic>> get _cardMaps {
    final positions = drawnCards.length == 1 ? ['present'] : ['past', 'present', 'future'];

    final topicKey = switch (topic.toLowerCase()) {
      'love' => 'love',
      'career' => 'career',
      'health' || 'spirituality' => 'spirituality',
      _ => 'general',
    };

    return List.generate(drawnCards.length, (i) {
      final card = drawnCards[i];
      final isReversed = i < drawnCardReversedStates.length && drawnCardReversedStates[i];

      return {
        'id': card.id,
        'name': card.name,
        'position': positions[i],
        'is_reversed': isReversed,
        'contextual_meaning': isReversed
            ? card.reversed.byTopic(topicKey)
            : card.upright.byTopic(topicKey),
        'upright_keywords': card.uprightKeywords,
        'reversed_keywords': card.reversedKeywords,
      };
    });
  }
}

class TarotQuestionDraftData {
  const TarotQuestionDraftData({
    required this.topic,
    required this.question,
    required this.cardCount,
  });

  final String topic;
  final String question;
  final int cardCount;
}
