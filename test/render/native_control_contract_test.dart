import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/component/input/native_select.dart';
import 'package:arcane_jaspr/stylesheets/base_css.dart';
import 'package:arcane_jaspr_neon/arcane_jaspr_neon.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:jaspr_test/server_test.dart';

String _openingTagForClass(String html, String className) {
  final Iterable<RegExpMatch> matches = RegExp(
    r'<[^>]+class="([^"]*)"[^>]*>',
  ).allMatches(html);
  for (final RegExpMatch match in matches) {
    if (match.group(1)!.split(' ').contains(className)) {
      return match.group(0)!;
    }
  }
  fail('Missing .$className in rendered HTML');
}

Future<String> _render(ServerTester tester, Widget widget) async {
  tester.pumpComponent(
    ArcaneThemeProvider(stylesheet: const ShadcnStylesheet(), child: widget),
  );
  final DocumentResponse response = await tester.request('/');
  expect(response.statusCode, 200, reason: response.body);
  return response.body;
}

String _cssRule(String css, String selectorStart) {
  final int selectorIndex = css.indexOf(selectorStart);
  expect(selectorIndex, isNonNegative, reason: 'Missing $selectorStart');
  final int blockStart = css.indexOf('{', selectorIndex);
  final int blockEnd = css.indexOf('}', blockStart);
  expect(blockStart, isNonNegative, reason: 'Missing block for $selectorStart');
  expect(blockEnd, isNonNegative, reason: 'Unclosed block for $selectorStart');
  return css.substring(selectorIndex, blockEnd + 1);
}

