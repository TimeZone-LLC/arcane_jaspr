import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neon/arcane_jaspr_neon.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:arcane_jaspr_win95/arcane_jaspr_win95.dart';
import 'package:jaspr_test/server_test.dart';

/// Themes that render the tab bar through `TabBarRenderBase`.
const List<(String, ArcaneStylesheet)> _prefixedThemes =
    <(String, ArcaneStylesheet)>[
      ('win95', Win95Stylesheet()),
      ('neon', NeonStylesheet()),
      ('neubrutalism', NeubrutalismStylesheet()),
    ];

/// The `class` attribute of every rendered element with a `role`, in order.
List<String> _classesByRole(String html, String role) => RegExp(
  '<[^>]+class="([^"]*)"[^>]*role="$role"[^>]*>',
).allMatches(html).map((RegExpMatch match) => match.group(1)!).toList();

void main() {
  for (final (String prefix, ArcaneStylesheet sheet) in _prefixedThemes) {
    testServer(
      '$prefix tab bar carries the shared hooks and one selected class',
      (ServerTester tester) async {
        tester.pumpComponent(
          ArcaneThemeProvider(
            stylesheet: sheet,
            child: ArcaneTabBar(
              tabs: const <ArcaneTabBarItem>[
                ArcaneTabBarItem(label: 'Posts'),
                ArcaneTabBarItem(label: 'Saves'),
              ],
              selectedIndex: 0,
              onChanged: (int _) {},
            ),
          ),
        );
        final DocumentResponse response = await tester.request('/');
        expect(response.statusCode, 200, reason: response.body);

        expect(_classesByRole(response.body, 'tablist'), <String>[
          'arcane-tab-bar $prefix-tab-bar',
        ]);
        expect(_classesByRole(response.body, 'tab'), <String>[
          'arcane-tab-bar-item $prefix-tab-bar-item selected',
          'arcane-tab-bar-item $prefix-tab-bar-item',
        ]);
      },
    );

    test('$prefix tab bar CSS never keys off the retired active class', () {
      expect(sheet.componentCss, isNot(contains('-tab-bar-item.active')));
    });
  }

  test('Win95 and Neon paint the selected tab bar item through .selected', () {
    expect(
      const Win95Stylesheet().componentCss,
      contains(
        '#arcane-root.arcane-theme-win95 .win95-tab-bar-item.selected {',
      ),
    );
    expect(
      const NeonStylesheet().componentCss,
      contains('#arcane-root.arcane-theme-neon .neon-tab-bar-item.selected,'),
    );
  });
}
