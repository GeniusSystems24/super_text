part of '../super_interactive_text_preview_library.dart';

/// Widget that displays text with clickable links, emails, phone numbers, and usernames
class SuperInteractiveTextPreview extends StatelessWidget {
  final String? text;
  final List<SuperInteractiveTextData>? parsedText;
  final TextStyle? normalTextStyle;
  final TextStyle? linkTextStyle;
  final TextStyle? emailTextStyle;
  final TextStyle? phoneTextStyle;
  final TextStyle? usernameTextStyle;
  final TextStyle? socialMediaTextStyle;
  final TextStyle? hashtagTextStyle;
  final TextStyle? routeTextStyle;

  // Highlight properties
  final String? highlightText;
  final Color? highlightColor;
  final Color? highlightTextColor;
  final TextStyle? highlightTextStyle;
  final bool caseSensitiveHighlight;

  final void Function(LinkTextData linkTextData)? onLinkTap;
  final void Function(EmailTextData emailTextData)? onEmailTap;
  final void Function(PhoneNumberTextData phoneNumberTextData)? onPhoneTap;
  final void Function(UsernameTextData usernameTextData)? onUsernameTap;
  final void Function(SocialMediaTextData socialMediaTextData)?
      onSocialMediaTap;
  final void Function(HashtagTextData hashtagTextData)? onHashtagTap;
  final void Function(RouteTextData routeTextData)? onRouteTap;
  final int? maxLines;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final SuperInteractiveTextPreviewTheme? textPreviewTheme;

  // Builder functions
  final Widget? Function(NormalTextData normalTextData)? textBuilder;
  final Widget? Function(LinkTextData linkTextData)? linkBuilder;
  final Widget? Function(EmailTextData emailTextData)? emailBuilder;
  final Widget? Function(PhoneNumberTextData phoneNumberTextData)? phoneBuilder;
  final Widget? Function(UsernameTextData usernameTextData)? usernameBuilder;
  final Widget? Function(SocialMediaTextData socialMediaTextData)?
      socialMediaBuilder;
  final Widget? Function(HashtagTextData hashtagTextData)? hashtagBuilder;
  final Widget? Function(RouteTextData routeTextData)? routeBuilder;

  const SuperInteractiveTextPreview({
    super.key,
    this.text,
    this.parsedText,
    this.normalTextStyle,
    this.linkTextStyle,
    this.emailTextStyle,
    this.phoneTextStyle,
    this.usernameTextStyle,
    this.socialMediaTextStyle,
    this.hashtagTextStyle,
    this.routeTextStyle,
    this.highlightText,
    this.highlightColor,
    this.highlightTextColor,
    this.highlightTextStyle,
    this.caseSensitiveHighlight = false,
    this.onLinkTap,
    this.onEmailTap,
    this.onPhoneTap,
    this.onUsernameTap,
    this.onSocialMediaTap,
    this.onHashtagTap,
    this.onRouteTap,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.textPreviewTheme,
  })  : assert(
          text != null || parsedText != null,
          'Either text or parsedText must be provided',
        ),
        textBuilder = null,
        linkBuilder = null,
        emailBuilder = null,
        phoneBuilder = null,
        usernameBuilder = null,
        socialMediaBuilder = null,
        hashtagBuilder = null,
        routeBuilder = null;

  /// Builder constructor for custom widget building
  const SuperInteractiveTextPreview.builder({
    super.key,
    this.text,
    this.parsedText,
    this.onLinkTap,
    this.onEmailTap,
    this.onPhoneTap,
    this.onUsernameTap,
    this.onSocialMediaTap,
    this.onRouteTap,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.textBuilder,
    this.linkBuilder,
    this.emailBuilder,
    this.phoneBuilder,
    this.usernameBuilder,
    this.socialMediaBuilder,
    this.hashtagBuilder,
    this.routeBuilder,
    this.onHashtagTap,
    this.normalTextStyle,
    this.linkTextStyle,
    this.emailTextStyle,
    this.phoneTextStyle,
    this.usernameTextStyle,
    this.socialMediaTextStyle,
    this.hashtagTextStyle,
    this.routeTextStyle,
    this.highlightText,
    this.highlightColor,
    this.highlightTextColor,
    this.highlightTextStyle,
    this.caseSensitiveHighlight = false,
    this.textPreviewTheme,
  }) : assert(
          text != null || parsedText != null,
          'Either text or parsedText must be provided',
        );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textPreviewTheme =
        this.textPreviewTheme ?? SuperInteractiveTextPreviewTheme.get(context);
    final defaultTextStyle = DefaultTextStyle.of(context).style;

