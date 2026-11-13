import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart';

import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/rendering/base/style_layering.dart';
import 'package:arcane_jaspr/core/props/sidebar_props.dart';

/// Shared structural bases for themed sidebar renderers.
///
/// Several sidebar sub-components render byte-identical markup across every
/// theme (the item link, the collapsible submenu, the fixed section). Those are
/// expressed as fully concrete bases with no abstract members. The separator
/// differs only in its CSS class and inline styles. The collapsible group and
/// the main sidebar shell are identical across the neon/neubrutalism themes
/// apart from CSS class names, so those bases factor the shared structure and
/// expose the class-name (and group label style) variation as abstract members.
///
/// These bases live in core and depend only on core props; they must never
/// depend on a theme package.

/// Sidebar item link. Identical markup across every theme.
abstract class SidebarItemRenderBase extends StatelessComponent {
  const SidebarItemRenderBase(this.props, {super.key});

  final SidebarItemProps props;

  @override
  Component build(BuildContext context) {
    final String linkClasses = 'sidebar-link${props.selected ? ' active' : ''}';
    final String? title =
        props.tooltip ?? (props.collapsed ? props.label : null);
    final Map<String, String> attributes = <String, String>{
      if (props.selected) 'aria-current': 'page',
      if (props.disabled) 'aria-disabled': 'true',
      if (props.collapsed)
        'aria-label': props.badge == null
            ? props.label
            : '${props.label}, ${props.badge}',
      'title': ?title,
    };
    // A plain item keeps its plain markup; the parts appear when asked for.
    final bool plain =
        props.icon == null && props.badge == null && !props.collapsed;
    final List<Component> content = plain
        ? <Component>[Component.text(props.label)]
        : <Component>[
            if (props.icon != null)
              dom.span(
                classes: 'sidebar-icon',
                attributes: const <String, String>{'aria-hidden': 'true'},
                <Component>[props.icon!],
              ),
            if (!props.collapsed)
              dom.span(classes: 'sidebar-link-label', <Component>[
                Component.text(props.label),
              ]),
            if (props.badge != null && !props.collapsed)
              dom.span(classes: 'sidebar-badge', <Component>[
                Component.text(props.badge!),
              ]),
            if (props.icon == null && props.collapsed)
              Component.text(props.label),
          ];

    if (props.href != null && !props.disabled) {
      return dom.div(classes: 'sidebar-tree-item', <Component>[
        dom.a(
          href: props.href!,
          classes: linkClasses,
          attributes: attributes,
          content,
        ),
      ]);
    }

    return dom.div(classes: 'sidebar-tree-item', <Component>[
      dom.button(
        classes: linkClasses,
        attributes: <String, String>{
          'type': 'button',
          ...attributes,
          if (props.disabled) 'disabled': '',
        },
        events: props.onTap != null && !props.disabled
            ? <String, EventCallback>{'click': (_) => props.onTap!()}
            : null,
        content,
      ),
    ]);
  }
}

/// Collapsible sidebar submenu (native details/summary). Identical markup
/// across every theme.
abstract class SidebarSubMenuRenderBase extends StatelessComponent {
  const SidebarSubMenuRenderBase(this.props, {super.key});

  final SidebarSubMenuProps props;

  @override
  Component build(BuildContext context) {
    return dom.div(classes: 'sidebar-section', <Component>[
      Component.element(
        tag: 'details',
        classes: 'sidebar-details',
        attributes: props.defaultOpen
            ? const <String, String>{'open': ''}
            : const <String, String>{},
        children: <Component>[
          Component.element(
            tag: 'summary',
            classes: 'sidebar-summary',
            children: <Component>[
              if (props.icon != null) props.icon!,
              dom.span(<Component>[Component.text(props.label)]),
              const dom.span(classes: 'sidebar-chevron', <Component>[]),
            ],
          ),
          dom.div(classes: 'sidebar-tree', props.children),
        ],
      ),
    ]);
  }
}

/// Fixed (non-collapsible) sidebar section. Identical markup across every theme.
abstract class SidebarSectionRenderBase extends StatelessComponent {
  const SidebarSectionRenderBase(this.props, {super.key});

  final SidebarSectionProps props;

  @override
  Component build(BuildContext context) {
    return dom.div(classes: 'sidebar-section', <Component>[
      dom.div(classes: 'sidebar-section-header', <Component>[
        if (props.icon != null) props.icon!,
        dom.span(<Component>[Component.text(props.label)]),
      ]),
      dom.div(classes: 'sidebar-tree', props.children),
    ]);
  }
}

/// Sidebar separator. Identical structure across every theme; only the CSS
/// class and inline styles differ.
abstract class SidebarSeparatorRenderBase extends StatelessComponent {
  const SidebarSeparatorRenderBase({super.key});

  /// CSS class applied to the separator element.
  String get cssClass;

  /// Inline styles for the separator element.
  Map<String, String> get separatorStyles;

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: cssClass,
      styles: dom.Styles(raw: separatorStyles),
      const <Component>[],
    );
  }
}

