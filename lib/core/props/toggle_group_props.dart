import 'package:arcane_jaspr/flutter.dart';

import '../../util/style_types/arcane_style_data.dart';
import '../decoration/arcane_decoration.dart';
import '../interaction/interaction.dart';

enum ToggleGroupVariantStyle { defaultVariant, outline }

enum ToggleGroupSizeVariant { sm, md, lg }

enum ToggleGroupSelectionType { single, multiple }

/// Toggle group item data.
class ToggleGroupItemProps {
  final String value;
  final Widget child;
  final bool disabled;

  const ToggleGroupItemProps({
    required this.value,
    required this.child,
    this.disabled = false,
  });
}

/// Toggle group component properties.
class ToggleGroupProps {
  final String? id;
  final List<ToggleGroupItemProps> items;
  final String? value;
  final Set<String>? values;
  final ToggleGroupSelectionType type;
  final ToggleGroupVariantStyle variant;
  final ToggleGroupSizeVariant size;
  final bool disabled;
  final void Function(String?)? onChanged;
  final void Function(Set<String>)? onMultiChanged;
  final ArcaneInteraction? onChangeAction;

  /// The items form one segmented control (no gap, inner corners square)
  /// where the theme draws one; otherwise they stand apart.
  final bool joined;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation + theme-specific fields).
  final ArcaneDecoration? decoration;

  const ToggleGroupProps({
    this.id,
    required this.items,
    this.value,
    this.values,
    this.type = ToggleGroupSelectionType.single,
    this.variant = ToggleGroupVariantStyle.defaultVariant,
    this.size = ToggleGroupSizeVariant.md,
    this.disabled = false,
    this.onChanged,
    this.onMultiChanged,
    this.onChangeAction,
    this.joined = false,
    this.styles,
    this.decoration,
  });
}

// ============================================================================
// RENDERER CONTRACT
// ============================================================================

/// Mixin defining the renderer methods for toggle group components.
mixin ToggleGroupRendererContract {
  Widget toggleGroup(ToggleGroupProps props);
}
