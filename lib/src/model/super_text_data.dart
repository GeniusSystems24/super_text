part of '../super_text_preview_library.dart';

/// Enum for different text types
enum SuperTextType {
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
    final textData = SuperTextData.parse(this, save: true);
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
abstract class SuperTextData {
  final String text;
  final SuperTextType textType;

  SuperTextData({required this.text, required this.textType});

  /// Create SuperTextData from Map
  factory SuperTextData.fromMap(Map<String, dynamic> map) {
    final type = SuperTextType.values.firstWhere(
      (e) => e.name == map['textType'],
      orElse: () => SuperTextType.normal,
    );

    switch (type) {
      case SuperTextType.link:
        return LinkTextData(text: map['text']);
      case SuperTextType.email:
        return EmailTextData(text: map['text']);
      case SuperTextType.phone:
        return PhoneNumberTextData(text: map['text']);
      case SuperTextType.username:
        return UsernameTextData(text: map['text']);
      case SuperTextType.hashtag:
        return HashtagTextData(text: map['text']);
      case SuperTextType.socialMedia:
        return SocialMediaTextData(
          text: map['text'],
          type: SocialMediaType.values.firstWhere(
            (e) => e.name == map['socialMediaType'],
            orElse: () => SocialMediaType.other,
          ),
          url: map['url'] ?? map['text'],
        );
      case SuperTextType.route:
        final config = SuperTextDataParser.routeConfig;
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

  /// Convert SuperTextData to Map
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
  static List<SuperTextData> parse(String inputText, {bool save = false}) =>
      SuperTextDataParser.parse(inputText, save: save);
}

/// Normal text without any special formatting
class NormalTextData extends SuperTextData {
  NormalTextData({required super.text}) : super(textType: SuperTextType.normal);
}

/// URL/Link text
class LinkTextData extends SuperTextData {
  LinkTextData({required super.text}) : super(textType: SuperTextType.link);
}

/// Email address text
class EmailTextData extends SuperTextData {
  EmailTextData({required super.text}) : super(textType: SuperTextType.email);
}

/// Phone number text
class PhoneNumberTextData extends SuperTextData {
  PhoneNumberTextData({required super.text})
      : super(textType: SuperTextType.phone);
}

/// Address text
class AddressText extends SuperTextData {
  AddressText({required super.text}) : super(textType: SuperTextType.normal);
}

/// Username text (starting with @)
class UsernameTextData extends SuperTextData {
  String get userId => text.replaceAll("@", "");

  UsernameTextData({required super.text})
      : super(textType: SuperTextType.username);
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
class SocialMediaTextData extends SuperTextData {
  final SocialMediaType type;
  final String url;

  SocialMediaTextData({
    required super.text,
    required this.type,
    required this.url,
  }) : super(textType: SuperTextType.socialMedia);
}

/// Hashtag text (starting with #)
class HashtagTextData extends SuperTextData {
  String get title => text.replaceAll("#", "");

  HashtagTextData({required super.text})
      : super(textType: SuperTextType.hashtag);
}

/// Route text for internal app links
class RouteTextData extends SuperTextData {
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
  }) : super(textType: SuperTextType.route);

  /// Get the route name
  String get routeName => routeDefinition.name;

  /// Navigate using the route's onNavigate callback
  void navigate(BuildContext context) {
    routeDefinition.onNavigate?.call(context, this);
  }
}