/// Collapsible sidebar group. Shared between the neon and neubrutalism themes;
/// the root/label CSS classes and the label inline styles vary per theme.
abstract class SidebarGroupRenderBase extends StatelessComponent {
  const SidebarGroupRenderBase(this.props, {super.key});

  final SidebarGroupProps props;

  /// CSS class applied to the group root element.
  String get cssClass;

  /// CSS class applied to the group label element.
  String get labelClass;

  /// Inline styles for the group label element.
  Map<String, String> get labelStyles;

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: cssClass,
      styles: const dom.Styles(
        raw: <String, String>{
          'display': 'flex',
          'flex-direction': 'column',
          'gap': 'var(--space-1)',
          'margin-bottom': '1rem',
        },
      ),
      <Component>[
        if (props.label != null && !props.collapsed)
          dom.div(
            classes: labelClass,
            styles: dom.Styles(raw: labelStyles),
            <Component>[Component.text(props.label!)],
          ),
        ...props.children,
      ],
    );
  }
}

/// Main sidebar shell. Shared between the neon and neubrutalism themes; only the
/// root/footer/collapse-button CSS classes vary per theme.
abstract class SidebarRenderBase extends StatelessComponent {
  const SidebarRenderBase(this.props, {super.key});

  final SidebarProps props;

  /// Base CSS class for the sidebar root (state/side classes are appended).
  String get sidebarBaseClass;

  /// CSS class applied to the sidebar footer element.
  String get footerClass;

  /// CSS class applied to the collapse toggle button.
  String get collapseButtonClass;

  /// Per-instance decoration overrides. Default: none. A theme overrides this
  /// to translate an [ArcaneDecoration] (elevation intent, theme-specific
  /// fields) into its own CSS. Fields a theme does not implement are ignored.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  @override
  Component build(BuildContext context) {
    final double width = props.isCollapsed ? props.collapsedWidth : props.width;
    final String sideClass = props.rightSide ? 'right' : 'left';
    final String stateClass = props.isCollapsed ? 'collapsed' : '';
    final String classes = '$sidebarBaseClass $stateClass $sideClass';

    return dom.aside(
      classes: classes,
      styles: dom.Styles(
        raw: layerStyles(
          <String, String>{
            'display': 'flex',
            'flex-direction': 'column',
            'width': '${width}px',
            'min-width': '${width}px',
            'height': '100%',
            'overflow': 'hidden',
            'transition': 'width 0.2s ease, min-width 0.2s ease',
            'flex-shrink': '0',
          },
          <Map<String, String>?>[
            props.decoration?.universalStyles(),
            decorationStyles(props.decoration),
            props.styles?.toMap(),
          ],
        ),
      ),
      <Component>[
        if (props.header != null)
          dom.div(classes: 'sidebar-header', <Component>[props.header!]),
        dom.nav(
          classes: 'sidebar-nav',
          styles: const dom.Styles(
            raw: <String, String>{
              'flex': '1',
              'min-height': '0',
              'display': 'flex',
              'flex-direction': 'column',
              'gap': '0.5rem',
              'overflow-y': 'auto',
              'overflow-x': 'hidden',
              'padding': '0.75rem',
              'position': 'relative',
              'z-index': '2',
            },
          ),
          props.children,
        ),
        if (props.showCollapseToggle || props.footer != null)
          dom.div(
            classes: footerClass,
            styles: const dom.Styles(
              raw: <String, String>{
                'flex-shrink': '0',
                'padding': '0.625rem 0.75rem',
                'display': 'flex',
                'flex-direction': 'column',
                'gap': '0.5rem',
                'position': 'relative',
                'z-index': '2',
              },
            ),
            <Component>[
              if (props.footer != null && !props.isCollapsed) props.footer!,
              if (props.showCollapseToggle)
                dom.button(
                  classes: collapseButtonClass,
                  attributes: const <String, String>{'type': 'button'},
                  styles: dom.Styles(
                    raw: <String, String>{
                      'width': '100%',
                      'display': 'flex',
                      'align-items': 'center',
                      'justify-content': props.isCollapsed
                          ? 'center'
                          : 'space-between',
                      'gap': '0.5rem',
                      'padding': '0.5rem 0.75rem',
                      'font-size': '0.6875rem',
                      'text-transform': 'uppercase',
                      'letter-spacing': '0.08em',
                    },
                  ),
                  events: <String, EventCallback>{
                    'click': (_) {
                      if (props.onToggleCollapse != null) {
                        props.onToggleCollapse!();
                      } else if (props.onCollapseChanged != null) {
                        props.onCollapseChanged!(!props.isCollapsed);
                      }
                    },
                  },
                  <Component>[
                    if (!props.isCollapsed) const Component.text('Collapse'),
                    dom.span(
                      styles: const dom.Styles(
                        raw: <String, String>{
                          'font-size': '0.875rem',
                          'opacity': '0.85',
                        },
                      ),
                      <Component>[
                        Component.text(
                          props.isCollapsed
                              ? (props.rightSide ? '←' : '→')
                              : (props.rightSide ? '→' : '←'),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
      ],
    );
  }
}
