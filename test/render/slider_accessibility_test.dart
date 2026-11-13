import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neon/arcane_jaspr_neon.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:arcane_jaspr_win95/arcane_jaspr_win95.dart';
import 'package:jaspr_test/server_test.dart';

/// The markup of the slider whose id is [id], up to the next slider.
String _slider(String html, String id) {
  final int start = html.indexOf('data-arcane-slider="$id"');
  expect(start, isNot(-1), reason: 'slider $id is rendered');
  final int next = html.indexOf('data-arcane-slider="', start + 1);
  return html.substring(start, next == -1 ? html.length : next);
}

List<String> _thumbs(String markup) => RegExp(
  r'<[^>]+role="slider"[^>]*>',
).allMatches(markup).map((RegExpMatch match) => match.group(0)!).toList();

void main() {
  for (final ArcaneStylesheet stylesheet in const <ArcaneStylesheet>[
    ShadcnStylesheet(),
    NeonStylesheet(),
    NeubrutalismStylesheet(),
    Win95Stylesheet(),
  ]) {
    testServer('${stylesheet.id} sliders can be named by their row', (
      ServerTester tester,
    ) async {
      tester.pumpComponent(
        ArcaneThemeProvider(
          stylesheet: stylesheet,
          child: const Column(
            children: <Widget>[
              ArcaneSlider(
                id: 'scrub',
                value: 40,
                max: 80,
                showValue: false,
                showBounds: false,
                ariaLabel: 'Scrub',
                ariaValueText: '2.0 s of 4.0 s',
              ),
              ArcaneSlider(id: 'plain', value: 40, max: 80, showValue: false),
              ArcaneSlider(
                id: 'both',
                value: 10,
                label: 'Volume',
                ariaLabel: 'Music volume',
              ),
              ArcaneSlider.range(
                id: 'price',
                minValue: 10,
                maxValue: 20,
                label: 'Price',
                showValue: false,
                ariaValueText: '10 to 20',
              ),
            ],
          ),
        ),
      );
      final DocumentResponse response = await tester.request('/');
      expect(response.statusCode, 200);
      final String html = response.body;

      final String scrub = _slider(html, 'scrub');
      expect(_thumbs(scrub).single, contains('aria-label="Scrub"'));
      expect(
        _thumbs(scrub).single,
        contains('aria-valuetext="2.0 s of 4.0 s"'),
      );
      expect(
        scrub,
        isNot(contains('<span')),
        reason: 'no label, value or min/max row',
      );

      final String plain = _slider(html, 'plain');
      expect(_thumbs(plain).single, isNot(contains('aria-label')));
      expect(_thumbs(plain).single, isNot(contains('aria-valuetext')));
      expect(plain, contains('>80</span>'), reason: 'the min/max row stays');

      final String both = _slider(html, 'both');
      expect(_thumbs(both).single, contains('aria-label="Music volume"'));
      expect(both, contains('>Volume</span>'), reason: 'the label row stays');

      final List<String> price = _thumbs(_slider(html, 'price'));
      expect(price, hasLength(2));
      expect(price.first, contains('aria-label="Price minimum"'));
      expect(price.last, contains('aria-label="Price maximum"'));
      for (final String thumb in price) {
        expect(thumb, isNot(contains('aria-valuetext')));
      }
    });
  }
}
