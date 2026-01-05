import 'package:flutter/material.dart';
import 'package:super_interactive_text/super_interactive_text.dart';

class RoutingScreen extends StatelessWidget {
  const RoutingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Internal Routing'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard(context),
            const SizedBox(height: 24),
            Text(
              'Try These Links',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildExample(
              context,
              'User Profile Links',
              '''
Check out these user profiles:
https://example.com/users/john_doe
https://example.com/users/flutter_dev
https://example.com/users/12345
''',
            ),
            const SizedBox(height: 16),
            _buildExample(
              context,
              'Post Links',
              '''
Popular posts:
https://example.com/posts/hello-world
https://example.com/posts/flutter-tips
https://example.com/posts/dart-basics
''',
            ),
            const SizedBox(height: 16),
            _buildExample(
              context,
              'Mixed Content',
              '''
Hey @john_doe! Check out this post:
https://example.com/posts/amazing-tutorial

Or visit the author's profile:
https://example.com/users/flutter_expert

Contact: support@example.com
''',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'How It Works',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Routes are configured in main.dart using RouteConfig. '
            'When a matching URL is tapped, the onNavigate callback is triggered.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Configured Routes:',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildRouteInfo('/users/{userId}', 'User profile'),
                _buildRouteInfo('/posts/{postId}', 'Post detail'),
                _buildRouteInfo('/home', 'Home page'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteInfo(String pattern, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              pattern,
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildExample(BuildContext context, String title, String text) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: SuperInteractiveTextPreview(
            text: text,
            onRouteTap: (route) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Route: ${route.routeName}\n'
                    'Parameters: ${route.pathParameters}',
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
