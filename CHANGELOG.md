# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-01-04

### Added
- **Flexible Routing System**: Introduced `RouteConfig` and `RouteDefinition` to allow fully customizable internal route parsing.
- `SuperTextDataParser.configure(RouteConfig)`: Method to initialize the parser with custom route patterns.
- `onNavigate` parameter in `RouteDefinition`: Callback to handle navigation logic (e.g., `Navigator.pushNamed`) when a route is tapped.
- `RouteTextData.navigate(BuildContext)`: Method to trigger the navigation callback.
- `RouteTextData.routeDefinition`: Reference to the matched route definition.

### Changed
- **Breaking Change**: Removed the hardcoded `RouteType` enum and `RouteTextData.routeType`.
- **Breaking Change**: `RouteTextData` constructor now requires `RouteDefinition` instead of `RouteType`.
- `SuperTextPreview` widget now passes `BuildContext` to `_handleRouteTap` to support `onNavigate`.
- `RouteTextData` serializes/deserializes using the configured `RouteConfig` to look up route definitions by name.

### Removed
- Static hardcoded route patterns in `SuperTextDataParser`.

## [1.0.0] - 2026-01-04

### Added
- Initial release of the super_text package
- `SuperTextPreview` for displaying text with interactive elements
- `SuperTextPreview.builder` for custom widget building
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
