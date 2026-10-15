import 'dart:math' as math;

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_ascii/arcane_jaspr_ascii.dart';
import 'package:jaspr_test/server_test.dart';

double _luminance(int color) {
  double linear(int channel) {
    final double value = channel / 255;
    return value <= 0.04045
        ? value / 12.92
        : math.pow((value + 0.055) / 1.055, 2.4).toDouble();
  }

  return 0.2126 * linear((color >> 16) & 255) +
      0.7152 * linear((color >> 8) & 255) +
      0.0722 * linear(color & 255);
}

double _contrast(int first, int second) {
  final double a = _luminance(first);
  final double b = _luminance(second);
  return (math.max(a, b) + 0.05) / (math.min(a, b) + 0.05);
}

Map<String, int> _palette(String css, String selector) {
  final String block = RegExp(
    '${RegExp.escape(selector)} \\{([^}]+)\\}',
  ).allMatches(css).last.group(1)!;
  return <String, int>{
    for (final RegExpMatch match in RegExp(
      r'--([a-z-]+): #([0-9a-f]{6});',
    ).allMatches(block))
      match.group(1)!: int.parse(match.group(2)!, radix: 16),
  };
}

void main() {
  const AsciiStylesheet stylesheet = AsciiStylesheet();

  testServer('calendar layout exists without fallback scripts', (
    ServerTester tester,
  ) async {
    tester.pumpComponent(
      ArcaneApp(
        stylesheet: stylesheet,
        includeFallbackScripts: false,
        home: ArcaneCalendar(month: DateTime(2026, 4)),
      ),
    );
    final DocumentResponse response = await tester.request('/');
    expect(response.statusCode, 200);
    expect(response.body, contains('grid-template-columns: repeat(7, 1fr)'));
    expect(
      RegExp('class="arcane-calendar-day ').allMatches(response.body),
      hasLength(42),
    );
  });

  testServer('charts reserve bar space and handle zero-value datasets', (
    ServerTester tester,
  ) async {
    tester.pumpComponent(
      const ArcaneThemeProvider(
        stylesheet: stylesheet,
        child: ArcaneChart(
          points: <ArcaneChartPoint>[
            ArcaneChartPoint(label: 'First', value: 0),
            ArcaneChartPoint(label: 'Second', value: 0),
          ],
        ),
      ),
    );
    final DocumentResponse response = await tester.request('/');
    expect(response.body, contains('width: 100%'));
    expect(response.body, contains('min-width: 1rem'));
    expect(response.body, contains('class="arcane-chart-fill"'));
    expect(response.body, contains('width: 0.00%'));
    expect(response.body, isNot(contains('NaN')));
  });

  for (final String mode in <String>['', '.dark']) {
    test(
      'Ascii $mode text, boundaries, and focus meet contrast thresholds',
      () {
        final Map<String, int> palette = _palette(
          stylesheet.componentCss,
          '#arcane-root$mode.arcane-theme-ascii',
        );
        for (final String surface in <String>['background', 'card']) {
          for (final String text in <String>[
            'foreground',
            'muted-foreground',
          ]) {
            expect(
              _contrast(palette[text]!, palette[surface]!),
              greaterThanOrEqualTo(4.5),
              reason: '$text on $surface',
            );
          }
          for (final String boundary in <String>['input', 'ring']) {
            expect(
              _contrast(palette[boundary]!, palette[surface]!),
              greaterThanOrEqualTo(3),
              reason: '$boundary on $surface',
            );
          }
        }
        expect(
          _contrast(palette['primary']!, palette['primary-foreground']!),
          greaterThanOrEqualTo(4.5),
        );
      },
    );
  }

  test(
    'stylesheets retain all Arcane renderer contracts and distinct modes',
    () {
      expect(stylesheet.id, 'ascii');
      expect(stylesheet.name, 'Ascii');
      expect(stylesheet.lightSeed.isDark, isFalse);
      expect(stylesheet.darkSeed.isDark, isTrue);
      expect(stylesheet.radius.md, '0');
      expect(stylesheet.baseCss, contains('prefers-reduced-motion: reduce'));
      expect(stylesheet.baseCss, contains('forced-colors: active'));
      expect(stylesheet.componentCss, isNot(contains('.arcane-theme-shadcn')));
    },
  );

  testServer('animated text has one accessible label and whole graphemes', (
    ServerTester tester,
  ) async {
    tester.pumpComponent(const AsciiText('Cafe\u0301 <ok>', cursor: true));
    final DocumentResponse response = await tester.request('/');
    expect(response.statusCode, 200);
    expect(response.body, contains('>Cafe\u0301 &lt;ok&gt;</span>'));
    expect(response.body, contains('aria-hidden="true"'));
    expect(response.body, contains('>e\u0301</span>'));
    expect(response.body, isNot(contains('><ok>')));
    expect(response.body, contains('ascii-text-cursor'));
  });

  testServer('zero duration and disabled motion render text directly', (
    ServerTester tester,
  ) async {
    tester.pumpComponent(const AsciiText('Ready', duration: Duration.zero));
    final DocumentResponse response = await tester.request('/');
    expect(response.body, contains('Ready'));
    expect(response.body, isNot(contains('ascii-text-char')));
    expect(response.body, isNot(contains('aria-hidden')));
  });

  testServer('datum values remain readable and decoration stays hidden', (
    ServerTester tester,
  ) async {
    tester.pumpComponent(
      const AsciiDatum(label: 'SAMPLE RATE', value: '20 Hz', animated: false),
    );
    final DocumentResponse response = await tester.request('/');
    expect(response.body, contains('SAMPLE RATE'));
    expect(response.body, contains('20 Hz'));
    expect(response.body, contains('data-animated="false"'));
    expect(response.body, contains('aria-hidden="true"'));
  });

  testServer('existing controls preserve semantics under Ascii', (
    ServerTester tester,
  ) async {
    tester.pumpComponent(
      const ArcaneThemeProvider(
        stylesheet: stylesheet,
        child: Column(
          children: <Widget>[
            Button(label: 'Save', disabled: true),
            ArcaneCheckbox(checked: true, label: 'Capture'),
            Card(child: Text('Telemetry')),
          ],
        ),
      ),
    );
    final DocumentResponse response = await tester.request('/');
    expect(response.statusCode, 200);
    expect(response.body, contains('disabled'));
    expect(response.body, contains('aria-checked="true"'));
    expect(response.body, contains('arcane-card'));
    expect(response.body, contains('Telemetry'));
  });
}
