# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
