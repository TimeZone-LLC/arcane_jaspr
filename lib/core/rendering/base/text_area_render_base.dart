import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart';

import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/dom_value.dart';
import 'package:arcane_jaspr/core/props/text_area_props.dart';
import 'package:arcane_jaspr/core/rendering/field_identity.dart';

/// Shared structural base for themed text-area renderers.
///
/// Every theme receives the same native textarea, label, error/helper structure,
/// attributes, sizing constraints, and input event wiring. Concrete renderers
/// own the paired surface/foreground colors and theme-specific visual states.
abstract class TextAreaRenderBase extends StatelessComponent {
  const TextAreaRenderBase(this.props, {super.key});

  final TextAreaProps props;

  /// Theme class prefix. The stable `arcane-textarea*` hooks are always emitted
  /// in addition to these theme-specific classes.
  String get classPrefix;

  /// Gap applied to the optional label/control/help column.
  String get wrapperGap => '0.25rem';

  /// Theme-owned styles for the native textarea.
  Map<String, String> textAreaStyles({
    required bool hasError,
    required bool isDisabled,
    required bool isReadOnly,
  });

  /// Theme-owned label styles.
  Map<String, String> labelStyles() => const <String, String>{
    'font-size': '1rem',
    'font-weight': '500',
    'color': 'var(--foreground)',
  };

  /// Theme-owned error text styles.
  Map<String, String> errorStyles() => const <String, String>{
    'font-size': '0.875rem',
    'color': 'var(--destructive)',
  };

  /// Theme-owned helper text styles.
  Map<String, String> helperStyles() => const <String, String>{
    'font-size': '0.875rem',
    'color': 'var(--muted-foreground)',
  };

  /// Per-instance decoration overrides. Default: none.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  @override
  Component build(BuildContext context) =>
      FieldIdentity(id: props.id, builder: _buildField);

  Component _buildField(String fieldId) {
    final bool hasError = props.error != null;
    final String? descriptionId = hasError
        ? '$fieldId-error'
        : props.helperText != null
        ? '$fieldId-helper'
        : null;
    final String resize = switch (props.resize) {
      TextAreaResize.none => 'none',
      TextAreaResize.vertical => 'vertical',
      TextAreaResize.horizontal => 'horizontal',
      TextAreaResize.both => 'both',
    };

    final Component textArea = Component.element(
      tag: 'textarea',
      id: fieldId,
      classes: _classes('arcane-textarea', '$classPrefix-textarea'),
      attributes: <String, String>{
        if (props.name != null) 'name': props.name!,
        if (props.placeholder != null) 'placeholder': props.placeholder!,
        'rows': props.rows.toString(),
        if (props.cols != null) 'cols': props.cols.toString(),
        if (props.disabled) 'disabled': 'true',
        if (props.required) 'required': 'true',
        if (props.readOnly) 'readonly': 'true',
        if (hasError) 'aria-invalid': 'true',
        'aria-describedby': ?descriptionId,
        if (hasError) 'data-error': 'true',
        if (props.readOnly) 'data-readonly': 'true',
      },
      styles: dom.Styles(
        raw: <String, String>{
          ...textAreaStyles(
            hasError: hasError,
            isDisabled: props.disabled,
            isReadOnly: props.readOnly,
          ),
          if (props.fullWidth) 'width': '100%',
          'resize': resize,
          if (props.minWidth != null) 'min-width': props.minWidth!,
          if (props.maxWidth != null) 'max-width': props.maxWidth!,
          if (props.minHeight != null) 'min-height': props.minHeight!,
          if (props.maxHeight != null) 'max-height': props.maxHeight!,
          if (props.disabled) 'cursor': 'not-allowed',
          if (props.disabled) 'opacity': '0.5',
          ...?props.decoration?.universalStyles(),
          ...decorationStyles(props.decoration),
          ..._literalOverrideStyles(props.styles?.toMap()),
        },
      ),
      events: <String, EventCallback>{
        if (props.onChanged != null)
          'input': (event) {
            props.onChanged!(domInputValue(event.target));
          },
      },
      children: props.value == null
          ? const <Component>[]
          : <Component>[Component.text(props.value!)],
    );

    if (props.label == null &&
        props.error == null &&
        props.helperText == null) {
      return textArea;
    }

    return dom.div(
      classes: _classes(
        'arcane-textarea-wrapper',
        '$classPrefix-textarea-wrapper',
      ),
      attributes: <String, String>{
        if (hasError) 'data-error': 'true',
        if (props.disabled) 'data-disabled': 'true',
        if (props.readOnly) 'data-readonly': 'true',
      },
      styles: dom.Styles(
        raw: <String, String>{
          'display': 'flex',
          'flex-direction': 'column',
          'gap': wrapperGap,
          if (props.fullWidth) 'width': '100%',
        },
      ),
      <Component>[
        if (props.label != null)
          Component.element(
            tag: 'label',
            classes: _classes(
              'arcane-textarea-label',
              '$classPrefix-textarea-label',
            ),
            attributes: <String, String>{'for': fieldId},
            styles: dom.Styles(raw: labelStyles()),
            children: <Component>[
              Component.text(props.label!),
              if (props.required)
                const dom.span(
                  styles: dom.Styles(
                    raw: <String, String>{
                      'color': 'var(--destructive)',
                      'margin-left': '0.25rem',
                    },
                  ),
                  <Component>[Component.text('*')],
                ),
            ],
          ),
        textArea,
        if (props.error != null)
          dom.span(
            id: descriptionId,
            classes: _classes(
              'arcane-textarea-error',
              '$classPrefix-textarea-error',
            ),
            styles: dom.Styles(raw: errorStyles()),
            <Component>[Component.text(props.error!)],
          )
        else if (props.helperText != null)
          dom.span(
            id: descriptionId,
            classes: _classes(
              'arcane-textarea-helper',
              '$classPrefix-textarea-helper',
            ),
            styles: dom.Styles(raw: helperStyles()),
            <Component>[Component.text(props.helperText!)],
          ),
      ],
    );
  }