void main() {
  for (final ComponentSize size in ComponentSize.values) {
    testServer('public native selects share themed ${size.name} geometry', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        Column(
          children: <Widget>[
            TextInput(size: size, label: 'Name'),
            ArcaneSelect(
              size: size,
              label: 'Category',
              options: const <ArcaneSelectOption>[],
            ),
            ArcaneNativeSelect(
              size: size,
              label: 'Status',
              options: const <ArcaneSelectOption>[],
            ),
          ],
        ),
      );
      final String height = switch (size) {
        ComponentSize.sm => '2rem',
        ComponentSize.md => '2.25rem',
        ComponentSize.lg => '2.5rem',
      };
      final List<String> controls = RegExp(
        r'<(?:input|select)\b[^>]*>',
      ).allMatches(html).map((RegExpMatch match) => match.group(0)!).toList();
      expect(controls, hasLength(3));
      for (final String control in controls) {
        expect(control, contains('height: $height'));
        expect(control, contains('font-size: 0.875rem'));
        expect(control, contains('line-height: 1.25rem'));
      }
      for (final RegExpMatch label in RegExp(
        r'<label\b[^>]*>',
      ).allMatches(html)) {
        expect(label.group(0), contains('font-size: 0.875rem'));
        expect(label.group(0), contains('line-height: 1.25rem'));
      }
    });
  }

  testServer('native select keeps literal styles and native form attributes', (
    ServerTester tester,
  ) async {
    final String html = await _render(
      tester,
      const ArcaneSelect(
        id: 'category',
        name: 'category',
        value: 'art',
        placeholder: 'Choose a category',
        label: 'Category',
        error: 'Choose an available category',
        required: true,
        disabled: true,
        styles: ArcaneStyleData(
          heightCustom: '52px',
          fontSizeCustom: '18px',
          paddingStringCustom: '9px 18px',
        ),
        options: <ArcaneSelectOption>[
          ArcaneSelectOption(label: 'Art', value: 'art'),
          ArcaneSelectOption(label: 'Music', value: 'music', disabled: true),
        ],
      ),
    );
    final String control = _openingTagForClass(html, 'arcane-select');
    expect(control, contains('id="category"'));
    expect(control, contains('name="category"'));
    expect(control, contains('required="true"'));
    expect(control, contains('disabled="true"'));
    expect(control, contains('aria-describedby="category-error"'));
    expect(control, contains('height: 52px'));
    expect(control, contains('font-size: 18px'));
    expect(control, contains('padding: 9px 18px'));
    expect(
      control.indexOf('padding: 9px'),
      greaterThan(control.indexOf('padding-right:')),
    );
    expect(RegExp(r'<option\b[^>]*\bselected=').allMatches(html), hasLength(1));
    expect(html, contains('for="category"'));
    expect(html, contains('value="music" disabled="true"'));
  });

  testServer('native select renders without a theme provider', (
    ServerTester tester,
  ) async {
    tester.pumpComponent(
      const ArcaneSelect(
        id: 'standalone',
        label: 'Category',
        options: <ArcaneSelectOption>[],
      ),
    );
    final DocumentResponse response = await tester.request('/');
    expect(response.statusCode, 200);
    expect(response.body, contains('for="standalone"'));
    expect(
      _openingTagForClass(response.body, 'arcane-select'),
      contains('height: 40px'),
    );
  });

  testServer('native select owns a balanced sibling chevron', (
    ServerTester tester,
  ) async {
    final String html = await _render(
      tester,
      const ArcaneSelect(
        value: 'all',
        fullWidth: true,
        options: <ArcaneSelectOption>[
          ArcaneSelectOption(label: 'All platforms', value: 'all'),
        ],
      ),
    );

    final String shell = _openingTagForClass(
      html,
      'arcane-native-select-shell',
    );
    final String select = _openingTagForClass(html, 'arcane-select');
    final String chevron = _openingTagForClass(
      html,
      'arcane-native-select-chevron',
    );

    expect(shell, contains('data-arcane-field-shell="true"'));
    expect(select, contains('data-arcane-field-control="true"'));
    expect(select.replaceAll(' ', ''), contains('padding-right:40px'));
    expect(select, contains('appearance: none'));
    expect(select, isNot(contains('background-image')));
    expect(chevron.replaceAll(' ', ''), contains('right:14px'));
    expect(chevron, contains('pointer-events: none'));
    expect(chevron, contains('aria-hidden="true"'));
  });

  testServer('shadcn native select ends long text before the chevron', (
    ServerTester tester,
  ) async {
    final String html = await _render(
      tester,
      const ArcaneSelect(
        value: 'all',
        options: <ArcaneSelectOption>[
          ArcaneSelectOption(label: 'All severities', value: 'all'),
        ],
      ),
    );
    final String select = _openingTagForClass(html, 'arcane-select');
    expect(select, contains('padding-right: 40px'));
    expect(select, contains('text-overflow: ellipsis'));
  });

  testServer('selects without a label take an accessible name', (
    ServerTester tester,
  ) async {
    final String html = await _render(
      tester,
      const Column(
        children: <Widget>[
          ArcaneSelect(
            id: 'world',
            ariaLabel: 'World',
            options: <ArcaneSelectOption>[],
          ),
          ArcaneNativeSelect(
            id: 'metric',
            ariaLabel: 'Metric',
            options: <ArcaneSelectOption>[],
          ),
          ArcaneSelect(id: 'plain', options: <ArcaneSelectOption>[]),
        ],
      ),
    );
    final List<String> selects = RegExp(
      r'<select\b[^>]*>',
    ).allMatches(html).map((RegExpMatch match) => match.group(0)!).toList();
    expect(selects, hasLength(3));
    expect(selects[0], contains('aria-label="World"'));
    expect(selects[1], contains('aria-label="Metric"'));
    expect(selects[2], isNot(contains('aria-label')));
  });

  testServer('prefixed text input gives its shell the only perimeter', (
    ServerTester tester,
  ) async {
    final String html = await _render(
      tester,
      TextInput(prefix: ArcaneIcon.search(), placeholder: 'Search'),
    );

    final String shell = _openingTagForClass(
      html,
      'arcane-text-input-container',
    );
    final String input = _openingTagForClass(html, 'arcane-text-input');

    expect(shell, contains('data-arcane-field-shell="true"'));
    expect(input, contains('data-arcane-field-inner="true"'));
    expect(input, contains('data-arcane-field-control="true"'));
  });

  test(
    'shared native-control CSS reserves space and enforces one focus edge',
    () {
      const String css = ArcaneBaseCss.shared;
      final String selectRule = _cssRule(
        css,
        '#arcane-root select:not([multiple])',
      );
      final String shellFocusRule = _cssRule(
        css,
        '#arcane-root:not(.arcane-theme-win95)\n'
        '  [data-arcane-field-shell="true"]:focus-within',
      );
      final String innerControlRule = _cssRule(
        css,
        '#arcane-root:not(.arcane-theme-win95)\n'
        '  [data-arcane-field-shell="true"]\n'
        '  > input[data-arcane-field-inner="true"]',
      );

      expect(selectRule, contains('padding-inline-end: 40px'));
      expect(selectRule, isNot(contains('background-image')));
      expect(shellFocusRule, contains('outline: none !important'));
      expect(
        shellFocusRule,
        contains('border-color: var(--ring, var(--primary)) !important'),
      );
      expect(shellFocusRule, contains('box-shadow: none !important'));
      expect(innerControlRule, contains('border: 0 !important'));
      expect(innerControlRule, contains('outline: none !important'));
      expect(innerControlRule, contains('box-shadow: none !important'));
    },
  );

  test('Neon field focus changes one border without an outline or shadow', () {
    final String focusRule = _cssRule(
      const NeonStylesheet().baseCss,
      '#arcane-root.arcane-theme-neon .neon-text-input:focus,',
    );

    expect(focusRule, contains('outline: none'));
    expect(focusRule, contains('border-color: var(--primary)'));
    expect(focusRule, contains('box-shadow: none'));
    expect(focusRule, isNot(contains('outline-offset')));
  });
}
