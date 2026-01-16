# Super Interactive Text

A powerful Flutter package for parsing, displaying, and editing text with interactive elements.

[![pub package](https://img.shields.io/pub/v/super_interactive_text.svg)](https://pub.dev/packages/super_interactive_text)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

[Live Demo](https://geniussystems24.github.io/super_interactive_text/)

## Features

### Preview (Display)
- **Link Detection**: HTTP/HTTPS URLs with query parameters
- **Email Detection**: All valid email formats
- **Phone Detection**: Local and international numbers with validation
- **Mention Detection**: Usernames starting with @
- **Hashtag Detection**: Tags starting with #
- **Social Media Detection**: Instagram, Twitter, Facebook, YouTube, LinkedIn, TikTok, WhatsApp, Telegram
- **Internal Routes**: Custom app route patterns with parameter extraction
- **Text Highlighting**: Highlight matching text with customizable background color
- **Serialization**: Convert to/from Map for storage

### Editor (New in v2.0)
- **Rich Text Editing**: Full-featured editor built on `super_editor`
- **Auto-Detection**: Automatic detection while typing
- **Formatting Toolbar**: Bold, italic, underline, and interactive elements
- **Insert Dialogs**: Easy insertion of links, mentions, hashtags, emails, phones
- **Controller API**: Programmatic control over the editor
- **Export Options**: Plain text and JSON export

## Installation

```yaml
dependencies:
  super_interactive_text: ^2.0.0
```

## Quick Start

### Preview Widget

Display text with automatically detected interactive elements:

```dart
import 'package:super_interactive_text/super_interactive_text.dart';

SuperInteractiveTextPreview(
  text: '''
    Visit https://flutter.dev
    Email: contact@example.com
    Call: +966500000000
    Follow @flutter_dev #Flutter
  ''',
  onLinkTap: (link) => launchUrl(Uri.parse(link.text)),
  onEmailTap: (email) => launchUrl(Uri.parse('mailto:${email.text}')),
  onMentionTap: (mention) => print('User: ${mention.userId}'),
)
```

### Editor Widget

Full-featured rich text editor with interactive element support:

```dart
import 'package:super_interactive_text/super_interactive_text.dart';

SuperInteractiveTextEditor(
  initialText: 'Hello @world! Check out #Flutter',
  autoDetect: true,
  showToolbar: true,
  onChanged: (text) => print('Text changed: $text'),
  onLinkTap: (url) => launchUrl(Uri.parse(url)),
  onMentionTap: (username) => navigateToUser(username),
)
```

## Preview Widget

### Basic Usage

```dart
SuperInteractiveTextPreview(
  text: 'Visit https://example.com or email support@example.com',
)
```

### Custom Styling

```dart
SuperInteractiveTextPreview(
  text: 'Your text here...',
  linkTextStyle: TextStyle(
    color: Colors.purple,
    decoration: TextDecoration.underline,
  ),
  emailTextStyle: TextStyle(color: Colors.orange),
  mentionTextStyle: TextStyle(
    color: Colors.blue,
    fontWeight: FontWeight.bold,
  ),
)
```

### Builder Pattern

For complete customization of how each element is rendered:

```dart
SuperInteractiveTextPreview.builder(
  text: 'Check @flutter and https://flutter.dev',
  linkBuilder: (link) => Container(
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.blue.shade100,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.link, size: 14),
        SizedBox(width: 4),
        Text(Uri.parse(link.text).host),
      ],
    ),
  ),
  usernameBuilder: (mention) => Chip(
    avatar: Icon(Icons.person, size: 16),
    label: Text(mention.text),
  ),
)
```

### Theme Support

```dart
SuperInteractiveTextPreview(
  text: 'Your text...',
  textPreviewTheme: SuperInteractiveTextPreviewTheme(
    linkColor: Color(0xFF6750A4),
    emailColor: Color(0xFF0091EA),
    phoneColor: Color(0xFF00C853),
    mentionColor: Color(0xFF2196F3),
    hashtagColor: Color(0xFF9C27B0),
  ),
)

// Or use presets
SuperInteractiveTextPreviewTheme.light()
SuperInteractiveTextPreviewTheme.dark()
```

### Text Highlighting

Highlight specific text within the content (useful for search results):

```dart
SuperInteractiveTextPreview(
  text: 'Search results for flutter development tutorials',
  highlightText: 'flutter',
  highlightColor: Colors.yellow,
  highlightTextColor: Colors.black,
)
```

With custom style:

```dart
SuperInteractiveTextPreview(
  text: 'Find all matches in this text',
  highlightText: 'match',
  highlightTextStyle: TextStyle(
    backgroundColor: Color(0xFF1B5E20),
    color: Colors.white,
    fontWeight: FontWeight.bold,
  ),
  caseSensitiveHighlight: false, // Case-insensitive (default)
)
```

| Property | Type | Description |
|----------|------|-------------|
| `highlightText` | `String?` | Text to highlight |
| `highlightColor` | `Color?` | Background color for highlights |
| `highlightTextColor` | `Color?` | Text color for highlights |
| `highlightTextStyle` | `TextStyle?` | Full style for highlighted text |
| `caseSensitiveHighlight` | `bool` | Case-sensitive matching (default: false) |

## Editor Widget

### Basic Editor

```dart
SuperInteractiveTextEditor(
  initialText: 'Start typing...',
  autoDetect: true,
  showToolbar: true,
)
```

### With Controller

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late final InteractiveEditorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = InteractiveEditorController(
      initialText: 'Hello World!',
      autoDetect: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SuperInteractiveTextEditor(
          controller: _controller,
          showToolbar: true,
        ),
        ElevatedButton(
          onPressed: () {
            // Insert a mention programmatically
            _controller.insertMention('flutter_dev');
          },
          child: Text('Add Mention'),
        ),
        ElevatedButton(
          onPressed: () {
            // Get the text content
            print(_controller.text);

            // Export as JSON
            print(_controller.exportAsJson());
          },
          child: Text('Export'),
        ),
      ],
    );
  }
}
```

### Controller API

```dart
final controller = InteractiveEditorController();

