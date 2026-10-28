import 'package:jaspr/jaspr.dart';
import '../interaction/interaction.dart';
import '../shared/shared.dart';
import '../../util/style_types/arcane_style_data.dart';
import '../decoration/arcane_decoration.dart';

export '../shared/shared.dart' show ComponentSize, ColorVariant;

/// Toggle switch component properties.
class ToggleSwitchProps {
  final String id;
  final bool value;
  final void Function(bool)? onChanged;
  final ArcaneInteraction? onChangeAction;
  final bool disabled;
  final ComponentSize size;
  final ColorVariant color;
  final String? label;
  final String? ariaLabel;
  final bool labelLeft;
  final String? group;
  final String? itemValue;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation intent + theme-specific
  /// fields honored-or-ignored per theme).
  final ArcaneDecoration? decoration;

  const ToggleSwitchProps({
    required this.id,
    required this.value,
    this.onChanged,
    this.onChangeAction,
    this.disabled = false,
    this.size = ComponentSize.md,
    this.color = ColorVariant.primary,
    this.label,
    this.ariaLabel,
    this.labelLeft = false,
    this.group,
    this.itemValue,
    this.styles,
    this.decoration,
  });

  ToggleSwitchProps copyWith({
    String? id,
    bool? value,
    void Function(bool)? onChanged,
    ArcaneInteraction? onChangeAction,
    bool? disabled,
    ComponentSize? size,
    ColorVariant? color,
    String? label,
    String? ariaLabel,
    bool? labelLeft,
    String? group,
    String? itemValue,
    ArcaneStyleData? styles,
    ArcaneDecoration? decoration,
  }) {
    return ToggleSwitchProps(
      id: id ?? this.id,
      value: value ?? this.value,
      onChanged: onChanged ?? this.onChanged,
      onChangeAction: onChangeAction ?? this.onChangeAction,
      disabled: disabled ?? this.disabled,
      size: size ?? this.size,
      color: color ?? this.color,
      label: label ?? this.label,
      ariaLabel: ariaLabel ?? this.ariaLabel,
      labelLeft: labelLeft ?? this.labelLeft,
      group: group ?? this.group,
      itemValue: itemValue ?? this.itemValue,
      styles: styles ?? this.styles,
      decoration: decoration ?? this.decoration,
    );
  }
}

// ============================================================================
// RENDERER CONTRACT
// ============================================================================

/// Mixin defining the renderer method for toggle switch components.
mixin ToggleSwitchRendererContract {
  /// Render a toggle switch component.
  Component toggleSwitch(ToggleSwitchProps props);
}
