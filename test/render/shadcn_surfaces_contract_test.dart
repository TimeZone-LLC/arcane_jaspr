import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:jaspr_test/server_test.dart';

const ShadcnStylesheet _sheet = ShadcnStylesheet();

final String _chevronDown = String.fromCharCode(0xe06d);
final String _chevronLeft = String.fromCharCode(0xe06e);
final String _chevronRight = String.fromCharCode(0xe06f);
final String _ellipsis = String.fromCharCode(0xe0b6);
final String _house = String.fromCharCode(0xe0f5);

Future<String> _render(ServerTester tester, Widget child) async {
  tester.pumpComponent(ArcaneThemeProvider(stylesheet: _sheet, child: child));
  final DocumentResponse response = await tester.request('/');
  expect(response.statusCode, 200, reason: response.body);
  return response.body;
}

/// Returns the opening tag of the first element carrying [className].
String _tag(String html, String className) {
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

/// Returns every opening tag carrying [className].
List<String> _tags(String html, String className) =>
    RegExp(r'<[^>]+class="([^"]*)"[^>]*>')
        .allMatches(html)
        .where(
          (RegExpMatch match) => match.group(1)!.split(' ').contains(className),
        )
        .map((RegExpMatch match) => match.group(0)!)
        .toList();

void _expectNoDirectionalBorder(String html) {
  for (final String side in <String>['left', 'right', 'top', 'bottom']) {
    expect(html, isNot(contains('border-$side:')), reason: 'border-$side');
  }
}

const List<ArcaneMenuItem> _menuItems = <ArcaneMenuItem>[
  MenuItemLabel(label: 'Account'),
  MenuItemAction(label: 'Profile', shortcut: 'P'),
  MenuItemAction(label: 'Archived', disabled: true),
  MenuItemSeparator(),
  MenuItemCheckbox(label: 'Status bar', checked: true),
  MenuItemAction(label: 'Delete', destructive: true),
];

void main() {
  final String css = _sheet.componentCss;

  group('scrims and dialogs', () {
    testServer('dialog uses the 50% overlay token and v4 content chrome', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const ArcaneDialog(
          id: 'surfaces-dialog',
          isOpen: true,
          title: 'Edit profile',
          actions: <Widget>[Button(label: 'Save')],
          child: Text('Body'),
        ),
      );
      final String overlay = _tag(html, 'arcane-dialog-overlay');
      expect(overlay, contains('background-color: var(--overlay)'));
      expect(html, isNot(contains('rgba(0, 0, 0, 0.8)')));

      final String dialog = _tag(html, 'arcane-dialog');
      expect(dialog, contains('position: relative'));
      expect(dialog, contains('padding: 1.5rem'));
      expect(dialog, contains('gap: 1rem'));
      expect(dialog, contains('border-radius: var(--radius-md)'));
      expect(dialog, contains('box-shadow: var(--shadow-lg)'));

      final String title = RegExp(
        r'<[^>]*id="dialog-title-surfaces-dialog"[^>]*>',
      ).firstMatch(html)!.group(0)!;
      expect(title, contains('font-size: 1.125rem'));
      expect(title, contains('line-height: 1'));
      expect(title, contains('font-weight: 600'));

      final String close = _tag(html, 'arcane-dialog-close');
      expect(close, contains('top: 1rem'));
      expect(close, contains('right: 1rem'));
      expect(
        close,
        contains('opacity: var(--shadcn-dialog-close-opacity, 0.7)'),
      );
      expect(close, contains('box-shadow: var(--shadcn-control-shadow, none)'));

      expect(_tag(html, 'arcane-dialog-footer'), contains('gap: 0.5rem'));
      _expectNoDirectionalBorder(html);
    });

    testServer('confirm dialog keeps icon ink off surface tokens', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        ArcaneConfirmDialog(
          title: 'Continue?',
          message: 'This keeps going.',
          icon: ArcaneIcon.info(),
        ),
      );
      expect(
        html,
        isNot(matches(RegExp(r'(?<!background-)color: var\(--accent\)'))),
      );
      expect(_tag(html, 'arcane-dialog-overlay'), contains('var(--overlay)'));
    });

    for (final SheetPosition position in SheetPosition.values) {
      testServer('${position.name} sheet uses a uniform square frame', (
        ServerTester tester,
      ) async {
        final String html = await _render(
          tester,
          ArcaneSheet(
            isOpen: true,
            position: position,
            title: 'Settings',
            description: 'Adjust the workspace.',
            footer: const Button(label: 'Done'),
            child: const Text('Body'),
          ),
        );
        final String panel = _tag(html, 'arcane-sheet-panel');
        expect(panel, contains('border: 1px solid var(--border)'));
        expect(panel, contains('border-radius: 0'));
        expect(panel, contains('box-shadow: var(--shadow-lg)'));
        expect(panel, contains('padding: 1.5rem'));
        expect(panel, contains('gap: 1rem'));
        expect(
          _tag(html, 'arcane-sheet-backdrop'),
          contains('background-color: var(--overlay)'),
        );
        if (position == SheetPosition.start || position == SheetPosition.end) {
          expect(panel, contains('width: 75%'));
          expect(panel, contains('max-width: 24rem'));
        }
        _expectNoDirectionalBorder(html);
      });
    }

    for (final DrawerPosition position in DrawerPosition.values) {
      testServer('${position.name} drawer drops the one-sided border', (
        ServerTester tester,
      ) async {
        final String html = await _render(
          tester,
          ArcaneDrawer(
            isOpen: true,
            position: position,
            child: const Text('Drawer body'),
          ),
        );
        final String panel = _tag(html, 'arcane-drawer');
        expect(panel, contains('border: 1px solid var(--border)'));
        expect(panel, contains('box-shadow: var(--shadow-lg)'));
        expect(
          panel,
          contains(
            position == DrawerPosition.bottom
                ? 'border-radius: var(--radius-md) var(--radius-md) 0 0'
                : 'border-radius: 0',
          ),
        );
        expect(
          _tag(html, 'arcane-drawer-backdrop'),
          contains('background-color: var(--overlay)'),
        );
        _expectNoDirectionalBorder(html);
      });
    }

    test('sheet and toast keyframes referenced inline are defined', () {
      for (final String name in <String>[
        'arcane-slide-left',
        'arcane-slide-right',
        'arcane-slide-up',
        'arcane-slide-down',
        'arcane-toast-enter',
        'arcane-toast-exit',
      ]) {
        expect(css, contains('@keyframes $name '), reason: name);
      }
    });
  });

  group('floating surfaces', () {
    testServer('text tooltips are flat primary chips', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const ArcaneTooltip(
          text: 'Copy link',
          child: Button(label: 'Copy'),
        ),
      );
      final String tooltip = _tag(html, 'arcane-floating-content');
      expect(tooltip, contains('arcane-floating-tooltip'));
      expect(tooltip, contains('background-color: var(--primary)'));
      expect(tooltip, contains('color: var(--primary-foreground)'));
      expect(tooltip, contains('border: 0'));
      expect(tooltip, contains('box-shadow: none'));
      expect(tooltip, contains('padding: 0.375rem 0.75rem'));
      expect(tooltip, contains('font-size: 0.75rem'));
      expect(tooltip, contains('border-radius: var(--radius-sm)'));
      expect(tooltip, contains('text-wrap: balance'));
      _expectNoDirectionalBorder(html);
    });

    testServer('rich popovers keep the popover surface', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const ArcanePopover(
          trigger: Button(label: 'Open'),
          content: Text('Dimensions'),
        ),
      );
      final String popover = _tag(html, 'arcane-floating-content');
      expect(popover, contains('arcane-floating-popover'));
      expect(popover, contains('background-color: var(--popover)'));
      expect(popover, contains('border: 1px solid var(--border)'));
      expect(popover, contains('box-shadow: var(--shadcn-surface-shadow)'));
      expect(popover, contains('padding: 1rem'));
      expect(popover, contains('border-radius: var(--radius-md)'));
      _expectNoDirectionalBorder(html);
    });
  });

  group('menus', () {
    testServer('dropdown menu content and items follow the item contract', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const ArcaneDropdownMenu(
          trigger: Button(label: 'Open'),
          items: _menuItems,
        ),
      );
      final String menu = _tag(html, 'arcane-dropdown-menu');
      expect(menu, contains('min-width: 8rem'));
      expect(menu, contains('border-radius: var(--radius-md)'));
      expect(menu, contains('box-shadow: var(--shadcn-surface-shadow)'));
      expect(menu, contains('z-index: 50'));

      final List<String> items = _tags(html, 'arcane-dropdown-item');
      final String action = items.firstWhere(
        (String tag) => tag.contains('role="menuitem"'),
      );
      expect(
        action,
        contains(
          'background-color: var(--arcane-menu-item-background, transparent)',
        ),
      );
      expect(action, contains('color: var(--arcane-menu-item-foreground,'));
      expect(action, contains('border-radius: var(--shadcn-item-radius)'));
      expect(html, contains('data-variant="destructive"'));
      expect(
        _tag(html, 'arcane-dropdown-divider'),
        contains('background-color: var(--border)'),
      );
      final String label = _tag(html, 'arcane-dropdown-label');
      expect(label, contains('font-size: 0.875rem'));
      expect(label, contains('font-weight: 500'));
      expect(label, isNot(contains('var(--muted-foreground)')));
    });

    testServer('context menu items follow the item contract', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const ArcaneContextMenu(trigger: Text('Target'), items: _menuItems),
      );
      final String menu = _tag(html, 'arcane-context-menu');
      expect(menu, contains('min-width: 8rem'));
      expect(menu, contains('border-radius: var(--radius-md)'));
      expect(menu, contains('box-shadow: var(--shadcn-surface-shadow)'));
      for (final String item in _tags(html, 'arcane-context-menu-item')) {
        expect(
          item,
          contains(
            'background-color: var(--shadcn-item-background, transparent)',
          ),
        );
        expect(item, contains('border-radius: var(--shadcn-item-radius)'));
      }
      expect(
        _tag(html, 'arcane-context-menu-separator'),
        contains('background-color: var(--border)'),
      );
    });

    testServer('menubar renders every menu and reveals submenus by state', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const ArcaneMenubar(
          menus: <ArcaneMenubarMenu>[
            ArcaneMenubarMenu(
              label: 'File',
              items: <ArcaneMenuItem>[
                MenuItemAction(label: 'New tab', shortcut: 'T'),
                MenuItemSubmenu(
                  label: 'Share',
                  children: <ArcaneMenuItem>[
                    MenuItemAction(label: 'Email link'),
                  ],
                ),
              ],
            ),
            ArcaneMenubarMenu(
              label: 'Edit',
              items: <ArcaneMenuItem>[MenuItemAction(label: 'Undo')],
            ),
          ],
        ),
      );
      expect(_tags(html, 'arcane-menubar-content'), hasLength(2));
      final String trigger = _tag(html, 'arcane-menubar-trigger');
      expect(
        trigger,
        contains(
          'background-color: var(--shadcn-item-background, transparent)',
        ),
      );
      expect(trigger, contains('border-radius: var(--radius-sm)'));
      expect(trigger, contains('padding: 0.25rem 0.5rem'));
      final String content = _tag(html, 'arcane-menubar-content');
      expect(content, contains('box-shadow: var(--shadcn-surface-shadow)'));
      expect(content, isNot(contains('overflow: hidden')));
      expect(
        _tag(html, 'arcane-menubar-submenu'),
        isNot(contains('display: none')),
      );
      expect(css, contains('.arcane-menubar-submenu'));

      final String scripts = ArcaneScripts.legacy;
      expect(scripts, contains('.arcane-menubar-menu'));
      expect(scripts, contains('.arcane-menubar-content'));
      expect(scripts, isNot(contains('.arcane-menubar-dropdown')));
      expect(scripts, isNot(contains('.arcane-menubar-menu-item')));
    });

    test('menu hover and focus flip the item variables', () {
      expect(css, contains('--arcane-menu-item-background: var(--accent)'));
      expect(css, contains('--shadcn-item-background: var(--accent)'));
      expect(
        css,
        contains('--shadcn-item-foreground: var(--accent-foreground)'),
      );
      expect(
        css,
        contains(
          '--arcane-menu-item-background: color-mix(in srgb, var(--destructive) 10%, transparent)',
        ),
      );
      expect(
        css,
        contains(':not([aria-disabled="true"]):not([data-disabled="true"])'),
      );
    });
  });

  group('command palette', () {
    testServer('command dialog uses v4 geometry and tokens', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const ArcaneCommand(
          isOpen: true,
          groups: <CommandGroup>[
            CommandGroup(
              heading: 'Suggestions',
              items: <CommandItem>[
                CommandItem(label: 'Calendar', shortcut: 'C'),
              ],
            ),
          ],
        ),
      );
      expect(
        _tag(html, 'arcane-command-overlay'),
        contains('background-color: var(--overlay)'),
      );
      final String dialog = _tag(html, 'arcane-command-dialog');
      expect(dialog, contains('max-width: 32rem'));
      expect(dialog, contains('box-shadow: var(--shadow-lg)'));
      expect(dialog, contains('border-radius: var(--radius-md)'));
      final String list = _tag(html, 'arcane-command-list');
      expect(list, contains('max-height: 300px'));
      expect(list, contains('padding: 0.25rem'));
      final String heading = _tag(html, 'arcane-command-group-heading');
      expect(heading, contains('padding: 0.375rem 0.5rem'));
      expect(heading, contains('font-weight: 500'));
      expect(heading, isNot(contains('uppercase')));
      final String item = _tag(html, 'arcane-command-item');
      expect(
        item,
        contains(
          'background-color: var(--shadcn-item-background, transparent)',
        ),
      );
      expect(item, contains('border-radius: var(--shadcn-item-radius)'));
      expect(html, isNot(contains('ui-monospace')));
      expect(css, contains('.arcane-command-item[data-arcane-state="active"]'));
    });

    // The runtime splits an action on whitespace, so a row must name its verb
    // and arguments apart for `nav.go` and `surface.close` to run at all.
    testServer('rows encode runtime navigation and close actions', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const ArcaneCommand(
          id: 'palette',
          isOpen: true,
          groups: <CommandGroup>[
            CommandGroup(
              items: <CommandItem>[
                CommandItem(label: 'Search', href: '/search?q=owl'),
                CommandItem(
                  label: 'Docs',
                  href: 'https://example.com/docs',
                  hrefTarget: '_blank',
                ),
                CommandItem(label: 'Run'),
              ],
            ),
          ],
        ),
      );
      final List<String> rows = _tags(html, 'arcane-command-item');
      expect(
        rows[0],
        contains(
          'data-arcane-action="nav.go %2Fsearch%3Fq%3Dowl;'
          'surface.close command palette"',
        ),
      );
      expect(
        rows[1],
        contains(
          'data-arcane-action="nav.external '
          'https%3A%2F%2Fexample.com%2Fdocs;surface.close command palette"',
        ),
      );
      expect(
        rows[2],
        contains('data-arcane-action="surface.close command palette"'),
      );
    });
  });

  group('tabs', () {
    testServer('tab list and triggers use v4 sizing and state variables', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const ArcaneTabs(
          tabs: <ArcaneTabItem>[
            ArcaneTabItem(label: 'Account', content: Text('Account')),
            ArcaneTabItem(label: 'Password', content: Text('Password')),
          ],
        ),
      );
      final String list = _tag(html, 'arcane-tabs-list');
      expect(list, contains('box-sizing: border-box'));
      expect(list, contains('height: 2.25rem'));
      expect(list, contains('padding: 3px'));
      expect(list, contains('border-radius: var(--radius-md)'));
      for (final String tab in _tags(html, 'arcane-tab')) {
        expect(tab, contains('box-sizing: border-box'));
        expect(tab, contains('border-radius: var(--radius-sm)'));
        expect(tab, contains('height: calc(100% - 1px)'));
        expect(
          tab,
          contains(
            'background-color: var(--shadcn-item-background, transparent)',
          ),
        );
        expect(tab, contains('box-shadow: var(--shadcn-control-shadow, none)'));
        expect(
          tab,
          contains(
            'border: 1px solid var(--shadcn-control-border-color, transparent)',
          ),
        );
      }
      expect(css, contains('.arcane-tab:focus-visible'));
      expect(
        css,
        contains('--shadcn-control-shadow: var(--shadcn-focus-ring)'),
      );
    });

    testServer('tab bar keeps the 36px strip and 29px triggers border-box', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        ArcaneTabBar(
          tabs: const <ArcaneTabBarItem>[
            ArcaneTabBarItem(label: 'Posts'),
            ArcaneTabBarItem(label: 'Saves'),
          ],
          selectedIndex: 0,
          fill: true,
          onChanged: (int _) {},
        ),
      );
      final String bar = _tag(html, 'arcane-tab-bar');
      expect(bar, contains('box-sizing: border-box'));
      expect(bar, contains('height: 2.25rem'));
      expect(bar, contains('width: 100%'));
      expect(bar, contains('padding: 3px'));
      final List<String> items = _tags(html, 'arcane-tab-bar-item');
      expect(items, hasLength(2));
      for (final String item in items) {
        expect(item, contains('box-sizing: border-box'));
        expect(item, contains('height: calc(100% - 1px)'));
        expect(item, contains('flex: 1'));
      }
    });
  });

  group('disclosure', () {
    testServer('accordion uses a Lucide chevron and a neutral divider', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const ArcaneAccordion(
          items: <ArcaneAccordionItem>[
            ArcaneAccordionItem(title: 'Is it accessible?', content: 'Yes.'),
            ArcaneAccordionItem(title: 'Is it styled?', content: 'Yes.'),
          ],
        ),
      );
      expect(html, isNot(contains('▼')));
      expect(html, contains(_chevronDown));
      expect(html, isNot(contains('rgba(255, 255, 255, 0.06)')));
      expect(_tag(html, 'arcane-accordion'), isNot(contains('gap: 0.75rem')));
      final String summary = _tag(html, 'arcane-accordion-trigger');
      expect(summary, contains('padding: 1rem 0'));
      expect(css, contains('::-webkit-details-marker'));
      expect(css, contains('rotate(180deg)'));
    });

    testServer('disclosure uses the same Lucide chevron', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const ArcaneDisclosure(summary: Text('More'), child: Text('Body')),
      );
      expect(html, isNot(contains('▼')));
      expect(html, contains(_chevronDown));
    });
  });

  group('toast', () {
    testServer('toast follows the Sonner surface without a progress strip', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const ArcaneToast(title: 'Saved', message: 'Changes stored.'),
      );
      expect(html, isNot(contains('arcane-toast-progress')));
      final String toast = _tag(html, 'arcane-toast');
      expect(toast, contains('background-color: var(--popover)'));
      expect(toast, contains('color: var(--popover-foreground)'));
      expect(toast, contains('border: 1px solid var(--border)'));
      expect(toast, contains('border-radius: var(--radius-md)'));
      expect(toast, contains('box-shadow: var(--shadow-lg)'));
      expect(toast, contains('padding: 1rem'));
      expect(toast, contains('font-size: 0.8125rem'));
      expect(_tag(html, 'arcane-toast-title'), contains('font-weight: 500'));
      _expectNoDirectionalBorder(html);
    });
  });

  group('navigation', () {
    testServer('pagination uses 36px ghost items and an outline active page', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const ArcanePagination(currentPage: 5, totalPages: 12),
      );
      final List<String> links = _tags(html, 'arcane-pagination-link');
      for (final String link in links) {
        expect(link, contains('height: 2.25rem'));
        expect(link, contains('border-radius: var(--radius-md)'));
        expect(link, contains('var(--shadcn-item-background,'));
      }
      final String active = links.firstWhere(
        (String tag) => tag.contains('aria-current="page"'),
      );
      expect(
        active,
        contains(
          'border: 1px solid var(--shadcn-control-border-color, var(--input))',
        ),
      );
      expect(active, contains('var(--shadow-xs)'));
      expect(html, contains(_chevronLeft));
      expect(html, contains(_chevronRight));
      expect(html, contains(_ellipsis));
      expect(html, isNot(contains('…')));
      // The default `<-`/`->` labels collapse to the chevron alone.
      expect(html, isNot(contains('<span>-</span>')));
    });

    testServer('simple pagination never paints text with a surface token', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const ArcanePagination.simple(currentPage: 1, totalPages: 3),
      );
      expect(html, isNot(contains('color: var(--muted)')));
    });

    testServer('breadcrumbs use Lucide separators and home icons', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const ArcaneBreadcrumbs(
          showHomeIcon: true,
          items: <BreadcrumbItem>[
            BreadcrumbItem(label: 'Home', href: '/'),
            BreadcrumbItem(label: 'Components', href: '/components'),
            BreadcrumbItem(label: 'Breadcrumb'),
          ],
        ),
      );
      expect(html, isNot(contains('›')));
      expect(html, isNot(contains('⌂')));
      expect(html, contains(_chevronRight));
      expect(html, contains(_house));
      expect(
        _tag(html, 'arcane-breadcrumb-list'),
        contains('gap: var(--shadcn-breadcrumb-gap, 0.375rem)'),
      );
      expect(css, contains('.arcane-breadcrumb-link:hover'));
    });

    testServer('sidebar paints with the sidebar token family', (
      ServerTester tester,
    ) async {
      final String html = await _render(
        tester,
        const ArcaneSidebar(
          children: <Widget>[
            ArcaneSidebarItem(label: 'Inbox', selected: true),
            ArcaneSidebarItem(label: 'Drafts'),
          ],
        ),
      );
      final String sidebar = _tag(html, 'arcane-sidebar');
      expect(sidebar, contains('background-color: var(--sidebar,'));
      expect(sidebar, contains('var(--sidebar-border)'));
      for (final String token in <String>[
        '--sidebar:',
        '--sidebar-foreground:',
        '--sidebar-border:',
        '--sidebar-accent:',
      ]) {
        expect(css, contains(token), reason: token);
      }
      expect(
        css,
        contains('.arcane-sidebar .sidebar-tree-item > .sidebar-link'),
      );
    });
  });

  test('surface CSS stays inside the policy envelope', () {
    expect(css, isNot(contains('linear-gradient')));
    expect(css, contains('var(--shadcn-focus-ring)'));
    expect(css, contains('prefers-reduced-motion'));
  });
}
