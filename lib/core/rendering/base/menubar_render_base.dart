import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/component/view/icon.dart';
import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/rendering/base/style_layering.dart';
import 'package:arcane_jaspr/core/props/menubar_props.dart';

/// Shared structural base for the Neon-family menubar renderers.
///
/// The Neon and Neubrutalism menubars share an identical DOM: a `menubar` row of
/// trigger buttons, each opening a popover that maps menu items (separator,
/// label, action, checkbox, radio, submenu) through the same dispatch. They
/// differ only in the CSS class prefix and a handful of style values (the root
/// chrome, the trigger styling, the popover/content surface, the separator, the
/// item radius/transition and the indicator color) — all exposed as abstract
/// members.
///
/// The ShadCN menubar carries extra `data-state`/`data-disabled` attributes,
/// appends a disabled marker class to checkbox/radio items and styles its
/// popovers inline, so it diverges structurally and does not extend this base.
///
/// This base lives in core and depends only on core props (and the shared icon
/// component); it must never depend on a theme package.
abstract class MenubarRenderBase extends StatelessComponent {
  const MenubarRenderBase(this.props, {super.key});

  final MenubarProps props;

  /// CSS class prefix (e.g. `'neon'`, `'neubrutalism'`).
  String get themePrefix;

  /// Inline styles for the root `menubar` element.
  Map<String, String> get rootStyles;

  /// Inline styles for a trigger button given its open state.
  Map<String, String> triggerStyles(bool isOpen);

  /// Inline styles for an open menu's content popover.
  Map<String, String> get contentStyles;

  /// Inline styles for a separator item.
  Map<String, String> get separatorStyles;

  /// `border-radius` applied to action/checkbox/radio/submenu items.
  String get itemBorderRadius;

  /// `transition` applied to action/checkbox/radio/submenu items.
  String get itemTransition;

  /// `color` of the checkbox check / radio dot indicator.
  String get indicatorColor;

