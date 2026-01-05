import 'package:flutter/material.dart';
import 'package:super_interactive_text/super_interactive_text.dart';

class ThemingScreen extends StatefulWidget {
  const ThemingScreen({super.key});

  @override
  State<ThemingScreen> createState() => _ThemingScreenState();
}

class _ThemingScreenState extends State<ThemingScreen> {
  bool _isDarkTheme = false;

  static const _sampleText = '''
Welcome to Super Interactive Text!

Visit https://flutter.dev for documentation.
Contact support@example.com for help.
Call +966500000000 for support.

Follow @flutter_dev and join the community!
Popular tags: #Flutter #Dart #Mobile
''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theming'),
        actions: [
          IconButton(
            icon: Icon(_isDarkTheme ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => setState(() => _isDarkTheme = !_isDarkTheme),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'Light Theme Preset',
              SuperInteractiveTextPreview(
                text: _sampleText,
                textPreviewTheme: SuperInteractiveTextPreviewTheme.light(),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Dark Theme Preset',
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1B1F),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SuperInteractiveTextPreview(
                  text: _sampleText,
                  textPreviewTheme: SuperInteractiveTextPreviewTheme.dark(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Custom Theme',
              SuperInteractiveTextPreview(
                text: _sampleText,
                textPreviewTheme: SuperInteractiveTextPreviewTheme(
                  linkColor: const Color(0xFF6750A4),
                  emailColor: const Color(0xFF00897B),
                  phoneColor: const Color(0xFFE65100),
                  usernameColor: const Color(0xFF1565C0),
                  hashtagColor: const Color(0xFFC2185B),
                  normalTextStyle: const TextStyle(
                    fontSize: 15,
                    height: 1.6,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Gradient-Inspired Theme',
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.indigo.shade50,
                      Colors.purple.shade50,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SuperInteractiveTextPreview(
                  text: _sampleText,
                  textPreviewTheme: const SuperInteractiveTextPreviewTheme(
                    linkColor: Color(0xFF5C6BC0),
                    emailColor: Color(0xFF7B1FA2),
                    phoneColor: Color(0xFF512DA8),
                    usernameColor: Color(0xFF303F9F),
                    hashtagColor: Color(0xFF9C27B0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
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
        child,
      ],
    );
  }
}