// Insert interactive elements
controller.insertLink('https://flutter.dev', displayText: 'Flutter');
controller.insertMention('username');
controller.insertHashtag('flutter');
controller.insertEmail('user@example.com');
controller.insertPhone('+966500000000');

// Formatting
controller.toggleBold();
controller.toggleItalic();
controller.toggleUnderline();

// Get content
String plainText = controller.text;
Map<String, dynamic> json = controller.exportAsJson();

// Set content
controller.setText('New content');
controller.clear();
```

### Custom Toolbar

```dart
SuperInteractiveTextEditor(
  controller: controller,
  showToolbar: true,
  toolbarPosition: ToolbarPosition.bottom, // or ToolbarPosition.top
)
```

### Editor with Suggestions

```dart
SuperInteractiveTextEditor(
  initialText: '',
  mentionSuggestions: ['flutter', 'dart', 'google'],
  hashtagSuggestions: ['flutter', 'mobile', 'development'],
)
```

## Internal Routing

Configure custom routes for your application:

### Configuration

```dart
void main() {
  SuperInteractiveTextDataParser.configure(
    RouteConfig(
      baseAddresses: ['https://myapp.com', 'myapp://'],
      routes: [
        RouteDefinition(
          name: 'user-profile',
          pattern: r'users/([^/]+)',
          parameterNames: {'userId': true},
          onNavigate: (context, data) {
            Navigator.pushNamed(
              context,
              '/user/${data.pathParameters['userId']}',
            );
          },
        ),
        RouteDefinition(
          name: 'settings',
          pattern: r'settings$',
          parameterNames: {},
          onNavigate: (context, data) {
            Navigator.pushNamed(context, '/settings');
          },
        ),
      ],
    ),
  );

  runApp(MyApp());
}
```

### Route Patterns

| Pattern | Matches | Parameters |
|---------|---------|------------|
| `r'settings$'` | `/settings` | None |
| `r'users/([^/]+)'` | `/users/123` | `userId: '123'` |
| `r'posts/([^/]+)/comments/([^/]+)'` | `/posts/1/comments/5` | `postId: '1', commentId: '5'` |

## API Reference

### Data Classes

| Class | Description |
|-------|-------------|
| `NormalTextData` | Regular text |
| `LinkTextData` | HTTP/HTTPS URLs |
| `EmailTextData` | Email addresses |
| `PhoneNumberTextData` | Phone numbers |
| `UsernameTextData` | @mentions |
| `HashtagTextData` | #hashtags |
| `SocialMediaTextData` | Social media links |
| `RouteTextData` | Internal app routes |

### Preview Properties

| Property | Type | Description |
|----------|------|-------------|
| `text` | `String?` | Text to parse |
| `parsedText` | `List<SuperInteractiveTextData>?` | Pre-parsed data |
| `textPreviewTheme` | `SuperInteractiveTextPreviewTheme?` | Theme configuration |
| `onLinkTap` | `Function(LinkTextData)?` | Link tap callback |
| `onEmailTap` | `Function(EmailTextData)?` | Email tap callback |
| `onPhoneTap` | `Function(PhoneNumberTextData)?` | Phone tap callback |
| `onUsernameTap` | `Function(UsernameTextData)?` | Mention tap callback |
| `onHashtagTap` | `Function(HashtagTextData)?` | Hashtag tap callback |
| `onRouteTap` | `Function(RouteTextData)?` | Route tap callback |
| `highlightText` | `String?` | Text to highlight |
| `highlightColor` | `Color?` | Highlight background color |
| `highlightTextColor` | `Color?` | Highlight text color |
| `highlightTextStyle` | `TextStyle?` | Full highlight style |
| `caseSensitiveHighlight` | `bool` | Case-sensitive matching (default: false) |

### Editor Properties

| Property | Type | Description |
|----------|------|-------------|
| `controller` | `InteractiveEditorController?` | Editor controller |
| `initialText` | `String?` | Initial text content |
| `autoDetect` | `bool` | Auto-detect elements (default: true) |
| `showToolbar` | `bool` | Show formatting toolbar (default: true) |
| `toolbarPosition` | `ToolbarPosition` | Toolbar position |
| `readOnly` | `bool` | Read-only mode |
| `onChanged` | `ValueChanged<String>?` | Text change callback |
| `mentionSuggestions` | `List<String>?` | Mention suggestions |
| `hashtagSuggestions` | `List<String>?` | Hashtag suggestions |

## Migration from v1.x

The preview functionality remains unchanged. Simply update your dependency version:

```yaml
# Before
super_interactive_text: ^1.1.0

# After
super_interactive_text: ^2.0.0
```

To use the new editor, import and use `SuperInteractiveTextEditor`:

```dart
// v1.x - Preview only
SuperInteractiveTextPreview(text: 'Hello @world')

// v2.0 - Editor (new)
SuperInteractiveTextEditor(
  initialText: 'Hello @world',
  autoDetect: true,
)
```

## Examples

See the [example](example/) directory for complete examples:

- Basic preview usage
- Custom styling
- Builder pattern
- Text highlighting
- Editor with toolbar
- Controller usage
- Internal routing

## Contributing

Contributions are welcome! Please read our [contributing guidelines](CONTRIBUTING.md) before submitting a pull request.

## License

MIT License - see the [LICENSE](LICENSE) file for details.
