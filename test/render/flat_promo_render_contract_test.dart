import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neon/arcane_jaspr_neon.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:arcane_jaspr_win95/arcane_jaspr_win95.dart';
import 'package:jaspr_test/server_test.dart';

void main() {
  const List<(String, ArcaneStylesheet)> themes = <(String, ArcaneStylesheet)>[
    ('neon', NeonStylesheet()),
    ('shadcn', ShadcnStylesheet()),
    ('neubrutalism', NeubrutalismStylesheet()),
    ('win95', Win95Stylesheet()),
  ];

  for (final (String name, ArcaneStylesheet stylesheet) in themes) {
    testServer('retained promos stay flat and visible under $name', (
      ServerTester tester,
    ) async {
      tester.pumpComponent(
        ArcaneThemeProvider(
          stylesheet: stylesheet,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ArcaneTopAnnouncementBar(
                message: 'Maintenance at 02:00 UTC',
                ctaText: 'Details',
                ctaHref: '/status',
                onDismiss: () {},
              ),
              ArcaneInlineHeroBanner(
                message: 'New region available',
                ctaText: 'View regions',
                ctaHref: '/regions',
                icon: ArcaneIcon.server(),
                onDismiss: () {},
              ),
            ],
          ),
        ),
      );

      final DocumentResponse response = await tester.request('/');
      expect(response.statusCode, 200, reason: response.body);
      for (final String forbidden in <String>[
        'linear-gradient',
        'radial-gradient',
        'backdrop-filter',
        'box-shadow',
        'display:none',
        'display: none',
        'position:fixed',
        'position: fixed',
        'position:absolute',
        'position: absolute',
        'border-radius:var(--radius',
        'border-radius: var(--radius',
      ]) {
        expect(response.body, isNot(contains(forbidden)), reason: forbidden);
      }
      expect(response.body, contains('border-radius: 0'));
      expect(response.body, contains('Maintenance at 02:00 UTC'));
      expect(response.body, contains('New region available'));
    });
  }

  testServer('external dropdown items have one icon and real link semantics', (
    ServerTester tester,
  ) async {
    tester.pumpComponent(
      ArcaneThemeProvider(
        stylesheet: const NeonStylesheet(),
        child: ArcaneDropdownItem(
          label: 'Documentation',
          href: 'https://example.com/docs',
          icon: ArcaneIcon.bookOpen(),
          isExternal: true,
        ),
      ),
    );

    final DocumentResponse response = await tester.request('/');
    expect(response.statusCode, 200, reason: response.body);
    expect(response.body, contains('target="_blank"'));
    expect(response.body, contains('rel="noopener noreferrer"'));
    expect(RegExp(r'<i\b').allMatches(response.body), hasLength(1));
    expect(response.body, isNot(contains('box-shadow')));
  });
}
