import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/component/input/native_select.dart';
import 'package:arcane_jaspr/stylesheets/base_css.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:arcane_jaspr_win95/arcane_jaspr_win95.dart';
import 'package:jaspr_test/server_test.dart';

const Win95Stylesheet _win95 = Win95Stylesheet();
const ShadcnStylesheet _shadcn = ShadcnStylesheet();

/// Body of the first CSS rule whose selector text starts with [selector].
String _rule(String css, String selector) {
  final int start = css.indexOf(selector);
  expect(start, isNonNegative, reason: 'Missing CSS selector: $selector');
  final int open = css.indexOf('{', start);
  final int close = css.indexOf('}', open);
  return css.substring(open + 1, close);
}

/// Every opening tag whose class list contains [className].
List<String> _tags(String html, String className) =>
    RegExp(r'<[^>]+class="([^"]*)"[^>]*>')
        .allMatches(html)
        .where((RegExpMatch m) {
          return m.group(1)!.split(' ').contains(className);
        })
        .map((RegExpMatch m) => m.group(0)!)
        .toList();

String _tag(String html, String className) {
  final List<String> tags = _tags(html, className);
  expect(tags, isNotEmpty, reason: 'Missing .$className');
  return tags.first;
}

/// The opening tag that carries `id="[id]"`.
String _tagById(String html, String id) {
  final RegExpMatch? match = RegExp(
    '<[^>]+\\sid="${RegExp.escape(id)}"[^>]*>',
  ).firstMatch(html);
  expect(match, isNotNull, reason: 'Missing #$id');
  return match!.group(0)!;
}

String _compact(String text) => text.replaceAll(' ', '');

Future<String> _render(
  ServerTester tester,
  ArcaneStylesheet sheet,
  Widget child,
) async {
  tester.pumpComponent(ArcaneThemeProvider(stylesheet: sheet, child: child));
  final DocumentResponse response = await tester.request('/');
  expect(response.statusCode, 200, reason: response.body);
  return response.body;
}

const List<SelectOptionProps<String>> _tagOptions = <SelectOptionProps<String>>[
  SelectOptionProps<String>(value: 'art', label: 'Art'),
  SelectOptionProps<String>(value: 'music', label: 'Music'),
];

Widget _multiSelect() => Builder(
  builder: (BuildContext context) => context.renderers.select<String>(
    const SelectProps<String>(
      id: 'tags',
      label: 'Tags',
      multiSelect: true,
      values: <String>['art'],
      options: _tagOptions,
      filteredOptions: _tagOptions,
    ),
  ),
);

ArcaneDropdownMenu _checkMenu() => const ArcaneDropdownMenu(
  id: 'view-menu',
  trigger: Text('View'),
  items: <ArcaneMenuItem>[
    MenuItemCheckbox(label: 'Grid', checked: true),
    MenuItemRadio(label: 'Large', group: 'size', value: 'lg', selected: true),
  ],
);

