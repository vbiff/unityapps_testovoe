import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/screens/prompt_screen.dart';
import '../../presentation/screens/result_screen.dart';

/// Application router configuration using go_router
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'prompt',
        builder: (context, state) => const PromptScreen(),
      ),
      GoRoute(
        path: '/result',
        name: 'result',
        builder: (context, state) => const ResultScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Error'), backgroundColor: Colors.red),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
