import 'package:flutter/material.dart';
import 'package:super_interactive_text/super_interactive_text.dart';

class HighlightTextScreen extends StatefulWidget {
  const HighlightTextScreen({super.key});

  @override
  State<HighlightTextScreen> createState() => _HighlightTextScreenState();
}

class _HighlightTextScreenState extends State<HighlightTextScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchText = 'flutter';

  @override
  void initState() {
    super.initState();
    _searchController.text = _searchText;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Highlighting'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search input
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search text to highlight',
                hintText: 'Enter text to highlight...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchText = '');
                  },
                ),
              ),
              onChanged: (value) {
                setState(() => _searchText = value);
              },
            ),
            const SizedBox(height: 24),

            _buildSection(
              context,
              'Basic Highlighting',
              'Highlight matching text with default theme colors:',
              SuperInteractiveTextPreview(
                text: '''
Flutter is Google's UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase.

With Flutter, you can build apps faster than ever. Flutter's hot reload helps you quickly and easily experiment, build UIs, add features, and fix bugs faster.
                ''',
                highlightText: _searchText,
              ),
            ),
            const SizedBox(height: 24),

            _buildSection(
              context,
              'Custom Highlight Colors',
              'Customize the highlight background and text colors:',
              SuperInteractiveTextPreview(
                text: '''
Learn Flutter development with comprehensive tutorials.
Flutter makes it easy to build beautiful apps.
Join the Flutter community today!
                ''',
                highlightText: _searchText,
                highlightColor: isDark
                    ? const Color(0xFF1B5E20)
                    : const Color(0xFFFFEB3B),
                highlightTextColor: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 24),

            _buildSection(
              context,
              'Custom Highlight Style',
              'Use a complete TextStyle for full control:',
              SuperInteractiveTextPreview(
                text: '''
Search results for "flutter":
1. Flutter SDK - The complete toolkit
2. Flutter Widgets - Build custom UIs
3. Flutter State Management - Handle app state
                ''',
                highlightText: _searchText,
                highlightTextStyle: TextStyle(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),

            _buildSection(
              context,
              'With Interactive Elements',
              'Highlighting works with links, mentions, and other interactive elements:',
              SuperInteractiveTextPreview(
                text: '''
Check out @flutter_dev on Twitter for Flutter updates!
Visit https://flutter.dev for documentation.
Email flutter-dev@googlegroups.com for support.
#Flutter #Dart #MobileDev
                ''',
                highlightText: _searchText,
                highlightColor: const Color(0xFFE1BEE7),
                highlightTextColor: const Color(0xFF4A148C),
                onLinkTap: (data) => _showSnackBar('Link: ${data.text}'),
                onUsernameTap: (data) => _showSnackBar('User: ${data.userId}'),
                onHashtagTap: (data) => _showSnackBar('Hashtag: ${data.title}'),
              ),
            ),
            const SizedBox(height: 24),

            _buildSection(
              context,
              'Case Sensitive',
              'Enable case-sensitive matching:',
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Case Insensitive (default):',
                    style: theme.textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  SuperInteractiveTextPreview(
                    text: 'Flutter, FLUTTER, flutter - all variations',
                    highlightText: 'flutter',
                    caseSensitiveHighlight: false,
                    highlightColor: Colors.green.shade200,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Case Sensitive:',
                    style: theme.textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  SuperInteractiveTextPreview(
                    text: 'Flutter, FLUTTER, flutter - only exact match',
                    highlightText: 'flutter',
                    caseSensitiveHighlight: true,
                    highlightColor: Colors.orange.shade200,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSection(
              context,
              'Arabic Text Support',
              'Highlighting works with Arabic and RTL text:',
              SuperInteractiveTextPreview(
                text: '''
جاري اكمال شاشات المحادثة وفصلها بنوع بيانات خاصة بها
مستقلة عن المصدر "موديلات api"

تطوير تطبيقات الجوال باستخدام فلاتر
                ''',
                highlightText: 'المحادثة',
                highlightColor: const Color(0xFF1B5E20),
                highlightTextColor: Colors.white,
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
