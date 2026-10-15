// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:arcane_jaspr/component/collection/card_carousel.dart'
    as _card_carousel;
import 'package:arcane_jaspr/component/collection/infinite_carousel.dart'
    as _infinite_carousel;
import 'package:arcane_jaspr/component/form/field.dart' as _field;
import 'package:arcane_jaspr/component/view/avatar.dart' as _avatar;
import 'package:arcane_neon_web/components/ascii_showcase.dart'
    as _ascii_showcase;
import 'package:arcane_neon_web/components/interactive_demo.dart'
    as _interactive_demo;
import 'package:jaspr_content/components/_internal/tab_bar.dart' as _tab_bar;
import 'package:jaspr_content/components/tabs.dart' as _tabs;

/// Default [ServerOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.server.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultServerOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ServerOptions get defaultServerOptions => ServerOptions(
  clientId: 'main.client.dart.js',
  clients: {
    _ascii_showcase.AsciiShowcase: ClientTarget<_ascii_showcase.AsciiShowcase>(
      'ascii_showcase',
    ),
    _interactive_demo.InteractiveDemoPage:
        ClientTarget<_interactive_demo.InteractiveDemoPage>(
          'interactive_demo',
          params: __interactive_demoInteractiveDemoPage,
        ),
    _tab_bar.TabBar: ClientTarget<_tab_bar.TabBar>(
      'jaspr_content:tab_bar',
      params: __tab_barTabBar,
    ),
  },
  styles: () => [
    ..._card_carousel.ArcaneHeroCarousel.styles,
    ..._card_carousel.ArcaneNavigableCarousel.styles,
    ..._card_carousel.CardCarousel.styles,
    ..._infinite_carousel.ArcaneInfiniteCarousel.styles,
    ..._field.ArcaneFieldStyles.styles,
    ..._avatar.ArcaneAvatarBadge.styles,
    ..._tabs.Tabs.styles,
    ..._tab_bar.TabBar.styles,
  ],
);

Map<String, Object?> __interactive_demoInteractiveDemoPage(
  _interactive_demo.InteractiveDemoPage c,
) => {'componentType': c.componentType};
Map<String, Object?> __tab_barTabBar(_tab_bar.TabBar c) => {
  'initialValue': c.initialValue,
  'items': c.items,
};
