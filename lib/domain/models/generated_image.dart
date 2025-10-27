import 'package:equatable/equatable.dart';

/// Domain model representing a generated image
class GeneratedImage extends Equatable {
  final String id;
  final String prompt;
  final String imageUrl;
  final DateTime createdAt;
  final ImageType type;

  const GeneratedImage({
    required this.id,
    required this.prompt,
    required this.imageUrl,
    required this.createdAt,
    required this.type,
  });

  @override
  List<Object?> get props => [id, prompt, imageUrl, createdAt, type];

  GeneratedImage copyWith({
    String? id,
    String? prompt,
    String? imageUrl,
    DateTime? createdAt,
    ImageType? type,
  }) {
    return GeneratedImage(
      id: id ?? this.id,
      prompt: prompt ?? this.prompt,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
    );
  }
}

/// Enum representing the type of image source
enum ImageType {
  apiNinjas,
}
