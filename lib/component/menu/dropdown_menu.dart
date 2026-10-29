import 'package:arcane_jaspr/flutter.dart';
import 'package:jaspr/jaspr.dart'
    hide
        BuildContext,
        InheritedComponent,
        Key,
        State,
        StatefulComponent,
        StatelessComponent,
        UniqueKey,
        ValueKey,
        runApp;
import 'package:jaspr/dom.dart' as dom;
import 'package:arcane_jaspr/core/interaction/interaction.dart';
import 'package:arcane_jaspr/core/interaction/interaction_attrs.dart';

import '../../core/decoration/arcane_decoration.dart';
import '../../core/theme_provider.dart';
import '../../util/style_types/arcane_style_data.dart';

export '../../core/props/dropdown_menu_props.dart' show DropdownAlignment;
export '../../core/props/menu_item_props.dart';

/// Dropdown menu component.
class ArcaneDropdownMenu extends StatelessWidget {
  final String? id;
  final Widget trigger;
  final List<ArcaneMenuItem> items;
  final DropdownAlignment alignment;
  final double? width;
  final bool keepOpenOnAction;
  final bool initiallyOpen;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation + theme-specific fields).
  final ArcaneDecoration? decoration;

  const ArcaneDropdownMenu({
    this.id,
    required this.trigger,
    required this.items,
    this.alignment = DropdownAlignment.left,
    this.width,
    this.keepOpenOnAction = false,
    this.initiallyOpen = false,
    this.styles,
    this.decoration,
    super.key,
  });

  static int _autoCounter = 0;
  static String _autoId() {
    _autoCounter++;
    return 'arcane-dropdown-$_autoCounter';
  }

  @override
  Widget build(BuildContext context) {
    final String resolvedId = id ?? _autoId();
    return context.renderers.dropdownMenu(
      DropdownMenuProps(
        id: resolvedId,
        trigger: trigger,
        items: items,
        alignment: alignment,
        width: width,
        keepOpenOnAction: keepOpenOnAction,
        initiallyOpen: initiallyOpen,
        styles: styles,
        decoration: decoration,
      ),
    );
  }
}

/// Navigation dropdown with mega-menu style.
class ArcaneMegaMenu extends StatefulWidget {
  final String label;
  final List<ArcaneMegaMenuSection> sections;
  final Widget? footer;

  const ArcaneMegaMenu({
    required this.label,
    required this.sections,
    this.footer,
    super.key,
  });

  @override
  State<ArcaneMegaMenu> createState() => _ArcaneMegaMenuState();
}

/// Section in a mega menu.
class ArcaneMegaMenuSection {
  final String? title;
  final List<ArcaneMenuItem> items;

  const ArcaneMegaMenuSection({this.title, required this.items});
}

class _ArcaneMegaMenuState extends State<ArcaneMegaMenu> {
  late final String _surfaceId = 'arcane-mega-${identityHashCode(this)}';

