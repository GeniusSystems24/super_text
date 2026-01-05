import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';

import '../attributions/interactive_attributions.dart';
import '../detection/interactive_text_detector.dart';

/// Controller for the interactive text editor
class InteractiveEditorController extends ChangeNotifier {
  InteractiveEditorController({
    String? initialText,
    MutableDocument? initialDocument,
    InteractiveTextDetector? detector,
    bool autoDetect = true,
  })  : _autoDetect = autoDetect,
        _detector = detector ?? InteractiveTextDetector() {
    if (initialDocument != null) {
      _document = initialDocument;
    } else if (initialText != null && initialText.isNotEmpty) {
      _document = _createDocumentFromText(initialText);
    } else {
      _document = _createEmptyDocument();
    }

    _composer = MutableDocumentComposer();
    _editor = createDefaultDocumentEditor(
      document: _document,
      composer: _composer,
    );
  }

  late final MutableDocument _document;
  late final MutableDocumentComposer _composer;
  late final Editor _editor;
  final InteractiveTextDetector _detector;
  bool _autoDetect;

  /// Get the document
  MutableDocument get document => _document;

  /// Get the composer
  MutableDocumentComposer get composer => _composer;

  /// Get the editor
  Editor get editor => _editor;

  /// Get auto-detect status
  bool get autoDetect => _autoDetect;

  /// Set auto-detect
  set autoDetect(bool value) {
    if (_autoDetect != value) {
      _autoDetect = value;
      notifyListeners();
    }
  }

  /// Get plain text from document
  String get text {
    final buffer = StringBuffer();
    final nodeCount = _document.nodeCount;
    for (int i = 0; i < nodeCount; i++) {
      final node = _document.getNodeAt(i);
      if (node is TextNode) {
        buffer.writeln(node.text.toPlainText());
      }
    }
    return buffer.toString().trim();
  }

  /// Get the current selection
  DocumentSelection? get selection => _composer.selection;

  /// Check if there is a selection
  bool get hasSelection => _composer.selection != null;

  /// Check if selection is collapsed (cursor position)
  bool get isSelectionCollapsed {
    final selection = _composer.selection;
    return selection != null && selection.isCollapsed;
  }

  /// Create empty document
  MutableDocument _createEmptyDocument() {
    return MutableDocument(
      nodes: [
        ParagraphNode(
          id: Editor.createNodeId(),
          text: AttributedText(''),
        ),
      ],
    );
  }

  /// Create document from text with auto-detection
  MutableDocument _createDocumentFromText(String text) {
    final lines = text.split('\n');
    final nodes = <DocumentNode>[];

    for (final line in lines) {
      final attributedText = _autoDetect
          ? _detector.applyDetections(line)
          : AttributedText(line);

      nodes.add(
        ParagraphNode(
          id: Editor.createNodeId(),
          text: attributedText,
        ),
      );
    }

    if (nodes.isEmpty) {
      nodes.add(
        ParagraphNode(
          id: Editor.createNodeId(),
          text: AttributedText(''),
        ),
      );
    }

    return MutableDocument(nodes: nodes);
  }

  /// Insert text at current position
  void insertText(String textToInsert) {
    final selection = _composer.selection;
    if (selection == null) return;

    _editor.execute([
      InsertTextRequest(
        documentPosition: selection.extent,
        textToInsert: textToInsert,
        attributions: {},
      ),
    ]);

    notifyListeners();
  }

  /// Insert attributed text at current position
  void insertAttributedText(AttributedText textToInsert) {
    final selection = _composer.selection;
    if (selection == null) return;

    // For attributed text, we insert plain text first then apply attributions
    final plainText = textToInsert.toPlainText();

    _editor.execute([
      InsertTextRequest(
        documentPosition: selection.extent,
        textToInsert: plainText,
        attributions: {},
      ),
    ]);

    // Apply the attributions from the attributed text
    // Note: This is a simplified approach - full implementation would need
    // to track the inserted position and apply attributions accordingly

    notifyListeners();
  }

