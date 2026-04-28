import 'package:mobile_boilerplate/common_dependencies.dart';

class GenerateReadingResponse with EquatableMixin {
  const GenerateReadingResponse({
    required this.id,
    required this.interpretation,
  });

  factory GenerateReadingResponse.fromMap(Map<String, dynamic> map) {
    return GenerateReadingResponse(
      id: map['id'] as String? ?? '',
      interpretation: map['interpretation'] as String? ?? '',
    );
  }

  final String id;
  final String interpretation;

  @override
  List<Object?> get props => [id, interpretation];
}
