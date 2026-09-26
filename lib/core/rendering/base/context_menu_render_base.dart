import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/component/view/icon.dart';
import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/interaction/interaction.dart';
import 'package:arcane_jaspr/core/interaction/interaction_attrs.dart';
import 'package:arcane_jaspr/core/props/context_menu_props.dart';

/// Shared structural base for themed context-menu renderers.
///
/// Every theme's context menu has the same DOM: a `display: contents` trigger
/// wrapper holding the user trigger and a hidden surface `div`, with the surface
/// listing items produced by a sealed-type switch (separator, label, action,
/// checkbox, radio, submenu). The themes diverge only in the CSS class prefix,
/// an optional popover marker class, and the style maps / a handful of color and
/// spacing values. This base factors the identical scaffold, interaction-attr
/// wiring and item iteration, leaving those divergent values to abstract
/// members the concrete renderer supplies.
///
/// This base lives in core and depends only on core props/interaction helpers
/// and the icon view; it must never depend on a theme package.
abstract class ContextMenuRenderBase extends StatelessComponent {
  const ContextMenuRenderBase(this.props, {super.key});

  final ContextMenuProps props;

  /// CSS class prefix (e.g. `'arcane'`, `'neon'`, `'neubrutalism'`).
  String get themePrefix;

  /// Suffix appended to the menu/submenu surface classes (e.g. an empty string
  /// for ShadCN, `' neon-popover'` for Neon).
  String get popoverSuffix;

  /// Raw style map for the menu surface container.
  Map<String, String> get menuStyles;

  /// Per-instance decoration overrides. Default: none. A theme overrides this
  /// to translate an [ArcaneDecoration] (elevation intent, theme-specific
  /// fields) into its own CSS. Fields a theme does not implement are ignored.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  /// Raw style map for a separator item.
  Map<String, String> get separatorStyles;

  /// Raw style map for a label item.
  Map<String, String> get labelStyles;

  /// Raw style map for an action item, given the resolved disabled flag.
  Map<String, String> actionStyles(bool disabled);

  /// Raw style map shared by checkbox and radio items.
  Map<String, String> selectableStyles(bool disabled);

  /// Raw style map for a submenu trigger item.
  Map<String, String> submenuTriggerStyles(bool disabled);

  /// Raw style map for a submenu surface container.
  Map<String, String> get submenuStyles;

  /// Text color for the (non-destructive) action and submenu trigger label.
  String get labelTextColor;

  /// Color for the checkbox/radio selection indicator.
  String get indicatorColor;

  /// `left` offset for the checkbox/radio selection indicator.
  String get indicatorLeft;

  /// `letter-spacing` value for a shortcut hint.
  String get shortcutLetterSpacing;

  @override
  Component build(BuildContext context) {
    final String surfaceId = props.id;

    final Map<String, String> menuAttrs = mergeAttrs(<Map<String, String>>[
      surfaceAttrs(
        surface: 'context-menu',
        id: surfaceId,
        focusTrap: false,
        scrimCloses: true,
      ),
      <String, String>{'role': 'menu'},
      if (props.keepOpenOnAction)
        <String, String>{'data-arcane-keep-open-on-action': 'true'},
    ]);

    return dom.div(
      classes: '$themePrefix-context-menu-trigger',
      attributes: <String, String>{
        'data-arcane-context-trigger': surfaceId,
      },
      styles: const dom.Styles(raw: {'display': 'contents'}),
      [
        props.trigger,
        dom.div(
          classes: '$themePrefix-context-menu$popoverSuffix',
          attributes: menuAttrs,
          styles: dom.Styles(raw: <String, String>{
            ...menuStyles,
            ...?props.decoration?.universalStyles(),
            ...decorationStyles(props.decoration),
            ...?props.styles?.toMap(),
          }),
          [for (final item in props.items) _buildMenuItem(item, surfaceId)],
        ),
      ],
    );
  }

  Component _buildMenuItem(ArcaneMenuItem item, String surfaceId) {
    return switch (item) {
      MenuItemSeparator() => _buildSeparator(),
      MenuItemLabel(:final label) => _buildLabel(label),
      MenuItemAction() => _buildAction(item),
      MenuItemCheckbox() => _buildCheckbox(item),
      MenuItemRadio() => _buildRadio(item),
      MenuItemSubmenu() => _buildSubmenu(item, surfaceId),
    };
  }

  Component _buildSeparator() {
    return dom.div(
      classes: '$themePrefix-context-menu-separator',
      styles: dom.Styles(raw: separatorStyles),
      const <Component>[],
    );
  }

  Component _buildLabel(String label) {
    return dom.div(
      classes: '$themePrefix-context-menu-label',
      styles: dom.Styles(raw: labelStyles),
      [Component.text(label)],
    );
  }

