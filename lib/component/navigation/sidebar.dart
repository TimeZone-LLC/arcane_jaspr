import 'package:arcane_jaspr/flutter.dart';

import '../../core/decoration/arcane_decoration.dart';
import '../../core/theme_provider.dart';
import '../../util/style_types/arcane_style_data.dart';
import '../view/icon.dart';

export '../../core/props/sidebar_props.dart'
    show
        SidebarItemProps,
        SidebarGroupProps,
        SidebarSubMenuProps,
        SidebarSectionProps;

/// Sidebar navigation component.
class ArcaneSidebar extends StatefulWidget {
  final List<Widget> children;
  final Widget? header;
  final Widget? footer;
  final bool collapsed;
  final void Function(bool collapsed)? onCollapseChanged;
  final double width;
  final double collapsedWidth;
  final bool showCollapseToggle;
  final bool rightSide;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation intent + theme-specific
  /// fields honored-or-ignored per theme).
  final ArcaneDecoration? decoration;

  const ArcaneSidebar({
    required this.children,
    this.header,
    this.footer,
    this.collapsed = false,
    this.onCollapseChanged,
    this.width = 280,
    this.collapsedWidth = 64,
    this.showCollapseToggle = true,
    this.rightSide = false,
    this.styles,
    this.decoration,
    super.key,
  });

  @override
  State<ArcaneSidebar> createState() => _ArcaneSidebarState();
}

class _ArcaneSidebarState extends State<ArcaneSidebar> {
  late bool _isCollapsed;

  @override
  void initState() {
    super.initState();
    _isCollapsed = widget.collapsed;
  }

  @override
  void didUpdateWidget(ArcaneSidebar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.collapsed != widget.collapsed) {
      _isCollapsed = widget.collapsed;
    }
  }

  void _toggleCollapse() {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });
    widget.onCollapseChanged?.call(_isCollapsed);
  }

  @override
  Widget build(BuildContext context) {
    return context.renderers.sidebar(
      SidebarProps(
        children: widget.children,
        header: widget.header,
        footer: widget.footer,
        isCollapsed: _isCollapsed,
        onCollapseChanged: widget.onCollapseChanged,
        width: widget.width,
        collapsedWidth: widget.collapsedWidth,
        showCollapseToggle: widget.showCollapseToggle,
        rightSide: widget.rightSide,
        onToggleCollapse: _toggleCollapse,
        styles: widget.styles,
        decoration: widget.decoration,
      ),
    );
  }
}

/// Sidebar item group with optional label.
class ArcaneSidebarGroup extends StatelessWidget {
  final String? label;
  final List<Widget> children;
  final bool collapsed;

  const ArcaneSidebarGroup({
    this.label,
    required this.children,
    this.collapsed = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return context.renderers.sidebarGroup(
      SidebarGroupProps(label: label, children: children, collapsed: collapsed),
    );
  }
}

/// Sidebar navigation item.
class ArcaneSidebarItem extends StatelessWidget {
  final String label;
  final ArcaneGlyph? icon;
  final void Function()? onTap;
  final String? href;
  final bool selected;
  final bool disabled;
  final String? badge;
  final bool collapsed;
  final String? tooltip;

  const ArcaneSidebarItem({
    required this.label,
    this.icon,
    this.onTap,
    this.href,
    this.selected = false,
    this.disabled = false,
    this.badge,
    this.collapsed = false,
    this.tooltip,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return context.renderers.sidebarItem(
      SidebarItemProps(
        label: label,
        icon: icon,
        onTap: onTap,
        href: href,
        selected: selected,
        disabled: disabled,
        badge: badge,
        collapsed: collapsed,
        tooltip: tooltip,
      ),
    );
  }
}

/// Content that only displays when sidebar is expanded.
class ArcaneSidebarExpanded extends StatelessWidget {
  final List<Widget> children;

  const ArcaneSidebarExpanded({required this.children, super.key});

  @override
  Widget build(BuildContext context) {
    return context.renderers.sidebarExpanded(children);
  }
}

/// Content that only displays when sidebar is collapsed.
class ArcaneSidebarCollapsed extends StatelessWidget {
  final List<Widget> children;

  const ArcaneSidebarCollapsed({required this.children, super.key});

  @override
  Widget build(BuildContext context) {
    return context.renderers.sidebarCollapsed(children);
  }
}

/// Visual separator between sidebar groups or items.
class ArcaneSidebarSeparator extends StatelessWidget {
  const ArcaneSidebarSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return context.renderers.sidebarSeparator();
  }
}

/// Collapsible submenu section using native `<details>/<summary>`.
///
/// Works on static sites without hydration. The `defaultOpen` prop
/// controls whether the section starts expanded.
class ArcaneSidebarSubMenu extends StatelessWidget {
  final String label;
  final ArcaneGlyph? icon;
  final List<Widget> children;
  final bool defaultOpen;
  final bool collapsed;
  final String? badge;

  const ArcaneSidebarSubMenu({
    required this.label,
    required this.children,
    this.icon,
    this.defaultOpen = false,
    this.collapsed = false,
    this.badge,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return context.renderers.sidebarSubMenu(
      SidebarSubMenuProps(
        label: label,
        icon: icon,
        children: children,
        defaultOpen: defaultOpen,
        collapsed: collapsed,
        badge: badge,
      ),
    );
  }
}

/// Fixed sidebar section that is always expanded.
///
/// For sections with a header that don't need collapsing behavior.
class ArcaneSidebarSection extends StatelessWidget {
  final String label;
  final ArcaneGlyph? icon;
  final List<Widget> children;

  const ArcaneSidebarSection({
    required this.label,
    required this.children,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return context.renderers.sidebarSection(
      SidebarSectionProps(label: label, icon: icon, children: children),
    );
  }
}
