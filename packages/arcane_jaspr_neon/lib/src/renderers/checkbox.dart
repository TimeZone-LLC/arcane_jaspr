import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart';

import 'package:arcane_jaspr/component/view/icon.dart';
import 'package:arcane_jaspr/core/props/checkbox_props.dart';
import 'package:arcane_jaspr/core/rendering/base/checkbox_render_base.dart';

/// Compact checkbox with a semantic checkmark and supporting label.
class NeonCheckbox extends CheckboxRenderBase {
  const NeonCheckbox(super.props, {super.key});

  @override
  String wrapperClasses(CheckboxProps props) =>
      'neon-checkbox-wrapper ${props.disabled ? 'disabled' : ''}';

  @override
  Map<String, String> extraWrapperAttrs(CheckboxProps props) =>
      <String, String>{
        'data-variant': props.color.name,
        'data-size': props.size.name,
      };

  @override
  Map<String, String> wrapperStyles(CheckboxProps props) => <String, String>{
    'display': 'flex',
    'align-items': 'flex-start',
    'gap': '0.625rem',
    'cursor': props.disabled ? 'not-allowed' : 'pointer',
    if (props.disabled) 'opacity': '0.5',
  };

  @override
  Map<String, String> labelTextStyles(CheckboxProps props) =>
      const <String, String>{
        'display': 'block',
        'font-size': 'var(--font-size-sm)',
        'line-height': '1.4',
        'font-weight': '600',
      };

  @override
  Map<String, String> descriptionTextStyles(CheckboxProps props) =>
      const <String, String>{
        'display': 'block',
        'margin-top': '0.25rem',
        'color': 'var(--muted-foreground)',
        'font-size': 'var(--font-size-sm)',
        'line-height': '1.5',
      };

  @override
  Component buildBox(CheckboxProps props, Map<String, String> itemAttrs) =>
      dom.div(
        classes: 'neon-checkbox-box',
        attributes: itemAttrs,
        styles: dom.Styles(
          raw: <String, String>{
            'display': 'flex',
            'align-items': 'center',
            'justify-content': 'center',
            'flex-shrink': '0',
            ...?props.decoration?.universalStyles(),
            ...?props.styles?.toMap(),
          },
        ),
        <Component>[
          dom.span(
            classes: 'neon-checkbox-indicator',
            attributes: const <String, String>{'aria-hidden': 'true'},
            <Component>[ArcaneIcon.check(size: IconSize.xs)],
          ),
        ],
      );
}
