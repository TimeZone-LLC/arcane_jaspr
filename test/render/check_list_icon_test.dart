import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/component/view/check_list.dart';
import 'package:arcane_jaspr_neon/arcane_jaspr_neon.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:jaspr_test/server_test.dart';

void main() {
  for (final ArcaneStylesheet stylesheet in <ArcaneStylesheet>[
    const NeonStylesheet(),
    const NeubrutalismStylesheet(),
  ]) {
    testServer('${stylesheet.runtimeType} checklists render decorative icons', (
      ServerTester tester,
    ) async {
      tester.pumpComponent(
        ArcaneThemeProvider(
          stylesheet: stylesheet,
          child: const ArcaneCheckList(
            items: <String>['Paper ready', 'Ink mixed'],
          ),
        ),
      );

      final DocumentResponse response = await tester.request('/');
      expect(response.statusCode, 200);
      expect(response.body, isNot(contains('[check]')));
      expect(response.body, contains('Paper ready'));
      expect(response.body, contains('Ink mixed'));
      final List<RegExpMatch> icons = RegExp(
        r'<span[^>]*class="[^"]*-check-item-icon"[^>]*aria-hidden="true"[^>]*>\s*<i\b',
      ).allMatches(response.body).toList();
      expect(icons, hasLength(2));
    });
  }
}
