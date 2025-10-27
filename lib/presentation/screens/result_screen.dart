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
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Generated Image',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Prompt display
                  if (state is GeneratingImageState ||
                      state is ImageGeneratedState ||
                      state is ImageGenerationErrorState)
                    _buildPromptDisplay(context, _getPromptFromState(state)),

                  const SizedBox(height: 24),

                  // Main content area
                  Expanded(child: _buildMainContent(context, state)),

                  const SizedBox(height: 24),

                  // Action buttons
                  _buildActionButtons(context, state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPromptDisplay(BuildContext context, String prompt) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit_note, color: Colors.deepPurple[600], size: 20),
              const SizedBox(width: 8),
              Text(
                'Your Prompt',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            prompt,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, ImageGenerationState state) {
    if (state is GeneratingImageState) {
      return _buildLoadingContent(context);
    } else if (state is ImageGeneratedState) {
      return _buildImageContent(state.imageUrl);
    } else if (state is ImageGenerationErrorState) {
      return _buildErrorContent(context, state.errorMessage);
    } else {
      // Fallback - shouldn't happen in normal flow
      return _buildLoadingContent(context);
    }
  }

  Widget _buildLoadingContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
                      Colors.deepPurple.withValues(alpha: 0.1),
                      Colors.deepPurple,
                      Colors.deepPurple.withValues(alpha: 0.1),
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
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'This may take a few moments',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
          ),

          const SizedBox(height: 32),

          // Progress indicator
          Container(
            width: 200,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(2),
            ),
            child: TweenAnimationBuilder<double>(
              duration: const Duration(seconds: 3),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Container(
                  width: 200 * value,
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
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

  Widget _buildImageContent(String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _buildImageWidget(imageUrl),
        ),
      ),
    );
  }

  Widget _buildImageWidget(String imageUrl) {
    // Check if it's a base64 data URL
    if (imageUrl.startsWith('data:image/')) {
      try {
        // Extract base64 data from data URL
        final base64Data = imageUrl.split(',')[1];
        final imageBytes = base64Decode(base64Data);

        return Image.memory(
          imageBytes,
          key: ValueKey(imageUrl),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return _buildImageError();
          },
        );
      } catch (e) {
        return _buildImageError();
      }
    } else {
      // Regular network URL
      return Image.network(
        imageUrl,
        key: ValueKey(imageUrl),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Container(
            color: Colors.grey[100],
            child: const Center(
              child: CircularProgressIndicator(color: Colors.deepPurple),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildImageError();
        },
      );
    }
  }

  Widget _buildImageError() {
    return Container(
      color: Colors.grey[100],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Failed to load image',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorContent(BuildContext context, String errorMessage) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.red[50],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.error_outline, size: 40, color: Colors.red[400]),
          ),

          const SizedBox(height: 24),

          Text(
            'Generation Failed',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              errorMessage,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, ImageGenerationState state) {
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
              backgroundColor: Colors.deepPurple,
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
              backgroundColor: Colors.deepPurple,
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
            foregroundColor: Colors.deepPurple,
            side: const BorderSide(color: Colors.deepPurple),
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

  String _getPromptFromState(ImageGenerationState state) {
    if (state is GeneratingImageState) return state.prompt;
    if (state is ImageGeneratedState) return state.prompt;
    if (state is ImageGenerationErrorState) return state.prompt;
    return '';
  }
}
