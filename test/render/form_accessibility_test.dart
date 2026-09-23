import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neon/arcane_jaspr_neon.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:arcane_jaspr_win95/arcane_jaspr_win95.dart';
import 'package:jaspr_test/server_test.dart';

const List<(String, ArcaneStylesheet)> _themes = <(String, ArcaneStylesheet)>[
  ('shadcn', ShadcnStylesheet()),
  ('neon', NeonStylesheet()),
  ('neubrutalism', NeubrutalismStylesheet()),
  ('win95', Win95Stylesheet()),
];

String _attribute(String html, String name) =>
    RegExp('$name="([^"]*)"').firstMatch(html)!.group(1)!;

Future<String> _render(
  ServerTester tester,
  ArcaneStylesheet theme,
  Widget child,
) async {
  tester.pumpComponent(ArcaneThemeProvider(stylesheet: theme, child: child));
  final DocumentResponse response = await tester.request('/');
  expect(response.statusCode, 200);
  return response.body;
}

void main() {
  for (final (String name, ArcaneStylesheet theme) in _themes) {
    for (final bool affixed in <bool>[false, true]) {
      testServer(
        '$name text field associates label, error and custom help ($affixed)',
        (ServerTester tester) async {
          final String html = await _render(
            tester,
            theme,
            TextInput(
              label: 'Email',
              error: 'Enter an email address',
              helperText: 'Unused helper',
              prefix: affixed ? const Text('@') : null,
              attributes: const <String, String>{
                'aria-describedby': 'external-help',
              },
            ),
          );
          final String control = RegExp(
            r'<input\b[^>]*>',
          ).firstMatch(html)!.group(0)!;
          final String id = _attribute(control, 'id');
          expect(html, contains('for="$id"'));
          expect(control, contains('aria-invalid="true"'));
          expect(
            control,
            contains('aria-describedby="external-help $id-error"'),
          );
          expect(html, contains('id="$id-error"'));
          expect(html, isNot(contains('Unused helper')));
          expect(RegExp(r'<input\b').allMatches(html), hasLength(1));
        },
      );
    }

    testServer('$name generated field identities are distinct and linked', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        theme,
        const Column(
          children: <Widget>[
            TextInput(label: 'Title', helperText: 'Visible title'),
            TextArea(label: 'Description', helperText: 'Visible description'),
            ArcaneSelect(
              label: 'Category',
              error: 'Choose a category',
              options: <ArcaneSelectOption>[],
            ),
          ],
        ),
      );
      final List<String> controls = RegExp(
        r'<(?:input|textarea|select)\b[^>]*>',
      ).allMatches(html).map((RegExpMatch match) => match.group(0)!).toList();
      final Set<String> ids = controls
          .map((String control) => _attribute(control, 'id'))
          .toSet();
      expect(ids, hasLength(3));
      for (final String control in controls) {
        expect(html, contains('for="${_attribute(control, 'id')}"'));
        expect(
          html,
          contains('id="${_attribute(control, 'aria-describedby')}"'),
        );
      }
    });

    testServer(
      '$name explicit id wins over attributes and invalid select has one choice',
      (ServerTester tester) async {
        final String html = await _render(
          tester,
          theme,
          const Column(
            children: <Widget>[
              TextInput(
                id: 'email',
                label: 'Email',
                attributes: <String, String>{'id': 'other'},
              ),
              ArcaneSelect(
                id: 'category',
                value: 'art',
                placeholder: 'Choose',
                options: <ArcaneSelectOption>[
                  ArcaneSelectOption(label: 'Art', value: 'art'),
                ],
              ),
            ],
          ),
        );
        expect(html, contains('for="email"'));
        expect(html, isNot(contains('id="other"')));
        expect(
          RegExp(r'<option\b[^>]*\bselected=').allMatches(html),
          hasLength(1),
        );
      },
    );

    testServer('$name disabled link has no navigation or runtime action', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        theme,
        Button(
          label: 'Unavailable',
          href: '/unavailable',
          disabled: true,
          action: ArcaneInteraction.openDialog('settings'),
        ),
      );
      final String link = RegExp(r'<a\b[^>]*>').firstMatch(html)!.group(0)!;
      expect(link, contains('aria-disabled="true"'));
      expect(link, contains('tabindex="-1"'));
      expect(link, isNot(contains('href=')));
      expect(link, isNot(contains('data-arcane-action=')));
    });

    testServer(
      '$name checkbox has a label and an unlabelled switch retains its group',
      (ServerTester tester) async {
        final String html = await _render(
          tester,
          theme,
          const Column(
            children: <Widget>[
              ArcaneCheckbox(
                id: 'terms',
                checked: false,
                label: 'Accept terms',
                description: 'Required to continue',
              ),
              ArcaneToggleSwitch(id: 'preview', value: false),
            ],
          ),
        );
        expect(html, contains('aria-labelledby="terms-label"'));
        expect(html, contains('id="terms-label"'));
        expect(html, contains('aria-describedby="terms-description"'));
        expect(html, contains('id="terms-description"'));
        expect(
          RegExp(
            r'<[^>]+data-arcane-group="preview"[^>]*data-arcane-group-mode="single"',
          ).hasMatch(html),
          isTrue,
        );
      },
    );
  }
}
