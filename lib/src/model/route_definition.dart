part of '../super_interactive_text_preview_library.dart';

/// Definition of a single route pattern
/// Used to define how URLs should be matched and handled
class RouteDefinition {
  /// Unique name for the route
  final String name;

  /// Regex pattern to match the URL path
  /// Examples:
  /// - Static: r'^login$', r'^signup$', r'^search$'
  /// - Single param: r'^Clubs/([^/]+)$', r'^Plans/([^/]+)$'
  /// - Multi params: r'^Clubs/([^/]+)/News/([^/]+)$'
  /// - Nested: r'^Clubs/([^/]+)/Groups/([^/]+)/Rooms/([^/]+)$'
  /// - With action: r'^Clubs/([^/]+)/edit$', r'^Clubs/([^/]+)/News/modify$'
  final String pattern;

  /// Map of expected parameter names with their required status
  /// key = parameter name, value = is required?
  /// Example: {'clubId': true, 'tab': false}
  /// If a required parameter is missing, the URL is treated as external link
  final Map<String, bool>? parameterNames;

  /// Callback for navigation
  final void Function(BuildContext context, RouteTextData data)? onNavigate;

  /// Compiled regex pattern for matching
  late final RegExp _regex;

  RouteDefinition({
    required this.name,
    required this.pattern,
    this.parameterNames,
    this.onNavigate,
  }) : _regex = RegExp(pattern);

  /// Get the compiled regex
  RegExp get regex => _regex;

  /// Get the list of parameter names in order
  List<String> get parameterNamesList =>
      parameterNames?.keys.toList() ?? const [];

  /// Get only the required parameter names
  List<String> get requiredParameterNames =>
      parameterNames?.entries
          .where((e) => e.value == true)
          .map((e) => e.key)
          .toList() ??
      const [];

  /// Validate that all required parameters are present and non-empty
  bool validateParameters(Map<String, String> extractedParams) {
    if (parameterNames == null) return true;

    for (final entry in parameterNames!.entries) {
      final isRequired = entry.value;
      final paramExists = extractedParams.containsKey(entry.key) &&
          extractedParams[entry.key]?.isNotEmpty == true;

      // If required parameter is missing, validation fails
      if (isRequired && !paramExists) {
        return false;
      }
    }
    return true;
  }

  /// Try to match a path and extract parameters
  /// Returns null if path doesn't match or required params are missing
  Map<String, String>? matchPath(String path) {
    final match = _regex.firstMatch(path);
    if (match == null) return null;

    final params = <String, String>{};
    final names = parameterNamesList;

    for (int i = 0; i < names.length && i < match.groupCount; i++) {
      final value = match.group(i + 1);
      if (value != null && value.isNotEmpty) {
        params[names[i]] = value;
      }
    }

    // Validate required parameters
    if (!validateParameters(params)) {
      return null;
    }

    return params;
  }
}