void main() {
  group('Win95 native select', () {
    final String css = _win95.baseCss;

    test('draws one arrow: the chevron span is the raised button', () {
      final String select = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .arcane-select {',
      );
      expect(select, isNot(contains('background-image')));
      // Matches the Win95 text input height table (sm 38 / md 46 / lg 54).
      expect(select, contains('height: 38px !important;'));
      expect(
        css,
        contains(
          '#arcane-root.arcane-theme-win95 .arcane-select[data-size="md"] {\n'
          '  height: 46px !important;',
        ),
      );
      expect(
        css,
        contains(
          '#arcane-root.arcane-theme-win95 .arcane-select[data-size="lg"] {\n'
          '  height: 54px !important;',
        ),
      );
      expect(select, contains('font-size: 1.219rem !important;'));

      final String button = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .arcane-native-select-chevron {',
      );
      expect(button, contains('background: var(--w95-face) !important;'));
      expect(
        button,
        contains('box-shadow: var(--w95-raised-thin) !important;'),
      );
      expect(button, contains('transform: none !important;'));

      final String glyph = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .arcane-native-select-chevron :is(svg, i) {',
      );
      expect(glyph, contains('display: none !important;'));

      // The triangle is drawn in the face text token, so the dark scheme
      // flips it with no second bitmap.
      final String arrow = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .arcane-native-select-chevron::after {',
      );
      expect(arrow, contains('border-top: 5px solid var(--w95-face-text)'));
    });

    test('the native select label matches the Win95 field label', () {
      final String label = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .arcane-select-wrapper > label {',
      );
      expect(label, contains('font-weight: 700 !important;'));
      expect(label, contains('font-size: 1rem !important;'));
      expect(label, contains('color: var(--w95-face-text) !important;'));
    });

    testServer('renders a single chevron in a shell the width of the select', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        _win95,
        const ArcaneNativeSelect(
          id: 'registration',
          label: 'Registration',
          value: 'open',
          options: <ArcaneSelectOption>[
            ArcaneSelectOption(label: 'Open', value: 'open'),
          ],
        ),
      );

      expect(_tags(html, 'arcane-native-select-chevron'), hasLength(1));
      expect(html, contains('for="registration"'));
      final String shell = _compact(_tag(html, 'arcane-native-select-shell'));
      expect(shell, contains('display:inline-block'));
      expect(shell, contains('width:fit-content'));
      expect(shell, contains('max-width:100%'));
      expect(shell, isNot(contains('align-self')));
      expect(_compact(_tag(html, 'arcane-select')), contains('display:block'));
    });
  });

  group('Win95 checkbox', () {
    final String css = _win95.baseCss;

    testServer('stacks the description and aligns the well to line one', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        _win95,
        const Column(
          children: <Widget>[
            ArcaneCheckbox(id: 'plain', checked: true, label: 'Plain'),
            ArcaneCheckbox(
              id: 'described',
              checked: false,
              label: 'Email me',
              description: 'Weekly digest.',
            ),
          ],
        ),
      );

      final List<String> wrappers = _tags(
        html,
        'win95-checkbox-wrapper',
      ).map(_compact).toList();
      final List<String> boxes = _tags(
        html,
        'win95-checkbox-box',
      ).map(_compact).toList();
      expect(wrappers[0], contains('align-items:center'));
      expect(boxes[0], isNot(contains('margin-top')));
      expect(wrappers[1], contains('align-items:flex-start'));
      expect(boxes[1], contains('margin-top:2px'));

      final String label = _compact(_tagById(html, 'described-label'));
      final String description = _compact(
        _tagById(html, 'described-description'),
      );
      expect(label, contains('display:block'));
      expect(description, contains('display:block'));
      expect(description, contains('margin-top:0.2rem'));
      expect(description, contains('font-size:0.875em'));
    });

    test('a disabled checkbox greys its well, tick and caption', () {
      final String well = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-checkbox-box[data-disabled="true"] {',
      );
      expect(well, contains('background: var(--w95-face);'));
      final String tick = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-checkbox-box[data-disabled="true"]::after {',
      );
      expect(tick, contains('background-color: var(--w95-disabled-text);'));

      final String engraved = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-checkbox-wrapper[data-disabled="true"],',
      );
      expect(engraved, contains('color: var(--w95-disabled-text) !important;'));
      expect(
        engraved,
        contains('text-shadow: 1px 1px 0 var(--w95-hilite) !important;'),
      );
    });

    test('bare native check boxes and radios take the Win95 bitmaps', () {
      final String box = _rule(
        css,
        '#arcane-root.arcane-theme-win95 input[type="checkbox"]:not([role="switch"]) {',
      );
      expect(box, contains('appearance: none !important;'));
      expect(box, contains('width: 13px !important;'));
      expect(box, contains('height: 13px !important;'));
      expect(box, contains('box-shadow: var(--w95-sunken) !important;'));

      final String checked = _rule(
        css,
        '#arcane-root.arcane-theme-win95 input[type="checkbox"]:not([role="switch"]):checked {',
      );
      // The 7x7 tick as seven 1x2 columns in the field text colour.
      expect(
        RegExp(r'linear-gradient\(var\(--w95-bare-tick\)').allMatches(checked),
        hasLength(7),
      );

      final String radio = _rule(
        css,
        '#arcane-root.arcane-theme-win95 :is(.win95-radio-control, input[type="radio"]) {',
      );
      expect(radio, contains('appearance: none'));
      expect(radio, contains('width: 12px'));
    });
  });

  group('Win95 select list and menus', () {
    final String css = _win95.baseCss;

    test('the select list floats above later fields', () {
      final int start = css.indexOf(
        '/* ---------- Custom select dropdown surface ----------',
      );
      final String rule = _rule(
        css.substring(start),
        '#arcane-root.arcane-theme-win95 .win95-select-dropdown {',
      );
      expect(rule, contains('z-index: 1000 !important;'));
    });

    test('menu rows use the theme font even when they are buttons', () {
      final String item = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-context-menu-item,\n'
        '#arcane-root.arcane-theme-win95 .win95-dropdown-item,\n'
        '#arcane-root.arcane-theme-win95 .win95-menubar-item {',
      );
      expect(item, contains('font-family: var(--font-sans) !important;'));
    });

    testServer('select lists and menus open flush with no inner gutter', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        _win95,
        Column(children: <Widget>[_multiSelect(), _checkMenu()]),
      );

      final String list = _tag(html, 'win95-select-dropdown');
      expect(list, contains('data-arcane-anchor-offset="0"'));
      expect(
        _compact(_tag(html, 'win95-select-options')),
        contains('padding:0'),
      );
      final String menu = _tag(html, 'win95-dropdown-menu');
      expect(menu, contains('data-arcane-anchor-offset="0"'));
    });

    testServer('menus and multi-select share the checkbox tick', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        _win95,
        Column(children: <Widget>[_multiSelect(), _checkMenu()]),
      );

      final List<String> indicators = _tags(html, 'arcane-menu-indicator');
      expect(indicators, hasLength(2));
      for (final String indicator in indicators) {
        expect(_compact(indicator), contains('left:6px'));
      }
      final List<String> wells = _tags(html, 'win95-select-option-check');
      expect(wells, hasLength(2));
      expect(_compact(wells.first), contains('width:13px'));

      final String menuTick = _rule(
        css,
        '#arcane-root.arcane-theme-win95 :is(.win95-dropdown-item, .win95-context-menu-item, .win95-menubar-item).checkbox > .arcane-menu-indicator {',
      );
      expect(menuTick, contains('mask-image: var(--w95-check) !important;'));
      final String optionTick = _rule(
        css,
        '#arcane-root.arcane-theme-win95 .win95-select-option[data-arcane-state="selected"] .win95-select-option-check::after {',
      );
      expect(optionTick, contains('mask-image: var(--w95-check);'));
    });
  });

  group('ShadCN checkbox', () {
    test('a disabled checkbox dims once, at the wrapper', () {
      final String css = _shadcn.baseCss;
      expect(css, isNot(contains(".arcane-checkbox[data-disabled='true']")));
    });

    testServer('a one-line checkbox centres its box on the label', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        _shadcn,
        const Column(
          children: <Widget>[
            ArcaneCheckbox(id: 'plain', checked: true, label: 'Plain'),
            ArcaneCheckbox(
              id: 'described',
              checked: false,
              disabled: true,
              label: 'Email me',
              description: 'Weekly digest.',
            ),
          ],
        ),
      );

      final List<String> wrappers = _tags(
        html,
        'arcane-checkbox-wrapper',
      ).map(_compact).toList();
      expect(wrappers[0], contains('align-items:center'));
      expect(wrappers[1], contains('align-items:flex-start'));
      expect(wrappers[1], contains('opacity:0.5'));
    });

    testServer('the multi-select option box uses the 3:1 control border', (
      ServerTester tester,
    ) async {
      final String html = await _render(tester, _shadcn, _multiSelect());
      expect(html, contains('1px solid var(--shadcn-control-border)'));
      expect(html, isNot(contains('1px solid var(--input)')));
    });
  });

  group('Select accessibility', () {
    for (final (String name, ArcaneStylesheet sheet)
        in <(String, ArcaneStylesheet)>[
          ('win95', _win95),
          ('shadcn', _shadcn),
        ]) {
      testServer('$name label, trigger and listbox ids resolve', (
        ServerTester tester,
      ) async {
        final String html = await _render(tester, sheet, _multiSelect());

        expect(html, contains('for="tags-trigger"'));
        final String trigger = _tagById(html, 'tags-trigger');
        expect(trigger, contains('aria-controls="tags"'));
        expect(trigger, contains('aria-expanded="false"'));
        final String listbox = _tagById(html, 'tags');
        expect(listbox, contains('role="listbox"'));
        expect(listbox, contains('aria-multiselectable="true"'));
      });
    }

    test('native option popups follow the active brightness', () {
      const String css = ArcaneBaseCss.shared;
      expect(
        _rule(css, '#arcane-root.light {'),
        contains('color-scheme: light;'),
      );
      expect(
        _rule(css, '#arcane-root.dark {'),
        contains('color-scheme: dark;'),
      );
    });
  });

  test('the legacy scripts leave dropdown menus to the runtime', () {
    // The fallback binder stopped trigger clicks before the runtime saw them,
    // so ShadCN dropdown menus never opened.
    expect(ArcaneScripts.legacy, isNot(contains('bindDropdowns')));
    expect(ArcaneScripts.legacy, isNot(contains("'.arcane-dropdown'")));
  });
}