    // Use provided parsed text or parse the raw text
    final List<SuperInteractiveTextData> parsedData = parsedText ??
        (text != null
            ? SuperInteractiveTextData.parse(text!, save: true)
            : <SuperInteractiveTextData>[]);

    if (parsedData.isEmpty) {
      final displayText = text ?? '';
      return Text(
        displayText,
        style: normalTextStyle ??
            textPreviewTheme.normalTextStyle ??
            defaultTextStyle,
        maxLines: maxLines ?? textPreviewTheme.maxLines,
        overflow: overflow ?? textPreviewTheme.overflow,
        textAlign: textAlign ?? textPreviewTheme.textAlign,
      );
    }

    // Use builder pattern if builders are provided
    if (_hasCustomBuilders()) {
      return _buildWithCustomBuilders(parsedData, textPreviewTheme);
    }

    return RichText(
      maxLines: maxLines ?? textPreviewTheme.maxLines,
      overflow: overflow ?? textPreviewTheme.overflow ?? TextOverflow.clip,
      textAlign: textAlign ?? textPreviewTheme.textAlign ?? TextAlign.start,
      text: TextSpan(
        children: parsedData
            .map(
              (data) => _buildTextSpan(
                data,
                context,
                theme,
                defaultTextStyle,
                textPreviewTheme,
              ),
            )
            .toList(),
      ),
    );
  }

  /// Check if any custom builders are provided
  bool _hasCustomBuilders() {
    return textBuilder != null ||
        linkBuilder != null ||
        emailBuilder != null ||
        phoneBuilder != null ||
        usernameBuilder != null ||
        socialMediaBuilder != null ||
        hashtagBuilder != null ||
        routeBuilder != null;
  }

  /// Build widget using custom builders
  Widget _buildWithCustomBuilders(
    List<SuperInteractiveTextData> parsedData,
    SuperInteractiveTextPreviewTheme textPreviewTheme,
  ) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final defaultTextStyle = DefaultTextStyle.of(context).style;

        return RichText(
          maxLines: maxLines ?? textPreviewTheme.maxLines,
          overflow: overflow ?? textPreviewTheme.overflow ?? TextOverflow.clip,
          textAlign: textAlign ?? textPreviewTheme.textAlign ?? TextAlign.start,
          text: TextSpan(
            children: parsedData.map((data) {
              Widget? customWidget = _buildCustomWidget(
                data,
                context,
                theme,
                textPreviewTheme,
                defaultTextStyle,
              );
              if (customWidget != null && data.runtimeType != NormalTextData) {
                return WidgetSpan(
                  child: customWidget,
                  alignment: PlaceholderAlignment.baseline,
                  baseline: TextBaseline.alphabetic,
                );
              } else {
                return _buildTextSpan(
                  data,
                  context,
                  theme,
                  defaultTextStyle,
                  textPreviewTheme,
                );
              }
            }).toList(),
          ),
        );
      },
    );
  }

  /// Build custom widget for each data type
  Widget? _buildCustomWidget(
    SuperInteractiveTextData data,
    BuildContext context,
    ThemeData theme,
    SuperInteractiveTextPreviewTheme textPreviewTheme,
    TextStyle defaultStyle,
  ) {
    switch (data.runtimeType) {
      case NormalTextData:
        Widget? widget = textBuilder?.call(data as NormalTextData);
        if (widget != null) {
          return DefaultTextStyle(
            style: normalTextStyle ??
                textPreviewTheme.normalTextStyle ??
                defaultStyle,
            child: widget,
          );
        }

        return widget;
      case LinkTextData:
        Widget? widget = linkBuilder?.call(data as LinkTextData);
        if (widget != null) {
          return DefaultTextStyle(
            style: linkTextStyle ??
                textPreviewTheme.linkTextStyle ??
                defaultStyle.copyWith(
                  color: textPreviewTheme.linkColor ?? theme.primaryColor,
                  decoration: TextDecoration.underline,
                  decorationColor:
                      textPreviewTheme.linkColor ?? theme.primaryColor,
                ),
            child: onLinkTap != null
                ? GestureDetector(
                    onTap: () => _handleLinkTap(data as LinkTextData),
                    child: widget,
                  )
                : widget,
          );
        }

        return widget;
      case EmailTextData:
        Widget? widget = emailBuilder?.call(data as EmailTextData);
        if (widget != null) {
          return DefaultTextStyle(
            style: emailTextStyle ??
                textPreviewTheme.emailTextStyle ??
                defaultStyle.copyWith(
                  color: textPreviewTheme.emailColor ??
                      theme.colorScheme.secondary,
                  decoration: TextDecoration.underline,
                  decorationColor: textPreviewTheme.emailColor ??
                      theme.colorScheme.secondary,
                ),
            child: onEmailTap != null
                ? GestureDetector(
                    onTap: () => _handleEmailTap(data as EmailTextData),
                    child: widget,
                  )
                : widget,
          );
        }

        return widget;
      case PhoneNumberTextData:
        Widget? widget = phoneBuilder?.call(data as PhoneNumberTextData);
        if (widget != null) {
          return DefaultTextStyle(
            style: phoneTextStyle ??
                textPreviewTheme.phoneTextStyle ??
                defaultStyle.copyWith(
                  color: textPreviewTheme.phoneColor ?? Colors.green,
                  decoration: TextDecoration.underline,
                  decorationColor: textPreviewTheme.phoneColor ?? Colors.green,
                ),
            child: onPhoneTap != null
                ? GestureDetector(
                    onTap: () => _handlePhoneTap(data as PhoneNumberTextData),
                    child: widget,
                  )
                : widget,
          );
        }

        return widget;
      case UsernameTextData:
        Widget? widget = usernameBuilder?.call(data as UsernameTextData);
        if (widget != null) {
          return DefaultTextStyle(
            style: usernameTextStyle ??
                textPreviewTheme.usernameTextStyle ??
                defaultStyle.copyWith(
                  color: textPreviewTheme.usernameColor ?? Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
            child: onUsernameTap != null
                ? GestureDetector(
                    onTap: () => _handleUsernameTap(data as UsernameTextData),
                    child: widget,
                  )
                : widget,
          );
        }

        return widget;
      case SocialMediaTextData:
        Widget? widget = socialMediaBuilder?.call(data as SocialMediaTextData);
        if (widget != null) {
          return DefaultTextStyle(
            style: socialMediaTextStyle ??
                textPreviewTheme.socialMediaTextStyle ??
                defaultStyle.copyWith(
                  color: textPreviewTheme.primaryColor ??
                      _getSocialMediaColor((data as SocialMediaTextData).type),
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
            child: onSocialMediaTap != null
                ? GestureDetector(
                    onTap: () =>
                        _handleSocialMediaTap(data as SocialMediaTextData),
                    child: widget,
                  )
                : widget,
          );
        }

        return widget;
      case HashtagTextData:
        Widget? widget = hashtagBuilder?.call(data as HashtagTextData);
        if (widget != null) {
          return DefaultTextStyle(
            style: hashtagTextStyle ??
                textPreviewTheme.hashtagTextStyle ??
                defaultStyle.copyWith(
                  color: textPreviewTheme.hashtagColor ?? Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
            child: onHashtagTap != null
                ? GestureDetector(
                    onTap: () => _handleHashtagTap(data as HashtagTextData),
                    child: widget,
                  )
                : widget,
          );
        }

        return widget;
      case RouteTextData:
        Widget? widget = routeBuilder?.call(data as RouteTextData);
        if (widget != null) {
          return DefaultTextStyle(
            style: routeTextStyle ??
                textPreviewTheme.routeTextStyle ??
                defaultStyle.copyWith(
                  color: textPreviewTheme.routeColor ?? Colors.purple,
                  decoration: TextDecoration.underline,
                ),
            child: onRouteTap != null
                ? GestureDetector(
                    onTap: () =>
                        _handleRouteTap(context, data as RouteTextData),
                    child: widget,
                  )
                : widget,
          );
        }

        return widget;
      default:
        return null;
    }
  }

  /// Build highlighted text spans by splitting text at highlight matches
  List<TextSpan> _buildHighlightedTextSpans({
    required String text,
    required TextStyle baseStyle,
    required SuperInteractiveTextPreviewTheme textPreviewTheme,
    GestureRecognizer? recognizer,
  }) {
    if (highlightText == null || highlightText!.isEmpty) {
      return [
        TextSpan(
          text: text,
          style: baseStyle,
          recognizer: recognizer,
        )
      ];
    }

    final List<TextSpan> spans = [];
    final String searchText =
        caseSensitiveHighlight ? text : text.toLowerCase();
    final String searchPattern =
        caseSensitiveHighlight ? highlightText! : highlightText!.toLowerCase();

    int start = 0;
    int index = searchText.indexOf(searchPattern, start);

    // Get highlight style
    final effectiveHighlightStyle = highlightTextStyle ??
        textPreviewTheme.highlightTextStyle ??
        baseStyle.copyWith(
          backgroundColor:
              highlightColor ?? textPreviewTheme.highlightColor ?? Colors.yellow,
          color: highlightTextColor ??
              textPreviewTheme.highlightTextColor ??
              baseStyle.color,
        );

    while (index != -1) {
      // Add text before the match
      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
          style: baseStyle,
          recognizer: recognizer,
        ));
      }

      // Add the highlighted match
      spans.add(TextSpan(
        text: text.substring(index, index + highlightText!.length),
        style: effectiveHighlightStyle,
        recognizer: recognizer,
      ));

      start = index + highlightText!.length;
      index = searchText.indexOf(searchPattern, start);
    }

    // Add remaining text after last match
    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: baseStyle,
        recognizer: recognizer,
      ));
    }

    return spans.isEmpty
        ? [TextSpan(text: text, style: baseStyle, recognizer: recognizer)]
        : spans;
  }

  /// Build TextSpan for each data type
  TextSpan _buildTextSpan(
    SuperInteractiveTextData data,
    BuildContext context,
    ThemeData theme,
    TextStyle defaultStyle,
    SuperInteractiveTextPreviewTheme textPreviewTheme,
  ) {
    switch (data.runtimeType) {
      case NormalTextData:
        final style = normalTextStyle ??
            textPreviewTheme.normalTextStyle ??
            defaultStyle;
        return TextSpan(
          children: _buildHighlightedTextSpans(
            text: data.text,
            baseStyle: style,
            textPreviewTheme: textPreviewTheme,
          ),
        );

      case LinkTextData:
        final style = linkTextStyle ??
            textPreviewTheme.linkTextStyle ??
            defaultStyle.copyWith(
              color: textPreviewTheme.linkColor ?? theme.primaryColor,
              decoration: TextDecoration.underline,
              decorationColor:
                  textPreviewTheme.linkColor ?? theme.primaryColor,
            );
        return TextSpan(
          children: _buildHighlightedTextSpans(
            text: data.text,
            baseStyle: style,
            textPreviewTheme: textPreviewTheme,
            recognizer: TapGestureRecognizer()
              ..onTap = () => _handleLinkTap(data as LinkTextData),
          ),
        );

      case EmailTextData:
        final style = emailTextStyle ??
            textPreviewTheme.emailTextStyle ??
            defaultStyle.copyWith(
              color:
                  textPreviewTheme.emailColor ?? theme.colorScheme.secondary,
              decoration: TextDecoration.underline,
              decorationColor:
                  textPreviewTheme.emailColor ?? theme.colorScheme.secondary,
            );
        return TextSpan(
          children: _buildHighlightedTextSpans(
            text: data.text,
            baseStyle: style,
            textPreviewTheme: textPreviewTheme,
            recognizer: TapGestureRecognizer()
              ..onTap = () => _handleEmailTap(data as EmailTextData),
          ),
        );

      case PhoneNumberTextData:
        final style = phoneTextStyle ??
            textPreviewTheme.phoneTextStyle ??
            defaultStyle.copyWith(
              color: textPreviewTheme.phoneColor ?? Colors.green,
              decoration: TextDecoration.underline,
              decorationColor: textPreviewTheme.phoneColor ?? Colors.green,
            );
        return TextSpan(
          children: _buildHighlightedTextSpans(
            text: data.text,
            baseStyle: style,
            textPreviewTheme: textPreviewTheme,
            recognizer: TapGestureRecognizer()
              ..onTap = () => _handlePhoneTap(data as PhoneNumberTextData),
          ),
        );

      case UsernameTextData:
        final style = usernameTextStyle ??
            textPreviewTheme.usernameTextStyle ??
            defaultStyle.copyWith(
              color: textPreviewTheme.usernameColor ?? Colors.blue,
              fontWeight: FontWeight.bold,
            );
        return TextSpan(
          children: _buildHighlightedTextSpans(
            text: data.text,
            baseStyle: style,
            textPreviewTheme: textPreviewTheme,
            recognizer: TapGestureRecognizer()
              ..onTap = () => _handleUsernameTap(data as UsernameTextData),
          ),
        );

      case SocialMediaTextData:
        final socialData = data as SocialMediaTextData;
        final style = socialMediaTextStyle ??
            textPreviewTheme.socialMediaTextStyle ??
            defaultStyle.copyWith(
              color: textPreviewTheme.primaryColor ??
                  _getSocialMediaColor(socialData.type),
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            );
        return TextSpan(
          children: _buildHighlightedTextSpans(
            text: socialData.text,
            baseStyle: style,
            textPreviewTheme: textPreviewTheme,
            recognizer: TapGestureRecognizer()
              ..onTap = () => _handleSocialMediaTap(socialData),
          ),
        );

      case HashtagTextData:
        final style = hashtagTextStyle ??
            textPreviewTheme.hashtagTextStyle ??
            defaultStyle.copyWith(
              color: textPreviewTheme.hashtagColor ?? Colors.blue,
              fontWeight: FontWeight.bold,
            );
        return TextSpan(
          children: _buildHighlightedTextSpans(
            text: data.text,
            baseStyle: style,
            textPreviewTheme: textPreviewTheme,
            recognizer: TapGestureRecognizer()
              ..onTap = () => _handleHashtagTap(data as HashtagTextData),
          ),
        );

      case RouteTextData:
        final routeData = data as RouteTextData;
        final style = routeTextStyle ??
            textPreviewTheme.routeTextStyle ??
            defaultStyle.copyWith(
              color: textPreviewTheme.routeColor ?? Colors.purple,
              decoration: TextDecoration.underline,
            );
        return TextSpan(
          children: _buildHighlightedTextSpans(
            text: routeData.text,
            baseStyle: style,
            textPreviewTheme: textPreviewTheme,
            recognizer: TapGestureRecognizer()
              ..onTap = () => _handleRouteTap(context, routeData),
          ),
        );

      default:
        final style = normalTextStyle ??
            textPreviewTheme.normalTextStyle ??
            defaultStyle;
        return TextSpan(
          children: _buildHighlightedTextSpans(
            text: data.text,
            baseStyle: style,
            textPreviewTheme: textPreviewTheme,
          ),
        );
    }
  }

  /// Get color for social media type
  Color _getSocialMediaColor(SocialMediaType type) {
    switch (type) {
      case SocialMediaType.instagram:
        return const Color(0xFFE4405F);
      case SocialMediaType.twitter:
        return const Color(0xFF1DA1F2);
      case SocialMediaType.facebook:
        return const Color(0xFF4267B2);
      case SocialMediaType.youtube:
        return const Color(0xFFFF0000);
      case SocialMediaType.linkedin:
        return const Color(0xFF0077B5);
      case SocialMediaType.tiktok:
        return const Color(0xFF000000);
      case SocialMediaType.snapchat:
        return const Color(0xFFFFFC00);
      case SocialMediaType.whatsapp:
        return const Color(0xFF25D366);
      case SocialMediaType.telegram:
        return const Color(0xFF0088CC);
      default:
        return Colors.blue;
    }
  }

  /// Handle link tap
  void _handleLinkTap(LinkTextData linkData) {
    if (onLinkTap != null) {
      onLinkTap!(linkData);
    } else {
      _launchUrl(linkData.text);
    }
  }

  /// Handle email tap
  void _handleEmailTap(EmailTextData emailData) {
    if (onEmailTap != null) {
      onEmailTap!(emailData);
    } else {
      _launchUrl('mailto:${emailData.text}');
    }
  }

  /// Handle phone tap
  void _handlePhoneTap(PhoneNumberTextData phoneData) {
    if (onPhoneTap != null) {
      onPhoneTap!(phoneData);
    } else {
      _launchUrl('tel:${phoneData.text}');
    }
  }

  /// Handle username tap
  void _handleUsernameTap(UsernameTextData usernameData) {
    if (onUsernameTap != null) {
      onUsernameTap!(usernameData);
    } else {
      // Copy username to clipboard as default action
      Clipboard.setData(ClipboardData(text: usernameData.text));
      // You can show a snackbar here if context is available
    }
  }

  /// Handle social media tap
  void _handleSocialMediaTap(SocialMediaTextData socialMedia) {
    if (onSocialMediaTap != null) {
      onSocialMediaTap!(socialMedia);
    } else {
      _launchUrl(socialMedia.url);
    }
  }

  /// Handle hashtag tap
  void _handleHashtagTap(HashtagTextData hashtagData) {
    if (onHashtagTap != null) {
      onHashtagTap!(hashtagData);
    } else {
      // Copy hashtag to clipboard as default action
      Clipboard.setData(ClipboardData(text: hashtagData.text));
      // You can show a snackbar here if context is available
    }
  }

  /// Handle route tap
  void _handleRouteTap(BuildContext context, RouteTextData routeData) {
    if (onRouteTap != null) {
      onRouteTap!(routeData);
    } else if (routeData.routeDefinition.onNavigate != null) {
      routeData.navigate(context);
    } else {
      // Default action: launch the route URL
      _launchUrl(routeData.text);
    }
  }

  /// Launch URL using url_launcher
  Future<void> _launchUrl(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
  }
}
