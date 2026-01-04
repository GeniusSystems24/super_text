part of '../super_interactive_text_preview_library.dart';

/// Internal parser class that handles the text processing
class SuperInteractiveTextDataParser {
  static final Map<String, List<SuperInteractiveTextData>> _parsedTexts = {};

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

  // Route configuration - must be set before parsing routes
  static RouteConfig? _routeConfig;

  /// Configure the parser with route definitions
  static void configure(RouteConfig config) {
    _routeConfig = config;
    _parsedTexts.clear(); // Clear cache when config changes
  }

  /// Get the current route configuration
  static RouteConfig? get routeConfig => _routeConfig;

  // Dynamic route regex based on configured base addresses
  static RegExp? get _routeRegex {
    if (_routeConfig == null || _routeConfig!.baseAddresses.isEmpty) {
      return null;
    }
    // Build regex pattern from base addresses
    final escapedAddresses = _routeConfig!.baseAddresses
        .map((addr) => RegExp.escape(addr))
        .join('|');
    return RegExp(
      '($escapedAddresses)[^\\s]*',
      caseSensitive: false,
    );
  }

  // Social media regex patterns
  static final RegExp _socialMediaRegex = RegExp(
    r'https?://(?:www\.)?(instagram\.com|twitter\.com|x\.com|facebook\.com|youtube\.com|youtu\.be|linkedin\.com|tiktok\.com|snapchat\.com|wa\.me|t\.me)/[^\s]+',
    caseSensitive: false,
  );

  /// Main parsing method that processes the input text
  ///
  /// * [text] the text to parse.
  /// * [save] if true, the parsed text will be saved in the cache.
  /// * returns [List<SuperInteractiveTextData>] the parsed text data.
  static List<SuperInteractiveTextData> parse(String text,
      {bool save = false}) {
    text = text.trim();
    if (save) {
      return _parsedTexts.putIfAbsent(text, () => _parseText(text));
    } else {
      return _parseText(text);
    }
  }

  /// Main parsing method that processes the input text
  static List<SuperInteractiveTextData> _parseText(String text) {
    if (text.isEmpty) return [];

    List<SuperInteractiveTextData> result = [];
    List<_TextSegment> segments = _extractSegments(text);

    for (_TextSegment segment in segments) {
      if (segment.text.trim().isEmpty) continue;

      switch (segment.type) {
        case _SegmentType.normal:
          result.add(NormalTextData(text: segment.text));
          break;
        case _SegmentType.link:
          result.add(LinkTextData(text: segment.text));
          break;
        case _SegmentType.email:
          result.add(EmailTextData(text: segment.text));
          break;
        case _SegmentType.phone:
          result.add(PhoneNumberTextData(text: segment.text));
          break;
        case _SegmentType.username:
          result.add(UsernameTextData(text: segment.text));
          break;
        case _SegmentType.socialMedia:
          result.add(segment.socialMediaData!);
          break;
        case _SegmentType.hashtag:
          result.add(HashtagTextData(text: segment.text));
          break;
        case _SegmentType.route:
          result.add(segment.routeData!);
          break;
      }
    }

    return result;
  }

  /// Extract segments from text with their types
  static List<_TextSegment> _extractSegments(String text) {
    List<_Match> matches = [];

    // Find all internal route URLs first (most specific)
    final routeRegex = _routeRegex;
    if (routeRegex != null) {
      for (Match match in routeRegex.allMatches(text)) {
        String url = match.group(0)!;
        RouteTextData? routeData = _parseRouteUrl(url);
        // Only add as route if it matches a valid pattern, otherwise it will be handled as regular URL
        if (routeData != null) {
          matches.add(
            _Match(
              start: match.start,
              end: match.end,
              text: url,
              type: _SegmentType.route,
              routeData: routeData,
            ),
          );
        }
      }
    }

    // Find all social media URLs (more specific than regular URLs)
    for (Match match in _socialMediaRegex.allMatches(text)) {
      String url = match.group(0)!;
      // Skip if it's already identified as internal route
      bool isRoute = matches.any(
        (m) =>
            m.type == _SegmentType.route &&
            m.start <= match.start &&
            m.end >= match.end,
      );
      if (!isRoute) {
        SocialMediaType type = _getSocialMediaType(url);
        SocialMediaTextData socialMediaData = SocialMediaTextData(
          text: url,
          type: type,
          url: url,
        );
        matches.add(
          _Match(
            start: match.start,
            end: match.end,
            text: url,
            type: _SegmentType.socialMedia,
            socialMediaData: socialMediaData,
          ),
        );
      }
    }

    // Find all other URLs
    for (Match match in _urlRegex.allMatches(text)) {
      String url = match.group(0)!;
      // Skip if it's already identified as social media
      bool isSocialMedia = matches.any(
        (m) =>
            m.type == _SegmentType.socialMedia &&
            m.start <= match.start &&
            m.end >= match.end,
      );
      if (!isSocialMedia) {
        matches.add(
          _Match(
            start: match.start,
            end: match.end,
            text: url,
            type: _SegmentType.link,
          ),
        );
      }
    }

    // Find all emails
    for (Match match in _emailRegex.allMatches(text)) {
      matches.add(
        _Match(
          start: match.start,
          end: match.end,
          text: match.group(0)!,
          type: _SegmentType.email,
        ),
      );
    }

    // Find all phone numbers
    for (Match match in _phoneRegex.allMatches(text)) {
      String phoneText = match.group(0)!.trim();
      String? validatedPhone = _validateAndFormatPhoneNumber(phoneText);
      if (validatedPhone != null) {
        matches.add(
          _Match(
            start: match.start,
            end: match.end,
            text: validatedPhone,
            type: _SegmentType.phone,
          ),
        );
      }
    }

    // Find all usernames
    for (Match match in _usernameRegex.allMatches(text)) {
      matches.add(
        _Match(
          start: match.start,
          end: match.end,
          text: match.group(0)!,
          type: _SegmentType.username,
        ),
      );
    }

    // Find all hashtags
    for (Match match in _hashtagRegex.allMatches(text)) {
      matches.add(
        _Match(
          start: match.start,
          end: match.end,
          text: match.group(0)!,
          type: _SegmentType.hashtag,
        ),
      );
    }

    // Sort matches by start position
    matches.sort((a, b) => a.start.compareTo(b.start));

    // Remove overlapping matches (keep the first one)
    List<_Match> filteredMatches = [];
    for (_Match match in matches) {
      bool overlaps = false;
      for (_Match existing in filteredMatches) {
        if (_isOverlapping(match, existing)) {
          overlaps = true;
          break;
        }
      }
      if (!overlaps) {
        filteredMatches.add(match);
      }
    }

    // Build segments
    List<_TextSegment> segments = [];
    int currentPos = 0;

    for (_Match match in filteredMatches) {
      // Add normal text before the match
      if (currentPos < match.start) {
        String normalText = text.substring(currentPos, match.start);
        if (normalText.isNotEmpty) {
          segments.add(
            _TextSegment(text: normalText, type: _SegmentType.normal),
          );
        }
      }

      // Add the matched segment
      segments.add(
        _TextSegment(
          text: match.text,
          type: match.type,
          socialMediaData: match.socialMediaData,
          routeData: match.routeData,
        ),
      );

      currentPos = match.end;
    }

    // Add remaining normal text
    if (currentPos < text.length) {
      String remainingText = text.substring(currentPos);
      if (remainingText.isNotEmpty) {
        segments.add(
          _TextSegment(text: remainingText, type: _SegmentType.normal),
        );
      }
    }

    return segments;
  }

