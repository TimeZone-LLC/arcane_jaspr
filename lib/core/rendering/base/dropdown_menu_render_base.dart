import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/component/view/icon.dart';
import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/interaction/interaction.dart';
import 'package:arcane_jaspr/core/interaction/interaction_attrs.dart';
import 'package:arcane_jaspr/core/props/dropdown_menu_props.dart';

/// Shared structural base for themed dropdown-menu renderers.
///
/// The dropdown menu has a large, structurally identical skeleton across every
/// theme: the trigger/menu surface scaffold, the menu-item type switch, and the
/// action/checkbox/radio/submenu item builders share the same DOM shape, the
/// same style-map key order, and the same interaction/attribute/event wiring.
/// Themes diverge only in CSS class names, a handful of style values, and the
/// small separator/label nodes.
///
/// This base factors the shared build logic and exposes the divergent class
/// names and style values as abstract members, with the separator and label
/// nodes as abstract sub-builders.
///
/// This base lives in core and depends only on core props/interaction helpers
/// and the shared icon set; it must never depend on a theme package.
abstract class DropdownMenuRenderBase extends StatelessComponent {
  const DropdownMenuRenderBase(this.props, {super.key});

  final DropdownMenuProps props;

  /// Root wrapper class (e.g. `'arcane-dropdown'`).
  String get rootClass;

  /// Trigger wrapper class (e.g. `'arcane-dropdown-trigger'`).
  String get triggerClass;

  /// Root menu surface class (e.g. `'arcane-dropdown-menu'`).
  String get menuClass;

  /// Base item class shared by action/checkbox/radio/submenu items.
  String get itemClass;

  /// Submenu surface class.
  String get submenuClass;

  /// Anchor offset for the root menu surface.
  String get anchorOffset;

  /// Gap between an item's icon, label and shortcut.
  String get itemGap;

  /// Padding applied to items.
  String get itemPadding;

  /// Default (enabled, non-destructive) action item text color.
  String get itemColor;

  /// Border radius applied to items.
  String get itemBorderRadius;

  /// Transition timing token (e.g. `'var(--transition)'`).
  String get transitionToken;

  /// Letter spacing for the shortcut hint span.
  String get shortcutLetterSpacing;

  /// Left padding reserved for the indicator on checkbox/radio items.
  String get selectablePaddingLeft;

  /// Left offset of the checkbox/radio indicator.
  String get indicatorLeft;

  /// Color of the checkbox/radio indicator.
  String get indicatorColor;

  /// Inline styles for the root menu surface (width-dependent).
  Map<String, String> menuStyles(DropdownMenuProps props);

  /// Per-instance decoration overrides. Default: none. A theme overrides this
  /// to translate an [ArcaneDecoration] (elevation intent, theme-specific
  /// fields) into its own CSS. Fields a theme does not implement are ignored.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  /// Inline styles for a submenu surface.
  Map<String, String> get submenuMenuStyles;

  /// Builds the separator node.
  Component buildSeparator();

  /// Builds a (non-interactive) label node.
  Component buildLabel(String label);

