import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/stylesheets/base_css.dart';
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

Future<String> _render(
  ServerTester tester,
  ArcaneStylesheet theme,
  Widget child,
) async {
  tester.pumpComponent(ArcaneThemeProvider(stylesheet: theme, child: child));
  final DocumentResponse response = await tester.request('/');
  expect(response.statusCode, 200, reason: response.body);
  return response.body;
}

/// The opening tag of the first element whose attributes contain [marker].
String _tag(String html, String marker) {
  final RegExpMatch? match = RegExp(
    '<[a-z]+\\b[^>]*${RegExp.escape(marker)}[^>]*>',
  ).firstMatch(html);
  expect(match, isNotNull, reason: 'no element with $marker in $html');
  return match!.group(0)!;
}

String? _attribute(String tag, String name) =>
    RegExp('\\s$name="([^"]*)"').firstMatch(tag)?.group(1);

String _input(String html) =>
    RegExp(r'<input\b[^>]*>').firstMatch(html)!.group(0)!;

void main() {
  for (final (String name, ArcaneStylesheet theme) in _themes) {
    group('$name field', () {
      testServer('links label, description and error to the control', (
        ServerTester tester,
      ) async {
        final String html = await _render(
          tester,
          theme,
          const ArcaneFormField(
            controlId: 'npc-name',
            invalid: true,
            children: <Widget>[
              ArcaneFieldLabel('Name'),
              TextInput(placeholder: 'Steve'),
              ArcaneFieldDescription('Shown above the head.'),
              ArcaneFieldError('That name is taken.'),
            ],
          ),
        );

        final String root = _tag(html, 'data-slot="field"');
        expect(_attribute(root, 'role'), 'group');
        expect(_attribute(root, 'data-orientation'), 'vertical');
        expect(_attribute(root, 'data-invalid'), 'true');
        expect(root, contains('arcane-field'));

        final String label = _tag(html, 'data-slot="field-label"');
        expect(label, startsWith('<label'));
        expect(_attribute(label, 'for'), 'npc-name');

        final String input = _input(html);
        expect(_attribute(input, 'id'), 'npc-name');
        expect(_attribute(input, 'aria-invalid'), 'true');
        expect(
          _attribute(input, 'aria-describedby'),
          'npc-name-description npc-name-error',
        );

        final String description = _tag(html, 'data-slot="field-description"');
        expect(description, startsWith('<p'));
        expect(_attribute(description, 'id'), 'npc-name-description');

        final String error = _tag(html, 'data-slot="field-error"');
        expect(_attribute(error, 'id'), 'npc-name-error');
        expect(_attribute(error, 'role'), 'alert');
        expect(html, contains('That name is taken.'));
      });

      testServer('generates one control id when none is given', (
        ServerTester tester,
      ) async {
        final String html = await _render(
          tester,
          theme,
          const ArcaneFormField(
            children: <Widget>[
              ArcaneFieldLabel('Title'),
              TextArea(placeholder: 'Write here'),
              ArcaneFieldDescription('Markdown works.'),
            ],
          ),
        );
        final String textarea = RegExp(
          r'<textarea\b[^>]*>',
        ).firstMatch(html)!.group(0)!;
        final String id = _attribute(textarea, 'id')!;
        expect(id, matches(RegExp(r'^arcane-field-\d+$')));
        expect(_attribute(_tag(html, 'data-slot="field-label"'), 'for'), id);
        expect(_attribute(textarea, 'aria-describedby'), '$id-description');
        expect(textarea, isNot(contains('aria-invalid')));
      });

      testServer('marks a disabled field and disables its text control', (
        ServerTester tester,
      ) async {
        final String html = await _render(
          tester,
          theme,
          const ArcaneFormField(
            controlId: 'locked',
            disabled: true,
            children: <Widget>[ArcaneFieldLabel('Locked'), TextInput()],
          ),
        );
        expect(
          _attribute(_tag(html, 'data-slot="field"'), 'data-disabled'),
          'true',
        );
        expect(_attribute(_input(html), 'disabled'), isNotNull);
      });

      testServer('names a native select by the field id', (
        ServerTester tester,
      ) async {
        final String html = await _render(
          tester,
          theme,
          const ArcaneFormField(
            controlId: 'kind',
            orientation: FieldOrientation.horizontal,
            invalid: true,
            children: <Widget>[
              ArcaneFieldLabel('Kind'),
              ArcaneSelect(
                options: <ArcaneSelectOption>[
                  ArcaneSelectOption(label: 'Villager', value: 'villager'),
                ],
              ),
              ArcaneFieldError('Pick a kind.'),
            ],
          ),
        );
        final String select = _tag(html, 'id="kind"');
        expect(select, contains('arcane-select'));
        expect(_attribute(select, 'aria-invalid'), 'true');
        expect(_attribute(select, 'aria-describedby'), 'kind-error');
        expect(
          _attribute(_tag(html, 'data-slot="field-label"'), 'for'),
          'kind',
        );
        expect(html, contains('data-orientation="horizontal"'));
      });

      testServer('labels a switch by the field id and links its help', (
        ServerTester tester,
      ) async {
        final String html = await _render(
          tester,
          theme,
          const ArcaneFormField(
            controlId: 'glow',
            orientation: FieldOrientation.horizontal,
            invalid: true,
            disabled: true,
            children: <Widget>[
              ArcaneFieldContent(
                children: <Widget>[
                  ArcaneFieldLabel('Glow'),
                  ArcaneFieldDescription('Outlines the text.'),
                ],
              ),
              ArcaneToggleSwitch(value: true, ariaLabel: 'Glow'),
            ],
          ),
        );
        final String control = _tag(html, 'role="switch"');
        expect(_attribute(control, 'id'), 'glow');
        expect(_attribute(control, 'aria-describedby'), 'glow-description');
        expect(_attribute(control, 'aria-invalid'), 'true');
        expect(_attribute(control, 'disabled'), isNotNull);
        expect(
          _attribute(_tag(html, 'data-slot="field-label"'), 'for'),
          'glow',
        );
      });

      testServer('leaves a switch outside a field without an element id', (
        ServerTester tester,
      ) async {
        final String html = await _render(
          tester,
          theme,
          const ArcaneToggleSwitch(
            id: 'loose',
            value: false,
            ariaLabel: 'Loose',
          ),
        );
        final String control = _tag(html, 'role="switch"');
        // Win95 names its own button `<id>-control`; no theme moves the
        // switch's id onto the element outside a field.
        expect(_attribute(control, 'id'), isNot('loose'));
        expect(control, isNot(contains('aria-describedby')));
      });

      testServer('puts a required mark and trailing widgets on a title', (
        ServerTester tester,
      ) async {
        final String html = await _render(
          tester,
          theme,
          const ArcaneFormField(
            children: <Widget>[
              ArcaneFieldTitle(
                'Blend',
                required: true,
                trailing: <Widget>[Text('Reset blend')],
              ),
            ],
          ),
        );
        final String title = RegExp(
          r'<div\b[^>]*arcane-field-title[^>]*>.*?</div>',
          dotAll: true,
        ).firstMatch(html)!.group(0)!;
        expect(title, contains('arcane-field-required'));
        expect(title, contains('Reset blend'));
        expect(
          title.indexOf('arcane-field-required'),
          lessThan(title.indexOf('Reset blend')),
        );
      });

      testServer('numbers repeated messages and lists every one', (
        ServerTester tester,
      ) async {
        final String html = await _render(
          tester,
          theme,
          const ArcaneFormField(
            controlId: 'skin',
            children: <Widget>[
              ArcaneFieldLabel('Skin'),
              ArcaneFieldContent(
                children: <Widget>[
                  TextInput(),
                  ArcaneFieldDescription('A player name or a texture URL.'),
                  ArcaneFieldDescription('Changes show on the next spawn.'),
                  ArcaneFieldError(null),
                ],
              ),
            ],
          ),
        );
        expect(
          _attribute(_input(html), 'aria-describedby'),
          'skin-description skin-description-2',
        );
        expect(html, contains('id="skin-description-2"'));
        expect(html, isNot(contains('data-slot="field-error"')));
        expect(_tag(html, 'data-slot="field-content"'), contains('<div'));
      });

      testServer('puts the label column width on the field', (
        ServerTester tester,
      ) async {
        final String html = await _render(
          tester,
          theme,
          const ArcaneFormField(
            orientation: FieldOrientation.responsive,
            labelWidth: '11.25rem',
            children: <Widget>[ArcaneFieldLabel('Name'), TextInput()],
          ),
        );
        final String root = _tag(html, 'data-slot="field"');
        expect(_attribute(root, 'data-orientation'), 'responsive');
        expect(_attribute(root, 'data-label-width'), 'true');
        expect(root, contains('--arcane-field-label-width: 11.25rem'));
      });

      testServer('keeps extra label tools outside the label element', (
        ServerTester tester,
      ) async {
        final String html = await _render(
          tester,
          theme,
          const ArcaneFormField(
            controlId: 'speed',
            children: <Widget>[
              ArcaneFieldLabel(
                'Speed',
                required: true,
                trailing: <Widget>[
                  Button(label: 'About speed', onPressed: null),
                ],
              ),
              TextInput(),
            ],
          ),
        );
        final String slot = _tag(html, 'data-slot="field-label"');
        expect(slot, startsWith('<div'));
        final String label = RegExp(
          r'<label\b[^>]*>(.*?)</label>',
        ).firstMatch(html)!.group(0)!;
        expect(_attribute(label, 'for'), 'speed');
        expect(label, contains('aria-hidden="true"'));
        expect(label, isNot(contains('About speed')));
        expect(html, contains('About speed'));
      });

      testServer('lists several errors once each', (ServerTester tester) async {
        final String html = await _render(
          tester,
          theme,
          const ArcaneFormField(
            controlId: 'id',
            invalid: true,
            children: <Widget>[
              ArcaneFieldLabel('Id'),
              TextInput(),
              ArcaneFieldError.list(<String>[
                'Use lowercase letters.',
                'Use lowercase letters.',
                'Keep it under 32 characters.',
              ]),
            ],
          ),
        );
        final String error = _tag(html, 'data-slot="field-error"');
        expect(_attribute(error, 'id'), 'id-error');
        expect(RegExp('<li').allMatches(html), hasLength(2));
        expect(html, contains('<ul'));
      });

      testServer('groups fields in sets with a legend and a separator', (
        ServerTester tester,
      ) async {
        final String html = await _render(
          tester,
          theme,
          const ArcaneFieldSet(
            disabled: true,
            children: <Widget>[
              ArcaneFieldLegend('Address'),
              ArcaneFieldDescription('Where the parcel goes.'),
              ArcaneFieldGroup(
                children: <Widget>[
                  ArcaneFormField(
                    children: <Widget>[ArcaneFieldLabel('Street'), TextInput()],
                  ),
                  ArcaneFieldSeparator(text: 'or'),
                  ArcaneFormField(
                    children: <Widget>[
                      ArcaneFieldTitle('Pick-up point'),
                      ArcaneFieldDescription('Collect it yourself.'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
        final String fieldset = _tag(html, 'data-slot="field-set"');
        expect(fieldset, startsWith('<fieldset'));
        expect(_attribute(fieldset, 'disabled'), isNotNull);
        final String legend = _tag(html, 'data-slot="field-legend"');
        expect(legend, startsWith('<legend'));
        expect(_attribute(legend, 'data-variant'), 'legend');
        expect(_tag(html, 'data-slot="field-group"'), startsWith('<div'));
        final String separator = _tag(html, 'data-slot="field-separator"');
        expect(_attribute(separator, 'data-content'), 'true');
        expect(html, contains('data-slot="field-separator-content"'));
        final String title = _tag(html, 'arcane-field-title');
        expect(title, startsWith('<div'));
        expect(_attribute(title, 'data-slot'), 'field-label');
      });

      testServer('leaves a text input outside a field unchanged', (
        ServerTester tester,
      ) async {
        final String outside = await _render(
          tester,
          theme,
          const TextInput(id: 'plain'),
        );
        expect(outside, isNot(contains('aria-describedby')));
        expect(outside, isNot(contains('aria-invalid')));
      });
    });
  }

  group('field stylesheet contract', () {
    const String css = ArcaneBaseCss.shared;

    test('responsive fields follow their group, not the viewport', () {
      expect(css, contains('container: field-group / inline-size'));
      expect(css, contains('@container field-group (min-width: 28rem)'));
      final String responsive = css.substring(
        css.indexOf('/* Field: shadcn Field'),
        css.indexOf('/* Field end */'),
      );
      expect(responsive, isNot(contains('@media')));
      expect(
        responsive,
        contains('[data-slot="field"][data-orientation="responsive"]'),
      );
    });

    test('only a choice card lights up for a checked choice', () {
      final RegExp highlight = RegExp(
        r'([^{}]*)\{\s*border-color: var\(--primary\);\s*background-color: '
        r'color-mix\(in srgb, var\(--primary\) 5%',
      );
      final RegExpMatch? rule = highlight.firstMatch(css);
      expect(rule, isNotNull);
      // A checked control on a plain label line (trailing) must not tint it.
      expect(
        rule!.group(1)!.trim(),
        startsWith('[data-slot="field-label"]:has(> [data-slot="field"])'),
      );
    });

    test('every theme ships the field rules', () {
      for (final (String _, ArcaneStylesheet theme) in _themes) {
        expect(theme.baseCss, contains('[data-slot="field-label"]'));
        expect(theme.baseCss, contains('[data-slot="field-error"]'));
      }
    });
  });
}
