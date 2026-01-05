import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';
import 'package:url_launcher/url_launcher.dart';

import '../attributions/interactive_attributions.dart';
import '../controller/interactive_editor_controller.dart';
import '../detection/interactive_text_detector.dart';
import '../dialogs/insert_dialogs.dart';
import '../styles/interactive_stylesheet.dart';
import '../toolbar/interactive_toolbar.dart';

/// Callback types for interactive elements
typedef InteractiveLinkCallback = void Function(String url);
typedef InteractiveEmailCallback = void Function(String email);
typedef InteractivePhoneCallback = void Function(String phone);
typedef InteractiveMentionCallback = void Function(String username);
typedef InteractiveHashtagCallback = void Function(String hashtag);
typedef InteractiveSocialMediaCallback = void Function(
    String url, InteractiveSocialMediaType platform);
typedef InteractiveRouteCallback = void Function(
    String url, String routeName, Map<String, String> pathParameters);

/// A rich text editor with interactive element detection and styling
class SuperInteractiveTextEditor extends StatefulWidget {
  const SuperInteractiveTextEditor({
    super.key,
    this.controller,
    this.initialText,
    this.autoDetect = true,
    this.showToolbar = true,
    this.toolbarPosition = ToolbarPosition.top,
    this.readOnly = false,
    this.minHeight,
    this.maxHeight,
    this.padding,
    this.decoration,
    this.placeholder,
    this.placeholderStyle,
    this.textStyle,
    this.linkColor,
    this.emailColor,
    this.phoneColor,
    this.mentionColor,
    this.hashtagColor,
    this.socialMediaColor,
    this.routeColor,
    this.onChanged,
    this.onLinkTap,
    this.onEmailTap,
    this.onPhoneTap,
    this.onMentionTap,
    this.onHashtagTap,
    this.onSocialMediaTap,
    this.onRouteTap,
    this.mentionSuggestions,
    this.hashtagSuggestions,
    this.focusNode,
    this.autofocus = false,
  });

  /// Controller for the editor
  final InteractiveEditorController? controller;

  /// Initial text content
  final String? initialText;

  /// Enable automatic detection of interactive elements
  final bool autoDetect;

  /// Show the formatting toolbar
  final bool showToolbar;

  /// Position of the toolbar
  final ToolbarPosition toolbarPosition;

  /// Read-only mode
  final bool readOnly;

  /// Minimum height of the editor
  final double? minHeight;

  /// Maximum height of the editor
  final double? maxHeight;

  /// Padding around the editor content
  final EdgeInsets? padding;

  /// Decoration for the editor container
  final BoxDecoration? decoration;

  /// Placeholder text when empty
  final String? placeholder;

  /// Style for placeholder text
  final TextStyle? placeholderStyle;

  /// Base text style
  final TextStyle? textStyle;

  // Colors for different interactive elements
  final Color? linkColor;
  final Color? emailColor;
  final Color? phoneColor;
  final Color? mentionColor;
  final Color? hashtagColor;
  final Color? socialMediaColor;
  final Color? routeColor;

  /// Callback when text changes
  final ValueChanged<String>? onChanged;

  // Callbacks for interactive elements
  final InteractiveLinkCallback? onLinkTap;
  final InteractiveEmailCallback? onEmailTap;
  final InteractivePhoneCallback? onPhoneTap;
  final InteractiveMentionCallback? onMentionTap;
  final InteractiveHashtagCallback? onHashtagTap;
  final InteractiveSocialMediaCallback? onSocialMediaTap;
  final InteractiveRouteCallback? onRouteTap;

  /// Suggestions for mentions
  final List<String>? mentionSuggestions;

  /// Suggestions for hashtags
  final List<String>? hashtagSuggestions;

  /// Focus node
  final FocusNode? focusNode;

  /// Auto-focus the editor
  final bool autofocus;

  @override
  State<SuperInteractiveTextEditor> createState() =>
      _SuperInteractiveTextEditorState();
}

