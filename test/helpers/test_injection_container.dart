import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:unityapps_testovoe/core/services/image_generation_service.dart'
    as service;
import 'package:unityapps_testovoe/data/datasources/image_generation_remote_datasource.dart';
import 'package:unityapps_testovoe/data/repository/image_generation_repository_impl.dart';
import 'package:unityapps_testovoe/domain/repository/image_generation_repository.dart';
import 'package:unityapps_testovoe/presentation/bloc/image_generation_bloc.dart';

// Mock classes for testing
class MockHttpClient extends Mock implements http.Client {}

class MockImageGenerationService extends Mock
    implements service.ImageGenerationService {}

class MockImageGenerationRemoteDataSource extends Mock
    implements ImageGenerationRemoteDataSource {}

class MockImageGenerationRepository extends Mock
    implements ImageGenerationRepository {}

/// Test dependency injection setup
///
/// This provides mock implementations for testing
class TestInjectionContainer {
  static final GetIt _getIt = GetIt.instance;

  /// Initialize test dependencies with mocks
  static Future<void> init() async {
    // Reset GetIt instance
    await _getIt.reset();

    // Register mocks
    _getIt.registerLazySingleton<http.Client>(() => MockHttpClient());

    _getIt.registerLazySingleton<service.ImageGenerationService>(
      () => MockImageGenerationService(),
    );

    _getIt.registerLazySingleton<ImageGenerationRemoteDataSource>(
      () => MockImageGenerationRemoteDataSource(),
    );

    _getIt.registerLazySingleton<ImageGenerationRepository>(
      () => MockImageGenerationRepository(),
    );

    _getIt.registerFactory<ImageGenerationBloc>(
      () =>
          ImageGenerationBloc(repository: _getIt<ImageGenerationRepository>()),
    );
  }

  /// Initialize test dependencies with real implementations
  static Future<void> initWithRealImplementations() async {
    // Reset GetIt instance
    await _getIt.reset();

    // Register real implementations for integration tests
    _getIt.registerLazySingleton<http.Client>(() => http.Client());

    _getIt.registerLazySingleton<service.ImageGenerationService>(
      () => service.ImageGenerationService(),
    );

    _getIt.registerLazySingleton<ImageGenerationRemoteDataSource>(
      () => ImageGenerationRemoteDataSourceImpl(
        imageGenerationService: _getIt<service.ImageGenerationService>(),
      ),
    );

    _getIt.registerLazySingleton<ImageGenerationRepository>(
      () => ImageGenerationRepositoryImpl(
        remoteDataSource: _getIt<ImageGenerationRemoteDataSource>(),
      ),
    );

    _getIt.registerFactory<ImageGenerationBloc>(
      () =>
          ImageGenerationBloc(repository: _getIt<ImageGenerationRepository>()),
    );
  }

  /// Get dependency by type
  static T get<T extends Object>() => _getIt<T>();

  /// Reset all dependencies
  static Future<void> reset() async {
    await _getIt.reset();
  }
}