  /// Insert a link
  void insertLink(String url, {String? displayText}) {
    final textToInsert = displayText ?? url;
    final selection = _composer.selection;
    if (selection == null) return;

    _editor.execute([
      InsertTextRequest(
        documentPosition: selection.extent,
        textToInsert: textToInsert,
        attributions: {InteractiveLinkAttribution(url)},
      ),
    ]);

    notifyListeners();
  }

  /// Insert a mention (@username)
  void insertMention(String username) {
    final textToInsert = username.startsWith('@') ? username : '@$username';
    final selection = _composer.selection;
    if (selection == null) return;

    _editor.execute([
      InsertTextRequest(
        documentPosition: selection.extent,
        textToInsert: textToInsert,
        attributions: {InteractiveMentionAttribution(textToInsert)},
      ),
    ]);

    notifyListeners();
  }

  /// Insert a hashtag (#tag)
  void insertHashtag(String tag) {
    final textToInsert = tag.startsWith('#') ? tag : '#$tag';
    final selection = _composer.selection;
    if (selection == null) return;

    _editor.execute([
      InsertTextRequest(
        documentPosition: selection.extent,
        textToInsert: textToInsert,
        attributions: {InteractiveHashtagAttribution(textToInsert)},
      ),
    ]);

    notifyListeners();
  }

  /// Insert an email
  void insertEmail(String email) {
    final selection = _composer.selection;
    if (selection == null) return;

    _editor.execute([
      InsertTextRequest(
        documentPosition: selection.extent,
        textToInsert: email,
        attributions: {InteractiveEmailAttribution(email)},
      ),
    ]);

    notifyListeners();
  }

  /// Insert a phone number
  void insertPhone(String phone) {
    final selection = _composer.selection;
    if (selection == null) return;

    _editor.execute([
      InsertTextRequest(
        documentPosition: selection.extent,
        textToInsert: phone,
        attributions: {InteractivePhoneAttribution(phone)},
      ),
    ]);

    notifyListeners();
  }

  /// Apply attribution to current selection
  void applyAttributionToSelection(Attribution attribution) {
    final selection = _composer.selection;
    if (selection == null || selection.isCollapsed) return;

    _editor.execute([
      AddTextAttributionsRequest(
        documentRange: selection,
        attributions: {attribution},
      ),
    ]);

    notifyListeners();
  }

  /// Remove attribution from current selection
  void removeAttributionFromSelection(Attribution attribution) {
    final selection = _composer.selection;
    if (selection == null || selection.isCollapsed) return;

    _editor.execute([
      RemoveTextAttributionsRequest(
        documentRange: selection,
        attributions: {attribution},
      ),
    ]);

    notifyListeners();
  }

  /// Toggle bold on selection
  void toggleBold() {
    _toggleAttribution(boldAttribution);
  }

  /// Toggle italic on selection
  void toggleItalic() {
    _toggleAttribution(italicsAttribution);
  }

  /// Toggle underline on selection
  void toggleUnderline() {
    _toggleAttribution(underlineAttribution);
  }

  /// Toggle strikethrough on selection
  void toggleStrikethrough() {
    _toggleAttribution(strikethroughAttribution);
  }

  void _toggleAttribution(Attribution attribution) {
    final selection = _composer.selection;
    if (selection == null) return;

    _editor.execute([
      ToggleTextAttributionsRequest(
        documentRange: selection,
        attributions: {attribution},
      ),
    ]);

    notifyListeners();
  }

  /// Convert selection to link
  void convertSelectionToLink(String url) {
    final selection = _composer.selection;
    if (selection == null || selection.isCollapsed) return;

    applyAttributionToSelection(InteractiveLinkAttribution(url));
  }

  /// Run auto-detection on current document
  void runAutoDetection() {
    final nodeCount = _document.nodeCount;
    for (int i = 0; i < nodeCount; i++) {
      final node = _document.getNodeAt(i);
      if (node is TextNode) {
        final plainText = node.text.toPlainText();
        final detections = _detector.detectAll(plainText);

        for (final detection in detections) {
          node.text.addAttribution(
            detection.attribution,
            SpanRange(detection.start, detection.end - 1),
          );
        }
      }
    }

    notifyListeners();
  }

