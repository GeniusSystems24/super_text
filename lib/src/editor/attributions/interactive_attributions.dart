import 'package:super_editor/super_editor.dart';

/// Attribution for links/URLs
class InteractiveLinkAttribution implements Attribution {
  const InteractiveLinkAttribution(this.url);

  @override
  String get id => 'interactive_link';

  final String url;

  @override
  bool canMergeWith(Attribution other) {
    return other is InteractiveLinkAttribution && other.url == url;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InteractiveLinkAttribution &&
          runtimeType == other.runtimeType &&
          url == other.url;

  @override
  int get hashCode => url.hashCode;

  @override
  String toString() => '[InteractiveLinkAttribution]: $url';
}

/// Attribution for email addresses
class InteractiveEmailAttribution implements Attribution {
  const InteractiveEmailAttribution(this.email);

  @override
  String get id => 'interactive_email';

  final String email;

  @override
  bool canMergeWith(Attribution other) {
    return other is InteractiveEmailAttribution && other.email == email;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InteractiveEmailAttribution &&
          runtimeType == other.runtimeType &&
          email == other.email;

  @override
  int get hashCode => email.hashCode;

  @override
  String toString() => '[InteractiveEmailAttribution]: $email';
}

/// Attribution for phone numbers
class InteractivePhoneAttribution implements Attribution {
  const InteractivePhoneAttribution(this.phone);

  @override
  String get id => 'interactive_phone';

  final String phone;

  @override
  bool canMergeWith(Attribution other) {
    return other is InteractivePhoneAttribution && other.phone == phone;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InteractivePhoneAttribution &&
          runtimeType == other.runtimeType &&
          phone == other.phone;

  @override
  int get hashCode => phone.hashCode;

  @override
  String toString() => '[InteractivePhoneAttribution]: $phone';
}

/// Attribution for usernames (mentions starting with @)
class InteractiveMentionAttribution implements Attribution {
  const InteractiveMentionAttribution(this.username);

  @override
  String get id => 'interactive_mention';

  final String username;

  /// Get the username without the @ symbol
  String get userId => username.replaceAll('@', '');

  @override
  bool canMergeWith(Attribution other) {
    return other is InteractiveMentionAttribution && other.username == username;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InteractiveMentionAttribution &&
          runtimeType == other.runtimeType &&
          username == other.username;

  @override
  int get hashCode => username.hashCode;

  @override
  String toString() => '[InteractiveMentionAttribution]: $username';
}

/// Attribution for hashtags (starting with #)
class InteractiveHashtagAttribution implements Attribution {
  const InteractiveHashtagAttribution(this.hashtag);

  @override
  String get id => 'interactive_hashtag';

  final String hashtag;

  /// Get the hashtag without the # symbol
  String get tag => hashtag.replaceAll('#', '');

  @override
  bool canMergeWith(Attribution other) {
    return other is InteractiveHashtagAttribution && other.hashtag == hashtag;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InteractiveHashtagAttribution &&
          runtimeType == other.runtimeType &&
          hashtag == other.hashtag;

  @override
  int get hashCode => hashtag.hashCode;

  @override
  String toString() => '[InteractiveHashtagAttribution]: $hashtag';
}

/// Social media platform types
enum InteractiveSocialMediaType {
  instagram,
  twitter,
  facebook,
  youtube,
  linkedin,
  tiktok,
  snapchat,
  whatsapp,
  telegram,
  other,
}

/// Attribution for social media links
class InteractiveSocialMediaAttribution implements Attribution {
  const InteractiveSocialMediaAttribution({
    required this.url,
    required this.platform,
  });

  @override
  String get id => 'interactive_social_media';

  final String url;
  final InteractiveSocialMediaType platform;

  @override
  bool canMergeWith(Attribution other) {
    return other is InteractiveSocialMediaAttribution &&
        other.url == url &&
        other.platform == platform;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InteractiveSocialMediaAttribution &&
          runtimeType == other.runtimeType &&
          url == other.url &&
          platform == other.platform;

  @override
  int get hashCode => Object.hash(url, platform);

  @override
  String toString() =>
      '[InteractiveSocialMediaAttribution]: $url (${platform.name})';
}

/// Attribution for internal app routes
class InteractiveRouteAttribution implements Attribution {
  const InteractiveRouteAttribution({
    required this.url,
    required this.routeName,
    this.pathParameters = const {},
  });

  @override
  String get id => 'interactive_route';

  final String url;
  final String routeName;
  final Map<String, String> pathParameters;

  @override
  bool canMergeWith(Attribution other) {
    return other is InteractiveRouteAttribution &&
        other.url == url &&
        other.routeName == routeName;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InteractiveRouteAttribution &&
          runtimeType == other.runtimeType &&
          url == other.url &&
          routeName == other.routeName;

  @override
  int get hashCode => Object.hash(url, routeName);

  @override
  String toString() =>
      '[InteractiveRouteAttribution]: $url (route: $routeName)';
}
