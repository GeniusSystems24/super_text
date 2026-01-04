part of '../super_text_preview_library.dart';

/// Configuration for route matching in the application
/// Contains base addresses and route definitions
class RouteConfig {
  /// List of base addresses for the application
  /// Example: ['https://myapp.page.link', 'https://myapp.com', 'myapp://']
  final List<String> baseAddresses;

  /// List of route definitions
  final List<RouteDefinition> routes;

  const RouteConfig({
    required this.baseAddresses,
    required this.routes,
  });

  /// Check if a URL belongs to one of the app's base addresses
  bool isAppLink(String url) {
    return baseAddresses.any((base) => url.startsWith(base));
  }

  /// Extract the path from a URL (removing the base address)
  /// Returns null if URL doesn't match any base address
  String? extractPath(String url) {
    for (final base in baseAddresses) {
      if (url.startsWith(base)) {
        String path = url.replaceFirst(base, '');
        // Remove leading slash if present for consistent matching
        if (path.startsWith('/')) {
          path = path.substring(1);
        }
        // Remove trailing slash for consistent matching
        if (path.endsWith('/') && path.length > 1) {
          path = path.substring(0, path.length - 1);
        }
        return path;
      }
    }
    return null;
  }

  /// Find a route by its name
  RouteDefinition? findByName(String name) {
    for (final route in routes) {
      if (route.name == name) {
        return route;
      }
    }
    return null;
  }

  /// Match a URL against registered routes
  /// Returns a tuple of (RouteDefinition, extracted parameters) or null
  (RouteDefinition, Map<String, String>)? matchUrl(String url) {
    final path = extractPath(url);
    if (path == null) return null;

    // Handle empty path (home route)
    if (path.isEmpty) {
      final homeRoute = findByName('home');
      if (homeRoute != null) {
        return (homeRoute, {});
      }
    }

    for (final route in routes) {
      final params = route.matchPath(path);
      if (params != null) {
        return (route, params);
      }
    }

    return null; // Treated as external link
  }
}
