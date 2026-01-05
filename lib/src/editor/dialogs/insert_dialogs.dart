import 'package:flutter/material.dart';

/// Dialog for inserting a link
class InsertLinkDialog extends StatefulWidget {
  const InsertLinkDialog({
    super.key,
    this.initialUrl,
    this.initialDisplayText,
  });

  final String? initialUrl;
  final String? initialDisplayText;

  static Future<LinkDialogResult?> show(
    BuildContext context, {
    String? initialUrl,
    String? initialDisplayText,
  }) {
    return showDialog<LinkDialogResult>(
      context: context,
      builder: (context) => InsertLinkDialog(
        initialUrl: initialUrl,
        initialDisplayText: initialDisplayText,
      ),
    );
  }

  @override
  State<InsertLinkDialog> createState() => _InsertLinkDialogState();
}

class _InsertLinkDialogState extends State<InsertLinkDialog> {
  late final TextEditingController _urlController;
  late final TextEditingController _displayTextController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.initialUrl);
    _displayTextController =
        TextEditingController(text: widget.initialDisplayText);
  }

  @override
  void dispose() {
    _urlController.dispose();
    _displayTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Insert Link'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'URL',
                hintText: 'https://example.com',
                prefixIcon: Icon(Icons.link),
              ),
              keyboardType: TextInputType.url,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a URL';
                }
                if (!Uri.tryParse(value)!.isAbsolute ?? true) {
                  return 'Please enter a valid URL';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _displayTextController,
              decoration: const InputDecoration(
                labelText: 'Display Text (optional)',
                hintText: 'Click here',
                prefixIcon: Icon(Icons.text_fields),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Insert'),
        ),
      ],
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(
        context,
        LinkDialogResult(
          url: _urlController.text,
          displayText: _displayTextController.text.isEmpty
              ? null
              : _displayTextController.text,
        ),
      );
    }
  }
}

class LinkDialogResult {
  const LinkDialogResult({
    required this.url,
    this.displayText,
  });

  final String url;
  final String? displayText;
}

/// Dialog for inserting a mention
class InsertMentionDialog extends StatefulWidget {
  const InsertMentionDialog({
    super.key,
    this.suggestions,
  });

  final List<String>? suggestions;

  static Future<String?> show(
    BuildContext context, {
    List<String>? suggestions,
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) => InsertMentionDialog(suggestions: suggestions),
    );
  }

  @override
  State<InsertMentionDialog> createState() => _InsertMentionDialogState();
}

class _InsertMentionDialogState extends State<InsertMentionDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Insert Mention'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Username',
              hintText: 'username',
              prefixText: '@',
              prefixIcon: Icon(Icons.alternate_email),
            ),
          ),
          if (widget.suggestions != null && widget.suggestions!.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Suggestions:',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.suggestions!
                  .map(
                    (s) => ActionChip(
                      label: Text('@$s'),
                      onPressed: () => Navigator.pop(context, s),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              Navigator.pop(context, _controller.text);
            }
          },
          child: const Text('Insert'),
        ),
      ],
    );
  }
}

/// Dialog for inserting a hashtag
class InsertHashtagDialog extends StatefulWidget {
  const InsertHashtagDialog({
    super.key,
    this.suggestions,
  });

  final List<String>? suggestions;

  static Future<String?> show(
    BuildContext context, {
    List<String>? suggestions,
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) => InsertHashtagDialog(suggestions: suggestions),
    );
  }

  @override
  State<InsertHashtagDialog> createState() => _InsertHashtagDialogState();
}

class _InsertHashtagDialogState extends State<InsertHashtagDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Insert Hashtag'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Hashtag',
              hintText: 'flutter',
              prefixText: '#',
              prefixIcon: Icon(Icons.tag),
            ),
          ),
          if (widget.suggestions != null && widget.suggestions!.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Trending:',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.suggestions!
                  .map(
                    (s) => ActionChip(
                      label: Text('#$s'),
                      onPressed: () => Navigator.pop(context, s),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              Navigator.pop(context, _controller.text);
            }
          },
          child: const Text('Insert'),
        ),
      ],
    );
  }
}

/// Dialog for inserting email
class InsertEmailDialog extends StatefulWidget {
  const InsertEmailDialog({super.key});

  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (context) => const InsertEmailDialog(),
    );
  }

  @override
  State<InsertEmailDialog> createState() => _InsertEmailDialogState();
}

class _InsertEmailDialogState extends State<InsertEmailDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Insert Email'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Email Address',
            hintText: 'user@example.com',
            prefixIcon: Icon(Icons.email),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, _controller.text);
            }
          },
          child: const Text('Insert'),
        ),
      ],
    );
  }
}

/// Dialog for inserting phone number
class InsertPhoneDialog extends StatefulWidget {
  const InsertPhoneDialog({super.key});

  static Future<String?> show(BuildContext context) {
    return showDialog<String>(
      context: context,
      builder: (context) => const InsertPhoneDialog(),
    );
  }

  @override
  State<InsertPhoneDialog> createState() => _InsertPhoneDialogState();
}

class _InsertPhoneDialogState extends State<InsertPhoneDialog> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Insert Phone Number'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Phone Number',
            hintText: '+966500000000',
            prefixIcon: Icon(Icons.phone),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a phone number';
            }
            final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');
            if (digitsOnly.length < 7 || digitsOnly.length > 15) {
              return 'Please enter a valid phone number';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, _controller.text);
            }
          },
          child: const Text('Insert'),
        ),
      ],
    );
  }
}