  /// Clear all content
  void clear() {
    // Use editor to clear content properly
    _editor.execute([
      ClearDocumentRequest(),
    ]);

    // Add empty paragraph
    _editor.execute([
      InsertNodeAtIndexRequest(
        nodeIndex: 0,
        node: ParagraphNode(
          id: Editor.createNodeId(),
          text: AttributedText(''),
        ),
      ),
    ]);

    notifyListeners();
  }

  /// Set text content (replaces existing)
  void setText(String text) {
    // Clear existing content
    _editor.execute([
      ClearDocumentRequest(),
    ]);

    final lines = text.split('\n');
    int index = 0;
    for (final line in lines) {
      final attributedText = _autoDetect
          ? _detector.applyDetections(line)
          : AttributedText(line);

      _editor.execute([
        InsertNodeAtIndexRequest(
          nodeIndex: index,
          node: ParagraphNode(
            id: Editor.createNodeId(),
            text: attributedText,
          ),
        ),
      ]);
      index++;
    }

    if (index == 0) {
      _editor.execute([
        InsertNodeAtIndexRequest(
          nodeIndex: 0,
          node: ParagraphNode(
            id: Editor.createNodeId(),
            text: AttributedText(''),
          ),
        ),
      ]);
    }

    notifyListeners();
  }

  /// Export document as plain text
  String exportAsPlainText() {
    return text;
  }

  /// Export document as JSON
  Map<String, dynamic> exportAsJson() {
    final nodes = <Map<String, dynamic>>[];

    final nodeCount = _document.nodeCount;
    for (int i = 0; i < nodeCount; i++) {
      final node = _document.getNodeAt(i);
      if (node is TextNode) {
        final spans = <Map<String, dynamic>>[];
        final attributedText = node.text;

        // Get all attribution spans using spans property
        for (final span in attributedText.spans.markers) {
          if (span.markerType == SpanMarkerType.start) {
            spans.add({
              'offset': span.offset,
              'type': _getAttributionType(span.attribution),
              'data': _getAttributionData(span.attribution),
            });
          }
        }

        nodes.add({
          'type': 'paragraph',
          'text': attributedText.toPlainText(),
          'spans': spans,
        });
      }
    }

    return {
      'version': '1.0',
      'nodes': nodes,
    };
  }

  String _getAttributionType(Attribution attribution) {
    if (attribution is InteractiveLinkAttribution) return 'link';
    if (attribution is InteractiveEmailAttribution) return 'email';
    if (attribution is InteractivePhoneAttribution) return 'phone';
    if (attribution is InteractiveMentionAttribution) return 'mention';
    if (attribution is InteractiveHashtagAttribution) return 'hashtag';
    if (attribution is InteractiveSocialMediaAttribution) return 'socialMedia';
    if (attribution is InteractiveRouteAttribution) return 'route';
    if (attribution == boldAttribution) return 'bold';
    if (attribution == italicsAttribution) return 'italic';
    if (attribution == underlineAttribution) return 'underline';
    if (attribution == strikethroughAttribution) return 'strikethrough';
    return 'unknown';
  }

  Map<String, dynamic>? _getAttributionData(Attribution attribution) {
    if (attribution is InteractiveLinkAttribution) {
      return {'url': attribution.url};
    }
    if (attribution is InteractiveEmailAttribution) {
      return {'email': attribution.email};
    }
    if (attribution is InteractivePhoneAttribution) {
      return {'phone': attribution.phone};
    }
    if (attribution is InteractiveMentionAttribution) {
      return {'username': attribution.username};
    }
    if (attribution is InteractiveHashtagAttribution) {
      return {'hashtag': attribution.hashtag};
    }
    if (attribution is InteractiveSocialMediaAttribution) {
      return {
        'url': attribution.url,
        'platform': attribution.platform.name,
      };
    }
    if (attribution is InteractiveRouteAttribution) {
      return {
        'url': attribution.url,
        'routeName': attribution.routeName,
        'pathParameters': attribution.pathParameters,
      };
    }
    return null;
  }

  @override
  void dispose() {
    _composer.dispose();
    super.dispose();
  }
}
