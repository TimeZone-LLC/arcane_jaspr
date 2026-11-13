import 'package:arcane_jaspr/component/view/icon.dart';
import 'package:arcane_jaspr/core/dom_value.dart';
import 'package:arcane_jaspr/core/props/native_select_props.dart';
import 'package:arcane_jaspr/core/rendering/base/style_layering.dart';
import 'package:arcane_jaspr/core/rendering/field_identity.dart';
import 'package:arcane_jaspr/core/shared/shared.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart';

/// Native select markup shared by renderers, with theme-owned field geometry.
abstract class NativeSelectRenderBase extends StatelessComponent {
  const NativeSelectRenderBase(this.props, {super.key});

  final NativeSelectProps props;

  String get wrapperGap => '0.25rem';

  Map<String, String> get labelStyles => const <String, String>{
    'font-size': '1rem',
    'font-weight': '500',
    'color': 'var(--foreground)',
  };

  Map<String, String> get selectStyles {
    final Map<String, String> sizeStyles = switch (props.size) {
      ComponentSize.sm => <String, String>{
        'height': '36px',
        'padding': '0 12px',
        'font-size': '14px',
      },
      ComponentSize.md => <String, String>{
        'height': '40px',
        'padding': '8px 12px',
        'font-size': '16px',
      },
      ComponentSize.lg => <String, String>{
        'height': '44px',
        'padding': '0 16px',
        'font-size': '16px',
      },
    };
    return <String, String>{
      ...sizeStyles,
      'display': 'block',
      'max-width': '100%',
      'padding-right': '40px',
      'font-family': 'var(--font-control, inherit)',
      'background-color': 'var(--background)',
      'border': props.error != null
          ? '1px solid var(--destructive)'
          : '1px solid var(--input)',
      'border-radius': 'var(--radius-sm)',
      'color': 'var(--foreground)',
      'transition':
          'color 150ms ease, border-color 150ms ease, box-shadow 150ms ease',
      'cursor': 'pointer',
      'appearance': 'none',
      '-webkit-appearance': 'none',
      if (props.fullWidth) 'width': '100%',
      if (props.disabled) 'opacity': '0.5',
      if (props.disabled) 'cursor': 'not-allowed',
    };
  }

  @override
  Component build(BuildContext context) =>
      FieldIdentity(id: props.id, builder: _buildField);

  Component _buildField(String fieldId) {
    final bool hasError = props.error != null;
    final Component select = Component.element(
      tag: 'select',
      id: fieldId,
      classes: 'arcane-select',
      attributes: <String, String>{
        'name': ?props.name,
        'data-arcane-field-control': 'true',
        'data-size': props.size.name,
        'aria-label': ?props.ariaLabel,
        if (props.disabled) 'disabled': 'true',
        if (props.required) 'required': 'true',
        if (hasError) 'aria-invalid': 'true',
        if (hasError) 'aria-describedby': '$fieldId-error',
      },
      styles: dom.Styles(
        raw: layerStyles(selectStyles, <Map<String, String>?>[
          props.decoration?.universalStyles(),
          props.styles?.toMap(),
        ]),
      ),
      events: <String, EventCallback>{
        if (props.onChange != null)
          'change': (event) => props.onChange!(domInputValue(event.target)),
      },
      children: <Component>[
        if (props.placeholder != null)
          Component.element(
            tag: 'option',
            attributes: <String, String>{
              'value': '',
              'disabled': 'true',
              if (props.value == null || props.value!.isEmpty)
                'selected': 'true',
            },
            children: <Component>[Component.text(props.placeholder!)],
          ),
        for (final NativeSelectOptionProps option in props.options)
          Component.element(
            tag: 'option',
            attributes: <String, String>{
              'value': option.value,
              if (option.disabled) 'disabled': 'true',
              if (props.value == option.value) 'selected': 'true',
            },
            children: <Component>[Component.text(option.label)],
          ),
      ],
    );

    // Position the chevron against the control, even in a stretching parent.
    final Component shell = dom.div(
      classes: 'arcane-native-select-shell',
      attributes: const <String, String>{'data-arcane-field-shell': 'true'},
      styles: dom.Styles(
        raw: <String, String>{
          'position': 'relative',
          'display': props.fullWidth ? 'block' : 'inline-block',
          if (props.fullWidth) 'width': '100%',
          if (!props.fullWidth) 'width': 'fit-content',
          if (!props.fullWidth) 'max-width': '100%',
        },
      ),
      <Component>[
        select,
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
          <Component>[ArcaneIcon.chevronDown(size: IconSize.sm)],
        ),
      ],
    );

    if (props.label == null && props.error == null) return shell;

    return dom.div(
      classes: 'arcane-select-wrapper',
      attributes: <String, String>{'data-size': props.size.name},
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
            classes: 'arcane-select-label',
            attributes: <String, String>{'for': fieldId},
            styles: dom.Styles(raw: labelStyles),
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
        shell,
        if (props.error != null)
          dom.span(
            id: '$fieldId-error',
            classes: 'arcane-select-error',
            styles: const dom.Styles(
              raw: <String, String>{
                'font-size': '0.875rem',
                'color': 'var(--destructive)',
              },
            ),
            <Component>[Component.text(props.error!)],
          ),
      ],
    );
  }
}

/// Native select recipe used outside an Arcane theme provider.
class DefaultNativeSelectRenderer extends NativeSelectRenderBase {
  const DefaultNativeSelectRenderer(super.props, {super.key});
}
