import 'package:jaspr/jaspr.dart';

import '../shared/shared.dart';
import '../../util/style_types/arcane_style_data.dart';
import '../decoration/arcane_decoration.dart';

class NativeSelectOptionProps {
  final String label;
  final String value;
  final bool disabled;

  const NativeSelectOptionProps({
    required this.label,
    required this.value,
    this.disabled = false,
  });
}

class NativeSelectProps {
  final List<NativeSelectOptionProps> options;
  final String? value;
  final String? placeholder;
  final ComponentSize size;
  final bool disabled;
  final bool required;
  final String? name;
  final String? id;
  final String? label;

  /// The select's accessible name when it shows no [label].
  final String? ariaLabel;
  final String? error;
  final bool fullWidth;
  final void Function(String)? onChange;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation intent + theme-specific
  /// fields honored-or-ignored per theme).
  final ArcaneDecoration? decoration;

  const NativeSelectProps({
    required this.options,
    this.value,
    this.placeholder,
    this.size = ComponentSize.md,
    this.disabled = false,
    this.required = false,
    this.name,
    this.id,
    this.label,
    this.ariaLabel,
    this.error,
    this.fullWidth = false,
    this.onChange,
    this.styles,
    this.decoration,
  });

  NativeSelectProps copyWith({
    List<NativeSelectOptionProps>? options,
    String? value,
    String? placeholder,
    ComponentSize? size,
    bool? disabled,
    bool? required,
    String? name,
    String? id,
    String? label,
    String? ariaLabel,
    String? error,
    bool? fullWidth,
    void Function(String)? onChange,
    ArcaneStyleData? styles,
    ArcaneDecoration? decoration,
  }) {
    return NativeSelectProps(
      options: options ?? this.options,
      value: value ?? this.value,
      placeholder: placeholder ?? this.placeholder,
      size: size ?? this.size,
      disabled: disabled ?? this.disabled,
      required: required ?? this.required,
      name: name ?? this.name,
      id: id ?? this.id,
      label: label ?? this.label,
      ariaLabel: ariaLabel ?? this.ariaLabel,
      error: error ?? this.error,
      fullWidth: fullWidth ?? this.fullWidth,
      onChange: onChange ?? this.onChange,
      styles: styles ?? this.styles,
      decoration: decoration ?? this.decoration,
    );
  }
}

mixin NativeSelectRendererContract {
  Component nativeSelect(NativeSelectProps props);
}
