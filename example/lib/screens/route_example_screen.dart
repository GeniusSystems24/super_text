import 'package:flutter/material.dart';
import 'package:super_text/super_text.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/example_card.dart';

class RouteExampleScreen extends StatelessWidget {
  const RouteExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Route Navigation'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const InfoCard(
            title: 'Internal Routing',
            description:
                'SuperTextPreview can detect internal app routes and navigate to them directly within your app.',
          ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1),
          const SizedBox(height: 16),
          ExampleCard(
            title: 'Navigation Links',
            description: 'Click these links to navigate to other screens',
            code: '''SuperTextPreview(
  text: \'\'\'Try these routes:
- Basic Usage: https://flutter.dev/basic
- Custom Styling: https://flutter.dev/styling
- Builder Pattern: https://flutter.dev/builder
- Interactive Demo: https://flutter.dev/interactive
- Fluter docs: https://flutter.dev/docs\'\'\',
)''',
            preview: const SuperTextPreview(
              text: '''Try these routes:
- Basic Usage: https://flutter.dev/basic
- Custom Styling: https://flutter.dev/styling
- Builder Pattern: https://flutter.dev/builder
- Theming: https://flutter.dev/theming
- Real World: https://flutter.dev/real-world
- Social Media: https://flutter.dev/social-media
- Interactive Demo: https://flutter.dev/interactive
- Fluter docs: https://flutter.dev/docs''',
            ),
          )
              .animate()
              .fadeIn(duration: 300.ms, delay: 100.ms)
              .slideY(begin: 0.1),
          const SizedBox(height: 16),
          ExampleCard(
            title: 'Custom Route Styling',
            description: 'Routes can be styled differently from regular links',
            code: '''SuperTextPreview(
  text: 'Go to https://flutter.dev/styling settings',
  routeTextStyle: TextStyle(
    color: Colors.deepOrange,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline,
    decorationStyle: TextDecorationStyle.dashed,
  ),
)''',
            preview: const SuperTextPreview(
              text: 'Go to https://flutter.dev/styling settings',
              routeTextStyle: TextStyle(
                color: Colors.deepOrange,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.dashed,
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 300.ms, delay: 200.ms)
              .slideY(begin: 0.1),
        ],
      ),
    );
  }
}