  @override
  Widget build(BuildContext context) {
    return dom.div(
      classes: 'arcane-mega-menu',
      styles: const dom.Styles(raw: {'position': 'relative'}),
      [
        dom.button(
          classes: 'arcane-mega-menu-trigger',
          attributes: <String, String>{
            'type': 'button',
            'aria-haspopup': 'menu',
            'aria-controls': _surfaceId,
            'aria-expanded': 'false',
            ...anchorAttrs('$_surfaceId-trigger'),
            ...interactionAttrs(ArcaneInteraction.toggleMenu(_surfaceId)),
          },
          styles: const dom.Styles(
            raw: {
              'display': 'flex',
              'align-items': 'center',
              'gap': '0.25rem',
              'padding': '8px 12px',
              'font-size': '0.875rem',
              'font-weight': '500',
              'background': 'none',
              'border': 'none',
              'cursor': 'pointer',
              'transition': 'color 150ms ease',
            },
          ),
          [
            Component.text(widget.label),
            const dom.span(
              attributes: <String, String>{'aria-hidden': 'true'},
              styles: dom.Styles(
                raw: {
                  'font-size': '0.75rem',
                  'transition': 'transform 150ms ease',
                },
              ),
              [Component.text('\u25BC')],
            ),
          ],
        ),
        dom.div(
          id: _surfaceId,
          classes: 'arcane-mega-menu-panel',
          attributes: <String, String>{
            'role': 'menu',
            'aria-label': widget.label,
            ...surfaceAttrs(
              surface: 'menu',
              id: _surfaceId,
              focusTrap: false,
              anchorId: '$_surfaceId-trigger',
              anchorPlacement: 'bottom',
              anchorAlign: 'start',
              anchorOffset: '8',
            ),
          },
          styles: const dom.Styles(
            raw: {
              'position': 'absolute',
              'top': '100%',
              'left': '0',
              'z-index': '100',
              'box-sizing': 'border-box',
              'padding': '1rem',
              'background-color': 'var(--popover)',
              'border': '1px solid var(--border)',
              'border-radius': '0.375rem',
              'box-shadow':
                  '0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1)',
              'display': 'flex',
              'flex-wrap': 'wrap',
              'width': 'max-content',
              'max-width': 'calc(100vw - 16px)',
              'max-height': 'calc(100vh - 16px)',
              'overflow': 'auto',
              'gap': '2rem',
            },
          ),
          [
            for (final ArcaneMegaMenuSection section in widget.sections)
              dom.div(
                classes: 'arcane-mega-menu-section',
                styles: const dom.Styles(
                  raw: <String, String>{
                    'flex': '1 1 180px',
                    'min-width': '0',
                    'overflow-wrap': 'anywhere',
                  },
                ),
                [
                  if (section.title != null)
                    dom.div(
                      styles: const dom.Styles(
                        raw: {
                          'font-size': '0.75rem',
                          'font-weight': '600',
                          'text-transform': 'uppercase',
                          'letter-spacing': '0.05em',
                          'color': 'var(--muted-foreground)',
                          'margin-bottom': '0.5rem',
                        },
                      ),
                      [Component.text(section.title!)],
                    ),
                  dom.div(
                    styles: const dom.Styles(
                      raw: {
                        'display': 'flex',
                        'flex-direction': 'column',
                        'gap': '0.25rem',
                      },
                    ),
                    [
                      for (final ArcaneMenuItem item in section.items)
                        _buildMegaItem(item),
                    ],
                  ),
                ],
              ),
            if (widget.footer != null)
              dom.div(
                classes: 'arcane-mega-menu-footer',
                styles: const dom.Styles(
                  raw: {'padding': '1rem', 'border': '1px solid var(--border)'},
                ),
                [widget.footer!],
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildMegaItem(ArcaneMenuItem item) {
    return switch (item) {
      final MenuItemAction action => _buildActionItem(action),
      MenuItemSeparator() => const dom.div(
        styles: dom.Styles(
          raw: {
            'border': 'none',
            'border-top': '1px solid var(--border)',
            'margin': '0.5rem 0',
            'height': '1px',
          },
        ),
        [],
      ),
      final MenuItemLabel label => dom.div(
        styles: const dom.Styles(
          raw: {
            'font-size': '0.75rem',
            'font-weight': '600',
            'text-transform': 'uppercase',
            'letter-spacing': '0.05em',
            'color': 'var(--muted-foreground)',
            'padding': '0.5rem',
          },
        ),
        [Component.text(label.label)],
      ),
      _ => const Component.text(''),
    };
  }

  Widget _buildActionItem(MenuItemAction action) {
    final Widget itemContent = dom.div(
      styles: const dom.Styles(
        raw: {'display': 'flex', 'align-items': 'flex-start', 'gap': '0.5rem'},
      ),
      [
        if (action.icon != null)
          dom.span(
            attributes: const <String, String>{'aria-hidden': 'true'},
            styles: const dom.Styles(
              raw: {'flex-shrink': '0', 'margin-top': '2px'},
            ),
            [action.icon!],
          ),
        dom.div([
          dom.div(
            styles: const dom.Styles(
              raw: {
                'font-size': '0.875rem',
                'font-weight': '500',
                'color': 'var(--foreground)',
              },
            ),
            [Component.text(action.label)],
          ),
          if (action.description != null)
            dom.div(
              styles: const dom.Styles(
                raw: {
                  'font-size': '0.75rem',
                  'color': 'var(--muted-foreground)',
                  'margin-top': '2px',
                },
              ),
              [Component.text(action.description!)],
            ),
        ]),
      ],
    );

    final Map<String, String> attributes = <String, String>{
      'role': 'menuitem',
      'data-label': action.label,
      if (action.disabled) ...<String, String>{
        'aria-disabled': 'true',
        'data-arcane-disabled': 'true',
      },
      if (!action.disabled && action.action != null)
        ...interactionAttrs(action.action!),
    };
    if (action.href != null && !action.disabled) {
      return dom.a(
        href: action.href!,
        classes: 'arcane-mega-menu-item',
        attributes: attributes,
        events: action.action == null && action.onSelect != null
            ? <String, EventCallback>{'click': (_) => action.onSelect!()}
            : null,
        styles: const dom.Styles(
          raw: {
            'display': 'block',
            'padding': '10px 0.5rem',
            'text-decoration': 'none',
            'border-radius': '0.25rem',
            'transition': 'background-color 150ms ease',
          },
        ),
        [itemContent],
      );
    }

    return dom.button(
      classes: 'arcane-mega-menu-item',
      attributes: <String, String>{
        ...attributes,
        'type': 'button',
        if (action.disabled) 'disabled': '',
      },
      styles: const dom.Styles(
        raw: {
          'display': 'block',
          'width': '100%',
          'padding': '10px 0.5rem',
          'text-align': 'left',
          'background': 'none',
          'border': 'none',
          'border-radius': '0.25rem',
          'cursor': 'pointer',
          'transition': 'background-color 150ms ease',
        },
      ),
      events: <String, EventCallback>{
        if (!action.disabled &&
            action.action == null &&
            action.onSelect != null)
          'click': (_) => action.onSelect!(),
      },
      [itemContent],
    );
  }
}
