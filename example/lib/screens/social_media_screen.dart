import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:super_interactive_text/super_interactive_text.dart';

class SocialMediaScreen extends StatelessWidget {
  const SocialMediaScreen({super.key});

  static const _socialPosts = [
    _SocialPost(
      platform: 'Twitter',
      icon: Icons.flutter_dash,
      color: Color(0xFF1DA1F2),
      username: '@FlutterDev',
      content: '''🎉 Flutter 3.19 is here!

Check out the new features: https://flutter.dev/release

#Flutter #Dart #CrossPlatform #MobileDev''',
      likes: 2453,
      retweets: 892,
    ),
    _SocialPost(
      platform: 'Instagram',
      icon: Icons.camera_alt,
      color: Color(0xFFE4405F),
      username: '@flutter_community',
      content: '''📱 Beautiful UI built with Flutter!

Follow us for more: @flutter_dev
Contact: hello@flutter.dev

#FlutterUI #AppDev #UI #UX''',
      likes: 5621,
      retweets: 0,
    ),
    _SocialPost(
      platform: 'LinkedIn',
      icon: Icons.work,
      color: Color(0xFF0077B5),
      username: 'Flutter Team',
      content: '''We're hiring Flutter developers!

Apply at: https://careers.google.com/flutter
Email: jobs@flutter.dev
Phone: +1-650-253-0000

#Hiring #FlutterJobs #TechCareers''',
      likes: 1234,
      retweets: 456,
    ),
    _SocialPost(
      platform: 'YouTube',
      icon: Icons.play_circle,
      color: Color(0xFFFF0000),
      username: 'Flutter',
      content: '''🎬 New tutorial is live!

Watch now: https://youtube.com/watch?v=flutter

Subscribe: @FlutterChannel
#FlutterTutorial #LearnToCode''',
      likes: 8765,
      retweets: 234,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Social Media')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _socialPosts.length,
        itemBuilder: (context, index) {
          return _SocialPostCard(post: _socialPosts[index])
              .animate()
              .fadeIn(
                  duration: 300.ms, delay: Duration(milliseconds: index * 100))
              .slideY(begin: 0.1);
        },
      ),
    );
  }
}

class _SocialPost {
  final String platform;
  final IconData icon;
  final Color color;
  final String username;
  final String content;
  final int likes;
  final int retweets;

  const _SocialPost({
    required this.platform,
    required this.icon,
    required this.color,
    required this.username,
    required this.content,
    required this.likes,
    required this.retweets,
  });
}

class _SocialPostCard extends StatelessWidget {
  final _SocialPost post;

  const _SocialPostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: post.color.withOpacity(0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: post.color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(post.icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.platform,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: post.color,
                        ),
                      ),
                      Text(
                        post.username,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: SuperInteractiveTextPreview(
              text: post.content,
              linkTextStyle: TextStyle(
                color: post.color,
                decoration: TextDecoration.underline,
                decorationColor: post.color,
              ),
              emailTextStyle: TextStyle(
                color: post.color.withOpacity(0.8),
                decoration: TextDecoration.underline,
              ),
              phoneTextStyle: const TextStyle(
                color: Colors.green,
                decoration: TextDecoration.underline,
              ),
              usernameTextStyle: TextStyle(
                color: post.color,
                fontWeight: FontWeight.bold,
              ),
              hashtagTextStyle: TextStyle(
                color: post.color.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
              onLinkTap: (link) => _showAction(context, 'Open: ${link.text}'),
              onEmailTap: (email) =>
                  _showAction(context, 'Mail: ${email.text}'),
              onPhoneTap: (phone) =>
                  _showAction(context, 'Call: ${phone.text}'),
              onUsernameTap: (u) => _showAction(context, 'View: ${u.text}'),
              onHashtagTap: (h) => _showAction(context, 'Search: ${h.text}'),
            ),
          ),
          // Actions
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                    color: colorScheme.outlineVariant.withOpacity(0.5)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _ActionButton(
                  icon: Icons.favorite_border,
                  label: _formatNumber(post.likes),
                  color: Colors.red,
                ),
                if (post.retweets > 0)
                  _ActionButton(
                    icon: Icons.repeat,
                    label: _formatNumber(post.retweets),
                    color: Colors.green,
                  ),
                _ActionButton(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  color: colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAction(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  String _formatNumber(int num) {
    if (num >= 1000) {
      return '${(num / 1000).toStringAsFixed(1)}K';
    }
    return num.toString();
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18, color: color),
      label: Text(label, style: TextStyle(color: color, fontSize: 12)),
    );
  }
}
