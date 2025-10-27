import '../models/generated_image.dart';
import '../repository/image_generation_repository.dart';

/// Use case for generating images
///
/// This class encapsulates the business logic for image generation
/// following the Single Responsibility Principle
class GenerateImageUseCase {
  final ImageGenerationRepository repository;

  const GenerateImageUseCase(this.repository);

  /// Execute the use case to generate an image
  ///
  /// [prompt] - The text prompt for image generation
  /// Returns a [GeneratedImage] on success
  /// Throws [ImageGenerationException] on failure
  Future<GeneratedImage> call(String prompt) async {
    return await repository.generateImage(prompt);
  }
}
