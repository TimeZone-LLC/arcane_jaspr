import 'package:arcane_jaspr/flutter.dart';

import '../../core/decoration/arcane_decoration.dart';
import '../../core/theme_provider.dart';
import '../../util/style_types/arcane_style_data.dart';

export '../../core/props/menubar_props.dart';

/// Horizontal menu bar component.
class ArcaneMenubar extends StatefulWidget {
  final List<ArcaneMenubarMenu> menus;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation + theme-specific fields).
  final ArcaneDecoration? decoration;

  const ArcaneMenubar({
    required this.menus,
    this.styles,
    this.decoration,
    super.key,
  });

  @override
  State<ArcaneMenubar> createState() => _ArcaneMenubarState();
}

class _ArcaneMenubarState extends State<ArcaneMenubar> {
  int? _openMenuIndex;

  void _onMenuChange(int? index) {
    setState(() {
      _openMenuIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return context.renderers.menubar(
      MenubarProps(
        menus: widget.menus
            .map(
              (menu) => MenubarMenuProps(label: menu.label, items: menu.items),
            )
            .toList(),
        openMenuIndex: _openMenuIndex,
        onMenuChange: _onMenuChange,
        styles: widget.styles,
        decoration: widget.decoration,
      ),
    );
  }
}

/// Top-level menu in the menubar.
class ArcaneMenubarMenu {
  final String label;
  final List<ArcaneMenuItem> items;

  const ArcaneMenubarMenu({required this.label, required this.items});
}
