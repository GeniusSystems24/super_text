import 'package:flutter/material.dart';
import 'package:super_interactive_text/super_interactive_text.dart';
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
                'SuperInteractiveTextPreview can detect internal app routes and navigate to them directly within your app.',
          ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1),
          const SizedBox(height: 16),
          ExampleCard(
            title: 'Navigation Links',
            description: 'Click these links to navigate to other screens',
            code: '''SuperInteractiveTextPreview(
  text: \'\'\'Try these routes:
- Basic Usage: https://MyApp.com/basic
- Custom Styling: https://MyApp.com/styling
- Builder Pattern: https://MyApp.com/builder
- Interactive Demo: https://MyApp.com/interactive
- Fluter docs: https://MyApp.com/docs\'\'\',
)''',
            preview: const SuperInteractiveTextPreview(
              text: '''Try these routes:
- Basic Usage: https://MyApp.com/basic
- Custom Styling: https://MyApp.com/styling
- Builder Pattern: https://MyApp.com/builder
- Theming: https://MyApp.com/theming
- Real World: https://MyApp.com/real-world
- Social Media: https://MyApp.com/social-media
- Interactive Demo: https://MyApp.com/interactive
- Fluter docs: https://MyApp.com/docs''',
            ),
          )
              .animate()
              .fadeIn(duration: 300.ms, delay: 100.ms)
              .slideY(begin: 0.1),
          const SizedBox(height: 16),
          ExampleCard(
            title: 'Custom Route Styling',
            description: 'Routes can be styled differently from regular links',
            code: '''SuperInteractiveTextPreview(
  text: 'Go to https://MyApp.com/styling settings',
  routeTextStyle: TextStyle(
    color: Colors.deepOrange,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline,
    decorationStyle: TextDecorationStyle.dashed,
  ),
)''',
            preview: const SuperInteractiveTextPreview(
              text: 'Go to https://MyApp.com/styling settings',
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
