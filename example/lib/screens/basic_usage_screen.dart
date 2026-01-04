import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:super_text/super_text.dart';

import '../widgets/example_card.dart';

class BasicUsageScreen extends StatelessWidget {
  const BasicUsageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Usage'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const InfoCard(
            title: 'Simple Usage',
            description:
                'The simplest way to use SuperTextPreview is to pass the text directly',
          ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1),
          const SizedBox(height: 16),
          ExampleCard(
            title: 'Simple Text with Link',
            description: 'Basic example with a clickable URL',
            code: '''SuperTextPreview(
  text: 'Visit our website at https://flutter.dev',
)''',
            preview: const SuperTextPreview(
              text: 'Visit our website at https://flutter.dev',
            ),
          )
              .animate()
              .fadeIn(duration: 300.ms, delay: 100.ms)
              .slideY(begin: 0.1),
          const SizedBox(height: 16),
          ExampleCard(
            title: 'Email and Phone Number',
            description: 'Detecting and styling emails and phone numbers',
            code: '''SuperTextPreview(
  text: 'Contact us at support@example.com\\n'
        'Or call +966555555555',
)''',
            preview: const SuperTextPreview(
              text: 'Contact us at support@example.com\nOr call +966555555555',
            ),
          )
              .animate()
              .fadeIn(duration: 300.ms, delay: 200.ms)
              .slideY(begin: 0.1),
          const SizedBox(height: 16),
          ExampleCard(
            title: 'Username and Hashtag',
            description: 'Recognizing @mentions and #hashtags',
            code: '''SuperTextPreview(
  text: 'Follow @flutter_dev and use #FlutterDev',
)''',
            preview: const SuperTextPreview(
              text: 'Follow @flutter_dev and use #FlutterDev',
            ),
          )
              .animate()
              .fadeIn(duration: 300.ms, delay: 300.ms)
              .slideY(begin: 0.1),
          const SizedBox(height: 16),
          ExampleCard(
            title: 'Comprehensive Example',
            description: 'All types of interactive text in one widget',
            code: '''SuperTextPreview(
  text: \'\'\'Hello! 👋
Website: https://flutter.dev
Email: contact@flutter.dev
Phone: +966500000000
Follow: @FlutterDev #Flutter #Dart\'\'\',
)''',
            preview: const SuperTextPreview(
              text: '''Hello! 👋
Website: https://flutter.dev
Email: contact@flutter.dev
Phone: +966500000000
Follow: @FlutterDev #Flutter #Dart''',
            ),
          )
              .animate()
              .fadeIn(duration: 300.ms, delay: 400.ms)
              .slideY(begin: 0.1),
          const SizedBox(height: 24),
          const TipCard(
            tip:
                'For better performance when displaying the same text multiple times, use parsedText instead of text to avoid re-parsing.',
          ).animate().fadeIn(duration: 300.ms, delay: 500.ms),
          const SizedBox(height: 16),
          ExampleCard(
            title: 'Using parsedText',
            description: 'Pre-parse text for better performance',
            code: '''// Parse once
final parsedData = SuperTextData.parse(
  'Pre-parsed text https://example.com',
  save: true,
);

// Use multiple times
SuperTextPreview(
  parsedText: parsedData,
)''',
            preview: SuperTextPreview(
              parsedText: SuperTextData.parse(
                'This text was pre-parsed https://example.com',
                save: true,
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 300.ms, delay: 600.ms)
              .slideY(begin: 0.1),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
