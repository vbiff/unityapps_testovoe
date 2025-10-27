import 'package:equatable/equatable.dart';

/// Base class for all image generation events
abstract class ImageGenerationEvent extends Equatable {
  const ImageGenerationEvent();

  @override
  List<Object?> get props => [];
}

/// Event to start image generation with a prompt
class GenerateImageEvent extends ImageGenerationEvent {
  final String prompt;

  const GenerateImageEvent(this.prompt);

  @override
  List<Object?> get props => [prompt];
}

/// Event to retry image generation with the same prompt
class RetryGenerationEvent extends ImageGenerationEvent {
  const RetryGenerationEvent();
}

/// Event to reset the state for a new prompt
class ResetToPromptEvent extends ImageGenerationEvent {
  const ResetToPromptEvent();
}
