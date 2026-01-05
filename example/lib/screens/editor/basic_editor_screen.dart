import 'package:flutter/material.dart';
import 'package:super_interactive_text/super_interactive_text.dart';

class BasicEditorScreen extends StatelessWidget {
  const BasicEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Editor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Interactive Text Editor',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Type text and watch as links, emails, mentions, and hashtags are automatically detected and styled.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SuperInteractiveTextEditor(
                initialText: '''
Welcome to the Super Interactive Text Editor!

Try typing:
- A URL like https://flutter.dev
- An email like hello@example.com
- A phone number like +966500000000
- A mention like @flutter_dev
- A hashtag like #Flutter

The editor will automatically detect and style these elements!
''',
                autoDetect: true,
                showToolbar: true,
                toolbarPosition: ToolbarPosition.top,
                onChanged: (text) {
                  debugPrint('Text changed: ${text.length} characters');
                },
                onLinkTap: (url) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Link: $url')),
                  );
                },
                onMentionTap: (username) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mention: $username')),
                  );
                },
                onHashtagTap: (hashtag) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Hashtag: $hashtag')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
