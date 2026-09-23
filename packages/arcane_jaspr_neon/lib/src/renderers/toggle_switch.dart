import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart';

import 'package:arcane_jaspr/core/dom_value.dart';
import 'package:arcane_jaspr/core/interaction/interaction_attrs.dart';
import 'package:arcane_jaspr/core/props/toggle_switch_props.dart';
import 'package:arcane_jaspr/core/rendering/base/toggle_switch_render_base.dart';

/// Neon Toggle Switch renderer (neutralized skeleton).
class NeonToggleSwitch extends ToggleSwitchRenderBase {
  const NeonToggleSwitch(super.props, {super.key});

  @override
  Component buildSwitch(
    ToggleSwitchProps props,
    Map<String, String> itemAttrs,
  ) {
    return dom.button(
      classes:
          'neon-toggle-switch ${props.value ? 'active' : ''} ${props.disabled ? 'disabled' : ''}',
      attributes: mergeAttrs(<Map<String, String>>[
        <String, String>{
          'type': 'button',
          'role': 'switch',
          'aria-checked': '${props.value}',
          'data-state': props.value ? 'checked' : 'unchecked',
          'data-disabled': '${props.disabled}',
          if (props.disabled) 'disabled': 'true',
        },
        itemAttrs,
      ]),
      styles: dom.Styles(
        raw: <String, String>{
          ...?props.decoration?.universalStyles(),
          ...?props.styles?.toMap(),
        },
      ),
      events: props.disabled || props.onChanged == null
          ? null
          : <String, EventCallback>{
              'click': (event) {
                domPreventDefault(event);
                props.onChanged!(!props.value);
              },
            },
      <Component>[const dom.span(classes: 'neon-toggle-thumb', <Component>[])],
    );
  }

  @override
  String get labelClasses => 'neon-toggle-label';

  @override
  Map<String, String> labelStyles(ToggleSwitchProps props) =>
      const <String, String>{};

  @override
  Component buildWrapper(
    ToggleSwitchProps props,
    Map<String, String> rootAttrs,
    List<Component> children,
  ) {
    return dom.label(
      classes: 'neon-toggle-wrapper',
      attributes: rootAttrs,
      children,
    );
  }
}
