import 'dart:io';

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/component/card/flexi_cards.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:jaspr_test/server_test.dart';

String _source(String path) => File(path).readAsStringSync();

void main() {
  test('shared stylesheet flattens every nested marked surface', () {
    final String baseCss = _source('lib/stylesheets/base_css.dart');

    expect(baseCss, contains('[data-arcane-surface] [data-arcane-surface]'));
    expect(baseCss, contains('background: transparent !important'));
    expect(baseCss, contains('border-color: transparent !important'));
    expect(baseCss, contains('box-shadow: none !important'));
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
