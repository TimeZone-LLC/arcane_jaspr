import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/component/view/icon.dart';
import 'package:arcane_jaspr/core/props/sidebar_props.dart';
import 'package:arcane_jaspr/core/rendering/base/sidebar_render_base.dart';

/// ShadCN-style sidebar component.
///
/// Paints with the v4 `--sidebar*` token family (defined by the surfaces
/// stylesheet). Links, section headers and submenu summaries are styled there
/// too, since the shared sidebar bases emit them without inline styles.
///
/// Reference: https://ui.shadcn.com/docs/components/sidebar
class ShadcnSidebar extends StatelessComponent {
  final SidebarProps props;

  const ShadcnSidebar(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    final double currentWidth = props.isCollapsed
        ? props.collapsedWidth
        : props.width;

    // ShadCN Sidebar: flex h-full w-(--sidebar-width) flex-col bg-sidebar
    // text-sidebar-foreground, with a square `border-r` against the page.
    return dom.aside(
      classes:
          'arcane-sidebar ${props.isCollapsed ? 'collapsed' : ''} ${props.rightSide ? 'right' : 'left'}',
      attributes: <String, String>{
        'data-state': props.isCollapsed ? 'collapsed' : 'expanded',
      },
      styles: dom.Styles(
        raw: <String, String>{
          'display': 'flex',
          'flex-direction': 'column',
          'width': '${currentWidth}px',
          'height': '100%',
          'background-color':
              'var(--sidebar, color-mix(in srgb, var(--muted) 60%, var(--background)))',
          'color': 'var(--sidebar-foreground, var(--foreground))',
          'border-radius': '0',
          'border-${props.rightSide ? 'left' : 'right'}':
              '1px solid var(--sidebar-border)',
          'transition': 'width var(--transition-slow)',
          'flex-shrink': '0',
          'overflow': 'hidden',
          ...?props.decoration?.universalStyles(),
          ...?props.styles?.toMap(),
        },
      ),
      <Component>[
        // ShadCN SidebarHeader
        if (props.header != null)
          dom.div(classes: 'sidebar-header', <Component>[props.header!]),

        // ShadCN SidebarContent: flex min-h-0 flex-1 flex-col gap-2
        // overflow-auto
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
              'padding': '0.5rem',
            },
          ),
          props.children,
        ),

