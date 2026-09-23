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

  @override
  Map<String, String> wrapperStyles(CheckboxProps props) =>
      const <String, String>{
        'display': 'flex',
        'align-items': 'center',
        'gap': '0.5rem',
        'min-height': '24px',
      };

  @override
  Map<String, String> labelTextStyles(CheckboxProps props) =>
      const <String, String>{};

  @override
  Map<String, String> descriptionTextStyles(CheckboxProps props) =>
      const <String, String>{};

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
            ...?props.decoration?.universalStyles(),
            ...?props.styles?.toMap(),
          },
        ),
        const <Component>[],
      );
}
