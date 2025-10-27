/// Domain exception for image generation failures
class ImageGenerationException implements Exception {
  final String message;
  final String? code;
  final Exception? originalException;

  const ImageGenerationException(
    this.message, {
    this.code,
    this.originalException,
  });

  @override
  String toString() => 'ImageGenerationException: $message';
}

/// Specific exception types for better error handling
class NetworkException extends ImageGenerationException {
  const NetworkException(super.message, {super.originalException})
      : super(code: 'NETWORK_ERROR');
}

class ApiException extends ImageGenerationException {
  final int statusCode;

  const ApiException(super.message, this.statusCode, {super.originalException})
      : super(code: 'API_ERROR');
}

class ValidationException extends ImageGenerationException {
  const ValidationException(super.message)
      : super(code: 'VALIDATION_ERROR');
}
