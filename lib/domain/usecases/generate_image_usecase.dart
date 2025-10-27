import '../models/generated_image.dart';
import '../repository/image_generation_repository.dart';

class GenerateImageUseCase {
  final ImageGenerationRepository repository;

  const GenerateImageUseCase(this.repository);

  Future<GeneratedImage> call(String prompt) async {
    return await repository.generateImage(prompt);
  }
}
