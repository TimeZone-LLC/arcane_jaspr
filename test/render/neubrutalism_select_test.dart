import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/component/input/native_select.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:jaspr_test/server_test.dart';

void main() {
  for (final NeubrutalismVariant variant in NeubrutalismVariant.values) {
    testServer(
      '${variant.name} selects expose a themed listbox and form backing',
      (ServerTester tester) async {
        tester.pumpComponent(
          ArcaneThemeProvider(
            stylesheet: NeubrutalismStylesheet(variant: variant),
            child: const Column(
              children: <Widget>[
                ArcaneSelect(
                  id: 'category',
                  name: 'category',
                  label: 'Category',
                  value: 'art',
                  required: true,
                  error: 'Choose an available category',
                  options: <ArcaneSelectOption>[
                    ArcaneSelectOption(value: 'art', label: 'Art'),
                    ArcaneSelectOption(
                      value: 'music',
                      label: 'Music',
                      disabled: true,
                    ),
                  ],
                ),
                ArcaneNativeSelect(
                  id: 'legacy',
                  disabled: true,
                  options: <ArcaneSelectOption>[],
                ),
              ],
            ),
          ),
        );
        final DocumentResponse response = await tester.request('/');
        expect(response.statusCode, 200);
        final String html = response.body;
        final List<String> selects = RegExp(
          r'<select\b[^>]*>',
        ).allMatches(html).map((RegExpMatch match) => match.group(0)!).toList();
        expect(selects, hasLength(2));
        for (final String select in selects) {
          expect(select, contains('hidden'));
          expect(select, contains('tabindex="-1"'));
          expect(select, contains('aria-hidden="true"'));
        }
        expect(selects.first, contains('name="category"'));
        expect(selects.first, contains('required="true"'));
        expect(html, contains('<button id="category"'));
        expect(html, contains('for="category"'));
        expect(html, contains('aria-describedby="category-error"'));
        expect(html, contains('role="listbox"'));
        expect(html, contains('role="option"'));
        expect(html, contains('data-label="Music"'));
        expect(html, contains('aria-disabled="true"'));
      },
    );
  }
}