  /// Per-instance decoration overrides. Default: none. Themes translate an
  /// ArcaneDecoration into their own CSS; unimplemented fields are ignored.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: '$themePrefix-menubar',
      attributes: const <String, String>{'role': 'menubar'},
      styles: dom.Styles(
        raw: layerStyles(
          <String, String>{
            ...rootStyles,
          },
          <Map<String, String>?>[
            props.decoration?.universalStyles(),
            decorationStyles(props.decoration),
            props.styles?.toMap(),
          ],
        ),
      ),
      <Component>[
        for (int i = 0; i < props.menus.length; i++)
          _buildMenu(props.menus[i], i),
      ],
    );
  }

  Component _buildMenu(MenubarMenuProps menu, int index) {
    final bool isOpen = props.openMenuIndex == index;

    return dom.div(
      classes: '$themePrefix-menubar-menu ${isOpen ? 'open' : ''}',
      styles: const dom.Styles(raw: <String, String>{'position': 'relative'}),
      <Component>[
        dom.button(
          classes: '$themePrefix-menubar-trigger',
          attributes: <String, String>{
            'type': 'button',
            'aria-haspopup': 'true',
            'aria-expanded': '$isOpen',
          },
          styles: dom.Styles(raw: triggerStyles(isOpen)),
          events: <String, EventCallback>{
            'click': (_) => props.onMenuChange?.call(isOpen ? null : index),
          },
          <Component>[Component.text(menu.label)],
        ),
        if (isOpen)
          dom.div(
            classes: '$themePrefix-menubar-content $themePrefix-popover',
            attributes: const <String, String>{'role': 'menu'},
            styles: dom.Styles(raw: contentStyles),
            <Component>[
              for (final ArcaneMenuItem item in menu.items)
                _buildMenuItem(item),
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

  Component _buildSeparator() {
    return dom.div(
      classes: '$themePrefix-menubar-separator',
      styles: dom.Styles(raw: separatorStyles),
      const <Component>[],
    );
  }

  Component _buildLabel(String label) {
    return dom.div(
      classes: '$themePrefix-menubar-label',
      styles: const dom.Styles(
        raw: <String, String>{
          'padding': '8px 10px 4px',
          'font-family': 'var(--font-heading)',
          'font-size': '0.6875rem',
          'font-weight': '600',
          'letter-spacing': '0.12em',
          'text-transform': 'uppercase',
          'color': 'var(--muted-foreground)',
          'user-select': 'none',
        },
      ),
      <Component>[Component.text(label)],
    );
  }

  Component _buildAction(MenuItemAction item) {
    return dom.div(
      classes: '$themePrefix-menubar-item ${item.disabled ? 'disabled' : ''}',
      attributes: <String, String>{
        'role': 'menuitem',
        if (item.disabled) 'aria-disabled': 'true',
      },
      styles: dom.Styles(
        raw: _itemStyles(disabled: item.disabled, cursorEnabled: 'default'),
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
        if (item.shortcut != null)
          dom.span(
            styles: const dom.Styles(raw: _shortcutStyles),
            <Component>[Component.text(item.shortcut!)],
          ),
      ],
    );
  }

  Component _buildCheckbox(MenuItemCheckbox item) {
    return dom.div(
      classes: '$themePrefix-menubar-item checkbox',
      attributes: <String, String>{
        'role': 'menuitemcheckbox',
        'aria-checked': '${item.checked}',
        if (item.disabled) 'aria-disabled': 'true',
      },
      styles: dom.Styles(
        raw: _itemStyles(
          disabled: item.disabled,
          cursorEnabled: 'pointer',
          withPaddingLeft: true,
        ),
      ),
      events: item.onChanged != null && !item.disabled
          ? <String, EventCallback>{
              'click': (_) => item.onChanged!(!item.checked),
            }
          : null,
      <Component>[
        if (item.checked)
          dom.span(
            classes: 'arcane-menu-indicator',
            styles: dom.Styles(
              raw: <String, String>{
                'position': 'absolute',
                'left': '10px',
                'color': indicatorColor,
              },
            ),
            <Component>[ArcaneIcon.check(size: IconSize.xs)],
          ),
        if (item.icon != null) item.icon!,
        dom.span(
          styles: const dom.Styles(raw: <String, String>{'flex': '1'}),
          <Component>[Component.text(item.label)],
        ),
        if (item.shortcut != null)
          dom.span(
            styles: const dom.Styles(raw: _shortcutStyles),
            <Component>[Component.text(item.shortcut!)],
          ),
      ],
    );
  }

  Component _buildRadio(MenuItemRadio item) {
    return dom.div(
      classes: '$themePrefix-menubar-item radio',
      attributes: <String, String>{
        'role': 'menuitemradio',
        'aria-checked': '${item.selected}',
        if (item.disabled) 'aria-disabled': 'true',
      },
      styles: dom.Styles(
        raw: _itemStyles(
          disabled: item.disabled,
          cursorEnabled: 'pointer',
          withPaddingLeft: true,
        ),
      ),
      events: item.onChanged != null && !item.disabled
          ? <String, EventCallback>{
              'click': (_) => item.onChanged!(item.value),
            }
          : null,
      <Component>[
        if (item.selected)
          dom.span(
            classes: 'arcane-menu-indicator',
            styles: dom.Styles(
              raw: <String, String>{
                'position': 'absolute',
                'left': '10px',
                'color': indicatorColor,
              },
            ),
            <Component>[ArcaneIcon.dot(size: IconSize.sm)],
          ),
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
          '$themePrefix-menubar-item submenu-trigger ${item.disabled ? 'disabled' : ''}',
      attributes: <String, String>{
        'role': 'menuitem',
        'aria-haspopup': 'true',
        if (item.disabled) 'aria-disabled': 'true',
      },
      styles: dom.Styles(
        raw: _itemStyles(disabled: item.disabled, cursorEnabled: 'default'),
      ),
      <Component>[
        if (item.icon != null) item.icon!,
        dom.span(
          styles: const dom.Styles(raw: <String, String>{'flex': '1'}),
          <Component>[Component.text(item.label)],
        ),
        dom.span(
          styles: const dom.Styles(
            raw: <String, String>{'color': 'var(--muted-foreground)'},
          ),
          <Component>[ArcaneIcon.chevronRight(size: IconSize.sm)],
        ),
        dom.div(
          classes: '$themePrefix-menubar-submenu $themePrefix-popover',
          styles: const dom.Styles(
            raw: <String, String>{
              'display': 'none',
              'position': 'absolute',
              'left': '100%',
              'top': '0',
              'min-width': '200px',
              'padding': '6px',
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

  Map<String, String> _itemStyles({
    required bool disabled,
    required String cursorEnabled,
    bool withPaddingLeft = false,
  }) {
    return <String, String>{
      'position': 'relative',
      'display': 'flex',
      'cursor': disabled ? 'not-allowed' : cursorEnabled,
      'user-select': 'none',
      'align-items': 'center',
      'gap': '10px',
      'border-radius': itemBorderRadius,
      'padding': '8px 10px',
      if (withPaddingLeft) 'padding-left': '36px',
      'font-size': 'var(--font-size-sm)',
      'outline': 'none',
      'transition': itemTransition,
      if (disabled) 'pointer-events': 'none',
      if (disabled) 'opacity': '0.5',
    };
  }

  static const Map<String, String> _shortcutStyles = <String, String>{
    'margin-left': 'auto',
    'font-size': 'var(--font-size-xs)',
    'letter-spacing': '0',
    'color': 'var(--muted-foreground)',
  };
}
