import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart';
import 'core/router/app_router.dart';
import 'presentation/bloc/image_generation_bloc.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ImageGenerationBloc>(),
      child: MaterialApp.router(
        title: 'AI Image Generator',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: 'SF Pro Display',
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
            headlineMedium: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.25,
            ),
            titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              shadowColor: Colors.black.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
            ),
          ),
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
