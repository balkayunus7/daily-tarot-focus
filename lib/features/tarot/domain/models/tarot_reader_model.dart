import 'package:mobile_boilerplate/common_dependencies.dart';

class TarotReaderModel {
  const TarotReaderModel({
    required this.id,
    required this.name,
    required this.title,
    required this.bio,
    required this.icon,
    required this.tags,
    required this.rating,
    required this.reviewCount,
    required this.aiPrompt,
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
      rating: json['rating'] as double,
      reviewCount: json['reviewCount'] as int,
      aiPrompt: json['aiPrompt'] as String,
    );
  }

  final String id;
  final String name;
  final String title;
  final String bio;
  final String icon;
  final KtList<TarotReaderTag> tags;
  final double rating;
  final int reviewCount;
  final String aiPrompt;
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
