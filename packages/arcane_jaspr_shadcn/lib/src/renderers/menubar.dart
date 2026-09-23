import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/component/view/icon.dart';
import 'package:arcane_jaspr/core/props/menubar_props.dart';

/// ShadCN-style menubar component.
///
/// Every menu renders its content up front (closed menus carry `hidden`), so
/// the legacy menubar script can open any menu on a static page. Triggers and
/// items route their background and foreground through `--shadcn-item-*`,
/// which the surfaces stylesheet flips on hover, focus and open state.
///
/// Reference: https://ui.shadcn.com/docs/components/menubar
class ShadcnMenubar extends StatelessComponent {
  final MenubarProps props;

  const ShadcnMenubar(this.props, {super.key});

  static const Map<String, String> _surfaceStyles = <String, String>{
    'padding': '0.25rem',
    'background-color': 'var(--popover)',
    'color': 'var(--popover-foreground)',
    'border': '1px solid var(--border)',
    'border-radius': 'var(--radius-md)',
    'box-shadow': 'var(--shadcn-surface-shadow)',
  };

  @override
  Component build(BuildContext context) {
    // ShadCN Menubar: flex h-9 items-center gap-1 rounded-md border
    // bg-background p-1 shadow-xs
    return dom.div(
      classes: 'arcane-menubar',
      attributes: const <String, String>{'role': 'menubar'},
      styles: dom.Styles(
        raw: <String, String>{
          'display': 'flex',
          'height': '2.25rem',
          'align-items': 'center',
          'gap': '0.25rem',
          'border-radius': 'var(--radius-md)',
          'border': '1px solid var(--border)',
          'background-color': 'var(--background)',
          'box-shadow': 'var(--shadow-xs)',
          'padding': '0.25rem',
          ...?props.decoration?.universalStyles(),
          ...?props.styles?.toMap(),
        },
      ),
      <Component>[
        for (int i = 0; i < props.menus.length; i++)
          _buildMenu(props.menus[i], i),
      ],
    );
  }

  Component _buildMenu(MenubarMenuProps menu, int index) {
    final bool isOpen = props.openMenuIndex == index;
    final String state = isOpen ? 'open' : 'closed';

    return dom.div(
      classes: 'arcane-menubar-menu${isOpen ? ' open' : ''}',
      attributes: <String, String>{'data-state': state},
      styles: const dom.Styles(raw: <String, String>{'position': 'relative'}),
      <Component>[
        // ShadCN MenubarTrigger: flex items-center rounded-sm px-2 py-1
        // text-sm font-medium outline-hidden select-none
        // focus:bg-accent data-[state=open]:bg-accent
        dom.button(
          classes: 'arcane-menubar-trigger',
          attributes: <String, String>{
            'type': 'button',
            'aria-haspopup': 'menu',
            'aria-expanded': '$isOpen',
            'data-state': state,
          },
          styles: const dom.Styles(
            raw: <String, String>{
              'display': 'flex',
              'align-items': 'center',
              'cursor': 'default',
              'user-select': 'none',
              'border': 'none',
              'border-radius': 'var(--radius-sm)',
              'padding': '0.25rem 0.5rem',
              'font-size': '0.875rem',
              'line-height': '1.25rem',
              'font-weight': '500',
              'outline': 'none',
              'background-color': 'var(--shadcn-item-background, transparent)',
              'color': 'var(--shadcn-item-foreground, var(--foreground))',
              'box-shadow': 'var(--shadcn-control-shadow, none)',
              'transition':
                  'background-color var(--transition), color var(--transition), box-shadow var(--transition)',
            },
          ),
          events: <String, EventCallback>{
            'click': (_) => props.onMenuChange?.call(isOpen ? null : index),
          },
          <Component>[Component.text(menu.label)],
        ),

        // ShadCN MenubarContent: min-w-[12rem] rounded-md border bg-popover
        // p-1 text-popover-foreground shadow-md
        dom.div(
          classes: 'arcane-menubar-content',
          attributes: <String, String>{
            'role': 'menu',
            'data-state': state,
            if (!isOpen) 'hidden': '',
          },
          styles: const dom.Styles(
            raw: <String, String>{
              'position': 'absolute',
              'top': '100%',
              'left': '-0.25rem',
              'z-index': '50',
              'min-width': '12rem',
              'margin-top': '0.5rem',
              ..._surfaceStyles,
            },
          ),
          <Component>[
            for (final ArcaneMenuItem item in menu.items) _buildMenuItem(item),
          ],
        ),
      ],
    );
  }

