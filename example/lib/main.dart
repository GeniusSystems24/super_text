import 'package:flutter/material.dart';
import 'package:super_interactive_text/super_interactive_text.dart';

import 'screens/home_screen.dart';
import 'screens/preview/basic_preview_screen.dart';
import 'screens/preview/custom_styling_screen.dart';
import 'screens/preview/builder_pattern_screen.dart';
import 'screens/preview/theming_screen.dart';
import 'screens/preview/routing_screen.dart';
import 'screens/preview/highlight_text_screen.dart';
import 'screens/editor/basic_editor_screen.dart';
import 'screens/editor/editor_with_controller_screen.dart';
import 'screens/editor/editor_features_screen.dart';

void main() {
  // Configure routes before running the app
  SuperInteractiveTextDataParser.configure(
    RouteConfig(
      baseAddresses: ['https://example.com', 'example://'],
      routes: [
        RouteDefinition(
          name: 'home',
          pattern: r'home$',
          parameterNames: {},
          onNavigate: (context, data) {
            Navigator.pushNamed(context, '/');
          },
        ),
        RouteDefinition(
          name: 'user-profile',
          pattern: r'users/([^/]+)',
          parameterNames: {'userId': true},
          onNavigate: (context, data) {
            final userId = data.pathParameters['userId'];
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Navigate to user: $userId')),
            );
          },
        ),
        RouteDefinition(
          name: 'post-detail',
          pattern: r'posts/([^/]+)',
          parameterNames: {'postId': true},
          onNavigate: (context, data) {
            final postId = data.pathParameters['postId'];
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Navigate to post: $postId')),
            );
          },
        ),
      ],
    ),
  );

  runApp(const SuperInteractiveTextExampleApp());
}

class SuperInteractiveTextExampleApp extends StatelessWidget {
  const SuperInteractiveTextExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Interactive Text Examples',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        // Preview screens
        '/preview/basic': (context) => const BasicPreviewScreen(),
        '/preview/styling': (context) => const CustomStylingScreen(),
        '/preview/builder': (context) => const BuilderPatternScreen(),
        '/preview/theming': (context) => const ThemingScreen(),
        '/preview/routing': (context) => const RoutingScreen(),
        '/preview/highlight': (context) => const HighlightTextScreen(),
        // Editor screens
        '/editor/basic': (context) => const BasicEditorScreen(),
        '/editor/controller': (context) => const EditorWithControllerScreen(),
        '/editor/features': (context) => const EditorFeaturesScreen(),
      },
    );
  }
}