        // ShadCN SidebarFooter: flex flex-col gap-2 p-2
        dom.div(
          classes: 'arcane-sidebar-footer',
          styles: const dom.Styles(
            raw: <String, String>{
              'display': 'flex',
              'flex-direction': 'column',
              'gap': '0.5rem',
              'padding': '0.5rem',
              'flex-shrink': '0',
            },
          ),
          <Component>[
            if (props.footer != null && !props.isCollapsed) props.footer!,
            if (props.showCollapseToggle)
              dom.button(
                classes: 'arcane-sidebar-toggle',
                attributes: <String, String>{
                  'type': 'button',
                  'aria-label': props.isCollapsed
                      ? 'Expand sidebar'
                      : 'Collapse sidebar',
                  'data-state': props.isCollapsed ? 'collapsed' : 'expanded',
                },
                styles: dom.Styles(
                  raw: <String, String>{
                    'display': 'inline-flex',
                    'align-items': 'center',
                    'justify-content': props.isCollapsed
                        ? 'center'
                        : 'flex-start',
                    'gap': '0.5rem',
                    'width': props.isCollapsed ? '2rem' : '100%',
                    'height': '2rem',
                    'margin': props.isCollapsed ? '0 auto' : '0',
                    'padding': props.isCollapsed ? '0' : '0 0.5rem',
                    'border': 'none',
                    'border-radius': 'var(--radius-sm)',
                    'background-color':
                        'var(--shadcn-item-background, transparent)',
                    'color':
                        'var(--shadcn-item-foreground, var(--sidebar-foreground, var(--foreground)))',
                    'box-shadow': 'var(--shadcn-control-shadow, none)',
                    'outline': 'none',
                    'cursor': 'pointer',
                    'font-size': '0.875rem',
                    'transition':
                        'color var(--transition), background-color var(--transition)',
                  },
                ),
                events: props.onToggleCollapse != null
                    ? <String, EventCallback>{
                        'click': (_) => props.onToggleCollapse!(),
                      }
                    : null,
                <Component>[
                  dom.span(
                    styles: dom.Styles(
                      raw: <String, String>{
                        'display': 'flex',
                        'transition': 'transform var(--transition-slow)',
                        'transform': props.rightSide
                            ? (props.isCollapsed
                                  ? 'rotate(180deg)'
                                  : 'rotate(0)')
                            : (props.isCollapsed
                                  ? 'rotate(0)'
                                  : 'rotate(180deg)'),
                      },
                    ),
                    <Component>[ArcaneIcon.chevronLeft(size: IconSize.sm)],
                  ),
                  if (!props.isCollapsed)
                    const dom.span(<Component>[Component.text('Collapse')]),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

/// ShadCN-style sidebar item using codex structure
/// Renders as: `<div class="sidebar-tree-item"><a class="sidebar-link">...</a></div>`
class ShadcnSidebarItem extends SidebarItemRenderBase {
  const ShadcnSidebarItem(super.props, {super.key});
}

/// ShadCN-style sidebar group.
class ShadcnSidebarGroup extends StatelessComponent {
  final SidebarGroupProps props;

  const ShadcnSidebarGroup(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    // ShadCN SidebarGroup: relative flex w-full min-w-0 flex-col p-2
    return dom.div(
      classes: 'arcane-sidebar-group',
      styles: const dom.Styles(
        raw: <String, String>{
          'position': 'relative',
          'display': 'flex',
          'width': '100%',
          'min-width': '0',
          'flex-direction': 'column',
          'padding': '0.5rem',
        },
      ),
      <Component>[
        // ShadCN SidebarGroupLabel: flex h-8 shrink-0 items-center rounded-md
        // px-2 text-xs font-medium text-sidebar-foreground/70
        if (props.label != null && !props.collapsed)
          dom.div(
            classes: 'arcane-sidebar-group-label',
            styles: const dom.Styles(
              raw: <String, String>{
                'display': 'flex',
                'height': '2rem',
                'flex-shrink': '0',
                'align-items': 'center',
                'border-radius': 'var(--radius-sm)',
                'padding': '0 0.5rem',
                'font-size': '0.75rem',
                'font-weight': '500',
                'color':
                    'color-mix(in srgb, var(--sidebar-foreground, var(--foreground)) 70%, transparent)',
              },
            ),
            <Component>[Component.text(props.label!)],
          ),
        // ShadCN SidebarGroupContent + SidebarMenu: flex flex-col gap-1
        dom.div(
          classes: 'arcane-sidebar-group-items',
          styles: const dom.Styles(
            raw: <String, String>{
              'width': '100%',
              'display': 'flex',
              'flex-direction': 'column',
              'gap': '0.25rem',
              'font-size': '0.875rem',
            },
          ),
          props.children,
        ),
      ],
    );
  }
}

/// ShadCN-style sidebar submenu using native details/summary
/// Renders as: `<div class="sidebar-section"><details class="sidebar-details">...</details></div>`
class ShadcnSidebarSubMenu extends SidebarSubMenuRenderBase {
  const ShadcnSidebarSubMenu(super.props, {super.key});
}

/// ShadCN-style sidebar section (fixed, non-collapsible)
/// Renders as: `<div class="sidebar-section"><div class="sidebar-section-header">...</div><div class="sidebar-tree">...</div></div>`
class ShadcnSidebarSection extends SidebarSectionRenderBase {
  const ShadcnSidebarSection(super.props, {super.key});
}

/// Content only visible when sidebar is expanded
class ShadcnSidebarExpanded extends StatelessComponent {
  final List<Component> children;

  const ShadcnSidebarExpanded(this.children, {super.key});

  @override
  Component build(BuildContext context) {
    // The visibility is controlled by CSS class on parent
    return dom.div(
      classes: 'arcane-sidebar-expanded-only',
      styles: const dom.Styles(
        raw: {'display': 'var(--sidebar-expanded-display, block)'},
      ),
      children,
    );
  }
}

/// Content only visible when sidebar is collapsed
class ShadcnSidebarCollapsed extends StatelessComponent {
  final List<Component> children;

  const ShadcnSidebarCollapsed(this.children, {super.key});

  @override
  Component build(BuildContext context) {
    // The visibility is controlled by CSS class on parent
    return dom.div(
      classes: 'arcane-sidebar-collapsed-only',
      styles: const dom.Styles(
        raw: {'display': 'var(--sidebar-collapsed-display, none)'},
      ),
      children,
    );
  }
}

/// Sidebar separator
class ShadcnSidebarSeparator extends SidebarSeparatorRenderBase {
  const ShadcnSidebarSeparator({super.key});

  @override
  String get cssClass => 'arcane-sidebar-separator';

  /// ShadCN SidebarSeparator: mx-2 w-auto bg-sidebar-border.
  @override
  Map<String, String> get separatorStyles => const <String, String>{
    'height': '1px',
    'background-color': 'var(--sidebar-border, var(--border))',
    'margin': '0.5rem',
  };
}