  Component _buildMenuItem(ArcaneMenuItem item) {
    return switch (item) {
      MenuItemSeparator() => _buildSeparator(),
      MenuItemLabel(:final String label) => _buildLabel(label),
      MenuItemAction() => _buildAction(item),
      MenuItemCheckbox() => _buildCheckbox(item),
      MenuItemRadio() => _buildRadio(item),
      MenuItemSubmenu() => _buildSubmenu(item),
    };
  }

  /// Shared v4 MenubarItem chrome (`rounded-sm px-2 py-1.5 text-sm gap-2`).
  Map<String, String> _itemStyles(
    bool disabled, {
    String? paddingLeft,
    String restingColor = 'inherit',
  }) => <String, String>{
    'position': 'relative',
    'display': 'flex',
    'align-items': 'center',
    'gap': '0.5rem',
    'cursor': 'default',
    'user-select': 'none',
    'border-radius': 'var(--shadcn-item-radius)',
    'padding': '0.375rem 0.5rem',
    'padding-left': ?paddingLeft,
    'font-size': '0.875rem',
    'line-height': '1.25rem',
    'outline': 'none',
    'background-color': 'var(--shadcn-item-background, transparent)',
    'color': 'var(--shadcn-item-foreground, $restingColor)',
    'transition': 'background-color var(--transition), color var(--transition)',
    if (disabled) 'pointer-events': 'none',
    if (disabled) 'opacity': '0.5',
  };

  Map<String, String> _itemAttributes(bool disabled) => <String, String>{
    if (disabled) 'aria-disabled': 'true',
    'data-disabled': '$disabled',
    'tabindex': disabled ? '-1' : '0',
  };

  Component _buildSeparator() {
    // ShadCN MenubarSeparator: -mx-1 my-1 h-px bg-border
    return const dom.div(
      classes: 'arcane-menubar-separator',
      attributes: <String, String>{'role': 'separator'},
      styles: dom.Styles(
        raw: <String, String>{
          'height': '1px',
          'margin': '0.25rem -0.25rem',
          'background-color': 'var(--border)',
        },
      ),
      <Component>[],
    );
  }

  Component _buildLabel(String label) {
    // ShadCN MenubarLabel: px-2 py-1.5 text-sm font-medium
    return dom.div(
      classes: 'arcane-menubar-label',
      styles: const dom.Styles(
        raw: <String, String>{
          'padding': '0.375rem 0.5rem',
          'font-size': '0.875rem',
          'line-height': '1.25rem',
          'font-weight': '500',
          'color': 'inherit',
          'user-select': 'none',
        },
      ),
      <Component>[Component.text(label)],
    );
  }

  Component _buildShortcut(String shortcut) {
    // ShadCN MenubarShortcut: ml-auto text-xs tracking-widest
    // text-muted-foreground
    return dom.span(
      classes: 'arcane-menubar-shortcut',
      styles: const dom.Styles(
        raw: <String, String>{
          'margin-left': 'auto',
          'font-size': '0.75rem',
          'letter-spacing': '0.1em',
          'color': 'var(--muted-foreground)',
        },
      ),
      <Component>[Component.text(shortcut)],
    );
  }

  Component _buildIndicator(Component icon) {
    return dom.span(
      classes: 'arcane-menubar-indicator',
      styles: const dom.Styles(
        raw: <String, String>{
          'position': 'absolute',
          'left': '0.5rem',
          'display': 'flex',
          'align-items': 'center',
          'justify-content': 'center',
          'width': '0.875rem',
          'height': '0.875rem',
          'pointer-events': 'none',
        },
      ),
      <Component>[icon],
    );
  }

