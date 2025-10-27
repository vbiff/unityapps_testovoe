import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class ImageGenerationService {
  static const String _apiKey =
      'TMaLleFh75AnMbFgI+o6QA==0E2DEyoXCbv9Xtl8'; // Replace with actual API key
  static const String _baseUrl = 'https://api.api-ninjas.com/v1/randomimage';

  /// Generates an image based on the provided prompt
  ///
  /// Returns either a base64 data URL from API Ninjas or a fallback URL
  /// Has approximately 50% chance of throwing an exception to simulate API errors
  Future<String> generate(String prompt) async {
    // Simulate network delay (2-3 seconds)
    final delaySeconds = 2 + Random().nextDouble(); // 2.0 to 3.0 seconds
    await Future.delayed(Duration(milliseconds: (delaySeconds * 1000).round()));

    // Simulate ~50% failure rate for testing purposes
    if (Random().nextBool()) {
      throw ImageGenerationException(
        'Failed to generate image. Please try again.',
      );
    }

    try {
      // Make API call to API Ninjas
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'X-Api-Key': _apiKey,
          'Accept': 'image/jpg', // API Ninjas expects this for image response
        },
      );

      if (response.statusCode == 200) {
        // API Ninjas returns binary image data
        // Convert to base64 data URL for display in Flutter
        final base64Image = base64Encode(response.bodyBytes);
        return 'data:image/jpeg;base64,$base64Image';
      } else {
        throw ImageGenerationException(
          'API request failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is ImageGenerationException) {
        rethrow;
      }
      // Re-throw any other exceptions as ImageGenerationException
      throw ImageGenerationException(
        'Network error occurred. Please try again.',
      );
    }
  }
}

class ImageGenerationException implements Exception {
  final String message;

  const ImageGenerationException(this.message);

  @override
  String toString() => 'ImageGenerationException: $message';
}
