import 'package:flutter/material.dart';
import 'package:super_interactive_text/super_interactive_text.dart';

class EditorWithControllerScreen extends StatefulWidget {
  const EditorWithControllerScreen({super.key});

  @override
  State<EditorWithControllerScreen> createState() =>
      _EditorWithControllerScreenState();
}

class _EditorWithControllerScreenState
    extends State<EditorWithControllerScreen> {
  late InteractiveEditorController _controller;
  String _exportedText = '';

  @override
  void initState() {
    super.initState();
    _controller = InteractiveEditorController(
      initialText: 'Hello World! Start typing...',
      autoDetect: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editor with Controller'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Controller API Demo',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Use the controller to programmatically insert elements and export content.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            _buildActionButtons(),
            const SizedBox(height: 16),
            Expanded(
              flex: 2,
              child: SuperInteractiveTextEditor(
                controller: _controller,
                showToolbar: true,
              ),
            ),
            const SizedBox(height: 16),
            _buildExportSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _ActionButton(
          icon: Icons.link,
          label: 'Insert Link',
          color: Colors.blue,
          onPressed: () {
            _controller.insertLink(
              'https://flutter.dev',
              displayText: 'Flutter',
            );
          },
        ),
        _ActionButton(
          icon: Icons.alternate_email,
          label: 'Insert @',
          color: Colors.purple,
          onPressed: () {
            _controller.insertMention('flutter_dev');
          },
        ),
        _ActionButton(
          icon: Icons.tag,
          label: 'Insert #',
          color: Colors.pink,
          onPressed: () {
            _controller.insertHashtag('Flutter');
          },
        ),
        _ActionButton(
          icon: Icons.email,
          label: 'Insert Email',
          color: Colors.green,
          onPressed: () {
            _controller.insertEmail('hello@flutter.dev');
          },
        ),
        _ActionButton(
          icon: Icons.phone,
          label: 'Insert Phone',
          color: Colors.orange,
          onPressed: () {
            _controller.insertPhone('+966500000000');
          },
        ),
        _ActionButton(
          icon: Icons.format_bold,
          label: 'Bold',
          color: Colors.grey,
          onPressed: () {
            _controller.toggleBold();
          },
        ),
        _ActionButton(
          icon: Icons.format_italic,
          label: 'Italic',
          color: Colors.grey,
          onPressed: () {
            _controller.toggleItalic();
          },
        ),
        _ActionButton(
          icon: Icons.clear,
          label: 'Clear',
          color: Colors.red,
          onPressed: () {
            _controller.clear();
          },
        ),
      ],
    );
  }

  Widget _buildExportSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Export',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              TextButton.icon(
                icon: const Icon(Icons.text_fields, size: 18),
                label: const Text('Text'),
                onPressed: () {
                  setState(() {
                    _exportedText = _controller.exportAsPlainText();
                  });
                },
              ),
              TextButton.icon(
                icon: const Icon(Icons.code, size: 18),
                label: const Text('JSON'),
                onPressed: () {
                  setState(() {
                    _exportedText = _controller.exportAsJson().toString();
                  });
                },
              ),
            ],
          ),
          if (_exportedText.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _exportedText,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                ),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
