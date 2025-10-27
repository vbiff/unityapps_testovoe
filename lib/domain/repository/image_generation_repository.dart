import '../models/generated_image.dart';

abstract class ImageGenerationRepository {
  Future<GeneratedImage> generateImage(String prompt);
}
