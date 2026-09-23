import 'dart:io';

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neon/arcane_jaspr_neon.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:jaspr_test/server_test.dart';

Future<String> _render(
  ServerTester tester,
  ArcaneStylesheet stylesheet,
  Widget child,
) async {
  tester.pumpComponent(
    ArcaneThemeProvider(stylesheet: stylesheet, child: child),
  );
  final DocumentResponse response = await tester.request('/');
  expect(response.statusCode, 200, reason: response.body);
  return response.body;
}

void _expectNoDirectionalBorder(String html) {
  expect(html, isNot(contains('border-left:')));
  expect(html, isNot(contains('border-right:')));
  expect(html, isNot(contains('border-top:')));
  expect(html, isNot(contains('border-bottom:')));
}

void main() {
  for (final (String name, ArcaneStylesheet stylesheet)
      in <(String, ArcaneStylesheet)>[
        ('shadcn', const ShadcnStylesheet()),
        ('neubrutalism', const NeubrutalismStylesheet()),
      ]) {
    testServer('accent alert uses a uniform perimeter under $name', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        stylesheet,
        const ArcaneAlert.success(
          title: 'Published',
          variant: AlertStyle.accent,
        ),
      );

      _expectNoDirectionalBorder(html);
      expect(html, contains('border:'));
    });
  }

  for (final (String name, ArcaneStylesheet stylesheet)
      in <(String, ArcaneStylesheet)>[
        ('shadcn', const ShadcnStylesheet()),
        ('neon', const NeonStylesheet()),
        ('neubrutalism', const NeubrutalismStylesheet()),
      ]) {
    testServer('accent cards use a uniform perimeter under $name', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        stylesheet,
        const Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            FeatureCard(
              title: 'Vertical',
              description: 'Complete border',
              accentColor: '#2563eb',
            ),
            FeatureCard(
              title: 'Horizontal',
              description: 'Complete border',
              horizontal: true,
              accentColor: '#2563eb',
            ),
            TestimonialCard(
              quote: 'Complete border',
              authorName: 'Arcane',
              accentColor: '#2563eb',
              showAccentBorder: true,
            ),
          ],
        ),
      );

      _expectNoDirectionalBorder(html);
      expect(html, contains('border-color: #2563eb'));
    });
  }

  test('Neon cards and alerts do not use clipped accent strips', () {
    final String css = const NeonStylesheet().componentCss;

    expect(css, isNot(contains('.neon-card.clickable::before')));
    expect(css, isNot(contains('border-left: 3px solid var(--primary)')));
    expect(css, isNot(contains('border-left-color: var(--destructive)')));
    expect(css, contains('border: 2px solid var(--primary)'));
    expect(css, contains('border-color: var(--success)'));
  });

  test('prose callouts use a complete border', () {
    expect(arcaneCalloutStyles, isNot(contains('border-left:')));
    expect(arcaneCalloutStyles, contains('border: 1px solid var(--border)'));
  });

  test('docs do not teach or ship rounded one-sided accents', () {
    final String docsCss = File(
      'arcane_jaspr_docs/arcane_jaspr_docs_web/web/styles.css',
    ).readAsStringSync();
    final String borderGuide = File(
      'arcane_jaspr_docs/arcane_jaspr_docs_web/content/docs/styles/borders.md',
    ).readAsStringSync();

    expect(docsCss, isNot(contains('border-left-width: 4px')));
    expect(docsCss, isNot(contains('border-left-color: #')));
    expect(docsCss, isNot(contains('box-shadow: inset 2px 0 0')));
    expect(docsCss, isNot(contains('box-shadow: inset 0 -1px 0')));
    expect(borderGuide, isNot(contains('Accent Left Border')));
    expect(
      borderGuide,
      isNot(contains("'border-left': '4px solid var(--arcane-accent)'")),
    );
  });
}
