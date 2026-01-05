import 'package:flutter/material.dart';
import 'package:super_interactive_text/super_interactive_text.dart';

class CustomStylingScreen extends StatelessWidget {
  const CustomStylingScreen({super.key});

  static const _sampleText = '''
Visit https://flutter.dev for documentation.
Contact support@flutter.dev for help.
Call +966500000000 for urgent matters.
Follow @flutter_dev and use #Flutter
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Styling'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildExample(
              context,
              'Default Styling',
              const SuperInteractiveTextPreview(text: _sampleText),
            ),
            const SizedBox(height: 24),
            _buildExample(
              context,
              'Custom Colors',
              SuperInteractiveTextPreview(
                text: _sampleText,
                linkTextStyle: const TextStyle(
                  color: Colors.purple,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.purple,
                ),
                emailTextStyle: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
                phoneTextStyle: const TextStyle(
                  color: Colors.green,
                  decoration: TextDecoration.underline,
                ),
                usernameTextStyle: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
                hashtagTextStyle: const TextStyle(
                  color: Colors.pink,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildExample(
              context,
              'Bold & Large',
              SuperInteractiveTextPreview(
                text: _sampleText,
                normalTextStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                linkTextStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
                emailTextStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildExample(
              context,
              'Minimal Style',
              SuperInteractiveTextPreview(
                text: _sampleText,
                linkTextStyle: TextStyle(
                  color: Colors.grey.shade700,
                  decoration: TextDecoration.none,
                ),
                emailTextStyle: TextStyle(
                  color: Colors.grey.shade700,
                ),
                usernameTextStyle: TextStyle(
                  color: Colors.grey.shade600,
                ),
                hashtagTextStyle: TextStyle(
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExample(BuildContext context, String title, Widget child) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: child,
        ),
      ],
    );
  }
}
