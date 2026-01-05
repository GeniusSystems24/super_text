import 'package:flutter/material.dart';
import 'package:super_interactive_text/super_interactive_text.dart';

class BuilderPatternScreen extends StatelessWidget {
  const BuilderPatternScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Builder Pattern'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Custom Widget Builders',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Use the builder constructor to create custom widgets for each element type.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 24),
            _buildExample(context),
          ],
        ),
      ),
    );
  }

  Widget _buildExample(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SuperInteractiveTextPreview.builder(
        text: '''
Check out https://flutter.dev for docs.

Contact @flutter_team or email flutter@google.com

Popular tags: #Flutter #Dart #Mobile

Social: https://twitter.com/flutterdev
''',
        linkBuilder: (link) => Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.link, size: 14, color: Colors.blue.shade700),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  Uri.tryParse(link.text)?.host ?? link.text,
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        usernameBuilder: (mention) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.purple.shade200,
                child: Icon(Icons.person, size: 12, color: Colors.purple.shade700),
              ),
              const SizedBox(width: 4),
              Text(
                mention.text,
                style: TextStyle(
                  color: Colors.purple.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        hashtagBuilder: (hashtag) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade300, Colors.pink.shade300],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            hashtag.text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
        emailBuilder: (email) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.email, size: 14, color: Colors.green.shade700),
              const SizedBox(width: 4),
              Text(
                email.text,
                style: TextStyle(color: Colors.green.shade700),
              ),
            ],
          ),
        ),
        socialMediaBuilder: (social) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getSocialColor(social.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getSocialIcon(social.type),
                size: 16,
                color: _getSocialColor(social.type),
              ),
              const SizedBox(width: 4),
              Text(
                social.type.name,
                style: TextStyle(
                  color: _getSocialColor(social.type),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSocialColor(SocialMediaType type) {
    switch (type) {
      case SocialMediaType.twitter:
        return const Color(0xFF1DA1F2);
      case SocialMediaType.instagram:
        return const Color(0xFFE1306C);
      case SocialMediaType.facebook:
        return const Color(0xFF4267B2);
      case SocialMediaType.youtube:
        return const Color(0xFFFF0000);
      default:
        return Colors.grey;
    }
  }

  IconData _getSocialIcon(SocialMediaType type) {
    switch (type) {
      case SocialMediaType.twitter:
        return Icons.flutter_dash;
      case SocialMediaType.instagram:
        return Icons.camera_alt;
      case SocialMediaType.facebook:
        return Icons.facebook;
      case SocialMediaType.youtube:
        return Icons.play_circle;
      default:
        return Icons.link;
    }
  }
}
