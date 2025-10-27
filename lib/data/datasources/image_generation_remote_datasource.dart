import '../../core/services/image_generation_service.dart' as service;
import '../../domain/exceptions/image_generation_exception.dart';

abstract class ImageGenerationRemoteDataSource {
  Future<String> generateImageFromApi(String prompt);
}

class ImageGenerationRemoteDataSourceImpl
    implements ImageGenerationRemoteDataSource {
  final service.ImageGenerationService _imageGenerationService;

  const ImageGenerationRemoteDataSourceImpl({
    required service.ImageGenerationService imageGenerationService,
  }) : _imageGenerationService = imageGenerationService;

  @override
  Future<String> generateImageFromApi(String prompt) async {
    try {
      final imageUrl = await _imageGenerationService.generate(prompt);
      return imageUrl;
    } on service.ImageGenerationException catch (e) {
      throw ImageGenerationException(e.message);
    } catch (e) {
      throw NetworkException(
        'Network error occurred while generating image',
        originalException: e is Exception ? e : null,
      );
    }
  }
}
