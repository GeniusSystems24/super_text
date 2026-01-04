import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Text preview theme configuration
class SuperInteractiveTextPreviewTheme {
  /// Get TextPreviewTheme from BuildContext using ThemeExtension
  static SuperInteractiveTextPreviewTheme? of(BuildContext context) =>
      Theme.of(context).extension<SuperInteractiveTextPreviewTheme>();

  /// Get TextPreviewTheme or create a default one based on brightness
  static SuperInteractiveTextPreviewTheme get(BuildContext context) {
    final theme = Theme.of(context);
    final existingTheme = theme.extension<SuperInteractiveTextPreviewTheme>();

    return existingTheme ??
        (theme.brightness == Brightness.light
            ? SuperInteractiveTextPreviewTheme.light(theme.textTheme)
            : SuperInteractiveTextPreviewTheme.dark(theme.textTheme));
  }

  // Container properties
  /// Border radius for preview container
  final double borderRadius;

  /// Container padding
  final EdgeInsetsGeometry containerPadding;

  /// Container margin
  final EdgeInsetsGeometry containerMargin;

  /// Background color
  final Color? backgroundColor;

  /// Border color
  final Color? borderColor;

  /// Maximum height for preview
  final double maxHeight;

  /// Elevation for preview container
  final double elevation;

  // Text styles for different types
  /// Normal text style
  final TextStyle? normalTextStyle;

  /// Link text style
  final TextStyle? linkTextStyle;

  /// Email text style
  final TextStyle? emailTextStyle;

  /// Phone text style
  final TextStyle? phoneTextStyle;

  /// Username text style
  final TextStyle? usernameTextStyle;

  /// Social media text style
  final TextStyle? socialMediaTextStyle;

  /// Hashtag text style
  final TextStyle? hashtagTextStyle;

  /// Route text style
  final TextStyle? routeTextStyle;

  // Colors
  /// Title text color
  final Color? titleColor;

  /// Description text color
  final Color? descriptionColor;

  /// URL text color
  final Color? urlColor;

  /// Link text color
  final Color? linkColor;

  /// Email text color
  final Color? emailColor;

  /// Phone text color
  final Color? phoneColor;

  /// Username text color
  final Color? usernameColor;

  /// Hashtag text color
  final Color? hashtagColor;

  /// Route text color
  final Color? routeColor;

  // Enhanced features colors
  /// Hover color for enhanced preview
  final Color? hoverColor;

  /// Primary color for enhanced elements
  final Color? primaryColor;

  /// Secondary color for enhanced elements
  final Color? secondaryColor;

  // Font sizes
  /// Title font size
  final double titleFontSize;

  /// Description font size
  final double descriptionFontSize;

  /// URL font size
  final double urlFontSize;

  /// Normal text font size
  final double normalTextFontSize;

  /// Link text font size
  final double linkTextFontSize;

  /// Username text font size
  final double usernameTextFontSize;

  /// Hashtag text font size
  final double hashtagTextFontSize;

  // Enhanced features
  /// Enable tooltips for enhanced preview
  final bool showTooltips;

  /// Enable haptic feedback
  final bool enableHapticFeedback;

  /// Enable hover effects
  final bool enableHoverEffects;

  /// Animation duration for enhanced effects
  final Duration animationDuration;

  /// Maximum lines for text display
  final int? maxLines;

  /// Text overflow behavior
  final TextOverflow? overflow;

  /// Text alignment
  final TextAlign? textAlign;

  const SuperInteractiveTextPreviewTheme({
    // Container properties
    this.borderRadius = 12.0,
    this.containerPadding = const EdgeInsets.all(12.0),
    this.containerMargin = const EdgeInsets.symmetric(vertical: 4.0),
    this.backgroundColor,
    this.borderColor,
    this.maxHeight = 200.0,
    this.elevation = 1.0,

    // Text styles
    this.normalTextStyle,
    this.linkTextStyle,
    this.emailTextStyle,
    this.phoneTextStyle,
    this.usernameTextStyle,
    this.socialMediaTextStyle,
    this.hashtagTextStyle,
    this.routeTextStyle,

    // Colors
    this.titleColor,
    this.descriptionColor,
    this.urlColor,
    this.linkColor,
    this.emailColor,
    this.phoneColor,
    this.usernameColor,
    this.hashtagColor,
    this.routeColor,
    this.hoverColor,
    this.primaryColor,
    this.secondaryColor,

    // Font sizes
    this.titleFontSize = 16.0,
    this.descriptionFontSize = 14.0,
    this.urlFontSize = 12.0,
    this.normalTextFontSize = 14.0,
    this.linkTextFontSize = 14.0,
    this.usernameTextFontSize = 14.0,
    this.hashtagTextFontSize = 14.0,

    // Enhanced features
    this.showTooltips = true,
    this.enableHapticFeedback = true,
    this.enableHoverEffects = true,
    this.animationDuration = const Duration(milliseconds: 200),
    this.maxLines,
    this.overflow,
    this.textAlign,
  });

