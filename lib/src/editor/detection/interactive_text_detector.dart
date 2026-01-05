import 'package:super_editor/super_editor.dart';

import '../attributions/interactive_attributions.dart';

/// Result of text detection
class DetectionResult {
  const DetectionResult({
    required this.start,
    required this.end,
    required this.text,
    required this.attribution,
  });

  final int start;
  final int end;
  final String text;
  final Attribution attribution;
}

/// Detects interactive elements in text and applies attributions
class InteractiveTextDetector {
  InteractiveTextDetector({
    this.detectLinks = true,
    this.detectEmails = true,
    this.detectPhones = true,
    this.detectMentions = true,
    this.detectHashtags = true,
    this.detectSocialMedia = true,
  });

  final bool detectLinks;
  final bool detectEmails;
  final bool detectPhones;
  final bool detectMentions;
  final bool detectHashtags;
  final bool detectSocialMedia;

  // Regular expressions for different data types
  static final RegExp _urlRegex = RegExp(
    r'https?://(?:[-\w.])+(?:[:\d]+)?(?:/(?:[\w/_.])*(?:\?(?:[\w&=%.])*)?(?:#(?:\w*))?)?',
    caseSensitive: false,
  );

  static final RegExp _emailRegex = RegExp(
    r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b',
  );

  static final RegExp _phoneRegex = RegExp(
    r'(\+?\d{1,4}[-.\s]?)?\(?\d{1,3}\)?[-.\s]?\d{1,4}[-.\s]?\d{1,4}[-.\s]?\d{1,9}',
  );

  static final RegExp _usernameRegex = RegExp(r'@[A-Za-z0-9_]+');

  static final RegExp _hashtagRegex = RegExp(r'#[A-Za-z0-9_]+');

  static final RegExp _socialMediaRegex = RegExp(
    r'https?://(?:www\.)?(instagram\.com|twitter\.com|x\.com|facebook\.com|youtube\.com|youtu\.be|linkedin\.com|tiktok\.com|snapchat\.com|wa\.me|t\.me)/[^\s]+',
    caseSensitive: false,
  );

  /// Detect all interactive elements in text
  List<DetectionResult> detectAll(String text) {
    final List<DetectionResult> results = [];

    // Detect social media URLs first (more specific than regular URLs)
    if (detectSocialMedia) {
      for (final match in _socialMediaRegex.allMatches(text)) {
        final url = match.group(0)!;
        final platform = _getSocialMediaType(url);
        results.add(DetectionResult(
          start: match.start,
          end: match.end,
          text: url,
          attribution: InteractiveSocialMediaAttribution(
            url: url,
            platform: platform,
          ),
        ));
      }
    }

    // Detect regular URLs (excluding already detected social media)
    if (detectLinks) {
      for (final match in _urlRegex.allMatches(text)) {
        final url = match.group(0)!;
        // Skip if it's already a social media URL
        if (!_isOverlapping(match.start, match.end, results)) {
          results.add(DetectionResult(
            start: match.start,
            end: match.end,
            text: url,
            attribution: InteractiveLinkAttribution(url),
          ));
        }
      }
    }

    // Detect emails
    if (detectEmails) {
      for (final match in _emailRegex.allMatches(text)) {
        if (!_isOverlapping(match.start, match.end, results)) {
          results.add(DetectionResult(
            start: match.start,
            end: match.end,
            text: match.group(0)!,
            attribution: InteractiveEmailAttribution(match.group(0)!),
          ));
        }
      }
    }

    // Detect phone numbers
    if (detectPhones) {
      for (final match in _phoneRegex.allMatches(text)) {
        final phone = match.group(0)!.trim();
        final validatedPhone = _validatePhoneNumber(phone);
        if (validatedPhone != null &&
            !_isOverlapping(match.start, match.end, results)) {
          results.add(DetectionResult(
            start: match.start,
            end: match.end,
            text: phone,
            attribution: InteractivePhoneAttribution(validatedPhone),
          ));
        }
      }
    }

    // Detect mentions (@username)
    if (detectMentions) {
      for (final match in _usernameRegex.allMatches(text)) {
        if (!_isOverlapping(match.start, match.end, results)) {
          results.add(DetectionResult(
            start: match.start,
            end: match.end,
            text: match.group(0)!,
            attribution: InteractiveMentionAttribution(match.group(0)!),
          ));
        }
      }
    }

    // Detect hashtags (#tag)
    if (detectHashtags) {
      for (final match in _hashtagRegex.allMatches(text)) {
        if (!_isOverlapping(match.start, match.end, results)) {
          results.add(DetectionResult(
            start: match.start,
            end: match.end,
            text: match.group(0)!,
            attribution: InteractiveHashtagAttribution(match.group(0)!),
          ));
        }
      }
    }

    // Sort by start position
    results.sort((a, b) => a.start.compareTo(b.start));

    return results;
  }

  /// Apply detected attributions to AttributedText
  AttributedText applyDetections(String text) {
    final detections = detectAll(text);
    final attributedText = AttributedText(text);

    for (final detection in detections) {
      attributedText.addAttribution(
        detection.attribution,
        SpanRange(detection.start, detection.end - 1),
      );
    }

    return attributedText;
  }

  /// Check if a range overlaps with existing results
  bool _isOverlapping(int start, int end, List<DetectionResult> results) {
    for (final result in results) {
      if (start < result.end && end > result.start) {
        return true;
      }
    }
    return false;
  }

  /// Get social media type from URL
  InteractiveSocialMediaType _getSocialMediaType(String url) {
    final lowerUrl = url.toLowerCase();
    if (lowerUrl.contains('instagram.com')) {
      return InteractiveSocialMediaType.instagram;
    }
    if (lowerUrl.contains('twitter.com') || lowerUrl.contains('x.com')) {
      return InteractiveSocialMediaType.twitter;
    }
    if (lowerUrl.contains('facebook.com')) {
      return InteractiveSocialMediaType.facebook;
    }
    if (lowerUrl.contains('youtube.com') || lowerUrl.contains('youtu.be')) {
      return InteractiveSocialMediaType.youtube;
    }
    if (lowerUrl.contains('linkedin.com')) {
      return InteractiveSocialMediaType.linkedin;
    }
    if (lowerUrl.contains('tiktok.com')) {
      return InteractiveSocialMediaType.tiktok;
    }
    if (lowerUrl.contains('snapchat.com')) {
      return InteractiveSocialMediaType.snapchat;
    }
    if (lowerUrl.contains('wa.me')) {
      return InteractiveSocialMediaType.whatsapp;
    }
    if (lowerUrl.contains('t.me')) {
      return InteractiveSocialMediaType.telegram;
    }
    return InteractiveSocialMediaType.other;
  }

  /// Validate and format phone number
  String? _validatePhoneNumber(String phone) {
    final digitsOnly = phone.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.length < 7 || digitsOnly.length > 15) {
      return null;
    }

    // Handle Saudi numbers
    if (digitsOnly.startsWith('966') && digitsOnly.length == 12) {
      return '+$digitsOnly';
    } else if (digitsOnly.startsWith('05') && digitsOnly.length == 10) {
      return '+966${digitsOnly.substring(1)}';
    } else if (digitsOnly.startsWith('5') && digitsOnly.length == 9) {
      return '+966$digitsOnly';
    }

    if (phone.startsWith('+')) {
      return phone;
    }

    if (digitsOnly.length >= 7) {
      return phone;
    }

    return null;
  }
}
