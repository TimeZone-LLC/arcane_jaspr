import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart';

import 'package:arcane_jaspr/core/props/checkbox_props.dart';
import 'package:arcane_jaspr/core/rendering/base/checkbox_render_base.dart';

/// A sunken checkbox well beside its label and description.
class Win95Checkbox extends CheckboxRenderBase {
  const Win95Checkbox(super.props, {super.key});

  @override
  String wrapperClasses(CheckboxProps props) =>
      'win95-checkbox-wrapper ${props.disabled ? 'disabled' : ''}';

  @override
  Map<String, String> extraWrapperAttrs(CheckboxProps props) =>
      <String, String>{
        'data-variant': props.color.name,
        'data-size': props.size.name,
      };

  /// A one-line caption centres on the well. With a description the caption
  /// grows downward, so the well pins to the first line instead.
  @override
  Map<String, String> wrapperStyles(CheckboxProps props) => <String, String>{
    'display': 'flex',
    'align-items': props.description == null ? 'center' : 'flex-start',
    'gap': '0.5rem',
    'min-height': '24px',
  };

  @override
  Map<String, String> labelTextStyles(CheckboxProps props) =>
      const <String, String>{'display': 'block'};

  /// Matches `.win95-radio-description`, one step under the caption.
  @override
  Map<String, String> descriptionTextStyles(CheckboxProps props) =>
      const <String, String>{
        'display': 'block',
        'margin-top': '0.2rem',
        'color': 'var(--muted-foreground)',
        'font-size': '0.875em',
        'line-height': '1.4',
      };

  @override
  Component buildBox(CheckboxProps props, Map<String, String> itemAttrs) =>
      dom.div(
        classes: 'win95-checkbox-box',
        attributes: itemAttrs,
        styles: dom.Styles(
          raw: <String, String>{
            'display': 'flex',
            'align-items': 'center',
            'justify-content': 'center',
            'flex-shrink': '0',
            // Centres the 13px well on the 18px first caption line.
            if (props.description != null) 'margin-top': '2px',
            ...?props.decoration?.universalStyles(),
            ...?props.styles?.toMap(),
          },
        ),
        const <Component>[],
      );
}
