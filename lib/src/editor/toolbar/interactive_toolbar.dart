import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';

import '../attributions/interactive_attributions.dart';

/// Toolbar item types for interactive editor
enum InteractiveToolbarItemType {
  bold,
  italic,
  underline,
  strikethrough,
  link,
  email,
  phone,
  mention,
  hashtag,
  divider,
}

/// Configuration for toolbar items
class InteractiveToolbarItem {
  const InteractiveToolbarItem({
    required this.type,
    this.icon,
    this.tooltip,
    this.onPressed,
  });

  final InteractiveToolbarItemType type;
  final IconData? icon;
  final String? tooltip;
  final VoidCallback? onPressed;

  /// Create default toolbar items
  static List<InteractiveToolbarItem> get defaultItems => [
        const InteractiveToolbarItem(
          type: InteractiveToolbarItemType.bold,
          icon: Icons.format_bold,
          tooltip: 'Bold',
        ),
        const InteractiveToolbarItem(
          type: InteractiveToolbarItemType.italic,
          icon: Icons.format_italic,
          tooltip: 'Italic',
        ),
        const InteractiveToolbarItem(
          type: InteractiveToolbarItemType.underline,
          icon: Icons.format_underlined,
          tooltip: 'Underline',
        ),
        const InteractiveToolbarItem(
          type: InteractiveToolbarItemType.divider,
        ),
        const InteractiveToolbarItem(
          type: InteractiveToolbarItemType.link,
          icon: Icons.link,
          tooltip: 'Insert Link',
        ),
        const InteractiveToolbarItem(
          type: InteractiveToolbarItemType.mention,
          icon: Icons.alternate_email,
          tooltip: 'Insert Mention',
        ),
        const InteractiveToolbarItem(
          type: InteractiveToolbarItemType.hashtag,
          icon: Icons.tag,
          tooltip: 'Insert Hashtag',
        ),
        const InteractiveToolbarItem(
          type: InteractiveToolbarItemType.divider,
        ),
        const InteractiveToolbarItem(
          type: InteractiveToolbarItemType.phone,
          icon: Icons.phone,
          tooltip: 'Insert Phone',
        ),
        const InteractiveToolbarItem(
          type: InteractiveToolbarItemType.email,
          icon: Icons.email,
          tooltip: 'Insert Email',
        ),
      ];
}

/// Interactive editor toolbar widget
class InteractiveEditorToolbar extends StatelessWidget {
  const InteractiveEditorToolbar({
    super.key,
    required this.editor,
    required this.composer,
    this.items,
    this.backgroundColor,
    this.iconColor,
    this.activeIconColor,
    this.dividerColor,
    this.elevation = 2.0,
    this.borderRadius = 8.0,
    this.onLinkPressed,
    this.onMentionPressed,
    this.onHashtagPressed,
    this.onEmailPressed,
    this.onPhonePressed,
  });

  final Editor editor;
  final DocumentComposer composer;
  final List<InteractiveToolbarItem>? items;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? activeIconColor;
  final Color? dividerColor;
  final double elevation;
  final double borderRadius;

