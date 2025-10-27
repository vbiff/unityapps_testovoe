import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/image_generation_bloc.dart';
import '../bloc/image_generation_event.dart';
import '../bloc/image_generation_state.dart';

/// Screen for displaying image generation results
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Generated Image',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            context.read<ImageGenerationBloc>().add(const ResetToPromptEvent());
            context.go('/');
          },
        ),
      ),
      body: BlocBuilder<ImageGenerationBloc, ImageGenerationState>(
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Prompt display
                  if (state is GeneratingImageState ||
                      state is ImageGeneratedState ||
                      state is ImageGenerationErrorState)
                    PromptDisplayWidget(prompt: _getPromptFromState(state)),

                  const SizedBox(height: 24),

                  // Main content area
                  Expanded(child: MainContentWidget(state: state)),

                  const SizedBox(height: 24),

                  // Action buttons
                  ActionButtonsWidget(state: state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getPromptFromState(ImageGenerationState state) {
    if (state is GeneratingImageState) return state.prompt;
    if (state is ImageGeneratedState) return state.prompt;
    if (state is ImageGenerationErrorState) return state.prompt;
    return '';
  }
}

/// Widget for displaying the user's prompt
class PromptDisplayWidget extends StatelessWidget {
  final String prompt;

  const PromptDisplayWidget({super.key, required this.prompt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.edit_note_rounded,
                color: theme.colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Your Prompt',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            prompt,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget for displaying the main content based on state
class MainContentWidget extends StatelessWidget {
  final ImageGenerationState state;

  const MainContentWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    if (state is GeneratingImageState) {
      return const LoadingContentWidget();
    } else if (state is ImageGeneratedState) {
      return ImageContentWidget(
        imageUrl: (state as ImageGeneratedState).imageUrl,
      );
    } else if (state is ImageGenerationErrorState) {
      return ErrorContentWidget(
        errorMessage: (state as ImageGenerationErrorState).errorMessage,
      );
    } else {
      // Fallback - shouldn't happen in normal flow
      return const LoadingContentWidget();
    }
  }
}

/// Widget for displaying loading state
class LoadingContentWidget extends StatelessWidget {
  const LoadingContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated loading indicator
          TweenAnimationBuilder<double>(
            duration: const Duration(seconds: 2),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.1),
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withValues(alpha: 0.1),
                    ],
                    stops: [0.0, value, 1.0],
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          Text(
            'Generating your image...',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'This may take a few moments',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),

          const SizedBox(height: 32),

          // Progress indicator
          Container(
            width: 200,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(seconds: 3),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Container(
                  width: 200 * value,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget for displaying generated image
class ImageContentWidget extends StatelessWidget {
  final String imageUrl;

  const ImageContentWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: ImageWidget(imageUrl: imageUrl),
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget for handling image display (base64 or network)
class ImageWidget extends StatelessWidget {
  final String imageUrl;

  const ImageWidget({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Check if it's a base64 data URL
    if (imageUrl.startsWith('data:image/')) {
      try {
        // Extract base64 data from data URL
        final base64Data = imageUrl.split(',')[1];
        final imageBytes = base64Decode(base64Data);

        return Image.memory(
          imageBytes,
          key: ValueKey(imageUrl),
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const ImageErrorWidget();
          },
        );
      } catch (e) {
        return const ImageErrorWidget();
      }
    } else {
      // Regular network URL
      return Image.network(
        imageUrl,
        key: ValueKey(imageUrl),
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Container(
            color: theme.colorScheme.surface,
            child: Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const ImageErrorWidget();
        },
      );
    }
  }
}

/// Widget for displaying image loading errors
class ImageErrorWidget extends StatelessWidget {
  const ImageErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            size: 64,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load image',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget for displaying error content
class ErrorContentWidget extends StatelessWidget {
  final String errorMessage;

  const ErrorContentWidget({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.refresh_rounded,
              size: 40,
              color: theme.colorScheme.primary,
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Let\'s Try Again',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              errorMessage,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget for action buttons
class ActionButtonsWidget extends StatelessWidget {
  final ImageGenerationState state;

  const ActionButtonsWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (state is GeneratingImageState) {
      return const SizedBox.shrink(); // No buttons during loading
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state is ImageGeneratedState) ...[
          // Try Another button
          ElevatedButton(
            onPressed: () {
              context.read<ImageGenerationBloc>().add(
                const RetryGenerationEvent(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, size: 20),
                SizedBox(width: 8),
                Text(
                  'Try Another',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

        if (state is ImageGenerationErrorState) ...[
          // Retry button
          ElevatedButton(
            onPressed: () {
              context.read<ImageGenerationBloc>().add(
                const RetryGenerationEvent(),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, size: 20),
                SizedBox(width: 8),
                Text(
                  'Retry',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

        // New Prompt button (always visible except during loading)
        OutlinedButton(
          onPressed: () {
            context.read<ImageGenerationBloc>().add(const ResetToPromptEvent());
            context.go('/');
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
            side: BorderSide(color: theme.colorScheme.primary),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit, size: 20),
              SizedBox(width: 8),
              Text(
                'New Prompt',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
