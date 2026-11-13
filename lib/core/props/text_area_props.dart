import 'package:arcane_jaspr/flutter.dart';

import '../../util/style_types/arcane_style_data.dart';
import '../decoration/arcane_decoration.dart';

/// Resize direction for a [TextAreaProps] control.
enum TextAreaResize { none, vertical, horizontal, both }

/// Text area component properties.
class TextAreaProps {
  final String? placeholder;
  final int rows;
  final int? cols;
  final bool disabled;
  final bool required;
  final bool readOnly;
  final TextAreaResize resize;
  final String? minWidth;
  final String? maxWidth;
  final String? minHeight;
  final String? maxHeight;
  final String? value;
  final String? name;
  final String? id;
  final String? label;
  final String? error;
  final String? helperText;
  final void Function(String)? onChanged;
  final bool fullWidth;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation + theme-specific fields).
  final ArcaneDecoration? decoration;

  /// Extra attributes for the native textarea (spellcheck, wrap, ...),
  /// applied after the library's own.
  final Map<String, String> attributes;

  const TextAreaProps({
    this.placeholder,
    this.rows = 4,
    this.cols,
    this.disabled = false,
    this.required = false,
    this.readOnly = false,
    this.resize = TextAreaResize.vertical,
    this.minWidth,
    this.maxWidth,
    this.minHeight,
    this.maxHeight,
    this.value,
    this.name,
    this.id,
    this.label,
    this.error,
    this.helperText,
    this.onChanged,
    this.fullWidth = true,
    this.styles,
    this.decoration,
    this.attributes = const <String, String>{},
  });

  TextAreaProps copyWith({
    String? placeholder,
    int? rows,
    int? cols,
    bool? disabled,
    bool? required,
    bool? readOnly,
    TextAreaResize? resize,
    String? minWidth,
    String? maxWidth,
    String? minHeight,
    String? maxHeight,
    String? value,
    String? name,
    String? id,
    String? label,
    String? error,
    String? helperText,
    void Function(String)? onChanged,
    bool? fullWidth,
    ArcaneStyleData? styles,
    ArcaneDecoration? decoration,
    Map<String, String>? attributes,
  }) {
    return TextAreaProps(
      placeholder: placeholder ?? this.placeholder,
      rows: rows ?? this.rows,
      cols: cols ?? this.cols,
      disabled: disabled ?? this.disabled,
      required: required ?? this.required,
      readOnly: readOnly ?? this.readOnly,
      resize: resize ?? this.resize,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      minHeight: minHeight ?? this.minHeight,
      maxHeight: maxHeight ?? this.maxHeight,
      value: value ?? this.value,
      name: name ?? this.name,
      id: id ?? this.id,
      label: label ?? this.label,
      error: error ?? this.error,
      helperText: helperText ?? this.helperText,
      onChanged: onChanged ?? this.onChanged,
      fullWidth: fullWidth ?? this.fullWidth,
      styles: styles ?? this.styles,
      decoration: decoration ?? this.decoration,
      attributes: attributes ?? this.attributes,
    );
  }
}

/// Mixin defining the renderer method for text area components.
mixin TextAreaRendererContract {
  /// Render a text area component.
  Widget textArea(TextAreaProps props);
}
