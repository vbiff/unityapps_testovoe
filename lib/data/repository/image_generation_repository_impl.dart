import 'dart:math';
import '../../domain/exceptions/image_generation_exception.dart';
import '../../domain/models/generated_image.dart';
import '../../domain/repository/image_generation_repository.dart';
import '../datasources/image_generation_remote_datasource.dart';

/// Concrete implementation of ImageGenerationRepository
///
/// This class uses only remote data source for image generation
/// and implements the business logic for image generation
class ImageGenerationRepositoryImpl implements ImageGenerationRepository {
  final ImageGenerationRemoteDataSource remoteDataSource;

  ImageGenerationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<GeneratedImage> generateImage(String prompt) async {
    // Validate prompt
    if (prompt.trim().isEmpty || prompt.trim().length < 3) {
      throw const ValidationException(
        'Prompt must be at least 3 characters long',
      );
    }

    try {
      // Generate image using remote API only
      final imageUrl = await remoteDataSource.generateImageFromApi(prompt);

      final generatedImage = GeneratedImage(
        id: _generateId(),
        prompt: prompt,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
        type: ImageType.apiNinjas,
      );

      return generatedImage;
    } catch (e) {
      // Re-throw all exceptions - no fallback handling
      rethrow;
    }
  }

  /// Generates a unique ID for the image
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(1000).toString();
  }
}