  /// Check if two matches overlap
  static bool _isOverlapping(_Match a, _Match b) {
    return (a.start < b.end && b.start < a.end);
  }

  /// Parse internal route URL and extract path parameters
  /// Returns null if the URL doesn't match any valid route pattern
  static RouteTextData? _parseRouteUrl(String url) {
    final config = _routeConfig;
    if (config == null) return null;

    // Try to match the URL against configured routes
    final matchResult = config.matchUrl(url);
    if (matchResult == null) return null;

    final (routeDefinition, pathParameters) = matchResult;
    final path = config.extractPath(url) ?? '';

    return RouteTextData(
      text: url,
      routeDefinition: routeDefinition,
      pathParameters: pathParameters,
      path: path,
    );
  }

  /// Get social media type from URL
  static SocialMediaType _getSocialMediaType(String url) {
    String lowerUrl = url.toLowerCase();
    if (lowerUrl.contains('instagram.com')) return SocialMediaType.instagram;
    if (lowerUrl.contains('twitter.com') || lowerUrl.contains('x.com')) {
      return SocialMediaType.twitter;
    }
    if (lowerUrl.contains('facebook.com')) return SocialMediaType.facebook;
    if (lowerUrl.contains('youtube.com') || lowerUrl.contains('youtu.be')) {
      return SocialMediaType.youtube;
    }
    if (lowerUrl.contains('linkedin.com')) return SocialMediaType.linkedin;
    if (lowerUrl.contains('tiktok.com')) return SocialMediaType.tiktok;
    if (lowerUrl.contains('snapchat.com')) return SocialMediaType.snapchat;
    if (lowerUrl.contains('wa.me')) return SocialMediaType.whatsapp;
    if (lowerUrl.contains('t.me')) return SocialMediaType.telegram;
    return SocialMediaType.other;
  }

  /// Validate and format phone number
  static String? _validateAndFormatPhoneNumber(String phone) {
    // Remove all non-digit characters
    String digitsOnly = phone.replaceAll(RegExp(r'[^\d]'), '');

    // Check if it's a valid length (7-15 digits)
    if (digitsOnly.length < 7 || digitsOnly.length > 15) {
      return null;
    }

    // Handle Saudi numbers specifically
    if (digitsOnly.startsWith('966')) {
      // Already has country code
      if (digitsOnly.length == 12) {
        return '+$digitsOnly';
      }
    } else if (digitsOnly.startsWith('05') && digitsOnly.length == 10) {
      // Saudi mobile number without country code
      return '+966${digitsOnly.substring(1)}';
    } else if (digitsOnly.startsWith('5') && digitsOnly.length == 9) {
      // Saudi mobile number without country code and leading 0
      return '+966$digitsOnly';
    }

    // For other international numbers
    if (phone.startsWith('+')) {
      return phone; // Already formatted
    }

    // If it looks like a valid number, return as is
    if (digitsOnly.length >= 7) {
      return phone;
    }

    return null;
  }
}

/// Internal class to represent a match in the text
class _Match {
  final int start;
  final int end;
  final String text;
  final _SegmentType type;
  final SocialMediaTextData? socialMediaData;
  final RouteTextData? routeData;

  _Match({
    required this.start,
    required this.end,
    required this.text,
    required this.type,
    this.socialMediaData,
    this.routeData,
  });
}

/// Internal class to represent a text segment
class _TextSegment {
  final String text;
  final _SegmentType type;
  final SocialMediaTextData? socialMediaData;
  final RouteTextData? routeData;

  _TextSegment({
    required this.text,
    required this.type,
    this.socialMediaData,
    this.routeData,
  });
}

/// Enum for different segment types
enum _SegmentType {
  normal,
  link,
  email,
  phone,
  username,
  socialMedia,
  hashtag,
  route,
}
