// Proves the newly-shipped StatCard family renders end-to-end (contract ->
// widget -> per-theme renderer) under all three stylesheets.

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neon/arcane_jaspr_neon.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:jaspr_test/server_test.dart';

Future<String> _render(
  ServerTester tester,
  ArcaneStylesheet sheet,
  Widget child,
) async {
  tester.pumpComponent(ArcaneThemeProvider(stylesheet: sheet, child: child));
  final DocumentResponse res = await tester.request('/');
  expect(res.statusCode, 200, reason: res.body);
  return res.body;
}

void main() {
  for (final (String name, ArcaneStylesheet sheet, String cls)
      in <(String, ArcaneStylesheet, String)>[
        ('shadcn', const ShadcnStylesheet(), 'arcane-stat-card'),
        ('neon', const NeonStylesheet(), 'neon-stat-card'),
        (
          'neubrutalism',
          const NeubrutalismStylesheet(),
          'neubrutalism-stat-card',
        ),
      ]) {
    testServer('StatCard renders its content under $name', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        sheet,
        const StatCard(
          label: 'Uptime',
          value: '99.9%',
          trend: '+0.1',
          description: 'last 30 days',
        ),
      );
      expect(html.contains('class="$cls"'), isTrue);
      expect(html.contains('Uptime'), isTrue);
      expect(html.contains('99.9%'), isTrue);
      expect(html.contains('last 30 days'), isTrue);
    });

    testServer('StatCardRow lays out a grid under $name', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        sheet,
        const StatCardRow(
          columns: 2,
          cards: <Widget>[
            StatCard(label: 'A', value: '1'),
            StatCard(label: 'B', value: '2'),
          ],
        ),
      );
      expect(html.contains('class="$cls-row"'), isTrue);
      expect(html.contains('grid-template-columns: repeat(2'), isTrue);
    });

    testServer('StatCard honors a literal styles override under $name', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        sheet,
        const StatCard(
          label: 'X',
          value: '1',
          styles: ArcaneStyleData(borderRadius: Radius.md),
        ),
      );
      expect(
        html.contains('border-radius: var(--arcane-radius-md, 8px)'),
        isTrue,
      );
    });

    testServer('StatCard shows its unit, footer and label limit under $name', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        sheet,
        const StatCard(
          label: 'Loaded chunks',
          value: '185',
          unit: 'chunks',
          labelLines: 1,
          footer: Text('Sparkline'),
        ),
      );
      expect(html, contains('>185</span>'));
      expect(html, contains('white-space: nowrap">chunks</span>'));
      expect(html, contains('-webkit-line-clamp: 1'));
      expect(html, contains('title="Loaded chunks"'));
      expect(html, contains('data-no-tooltip'));
      expect(html, contains('Sparkline'));
      expect(
        html.indexOf('Sparkline'),
        greaterThan(html.indexOf('>185</span>')),
      );
    });

    testServer('StatCard without the options adds nothing under $name', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        sheet,
        const StatCard(label: 'Loaded chunks', value: '185'),
      );
      expect(html, isNot(contains('white-space: nowrap')));
      expect(html, isNot(contains('-webkit-line-clamp')));
      expect(html, isNot(contains('title="Loaded chunks"')));
      expect(html, isNot(contains('data-no-tooltip')));
    });
  }
}
