import '../models/generated_image.dart';

/// Abstract repository interface for image generation
///
/// This interface defines the contract for image generation operations
/// following the Repository pattern and Dependency Inversion Principle
abstract class ImageGenerationRepository {
  /// Generates an image based on the provided prompt
  ///
  /// Returns a [GeneratedImage] containing the image data and metadata
  /// Throws [ImageGenerationException] on failure
  Future<GeneratedImage> generateImage(String prompt);
}
