import 'package:mobile_boilerplate/common_dependencies.dart';

class TarotReaderModel {
  const TarotReaderModel({
    required this.id,
    required this.name,
    required this.title,
    required this.bio,
    required this.icon,
    required this.tags,
    required this.aiPrompt,
    required this.image,
  });

  factory TarotReaderModel.fromJson(Map<String, dynamic> json) {
    return TarotReaderModel(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      bio: json['bio'] as String,
      icon: json['icon'] as String,
      tags:
          (json['tags'] as List<dynamic>)
              .map((e) => TarotReaderTag.fromJson(e as Map<String, dynamic>))
              .toImmutableList(),
      aiPrompt: json['aiPrompt'] as String,
      image: json['image'] as String,
    );
  }

  final String id;
  final String name;
  final String title;
  final String bio;
  final String icon;
  final KtList<TarotReaderTag> tags;
  final String aiPrompt;
  final String image;
}

class TarotReaderTag {
  const TarotReaderTag({
    required this.label,
    required this.emoji,
  });

  factory TarotReaderTag.fromJson(Map<String, dynamic> json) {
    return TarotReaderTag(
      label: json['label'] as String,
      emoji: json['emoji'] as String,
    );
  }

  final String label;
  final String emoji;
}
