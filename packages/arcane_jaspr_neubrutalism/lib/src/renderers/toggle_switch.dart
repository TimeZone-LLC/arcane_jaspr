import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart';

import 'package:arcane_jaspr/core/interaction/interaction_attrs.dart';
import 'package:arcane_jaspr/core/props/toggle_switch_props.dart';
import 'package:arcane_jaspr/core/dom_value.dart';
import 'package:arcane_jaspr/core/rendering/base/toggle_switch_render_base.dart';

class NeubrutalismToggleSwitch extends ToggleSwitchRenderBase {
  const NeubrutalismToggleSwitch(super.props, {super.key});

  @override
  Component buildSwitch(
    ToggleSwitchProps props,
    Map<String, String> itemAttrs,
  ) {
    (double, double, double, double) sizing = switch (props.size) {
      ComponentSize.sm => (44.0, 24.0, 16.0, 4.0),
      ComponentSize.md => (52.0, 28.0, 20.0, 4.0),
      ComponentSize.lg => (60.0, 32.0, 24.0, 4.0),
    };
    double width = sizing.$1;
    double height = sizing.$2;
    double thumbSize = sizing.$3;
    double inset = sizing.$4;

    String tone = switch (props.color) {
      ColorVariant.primary => 'var(--nb-accent, var(--primary))',
      ColorVariant.secondary => 'var(--nb-accent-cool, var(--secondary))',
      ColorVariant.destructive => 'var(--destructive)',
      ColorVariant.success => 'var(--success)',
      ColorVariant.warning => 'var(--warning)',
      ColorVariant.info => 'var(--info)',
    };

    double thumbTranslate = props.value ? (width - thumbSize - (inset * 2)) : 0;

    return dom.button(
      classes:
          'neubrutalism-toggle-switch ${props.value ? 'active' : ''} ${props.disabled ? 'disabled' : ''}',
      attributes: mergeAttrs(<Map<String, String>>[
        <String, String>{
          'type': 'button',
          'role': 'switch',
          'aria-checked': '${props.value}',
          'data-state': props.value ? 'checked' : 'unchecked',
          'data-disabled': '${props.disabled}',
          'data-variant': props.color.name,
          'data-size': props.size.name,
          'data-arcane-intrinsic-shape': 'switch-track',
          if (props.disabled) 'disabled': 'true',
        },
        itemAttrs,
      ]),
      styles: dom.Styles(
        raw: <String, String>{
          'position': 'relative',
          'display': 'inline-flex',
          'align-items': 'center',
          'width': '${width}px',
          'height': '${height}px',
          'padding': '${inset}px',
          'border-radius': 'var(--nb-radius-soft, 4px)',
          'border': 'var(--nb-border-thick, 3px) solid var(--nb-line, #000)',
          'background-color': props.value
              ? tone
              : 'var(--nb-paper, var(--card))',
          'box-shadow':
              'var(--nb-shadow-sm, 3px 3px 0 0 var(--nb-shadow-color, #000))',
          'cursor': props.disabled ? 'not-allowed' : 'pointer',
          'opacity': props.disabled ? '0.5' : '1',
          'pointer-events': props.disabled ? 'none' : 'auto',
          'transition':
              'background-color 120ms cubic-bezier(0.2, 0.8, 0.2, 1), box-shadow 120ms cubic-bezier(0.2, 0.8, 0.2, 1)',
          'outline': 'none',
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
      <Component>[
        dom.span(
          classes: 'neubrutalism-toggle-switch-thumb',
          attributes: const <String, String>{
            'data-arcane-intrinsic-shape': 'switch-thumb',
          },
          styles: dom.Styles(
            raw: <String, String>{
              'display': 'block',
              'width': '${thumbSize}px',
              'height': '${thumbSize}px',
              'border-radius': '50%',
              'background-color': 'var(--nb-paper, #fff)',
              'border':
                  'var(--nb-border-thick, 3px) solid var(--nb-line, #000)',
              'transform': 'translateX(${thumbTranslate}px)',
              'transition': 'transform 220ms cubic-bezier(0.4, 0.1, 0.3, 1)',
              'pointer-events': 'none',
            },
          ),
          const <Component>[],
        ),
      ],
    );
  }

  @override
  String get labelClasses => 'neubrutalism-toggle-label';

  @override
  Map<String, String> labelStyles(ToggleSwitchProps props) => <String, String>{
    'font-family': 'var(--font-sans)',
    'font-size': '0.875rem',
    'font-weight': '600',
    'color': props.disabled ? 'var(--muted-foreground)' : 'var(--foreground)',
    'user-select': 'none',
  };

  @override
  Component buildWrapper(
    ToggleSwitchProps props,
    Map<String, String> rootAttrs,
    List<Component> children,
  ) {
    return dom.label(
      classes: 'neubrutalism-toggle-wrapper',
      attributes: rootAttrs,
      styles: dom.Styles(
        raw: <String, String>{
          'display': 'inline-flex',
          'align-items': 'center',
          'gap': '0.625rem',
          'cursor': props.disabled ? 'not-allowed' : 'pointer',
        },
      ),
      children,
    );
  }
}
