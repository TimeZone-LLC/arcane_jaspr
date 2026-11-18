import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:jaspr_test/server_test.dart';

const ShadcnStylesheet _sheet = ShadcnStylesheet();

Future<String> _render(ServerTester tester, Widget child) async {
  tester.pumpComponent(ArcaneThemeProvider(stylesheet: _sheet, child: child));
  final DocumentResponse response = await tester.request('/');
  expect(response.statusCode, 200, reason: response.body);
  return response.body;
}

/// The opening tag of the first element carrying [className].
String _tag(String html, String className) {
  for (final RegExpMatch match in RegExp(
    r'<[^>]+class="([^"]*)"[^>]*>',
  ).allMatches(html)) {
    if (match.group(1)!.split(' ').contains(className)) return match.group(0)!;
  }
  fail('Missing .$className in rendered HTML');
}

/// Every opening tag carrying [className].
List<String> _tags(String html, String className) =>
    RegExp(r'<[^>]+class="([^"]*)"[^>]*>')
        .allMatches(html)
        .where(
          (RegExpMatch match) => match.group(1)!.split(' ').contains(className),
        )
        .map((RegExpMatch match) => match.group(0)!)
        .toList();

void main() {
  final String css = _sheet.componentCss;

  group('control heights read the size tokens', () {
    testServer('buttons of every size', (ServerTester tester) async {
      final String html = await _render(
        tester,
        const Row(
          children: <Widget>[
            Button.primary(label: 'Small', size: ButtonSize.sm),
            Button.primary(label: 'Default'),
            Button.primary(label: 'Large', size: ButtonSize.lg),
          ],
        ),
      );
      final List<String> buttons = _tags(html, 'arcane-button');
      expect(buttons[0], contains('height: var(--shadcn-control-h-sm, 2rem)'));
      expect(buttons[1], contains('height: var(--shadcn-control-h, 2.25rem)'));
      expect(
        buttons[2],
        contains('height: var(--shadcn-control-h-lg, 2.5rem)'),
      );
    });

    testServer('selects, inputs, toggle groups and tab strips', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        Column(
          children: <Widget>[
            ArcaneSelect(
              options: const <ArcaneSelectOption>[
                ArcaneSelectOption(value: 'a', label: 'A'),
              ],
              size: ComponentSize.sm,
              ariaLabel: 'Letter',
              onChanged: (String _) {},
            ),
            const TextInput(placeholder: 'Name'),
            ArcaneToggleGroup(
              items: const <ToggleGroupItem>[
                ToggleGroupItem(value: 'a', child: Text('A')),
                ToggleGroupItem(value: 'b', child: Text('B')),
              ],
              value: 'a',
              onChanged: (String? _) {},
            ),
            ArcaneTabBar(
              tabs: const <ArcaneTabBarItem>[
                ArcaneTabBarItem(label: 'One'),
                ArcaneTabBarItem(label: 'Two'),
              ],
              selectedIndex: 0,
              onChanged: (int _) {},
            ),
          ],
        ),
      );
      expect(
        _tag(html, 'arcane-select'),
        contains('height: var(--shadcn-control-h-sm, 2rem)'),
      );
      expect(html, contains('height: var(--shadcn-control-h, 2.25rem)'));
      expect(
        _tag(html, 'arcane-toggle-group-item'),
        contains('height: var(--shadcn-control-h, 2.25rem)'),
      );
      expect(
        _tag(html, 'arcane-tab-bar'),
        contains('height: var(--shadcn-control-h, 2.25rem)'),
      );
    });
  });

  testServer('tab triggers take the control radius inside a wider strip', (
    ServerTester tester,
  ) async {
    final String html = await _render(
      tester,
      ArcaneTabBar(
        tabs: const <ArcaneTabBarItem>[
          ArcaneTabBarItem(label: 'One'),
          ArcaneTabBarItem(label: 'Two'),
        ],
        selectedIndex: 0,
        onChanged: (int _) {},
      ),
    );
    expect(
      _tag(html, 'arcane-tab-bar-item'),
      contains('border-radius: var(--radius-md)'),
    );
    expect(
      _tag(html, 'arcane-tab-bar'),
      contains('border-radius: calc(var(--radius-md) + 2px)'),
    );
  });

  testServer('a disclosure summary leaves its focus ring to the stylesheet', (
    ServerTester tester,
  ) async {
    final String html = await _render(
      tester,
      const ArcaneDisclosure(
        summary: Text('Steps'),
        variant: DisclosureVariant.minimal,
        child: Text('Body'),
      ),
    );
    expect(
      _tag(html, 'arcane-disclosure-summary'),
      isNot(contains('outline: none')),
    );
    expect(
      css,
      contains(
        '#arcane-root.arcane-theme-shadcn .arcane-disclosure-summary:focus-visible {\n'
        '  outline: none;\n'
        '  border-radius: var(--radius-md);\n'
        '  box-shadow: var(--shadcn-focus-ring);',
      ),
    );
  });

  testServer('a toggle group of icons is named by ariaLabel', (
    ServerTester tester,
  ) async {
    final String html = await _render(
      tester,
      ArcaneToggleGroup(
        ariaLabel: 'Skin layers',
        items: const <ToggleGroupItem>[
          ToggleGroupItem(value: 'a', child: Text('A')),
          ToggleGroupItem(value: 'b', child: Text('B')),
        ],
        value: 'a',
        onChanged: (String? _) {},
      ),
    );
    expect(
      _tag(html, 'arcane-toggle-group'),
      contains('aria-label="Skin layers"'),
    );
  });

  testServer('a checkbox without a visible label is named by ariaLabel', (
    ServerTester tester,
  ) async {
    final String html = await _render(
      tester,
      ArcaneCheckbox(
        checked: false,
        ariaLabel: 'Pick Bakery Shop',
        onChanged: (bool _) {},
      ),
    );
    expect(
      _tag(html, 'arcane-checkbox'),
      contains('aria-label="Pick Bakery Shop"'),
    );
  });

  test('a nested card a person can open keeps its focus ring', () {
    expect(
      css,
      contains(
        '#arcane-root.arcane-theme-shadcn .arcane-card .arcane-card.clickable:not([data-arcane-decorated]):focus-visible {\n'
        '  box-shadow: var(--shadcn-focus-ring) !important;\n'
        '}',
      ),
    );
  });

  test('small controls take taps over the touch hit size', () {
    expect(
      css,
      contains(
        '#arcane-root.arcane-theme-shadcn :is(.arcane-toggle-switch, .arcane-checkbox, .arcane-radio-circle, .arcane-dialog-close, .arcane-sheet-close, .arcane-drawer-close, .arcane-tab, .arcane-tab-bar-item, .arcane-breadcrumb-link, [data-arcane-hit])::after,\n'
        'html:has(#arcane-root.arcane-theme-shadcn) [data-arcane-toast-surface] .arcane-toast-close::after {',
      ),
    );
    expect(css, contains('width: max(100%, var(--shadcn-hit-min, 0px));'));
    expect(css, contains('height: max(100%, var(--shadcn-hit-min, 0px));'));
  });

  testServer('a slider track takes taps over the touch size', (
    ServerTester tester,
  ) async {
    final String html = await _render(
      tester,
      ArcaneSlider(value: 4, min: 0, max: 10, onChanged: (double _) {}),
    );
    expect(
      _tag(html, 'arcane-slider-track-container'),
      contains('height: max(24px, var(--shadcn-hit-min, 0px))'),
    );
  });

  test('a page that opts in gets the touch layout on phones', () {
    expect(
      css,
      contains(
        '@media (max-width: 760px), (pointer: coarse) {\n'
        '  html[data-arcane-touch] {\n'
        '    --shadcn-control-h: 2.75rem;\n'
        '    --shadcn-control-h-sm: 2.75rem;\n'
        '    --shadcn-control-h-lg: 2.75rem;\n'
        '    --shadcn-hit-min: 2.75rem;\n'
        '  }\n'
        '}',
      ),
    );
  });

  test(
    'a breadcrumb row is as tall as the touch size, so its links do not overlap the title',
    () {
      expect(
        css,
        contains(
          '#arcane-root.arcane-theme-shadcn .arcane-breadcrumb-list {\n'
          '  min-height: var(--shadcn-hit-min, 0px);\n'
          '}',
        ),
      );
    },
  );

  test('sidebar links are v4 h-8 and grow with the small control token', () {
    expect(
      css,
      contains(
        '  height: var(--shadcn-control-h-sm, 2rem);\n'
        '  min-height: 0;\n'
        '  padding: 0 0.5rem;',
      ),
    );
  });

  group('hover cards', () {
    testServer(
      'an open hover card the pointer is not in lets clicks through',
      (ServerTester tester) async {
        final String html = await _render(
          tester,
          const ArcaneHoverCard(
            trigger: Text('Info'),
            content: Text('Tip'),
            isOpen: true,
          ),
        );
        expect(
          _tag(html, 'arcane-floating-content'),
          contains('data-arcane-pass-through'),
        );
      },
    );

    testServer('a closed hover card and an open popover take clicks', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const Column(
          children: <Widget>[
            ArcaneHoverCard(trigger: Text('Info'), content: Text('Tip')),
            ArcaneHoverCard.popover(
              trigger: Text('Menu'),
              content: Text('Items'),
              isOpen: true,
            ),
          ],
        ),
      );
      for (final String tag in _tags(html, 'arcane-floating-content')) {
        expect(tag, isNot(contains('data-arcane-pass-through')));
      }
    });

    test('its links, buttons and fields still take the pointer', () {
      final String runtime = ArcaneScripts.runtimeCss;
      expect(
        runtime,
        contains('[data-arcane-pass-through] { pointer-events: none; }'),
      );
      expect(
        runtime,
        contains(
          '[data-arcane-pass-through] :is(a[href], button, input, select, textarea, summary, [tabindex]:not([tabindex="-1"])) { pointer-events: auto; }',
        ),
      );
    });
  });

  group('roving focus', () {
    testServer('a sidebar item that is not the tab stop leaves the tab order', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const ArcaneSidebar(
          children: <Widget>[
            ArcaneSidebarGroup(
              children: <Widget>[
                ArcaneSidebarItem(label: 'Home', href: '#/', selected: true),
                ArcaneSidebarItem(
                  label: 'NPCs',
                  href: '#/npcs',
                  tabStop: false,
                ),
              ],
            ),
          ],
        ),
      );
      final List<String> links = _tags(html, 'sidebar-link');
      expect(links[0], isNot(contains('tabindex')));
      expect(links[1], contains('tabindex="-1"'));
    });

    test(
      'the runtime moves focus with the arrows inside data-arcane-roving',
      () {
        final String script = ArcaneScripts.all;
        expect(script, contains('function handleRovingKey(e)'));
        expect(script, contains("closest('[data-arcane-roving]')"));
      },
    );
  });
}
