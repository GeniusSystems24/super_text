import 'package:flutter/material.dart';

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
            expandedHeight: 180,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Super Interactive Text',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
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
                    'A powerful Flutter package for parsing, displaying, and editing text with interactive elements.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle(context, 'Preview Examples', Icons.visibility),
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
                childAspectRatio: 2.5,
              ),
              delegate: SliverChildListDelegate([
                _ExampleCard(
                  title: 'Basic Preview',
                  description: 'Display text with auto-detected interactive elements',
                  icon: Icons.text_fields,
                  color: const Color(0xFF6750A4),
                  route: '/preview/basic',
                ),
                _ExampleCard(
                  title: 'Custom Styling',
                  description: 'Customize colors and styles for each element type',
                  icon: Icons.palette,
                  color: const Color(0xFF00897B),
                  route: '/preview/styling',
                ),
                _ExampleCard(
                  title: 'Builder Pattern',
                  description: 'Create custom widgets for each data type',
                  icon: Icons.widgets,
                  color: const Color(0xFFE65100),
                  route: '/preview/builder',
                ),
                _ExampleCard(
                  title: 'Theming',
                  description: 'Use theme presets and customization',
                  icon: Icons.color_lens,
                  color: const Color(0xFF1565C0),
                  route: '/preview/theming',
                ),
                _ExampleCard(
                  title: 'Internal Routing',
                  description: 'Handle internal app links with parameters',
                  icon: Icons.route,
                  color: const Color(0xFFC2185B),
                  route: '/preview/routing',
                ),
              ]),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: _buildSectionTitle(context, 'Editor Examples', Icons.edit),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.5,
              ),
              delegate: SliverChildListDelegate([
                _ExampleCard(
                  title: 'Basic Editor',
                  description: 'Simple rich text editor with auto-detection',
                  icon: Icons.edit_note,
                  color: const Color(0xFF7B1FA2),
                  route: '/editor/basic',
                ),
                _ExampleCard(
                  title: 'Editor with Controller',
                  description: 'Programmatic control over the editor',
                  icon: Icons.code,
                  color: const Color(0xFF5C6BC0),
                  route: '/editor/controller',
                ),
                _ExampleCard(
                  title: 'Editor Features',
                  description: 'Explore all editor features and options',
                  icon: Icons.auto_awesome,
                  color: const Color(0xFFFF6F00),
                  route: '/editor/features',
                ),
              ]),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverToBoxAdapter(
              child: _FeaturesSection(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.primary,
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
  final Color color;
  final String route;

  const _ExampleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
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
                child: Icon(Icons.star, color: colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Text(
                'Supported Elements',
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
              _FeatureChip(label: 'Links', icon: Icons.link, color: colorScheme.primary),
              _FeatureChip(label: 'Emails', icon: Icons.email, color: Colors.green),
              _FeatureChip(label: 'Phones', icon: Icons.phone, color: Colors.orange),
              _FeatureChip(label: '@Mentions', icon: Icons.alternate_email, color: Colors.blue),
              _FeatureChip(label: '#Hashtags', icon: Icons.tag, color: Colors.purple),
              _FeatureChip(label: 'Social Media', icon: Icons.share, color: Colors.pink),
              _FeatureChip(label: 'App Routes', icon: Icons.route, color: Colors.teal),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _FeatureChip({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
