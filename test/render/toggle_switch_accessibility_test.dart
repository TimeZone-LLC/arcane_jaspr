import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neon/arcane_jaspr_neon.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:arcane_jaspr_win95/arcane_jaspr_win95.dart';
import 'package:jaspr_test/server_test.dart';

void main() {
  for (final ArcaneStylesheet stylesheet in const <ArcaneStylesheet>[
    ShadcnStylesheet(),
    NeonStylesheet(),
    NeubrutalismStylesheet(),
    Win95Stylesheet(),
  ]) {
    testServer('${stylesheet.id} switches support external row labels', (
      ServerTester tester,
    ) async {
      tester.pumpComponent(
        ArcaneThemeProvider(
          stylesheet: stylesheet,
          child: const Column(
            children: <Widget>[
              ArcaneToggleSwitch(
                id: 'external',
                value: true,
                ariaLabel: 'Follow player',
              ),
              ArcaneToggleSwitch(
                id: 'visible',
                value: false,
                label: 'Lock position',
              ),
            ],
          ),
        ),
      );
      final DocumentResponse response = await tester.request('/');
      expect(response.statusCode, 200);
      final List<String> switches = RegExp(r'<[^>]+role="switch"[^>]*>')
          .allMatches(response.body)
          .map((RegExpMatch match) => match.group(0)!)
          .toList();
      expect(switches, hasLength(2));
      expect(switches.first, contains('aria-label="Follow player"'));
      expect(switches.first, isNot(contains('aria-labelledby')));
      expect(switches.last, contains('aria-labelledby="visible-label"'));
      expect(response.body, contains('id="visible-label"'));
      expect(response.body, isNot(contains('id="external-label"')));
    });
  }
}
