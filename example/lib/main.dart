import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:super_interactive_text/super_interactive_text.dart';
import 'screens/home_screen.dart';
import 'screens/basic_usage_screen.dart';
import 'screens/custom_styling_screen.dart';
import 'screens/builder_pattern_screen.dart';
import 'screens/theming_screen.dart';
import 'screens/real_world_screen.dart';
import 'screens/social_media_screen.dart';
import 'screens/interactive_demo_screen.dart';
import 'screens/route_example_screen.dart';
import 'utils.dart';

void main() {
  // Example of flexible route configuration
  SuperInteractiveTextDataParser.configure(
    RouteConfig(
      baseAddresses: ['https://MyApp.com'],
      routes: [
        RouteDefinition(
          name: 'basic-screen',
          pattern: r'basic$',
          parameterNames: {},
          onNavigate: (context, data) {
            Navigator.pushNamed(context, '/basic');
            showToast(context, 'Navigated to Basic Usage');
          },
        ),
        RouteDefinition(
          name: 'styling-screen',
          pattern: r'styling$',
          parameterNames: {},
          onNavigate: (context, data) {
            Navigator.pushNamed(context, '/styling');
            showToast(context, 'Navigated to Custom Styling');
          },
        ),
        RouteDefinition(
          name: 'builder-screen',
          pattern: r'builder$',
          parameterNames: {},
          onNavigate: (context, data) {
            Navigator.pushNamed(context, '/builder');
            showToast(context, 'Navigated to Builder Pattern');
          },
        ),
        RouteDefinition(
          name: 'theming-screen',
          pattern: r'theming$',
          parameterNames: {},
          onNavigate: (context, data) {
            Navigator.pushNamed(context, '/theming');
            showToast(context, 'Navigated to Theming');
          },
        ),
        RouteDefinition(
          name: 'real-world-screen',
          pattern: r'real-world$',
          parameterNames: {},
          onNavigate: (context, data) {
            Navigator.pushNamed(context, '/real-world');
            showToast(context, 'Navigated to Real World Example');
          },
        ),
        RouteDefinition(
          name: 'social-media-screen',
          pattern: r'social-media$',
          parameterNames: {},
          onNavigate: (context, data) {
            Navigator.pushNamed(context, '/social-media');
            showToast(context, 'Navigated to Social Media');
          },
        ),
        RouteDefinition(
          name: 'interactive-screen',
          pattern: r'interactive$',
          parameterNames: {},
          onNavigate: (context, data) {
            Navigator.pushNamed(context, '/interactive');
            showToast(context, 'Navigated to Interactive Demo');
          },
        ),
        RouteDefinition(
          name: 'route-screen',
          pattern: r'routes$',
          parameterNames: {},
          onNavigate: (context, data) {
            Navigator.pushNamed(context, '/routes');
            showToast(context, 'Navigated to Route Examples');
          },
        ),
      ],
    ),
  );

  runApp(const TextPreviewExampleApp());
}

class TextPreviewExampleApp extends StatelessWidget {
  const TextPreviewExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super Interactive Text - Examples',
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/basic': (context) => const BasicUsageScreen(),
        '/styling': (context) => const CustomStylingScreen(),
        '/builder': (context) => const BuilderPatternScreen(),
        '/theming': (context) => const ThemingScreen(),
        '/real-world': (context) => const RealWorldScreen(),
        '/social-media': (context) => const SocialMediaScreen(),
        '/interactive': (context) => const InteractiveDemoScreen(),
        '/routes': (context) => const RouteExampleScreen(),
      },
    );
  }

  ThemeData _buildLightTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.light,
      primary: const Color(0xFF6750A4),
      secondary: const Color(0xFF625B71),
      tertiary: const Color(0xFF7D5260),
      surface: const Color(0xFFFFFBFE),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.cairoTextTheme().copyWith(
        displayLarge: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.cairo(fontWeight: FontWeight.w700),
        headlineMedium: GoogleFonts.cairo(fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.cairo(fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.cairo(),
        bodyMedium: GoogleFonts.cairo(),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      // extensions: [SuperInteractiveTextPreviewTheme.light()],
    );
  }

  ThemeData _buildDarkTheme() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF6750A4),
      brightness: Brightness.dark,
      primary: const Color(0xFFD0BCFF),
      secondary: const Color(0xFFCCC2DC),
      tertiary: const Color(0xFFEFB8C8),
      surface: const Color(0xFF1C1B1F),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme:
          GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.cairo(fontWeight: FontWeight.w700),
        headlineMedium: GoogleFonts.cairo(fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.cairo(fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.cairo(),
        bodyMedium: GoogleFonts.cairo(),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      // extensions: [SuperInteractiveTextPreviewTheme.dark()],
    );
  }
}
