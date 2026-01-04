import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Text Preview',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primaryContainer.withOpacity(0.5),
                      colorScheme.tertiaryContainer.withOpacity(0.3),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 30,
                      right: 30,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.primary.withOpacity(0.2),
                        ),
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat())
                        .scale(
                          begin: const Offset(1, 1),
                          end: const Offset(1.2, 1.2),
                          duration: 2.seconds,
                          curve: Curves.easeInOut,
                        )
                        .then()
                        .scale(
                          begin: const Offset(1.2, 1.2),
                          end: const Offset(1, 1),
                          duration: 2.seconds,
                          curve: Curves.easeInOut,
                        ),
                    Positioned(
                      bottom: 60,
                      left: 20,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.tertiary.withOpacity(0.2),
                        ),
                      ),
                    )
                        .animate(onPlay: (c) => c.repeat())
                        .scale(
                          begin: const Offset(1, 1),
                          end: const Offset(1.3, 1.3),
                          duration: 3.seconds,
                          curve: Curves.easeInOut,
                        )
                        .then()
                        .scale(
                          begin: const Offset(1.3, 1.3),
                          end: const Offset(1, 1),
                          duration: 3.seconds,
                          curve: Curves.easeInOut,
                        ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'مرحباً بك في مكتبة Text Preview',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ).animate().fadeIn(duration: 400.ms).slideX(begin: -0.1),
                  const SizedBox(height: 8),
                  Text(
                    'اكتشف قوة تحويل النصوص إلى عناصر تفاعلية قابلة للنقر',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 100.ms)
                      .slideX(begin: -0.1),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.2,
              ),
              delegate: SliverChildListDelegate([
                _ExampleCard(
                  title: 'الاستخدام الأساسي',
                  description: 'تعلم كيفية استخدام SuperTextPreview بأبسط صورة',
                  icon: Icons.play_arrow_rounded,
                  gradient: [const Color(0xFF6750A4), const Color(0xFF9747FF)],
                  route: '/basic',
                  delay: 0,
                ),
                _ExampleCard(
                  title: 'التنسيق المخصص',
                  description: 'تخصيص ألوان وأنماط النصوص المختلفة',
                  icon: Icons.palette_rounded,
                  gradient: [const Color(0xFF00897B), const Color(0xFF4DB6AC)],
                  route: '/styling',
                  delay: 50,
                ),
                _ExampleCard(
                  title: 'Builder Pattern',
                  description: 'إنشاء عناصر مخصصة لكل نوع من البيانات',
                  icon: Icons.build_rounded,
                  gradient: [const Color(0xFFE65100), const Color(0xFFFF9800)],
                  route: '/builder',
                  delay: 100,
                ),
                _ExampleCard(
                  title: 'التخصيص بالثيمات',
                  description: 'استخدام SuperTextPreviewTheme للتحكم الكامل',
                  icon: Icons.auto_awesome_rounded,
                  gradient: [const Color(0xFF1565C0), const Color(0xFF42A5F5)],
                  route: '/theming',
                  delay: 150,
                ),
                _ExampleCard(
                  title: 'مثال واقعي',
                  description: 'محاكاة تطبيق دردشة حقيقي مع رسائل تفاعلية',
                  icon: Icons.chat_rounded,
                  gradient: [const Color(0xFFC2185B), const Color(0xFFF48FB1)],
                  route: '/real-world',
                  delay: 200,
                ),
                _ExampleCard(
                  title: 'وسائل التواصل',
                  description: 'عرض روابط التواصل الاجتماعي بشكل جذاب',
                  icon: Icons.share_rounded,
                  gradient: [const Color(0xFF5C6BC0), const Color(0xFF9FA8DA)],
                  route: '/social-media',
                  delay: 250,
                ),
                _ExampleCard(
                  title: 'عرض تفاعلي',
                  description: 'جرب إدخال نصك الخاص وشاهد النتيجة مباشرة',
                  icon: Icons.edit_note_rounded,
                  gradient: [const Color(0xFF7B1FA2), const Color(0xFFBA68C8)],
                  route: '/interactive',
                  delay: 300,
                ),
                _ExampleCard(
                  title: 'التنقل في التطبيق',
                  description:
                      'اكشتف كيفية استخدام الروابط للتنقل داخل التطبيق',
                  icon: Icons.directions_rounded,
                  gradient: [const Color(0xFFFF6F00), const Color(0xFFFFB74D)],
                  route: '/routes',
                  delay: 350,
                ),
              ]),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverToBoxAdapter(
              child: _FeaturesSection()
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 400.ms)
                  .slideY(begin: 0.1),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;
  final String route;
  final int delay;

  const _ExampleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.route,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
            boxShadow: [
              BoxShadow(
                color: gradient[0].withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withOpacity(0.7),
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: Duration(milliseconds: 200 + delay))
        .slideY(begin: 0.1);
  }
}

class _FeaturesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.star_rounded, color: colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Text(
                'المميزات الرئيسية',
                style: theme.textTheme.titleMedium?.copyWith(
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
              _FeatureChip(label: '🔗 روابط', color: colorScheme.primary),
              _FeatureChip(label: '📧 إيميلات', color: colorScheme.secondary),
              _FeatureChip(label: '📱 هواتف', color: Colors.green),
              _FeatureChip(label: '👤 أسماء مستخدمين', color: Colors.blue),
              _FeatureChip(label: '#️⃣ هاشتاغ', color: Colors.purple),
              _FeatureChip(label: '🌐 وسائل تواصل', color: Colors.pink),
              _FeatureChip(label: '🏠 روابط داخلية', color: Colors.orange),
              _FeatureChip(label: '💾 تسلسل البيانات', color: Colors.teal),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final String label;
  final Color color;

  const _FeatureChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