  @override
  Component build(BuildContext context) {
    final String surfaceId = props.id;
    final String anchorId = '$surfaceId-trigger';
    final String alignName = switch (props.alignment) {
      DropdownAlignment.left => 'start',
      DropdownAlignment.right => 'end',
      DropdownAlignment.center => 'center',
    };

    final Map<String, String> menuAttrs = mergeAttrs(<Map<String, String>>[
      surfaceAttrs(
        surface: 'menu',
        id: surfaceId,
        initiallyOpen: props.initiallyOpen,
        focusTrap: false,
        scrimCloses: true,
        anchorId: anchorId,
        anchorPlacement: 'bottom',
        anchorAlign: alignName,
        anchorOffset: anchorOffset,
      ),
      <String, String>{'role': 'menu'},
      if (props.keepOpenOnAction)
        <String, String>{'data-arcane-keep-open-on-action': 'true'},
    ]);

    final Map<String, String> triggerAttrs = mergeAttrs(<Map<String, String>>[
      anchorAttrs(anchorId),
      interactionAttrs(ArcaneInteraction.toggleMenu(surfaceId)),
      <String, String>{
        'aria-haspopup': 'menu',
        'aria-controls': surfaceId,
        'aria-expanded': props.initiallyOpen ? 'true' : 'false',
      },
    ]);

    return dom.div(
      classes: rootClass,
      attributes: <String, String>{'data-arcane-dropdown-root': surfaceId},
      styles: const dom.Styles(
        raw: <String, String>{
          'position': 'relative',
          'display': 'inline-block',
        },
      ),
      <Component>[
        dom.div(
          classes: triggerClass,
          attributes: triggerAttrs,
          styles: const dom.Styles(
            raw: <String, String>{'display': 'inline-block'},
          ),
          <Component>[props.trigger],
        ),
        dom.div(
          classes: menuClass,
          attributes: menuAttrs,
          styles: dom.Styles(raw: <String, String>{
            ...menuStyles(props),
            ...?props.decoration?.universalStyles(),
            ...decorationStyles(props.decoration),
            ...?props.styles?.toMap(),
          }),
          <Component>[
            for (final ArcaneMenuItem item in props.items)
              buildMenuItem(item, surfaceId),
          ],
        ),
      ],
    );
  }

  Component buildMenuItem(ArcaneMenuItem item, String surfaceId) {
    return switch (item) {
      MenuItemSeparator() => buildSeparator(),
      MenuItemLabel(:final String label) => buildLabel(label),
      MenuItemAction() => buildAction(item, surfaceId),
      MenuItemCheckbox() => buildCheckbox(item, surfaceId),
      MenuItemRadio() => buildRadio(item, surfaceId),
      MenuItemSubmenu() => buildSubmenu(item, surfaceId),
    };
  }

  Component buildAction(MenuItemAction item, String surfaceId) {
    final String restingColor = item.disabled
        ? 'var(--muted-foreground)'
        : item.destructive
        ? 'var(--destructive)'
        : itemColor;
    // Colors route through theme-neutral variables so a theme stylesheet can
    // flip them on hover, focus and state; inline literals would block it.
    final dom.Styles itemStyles = dom.Styles(
      raw: <String, String>{
        'position': 'relative',
        'display': 'flex',
        'align-items': 'center',
        'gap': itemGap,
        'padding': itemPadding,
        'font-size': 'var(--font-size-sm)',
        'color': 'var(--arcane-menu-item-foreground, $restingColor)',
        'text-decoration': 'none',
        'border-radius': itemBorderRadius,
        'cursor': item.disabled ? 'not-allowed' : 'pointer',
        'transition':
            'color $transitionToken, background-color $transitionToken',
        'background-color': 'var(--arcane-menu-item-background, transparent)',
        'border': 'none',
        'width': '100%',
        'text-align': 'left',
        'user-select': 'none',
        'outline': 'none',
        'opacity': item.disabled ? '0.5' : '1',
        'pointer-events': item.disabled ? 'none' : 'auto',
      },
    );

    final List<Component> content = <Component>[
      if (item.icon != null)
        dom.span(
          styles: dom.Styles(
            raw: <String, String>{
              'flex-shrink': '0',
              'opacity': item.disabled ? '0.5' : '1',
            },
          ),
          <Component>[item.icon!],
        ),
      dom.div(
        styles: const dom.Styles(
          raw: <String, String>{
            'flex': '1',
            'display': 'flex',
            'flex-direction': 'column',
            'gap': '2px',
          },
        ),
        <Component>[
          dom.span(<Component>[Component.text(item.label)]),
          if (item.description != null)
            dom.span(
              styles: const dom.Styles(
                raw: <String, String>{
                  'font-size': 'var(--font-size-xs)',
                  'color': 'var(--muted-foreground)',
                },
              ),
              <Component>[Component.text(item.description!)],
            ),
        ],
      ),
      if (item.shortcut != null)
        dom.span(
          styles: dom.Styles(
            raw: <String, String>{
              'margin-left': 'auto',
              'font-size': 'var(--font-size-xs)',
              'letter-spacing': shortcutLetterSpacing,
              'color': 'var(--muted-foreground)',
            },
          ),
          <Component>[Component.text(item.shortcut!)],
        ),
    ];

    final ArcaneInteraction? itemAction = item.action;
    final Map<String, String> baseItemAttrs = <String, String>{
      'role': 'menuitem',
      'data-state': 'unchecked',
      'data-disabled': '${item.disabled}',
      if (item.destructive) 'data-variant': 'destructive',
      if (item.disabled) 'data-arcane-disabled': 'true',
    };
    final Map<String, String> actionAttrs = item.disabled
        ? const <String, String>{}
        : itemAction != null
        ? interactionAttrs(itemAction)
        : const <String, String>{};

    if (item.href != null && !item.disabled) {
      return dom.a(
        href: item.href!,
        classes: itemClass,
        attributes: mergeAttrs(<Map<String, String>>[
          baseItemAttrs,
          actionAttrs,
        ]),
        styles: itemStyles,
        events: item.onSelect != null && itemAction == null
            ? <String, EventCallback>{'click': (e) => item.onSelect!()}
            : null,
        content,
      );
    }

    return dom.button(
      classes: itemClass,
      attributes: mergeAttrs(<Map<String, String>>[
        baseItemAttrs,
        <String, String>{
          'type': 'button',
          if (item.disabled) 'disabled': 'true',
        },
        actionAttrs,
      ]),
      styles: itemStyles,
      events: !item.disabled && item.onSelect != null && itemAction == null
          ? <String, EventCallback>{'click': (e) => item.onSelect!()}
          : null,
      content,
    );
  }

