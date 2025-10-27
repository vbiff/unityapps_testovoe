import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../../data/datasources/image_generation_remote_datasource.dart';
import '../../data/repository/image_generation_repository_impl.dart';
import '../../domain/repository/image_generation_repository.dart';
import '../../presentation/bloc/image_generation_bloc.dart';
import '../services/image_generation_service.dart' as service;

/// Dependency injection setup using GetIt
///
/// This provides a centralized way to register and access dependencies
/// throughout the application following the Service Locator pattern
final GetIt getIt = GetIt.instance;

/// Initialize all dependencies
Future<void> initializeDependencies() async {
  // External dependencies
  getIt.registerLazySingleton<http.Client>(() => http.Client());

  // Services
  getIt.registerLazySingleton<service.ImageGenerationService>(
    () => service.ImageGenerationService(),
  );

  // Data sources
  getIt.registerLazySingleton<ImageGenerationRemoteDataSource>(
    () => ImageGenerationRemoteDataSourceImpl(
      imageGenerationService: getIt<service.ImageGenerationService>(),
    ),
  );

  // Repository
  getIt.registerLazySingleton<ImageGenerationRepository>(
    () => ImageGenerationRepositoryImpl(
      remoteDataSource: getIt<ImageGenerationRemoteDataSource>(),
    ),
  );

  // BLoC - Register as factory since we want new instances
  getIt.registerFactory<ImageGenerationBloc>(
    () => ImageGenerationBloc(repository: getIt<ImageGenerationRepository>()),
  );
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await getIt.reset();
}