  Component _buildAction(MenuItemAction item) {
    return dom.div(
      classes: 'arcane-menubar-item${item.disabled ? ' disabled' : ''}',
      attributes: <String, String>{
        'role': 'menuitem',
        if (item.destructive) 'data-variant': 'destructive',
        ..._itemAttributes(item.disabled),
      },
      styles: dom.Styles(
        raw: _itemStyles(
          item.disabled,
          restingColor: item.destructive ? 'var(--destructive)' : 'inherit',
        ),
      ),
      events: item.onSelect != null && !item.disabled
          ? <String, EventCallback>{'click': (_) => item.onSelect!()}
          : null,
      <Component>[
        if (item.icon != null) item.icon!,
        dom.span(
          styles: const dom.Styles(raw: <String, String>{'flex': '1'}),
          <Component>[Component.text(item.label)],
        ),
        if (item.shortcut != null) _buildShortcut(item.shortcut!),
      ],
    );
  }

  Component _buildCheckbox(MenuItemCheckbox item) {
    return dom.div(
      classes:
          'arcane-menubar-item checkbox${item.disabled ? ' disabled' : ''}',
      attributes: <String, String>{
        'role': 'menuitemcheckbox',
        'aria-checked': '${item.checked}',
        'data-state': item.checked ? 'checked' : 'unchecked',
        ..._itemAttributes(item.disabled),
      },
      styles: dom.Styles(raw: _itemStyles(item.disabled, paddingLeft: '2rem')),
      events: item.onChanged != null && !item.disabled
          ? <String, EventCallback>{
              'click': (_) => item.onChanged!(!item.checked),
            }
          : null,
      <Component>[
        if (item.checked) _buildIndicator(ArcaneIcon.check(size: IconSize.xs)),
        if (item.icon != null) item.icon!,
        dom.span(
          styles: const dom.Styles(raw: <String, String>{'flex': '1'}),
          <Component>[Component.text(item.label)],
        ),
        if (item.shortcut != null) _buildShortcut(item.shortcut!),
      ],
    );
  }

  Component _buildRadio(MenuItemRadio item) {
    return dom.div(
      classes: 'arcane-menubar-item radio${item.disabled ? ' disabled' : ''}',
      attributes: <String, String>{
        'role': 'menuitemradio',
        'aria-checked': '${item.selected}',
        'data-state': item.selected ? 'checked' : 'unchecked',
        ..._itemAttributes(item.disabled),
      },
      styles: dom.Styles(raw: _itemStyles(item.disabled, paddingLeft: '2rem')),
      events: item.onChanged != null && !item.disabled
          ? <String, EventCallback>{'click': (_) => item.onChanged!(item.value)}
          : null,
      <Component>[
        if (item.selected) _buildIndicator(ArcaneIcon.dot(size: IconSize.sm)),
        if (item.icon != null) item.icon!,
        dom.span(
          styles: const dom.Styles(raw: <String, String>{'flex': '1'}),
          <Component>[Component.text(item.label)],
        ),
      ],
    );
  }

  Component _buildSubmenu(MenuItemSubmenu item) {
    return dom.div(
      classes:
          'arcane-menubar-item submenu-trigger${item.disabled ? ' disabled' : ''}',
      attributes: <String, String>{
        'role': 'menuitem',
        'aria-haspopup': 'menu',
        'aria-expanded': 'false',
        ..._itemAttributes(item.disabled),
      },
      styles: dom.Styles(raw: _itemStyles(item.disabled)),
      <Component>[
        if (item.icon != null) item.icon!,
        dom.span(
          styles: const dom.Styles(raw: <String, String>{'flex': '1'}),
          <Component>[Component.text(item.label)],
        ),
        dom.span(
          styles: const dom.Styles(
            raw: <String, String>{
              'display': 'flex',
              'margin-left': 'auto',
              'color': 'var(--muted-foreground)',
            },
          ),
          <Component>[ArcaneIcon.chevronRight(size: IconSize.sm)],
        ),
        // Revealed by the surfaces stylesheet on hover, focus-within and
        // `aria-expanded="true"`; no inline `display` so the rule can win.
        dom.div(
          classes: 'arcane-menubar-submenu',
          attributes: const <String, String>{'role': 'menu'},
          styles: const dom.Styles(
            raw: <String, String>{
              'position': 'absolute',
              'left': '100%',
              'top': '-0.3125rem',
              'z-index': '51',
              'min-width': '8rem',
              ..._surfaceStyles,
            },
          ),
          <Component>[
            for (final ArcaneMenuItem child in item.children)
              _buildMenuItem(child),
          ],
        ),
      ],
    );
  }
}
