import 'dart:io';

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/component/card/flexi_cards.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:jaspr_test/server_test.dart';

String _source(String path) => File(path).readAsStringSync();

final String _baseCss = _source('lib/stylesheets/base_css.dart');

/// Every surface kind the renderers emit for a layer that floats above the
/// page: they are separate windows and keep their own frame wherever they are
/// nested.
const Set<String> _floatingSurfaces = <String>{
  'popover',
  'hovercard',
  'menu',
  'context-menu',
  'command',
  'dialog',
  'sheet',
  'drawer',
};

/// The nested-surface flattening rule, selector included.
String _nestedSurfaceRule() {
  final RegExpMatch? match = RegExp(
    r'\[data-arcane-surface\]\s+\[data-arcane-surface\]:not\(',
  ).firstMatch(_baseCss);
  expect(match, isNotNull, reason: 'Missing scoped nested-surface rule');
  final int start = match!.start;
  final int end = _baseCss.indexOf('}', start);
  return _baseCss.substring(start, end + 1);
}

void main() {
  test(
    'shared stylesheet flattens nested surfaces but never floating layers',
    () {
      final String rule = _nestedSurfaceRule();

      expect(rule, contains('background: transparent !important'));
      expect(rule, contains('border-color: transparent !important'));
      expect(rule, contains('box-shadow: none !important'));
      expect(
        _baseCss,
        isNot(contains('[data-arcane-surface] [data-arcane-surface] {')),
      );

      final String selector = rule.substring(0, rule.indexOf('{'));
      // Any surface flattens what it holds; only the nested surface is scoped.
      expect(
        selector,
        matches(
          RegExp(r'^\[data-arcane-surface\]\s+\[data-arcane-surface\]:not\('),
        ),
      );
      final List<RegExpMatch> scopes = RegExp(
        r'\[data-arcane-surface\]:not\(([^)]*)\)',
      ).allMatches(selector).toList();
      expect(scopes, hasLength(1));
      final Set<String> excluded = RegExp(r'data-arcane-surface="([a-z-]+)"')
          .allMatches(scopes.single.group(1)!)
          .map((RegExpMatch m) => m.group(1)!)
          .toSet();
      expect(excluded, _floatingSurfaces);
    },
  );

  testServer('menus and select lists nested in a card are floating layers', (
    ServerTester tester,
  ) async {
    tester.pumpComponent(
      const ArcaneThemeProvider(
        stylesheet: ShadcnStylesheet(),
        child: Card(
          child: Column(
            children: <Widget>[
              ArcaneCombobox<String>(
                id: 'nested-combo',
                options: <ComboboxOption<String>>[
                  ComboboxOption<String>(value: 'a', label: 'A'),
                ],
              ),
              ArcaneDropdownMenu(
                id: 'nested-menu',
                trigger: Text('Open'),
                items: <ArcaneMenuItem>[
                  MenuItemSubmenu(
                    label: 'More',
                    children: <ArcaneMenuItem>[MenuItemAction(label: 'One')],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    final DocumentResponse response = await tester.request('/');
    expect(response.statusCode, 200, reason: response.body);
    final List<String> kinds = RegExp(
      r'data-arcane-surface="([a-z-]+)"',
    ).allMatches(response.body).map((RegExpMatch m) => m.group(1)!).toList();
    expect(kinds.first, 'card');
    // The select list, the menu and its submenu all sit inside the card and
    // must keep their own background, border and shadow.
    expect(kinds.skip(1), hasLength(3));
    for (final String kind in kinds.skip(1)) {
      expect(_floatingSurfaces, contains(kind));
    }
  });

  testServer('a card inside a dialog is a nested surface that flattens', (
    ServerTester tester,
  ) async {
    tester.pumpComponent(
      const ArcaneThemeProvider(
        stylesheet: ShadcnStylesheet(),
        child: ArcaneDialog(
          id: 'nested-dialog',
          isOpen: true,
          title: 'Invite',
          child: Card(child: Text('Invite details')),
        ),
      ),
    );

    final DocumentResponse response = await tester.request('/');
    expect(response.statusCode, 200, reason: response.body);
    final int dialog = response.body.indexOf('data-arcane-surface="dialog"');
    final int card = response.body.indexOf('data-arcane-surface="card"');
    expect(dialog, isNonNegative);
    expect(card, greaterThan(dialog));
    expect(_floatingSurfaces, isNot(contains('card')));
  });

  test('tile-like renderers mark their own visual surfaces', () {
    final List<String> sources = <String>[
      _source('lib/core/rendering/base/gallery_render_base.dart'),
      _source('packages/arcane_jaspr_neon/lib/src/renderers/flexi_cards.dart'),
      _source(
        'packages/arcane_jaspr_shadcn/lib/src/renderers/flexi_cards.dart',
      ),
      _source(
        'packages/arcane_jaspr_neubrutalism/lib/src/renderers/flexi_cards.dart',
      ),
      _source('packages/arcane_jaspr_win95/lib/src/renderers/flexi_cards.dart'),
    ];

    expect(sources.first, contains("'data-arcane-surface': 'gallery-tile'"));
    for (final String source in sources.skip(1)) {
      expect(source, contains("'data-arcane-surface': 'flexi-card'"));
    }
  });

  testServer('card-like surfaces compose as siblings, not nested frames', (
    ServerTester tester,
  ) async {
    tester.pumpComponent(
      ArcaneThemeProvider(
        stylesheet: const ShadcnStylesheet(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Card(child: Text('Compute overview')),
            ArcaneFlexiCardsSimple(
              items: <FlexiCardItem>[
                FlexiCardItem(
                  icon: ArcaneIcon.server(),
                  shortText: 'Compute',
                  longText: 'Managed game compute',
                ),
              ],
            ),
            const ArcaneEmptyState(
              title: 'No nodes',
              variant: EmptyStateStyle.card,
            ),
          ],
        ),
      ),
    );

    final DocumentResponse response = await tester.request('/');
    expect(response.statusCode, 200, reason: response.body);
    expect(response.body, contains('data-arcane-surface="card"'));
    expect(response.body, contains('data-arcane-surface="flexi-card"'));
    expect(response.body, contains('data-arcane-surface="empty-state-card"'));
    expect(
      RegExp(
        r'data-arcane-surface="[^"]+"[^<]*>\s*<[^>]+data-arcane-surface=',
        dotAll: true,
      ).hasMatch(response.body),
      isFalse,
    );
  });
}
