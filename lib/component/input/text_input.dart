import 'package:arcane_jaspr/flutter.dart';
import 'package:jaspr/jaspr.dart' as jaspr;
import 'package:jaspr/dom.dart' as dom;
import '../../core/dom_value.dart';
import 'package:arcane_jaspr/core/rendering/field_identity.dart';

export '../../core/props/text_input_props.dart'
    show ComponentSize, TextInputVariant, TextInputType;
export '../../core/props/text_area_props.dart' show TextAreaResize;

import '../../core/interaction/interaction.dart';
import '../../core/rendering/base/text_area_render_base.dart';
import '../../core/theme_provider.dart';
import '../../core/decoration/arcane_decoration.dart';
import '../../util/style_types/arcane_style_data.dart';
import '../view/icon.dart';

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
    return context.renderers.textInput(
      TextInputProps(
        placeholder: placeholder,
        type: type,
        value: value,
        name: name,
        id: id,
        size: size,
        disabled: disabled,
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
        attributes: attributes,
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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextAreaProps props = TextAreaProps(
      placeholder: placeholder,
      rows: rows,
      cols: cols,
      disabled: disabled,
      required: required,
      readOnly: readOnly,
      resize: resize,
      minWidth: minWidth,
      maxWidth: maxWidth,
      minHeight: minHeight,
      maxHeight: maxHeight,
      value: value,
      name: name,
      id: id,
      label: label,
      error: error,
      helperText: helperText,
      onChanged: onChanged,
      fullWidth: fullWidth,
      styles: styles,
      decoration: decoration,
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
    this.error,
    this.onChanged,
    this.fullWidth = false,
    this.styles,
    this.decoration,
    super.key,
  });

  @override
  Widget build(BuildContext context) =>
      FieldIdentity(id: id, builder: _buildField);

  Widget _buildField(String fieldId) {
    final bool hasError = error != null;

    final Map<String, String> sizeStyles = switch (size) {
      ComponentSize.sm => {
        'height': '36px',
        'padding': '0 12px',
        'font-size': '14px',
      },
      ComponentSize.md => {
        'height': '40px',
        'padding': '8px 12px',
        'font-size': '16px',
      },
      ComponentSize.lg => {
        'height': '44px',
        'padding': '0 16px',
        'font-size': '16px',
      },
    };

    final Widget selectElement = jaspr.Component.element(
      tag: 'select',
      id: fieldId,
      classes: 'arcane-select',
      attributes: {
        'name': ?name,
        'data-arcane-field-control': 'true',
        // Lets a theme key its own height table on the size (the inline px
        // table above is the modern one).
        'data-size': size.name,
        if (disabled) 'disabled': 'true',
        if (required) 'required': 'true',
        if (hasError) 'aria-invalid': 'true',
        if (hasError) 'aria-describedby': '$fieldId-error',
      },
      styles: dom.Styles(
        raw: {
          ...sizeStyles,
          'display': 'block',
          'max-width': '100%',
          'padding-right': '40px',
          'font-family': 'inherit',
          'background-color': 'var(--background)',
          'border': hasError
              ? '1px solid var(--destructive)'
              : '1px solid var(--input)',
          'border-radius': '0.375rem',
          'color': 'var(--foreground)',
          'transition':
              'color 150ms ease, border-color 150ms ease, box-shadow 150ms ease',
          'cursor': 'pointer',
          'appearance': 'none',
          '-webkit-appearance': 'none',
          if (fullWidth) 'width': '100%',
          if (disabled) 'opacity': '0.5',
          if (disabled) 'cursor': 'not-allowed',
          ...?decoration?.universalStyles(),
          ...?styles?.toMap(),
        },
      ),
      events: {
        if (onChanged != null)
          'change': (e) {
            onChanged!(domInputValue(e.target));
          },
      },
      children: [
        if (placeholder != null)
          jaspr.Component.element(
            tag: 'option',
            attributes: <String, String>{
              'value': '',
              'disabled': 'true',
              if (value == null || value!.isEmpty) 'selected': 'true',
            },
            children: [jaspr.Component.text(placeholder!)],
          ),
        for (final opt in options)
          jaspr.Component.element(
            tag: 'option',
            attributes: {
              'value': opt.value,
              if (opt.disabled) 'disabled': 'true',
              if (value == opt.value) 'selected': 'true',
            },
            children: [jaspr.Component.text(opt.label)],
          ),
      ],
    );

    // The chevron is positioned against the shell, so the shell must stay the
    // width of the select: a flex or grid parent would otherwise stretch it
    // and leave the glyph floating past the control's edge.
    final Widget selectShell = dom.div(
      classes: 'arcane-native-select-shell',
      attributes: const <String, String>{'data-arcane-field-shell': 'true'},
      styles: dom.Styles(
        raw: <String, String>{
          'position': 'relative',
          'display': fullWidth ? 'block' : 'inline-block',
          if (fullWidth) 'width': '100%',
          if (!fullWidth) 'width': 'fit-content',
          if (!fullWidth) 'max-width': '100%',
        },
      ),
      <Widget>[
        selectElement,
        dom.span(
          classes: 'arcane-native-select-chevron',
          attributes: const <String, String>{'aria-hidden': 'true'},
          styles: const dom.Styles(
            raw: <String, String>{
              'position': 'absolute',
              'right': '14px',
              'top': '50%',
              'display': 'inline-flex',
              'align-items': 'center',
              'justify-content': 'center',
              'color': 'var(--muted-foreground)',
              'pointer-events': 'none',
              'transform': 'translateY(-50%)',
            },
          ),
          <Widget>[ArcaneIcon.chevronDown(size: IconSize.sm)],
        ),
      ],
    );

    if (label != null || error != null) {
      return dom.div(
        classes: 'arcane-select-wrapper',
        styles: dom.Styles(
          raw: {
            'display': 'flex',
            'flex-direction': 'column',
            'gap': '0.25rem',
            if (fullWidth) 'width': '100%',
          },
        ),
        [
          if (label != null)
            jaspr.Component.element(
              tag: 'label',
              attributes: <String, String>{'for': fieldId},
              styles: const dom.Styles(
                raw: {
                  'font-size': '1rem',
                  'font-weight': '500',
                  'color': 'var(--foreground)',
                },
              ),
              children: [
                jaspr.Component.text(label!),
                if (required)
                  const dom.span(
                    styles: dom.Styles(
                      raw: {
                        'color': 'var(--destructive)',
                        'margin-left': '0.25rem',
                      },
                    ),
                    [jaspr.Component.text('*')],
                  ),
              ],
            ),
          selectShell,
          if (error != null)
            dom.span(
              id: '$fieldId-error',
              classes: 'arcane-select-error',
              styles: const dom.Styles(
                raw: {'font-size': '0.875rem', 'color': 'var(--destructive)'},
              ),
              [jaspr.Component.text(error!)],
            ),
        ],
      );
    }

    return selectShell;
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
