import 'package:arcane_jaspr/flutter.dart';
import '../../component/view/icon.dart';

import '../../util/style_types/arcane_style_data.dart';
import '../decoration/arcane_decoration.dart';

/// Sidebar item component properties.
class SidebarItemProps {
  final String label;
  final ArcaneGlyph? icon;
  final void Function()? onTap;
  final String? href;
  final bool selected;
  final bool disabled;
  final String? badge;
  final bool collapsed;
  final String? tooltip;

  /// Whether Tab stops on the item. A sidebar with one stop (the current
  /// item) passes false for the others; the arrows reach them.
  final bool tabStop;

  const SidebarItemProps({
    required this.label,
    this.icon,
    this.onTap,
    this.href,
    this.selected = false,
    this.disabled = false,
    this.badge,
    this.collapsed = false,
    this.tooltip,
    this.tabStop = true,
  });
}

/// Sidebar group component properties.
class SidebarGroupProps {
  final String? label;
  final List<Widget> children;
  final bool collapsed;

  const SidebarGroupProps({
    this.label,
    required this.children,
    this.collapsed = false,
  });
}

/// Sidebar submenu component properties (collapsible section).
///
/// Uses native `<details>/<summary>` for static-site-friendly collapsibles.
class SidebarSubMenuProps {
  final String label;
  final ArcaneGlyph? icon;
  final List<Widget> children;

  /// Whether the section is open by default (sets `open` attribute on `<details>`).
  final bool defaultOpen;
  final bool collapsed;
  final String? badge;

  const SidebarSubMenuProps({
    required this.label,
    required this.children,
    this.icon,
    this.defaultOpen = false,
    this.collapsed = false,
    this.badge,
  });
}

/// Sidebar section component properties (fixed, non-collapsible section).
///
/// For sections that are always expanded with a header.
class SidebarSectionProps {
  final String label;
  final ArcaneGlyph? icon;
  final List<Widget> children;

  const SidebarSectionProps({
    required this.label,
    this.icon,
    required this.children,
  });
}

/// Sidebar component properties.
class SidebarProps {
  final List<Widget> children;
  final Widget? header;
  final Widget? footer;
  final bool isCollapsed;
  final void Function(bool collapsed)? onCollapseChanged;
  final double width;
  final double collapsedWidth;
  final bool showCollapseToggle;
  final bool rightSide;
  final void Function()? onToggleCollapse;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation intent + theme-specific
  /// fields honored-or-ignored per theme).
  final ArcaneDecoration? decoration;

  const SidebarProps({
    required this.children,
    this.header,
    this.footer,
    this.isCollapsed = false,
    this.onCollapseChanged,
    this.width = 280,
    this.collapsedWidth = 64,
    this.showCollapseToggle = true,
    this.rightSide = false,
    this.onToggleCollapse,
    this.styles,
    this.decoration,
  });
}

// ============================================================================
// RENDERER CONTRACT
// ============================================================================

/// Mixin defining the renderer methods for sidebar components.
mixin SidebarRendererContract {
  /// Renders the main sidebar container.
  Widget sidebar(SidebarProps props);

  /// Renders a sidebar navigation item.
  Widget sidebarItem(SidebarItemProps props);

  /// Renders a sidebar group with optional label.
  Widget sidebarGroup(SidebarGroupProps props);

  /// Renders a collapsible sidebar submenu.
  Widget sidebarSubMenu(SidebarSubMenuProps props);

  /// Renders a fixed (non-collapsible) sidebar section.
  Widget sidebarSection(SidebarSectionProps props);

  /// Renders content shown when sidebar is expanded.
  Widget sidebarExpanded(List<Widget> children);

  /// Renders content shown when sidebar is collapsed.
  Widget sidebarCollapsed(List<Widget> children);

  /// Renders a sidebar separator.
  Widget sidebarSeparator();
}
