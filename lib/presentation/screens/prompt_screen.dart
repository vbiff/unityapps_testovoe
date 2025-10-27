import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/image_generation_bloc.dart';
import '../bloc/image_generation_event.dart';
import '../bloc/image_generation_state.dart';

/// Screen for entering image generation prompts
class PromptScreen extends StatefulWidget {
  const PromptScreen({super.key});

  @override
  State<PromptScreen> createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen> {
  late final TextEditingController _promptController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _promptController = TextEditingController();
    _focusNode = FocusNode();

    // Set initial text if there's a saved prompt
    final state = context.read<ImageGenerationBloc>().state;
    if (state is PromptInputState && state.savedPrompt != null) {
      _promptController.text = state.savedPrompt!;
    }
  }

  @override
  void dispose() {
    _promptController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onGeneratePressed() {
    final prompt = _promptController.text.trim();
    if (prompt.isNotEmpty) {
      context.read<ImageGenerationBloc>().add(GenerateImageEvent(prompt));
      context.go('/result');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'AI Image Generator',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Header section
              const Icon(
                Icons.auto_awesome,
                size: 64,
                color: Colors.deepPurple,
              ),
              const SizedBox(height: 24),

              Text(
                'Create Amazing Images',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              Text(
                'Describe what you want to see and let AI bring it to life',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 48),

              // Input section
              Container(
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Prompt',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                          ),
                          const SizedBox(height: 12),

                          // Text input field
                          TextField(
                            controller: _promptController,
                            focusNode: _focusNode,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: 'Describe what you want to see...',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.deepPurple,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              contentPadding: const EdgeInsets.all(16),
                              filled: true,
                              fillColor: Colors.grey[50],
                            ),
                            style: const TextStyle(fontSize: 16),
                            onChanged: (_) => setState(() {}),
                            onSubmitted: (_) {
                              if (_promptController.text.trim().isNotEmpty) {
                                _onGeneratePressed();
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    // Generate button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _promptController,
                        builder: (context, value, child) {
                          final isEnabled = value.text.trim().isNotEmpty;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            child: ElevatedButton(
                              onPressed: isEnabled ? _onGeneratePressed : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                disabledBackgroundColor: Colors.grey[300],
                                disabledForegroundColor: Colors.grey[500],
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: isEnabled ? 2 : 0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    size: 20,
                                    color: isEnabled
                                        ? Colors.white
                                        : Colors.grey[500],
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Generate',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isEnabled
                                          ? Colors.white
                                          : Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Tips section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: Colors.deepPurple[700],
                      size: 24,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tip: Be specific and descriptive for better results',
                      style: TextStyle(
                        color: Colors.deepPurple[700],
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
