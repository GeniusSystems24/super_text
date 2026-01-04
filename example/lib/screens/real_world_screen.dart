import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:super_interactive_text/super_interactive_text.dart';

class RealWorldScreen extends StatefulWidget {
  const RealWorldScreen({super.key});

  @override
  State<RealWorldScreen> createState() => _RealWorldScreenState();
}

class _RealWorldScreenState extends State<RealWorldScreen> {
  final _messages = <_ChatMessage>[
    _ChatMessage(
      sender: 'Ahmed',
      text:
          'Hello! Have you seen the new project? https://github.com/flutter/flutter',
      isMe: false,
      time: '10:30 AM',
      avatar: 'A',
    ),
    _ChatMessage(
      sender: 'You',
      text: 'Yes! It is amazing 🔥',
      isMe: true,
      time: '10:32 AM',
      avatar: 'Y',
    ),
    _ChatMessage(
      sender: 'Ahmed',
      text:
          'Okay, here are the details:\n📧 dev@flutter.io\n📱 +966501234567\n👤 @flutter_team',
      isMe: false,
      time: '10:35 AM',
      avatar: 'A',
    ),
    _ChatMessage(
      sender: 'Sarah',
      text: 'Hi 👋\nhttps://flutter.dev\ncontact@example.com\n#flutter #dart',
      isMe: false,
      time: '10:40 AM',
      avatar: 'S',
    ),
  ];

  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add(_ChatMessage(
        sender: 'You',
        text: _controller.text,
        isMe: true,
        time: 'Now',
        avatar: 'Y',
      ));
      _controller.clear();
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Interactive Chat')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _ChatBubble(
                  message: message,
                  onLinkTap: (l) => _showSnackBar('Link: ${l.text}'),
                  onEmailTap: (e) => _showSnackBar('Mail: ${e.text}'),
                  onPhoneTap: (p) => _showSnackBar('Phone: ${p.text}'),
                  onUsernameTap: (u) => _showSnackBar('User: ${u.text}'),
                  onHashtagTap: (h) => _showSnackBar('Hashtag: ${h.text}'),
                ).animate().fadeIn(duration: 300.ms);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            color: colorScheme.surface,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton.small(
                  onPressed: _sendMessage,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage {
  final String sender, text, time, avatar;
  final bool isMe;
  _ChatMessage({
    required this.sender,
    required this.text,
    required this.isMe,
    required this.time,
    required this.avatar,
  });
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;
  final void Function(LinkTextData) onLinkTap;
  final void Function(EmailTextData) onEmailTap;
  final void Function(PhoneNumberTextData) onPhoneTap;
  final void Function(UsernameTextData) onUsernameTap;
  final void Function(HashtagTextData) onHashtagTap;

  const _ChatBubble({
    required this.message,
    required this.onLinkTap,
    required this.onEmailTap,
    required this.onPhoneTap,
    required this.onUsernameTap,
    required this.onHashtagTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            message.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isMe)
            CircleAvatar(radius: 16, child: Text(message.avatar)),
          if (!message.isMe) const SizedBox(width: 8),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isMe
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!message.isMe)
                    Text(message.sender,
                        style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  SuperInteractiveTextPreview(
                    text: message.text,
                    normalTextStyle: TextStyle(
                      color: message.isMe
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                    ),
                    linkTextStyle: TextStyle(
                      color:
                          message.isMe ? Colors.white70 : colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                    onLinkTap: onLinkTap,
                    onEmailTap: onEmailTap,
                    onPhoneTap: onPhoneTap,
                    onUsernameTap: onUsernameTap,
                    onHashtagTap: onHashtagTap,
                  ),
                  Text(message.time,
                      style: TextStyle(
                          fontSize: 10,
                          color: message.isMe
                              ? Colors.white54
                              : colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
          ),
          if (message.isMe) const SizedBox(width: 8),
          if (message.isMe)
            CircleAvatar(radius: 16, child: Text(message.avatar)),
        ],
      ),
    );
  }
}
