import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';

import '../attributions/interactive_attributions.dart';

/// Creates a stylesheet with interactive text styles
Stylesheet createInteractiveStylesheet({
  Color? linkColor,
  Color? emailColor,
  Color? phoneColor,
  Color? mentionColor,
  Color? hashtagColor,
  Color? socialMediaColor,
  Color? routeColor,
  TextStyle? baseTextStyle,
}) {
  final defaultLinkColor = linkColor ?? const Color(0xFF974EE9);
  final defaultEmailColor = emailColor ?? const Color(0xFF2196F3);
  final defaultPhoneColor = phoneColor ?? const Color(0xFF4CAF50);
  final defaultMentionColor = mentionColor ?? const Color(0xFF2196F3);
  final defaultHashtagColor = hashtagColor ?? const Color(0xFF2196F3);
  final defaultSocialMediaColor = socialMediaColor ?? const Color(0xFFE1306C);
  final defaultRouteColor = routeColor ?? const Color(0xFF9C27B0);

  return defaultStylesheet.copyWith(
    addRulesAfter: [
      // Link style
      StyleRule(
        const BlockSelector('paragraph'),
        (doc, docNode) {
          return {
            Styles.inlineTextStyler: _InteractiveTextStyler(
              linkColor: defaultLinkColor,
              emailColor: defaultEmailColor,
              phoneColor: defaultPhoneColor,
              mentionColor: defaultMentionColor,
              hashtagColor: defaultHashtagColor,
              socialMediaColor: defaultSocialMediaColor,
              routeColor: defaultRouteColor,
            ),
          };
        },
      ),
    ],
  );
}

/// Custom text styler for interactive attributions
class _InteractiveTextStyler extends SingleColumnLayoutStylePhase {
  _InteractiveTextStyler({
    required this.linkColor,
    required this.emailColor,
    required this.phoneColor,
    required this.mentionColor,
    required this.hashtagColor,
    required this.socialMediaColor,
    required this.routeColor,
  });

  final Color linkColor;
  final Color emailColor;
  final Color phoneColor;
  final Color mentionColor;
  final Color hashtagColor;
  final Color socialMediaColor;
  final Color routeColor;

  @override
  SingleColumnLayoutViewModel style(
    Document document,
    SingleColumnLayoutViewModel viewModel,
  ) {
    return viewModel;
  }
}

/// Attribution styler function for interactive elements
TextStyle interactiveAttributionStyler(
  Set<Attribution> attributions,
  TextStyle existingStyle, {
  Color? linkColor,
  Color? emailColor,
  Color? phoneColor,
  Color? mentionColor,
  Color? hashtagColor,
  Color? socialMediaColor,
  Color? routeColor,
}) {
  var style = existingStyle;

  for (final attribution in attributions) {
    if (attribution is InteractiveLinkAttribution) {
      style = style.copyWith(
        color: linkColor ?? const Color(0xFF974EE9),
        decoration: TextDecoration.underline,
        decorationColor: linkColor ?? const Color(0xFF974EE9),
      );
    } else if (attribution is InteractiveEmailAttribution) {
      style = style.copyWith(
        color: emailColor ?? const Color(0xFF2196F3),
        decoration: TextDecoration.underline,
        decorationColor: emailColor ?? const Color(0xFF2196F3),
      );
    } else if (attribution is InteractivePhoneAttribution) {
      style = style.copyWith(
        color: phoneColor ?? const Color(0xFF4CAF50),
        decoration: TextDecoration.underline,
        decorationColor: phoneColor ?? const Color(0xFF4CAF50),
      );
    } else if (attribution is InteractiveMentionAttribution) {
      style = style.copyWith(
        color: mentionColor ?? const Color(0xFF2196F3),
        fontWeight: FontWeight.bold,
      );
    } else if (attribution is InteractiveHashtagAttribution) {
      style = style.copyWith(
        color: hashtagColor ?? const Color(0xFF2196F3),
        fontWeight: FontWeight.bold,
      );
    } else if (attribution is InteractiveSocialMediaAttribution) {
      final color = _getSocialMediaColor(attribution.platform) ??
          socialMediaColor ??
          const Color(0xFFE1306C);
      style = style.copyWith(
        color: color,
        decoration: TextDecoration.underline,
        decorationColor: color,
      );
    } else if (attribution is InteractiveRouteAttribution) {
      style = style.copyWith(
        color: routeColor ?? const Color(0xFF9C27B0),
        decoration: TextDecoration.underline,
        decorationColor: routeColor ?? const Color(0xFF9C27B0),
      );
    }
  }

  return style;
}

/// Get color for social media platform
Color? _getSocialMediaColor(InteractiveSocialMediaType platform) {
  switch (platform) {
    case InteractiveSocialMediaType.instagram:
      return const Color(0xFFE1306C);
    case InteractiveSocialMediaType.twitter:
      return const Color(0xFF1DA1F2);
    case InteractiveSocialMediaType.facebook:
      return const Color(0xFF4267B2);
    case InteractiveSocialMediaType.youtube:
      return const Color(0xFFFF0000);
    case InteractiveSocialMediaType.linkedin:
      return const Color(0xFF0077B5);
    case InteractiveSocialMediaType.tiktok:
      return const Color(0xFF000000);
    case InteractiveSocialMediaType.snapchat:
      return const Color(0xFFFFFC00);
    case InteractiveSocialMediaType.whatsapp:
      return const Color(0xFF25D366);
    case InteractiveSocialMediaType.telegram:
      return const Color(0xFF0088CC);
    case InteractiveSocialMediaType.other:
      return null;
  }
}

/// Default interactive stylesheet with Material Design colors
Stylesheet get interactiveDefaultStylesheet => createInteractiveStylesheet();

/// Dark theme interactive stylesheet
Stylesheet get interactiveDarkStylesheet => createInteractiveStylesheet(
      linkColor: const Color(0xFFBB86FC),
      emailColor: const Color(0xFF64B5F6),
      phoneColor: const Color(0xFF81C784),
      mentionColor: const Color(0xFF64B5F6),
      hashtagColor: const Color(0xFF64B5F6),
      socialMediaColor: const Color(0xFFCF6679),
      routeColor: const Color(0xFFBA68C8),
    );
