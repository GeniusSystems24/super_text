import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:super_interactive_text/super_interactive_text.dart';

class ThemingScreen extends StatefulWidget {
  const ThemingScreen({super.key});

  @override
  State<ThemingScreen> createState() => _ThemingScreenState();
}

class _ThemingScreenState extends State<ThemingScreen> {
  bool _isDarkMode = false;
  double _fontSize = 14.0;
  double _borderRadius = 12.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final customTheme = _buildCustomTheme();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theming'),
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => setState(() => _isDarkMode = !_isDarkMode),
            tooltip: _isDarkMode ? 'Light Mode' : 'Dark Mode',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _InfoCard(
            icon: Icons.palette_outlined,
            title: 'SuperInteractiveTextPreviewTheme',
            description:
                'Use SuperInteractiveTextPreviewTheme for full control over text appearance throughout the app',
          ).animate().fadeIn(duration: 300.ms).slideX(begin: -0.1),
          const SizedBox(height: 20),

          // Controls
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Controls',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.format_size, size: 20),
                      const SizedBox(width: 12),
                      const Text('Font Size:'),
                      Expanded(
                        child: Slider(
                          value: _fontSize,
                          min: 10,
                          max: 24,
                          divisions: 14,
                          label: _fontSize.toStringAsFixed(0),
                          onChanged: (v) => setState(() => _fontSize = v),
                        ),
                      ),
                      Text('${_fontSize.toStringAsFixed(0)}'),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.rounded_corner, size: 20),
                      const SizedBox(width: 12),
                      const Text('Rounded Corners:'),
                      Expanded(
                        child: Slider(
                          value: _borderRadius,
                          min: 0,
                          max: 24,
                          divisions: 24,
                          label: _borderRadius.toStringAsFixed(0),
                          onChanged: (v) => setState(() => _borderRadius = v),
                        ),
                      ),
                      Text('${_borderRadius.toStringAsFixed(0)}'),
                    ],
                  ),
                ],
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 300.ms, delay: 100.ms)
              .slideY(begin: 0.1),
          const SizedBox(height: 20),

          // Preview with custom theme
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: _isDarkMode ? const Color(0xFF1C1B1F) : Colors.white,
              borderRadius: BorderRadius.circular(_borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Theme(
              data: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: customTheme.primaryColor?.withOpacity(0.1) ??
                                colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.preview,
                            color:
                                customTheme.primaryColor ?? colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Live Preview',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: _isDarkMode ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    SuperInteractiveTextPreview(
                      text: '''Welcome to our app! 🎉

For more info, visit our website:
https://flutter.dev

For support:
📧 support@flutter.dev
📱 +966555555555

Follow us on:
🐦 @FlutterDev
#Flutter #Dart #MobileApp''',
                      textPreviewTheme: customTheme,
                    ),
                  ],
                ),
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 300.ms, delay: 200.ms)
              .slideY(begin: 0.1),
          const SizedBox(height: 20),

          // Theme Properties
          _ThemePropertiesCard(
                  customTheme: customTheme, isDarkMode: _isDarkMode)
              .animate()
              .fadeIn(duration: 300.ms, delay: 300.ms)
              .slideY(begin: 0.1),
          const SizedBox(height: 20),

          // Code Example
          _CodeCard(customTheme: customTheme, isDarkMode: _isDarkMode)
              .animate()
              .fadeIn(duration: 300.ms, delay: 400.ms)
              .slideY(begin: 0.1),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  SuperInteractiveTextPreviewTheme _buildCustomTheme() {
    if (_isDarkMode) {
      return SuperInteractiveTextPreviewTheme(
        borderRadius: _borderRadius,
        normalTextFontSize: _fontSize,
        linkTextFontSize: _fontSize,
        normalTextStyle: TextStyle(
          color: Colors.white,
          fontSize: _fontSize,
        ),
        linkTextStyle: TextStyle(
          color: const Color(0xFFBB86FC),
          fontSize: _fontSize,
          decoration: TextDecoration.underline,
          decorationColor: const Color(0xFFBB86FC),
        ),
        emailTextStyle: TextStyle(
          color: const Color(0xFF03DAC6),
          fontSize: _fontSize,
          decoration: TextDecoration.underline,
          decorationColor: const Color(0xFF03DAC6),
        ),
        phoneTextStyle: TextStyle(
          color: const Color(0xFFCF6679),
          fontSize: _fontSize,
          decoration: TextDecoration.underline,
          decorationColor: const Color(0xFFCF6679),
        ),
        usernameTextStyle: TextStyle(
          color: const Color(0xFF64B5F6),
          fontSize: _fontSize,
          fontWeight: FontWeight.bold,
        ),
        hashtagTextStyle: TextStyle(
          color: const Color(0xFFFFB74D),
          fontSize: _fontSize,
          fontWeight: FontWeight.bold,
        ),
        primaryColor: const Color(0xFFBB86FC),
        linkColor: const Color(0xFFBB86FC),
        emailColor: const Color(0xFF03DAC6),
        phoneColor: const Color(0xFFCF6679),
        usernameColor: const Color(0xFF64B5F6),
        hashtagColor: const Color(0xFFFFB74D),
      );
    } else {
      return SuperInteractiveTextPreviewTheme(
        borderRadius: _borderRadius,
        normalTextFontSize: _fontSize,
        normalTextStyle: TextStyle(
          color: const Color(0xFF1C1B1F),
          fontSize: _fontSize,
        ),
        linkTextStyle: TextStyle(
          color: const Color(0xFF6750A4),
          fontSize: _fontSize,
          decoration: TextDecoration.underline,
          decorationColor: const Color(0xFF6750A4),
        ),
        emailTextStyle: TextStyle(
          color: const Color(0xFF0091EA),
          fontSize: _fontSize,
          decoration: TextDecoration.underline,
          decorationColor: const Color(0xFF0091EA),
        ),
        phoneTextStyle: TextStyle(
          color: const Color(0xFF00C853),
          fontSize: _fontSize,
          decoration: TextDecoration.underline,
          decorationColor: const Color(0xFF00C853),
        ),
        usernameTextStyle: TextStyle(
          color: const Color(0xFF2962FF),
          fontSize: _fontSize,
          fontWeight: FontWeight.bold,
        ),
        hashtagTextStyle: TextStyle(
          color: const Color(0xFFAA00FF),
          fontSize: _fontSize,
          fontWeight: FontWeight.bold,
        ),
        primaryColor: const Color(0xFF6750A4),
        linkColor: const Color(0xFF6750A4),
        emailColor: const Color(0xFF0091EA),
        phoneColor: const Color(0xFF00C853),
        usernameColor: const Color(0xFF2962FF),
        hashtagColor: const Color(0xFFAA00FF),
      );
    }
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer.withOpacity(0.5),
            colorScheme.tertiaryContainer.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemePropertiesCard extends StatelessWidget {
  final SuperInteractiveTextPreviewTheme customTheme;
  final bool isDarkMode;

  const _ThemePropertiesCard({
    required this.customTheme,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.settings, size: 20, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Current Theme Properties',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _PropertyChip(
                  label: 'Mode',
                  value: isDarkMode ? 'Dark' : 'Light',
                  color: colorScheme.primary,
                ),
                _PropertyChip(
                  label: 'Font Size',
                  value: '${customTheme.normalTextFontSize.toStringAsFixed(0)}',
                  color: colorScheme.secondary,
                ),
                _PropertyChip(
                  label: 'Radius',
                  value: '${customTheme.borderRadius.toStringAsFixed(0)}',
                  color: colorScheme.tertiary,
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              'Element Colors',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ColorIndicator(label: 'Links', color: customTheme.linkColor),
                _ColorIndicator(label: 'Email', color: customTheme.emailColor),
                _ColorIndicator(label: 'Phone', color: customTheme.phoneColor),
                _ColorIndicator(
                    label: 'User', color: customTheme.usernameColor),
                _ColorIndicator(
                    label: 'Hashtag', color: customTheme.hashtagColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PropertyChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _PropertyChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorIndicator extends StatelessWidget {
  final String label;
  final Color? color;

  const _ColorIndicator({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color ?? Colors.grey,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black12),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11),
        ),
      ],
    );
  }
}

class _CodeCard extends StatelessWidget {
  final SuperInteractiveTextPreviewTheme customTheme;
  final bool isDarkMode;

  const _CodeCard({
    required this.customTheme,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.code, size: 20, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'How to use theme',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SelectableText(
                  '''// Add theme to MaterialApp
MaterialApp(
  theme: ThemeData(
    extensions: [
      SuperInteractiveTextPreviewTheme.${isDarkMode ? 'dark' : 'light'}(),
    ],
  ),
)

// Or use a custom theme
SuperInteractiveTextPreview(
  text: 'Text here...',
  textPreviewTheme: SuperInteractiveTextPreviewTheme(
    normalTextFontSize: ${customTheme.normalTextFontSize.toStringAsFixed(0)},
    borderRadius: ${customTheme.borderRadius.toStringAsFixed(0)},
    linkColor: Color(0xFF6750A4),
    emailColor: Color(0xFF0091EA),
    // ... other properties
  ),
)''',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
