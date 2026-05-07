import 'package:daily_tarot_focus/features/zodiac/domain/models/generate_compatibility_response_model.dart';
import 'package:mobile_boilerplate/common_dependencies.dart';
import 'package:mobile_boilerplate/domain/common/failure.dart';
import 'package:mobile_boilerplate/extensions.dart';

class ZodiacState extends Equatable {
  const ZodiacState({
    required this.isGeneratingCompatibility,
    required this.fetchCompatibilityFailureOrResult,
  });

  factory ZodiacState.initial() => const ZodiacState(
    isGeneratingCompatibility: false,
    fetchCompatibilityFailureOrResult: None(),
  );

  final bool isGeneratingCompatibility;
  final Option<FailureOr<GenerateCompatibilityResponse>> fetchCompatibilityFailureOrResult;

  bool get hasGeneratedCompatibilitySucceeded =>
      fetchCompatibilityFailureOrResult.getOrNull()?.getRightOrNull() != null;

  bool get hasGeneratedCompatibilityFailed =>
      fetchCompatibilityFailureOrResult.getOrNull()?.getLeftOrNull() != null;

  GenerateCompatibilityResponse? get compatibilityResponseOrNull =>
      fetchCompatibilityFailureOrResult.getOrNull()?.getRightOrNull();

  ZodiacState copyWith({
    bool? isGeneratingCompatibility,
    Option<FailureOr<GenerateCompatibilityResponse>>? fetchCompatibilityFailureOrResult,
  }) {
    return ZodiacState(
      isGeneratingCompatibility: isGeneratingCompatibility ?? this.isGeneratingCompatibility,
      fetchCompatibilityFailureOrResult:
          fetchCompatibilityFailureOrResult ?? this.fetchCompatibilityFailureOrResult,
    );
  }

  @override
  List<Object?> get props => [isGeneratingCompatibility, fetchCompatibilityFailureOrResult];
}
