import 'package:arcane_jaspr/flutter.dart';

import '../../core/decoration/arcane_decoration.dart';
import '../../core/theme_provider.dart';
import '../../util/style_types/arcane_style_data.dart';
import '../view/icon.dart';

/// A tab component for switching between views.
class ArcaneTabs extends StatefulWidget {
  final List<ArcaneTabItem> tabs;
  final int initialIndex;
  final void Function(int index)? onChanged;
  final bool fill;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration.
  final ArcaneDecoration? decoration;

  const ArcaneTabs({
    required this.tabs,
    this.initialIndex = 0,
    this.onChanged,
    this.fill = false,
    this.styles,
    this.decoration,
    super.key,
  });

  @override
  State<ArcaneTabs> createState() => _ArcaneTabsState();
}

class _ArcaneTabsState extends State<ArcaneTabs> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _selectTab(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
      widget.onChanged?.call(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<TabItemProps> tabProps = widget.tabs
        .map(
          (tab) => TabItemProps(
            label: tab.label,
            content: tab.content,
            icon: tab.icon,
            badge: tab.badge,
            disabled: tab.disabled,
          ),
        )
        .toList();

    return context.renderers.tabs(
      TabsProps(
        tabs: tabProps,
        selectedIndex: _selectedIndex,
        onChanged: _selectTab,
        fill: widget.fill,
        styles: widget.styles,
        decoration: widget.decoration,
      ),
    );
  }
}

/// A tab item for ArcaneTabs.
class ArcaneTabItem {
  final String label;
  final Widget content;
  final ArcaneGlyph? icon;
  final String? badge;
  final bool disabled;

  const ArcaneTabItem({
    required this.label,
    required this.content,
    this.icon,
    this.badge,
    this.disabled = false,
  });
}

/// A simple tab bar without content for custom tab handling.
class ArcaneTabBar extends StatelessWidget {
  final List<ArcaneTabBarItem> tabs;
  final int selectedIndex;
  final void Function(int index) onChanged;
  final bool fill;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration.
  final ArcaneDecoration? decoration;

  const ArcaneTabBar({
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
    this.fill = false,
    this.styles,
    this.decoration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<TabBarItemProps> tabProps = tabs
        .map((tab) => TabBarItemProps(label: tab.label, icon: tab.icon))
        .toList();

    return context.renderers.tabBar(
      TabBarProps(
        tabs: tabProps,
        selectedIndex: selectedIndex,
        onChanged: onChanged,
        fill: fill,
        styles: styles,
        decoration: decoration,
      ),
    );
  }
}

/// A tab bar item.
class ArcaneTabBarItem {
  final String label;
  final ArcaneGlyph? icon;

  const ArcaneTabBarItem({required this.label, this.icon});
}