  Component _buildAction(MenuItemAction item) {
    final ArcaneInteraction? itemAction = item.action;
    final Map<String, String> actionAttrs = item.disabled
        ? const <String, String>{}
        : itemAction != null
            ? interactionAttrs(itemAction)
            : const <String, String>{};

    return dom.div(
      classes:
          '$themePrefix-context-menu-item ${item.disabled ? 'disabled' : ''} ${item.destructive ? 'destructive' : ''}',
      attributes: mergeAttrs(<Map<String, String>>[
        <String, String>{
          'role': 'menuitem',
          if (item.disabled) 'aria-disabled': 'true',
          if (item.shortcut != null) 'data-shortcut': item.shortcut!,
          'data-disabled': '${item.disabled}',
          if (item.disabled) 'data-arcane-disabled': 'true',
          'tabindex': '0',
        },
        actionAttrs,
      ]),
      styles: dom.Styles(raw: actionStyles(item.disabled)),
      events: item.onSelect != null && !item.disabled && itemAction == null
          ? <String, EventCallback>{'click': (_) => item.onSelect!()}
          : null,
      [
        if (item.icon != null) item.icon!,
        dom.span(
          styles: dom.Styles(
            raw: {
              'flex': '1',
              'color': item.destructive ? 'var(--destructive)' : labelTextColor,
            },
          ),
          [Component.text(item.label)],
        ),
        if (item.shortcut != null)
          dom.span(
            styles: dom.Styles(
              raw: {
                'margin-left': 'auto',
                'font-size': 'var(--font-size-xs)',
                'letter-spacing': shortcutLetterSpacing,
                'color': 'var(--muted-foreground)',
              },
            ),
            [Component.text(item.shortcut!)],
          ),
      ],
    );
  }

  Component _buildCheckbox(MenuItemCheckbox item) {
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
      classes: '$themePrefix-context-menu-item checkbox',
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
      styles: dom.Styles(raw: selectableStyles(item.disabled)),
      events: item.onChanged != null && !item.disabled && itemAction == null
          ? <String, EventCallback>{'click': (_) => item.onChanged!(!item.checked)}
          : null,
      [
        // Checkbox indicator
        if (item.checked)
          dom.span(
            classes: 'arcane-menu-indicator',
            styles: dom.Styles(
              raw: {
                'position': 'absolute',
                'left': indicatorLeft,
                'color': indicatorColor,
              },
            ),
            [ArcaneIcon.check(size: IconSize.xs)],
          ),
        if (item.icon != null) item.icon!,
        dom.span(styles: const dom.Styles(raw: {'flex': '1'}), [
          Component.text(item.label),
        ]),
        if (item.shortcut != null)
          dom.span(
            styles: dom.Styles(
              raw: {
                'margin-left': 'auto',
                'font-size': 'var(--font-size-xs)',
                'letter-spacing': shortcutLetterSpacing,
                'color': 'var(--muted-foreground)',
              },
            ),
            [Component.text(item.shortcut!)],
          ),
      ],
    );
  }

  Component _buildRadio(MenuItemRadio item) {
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
      classes: '$themePrefix-context-menu-item radio',
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
      styles: dom.Styles(raw: selectableStyles(item.disabled)),
      events: item.onChanged != null && !item.disabled && itemAction == null
          ? <String, EventCallback>{'click': (_) => item.onChanged!(item.value)}
          : null,
      [
        // Radio indicator
        if (item.selected)
          dom.span(
            classes: 'arcane-menu-indicator',
            styles: dom.Styles(
              raw: {
                'position': 'absolute',
                'left': indicatorLeft,
                'color': indicatorColor,
              },
            ),
            [ArcaneIcon.dot(size: IconSize.sm)],
          ),
        if (item.icon != null) item.icon!,
        dom.span(styles: const dom.Styles(raw: {'flex': '1'}), [
          Component.text(item.label),
        ]),
      ],
    );
  }

  Component _buildSubmenu(MenuItemSubmenu item, String parentSurfaceId) {
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
      classes:
          '$themePrefix-context-menu-item $themePrefix-context-menu-submenu-trigger ${item.disabled ? 'disabled' : ''}',
      attributes: triggerAttrs,
      styles: dom.Styles(raw: submenuTriggerStyles(item.disabled)),
      [
        if (item.icon != null) item.icon!,
        dom.span(
          styles: dom.Styles(
            raw: {'flex': '1', 'color': labelTextColor},
          ),
          [Component.text(item.label)],
        ),
        dom.span(
          styles: const dom.Styles(raw: {'color': 'var(--muted-foreground)'}),
          [ArcaneIcon.chevronRight(size: IconSize.sm)],
        ),
        dom.div(
          classes: '$themePrefix-context-menu-submenu$popoverSuffix',
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
          styles: dom.Styles(raw: submenuStyles),
          [for (final child in item.children) _buildMenuItem(child, submenuId)],
        ),
      ],
    );
  }
}