  String _classes(String common, String themed) =>
      common == themed ? common : '$common $themed';
}

/// Backward-compatible text-area renderer used by custom themes that have not
/// provided a dedicated renderer and by standalone `TextArea` components
/// outside an Arcane theme provider.
///
/// Its styles preserve the original core TextArea appearance; bundled themes
/// override the renderer contract with their native renderer.
class DefaultTextAreaRenderer extends TextAreaRenderBase {
  const DefaultTextAreaRenderer(super.props, {super.key});

  @override
  String get classPrefix => 'arcane';

  @override
  Map<String, String> textAreaStyles({
    required bool hasError,
    required bool isDisabled,
    required bool isReadOnly,
  }) {
    return <String, String>{
      'padding': '0.5rem 1rem',
      'font-size': '1rem',
      'font-family': 'inherit',
      'line-height': '1.625',
      'background-color': isReadOnly ? 'var(--muted)' : 'var(--background)',
      'border': hasError
          ? '1px solid var(--destructive)'
          : '1px solid var(--input)',
      'border-radius': '0.375rem',
      'color': isReadOnly ? 'var(--muted-foreground)' : 'var(--foreground)',
      'caret-color': isReadOnly
          ? 'var(--muted-foreground)'
          : 'var(--foreground)',
      'transition':
          'color 150ms ease, border-color 150ms ease, box-shadow 150ms ease',
      'outline': 'none',
    };
  }
}

Map<String, String> _literalOverrideStyles(Map<String, String>? styles) {
  if (styles == null) {
    return const <String, String>{};
  }
  final RegExp terminalImportant = RegExp(
    r'!\s*important\s*$',
    caseSensitive: false,
  );
  final Map<String, String> overrides = styles.map(
    (String property, String value) => MapEntry<String, String>(
      property,
      terminalImportant.hasMatch(value) ? value : '$value !important',
    ),
  );

  // Win95 deliberately pins WebKit's independent glyph-paint property so
  // autofill cannot make field text illegible. Mirror a caller's literal color
  // override to that property so the public "literal styles win" contract
  // remains true in Blink/WebKit as well.
  final String? color = overrides['color'];
  if (color != null) {
    overrides.putIfAbsent('-webkit-text-fill-color', () => color);
  }
  return overrides;
}
