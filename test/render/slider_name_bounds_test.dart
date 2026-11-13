// ArcaneSlider can name its thumb without drawing a label, and drop the
// min/max row under the track.

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:jaspr_test/server_test.dart';

Future<String> _render(ServerTester tester, Widget child) async {
  tester.pumpComponent(
    ArcaneThemeProvider(stylesheet: const ShadcnStylesheet(), child: child),
  );
  final DocumentResponse res = await tester.request('/');
  expect(res.statusCode, 200, reason: res.body);
  return res.body;
}

void main() {
  testServer('ariaLabel names the thumb without a drawn label', (
    ServerTester tester,
  ) async {
    final String html = await _render(
      tester,
      const ArcaneSlider(
        value: 40,
        ariaLabel: 'Opacity',
        showValue: false,
        showBounds: false,
      ),
    );
    expect(html, contains('role="slider"'));
    expect(html, contains('aria-label="Opacity"'));
    expect(RegExp('>Opacity<').hasMatch(html), isFalse);
    expect(RegExp(r'>\s*100\s*<').hasMatch(html), isFalse);
  });

  testServer('without the new options the bounds row stays', (
    ServerTester tester,
  ) async {
    final String html = await _render(
      tester,
      const ArcaneSlider(value: 40, showValue: false),
    );
    expect(RegExp(r'>\s*100\s*<').hasMatch(html), isTrue);
    expect(html.contains('aria-label='), isFalse);
  });
}