  /// Light theme for text preview
  SuperInteractiveTextPreviewTheme.light([TextTheme? textTheme])
      : this(
          backgroundColor: const Color(0xFFF5F5F5),
          borderColor: const Color(0xFFE0E0E0),
          titleColor: const Color(0xFF121212),
          descriptionColor: const Color(0xFF757575),
          urlColor: const Color(0xFF974EE9),
          linkColor: const Color(0xFF974EE9),
          emailColor: const Color(0xFF2196F3),
          phoneColor: const Color(0xFF4CAF50),
          usernameColor: const Color(0xFF2196F3),
          hashtagColor: const Color(0xFF2196F3),
          routeColor: const Color(0xFF9C27B0),
          hoverColor: const Color(0xFF974EE9),
          primaryColor: const Color(0xFF974EE9),
          secondaryColor: const Color(0xFF2196F3),
          normalTextStyle: textTheme?.bodyMedium?.copyWith(
                color: const Color(0xFF121212),
                fontSize: 14.0,
              ) ??
              const TextStyle(color: Color(0xFF121212), fontSize: 14.0),
          linkTextStyle: textTheme?.bodyMedium?.copyWith(
                color: const Color(0xFF974EE9),
                fontSize: 14.0,
                decoration: TextDecoration.underline,
                decorationColor: const Color(0xFF974EE9),
              ) ??
              const TextStyle(
                color: Color(0xFF974EE9),
                fontSize: 14.0,
                decoration: TextDecoration.underline,
                decorationColor: Color(0xFF974EE9),
              ),
          emailTextStyle: textTheme?.bodyMedium?.copyWith(
                color: const Color(0xFF2196F3),
                fontSize: 14.0,
                decoration: TextDecoration.underline,
                decorationColor: const Color(0xFF2196F3),
              ) ??
              const TextStyle(
                color: Color(0xFF2196F3),
                fontSize: 14.0,
                decoration: TextDecoration.underline,
                decorationColor: Color(0xFF2196F3),
              ),
          phoneTextStyle: textTheme?.bodyMedium?.copyWith(
                color: const Color(0xFF4CAF50),
                fontSize: 14.0,
                decoration: TextDecoration.underline,
                decorationColor: const Color(0xFF4CAF50),
              ) ??
              const TextStyle(
                color: Color(0xFF4CAF50),
                fontSize: 14.0,
                decoration: TextDecoration.underline,
                decorationColor: Color(0xFF4CAF50),
              ),
          usernameTextStyle: textTheme?.bodyMedium?.copyWith(
                color: const Color(0xFF2196F3),
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ) ??
              const TextStyle(
                color: Color(0xFF2196F3),
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
          socialMediaTextStyle: textTheme?.bodyMedium?.copyWith(
                color: const Color(0xFF2196F3),
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ) ??
              const TextStyle(
                color: Color(0xFF2196F3),
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
          hashtagTextStyle: textTheme?.bodyMedium?.copyWith(
                color: const Color(0xFF2196F3),
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ) ??
              const TextStyle(
                color: Color(0xFF2196F3),
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
          routeTextStyle: textTheme?.bodyMedium?.copyWith(
                color: const Color(0xFF9C27B0),
                fontSize: 14.0,
                decoration: TextDecoration.underline,
              ) ??
              const TextStyle(
                color: Color(0xFF9C27B0),
                fontSize: 14.0,
                decoration: TextDecoration.underline,
              ),
        );

  /// Dark theme for text preview
  SuperInteractiveTextPreviewTheme.dark([TextTheme? textTheme])
      : this(
          backgroundColor: const Color(0xFF2C2C2E),
          borderColor: const Color(0xFF444444),
          titleColor: const Color(0xFFFFFFFF),
          descriptionColor: const Color(0xFFB0B0B0),
          urlColor: const Color(0xFF974EE9),
          linkColor: const Color(0xFF974EE9),
          emailColor: const Color(0xFF64B5F6),
          phoneColor: const Color(0xFF81C784),
          usernameColor: const Color(0xFF64B5F6),
          hashtagColor: const Color(0xFF64B5F6),
          routeColor: const Color(0xFFBA68C8),
          hoverColor: const Color(0xFF974EE9),
          primaryColor: const Color(0xFF974EE9),
          secondaryColor: const Color(0xFF64B5F6),
          normalTextStyle: textTheme?.bodyMedium?.copyWith(
                color: const Color(0xFFFFFFFF),
                fontSize: 14.0,
              ) ??
              const TextStyle(color: Color(0xFFFFFFFF), fontSize: 14.0),
          linkTextStyle: textTheme?.bodyMedium?.copyWith(
                color: const Color(0xFF974EE9),
                fontSize: 14.0,
                decoration: TextDecoration.underline,
                decorationColor: const Color(0xFF974EE9),
              ) ??
              const TextStyle(
                color: Color(0xFF974EE9),
                fontSize: 14.0,
                decoration: TextDecoration.underline,
                decorationColor: Color(0xFF974EE9),
              ),
          emailTextStyle: textTheme?.bodyMedium?.copyWith(
                color: const Color(0xFF64B5F6),
                fontSize: 14.0,
                decoration: TextDecoration.underline,
                decorationColor: const Color(0xFF64B5F6),
              ) ??
              const TextStyle(
                color: Color(0xFF64B5F6),
                fontSize: 14.0,
                decoration: TextDecoration.underline,
                decorationColor: Color(0xFF64B5F6),
              ),
          phoneTextStyle: textTheme?.bodyMedium?.copyWith(
                color: const Color(0xFF81C784),
                fontSize: 14.0,
                decoration: TextDecoration.underline,
                decorationColor: const Color(0xFF81C784),
              ) ??
              const TextStyle(
                color: Color(0xFF81C784),
                fontSize: 14.0,
                decoration: TextDecoration.underline,
                decorationColor: Color(0xFF81C784),
              ),
          usernameTextStyle: textTheme?.bodyMedium?.copyWith(
                color: const Color(0xFF64B5F6),
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ) ??
              const TextStyle(
                color: Color(0xFF64B5F6),
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
          socialMediaTextStyle: textTheme?.bodyMedium?.copyWith(
                color: const Color(0xFF64B5F6),
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ) ??
              const TextStyle(
                color: Color(0xFF64B5F6),
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
          hashtagTextStyle: textTheme?.bodyMedium?.copyWith(
                color: const Color(0xFF64B5F6),
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ) ??
              const TextStyle(
                color: Color(0xFF64B5F6),
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
          routeTextStyle: textTheme?.bodyMedium?.copyWith(
                color: const Color(0xFFBA68C8),
                fontSize: 14.0,
                decoration: TextDecoration.underline,
              ) ??
              const TextStyle(
                color: Color(0xFFBA68C8),
                fontSize: 14.0,
                decoration: TextDecoration.underline,
              ),
        );

  SuperInteractiveTextPreviewTheme copyWith({
    double? borderRadius,
    EdgeInsetsGeometry? containerPadding,
    EdgeInsetsGeometry? containerMargin,
    Color? backgroundColor,
    Color? borderColor,
    double? maxHeight,
    double? elevation,
    TextStyle? normalTextStyle,
    TextStyle? linkTextStyle,
    TextStyle? emailTextStyle,
    TextStyle? phoneTextStyle,
    TextStyle? usernameTextStyle,
    TextStyle? socialMediaTextStyle,
    TextStyle? hashtagTextStyle,
    TextStyle? routeTextStyle,
    Color? titleColor,
    Color? descriptionColor,
    Color? urlColor,
    Color? linkColor,
    Color? emailColor,
    Color? phoneColor,
    Color? usernameColor,
    Color? hashtagColor,
    Color? routeColor,
    Color? hoverColor,
    Color? primaryColor,
    Color? secondaryColor,
    double? titleFontSize,
    double? descriptionFontSize,
    double? urlFontSize,
    double? normalTextFontSize,
    double? linkTextFontSize,
    double? usernameTextFontSize,
    double? hashtagTextFontSize,
    bool? showTooltips,
    bool? enableHapticFeedback,
    bool? enableHoverEffects,
    Duration? animationDuration,
    int? maxLines,
    TextOverflow? overflow,
    TextAlign? textAlign,
  }) {
    return SuperInteractiveTextPreviewTheme(
      borderRadius: borderRadius ?? this.borderRadius,
      containerPadding: containerPadding ?? this.containerPadding,
      containerMargin: containerMargin ?? this.containerMargin,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      maxHeight: maxHeight ?? this.maxHeight,
      elevation: elevation ?? this.elevation,
      normalTextStyle: normalTextStyle ?? this.normalTextStyle,
      linkTextStyle: linkTextStyle ?? this.linkTextStyle,
      emailTextStyle: emailTextStyle ?? this.emailTextStyle,
      phoneTextStyle: phoneTextStyle ?? this.phoneTextStyle,
      usernameTextStyle: usernameTextStyle ?? this.usernameTextStyle,
      socialMediaTextStyle: socialMediaTextStyle ?? this.socialMediaTextStyle,
      hashtagTextStyle: hashtagTextStyle ?? this.hashtagTextStyle,
      routeTextStyle: routeTextStyle ?? this.routeTextStyle,
      titleColor: titleColor ?? this.titleColor,
      descriptionColor: descriptionColor ?? this.descriptionColor,
      urlColor: urlColor ?? this.urlColor,
      linkColor: linkColor ?? this.linkColor,
      emailColor: emailColor ?? this.emailColor,
      phoneColor: phoneColor ?? this.phoneColor,
      usernameColor: usernameColor ?? this.usernameColor,
      hashtagColor: hashtagColor ?? this.hashtagColor,
      routeColor: routeColor ?? this.routeColor,
      hoverColor: hoverColor ?? this.hoverColor,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      titleFontSize: titleFontSize ?? this.titleFontSize,
      descriptionFontSize: descriptionFontSize ?? this.descriptionFontSize,
      urlFontSize: urlFontSize ?? this.urlFontSize,
      normalTextFontSize: normalTextFontSize ?? this.normalTextFontSize,
      linkTextFontSize: linkTextFontSize ?? this.linkTextFontSize,
      usernameTextFontSize: usernameTextFontSize ?? this.usernameTextFontSize,
      hashtagTextFontSize: hashtagTextFontSize ?? this.hashtagTextFontSize,
      showTooltips: showTooltips ?? this.showTooltips,
      enableHapticFeedback: enableHapticFeedback ?? this.enableHapticFeedback,
      enableHoverEffects: enableHoverEffects ?? this.enableHoverEffects,
      animationDuration: animationDuration ?? this.animationDuration,
      maxLines: maxLines ?? this.maxLines,
      overflow: overflow ?? this.overflow,
      textAlign: textAlign ?? this.textAlign,
    );
  }

  /// Linear interpolation between two TextPreviewThemes
  static SuperInteractiveTextPreviewTheme lerp(
    SuperInteractiveTextPreviewTheme? a,
    SuperInteractiveTextPreviewTheme? b,
    double t,
  ) {
    if (a == null && b == null) return const SuperInteractiveTextPreviewTheme();
    if (a == null) return b!;
    if (b == null) return a;

    return SuperInteractiveTextPreviewTheme(
      borderRadius: ui.lerpDouble(a.borderRadius, b.borderRadius, t) ?? 12.0,
      containerPadding:
          EdgeInsetsGeometry.lerp(a.containerPadding, b.containerPadding, t) ??
              const EdgeInsets.all(12.0),
      containerMargin:
          EdgeInsetsGeometry.lerp(a.containerMargin, b.containerMargin, t) ??
              const EdgeInsets.symmetric(vertical: 4.0),
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      borderColor: Color.lerp(a.borderColor, b.borderColor, t),
      maxHeight: ui.lerpDouble(a.maxHeight, b.maxHeight, t) ?? 200.0,
      elevation: ui.lerpDouble(a.elevation, b.elevation, t) ?? 1.0,
      normalTextStyle: TextStyle.lerp(a.normalTextStyle, b.normalTextStyle, t),
      linkTextStyle: TextStyle.lerp(a.linkTextStyle, b.linkTextStyle, t),
      emailTextStyle: TextStyle.lerp(a.emailTextStyle, b.emailTextStyle, t),
      phoneTextStyle: TextStyle.lerp(a.phoneTextStyle, b.phoneTextStyle, t),
      usernameTextStyle: TextStyle.lerp(
        a.usernameTextStyle,
        b.usernameTextStyle,
        t,
      ),
      socialMediaTextStyle: TextStyle.lerp(
        a.socialMediaTextStyle,
        b.socialMediaTextStyle,
        t,
      ),
      hashtagTextStyle: TextStyle.lerp(
        a.hashtagTextStyle,
        b.hashtagTextStyle,
        t,
      ),
      routeTextStyle: TextStyle.lerp(a.routeTextStyle, b.routeTextStyle, t),
      titleColor: Color.lerp(a.titleColor, b.titleColor, t),
      descriptionColor: Color.lerp(a.descriptionColor, b.descriptionColor, t),
      urlColor: Color.lerp(a.urlColor, b.urlColor, t),
      linkColor: Color.lerp(a.linkColor, b.linkColor, t),
      emailColor: Color.lerp(a.emailColor, b.emailColor, t),
      phoneColor: Color.lerp(a.phoneColor, b.phoneColor, t),
      usernameColor: Color.lerp(a.usernameColor, b.usernameColor, t),
      hashtagColor: Color.lerp(a.hashtagColor, b.hashtagColor, t),
      routeColor: Color.lerp(a.routeColor, b.routeColor, t),
      hoverColor: Color.lerp(a.hoverColor, b.hoverColor, t),
      primaryColor: Color.lerp(a.primaryColor, b.primaryColor, t),
      secondaryColor: Color.lerp(a.secondaryColor, b.secondaryColor, t),
      titleFontSize: ui.lerpDouble(a.titleFontSize, b.titleFontSize, t) ?? 16.0,
      descriptionFontSize:
          ui.lerpDouble(a.descriptionFontSize, b.descriptionFontSize, t) ??
              14.0,
      urlFontSize: ui.lerpDouble(a.urlFontSize, b.urlFontSize, t) ?? 12.0,
      normalTextFontSize:
          ui.lerpDouble(a.normalTextFontSize, b.normalTextFontSize, t) ?? 14.0,
      linkTextFontSize:
          ui.lerpDouble(a.linkTextFontSize, b.linkTextFontSize, t) ?? 14.0,
      usernameTextFontSize:
          ui.lerpDouble(a.usernameTextFontSize, b.usernameTextFontSize, t) ??
              14.0,
      hashtagTextFontSize:
          ui.lerpDouble(a.hashtagTextFontSize, b.hashtagTextFontSize, t) ??
              14.0,
      showTooltips: t < 0.5 ? a.showTooltips : b.showTooltips,
      enableHapticFeedback:
          t < 0.5 ? a.enableHapticFeedback : b.enableHapticFeedback,
      enableHoverEffects: t < 0.5 ? a.enableHoverEffects : b.enableHoverEffects,
      animationDuration: t < 0.5 ? a.animationDuration : b.animationDuration,
      maxLines: t < 0.5 ? a.maxLines : b.maxLines,
      overflow: t < 0.5 ? a.overflow : b.overflow,
      textAlign: t < 0.5 ? a.textAlign : b.textAlign,
    );
  }

  /// Merge with another TextPreviewTheme
  SuperInteractiveTextPreviewTheme merge(
      SuperInteractiveTextPreviewTheme? other) {
    if (other == null) return this;
    return copyWith(
      borderRadius: other.borderRadius,
      containerPadding: other.containerPadding,
      containerMargin: other.containerMargin,
      backgroundColor: other.backgroundColor,
      borderColor: other.borderColor,
      maxHeight: other.maxHeight,
      elevation: other.elevation,
      normalTextStyle: other.normalTextStyle,
      linkTextStyle: other.linkTextStyle,
      emailTextStyle: other.emailTextStyle,
      phoneTextStyle: other.phoneTextStyle,
      usernameTextStyle: other.usernameTextStyle,
      socialMediaTextStyle: other.socialMediaTextStyle,
      hashtagTextStyle: other.hashtagTextStyle,
      routeTextStyle: other.routeTextStyle,
      titleColor: other.titleColor,
      descriptionColor: other.descriptionColor,
      urlColor: other.urlColor,
      linkColor: other.linkColor,
      emailColor: other.emailColor,
      phoneColor: other.phoneColor,
      usernameColor: other.usernameColor,
      hashtagColor: other.hashtagColor,
      routeColor: other.routeColor,
      hoverColor: other.hoverColor,
      primaryColor: other.primaryColor,
      secondaryColor: other.secondaryColor,
      titleFontSize: other.titleFontSize,
      descriptionFontSize: other.descriptionFontSize,
      urlFontSize: other.urlFontSize,
      normalTextFontSize: other.normalTextFontSize,
      linkTextFontSize: other.linkTextFontSize,
      usernameTextFontSize: other.usernameTextFontSize,
      hashtagTextFontSize: other.hashtagTextFontSize,
      showTooltips: other.showTooltips,
      enableHapticFeedback: other.enableHapticFeedback,
      enableHoverEffects: other.enableHoverEffects,
      animationDuration: other.animationDuration,
      maxLines: other.maxLines,
      overflow: other.overflow,
      textAlign: other.textAlign,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SuperInteractiveTextPreviewTheme &&
        other.borderRadius == borderRadius &&
        other.containerPadding == containerPadding &&
        other.containerMargin == containerMargin &&
        other.backgroundColor == backgroundColor &&
        other.borderColor == borderColor &&
        other.maxHeight == maxHeight &&
        other.elevation == elevation &&
        other.normalTextStyle == normalTextStyle &&
        other.linkTextStyle == linkTextStyle &&
        other.emailTextStyle == emailTextStyle &&
        other.phoneTextStyle == phoneTextStyle &&
        other.usernameTextStyle == usernameTextStyle &&
        other.socialMediaTextStyle == socialMediaTextStyle &&
        other.hashtagTextStyle == hashtagTextStyle &&
        other.routeTextStyle == routeTextStyle &&
        other.titleColor == titleColor &&
        other.descriptionColor == descriptionColor &&
        other.urlColor == urlColor &&
        other.linkColor == linkColor &&
        other.emailColor == emailColor &&
        other.phoneColor == phoneColor &&
        other.usernameColor == usernameColor &&
        other.hashtagColor == hashtagColor &&
        other.routeColor == routeColor &&
        other.hoverColor == hoverColor &&
        other.primaryColor == primaryColor &&
        other.secondaryColor == secondaryColor &&
        other.titleFontSize == titleFontSize &&
        other.descriptionFontSize == descriptionFontSize &&
        other.urlFontSize == urlFontSize &&
        other.normalTextFontSize == normalTextFontSize &&
        other.linkTextFontSize == linkTextFontSize &&
        other.usernameTextFontSize == usernameTextFontSize &&
        other.hashtagTextFontSize == hashtagTextFontSize &&
        other.showTooltips == showTooltips &&
        other.enableHapticFeedback == enableHapticFeedback &&
        other.enableHoverEffects == enableHoverEffects &&
        other.animationDuration == animationDuration &&
        other.maxLines == maxLines &&
        other.overflow == overflow &&
        other.textAlign == textAlign;
  }

  @override
  int get hashCode => Object.hashAll([
        borderRadius,
        containerPadding,
        containerMargin,
        backgroundColor,
        borderColor,
        maxHeight,
        elevation,
        normalTextStyle,
        linkTextStyle,
        emailTextStyle,
        phoneTextStyle,
        usernameTextStyle,
        socialMediaTextStyle,
        hashtagTextStyle,
        routeTextStyle,
        titleColor,
        descriptionColor,
        urlColor,
        linkColor,
        emailColor,
        phoneColor,
        usernameColor,
        hashtagColor,
        routeColor,
        hoverColor,
        primaryColor,
        secondaryColor,
        titleFontSize,
        descriptionFontSize,
        urlFontSize,
        normalTextFontSize,
        linkTextFontSize,
        usernameTextFontSize,
        hashtagTextFontSize,
        showTooltips,
        enableHapticFeedback,
        enableHoverEffects,
        animationDuration,
        maxLines,
        overflow,
        textAlign,
      ]);
}
