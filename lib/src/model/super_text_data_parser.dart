part of '../super_text_preview_library.dart';

/// Internal parser class that handles the text processing
class SuperTextDataParser {
  static final Map<String, List<SuperTextData>> _parsedTexts = {};

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

  // Internal route regex pattern
  static final RegExp _routeRegex = RegExp(
    r'https://clubapp3\.page\.link/[^\s]*',
    caseSensitive: false,
  );

  // Social media regex patterns
  static final RegExp _socialMediaRegex = RegExp(
    r'https?://(?:www\.)?(instagram\.com|twitter\.com|x\.com|facebook\.com|youtube\.com|youtu\.be|linkedin\.com|tiktok\.com|snapchat\.com|wa\.me|t\.me)/[^\s]+',
    caseSensitive: false,
  );

  /// Main parsing method that processes the input text
  ///
  /// * [text] the text to parse.
  /// * [save] if true, the parsed text will be saved in the cache.
  /// * returns [List<SuperTextData>] the parsed text data.
  static List<SuperTextData> parse(String text, {bool save = false}) {
    text = text.trim();
    if (save) {
      return _parsedTexts.putIfAbsent(text, () => _parseText(text));
    } else {
      return _parseText(text);
    }
  }

  /// Main parsing method that processes the input text
  static List<SuperTextData> _parseText(String text) {
    if (text.isEmpty) return [];

    List<SuperTextData> result = [];
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
    for (Match match in _routeRegex.allMatches(text)) {
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
    // Remove the base URL to get the path
    String path = url.replaceFirst('https://clubapp3.page.link/', '');

    // Handle empty path or just slash
    if (path.isEmpty || path == '/') {
      return RouteTextData(
        text: url,
        pathParameters: null,
        routeType: RouteType.home,
      );
    }

    // Remove trailing slash for consistent matching
    if (path.endsWith('/') && path.length > 1) {
      path = path.substring(0, path.length - 1);
    }

    // Define route patterns with their parameter names and route types
    final List<_RoutePattern> patterns = [
      // Static routes (no parameters)
      _RoutePattern(r'^login$', [], RouteType.login),
      _RoutePattern(r'^signup$', [], RouteType.signup),
      _RoutePattern(r'^Clubs/create$', [], RouteType.clubCreate),
      _RoutePattern(r'^Plans$', [], RouteType.planIndex),
      _RoutePattern(r'^search$', [], RouteType.clubSearch),
      _RoutePattern(r'^notification$', [], RouteType.notificationIndex),
      _RoutePattern(
        r'^interested-categories$',
        [],
        RouteType.interestedCategories,
      ),
      _RoutePattern(r'^forget-password$', [], RouteType.forgetPassword),
      _RoutePattern(r'^phone-auth$', [], RouteType.phoneAuth),
      _RoutePattern(r'^emailVerification$', [], RouteType.emailVerification),
      _RoutePattern(r'^waiting-verifying$', [], RouteType.waitingVerifying),
      _RoutePattern(r'^introduction$', [], RouteType.introduction),
      _RoutePattern(r'^licence-agreement$', [], RouteType.licenceAgreement),
      _RoutePattern(r'^app-setting$', [], RouteType.appSettings),
      _RoutePattern(r'^pdf-reader$', [], RouteType.pdfReader),
      _RoutePattern(r'^user/profile/edit$', [], RouteType.userProfileEdit),
      _RoutePattern(r'^user/password/edit$', [], RouteType.userPasswordEdit),
      _RoutePattern(r'^user/email/edit$', [], RouteType.userEmailEdit),
      _RoutePattern(
        r'^user/social-media-links/modify$',
        [],
        RouteType.userSocialMediaEdit,
      ),

      // Club routes
      _RoutePattern(r'^Clubs/([^/]+)$', ['clubId'], RouteType.clubDetails),
      _RoutePattern(r'^Clubs/([^/]+)/edit$', ['clubId'], RouteType.clubEdit),
      _RoutePattern(
          r'^Clubs/([^/]+)/subscription$',
          [
            'clubId',
          ],
          RouteType.clubSubscription),
      _RoutePattern(
          r'^Clubs/([^/]+)/settings$',
          [
            'clubId',
          ],
          RouteType.clubSettings),
      _RoutePattern(
          r'^Clubs/([^/]+)/balance$',
          [
            'clubId',
          ],
          RouteType.clubBalance),
      _RoutePattern(
          r'^Clubs/([^/]+)/contactus$',
          [
            'clubId',
          ],
          RouteType.clubContactUs),
      _RoutePattern(
          r'^Clubs/([^/]+)/contactus/([^/]+)$',
          [
            'clubId',
            'contactUsId',
          ],
          RouteType.clubContactUsDetails),
      _RoutePattern(
          r'^Clubs/([^/]+)/contactus/modify$',
          [
            'clubId',
          ],
          RouteType.clubContactUsModify),
      _RoutePattern(
          r'^Clubs/([^/]+)/ClubMessages$',
          [
            'clubId',
          ],
          RouteType.clubMessagesIndex),
      _RoutePattern(
          r'^Clubs/([^/]+)/ClubMessages/modify$',
          [
            'clubId',
          ],
          RouteType.clubMessagesModify),
      _RoutePattern(
          r'^Clubs/([^/]+)/ClubMessages/([^/]+)$',
          [
            'clubId',
            'messageId',
          ],
          RouteType.clubMessagesDetails),
      _RoutePattern(
        r'^Clubs/([^/]+)/membership-questions$',
        ['clubId'],
        RouteType.clubMembershipQuestionsIndex,
      ),
      _RoutePattern(
        r'^Clubs/([^/]+)/membership-questions/modify$',
        ['clubId'],
        RouteType.clubMembershipQuestionsModify,
      ),
      _RoutePattern(
        r'^Clubs/([^/]+)/membership-questions/answer$',
        ['clubId'],
        RouteType.clubMembershipQuestionsAnswer,
      ),
      _RoutePattern(
          r'^Clubs/([^/]+)/mass-mail$',
          [
            'clubId',
          ],
          RouteType.clubMassEmail),
      _RoutePattern(
          r'^Clubs/([^/]+)/payment/([^&]+)&([^/]+)$',
          [
            'clubId',
            'isOneTimePayment',
            'price',
          ],
          RouteType.clubPaymentCreate),
      _RoutePattern(
          r'^Clubs/([^/]+)/edit-logo$',
          [
            'clubId',
          ],
          RouteType.clubLogoModify),
      _RoutePattern(
          r'^Clubs/([^/]+)/edit-members-policies$',
          [
            'clubId',
          ],
          RouteType.clubMemberPolicyEdit),
      _RoutePattern(
          r'^Clubs/([^/]+)/gallery$',
          [
            'clubId',
          ],
          RouteType.clubGalleryIndex),
      _RoutePattern(
          r'^Clubs/([^/]+)/gallery/modify$',
          [
            'clubId',
          ],
          RouteType.clubGalleryModify),
      _RoutePattern(
          r'^Clubs/([^/]+)/gallery/([^/]+)$',
          [
            'clubId',
            'galleryId',
          ],
          RouteType.clubGalleryDetails),
      _RoutePattern(
        r'^Clubs/([^/]+)/gallery/([^/]+)/add-media$',
        ['clubId', 'galleryId'],
        RouteType.clubGalleryMediaAdd,
      ),
      _RoutePattern(
        r'^Clubs/([^/]+)/gallery/([^/]+)/media/([^/]+)$',
        ['clubId', 'galleryId', 'mediaId'],
        RouteType.clubGalleryMediaDetails,
      ),
      _RoutePattern(
          r'^Clubs/([^/]+)/invite$',
          [
            'clubId',
          ],
          RouteType.clubInviteLink),
      _RoutePattern(r'^Clubs/([^/]+)/about$', ['clubId'], RouteType.clubAbout),
      _RoutePattern(
          r'^Clubs/([^/]+)/about/modify$',
          [
            'clubId',
          ],
          RouteType.clubAboutModify),
      _RoutePattern(
          r'^Clubs/([^/]+)/nav$',
          [
            'clubId',
          ],
          RouteType.clubNavConfigEdit),
      _RoutePattern(
          r'^Clubs/([^/]+)/ClubMembers$',
          [
            'clubId',
          ],
          RouteType.clubMembersIndex),
      _RoutePattern(
        r'^Clubs/([^/]+)/ClubMembers/join-request$',
        ['clubId'],
        RouteType.clubMemberJoinRequest,
      ),
      _RoutePattern(
          r'^Clubs/([^/]+)/ClubMembers/([^/]+)$',
          [
            'clubId',
            'memberId',
          ],
          RouteType.clubMembersDetails),
      _RoutePattern(
          r'^Clubs/([^/]+)/News$',
          [
            'clubId',
          ],
          RouteType.clubNewsIndex),
      _RoutePattern(
          r'^Clubs/([^/]+)/News/modify$',
          [
            'clubId',
          ],
          RouteType.clubNewsModify),
      _RoutePattern(
          r'^Clubs/([^/]+)/News/([^/]+)$',
          [
            'clubId',
            'newsId',
          ],
          RouteType.clubNewsDetails),
      _RoutePattern(
          r'^Clubs/([^/]+)/Articles$',
          [
            'clubId',
          ],
          RouteType.clubArticlesIndex),
      _RoutePattern(
          r'^Clubs/([^/]+)/Articles/modify$',
          [
            'clubId',
          ],
          RouteType.clubArticlesModify),
      _RoutePattern(
          r'^Clubs/([^/]+)/Articles/([^/]+)$',
          [
            'clubId',
            'articleId',
          ],
          RouteType.clubArticlesDetails),
      _RoutePattern(
          r'^Clubs/([^/]+)/single-articles$',
          [
            'clubId',
          ],
          RouteType.clubSingleArticlesIndex),
      _RoutePattern(
        r'^Clubs/([^/]+)/single-articles/modify$',
        ['clubId'],
        RouteType.clubSingleArticlesModify,
      ),
      _RoutePattern(
        r'^Clubs/([^/]+)/single-articles/([^/]+)$',
        ['clubId', 'articleId'],
        RouteType.clubSingleArticlesDetails,
      ),
      _RoutePattern(
          r'^Clubs/([^/]+)/Events$',
          [
            'clubId',
          ],
          RouteType.clubEventsIndex),
      _RoutePattern(
          r'^Clubs/([^/]+)/Events/modify$',
          [
            'clubId',
          ],
          RouteType.clubEventsModify),
      _RoutePattern(
          r'^Clubs/([^/]+)/Events/([^/]+)$',
          [
            'clubId',
            'eventId',
          ],
          RouteType.clubEventsDetails),
      _RoutePattern(
          r'^Clubs/([^/]+)/Groups$',
          [
            'clubId',
          ],
          RouteType.clubGroupsIndex),
      _RoutePattern(
          r'^Clubs/([^/]+)/Groups/modify/([^/]+)$',
          [
            'clubId',
            'type',
          ],
          RouteType.clubGroupsModify),
      _RoutePattern(
          r'^Clubs/([^/]+)/Groups/([^/]+)$',
          [
            'clubId',
            'groupId',
          ],
          RouteType.clubGroupsDetails),
      _RoutePattern(
        r'^Clubs/([^/]+)/Groups/([^/]+)/Members$',
        ['clubId', 'groupId'],
        RouteType.clubGroupMembersIndex,
      ),
      _RoutePattern(
          r'^Clubs/([^/]+)/Groups/([^/]+)/Rooms$',
          [
            'clubId',
            'groupId',
          ],
          RouteType.clubGroupRoomsIndex),
      _RoutePattern(
        r'^Clubs/([^/]+)/Groups/([^/]+)/Rooms/modify$',
        ['clubId', 'groupId'],
        RouteType.clubGroupRoomsModify,
      ),
      _RoutePattern(
        r'^Clubs/([^/]+)/Groups/([^/]+)/Rooms/([^/]+)$',
        ['clubId', 'groupId', 'roomId'],
        RouteType.clubGroupRoomsDetails,
      ),
      _RoutePattern(
        r'^Clubs/([^/]+)/Groups/([^/]+)/Rooms/([^/]+)/chat$',
        ['clubId', 'groupId', 'roomId'],
        RouteType.clubGroupRoomsChat,
      ),
      _RoutePattern(
        r'^Clubs/([^/]+)/Groups/([^/]+)/Rooms/([^/]+)/chat/Meeting$',
        ['clubId', 'groupId', 'roomId'],
        RouteType.clubChatMeeting,
      ),
      _RoutePattern(
          r'^Clubs/([^/]+)/Groups/questions$',
          [
            'clubId',
          ],
          RouteType.clubGroupQuestionsIndex),
      _RoutePattern(
        r'^Clubs/([^/]+)/Groups/questions/modify$',
        ['clubId'],
        RouteType.clubGroupQuestionsModify,
      ),
      _RoutePattern(
        r'^Clubs/([^/]+)/Groups/questions/([^/]+)$',
        ['clubId', 'questionId'],
        RouteType.clubGroupQuestionsDetails,
      ),

      // Chat routes
      _RoutePattern(
          r'^Chats/([^/]+)$',
          [
            'chatId',
          ],
          RouteType.clubChatMessageIndex),
      _RoutePattern(
          r'^Chats/([^/]+)/Tasks$',
          [
            'chatId',
          ],
          RouteType.clubChatTaskIndex),
      _RoutePattern(
          r'^Chats/([^/]+)/Tasks/modify$',
          [
            'chatId',
          ],
          RouteType.clubChatTaskModify),
      _RoutePattern(
          r'^Chats/([^/]+)/Tasks/([^/]+)$',
          [
            'chatId',
            'taskId',
          ],
          RouteType.clubChatTaskDetails),
      _RoutePattern(
          r'^IndividualChat/([^/]+)$',
          [
            'chatId',
          ],
          RouteType.individualChatMessageIndex),
      _RoutePattern(
          r'^IndividualChat/([^/]+)/profile$',
          [
            'chatId',
          ],
          RouteType.chatProfile),

      // Other routes
      _RoutePattern(r'^Plans/([^/]+)$', ['planId'], RouteType.planDetails),
      _RoutePattern(
          r'^Category/([^/]+)$',
          [
            'categoryId',
          ],
          RouteType.categoryDetails),
      _RoutePattern(
          r'^app-youtube-player-iframe/([^/]+)$',
          [
            'url',
          ],
          RouteType.appYoutubePlayer),
      _RoutePattern(
          r'^users/([^/]+)/profile$',
          [
            'userId',
          ],
          RouteType.userProfile),
      _RoutePattern(r'^users/([^/]+)$', ['userId'], RouteType.userDetails),
      _RoutePattern(
          r'^users/([^/]+)/interested$',
          [
            'userId',
          ],
          RouteType.userInterested),
    ];

    Map<String, String> pathParameters = {};
    RouteType? routeType;
    bool matchFound = false;

    // Try to match against known patterns
    for (_RoutePattern pattern in patterns) {
      RegExp regex = RegExp(pattern.pattern);
      Match? match = regex.firstMatch(path);
      if (match != null) {
        matchFound = true;
        routeType = pattern.routeType;
        for (int i = 0;
            i < pattern.parameterNames.length && i < match.groupCount;
            i++) {
          String? value = match.group(i + 1);
          if (value != null) {
            pathParameters[pattern.parameterNames[i]] = value;
          }
        }
        break;
      }
    }

    // Return null if no pattern matched - this will cause the URL to be treated as external
    if (!matchFound || routeType == null) {
      return null;
    }

    return RouteTextData(
      text: url,
      pathParameters: pathParameters.isNotEmpty ? pathParameters : null,
      routeType: routeType,
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

/// Internal class to represent a route pattern
class _RoutePattern {
  final String pattern;
  final List<String> parameterNames;
  final RouteType routeType;

  _RoutePattern(this.pattern, this.parameterNames, this.routeType);
}
