part of '../super_text_preview_library.dart';

/// Widget that displays text with clickable links, emails, phone numbers, and usernames
class SuperTextPreview extends StatelessWidget {
  final String? text;
  final List<SuperTextData>? parsedText;
  final TextStyle? normalTextStyle;
  final TextStyle? linkTextStyle;
  final TextStyle? emailTextStyle;
  final TextStyle? phoneTextStyle;
  final TextStyle? usernameTextStyle;
  final TextStyle? socialMediaTextStyle;
  final TextStyle? hashtagTextStyle;
  final TextStyle? routeTextStyle;
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
  final SuperTextPreviewTheme? textPreviewTheme;

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

  const SuperTextPreview({
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
  const SuperTextPreview.builder({
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
    this.textPreviewTheme,
  }) : assert(
          text != null || parsedText != null,
          'Either text or parsedText must be provided',
        );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textPreviewTheme =
        this.textPreviewTheme ?? SuperTextPreviewTheme.get(context);
    final defaultTextStyle = DefaultTextStyle.of(context).style;

    // Use provided parsed text or parse the raw text
    final List<SuperTextData> parsedData = parsedText ??
        (text != null ? SuperTextData.parse(text!, save: true) : <SuperTextData>[]);

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
    List<SuperTextData> parsedData,
    SuperTextPreviewTheme textPreviewTheme,
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
    SuperTextData data,
    ThemeData theme,
    SuperTextPreviewTheme textPreviewTheme,
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
                    onTap: () => _handleRouteTap(data as RouteTextData),
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

  /// Build TextSpan for each data type
  TextSpan _buildTextSpan(
    SuperTextData data,
    ThemeData theme,
    TextStyle defaultStyle,
    SuperTextPreviewTheme textPreviewTheme,
  ) {
    switch (data.runtimeType) {
      case NormalTextData:
        return TextSpan(
          text: data.text,
          style: normalTextStyle ??
              textPreviewTheme.normalTextStyle ??
              defaultStyle,
        );

      case LinkTextData:
        return TextSpan(
          text: data.text,
          style: linkTextStyle ??
              textPreviewTheme.linkTextStyle ??
              defaultStyle.copyWith(
                color: textPreviewTheme.linkColor ?? theme.primaryColor,
                decoration: TextDecoration.underline,
                decorationColor:
                    textPreviewTheme.linkColor ?? theme.primaryColor,
              ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => _handleLinkTap(data as LinkTextData),
        );

      case EmailTextData:
        return TextSpan(
          text: data.text,
          style: emailTextStyle ??
              textPreviewTheme.emailTextStyle ??
              defaultStyle.copyWith(
                color:
                    textPreviewTheme.emailColor ?? theme.colorScheme.secondary,
                decoration: TextDecoration.underline,
                decorationColor:
                    textPreviewTheme.emailColor ?? theme.colorScheme.secondary,
              ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => _handleEmailTap(data as EmailTextData),
        );

      case PhoneNumberTextData:
        return TextSpan(
          text: data.text,
          style: phoneTextStyle ??
              textPreviewTheme.phoneTextStyle ??
              defaultStyle.copyWith(
                color: textPreviewTheme.phoneColor ?? Colors.green,
                decoration: TextDecoration.underline,
                decorationColor: textPreviewTheme.phoneColor ?? Colors.green,
              ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => _handlePhoneTap(data as PhoneNumberTextData),
        );

      case UsernameTextData:
        return TextSpan(
          text: data.text,
          style: usernameTextStyle ??
              textPreviewTheme.usernameTextStyle ??
              defaultStyle.copyWith(
                color: textPreviewTheme.usernameColor ?? Colors.blue,
                fontWeight: FontWeight.bold,
              ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => _handleUsernameTap(data as UsernameTextData),
        );

      case SocialMediaTextData:
        final socialData = data as SocialMediaTextData;
        return TextSpan(
          text: socialData.text,
          style: socialMediaTextStyle ??
              textPreviewTheme.socialMediaTextStyle ??
              defaultStyle.copyWith(
                color: textPreviewTheme.primaryColor ??
                    _getSocialMediaColor(socialData.type),
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => _handleSocialMediaTap(socialData),
        );

      case HashtagTextData:
        return TextSpan(
          text: data.text,
          style: hashtagTextStyle ??
              textPreviewTheme.hashtagTextStyle ??
              defaultStyle.copyWith(
                color: textPreviewTheme.hashtagColor ?? Colors.blue,
                fontWeight: FontWeight.bold,
              ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => _handleHashtagTap(data as HashtagTextData),
        );

      case RouteTextData:
        final routeData = data as RouteTextData;
        return TextSpan(
          text: routeData.text,
          style: routeTextStyle ??
              textPreviewTheme.routeTextStyle ??
              defaultStyle.copyWith(
                color: textPreviewTheme.routeColor ?? Colors.purple,
                decoration: TextDecoration.underline,
              ),
          recognizer: TapGestureRecognizer()
            ..onTap = () => _handleRouteTap(routeData),
        );

      default:
        return TextSpan(
          text: data.text,
          style: normalTextStyle ??
              textPreviewTheme.normalTextStyle ??
              defaultStyle,
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
  void _handleRouteTap(RouteTextData routeData) {
    if (onRouteTap != null) {
      onRouteTap!(routeData);
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
