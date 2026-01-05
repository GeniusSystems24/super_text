import 'package:flutter/material.dart';
import 'package:super_interactive_text/super_interactive_text.dart';

class EditorFeaturesScreen extends StatefulWidget {
  const EditorFeaturesScreen({super.key});

  @override
  State<EditorFeaturesScreen> createState() => _EditorFeaturesScreenState();
}

class _EditorFeaturesScreenState extends State<EditorFeaturesScreen> {
  bool _autoDetect = true;
  bool _showToolbar = true;
  ToolbarPosition _toolbarPosition = ToolbarPosition.top;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor Features'),
      ),
      body: Column(
        children: [
          _buildOptionsPanel(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SuperInteractiveTextEditor(
                key: ValueKey('$_autoDetect$_showToolbar$_toolbarPosition'),
                initialText: '''
Explore the editor features!

Try typing URLs, emails, mentions, and hashtags.
Use the toolbar to format text and insert elements.

Example content:
- Website: https://flutter.dev
- Email: contact@flutter.dev
- Phone: +966500000000
- Mention: @flutter
- Hashtag: #FlutterDev
''',
                autoDetect: _autoDetect,
                showToolbar: _showToolbar,
                toolbarPosition: _toolbarPosition,
                mentionSuggestions: const [
                  'flutter',
                  'dart',
                  'google',
                  'android',
                  'ios',
                ],
                hashtagSuggestions: const [
                  'Flutter',
                  'Dart',
                  'Mobile',
                  'Development',
                  'OpenSource',
                ],
                linkColor: const Color(0xFF6750A4),
                emailColor: const Color(0xFF00897B),
                phoneColor: const Color(0xFFE65100),
                mentionColor: const Color(0xFF1565C0),
                hashtagColor: const Color(0xFFC2185B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Editor Options',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _buildSwitch(
                'Auto Detect',
                _autoDetect,
                (value) => setState(() => _autoDetect = value),
              ),
              _buildSwitch(
                'Show Toolbar',
                _showToolbar,
                (value) => setState(() => _showToolbar = value),
              ),
              _buildDropdown(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(fontSize: 13)),
        const SizedBox(width: 8),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDropdown() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Toolbar Position:', style: TextStyle(fontSize: 13)),
        const SizedBox(width: 8),
        DropdownButton<ToolbarPosition>(
          value: _toolbarPosition,
          underline: const SizedBox(),
          items: const [
            DropdownMenuItem(
              value: ToolbarPosition.top,
              child: Text('Top'),
            ),
            DropdownMenuItem(
              value: ToolbarPosition.bottom,
              child: Text('Bottom'),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              setState(() => _toolbarPosition = value);
            }
          },
        ),
      ],
    );
  }
}
