// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/client.dart';

import 'package:arcane_neon_web/components/ascii_showcase.dart'
    deferred as _ascii_showcase;
import 'package:arcane_neon_web/components/interactive_demo.dart'
    deferred as _interactive_demo;
import 'package:jaspr_content/components/_internal/tab_bar.dart'
    deferred as _tab_bar;

/// Default [ClientOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.client.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultClientOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ClientOptions get defaultClientOptions => ClientOptions(
  clients: {
    'ascii_showcase': ClientLoader(
      (p) => _ascii_showcase.AsciiShowcase(),
      loader: _ascii_showcase.loadLibrary,
    ),
    'interactive_demo': ClientLoader(
      (p) => _interactive_demo.InteractiveDemoPage(
        componentType: p['componentType'] as String,
      ),
      loader: _interactive_demo.loadLibrary,
    ),
    'jaspr_content:tab_bar': ClientLoader(
      (p) => _tab_bar.TabBar(
        initialValue: p['initialValue'] as String,
        items: (p['items'] as Map<String, Object?>).cast<String, String>(),
      ),
      loader: _tab_bar.loadLibrary,
    ),
  },
);
