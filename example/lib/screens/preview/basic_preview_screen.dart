import 'package:flutter/material.dart';
import 'package:super_interactive_text/super_interactive_text.dart';

class BasicPreviewScreen extends StatelessWidget {
  const BasicPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Preview'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              'Auto-Detection Example',
              'The widget automatically detects and styles different types of content:',
              SuperInteractiveTextPreview(
                text: '''
Hello! Welcome to Super Interactive Text.

Visit our website: https://flutter.dev
Email us at: contact@flutter.dev
Call us: +966500000000

Follow us:
@flutter_dev
#Flutter #Dart #MobileDev

Check out our social media:
https://twitter.com/flutterdev
https://youtube.com/flutterdev
                ''',
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              'Mixed Content',
              'Interactive elements work seamlessly within regular text:',
              const SuperInteractiveTextPreview(
                text: 'Contact @john_doe at john@example.com or call +1234567890. '
                    'Visit https://example.com for more info. #contact #support',
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              'With Callbacks',
              'Handle taps on different elements:',
              SuperInteractiveTextPreview(
                text: 'Tap on @username, #hashtag, or https://example.com',
                onUsernameTap: (data) {
                  _showSnackBar(context, 'Username tapped: ${data.userId}');
                },
                onHashtagTap: (data) {
                  _showSnackBar(context, 'Hashtag tapped: ${data.title}');
                },
                onLinkTap: (data) {
                  _showSnackBar(context, 'Link tapped: ${data.text}');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String description,
    Widget child,
  ) {
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
        const SizedBox(height: 4),
        Text(
          description,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outlineVariant,
            ),
          ),
          child: child,
        ),
      ],
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
