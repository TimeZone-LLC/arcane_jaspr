import 'package:arcane_jaspr/flutter.dart';
import '../interaction/interaction.dart';
import '../shared/shared.dart';
import '../../util/style_types/arcane_style_data.dart';
import '../decoration/arcane_decoration.dart';

export '../shared/shared.dart' show ComponentSize;

enum TextInputVariant { outline, filled, underline }

enum TextInputType { text, email, password, number, tel, url, search }

/// Text input component properties.
class TextInputProps {
  final String? placeholder;
  final TextInputType type;
  final String? value;
  final String? name;
  final String? id;
  final ComponentSize size;
  final TextInputVariant variant;
  final bool disabled;
  final bool required;
  final bool readOnly;
  final bool fullWidth;
  final String? label;
  final String? helperText;
  final String? error;
  final Widget? prefix;
  final Widget? suffix;
  final void Function(String)? onChanged;
  final void Function()? onFocus;
  final void Function()? onBlur;
  final void Function(String)? onSubmitted;
  final ArcaneInteraction? onChangeAction;
  final ArcaneInteraction? onSubmitAction;
  final String? formId;
  final String? fieldName;
  final Map<String, String>? attributes;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation intent + theme-specific
  /// fields honored-or-ignored per theme).
  final ArcaneDecoration? decoration;

  const TextInputProps({
    this.placeholder,
    this.type = TextInputType.text,
    this.value,
    this.name,
    this.id,
    this.size = ComponentSize.md,
    this.variant = TextInputVariant.outline,
    this.disabled = false,
    this.required = false,
    this.readOnly = false,
    this.fullWidth = false,
    this.label,
    this.helperText,
    this.error,
    this.prefix,
    this.suffix,
    this.onChanged,
    this.onFocus,
    this.onBlur,
    this.onSubmitted,
    this.onChangeAction,
    this.onSubmitAction,
    this.formId,
    this.fieldName,
    this.attributes,
    this.styles,
    this.decoration,
  });

  TextInputProps copyWith({
    String? placeholder,
    TextInputType? type,
    String? value,
    String? name,
    String? id,
    ComponentSize? size,
    TextInputVariant? variant,
    bool? disabled,
    bool? required,
    bool? readOnly,
    bool? fullWidth,
    String? label,
    String? helperText,
    String? error,
    Widget? prefix,
    Widget? suffix,
    void Function(String)? onChanged,
    void Function()? onFocus,
    void Function()? onBlur,
    void Function(String)? onSubmitted,
    ArcaneInteraction? onChangeAction,
    ArcaneInteraction? onSubmitAction,
    String? formId,
    String? fieldName,
    Map<String, String>? attributes,
    ArcaneStyleData? styles,
    ArcaneDecoration? decoration,
  }) {
    return TextInputProps(
      placeholder: placeholder ?? this.placeholder,
      type: type ?? this.type,
      value: value ?? this.value,
      name: name ?? this.name,
      id: id ?? this.id,
      size: size ?? this.size,
      variant: variant ?? this.variant,
      disabled: disabled ?? this.disabled,
      required: required ?? this.required,
      readOnly: readOnly ?? this.readOnly,
      fullWidth: fullWidth ?? this.fullWidth,
      label: label ?? this.label,
      helperText: helperText ?? this.helperText,
      error: error ?? this.error,
      prefix: prefix ?? this.prefix,
      suffix: suffix ?? this.suffix,
      onChanged: onChanged ?? this.onChanged,
      onFocus: onFocus ?? this.onFocus,
      onBlur: onBlur ?? this.onBlur,
      onSubmitted: onSubmitted ?? this.onSubmitted,
      onChangeAction: onChangeAction ?? this.onChangeAction,
      onSubmitAction: onSubmitAction ?? this.onSubmitAction,
      formId: formId ?? this.formId,
      fieldName: fieldName ?? this.fieldName,
      attributes: attributes ?? this.attributes,
      styles: styles ?? this.styles,
      decoration: decoration ?? this.decoration,
    );
  }
}

// ============================================================================
// RENDERER CONTRACT
// ============================================================================

/// Mixin defining the renderer method for text input components.
mixin TextInputRendererContract {
  /// Render a text input component.
  Widget textInput(TextInputProps props);
}
