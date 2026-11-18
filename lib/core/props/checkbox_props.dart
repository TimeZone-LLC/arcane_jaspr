import 'package:jaspr/jaspr.dart';
import '../shared/shared.dart';

import '../../util/style_types/arcane_style_data.dart';
import '../decoration/arcane_decoration.dart';

export '../shared/shared.dart' show ComponentSize, ColorVariant;

/// Checkbox component properties.
class CheckboxProps {
  final String id;
  final bool checked;
  final String? label;
  final String? description;
  final ComponentSize size;
  final ColorVariant color;
  final bool disabled;
  final void Function(bool)? onChanged;
  final String? group;
  final String? value;

  /// The box's accessible name when it shows no [label].
  final String? ariaLabel;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation intent + theme-specific
  /// fields honored-or-ignored per theme).
  final ArcaneDecoration? decoration;

  const CheckboxProps({
    required this.id,
    required this.checked,
    this.label,
    this.description,
    this.size = ComponentSize.md,
    this.color = ColorVariant.primary,
    this.disabled = false,
    this.onChanged,
    this.group,
    this.value,
    this.ariaLabel,
    this.styles,
    this.decoration,
  });

  CheckboxProps copyWith({
    String? id,
    bool? checked,
    String? label,
    String? description,
    ComponentSize? size,
    ColorVariant? color,
    bool? disabled,
    void Function(bool)? onChanged,
    String? group,
    String? value,
    String? ariaLabel,
    ArcaneStyleData? styles,
    ArcaneDecoration? decoration,
  }) {
    return CheckboxProps(
      id: id ?? this.id,
      checked: checked ?? this.checked,
      label: label ?? this.label,
      description: description ?? this.description,
      size: size ?? this.size,
      color: color ?? this.color,
      disabled: disabled ?? this.disabled,
      onChanged: onChanged ?? this.onChanged,
      group: group ?? this.group,
      value: value ?? this.value,
      ariaLabel: ariaLabel ?? this.ariaLabel,
      styles: styles ?? this.styles,
      decoration: decoration ?? this.decoration,
    );
  }
}

// ============================================================================
// RENDERER CONTRACT
// ============================================================================

/// Mixin defining the renderer method for checkbox components.
mixin CheckboxRendererContract {
  /// Render a checkbox component.
  Component checkbox(CheckboxProps props);
}
