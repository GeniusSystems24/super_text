# SuperInteractiveText

A powerful Flutter widget for displaying text with interactive, clickable elements.

[Live Demo](https://geniussystems24.github.io/super_interactive_text/)

## Key Features

- 🔗 **Link Extraction**: Supports HTTP and HTTPS with query parameters.
- 📧 **Email Extraction**: Recognizes all valid email formats.
- 📱 **Phone Number Extraction**: Supports local and international numbers with validation.
- 👤 **Username Extraction**: Recognizes usernames starting with @.
- 🏷️ **Hashtag Extraction**: Recognizes hashtags starting with #.
- 🏠 **Internal Route Extraction**: Recognizes valid internal app routes.
- 🌐 **Social Media Extraction**: Instagram, Twitter, Facebook, YouTube, LinkedIn, TikTok, WhatsApp, Telegram.
- 💾 **Serialization Support**: Convert data to/from Map for storage and retrieval.
- 🎨 **Customizable Styling**: Ability to customize the appearance of each data type.
- ⚡ **High Performance**: Fast and efficient processing of long texts.

## Installation

Add the library to your `pubspec.yaml`:

```yaml
dependencies:
  super_interactive_text:
    path: ../packages/super_interactive_text
```

## Basic Usage

```dart
import 'package:super_interactive_text/super_interactive_text.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SuperInteractiveTextPreview(
      text: '''
        Visit our website at https://example.com
        Or email us at support@example.com
        Call us at +966599999999
        Follow @official_account
        #flutter #development
      ''',
    );
  }
}
```

## Customization

```dart
SuperInteractiveTextPreview(
  text: 'Text containing various data...',
  linkTextStyle: TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline,
  ),
  emailTextStyle: TextStyle(
    color: Colors.orange,
    fontStyle: FontStyle.italic,
  ),
  onLinkTap: (linkData) => print('Link tapped: ${linkData.text}'),
  onEmailTap: (emailData) => print('Email tapped: ${emailData.text}'),
)
```

## Builder Pattern

```dart
SuperInteractiveTextPreview.builder(
  text: 'Text with full customization...',
  linkBuilder: (linkData) => Container(
    padding: EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: Colors.blue[100],
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text('🔗 ${linkData.text}'),
  ),
)
```

## Flexible Routing System

The library allows defining a custom routing system for your application, enabling the recognition of internal links and executing custom actions when tapped (e.g., navigating to a specific screen within the app).

### 1. Configuration

The parser must be configured before use, preferably in the `main` function:

```dart
void main() {
  SuperInteractiveTextDataParser.configure(
    RouteConfig(
      // Base addresses to be considered as internal links
      baseAddresses: ['https://myapp.com', 'myapp://'],
      routes: [
        // Define routes here
      ],
    ),
  );
  
  runApp(MyApp());
}
```

### 2. Route Definitions

Each route is defined using `RouteDefinition`. Here are some common examples:

#### A. Static Route
A route with no parameters.
Example: `https://myapp.com/settings`

```dart
RouteDefinition(
  name: 'settings',
  pattern: r'settings$', // Regex pattern
  parameterNames: {}, // No parameters
  onNavigate: (context, data) {
    Navigator.pushNamed(context, '/settings');
  },
)
```

#### B. Single Parameter Route
A route containing an ID or parameter.
Example: `https://myapp.com/users/123`

```dart
RouteDefinition(
  name: 'user-profile',
  pattern: r'users/([^/]+)', // ([^/]+) captures any text until the next slash
  parameterNames: {'userId': true}, // Define parameter name and requirement
  onNavigate: (context, data) {
    // Access the parameter via data.pathParameters
    final userId = data.pathParameters['userId'];
    Navigator.pushNamed(context, '/users', arguments: userId);
  },
)
```

#### C. Multi-Parameter Route
A route containing multiple parameters.
Example: `https://myapp.com/shop/10/item/55`

```dart
RouteDefinition(
  name: 'shop-item',
  pattern: r'shop/([^/]+)/item/([^/]+)', // Capture two parameters
  parameterNames: {
    'shopId': true,
    'itemId': true,
  },
  onNavigate: (context, data) {
    final shopId = data.pathParameters['shopId'];
    final itemId = data.pathParameters['itemId'];
    Navigator.pushNamed(
      context, 
      '/shop/item', 
      arguments: {'shop': shopId, 'item': itemId},
    );
  },
)
```

### 3. How to Write Patterns

We use Regular Expressions (Regex) to define the route pattern:
- `^` and `$` are added automatically, so there is no need to write them at the start and end of the full pattern, but it is preferred to use `$` for the end of the route if you want an exact match.
- `([^/]+)` is the most commonly used pattern to capture a parameter value (meaning: any string of characters not containing `/`).
- `\d+` can be used if you want to capture numbers only.

Examples:
- `r'contact-us$'` matches `.../contact-us`
- `r'docs/([^/]+)/([^/]+)'` matches `.../docs/section/page`

For more information on writing patterns, refer to [Dart RegExp documentation](https://api.dart.dev/stable/dart-core/RegExp-class.html).

## API

### TextData Classes

- **NormalTextData**: Regular text with no special formatting.
- **LinkTextData**: URLs (HTTP/HTTPS).
- **EmailTextData**: Email addresses.
- **PhoneNumberTextData**: Phone numbers.
- **UsernameTextData**: Usernames (@username).
- **SocialMediaTextData**: Social media links.
- **HashtagTextData**: Hashtags (#hashtag).
- **RouteTextData**: Internal app routes.

### SuperInteractiveTextPreview Properties

| Property | Type | Description |
|---------|-------|-------|
| `text` | `String?` | The text to process. |
| `parsedText` | `List<TextData>?` | Pre-processed text data. |
| `textPreviewTheme` | `TextPreviewTheme?` | Appearance customization. |
| `onLinkTap` | `Function(LinkTextData)?` | Callback for link tap. |
| `onEmailTap` | `Function(EmailTextData)?` | Callback for email tap. |
| `onPhoneTap` | `Function(PhoneNumberTextData)?` | Callback for phone number tap. |
| `onUsernameTap` | `Function(UsernameTextData)?` | Callback for username tap. |
| `onHashtagTap` | `Function(HashtagTextData)?` | Callback for hashtag tap. |
| `onRouteTap` | `Function(RouteTextData)?` | Callback for internal route tap. |
