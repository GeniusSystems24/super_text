# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.1.0] - 2026-01-16

### Added
- **Text Highlighting**: New `highlightText` feature in `SuperInteractiveTextPreview`
  - `highlightText` parameter to specify text to highlight
  - `highlightColor` for background color customization
  - `highlightTextColor` for text color customization
  - `highlightTextStyle` for full style control
  - `caseSensitiveHighlight` option for case-sensitive matching
- **Theme Support**: Added highlight properties to `SuperInteractiveTextPreviewTheme`
  - `highlightColor` - default highlight background color
  - `highlightTextColor` - default highlight text color
  - `highlightTextStyle` - default highlight text style
  - Light theme default: Yellow background (#FFEB3B) with black text
  - Dark theme default: Dark green background (#1B5E20) with white text

### Example
```dart
SuperInteractiveTextPreview(
  text: 'Search results for flutter development',
  highlightText: 'flutter',
  highlightColor: Colors.yellow,
)
```

## [2.0.0] - 2026-01-05

### Added
- **Rich Text Editor**: New `SuperInteractiveTextEditor` widget built on top of `super_editor`
- **Interactive Editor Controller**: `InteractiveEditorController` for programmatic control
- **Auto-Detection**: Automatic detection of interactive elements while typing
- **Formatting Toolbar**: Built-in toolbar with bold, italic, underline, and interactive element buttons
- **Insert Dialogs**: Easy-to-use dialogs for inserting links, mentions, hashtags, emails, and phone numbers
- **Custom Attributions**: New attribution system for interactive elements:
  - `InteractiveLinkAttribution`
  - `InteractiveEmailAttribution`
  - `InteractivePhoneAttribution`
  - `InteractiveMentionAttribution`
  - `InteractiveHashtagAttribution`
  - `InteractiveSocialMediaAttribution`
  - `InteractiveRouteAttribution`
- **Interactive Text Detector**: `InteractiveTextDetector` class for standalone detection
- **Stylesheet Support**: `createInteractiveStylesheet()` for custom styling
- **Export Functions**: Export as plain text or JSON with attribution data
- **Suggestions Support**: Mention and hashtag suggestions in insert dialogs

### Changed
- **Dependency**: Added `super_editor: ^0.3.0-dev.47` as a dependency
- **Library Structure**: Reorganized into preview and editor modules
- **Version Bump**: Major version bump due to new editor functionality

### Migration Guide
The preview functionality remains unchanged. To use the new editor:
```dart
// New editor widget
SuperInteractiveTextEditor(
  initialText: 'Hello @world!',
  autoDetect: true,
  showToolbar: true,
  onChanged: (text) => print(text),
)
```

## [1.1.0] - 2026-01-04

### Added
- **Flexible Routing System**: Introduced `RouteConfig` and `RouteDefinition` to allow fully customizable internal route parsing.
- `SuperInteractiveTextDataParser.configure(RouteConfig)`: Method to initialize the parser with custom route patterns.
- `onNavigate` parameter in `RouteDefinition`: Callback to handle navigation logic (e.g., `Navigator.pushNamed`) when a route is tapped.
- `RouteTextData.navigate(BuildContext)`: Method to trigger the navigation callback.
- `RouteTextData.routeDefinition`: Reference to the matched route definition.

### Changed
- **Breaking Change**: Removed the hardcoded `RouteType` enum and `RouteTextData.routeType`.
- **Breaking Change**: `RouteTextData` constructor now requires `RouteDefinition` instead of `RouteType`.
- `SuperInteractiveTextPreview` widget now passes `BuildContext` to `_handleRouteTap` to support `onNavigate`.
- `RouteTextData` serializes/deserializes using the configured `RouteConfig` to look up route definitions by name.

### Removed
- Static hardcoded route patterns in `SuperInteractiveTextDataParser`.

## [1.0.0] - 2026-01-04

### Added
- Initial release of the super_interactive_text package
- `SuperInteractiveTextPreview` for displaying text with interactive elements
- `SuperInteractiveTextPreview.builder` for custom widget building
- `TextData` class hierarchy for different text types:
  - `NormalTextData` - Regular text
  - `LinkTextData` - HTTP/HTTPS URLs
  - `EmailTextData` - Email addresses
  - `PhoneNumberTextData` - Phone numbers
  - `UsernameTextData` - @usernames
  - `HashtagTextData` - #hashtags
  - `SocialMediaTextData` - Social media links (Instagram, Twitter, Facebook, YouTube, etc.)
  - `RouteTextData` - Internal app routes
- `TextPreviewTheme` for customizing appearance
- Light and dark theme support
- Phone number validation and formatting (with Saudi number support)
- Social media platform detection
- Internal route parsing with path parameters
- Caching support for parsed text
- Serialization support (toMap/fromMap)
