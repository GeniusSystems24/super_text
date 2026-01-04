import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:super_interactive_text/super_interactive_text.dart';

class CustomStylingScreen extends StatefulWidget {
  const CustomStylingScreen({super.key});

  @override
  State<CustomStylingScreen> createState() => _CustomStylingScreenState();
}

class _CustomStylingScreenState extends State<CustomStylingScreen> {
  int _selectedStyle = 0;

  static const _sampleText = '''Welcome to our website https://example.com
Contact: contact@company.com
Phone: +966501234567
Follow @official_account
#development #flutter #dart''';

  final _styles = [
    _StyleConfig(
      name: 'Default',
      icon: Icons.auto_awesome,
      linkColor: const Color(0xFF6750A4),
      emailColor: const Color(0xFF2196F3),
      phoneColor: const Color(0xFF4CAF50),
      usernameColor: const Color(0xFF9C27B0),
      hashtagColor: const Color(0xFF3F51B5),
    ),
    _StyleConfig(
      name: 'Dark Elegant',
      icon: Icons.dark_mode,
      linkColor: const Color(0xFFBB86FC),
      emailColor: const Color(0xFF03DAC6),
      phoneColor: const Color(0xFFCF6679),
      usernameColor: const Color(0xFFFF6B35),
      hashtagColor: const Color(0xFFFFEB3B),
    ),
    _StyleConfig(
      name: 'Soft Light',
      icon: Icons.light_mode,
      linkColor: const Color(0xFF5C6BC0),
      emailColor: const Color(0xFF00897B),
      phoneColor: const Color(0xFF8E24AA),
      usernameColor: const Color(0xFFD81B60),
      hashtagColor: const Color(0xFFFB8C00),
    ),
    _StyleConfig(
      name: 'Rainbow',
      icon: Icons.palette,
      linkColor: const Color(0xFFE91E63),
      emailColor: const Color(0xFF00BCD4),
      phoneColor: const Color(0xFF4CAF50),
      usernameColor: const Color(0xFF9C27B0),
      hashtagColor: const Color(0xFFFF9800),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentStyle = _styles[_selectedStyle];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Styling'),
      ),
      body: Column(
        children: [
          // Style selector
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _styles.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final style = _styles[index];
                final isSelected = index == _selectedStyle;
                return _StyleButton(
                  style: style,
                  isSelected: isSelected,
                  onTap: () => setState(() => _selectedStyle = index),
                );
              },
            ),
          ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Preview Card
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              currentStyle.linkColor.withOpacity(0.2),
                              currentStyle.linkColor.withOpacity(0.05),
                            ],
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: currentStyle.linkColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(currentStyle.icon,
                                  color: currentStyle.linkColor),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Preview: ${currentStyle.name}',
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: currentStyle.linkColor,
                                    ),
                                  ),
                                  Text(
                                    'See how your text looks with this style',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Preview content
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: SuperInteractiveTextPreview(
                            key: ValueKey(_selectedStyle),
                            text: _sampleText,
                            linkTextStyle: TextStyle(
                              color: currentStyle.linkColor,
                              decoration: TextDecoration.underline,
                              decorationColor: currentStyle.linkColor,
                              fontWeight: FontWeight.w500,
                            ),
                            emailTextStyle: TextStyle(
                              color: currentStyle.emailColor,
                              decoration: TextDecoration.underline,
                              decorationColor: currentStyle.emailColor,
                            ),
                            phoneTextStyle: TextStyle(
                              color: currentStyle.phoneColor,
                              decoration: TextDecoration.underline,
                              decorationColor: currentStyle.phoneColor,
                            ),
                            usernameTextStyle: TextStyle(
                              color: currentStyle.usernameColor,
                              fontWeight: FontWeight.bold,
                            ),
                            hashtagTextStyle: TextStyle(
                              color: currentStyle.hashtagColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms, delay: 100.ms),

                const SizedBox(height: 20),

                // Color Legend
                _ColorLegend(style: currentStyle)
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 200.ms)
                    .slideY(begin: 0.1),

                const SizedBox(height: 20),

                // Code Example with Syntax Highlighting
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest
                              .withOpacity(0.3),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.code,
                                size: 20, color: colorScheme.primary),
                            const SizedBox(width: 8),
                            Text(
                              'Code Example',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 350),
                        color: const Color(0xFF1E1E1E),
                        child: SyntaxView(
                          code: _generateCode(currentStyle),
                          syntax: Syntax.DART,
                          syntaxTheme: SyntaxTheme.vscodeDark(),
                          fontSize: 11.0,
                          withZoom: false,
                          withLinesCount: true,
                          expanded: false,
                          selectable: true,
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 300.ms, delay: 300.ms)
                    .slideY(begin: 0.1),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _generateCode(_StyleConfig style) {
    return '''SuperInteractiveTextPreview(
  text: 'Your text here...',
  linkTextStyle: TextStyle(
    color: Color(0x${style.linkColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}),
    decoration: TextDecoration.underline,
  ),
  emailTextStyle: TextStyle(
    color: Color(0x${style.emailColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}),
  ),
  phoneTextStyle: TextStyle(
    color: Color(0x${style.phoneColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}),
  ),
  usernameTextStyle: TextStyle(
    color: Color(0x${style.usernameColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}),
    fontWeight: FontWeight.bold,
  ),
  hashtagTextStyle: TextStyle(
    color: Color(0x${style.hashtagColor.value.toRadixString(16).padLeft(8, '0').toUpperCase()}),
    fontWeight: FontWeight.bold,
  ),
)''';
  }
}

class _StyleConfig {
  final String name;
  final IconData icon;
  final Color linkColor;
  final Color emailColor;
  final Color phoneColor;
  final Color usernameColor;
  final Color hashtagColor;

  const _StyleConfig({
    required this.name,
    required this.icon,
    required this.linkColor,
    required this.emailColor,
    required this.phoneColor,
    required this.usernameColor,
    required this.hashtagColor,
  });
}

class _StyleButton extends StatelessWidget {
  final _StyleConfig style;
  final bool isSelected;
  final VoidCallback onTap;

  const _StyleButton({
    required this.style,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? style.linkColor.withOpacity(0.15)
                : colorScheme.surfaceContainerHighest.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? style.linkColor : Colors.transparent,
              width: 2,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: style.linkColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                style.icon,
                color:
                    isSelected ? style.linkColor : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 4),
              Text(
                style.name,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? style.linkColor
                      : colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorLegend extends StatelessWidget {
  final _StyleConfig style;

  const _ColorLegend({required this.style});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.palette_outlined, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Color Legend',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _ColorChip(label: '🔗 Links', color: style.linkColor),
                _ColorChip(label: '📧 Email', color: style.emailColor),
                _ColorChip(label: '📱 Phone', color: style.phoneColor),
                _ColorChip(label: '👤 User', color: style.usernameColor),
                _ColorChip(label: '#️⃣ Hashtag', color: style.hashtagColor),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorChip extends StatelessWidget {
  final String label;
  final Color color;

  const _ColorChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
