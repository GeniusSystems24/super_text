import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'screens/home_screen.dart';
import 'screens/basic_usage_screen.dart';
import 'screens/custom_styling_screen.dart';
import 'screens/builder_pattern_screen.dart';
import 'screens/theming_screen.dart';
import 'screens/real_world_screen.dart';
import 'screens/social_media_screen.dart';
import 'screens/interactive_demo_screen.dart';

void main() {
  runApp(const TextPreviewExampleApp());
}

class TextPreviewExampleApp extends StatelessWidget {
  const TextPreviewExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Text Preview - Examples',
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
      // extensions: [SuperTextPreviewTheme.light()],
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
      // extensions: [SuperTextPreviewTheme.dark()],
    );
  }
}
