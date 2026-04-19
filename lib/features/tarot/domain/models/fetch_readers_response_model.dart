import 'package:mobile_boilerplate/common_dependencies.dart';

class FetchReadersResponseModel {
  const FetchReadersResponseModel({required this.readers});

  factory FetchReadersResponseModel.fromMap(Map<String, dynamic> map) {
    return FetchReadersResponseModel(
      readers: KtList.from(
        map.entries.map((e) => TarotReaderModel.fromMap(e.value as Map<String, dynamic>)),
      ),
    );
  }

  final KtList<TarotReaderModel> readers;
}

typedef FetchReadersResponse = FetchReadersResponseModel;

class TarotReaderModel {
  const TarotReaderModel({
    required this.id,
    required this.name,
    required this.title,
    required this.bio,
    required this.tags,
    required this.aiPrompt,
    required this.imageUrl,
  });

  factory TarotReaderModel.fromMap(Map<String, dynamic> map) {
    return TarotReaderModel(
      id: map['id'] as String,
      name: map['name'] as String,
      title: map['title'] as String,
      bio: map['bio'] as String,
      tags:
          (map['tags'] as List<dynamic>)
              .map((e) => ReaderTagModel.fromMap(e as Map<String, dynamic>))
              .toImmutableList(),
      aiPrompt: map['ai_prompt'] as String,
      imageUrl: map['image_url'] as String,
    );
  }

  factory TarotReaderModel.fromJson(Map<String, dynamic> json) => TarotReaderModel.fromMap(json);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'bio': bio,
      'tags': tags.asList().map((e) => e.toMap()).toList(),
      'ai_prompt': aiPrompt,
      'image_url': imageUrl,
    };
  }

  Map<String, dynamic> toJson() => toMap();

  final String id;
  final String name;
  final String title;
  final String bio;
  final KtList<ReaderTagModel> tags;
  final String aiPrompt;
  final String imageUrl;
}

class ReaderTagModel {
  const ReaderTagModel({
    required this.emoji,
    required this.label,
  });

  factory ReaderTagModel.fromMap(Map<String, dynamic> map) {
    return ReaderTagModel(
      emoji: map['emoji'] as String,
      label: map['label'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'emoji': emoji,
      'label': label,
    };
  }

  final String emoji;
  final String label;
}
