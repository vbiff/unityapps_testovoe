import 'package:equatable/equatable.dart';

/// Base class for all image generation states
abstract class ImageGenerationState extends Equatable {
  const ImageGenerationState();

  @override
  List<Object?> get props => [];
}

/// Initial state - user can enter a prompt
class PromptInputState extends ImageGenerationState {
  final String? savedPrompt;

  const PromptInputState({this.savedPrompt});

  @override
  List<Object?> get props => [savedPrompt];
}

/// State when image generation is in progress
class GeneratingImageState extends ImageGenerationState {
  final String prompt;

  const GeneratingImageState(this.prompt);

  @override
  List<Object?> get props => [prompt];
}

/// State when image generation is successful
class ImageGeneratedState extends ImageGenerationState {
  final String prompt;
  final String imageUrl;

  const ImageGeneratedState({required this.prompt, required this.imageUrl});

  @override
  List<Object?> get props => [prompt, imageUrl];
}

/// State when image generation fails
class ImageGenerationErrorState extends ImageGenerationState {
  final String prompt;
  final String errorMessage;

  const ImageGenerationErrorState({
    required this.prompt,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [prompt, errorMessage];
}
