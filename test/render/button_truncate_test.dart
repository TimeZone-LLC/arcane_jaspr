// A long label in a narrow button ends in an ellipsis with `truncate`, under
// every stylesheet that renders buttons through ButtonRenderBase.

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
  const String label = 'Purpur » react-ux-purpur-26-3 (Plugin)';

  for (final (String name, ArcaneStylesheet sheet)
      in <(String, ArcaneStylesheet)>[
        ('shadcn', const ShadcnStylesheet()),
        ('neon', const NeonStylesheet()),
        ('neubrutalism', const NeubrutalismStylesheet()),
      ]) {
    testServer('Button truncate cuts the label with an ellipsis under $name', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        sheet,
        Button.outline(
          label: label,
          icon: ArcaneIcon.server(),
          fullWidth: true,
          truncate: true,
          onPressed: () {},
        ),
      );
      final RegExpMatch? match = RegExp(
        r'<span ([^>]*)>Purpur » react-ux-purpur-26-3 \(Plugin\)</span>',
      ).firstMatch(html);
      expect(match, isNotNull, reason: html);
      final String attributes = match!.group(1)!;
      expect(attributes, contains('title="$label"'));
      expect(attributes, contains('data-no-tooltip'));
      expect(attributes, contains('min-width: 0'));
      expect(attributes, contains('overflow: hidden'));
      expect(attributes, contains('text-overflow: ellipsis'));
      expect(attributes, contains('white-space: nowrap'));
      final RegExpMatch? button = RegExp(
        r'<button[^>]*style="([^"]*)"',
      ).firstMatch(html);
      expect(button!.group(1), contains('min-width: 0'));
      expect(button.group(1), contains('max-width: 100%'));
    });

    testServer('Button without truncate keeps a bare label under $name', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        sheet,
        Button.outline(label: label, fullWidth: true, onPressed: () {}),
      );
      expect(html, contains(label));
      expect(html, isNot(contains('data-no-tooltip')));
      expect(html, isNot(contains('text-overflow: ellipsis')));
    });
  }
}
