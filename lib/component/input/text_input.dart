import 'package:arcane_jaspr/flutter.dart';
import 'package:arcane_jaspr/core/rendering/base/native_select_render_base.dart';

export '../../core/props/text_input_props.dart'
    show ComponentSize, TextInputVariant, TextInputType;
export '../../core/props/text_area_props.dart' show TextAreaResize;

import '../../core/interaction/interaction.dart';
import '../form/form_field.dart' show ArcaneFieldScope;
import '../../core/rendering/base/text_area_render_base.dart';
import '../../core/theme_provider.dart';
import '../../core/decoration/arcane_decoration.dart';
import '../../util/style_types/arcane_style_data.dart';

/// A styled text input component.
class TextInput extends StatelessWidget {
  final String? placeholder;
  final TextInputType type;
  final ComponentSize size;
  final bool disabled;
  final bool required;
  final bool readOnly;
  final String? value;
  final String? name;
  final String? id;
  final Widget? prefix;
  final Widget? suffix;
  final String? error;
  final String? helperText;
  final String? label;
  final void Function(String)? onChanged;
  final void Function()? onFocus;
  final void Function()? onBlur;
  final void Function(String)? onSubmitted;
  final ArcaneInteraction? onChangeAction;
  final ArcaneInteraction? onSubmitAction;
  final String? formId;
  final String? fieldName;
  final Map<String, String>? attributes;
  final bool fullWidth;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation intent + theme-specific
  /// fields honored-or-ignored per theme).
  final ArcaneDecoration? decoration;

  const TextInput({
    this.placeholder,
    this.type = TextInputType.text,
    this.size = ComponentSize.md,
    this.disabled = false,
    this.required = false,
    this.readOnly = false,
    this.value,
    this.name,
    this.id,
    this.prefix,
    this.suffix,
    this.error,
    this.helperText,
    this.label,
    this.onChanged,
    this.onFocus,
    this.onBlur,
    this.onSubmitted,
    this.onChangeAction,
    this.onSubmitAction,
    this.formId,
    this.fieldName,
    this.attributes,
    this.fullWidth = false,
    this.styles,
    this.decoration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ArcaneFieldScope? field = ArcaneFieldScope.maybeOf(context);
    return context.renderers.textInput(
      TextInputProps(
        placeholder: placeholder,
        type: type,
        value: value,
        name: name,
        id: id ?? field?.controlId,
        size: size,
        disabled: disabled || (field?.disabled ?? false),
        required: required,
        readOnly: readOnly,
        fullWidth: fullWidth,
        label: label,
        helperText: helperText,
        error: error,
        prefix: prefix,
        suffix: suffix,
        onChanged: onChanged,
        onFocus: onFocus,
        onBlur: onBlur,
        onSubmitted: onSubmitted,
        onChangeAction: onChangeAction,
        onSubmitAction: onSubmitAction,
        formId: formId,
        fieldName: fieldName,
        attributes: field?.controlAttributes(attributes) ?? attributes,
        styles: styles,
        decoration: decoration,
      ),
    );
  }
}

/// A textarea component.
class TextArea extends StatelessWidget {
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

  /// Extra attributes for the native textarea (spellcheck, wrap, ...).
  final Map<String, String> attributes;

  const TextArea({
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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ArcaneFieldScope? field = ArcaneFieldScope.maybeOf(context);
    final TextAreaProps props = TextAreaProps(
      placeholder: placeholder,
      rows: rows,
      cols: cols,
      disabled: disabled || (field?.disabled ?? false),
      required: required,
      readOnly: readOnly,
      resize: resize,
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
      value: value,
      name: name,
      id: id ?? field?.controlId,
      label: label,
      error: error,
      helperText: helperText,
      onChanged: onChanged,
      fullWidth: fullWidth,
      styles: styles,
      decoration: decoration,
      attributes: field?.controlAttributes(attributes) ?? attributes,
    );

    // TextArea historically worked without ArcaneThemeProvider. Keep that
    // source/runtime contract while letting themed trees opt into their native
    // renderer.
    final Object? renderers = ArcaneThemeProvider.of(context)?.renderers;
    return renderers is TextAreaRendererContract
        ? renderers.textArea(props)
        : DefaultTextAreaRenderer(props);
  }
}

/// A select/dropdown input component.
class ArcaneSelect extends StatelessWidget {
  final List<ArcaneSelectOption> options;
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
  final void Function(String)? onChanged;
  final bool fullWidth;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation intent + theme-specific
  /// fields honored-or-ignored per theme).
  final ArcaneDecoration? decoration;

  const ArcaneSelect({
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
    this.onChanged,
    this.fullWidth = false,
    this.styles,
    this.decoration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ArcaneFieldScope? field = ArcaneFieldScope.maybeOf(context);
    final NativeSelectProps props = NativeSelectProps(
      options: options
          .map(
            (ArcaneSelectOption option) => NativeSelectOptionProps(
              label: option.label,
              value: option.value,
              disabled: option.disabled,
            ),
          )
          .toList(),
      value: value,
      placeholder: placeholder,
      size: size,
      disabled: disabled || (field?.disabled ?? false),
      required: required,
      name: name,
      id: id ?? field?.controlId,
      label: label,
      ariaLabel: ariaLabel,
      error: error,
      describedBy: field?.describedBy,
      invalid: field?.invalid ?? false,
      fullWidth: fullWidth,
      onChange: onChanged,
      styles: styles,
      decoration: decoration,
    );
    final ArcaneThemeProvider? theme = ArcaneThemeProvider.of(context);
    return theme == null
        ? DefaultNativeSelectRenderer(props)
        : theme.renderers.nativeSelect(props);
  }
}

/// Select option model.
class ArcaneSelectOption {
  final String label;
  final String value;
  final bool disabled;

  const ArcaneSelectOption({
    required this.label,
    required this.value,
    this.disabled = false,
  });
}

typedef SelectInput = ArcaneSelect;