  // Callbacks for interactive elements
  final VoidCallback? onLinkPressed;
  final VoidCallback? onMentionPressed;
  final VoidCallback? onHashtagPressed;
  final VoidCallback? onEmailPressed;
  final VoidCallback? onPhonePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final toolbarItems = items ?? InteractiveToolbarItem.defaultItems;

    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(borderRadius),
      color: backgroundColor ?? theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: toolbarItems.map((item) => _buildItem(context, item)).toList(),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, InteractiveToolbarItem item) {
    if (item.type == InteractiveToolbarItemType.divider) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: SizedBox(
          height: 24,
          child: VerticalDivider(
            color: dividerColor ?? Colors.grey.shade300,
            width: 1,
          ),
        ),
      );
    }

    return Tooltip(
      message: item.tooltip ?? '',
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: () => _handleItemPressed(item),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            item.icon,
            size: 20,
            color: _getIconColor(context, item),
          ),
        ),
      ),
    );
  }

  Color _getIconColor(BuildContext context, InteractiveToolbarItem item) {
    final theme = Theme.of(context);
    final isActive = _isItemActive(item);

    if (isActive) {
      return activeIconColor ?? theme.colorScheme.primary;
    }
    return iconColor ?? theme.iconTheme.color ?? Colors.grey.shade700;
  }

  bool _isItemActive(InteractiveToolbarItem item) {
    final selection = composer.selection;
    if (selection == null) return false;

    // Check if the current selection has the attribution
    switch (item.type) {
      case InteractiveToolbarItemType.bold:
        return _hasAttribution(boldAttribution);
      case InteractiveToolbarItemType.italic:
        return _hasAttribution(italicsAttribution);
      case InteractiveToolbarItemType.underline:
        return _hasAttribution(underlineAttribution);
      case InteractiveToolbarItemType.strikethrough:
        return _hasAttribution(strikethroughAttribution);
      default:
        return false;
    }
  }

  bool _hasAttribution(Attribution attribution) {
    final selection = composer.selection;
    if (selection == null) return false;

    final document = editor.context.document;
    final selectedNodes = document.getNodesInside(
      selection.base,
      selection.extent,
    );

    for (final node in selectedNodes) {
      if (node is TextNode) {
        final text = node.text;
        final spans = text.getAttributionSpansInRange(
          attributionFilter: (a) => a == attribution,
          range: SpanRange(0, text.length - 1),
        );
        if (spans.isNotEmpty) return true;
      }
    }
    return false;
  }

  void _handleItemPressed(InteractiveToolbarItem item) {
    if (item.onPressed != null) {
      item.onPressed!();
      return;
    }

    switch (item.type) {
      case InteractiveToolbarItemType.bold:
        _toggleAttribution(boldAttribution);
        break;
      case InteractiveToolbarItemType.italic:
        _toggleAttribution(italicsAttribution);
        break;
      case InteractiveToolbarItemType.underline:
        _toggleAttribution(underlineAttribution);
        break;
      case InteractiveToolbarItemType.strikethrough:
        _toggleAttribution(strikethroughAttribution);
        break;
      case InteractiveToolbarItemType.link:
        onLinkPressed?.call();
        break;
      case InteractiveToolbarItemType.mention:
        onMentionPressed?.call();
        break;
      case InteractiveToolbarItemType.hashtag:
        onHashtagPressed?.call();
        break;
      case InteractiveToolbarItemType.email:
        onEmailPressed?.call();
        break;
      case InteractiveToolbarItemType.phone:
        onPhonePressed?.call();
        break;
      default:
        break;
    }
  }

  void _toggleAttribution(Attribution attribution) {
    final selection = composer.selection;
    if (selection == null) return;

    editor.execute([
      ToggleTextAttributionsRequest(
        documentRange: selection,
        attributions: {attribution},
      ),
    ]);
  }
}

/// Floating toolbar that appears on text selection
class InteractiveFloatingToolbar extends StatelessWidget {
  const InteractiveFloatingToolbar({
    super.key,
    required this.editor,
    required this.composer,
    required this.anchor,
    this.onLinkPressed,
    this.onMentionPressed,
    this.onHashtagPressed,
  });

  final Editor editor;
  final DocumentComposer composer;
  final Offset anchor;
  final VoidCallback? onLinkPressed;
  final VoidCallback? onMentionPressed;
  final VoidCallback? onHashtagPressed;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: anchor.dx,
      top: anchor.dy - 50,
      child: InteractiveEditorToolbar(
        editor: editor,
        composer: composer,
        onLinkPressed: onLinkPressed,
        onMentionPressed: onMentionPressed,
        onHashtagPressed: onHashtagPressed,
        items: [
          const InteractiveToolbarItem(
            type: InteractiveToolbarItemType.bold,
            icon: Icons.format_bold,
            tooltip: 'Bold',
          ),
          const InteractiveToolbarItem(
            type: InteractiveToolbarItemType.italic,
            icon: Icons.format_italic,
            tooltip: 'Italic',
          ),
          const InteractiveToolbarItem(
            type: InteractiveToolbarItemType.divider,
          ),
          const InteractiveToolbarItem(
            type: InteractiveToolbarItemType.link,
            icon: Icons.link,
            tooltip: 'Link',
          ),
          const InteractiveToolbarItem(
            type: InteractiveToolbarItemType.mention,
            icon: Icons.alternate_email,
            tooltip: 'Mention',
          ),
        ],
      ),
    );
  }
}
