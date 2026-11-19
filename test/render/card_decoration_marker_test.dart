import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:jaspr_test/server_test.dart';

typedef _CardBuilder =
    Widget Function(ArcaneDecoration? decoration, ArcaneStyleData? styles);

Future<String> _rootTag(
  ServerTester tester,
  String surface,
  Widget card,
) async {
  tester.pumpComponent(
    ArcaneThemeProvider(
      stylesheet: const NeubrutalismStylesheet(),
      child: card,
    ),
  );
  final DocumentResponse response = await tester.request('/');
  expect(response.statusCode, 200);
  return RegExp(
    '<(?:div|a|button)\\b[^>]*data-arcane-surface="$surface"[^>]*>',
  ).firstMatch(response.body)!.group(0)!;
}

void main() {
  final Map<String, _CardBuilder> cards = <String, _CardBuilder>{
    'feature-card': (ArcaneDecoration? decoration, ArcaneStyleData? styles) =>
        FeatureCard(
          title: 'Proof',
          description: 'Paper and ink.',
          decoration: decoration,
          styles: styles,
        ),
    'stat-card': (ArcaneDecoration? decoration, ArcaneStyleData? styles) =>
        StatCard(
          label: 'Prints',
          value: '12',
          decoration: decoration,
          styles: styles,
        ),
    'pricing-card': (ArcaneDecoration? decoration, ArcaneStyleData? styles) =>
        PricingCard(
          title: 'Proof',
          price: r'$8',
          decoration: decoration,
          styles: styles,
        ),
    'cta-card': (ArcaneDecoration? decoration, ArcaneStyleData? styles) =>
        CtaCard(
          title: 'Proof',
          ctaText: 'Review',
          decoration: decoration,
          styles: styles,
        ),
    'testimonial-card':
        (ArcaneDecoration? decoration, ArcaneStyleData? styles) =>
            TestimonialCard(
              quote: 'Sample quote.',
              authorName: 'Example',
              decoration: decoration,
              styles: styles,
            ),
  };

  for (final MapEntry<String, _CardBuilder> entry in cards.entries) {
    testServer('${entry.key} default frame remains theme-owned', (
      ServerTester tester,
    ) async {
      final String tag = await _rootTag(
        tester,
        entry.key,
        entry.value(null, null),
      );
      expect(tag, isNot(contains('data-arcane-decorated')));
    });

    testServer('${entry.key} literal custom frame opts out of theme defaults', (
      ServerTester tester,
    ) async {
      final String tag = await _rootTag(
        tester,
        entry.key,
        entry.value(
          null,
          const ArcaneStyleData(
            borderCustom: '5px solid #123456',
            paddingCustom: EdgeInsets.all(37),
          ),
        ),
      );
      expect(tag, contains('data-arcane-decorated'));
      expect(tag, contains('border: 5px solid #123456'));
      expect(tag, matches(RegExp(r'padding: 37(?:\.0)?px')));
    });

    testServer('${entry.key} explicit decoration opts out of theme defaults', (
      ServerTester tester,
    ) async {
      final String tag = await _rootTag(
        tester,
        entry.key,
        entry.value(
          const ArcaneDecoration(color: '#123456', elevation: Elevation.none),
          null,
        ),
      );
      expect(tag, contains('data-arcane-decorated'));
      expect(tag, contains('background: #123456'));
      expect(tag, contains('box-shadow: none'));
    });
  }

  for (final String surface in <String>['link', 'button']) {
    testServer('feature $surface keeps explicit frame metadata on its root', (
      ServerTester tester,
    ) async {
      final String tag = await _rootTag(
        tester,
        'feature-card',
        FeatureCard(
          title: 'Proof',
          description: 'Paper and ink.',
          href: surface == 'link' ? '/proof' : null,
          onTap: surface == 'button' ? () {} : null,
          styles: const ArcaneStyleData(borderCustom: '5px solid #123456'),
        ),
      );
      expect(tag, startsWith(surface == 'link' ? '<a' : '<button'));
      expect(tag, contains('data-arcane-decorated'));
      expect(tag, contains('border: 5px solid #123456'));
    });
  }

  testServer('feature accent is separate from explicit frame decoration', (
    ServerTester tester,
  ) async {
    final String tag = await _rootTag(
      tester,
      'feature-card',
      const FeatureCard(
        title: 'Proof',
        description: 'Paper and ink.',
        accentColor: '#123456',
      ),
    );
    expect(tag, isNot(contains('data-arcane-decorated')));
    expect(tag, contains('data-arcane-accent'));
    expect(tag, contains('--arcane-card-accent: #123456'));
    expect(tag, contains('border-color: #123456'));
  });

  testServer('CTA accent keeps its default theme frame', (
    ServerTester tester,
  ) async {
    final String tag = await _rootTag(
      tester,
      'cta-card',
      const CtaCard(title: 'Proof', ctaText: 'Review', accentColor: '#123456'),
    );
    expect(tag, isNot(contains('data-arcane-decorated')));
    expect(tag, contains('data-arcane-accent'));
    expect(tag, contains('--arcane-card-accent: #123456'));
  });

  testServer('testimonial accent perimeter is explicit decoration', (
    ServerTester tester,
  ) async {
    final String tag = await _rootTag(
      tester,
      'testimonial-card',
      const TestimonialCard(
        quote: 'Sample quote.',
        authorName: 'Example',
        showAccentBorder: true,
        accentColor: '#123456',
      ),
    );
    expect(tag, contains('data-arcane-decorated'));
    expect(tag, contains('border-color: #123456'));
  });
}
