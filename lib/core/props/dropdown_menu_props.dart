import 'package:arcane_jaspr/flutter.dart';
import 'menu_item_props.dart';

import '../../util/style_types/arcane_style_data.dart';
import '../decoration/arcane_decoration.dart';

export 'menu_item_props.dart';

enum DropdownAlignment { left, right, center }

/// Dropdown menu component properties.
class DropdownMenuProps {
  final String id;
  final Widget trigger;
  final List<ArcaneMenuItem> items;
  final DropdownAlignment alignment;
  final double? width;
  final bool keepOpenOnAction;
  final bool initiallyOpen;

  /// The trigger fills the menu's box (a full-width button).
  final bool fullWidth;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation intent + theme-specific
  /// fields honored-or-ignored per theme).
  final ArcaneDecoration? decoration;

  const DropdownMenuProps({
    required this.id,
    required this.trigger,
    required this.items,
    this.alignment = DropdownAlignment.left,
    this.width,
    this.keepOpenOnAction = false,
    this.initiallyOpen = false,
    this.fullWidth = false,
    this.styles,
    this.decoration,
  });

  DropdownMenuProps copyWith({
    String? id,
    Widget? trigger,
    List<ArcaneMenuItem>? items,
    DropdownAlignment? alignment,
    double? width,
    bool? keepOpenOnAction,
    bool? initiallyOpen,
    bool? fullWidth,
    ArcaneStyleData? styles,
    ArcaneDecoration? decoration,
  }) {
    return DropdownMenuProps(
      id: id ?? this.id,
      trigger: trigger ?? this.trigger,
      items: items ?? this.items,
      alignment: alignment ?? this.alignment,
      width: width ?? this.width,
      keepOpenOnAction: keepOpenOnAction ?? this.keepOpenOnAction,
      initiallyOpen: initiallyOpen ?? this.initiallyOpen,
      fullWidth: fullWidth ?? this.fullWidth,
      styles: styles ?? this.styles,
      decoration: decoration ?? this.decoration,
    );
  }
}

// ============================================================================
// RENDERER CONTRACT
// ============================================================================

/// Mixin defining the renderer methods for dropdown menu components.
mixin DropdownMenuRendererContract {
  Widget dropdownMenu(DropdownMenuProps props);
}
