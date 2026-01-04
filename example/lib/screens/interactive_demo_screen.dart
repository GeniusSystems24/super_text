import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:super_text/super_text.dart';

class InteractiveDemoScreen extends StatefulWidget {
  const InteractiveDemoScreen({super.key});

  @override
  State<InteractiveDemoScreen> createState() => _InteractiveDemoScreenState();
}

class _InteractiveDemoScreenState extends State<InteractiveDemoScreen> {
  final _controller = TextEditingController(
    text: '''مرحباً بكم! 👋

جربوا إدخال نصوص تحتوي على:
🔗 روابط: https://flutter.dev
📧 إيميل: test@example.com  
📱 هاتف: +966555555555
👤 مستخدم: @flutter_dev
#️⃣ هاشتاغ: #Flutter #Dart''',
  );

  List<SuperTextData> _parsedData = [];
  String _lastTapped = '';

  @override
  void initState() {
    super.initState();
    _parseText();
  }

  void _parseText() {
    setState(() {
      _parsedData = SuperTextData.parse(_controller.text, save: true);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('عرض تفاعلي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.text = '''مرحباً بكم! 👋

🔗 روابط: https://flutter.dev
📧 إيميل: test@example.com  
📱 هاتف: +966555555555
👤 مستخدم: @flutter_dev
#️⃣ هاشتاغ: #Flutter #Dart''';
              _parseText();
            },
            tooltip: 'إعادة تعيين',
          ),
        ],
      ),
      body: Column(
        children: [
          // Input Section
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: _controller,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'اكتب نصك هنا...',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
                suffixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        _parseText();
                      },
                    ),
                  ],
                ),
              ),
              onChanged: (_) => _parseText(),
            ),
          ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.1),

          // Parse Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'العناصر المكتشفة: ${_parsedData.where((d) => d.textType != SuperTextType.normal).length}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (_lastTapped.isNotEmpty)
                  Chip(
                    label:
                        Text(_lastTapped, style: const TextStyle(fontSize: 11)),
                    backgroundColor: colorScheme.primaryContainer,
                    deleteIcon: const Icon(Icons.close, size: 14),
                    onDeleted: () => setState(() => _lastTapped = ''),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Preview Section
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.outlineVariant),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: SuperTextPreview(
                  parsedText: _parsedData,
                  onLinkTap: (l) => _setTapped('🔗 ${l.text}'),
                  onEmailTap: (e) => _setTapped('📧 ${e.text}'),
                  onPhoneTap: (p) => _setTapped('📱 ${p.text}'),
                  onUsernameTap: (u) => _setTapped('👤 ${u.text}'),
                  onHashtagTap: (h) => _setTapped('#️⃣ ${h.text}'),
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 300.ms, delay: 100.ms)
                .slideY(begin: 0.1),
          ),

          // Stats Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatItem(
                    icon: Icons.link,
                    label: 'روابط',
                    count: _countType(SuperTextType.link),
                    color: colorScheme.primary,
                  ),
                  _StatItem(
                    icon: Icons.email,
                    label: 'إيميل',
                    count: _countType(SuperTextType.email),
                    color: Colors.orange,
                  ),
                  _StatItem(
                    icon: Icons.phone,
                    label: 'هاتف',
                    count: _countType(SuperTextType.phone),
                    color: Colors.green,
                  ),
                  _StatItem(
                    icon: Icons.person,
                    label: 'مستخدم',
                    count: _countType(SuperTextType.username),
                    color: Colors.blue,
                  ),
                  _StatItem(
                    icon: Icons.tag,
                    label: 'هاشتاغ',
                    count: _countType(SuperTextType.hashtag),
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
          ).animate().fadeIn(duration: 300.ms, delay: 200.ms),
        ],
      ),
    );
  }

  void _setTapped(String value) {
    setState(() => _lastTapped = value);
  }

  int _countType(SuperTextType type) {
    return _parsedData.where((d) => d.textType == type).length;
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}
