import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/dom_value.dart';
import 'package:arcane_jaspr/core/interaction/interaction_attrs.dart';
import 'package:arcane_jaspr/core/props/toggle_switch_props.dart';
import 'package:arcane_jaspr/core/rendering/base/toggle_switch_render_base.dart';

/// ShadCN v4 switch renderer.
///
/// Reference: https://ui.shadcn.com/docs/components/switch
///
/// Track `h-[1.15rem] w-8 border border-transparent shadow-xs bg-input
/// data-[state=checked]:bg-primary dark:bg-input/80`; thumb `size-4
/// bg-background translate-x-[calc(100%-2px)]` when checked. Both use the
/// 8px `--radius-md` cap instead of a pill.
class ShadcnToggleSwitch extends ToggleSwitchRenderBase {
  const ShadcnToggleSwitch(super.props, {super.key});

  @override
  Component buildSwitch(
    ToggleSwitchProps props,
    Map<String, String> itemAttrs,
  ) {
    // The track is two thumbs wide plus its 1px borders, so the checked
    // offset is always `calc(100% - 2px)` of the thumb.
    final int thumbSize = switch (props.size) {
      ComponentSize.sm => 14,
      ComponentSize.md => 16,
      ComponentSize.lg => 20,
    };
    final int trackWidth = thumbSize * 2;
    final int trackHeight = thumbSize + 2;

    final String activeColor = switch (props.color) {
      ColorVariant.primary => 'var(--primary)',
      ColorVariant.secondary => 'var(--secondary)',
      ColorVariant.destructive => 'var(--destructive)',
      ColorVariant.success => 'var(--success, #22c55e)',
      ColorVariant.warning => 'var(--warning, #f59e0b)',
      ColorVariant.info => 'var(--info, #3b82f6)',
    };

    return dom.button(
      classes:
          'arcane-toggle-switch ${props.value ? 'active' : ''} ${props.disabled ? 'disabled' : ''}',
      attributes: mergeAttrs(<Map<String, String>>[
        <String, String>{
          'type': 'button',
          'role': 'switch',
          'aria-checked': props.value.toString(),
          if (props.disabled) 'disabled': 'true',
          'data-state': props.value ? 'checked' : 'unchecked',
          'data-disabled': '${props.disabled}',
          'data-arcane-intrinsic-shape': 'switch-track',
        },
        itemAttrs,
      ]),
      styles: dom.Styles(
        raw: <String, String>{
          'position': 'relative',
          'display': 'inline-flex',
          'align-items': 'center',
          'flex-shrink': '0',
          'width': '${trackWidth}px',
          'height': '${trackHeight}px',
          'padding': '0',
          'border': '1px solid var(--shadcn-control-border-color, transparent)',
          'border-radius': 'var(--radius-md)',
          '--shadcn-switch-active': activeColor,
          'background-color':
              'var(--shadcn-switch-background, var(--shadcn-switch-track, var(--input)))',
          'box-shadow': 'var(--shadcn-control-shadow, var(--shadow-xs))',
          'cursor': props.disabled ? 'not-allowed' : 'pointer',
          'opacity': props.disabled ? '0.5' : '1',
          'pointer-events': props.disabled ? 'none' : 'auto',
          'transition':
              'background-color var(--transition), border-color var(--transition), box-shadow var(--transition)',
          'outline': 'none',
          'box-sizing': 'border-box',
          ...?props.decoration?.universalStyles(),
          ...?props.styles?.toMap(),
        },
      ),
      events: <String, EventCallback>{
        'click': (event) {
          if (!props.disabled && props.onChanged != null) {
            domPreventDefault(event);
            props.onChanged!(!props.value);
          }
        },
      },
      <Component>[
        dom.span(
          classes: 'arcane-toggle-thumb',
          attributes: <String, String>{
            'data-state': props.value ? 'checked' : 'unchecked',
            'data-arcane-intrinsic-shape': 'switch-thumb',
          },
          styles: dom.Styles(
            raw: <String, String>{
              'display': 'block',
              'width': '${thumbSize}px',
              'height': '${thumbSize}px',
              'border-radius': 'var(--radius-md)',
              'background-color':
                  'var(--shadcn-switch-thumb, var(--background))',
              'transform': 'translateX(var(--shadcn-switch-offset, 0px))',
              'transition':
                  'transform var(--transition), background-color var(--transition)',
              'pointer-events': 'none',
              'flex-shrink': '0',
            },
          ),
          <Component>[],
        ),
      ],
    );
  }

  @override
  String get labelClasses => 'arcane-toggle-label';

  @override
  Map<String, String> labelStyles(ToggleSwitchProps props) => <String, String>{
    // ShadCN: text-sm font-medium leading-none
    // peer-disabled:cursor-not-allowed peer-disabled:opacity-70
    'font-size': 'var(--font-size-sm)', // 14px
    'font-weight': 'var(--font-weight-medium)',
    'color': props.disabled ? 'var(--muted-foreground)' : 'var(--foreground)',
    'user-select': 'none',
    'line-height': '1',
  };

  @override
  Component buildWrapper(
    ToggleSwitchProps props,
    Map<String, String> rootAttrs,
    List<Component> children,
  ) {
    return dom.label(
      classes: 'arcane-toggle-wrapper',
      attributes: mergeAttrs(<Map<String, String>>[
        rootAttrs,
        <String, String>{
          'data-state': props.value ? 'checked' : 'unchecked',
          'data-disabled': '${props.disabled}',
        },
      ]),
      styles: dom.Styles(
        raw: <String, String>{
          'display': 'inline-flex',
          'align-items': 'center',
          'gap': 'var(--space-2)', // gap-2
          'cursor': props.disabled ? 'not-allowed' : 'pointer',
        },
      ),
      children,
    );
  }
}
