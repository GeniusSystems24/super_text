part of '../super_interactive_text_preview_library.dart';

/// Enum for different text types
enum SuperInteractiveTextType {
  normal,
  link,
  email,
  phone,
  username,
  socialMedia,
  hashtag,
  route,
}

extension SearchKeys on String {
  List<String> get searchKeys {
    final textData = SuperInteractiveTextData.parse(this, save: true);
    final searchKeys = <String>{};
    for (final data in textData.whereType<NormalTextData>()) {
      // remove all special characters
      var text =
          data.text.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ' ').toLowerCase();
      // searchKeys.add(text);

      // split by space or new line
      searchKeys.addAll(text.split(RegExp(r'\s+')));
    }
    return searchKeys.toList();
  }
}

/// Base abstract class for different types of text data
abstract class SuperInteractiveTextData {
  final String text;
  final SuperInteractiveTextType textType;

  SuperInteractiveTextData({required this.text, required this.textType});

  /// Create SuperInteractiveTextData from Map
  factory SuperInteractiveTextData.fromMap(Map<String, dynamic> map) {
    final type = SuperInteractiveTextType.values.firstWhere(
      (e) => e.name == map['textType'],
      orElse: () => SuperInteractiveTextType.normal,
    );

    switch (type) {
      case SuperInteractiveTextType.link:
        return LinkTextData(text: map['text']);
      case SuperInteractiveTextType.email:
        return EmailTextData(text: map['text']);
      case SuperInteractiveTextType.phone:
        return PhoneNumberTextData(text: map['text']);
      case SuperInteractiveTextType.username:
        return UsernameTextData(text: map['text']);
      case SuperInteractiveTextType.hashtag:
        return HashtagTextData(text: map['text']);
      case SuperInteractiveTextType.socialMedia:
        return SocialMediaTextData(
          text: map['text'],
          type: SocialMediaType.values.firstWhere(
            (e) => e.name == map['socialMediaType'],
            orElse: () => SocialMediaType.other,
          ),
          url: map['url'] ?? map['text'],
        );
      case SuperInteractiveTextType.route:
        final config = SuperInteractiveTextDataParser.routeConfig;
        final routeName = map['routeName'] as String?;

        if (config != null && routeName != null) {
          final definition = config.findByName(routeName);
          if (definition != null) {
            return RouteTextData(
              text: map['text'],
              routeDefinition: definition,
              pathParameters: map['pathParameters'] != null
                  ? Map<String, String>.from(map['pathParameters'])
                  : {},
              path: map['path'] ?? '',
            );
          }
        }
        return LinkTextData(text: map['text']);
      default:
        return NormalTextData(text: map['text']);
    }
  }

  /// Convert SuperInteractiveTextData to Map
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> baseMap = {
      'text': text,
      'textType': textType.name,
    };

    if (this is SocialMediaTextData) {
      final socialMedia = this as SocialMediaTextData;
      baseMap['socialMediaType'] = socialMedia.type.name;
      baseMap['url'] = socialMedia.url;
    } else if (this is RouteTextData) {
      final route = this as RouteTextData;
      baseMap['pathParameters'] = route.pathParameters;
      baseMap['routeName'] = route.routeName;
      baseMap['path'] = route.path;
    }

    return baseMap;
  }

  /// Static method to parse text and extract different data types
  static List<SuperInteractiveTextData> parse(String inputText,
          {bool save = false}) =>
      SuperInteractiveTextDataParser.parse(inputText, save: save);
}

/// Normal text without any special formatting
class NormalTextData extends SuperInteractiveTextData {
  NormalTextData({required super.text})
      : super(textType: SuperInteractiveTextType.normal);
}

/// URL/Link text
class LinkTextData extends SuperInteractiveTextData {
  LinkTextData({required super.text})
      : super(textType: SuperInteractiveTextType.link);
}

/// Email address text
class EmailTextData extends SuperInteractiveTextData {
  EmailTextData({required super.text})
      : super(textType: SuperInteractiveTextType.email);
}

/// Phone number text
class PhoneNumberTextData extends SuperInteractiveTextData {
  PhoneNumberTextData({required super.text})
      : super(textType: SuperInteractiveTextType.phone);
}

/// Address text
class AddressText extends SuperInteractiveTextData {
  AddressText({required super.text})
      : super(textType: SuperInteractiveTextType.normal);
}

/// Username text (starting with @)
class UsernameTextData extends SuperInteractiveTextData {
  String get userId => text.replaceAll("@", "");

  UsernameTextData({required super.text})
      : super(textType: SuperInteractiveTextType.username);
}

/// Enum for social media types
enum SocialMediaType {
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

/// Social media link text
class SocialMediaTextData extends SuperInteractiveTextData {
  final SocialMediaType type;
  final String url;

  SocialMediaTextData({
    required super.text,
    required this.type,
    required this.url,
  }) : super(textType: SuperInteractiveTextType.socialMedia);
}

/// Hashtag text (starting with #)
class HashtagTextData extends SuperInteractiveTextData {
  String get title => text.replaceAll("#", "");

  HashtagTextData({required super.text})
      : super(textType: SuperInteractiveTextType.hashtag);
}

/// Route text for internal app links
class RouteTextData extends SuperInteractiveTextData {
  /// The matched route definition
  final RouteDefinition routeDefinition;

  /// Extracted path parameters
  final Map<String, String> pathParameters;

  /// Extracted query parameters
  final Map<String, String>? queryParameters;

  /// The path without base address
  final String path;

  RouteTextData({
    required super.text,
    required this.routeDefinition,
    required this.pathParameters,
    required this.path,
    this.queryParameters,
  }) : super(textType: SuperInteractiveTextType.route);

  /// Get the route name
  String get routeName => routeDefinition.name;

  /// Navigate using the route's onNavigate callback
  void navigate(BuildContext context) {
    routeDefinition.onNavigate?.call(context, this);
  }
}
