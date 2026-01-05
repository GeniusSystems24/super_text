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
    for (final node in _document.nodes) {
      if (node is TextNode) {
        buffer.writeln(node.text.text);
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
  void insertText(String text) {
    final selection = _composer.selection;
    if (selection == null) return;

    _editor.execute([
      InsertTextRequest(
        documentPosition: selection.extent,
        textToInsert: text,
        attributions: {},
      ),
    ]);

    notifyListeners();
  }

  /// Insert attributed text at current position
  void insertAttributedText(AttributedText text) {
    final selection = _composer.selection;
    if (selection == null) return;

    _editor.execute([
      InsertAttributedTextRequest(
        documentPosition: selection.extent,
        textToInsert: text,
      ),
    ]);

    notifyListeners();
  }

  /// Insert a link
  void insertLink(String url, {String? displayText}) {
    final text = displayText ?? url;
    final attributedText = AttributedText(
      text,
      AttributedSpans(
        attributions: [
          SpanMarker(
            attribution: InteractiveLinkAttribution(url),
            offset: 0,
            markerType: SpanMarkerType.start,
          ),
          SpanMarker(
            attribution: InteractiveLinkAttribution(url),
            offset: text.length - 1,
            markerType: SpanMarkerType.end,
          ),
        ],
      ),
    );

    insertAttributedText(attributedText);
  }

  /// Insert a mention (@username)
  void insertMention(String username) {
    final text = username.startsWith('@') ? username : '@$username';
    final attributedText = AttributedText(
      text,
      AttributedSpans(
        attributions: [
          SpanMarker(
            attribution: InteractiveMentionAttribution(text),
            offset: 0,
            markerType: SpanMarkerType.start,
          ),
          SpanMarker(
            attribution: InteractiveMentionAttribution(text),
            offset: text.length - 1,
            markerType: SpanMarkerType.end,
          ),
        ],
      ),
    );

    insertAttributedText(attributedText);
  }

  /// Insert a hashtag (#tag)
  void insertHashtag(String tag) {
    final text = tag.startsWith('#') ? tag : '#$tag';
    final attributedText = AttributedText(
      text,
      AttributedSpans(
        attributions: [
          SpanMarker(
            attribution: InteractiveHashtagAttribution(text),
            offset: 0,
            markerType: SpanMarkerType.start,
          ),
          SpanMarker(
            attribution: InteractiveHashtagAttribution(text),
            offset: text.length - 1,
            markerType: SpanMarkerType.end,
          ),
        ],
      ),
    );

    insertAttributedText(attributedText);
  }

  /// Insert an email
  void insertEmail(String email) {
    final attributedText = AttributedText(
      email,
      AttributedSpans(
        attributions: [
          SpanMarker(
            attribution: InteractiveEmailAttribution(email),
            offset: 0,
            markerType: SpanMarkerType.start,
          ),
          SpanMarker(
            attribution: InteractiveEmailAttribution(email),
            offset: email.length - 1,
            markerType: SpanMarkerType.end,
          ),
        ],
      ),
    );

    insertAttributedText(attributedText);
  }

  /// Insert a phone number
  void insertPhone(String phone) {
    final attributedText = AttributedText(
      phone,
      AttributedSpans(
        attributions: [
          SpanMarker(
            attribution: InteractivePhoneAttribution(phone),
            offset: 0,
            markerType: SpanMarkerType.start,
          ),
          SpanMarker(
            attribution: InteractivePhoneAttribution(phone),
            offset: phone.length - 1,
            markerType: SpanMarkerType.end,
          ),
        ],
      ),
    );

    insertAttributedText(attributedText);
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
    for (final node in _document.nodes) {
      if (node is TextNode) {
        final text = node.text.text;
        final detections = _detector.detectAll(text);

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
    _document.nodes.clear();
    _document.nodes.add(
      ParagraphNode(
        id: Editor.createNodeId(),
        text: AttributedText(''),
      ),
    );
    _composer.selection = null;
    notifyListeners();
  }

  /// Set text content (replaces existing)
  void setText(String text) {
    _document.nodes.clear();

    final lines = text.split('\n');
    for (final line in lines) {
      final attributedText = _autoDetect
          ? _detector.applyDetections(line)
          : AttributedText(line);

      _document.nodes.add(
        ParagraphNode(
          id: Editor.createNodeId(),
          text: attributedText,
        ),
      );
    }

    if (_document.nodes.isEmpty) {
      _document.nodes.add(
        ParagraphNode(
          id: Editor.createNodeId(),
          text: AttributedText(''),
        ),
      );
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

    for (final node in _document.nodes) {
      if (node is TextNode) {
        final spans = <Map<String, dynamic>>[];
        final text = node.text;

        // Get all attribution spans
        text.visitAttributions((attributedText, index, attributions, start, end) {
          for (final attribution in attributions) {
            spans.add({
              'start': start,
              'end': end,
              'type': _getAttributionType(attribution),
              'data': _getAttributionData(attribution),
            });
          }
        });

        nodes.add({
          'type': 'paragraph',
          'text': text.text,
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
