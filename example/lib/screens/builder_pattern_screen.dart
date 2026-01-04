import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:super_text/super_text.dart';

import '../widgets/example_card.dart';

class BuilderPatternScreen extends StatelessWidget {
  const BuilderPatternScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Builder Pattern'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const InfoCard(
            title: 'Builder Pattern',
            description:
                'Create custom widgets for each data type instead of using TextSpan',
            icon: Icons.construction_rounded,
          ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1),

          const SizedBox(height: 20),

          // Example 1: Link Builder with Chip
          ExampleCard(
            title: '1. Link as Chip',
            description: 'Transform links into clickable chip elements',
            code: '''SuperTextPreview.builder(
  text: 'Visit https://flutter.dev for more',
  linkBuilder: (link) => Container(
    margin: EdgeInsets.symmetric(horizontal: 4),
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.link, size: 14, color: colorScheme.primary),
        SizedBox(width: 4),
        Text(Uri.parse(link.text).host),
      ],
    ),
  ),
)''',
            preview: SuperTextPreview.builder(
              text: 'Visit https://flutter.dev for more info',
              linkBuilder: (link) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.link, size: 14, color: colorScheme.primary),
                    const SizedBox(width: 4),
                    Text(
                      Uri.parse(link.text).host,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 300.ms, delay: 100.ms)
              .slideY(begin: 0.1),

          const SizedBox(height: 16),

          // Example 2: Email with Icon
          ExampleCard(
            title: '2. Email with Icon',
            description: 'Add an email icon next to email addresses',
            code: '''SuperTextPreview.builder(
  text: 'Contact us at support@company.com',
  emailBuilder: (email) => Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.blue.shade400, Colors.blue.shade600],
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.email, size: 14, color: Colors.white),
        SizedBox(width: 6),
        Text(email.text, style: TextStyle(color: Colors.white)),
      ],
    ),
  ),
)''',
            preview: SuperTextPreview.builder(
              text: 'Contact us at support@company.com',
              emailBuilder: (email) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.blue.shade600],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.email, size: 14, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      email.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 300.ms, delay: 200.ms)
              .slideY(begin: 0.1),

          const SizedBox(height: 16),

          // Example 3: Phone with Call Button
          ExampleCard(
            title: '3. Phone with Call Button',
            description: 'Transform phone numbers into call buttons',
            code: '''SuperTextPreview.builder(
  text: 'Call us at +966501234567',
  phoneBuilder: (phone) => Container(
    decoration: BoxDecoration(
      color: Colors.green.shade50,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.green.shade200),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(Icons.call, size: 12, color: Colors.white),
        ),
        SizedBox(width: 8),
        Text(phone.text),
      ],
    ),
  ),
)''',
            preview: SuperTextPreview.builder(
              text: 'Call us at +966501234567',
              phoneBuilder: (phone) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(Icons.call,
                                size: 12, color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            phone.text,
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 300.ms, delay: 300.ms)
              .slideY(begin: 0.1),

          const SizedBox(height: 16),

          // Example 4: Username with Avatar
          ExampleCard(
            title: '4. Username with Avatar',
            description: 'Display usernames with an avatar',
            code: '''SuperTextPreview.builder(
  text: 'Follow @flutter_dev on Twitter',
  usernameBuilder: (username) => Container(
    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: Colors.purple.shade50,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 10,
          child: Text(username.userId[0].toUpperCase()),
        ),
        SizedBox(width: 4),
        Text(username.text),
      ],
    ),
  ),
)''',
            preview: SuperTextPreview.builder(
              text: 'Follow @flutter_dev on Twitter',
              usernameBuilder: (username) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.purple.shade200,
                      child: Text(
                        username.userId[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      username.text,
                      style: TextStyle(
                        color: Colors.purple.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 300.ms, delay: 400.ms)
              .slideY(begin: 0.1),

          const SizedBox(height: 16),

          // Example 5: Hashtag with Badge
          ExampleCard(
            title: '5. Hashtag Badges',
            description: 'Convert hashtags into colorful badge elements',
            code: '''SuperTextPreview.builder(
  text: 'We share #FlutterDev and #Dart content',
  hashtagBuilder: (hashtag) => Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [_getHashtagColor(hashtag.title), ...],
      ),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      hashtag.text,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
  ),
)''',
            preview: SuperTextPreview.builder(
              text: 'We share #FlutterDev and #Dart and #MobileDev content',
              hashtagBuilder: (hashtag) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getHashtagColor(hashtag.title),
                      _getHashtagColor(hashtag.title).withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: _getHashtagColor(hashtag.title).withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  hashtag.text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 300.ms, delay: 500.ms)
              .slideY(begin: 0.1),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  static Color _getHashtagColor(String tag) {
    final colors = [
      Colors.blue,
      Colors.purple,
      Colors.teal,
      Colors.orange,
      Colors.pink,
      Colors.indigo,
    ];
    return colors[tag.hashCode.abs() % colors.length];
  }
}