  Component buildCheckbox(MenuItemCheckbox item, String surfaceId) {
    final ArcaneInteraction? itemAction = item.action;
    final Map<String, String> actionAttrs = item.disabled
        ? const <String, String>{}
        : itemAction != null
        ? mergeAttrs(<Map<String, String>>[
            interactionAttrs(itemAction),
            <String, String>{'data-arcane-keep-open': 'true'},
          ])
        : const <String, String>{};
    return dom.div(
      classes: '$itemClass checkbox',
      attributes: mergeAttrs(<Map<String, String>>[
        <String, String>{
          'role': 'menuitemcheckbox',
          'aria-checked': '${item.checked}',
          if (item.disabled) 'aria-disabled': 'true',
          'data-state': item.checked ? 'checked' : 'unchecked',
          'data-disabled': '${item.disabled}',
          if (item.disabled) 'data-arcane-disabled': 'true',
          'tabindex': '0',
        },
        actionAttrs,
      ]),
      styles: dom.Styles(
        raw: <String, String>{
          'position': 'relative',
          'display': 'flex',
          'align-items': 'center',
          'gap': itemGap,
          'padding': itemPadding,
          'padding-left': selectablePaddingLeft,
          'font-size': 'var(--font-size-sm)',
          'border-radius': itemBorderRadius,
          'cursor': item.disabled ? 'not-allowed' : 'pointer',
          'transition':
              'background-color $transitionToken, color $transitionToken',
          'user-select': 'none',
          'outline': 'none',
          if (item.disabled) 'pointer-events': 'none',
          if (item.disabled) 'opacity': '0.5',
        },
      ),
      events: item.onChanged != null && !item.disabled && itemAction == null
          ? <String, EventCallback>{
              'click': (_) => item.onChanged!(!item.checked),
            }
          : null,
      <Component>[
        if (item.checked)
          dom.span(
            styles: dom.Styles(
              raw: <String, String>{
                'position': 'absolute',
                'left': indicatorLeft,
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
            styles: dom.Styles(
              raw: <String, String>{
                'margin-left': 'auto',
                'font-size': 'var(--font-size-xs)',
                'letter-spacing': shortcutLetterSpacing,
                'color': 'var(--muted-foreground)',
              },
            ),
            <Component>[Component.text(item.shortcut!)],
          ),
      ],
    );
  }

  Component buildRadio(MenuItemRadio item, String surfaceId) {
    final ArcaneInteraction? itemAction = item.action;
    final Map<String, String> actionAttrs = item.disabled
        ? const <String, String>{}
        : itemAction != null
        ? interactionAttrs(itemAction)
        : const <String, String>{};
    final Map<String, String> groupItem = groupItemAttrs(
      groupId: item.group,
      value: item.value,
      selected: item.selected,
      disabled: item.disabled,
    );
    return dom.div(
      classes: '$itemClass radio',
      attributes: mergeAttrs(<Map<String, String>>[
        groupItem,
        <String, String>{
          'role': 'menuitemradio',
          'aria-checked': '${item.selected}',
          if (item.disabled) 'aria-disabled': 'true',
          'data-disabled': '${item.disabled}',
          'tabindex': '0',
        },
        actionAttrs,
      ]),
      styles: dom.Styles(
        raw: <String, String>{
          'position': 'relative',
          'display': 'flex',
          'align-items': 'center',
          'gap': itemGap,
          'padding': itemPadding,
          'padding-left': selectablePaddingLeft,
          'font-size': 'var(--font-size-sm)',
          'border-radius': itemBorderRadius,
          'cursor': item.disabled ? 'not-allowed' : 'pointer',
          'transition':
              'background-color $transitionToken, color $transitionToken',
          'user-select': 'none',
          'outline': 'none',
          if (item.disabled) 'pointer-events': 'none',
          if (item.disabled) 'opacity': '0.5',
        },
      ),
      events: item.onChanged != null && !item.disabled && itemAction == null
          ? <String, EventCallback>{
              'click': (_) => item.onChanged!(item.value),
            }
          : null,
      <Component>[
        if (item.selected)
          dom.span(
            styles: dom.Styles(
              raw: <String, String>{
                'position': 'absolute',
                'left': indicatorLeft,
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

  Component buildSubmenu(MenuItemSubmenu item, String parentSurfaceId) {
    final String submenuId =
        item.id ?? '$parentSurfaceId-sub-${item.label.hashCode}';
    final String submenuAnchorId = '$submenuId-trigger';

    final Map<String, String> triggerAttrs = mergeAttrs(<Map<String, String>>[
      anchorAttrs(submenuAnchorId),
      if (!item.disabled)
        interactionAttrs(ArcaneInteraction.toggleMenu(submenuId)),
      <String, String>{
        'role': 'menuitem',
        'aria-haspopup': 'menu',
        'aria-expanded': 'false',
        'aria-controls': submenuId,
        if (item.disabled) 'aria-disabled': 'true',
        'data-disabled': '${item.disabled}',
        if (item.disabled) 'data-arcane-disabled': 'true',
        'data-arcane-keep-open': 'true',
        'tabindex': '0',
      },
    ]);

    return dom.div(
      classes: '$itemClass submenu-trigger ${item.disabled ? 'disabled' : ''}',
      attributes: triggerAttrs,
      styles: dom.Styles(
        raw: <String, String>{
          'position': 'relative',
          'display': 'flex',
          'align-items': 'center',
          'gap': itemGap,
          'padding': itemPadding,
          'font-size': 'var(--font-size-sm)',
          'border-radius': itemBorderRadius,
          'cursor': item.disabled ? 'not-allowed' : 'default',
          'transition':
              'background-color $transitionToken, color $transitionToken',
          'user-select': 'none',
          'outline': 'none',
          if (item.disabled) 'pointer-events': 'none',
          if (item.disabled) 'opacity': '0.5',
        },
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
          classes: submenuClass,
          attributes: surfaceAttrs(
            surface: 'menu',
            id: submenuId,
            focusTrap: false,
            scrimCloses: true,
            anchorId: submenuAnchorId,
            anchorPlacement: 'right',
            anchorAlign: 'start',
            anchorOffset: '4',
          ),
          styles: dom.Styles(raw: submenuMenuStyles),
          <Component>[
            for (final ArcaneMenuItem child in item.children)
              buildMenuItem(child, submenuId),
          ],
        ),
      ],
    );
  }
}
