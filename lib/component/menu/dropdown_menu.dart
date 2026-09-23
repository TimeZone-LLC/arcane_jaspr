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
  bool _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return dom.div(
      classes: 'arcane-mega-menu ${_isOpen ? 'open' : ''}',
      styles: const dom.Styles(raw: {'position': 'relative'}),
      events: {
        'mouseenter': (e) => setState(() => _isOpen = true),
        'mouseleave': (e) => setState(() => _isOpen = false),
      },
      [
        dom.button(
          classes: 'arcane-mega-menu-trigger',
          attributes: {'type': 'button'},
          styles: dom.Styles(
            raw: {
              'display': 'flex',
              'align-items': 'center',
              'gap': '0.25rem',
              'padding': '8px 12px',
              'font-size': '0.875rem',
              'font-weight': '500',
              'color': _isOpen
                  ? 'var(--foreground)'
                  : 'var(--muted-foreground)',
              'background': 'none',
              'border': 'none',
              'cursor': 'pointer',
              'transition': 'color 150ms ease',
            },
          ),
          [
            Component.text(widget.label),
            dom.span(
              styles: dom.Styles(
                raw: {
                  'font-size': '0.75rem',
                  'transform': _isOpen ? 'rotate(180deg)' : 'rotate(0deg)',
                  'transition': 'transform 150ms ease',
                },
              ),
              [const Component.text('\u25BC')],
            ),
          ],
        ),
        if (_isOpen)
          dom.div(
            classes: 'arcane-mega-menu-panel',
            styles: const dom.Styles(
              raw: {
                'position': 'absolute',
                'top': '100%',
                'left': '50%',
                'transform': 'translateX(-50%)',
                'z-index': '100',
                'margin-top': '0.5rem',
                'padding': '1rem',
                'background-color': 'var(--popover)',
                'border': '1px solid var(--border)',
                'border-radius': '0.375rem',
                'box-shadow':
                    '0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1)',
                'display': 'flex',
                'gap': '2rem',
                'animation': 'arcane-dropdown-fade 0.15s ease-out',
              },
            ),
            [
              for (final section in widget.sections)
                dom.div(
                  classes: 'arcane-mega-menu-section',
                  styles: const dom.Styles(raw: {'min-width': '180px'}),
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
                      [for (final item in section.items) _buildMegaItem(item)],
                    ),
                  ],
                ),
              if (widget.footer != null)
                dom.div(
                  classes: 'arcane-mega-menu-footer',
                  styles: const dom.Styles(
                    raw: {
                      'padding-left': '1rem',
                      'border-left': '1px solid var(--border)',
                    },
                  ),
                  [widget.footer!],
                ),
            ],
          ),
      ],
    );
  }

  Widget _buildMegaItem(ArcaneMenuItem item) {
    // Handle different menu item types with pattern matching
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

    if (action.href != null) {
      return dom.a(
        href: action.href!,
        classes: 'arcane-mega-menu-item',
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
      attributes: {'type': 'button'},
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
      events: {if (action.onSelect != null) 'click': (e) => action.onSelect!()},
      [itemContent],
    );
  }
}
