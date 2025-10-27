import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/exceptions/image_generation_exception.dart';
import '../../domain/repository/image_generation_repository.dart';
import 'image_generation_event.dart';
import 'image_generation_state.dart';

/// BLoC for managing image generation state and business logic
class ImageGenerationBloc
    extends Bloc<ImageGenerationEvent, ImageGenerationState> {
  final ImageGenerationRepository _repository;
  String? _currentPrompt;

  ImageGenerationBloc({required ImageGenerationRepository repository})
    : _repository = repository,
      super(const PromptInputState()) {
    on<GenerateImageEvent>(_onGenerateImage);
    on<RetryGenerationEvent>(_onRetryGeneration);
    on<ResetToPromptEvent>(_onResetToPrompt);
  }

  /// Handles image generation with a new prompt
  Future<void> _onGenerateImage(
    GenerateImageEvent event,
    Emitter<ImageGenerationState> emit,
  ) async {
    _currentPrompt = event.prompt;
    emit(GeneratingImageState(event.prompt));

    try {
      final generatedImage = await _repository.generateImage(event.prompt);
      emit(
        ImageGeneratedState(
          prompt: event.prompt,
          imageUrl: generatedImage.imageUrl,
        ),
      );
    } on ImageGenerationException catch (e) {
      emit(
        ImageGenerationErrorState(
          prompt: event.prompt,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        ImageGenerationErrorState(
          prompt: event.prompt,
          errorMessage: 'An unexpected error occurred. Please try again.',
        ),
      );
    }
  }

  /// Handles retry generation with the same prompt
  Future<void> _onRetryGeneration(
    RetryGenerationEvent event,
    Emitter<ImageGenerationState> emit,
  ) async {
    if (_currentPrompt != null) {
      emit(GeneratingImageState(_currentPrompt!));

      try {
        final generatedImage = await _repository.generateImage(_currentPrompt!);
        emit(
          ImageGeneratedState(
            prompt: _currentPrompt!,
            imageUrl: generatedImage.imageUrl,
          ),
        );
      } on ImageGenerationException catch (e) {
        emit(
          ImageGenerationErrorState(
            prompt: _currentPrompt!,
            errorMessage: e.message,
          ),
        );
      } catch (e) {
        emit(
          ImageGenerationErrorState(
            prompt: _currentPrompt!,
            errorMessage: 'An unexpected error occurred. Please try again.',
          ),
        );
      }
    }
  }

  /// Handles reset to prompt input state while preserving the current prompt
  void _onResetToPrompt(
    ResetToPromptEvent event,
    Emitter<ImageGenerationState> emit,
  ) {
    emit(PromptInputState(savedPrompt: _currentPrompt));
  }
}