class _SuperInteractiveTextEditorState
    extends State<SuperInteractiveTextEditor> {
  late InteractiveEditorController _controller;
  late FocusNode _focusNode;
  bool _ownsController = false;
  bool _ownsFocusNode = false;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = InteractiveEditorController(
        initialText: widget.initialText,
        autoDetect: widget.autoDetect,
      );
      _ownsController = true;
    }

    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    }

    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (_ownsController) {
      _controller.dispose();
    }
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onControllerChanged() {
    widget.onChanged?.call(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget editor = _buildEditor(theme);

    if (widget.showToolbar && !widget.readOnly) {
      editor = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.toolbarPosition == ToolbarPosition.top) ...[
            _buildToolbar(),
            const SizedBox(height: 8),
          ],
          Flexible(child: editor),
          if (widget.toolbarPosition == ToolbarPosition.bottom) ...[
            const SizedBox(height: 8),
            _buildToolbar(),
          ],
        ],
      );
    }

    return Container(
      constraints: BoxConstraints(
        minHeight: widget.minHeight ?? 100,
        maxHeight: widget.maxHeight ?? double.infinity,
      ),
      decoration: widget.decoration ??
          BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.dividerColor,
            ),
          ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: editor,
      ),
    );
  }

  Widget _buildEditor(ThemeData theme) {
    return SuperEditor(
      editor: _controller.editor,
      document: _controller.document,
      composer: _controller.composer,
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      stylesheet: _buildStylesheet(),
      gestureMode: DocumentGestureMode.mouse,
      selectionStyle: SelectionStyles(
        selectionColor: theme.colorScheme.primary.withOpacity(0.3),
      ),
      documentOverlayBuilders: [
        DefaultCaretOverlayBuilder(
          caretStyle: CaretStyle(
            color: theme.colorScheme.primary,
            width: 2,
          ),
        ),
      ],
    );
  }

  Stylesheet _buildStylesheet() {
    return createInteractiveStylesheet(
      linkColor: widget.linkColor,
      emailColor: widget.emailColor,
      phoneColor: widget.phoneColor,
      mentionColor: widget.mentionColor,
      hashtagColor: widget.hashtagColor,
      socialMediaColor: widget.socialMediaColor,
      routeColor: widget.routeColor,
    );
  }

  Widget _buildToolbar() {
    return InteractiveEditorToolbar(
      editor: _controller.editor,
      composer: _controller.composer,
      onLinkPressed: _showLinkDialog,
      onMentionPressed: _showMentionDialog,
      onHashtagPressed: _showHashtagDialog,
      onEmailPressed: _showEmailDialog,
      onPhonePressed: _showPhoneDialog,
    );
  }

  Future<void> _showLinkDialog() async {
    // Get selected text if any
    String? selectedText;
    final selection = _controller.selection;
    if (selection != null && !selection.isCollapsed) {
      selectedText = _getSelectedText();
    }

    final result = await InsertLinkDialog.show(
      context,
      initialDisplayText: selectedText,
    );

    if (result != null) {
      if (selection != null && !selection.isCollapsed) {
        _controller.convertSelectionToLink(result.url);
      } else {
        _controller.insertLink(result.url, displayText: result.displayText);
      }
    }
  }

  Future<void> _showMentionDialog() async {
    final username = await InsertMentionDialog.show(
      context,
      suggestions: widget.mentionSuggestions,
    );

    if (username != null) {
      _controller.insertMention(username);
    }
  }

  Future<void> _showHashtagDialog() async {
    final tag = await InsertHashtagDialog.show(
      context,
      suggestions: widget.hashtagSuggestions,
    );

    if (tag != null) {
      _controller.insertHashtag(tag);
    }
  }

  Future<void> _showEmailDialog() async {
    final email = await InsertEmailDialog.show(context);

    if (email != null) {
      _controller.insertEmail(email);
    }
  }

  Future<void> _showPhoneDialog() async {
    final phone = await InsertPhoneDialog.show(context);

    if (phone != null) {
      _controller.insertPhone(phone);
    }
  }

  String? _getSelectedText() {
    final selection = _controller.selection;
    if (selection == null || selection.isCollapsed) return null;

    final document = _controller.document;
    final selectedNodes = document.getNodesInside(
      selection.base,
      selection.extent,
    );

    final buffer = StringBuffer();
    for (final node in selectedNodes) {
      if (node is TextNode) {
        buffer.write(node.text.text);
      }
    }

    return buffer.toString();
  }
}

/// Toolbar position options
enum ToolbarPosition {
  top,
  bottom,
}

/// Simple interactive text field with single-line support
class SuperInteractiveTextField extends StatefulWidget {
  const SuperInteractiveTextField({
    super.key,
    this.controller,
    this.initialText,
    this.autoDetect = true,
    this.decoration,
    this.textStyle,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
  });

  final InteractiveEditorController? controller;
  final String? initialText;
  final bool autoDetect;
  final InputDecoration? decoration;
  final TextStyle? textStyle;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;

  @override
  State<SuperInteractiveTextField> createState() =>
      _SuperInteractiveTextFieldState();
}

class _SuperInteractiveTextFieldState extends State<SuperInteractiveTextField> {
  late InteractiveEditorController _controller;
  late FocusNode _focusNode;
  bool _ownsController = false;
  bool _ownsFocusNode = false;

  @override
  void initState() {
    super.initState();

    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = InteractiveEditorController(
        initialText: widget.initialText,
        autoDetect: widget.autoDetect,
      );
      _ownsController = true;
    }

    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    }

    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (_ownsController) {
      _controller.dispose();
    }
    if (_ownsFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onControllerChanged() {
    widget.onChanged?.call(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return SuperEditor(
      editor: _controller.editor,
      document: _controller.document,
      composer: _controller.composer,
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      stylesheet: interactiveDefaultStylesheet,
    );
  }
}
