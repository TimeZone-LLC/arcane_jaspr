import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/dom_value.dart';
import 'package:arcane_jaspr/core/interaction/interaction_attrs.dart';
import 'package:arcane_jaspr/core/props/toggle_switch_props.dart';
import 'package:arcane_jaspr/core/rendering/base/toggle_switch_render_base.dart';

/// ShadCN Toggle Switch renderer.
///
/// Outputs the exact HTML structure and CSS from ui.shadcn.com.
/// Reference: https://ui.shadcn.com/docs/components/switch
class ShadcnToggleSwitch extends ToggleSwitchRenderBase {
  const ShadcnToggleSwitch(super.props, {super.key});

  @override
  Component buildSwitch(
    ToggleSwitchProps props,
    Map<String, String> itemAttrs,
  ) {
    // ShadCN size-specific dimensions
    // Default: w-11 h-6 (44px x 24px), thumb h-5 w-5 (20px)
    final (
      double width,
      double height,
      double thumbSize,
      double thumbOffset,
    ) = switch (props.size) {
      ComponentSize.sm => (36.0, 20.0, 16.0, 2.0), // w-9 h-5, thumb h-4
      ComponentSize.md => (
        44.0,
        24.0,
        20.0,
        2.0,
      ), // w-11 h-6, thumb h-5 (shadcn)
      ComponentSize.lg => (56.0, 28.0, 24.0, 2.0), // w-14 h-7, thumb h-6
    };

    // ShadCN: translate-x-0 (off) / translate-x-5 (on)
    final double thumbTranslate = width - thumbSize - thumbOffset * 2 - 2;

    // Get color variant colors - inactive uses muted with border for better visibility
    final (String activeColor, String inactiveColor) = switch (props.color) {
      ColorVariant.primary => ('var(--primary)', 'var(--muted)'),
      ColorVariant.secondary => ('var(--secondary)', 'var(--muted)'),
      ColorVariant.destructive => ('var(--destructive)', 'var(--muted)'),
      ColorVariant.success => ('var(--success, #22c55e)', 'var(--muted)'),
      ColorVariant.warning => ('var(--warning, #f59e0b)', 'var(--muted)'),
      ColorVariant.info => ('var(--info, #3b82f6)', 'var(--muted)'),
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
          'width': '${width}px',
          'height': '${height}px',
          'padding': '${thumbOffset}px',
          'border':
              '1px solid var(--shadcn-switch-border, var(--shadcn-control-border))',
          'border-radius': 'var(--radius-sm)',
          // ShadCN: bg-input (off) / bg-primary (on)
          '--shadcn-switch-active': activeColor,
          '--shadcn-switch-off': inactiveColor,
          '--shadcn-switch-travel': '${thumbTranslate}px',
          'background-color':
              'var(--shadcn-switch-background, var(--shadcn-switch-off))',
          'cursor': props.disabled ? 'not-allowed' : 'pointer',
          // ShadCN: disabled:opacity-50 disabled:cursor-not-allowed
          'opacity': props.disabled ? '0.5' : '1',
          'pointer-events': props.disabled ? 'none' : 'auto',
          // ShadCN: transition-colors
          'transition':
              'background-color var(--transition), border-color var(--transition)',
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
        // Thumb - ShadCN styling
        // ShadCN: pointer-events-none block h-5 w-5 rounded-full
        // bg-background shadow-lg ring-0 transition-transform
        // data-[state=checked]:translate-x-5 data-[state=unchecked]:translate-x-0
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
              'border-radius': '50%',
              // ShadCN: bg-background
              'background-color': 'var(--background)',
              // ShadCN: shadow-lg
              'box-shadow':
                  '0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)',
              // ShadCN: transition-transform
              'transform': 'translateX(var(--shadcn-switch-offset, 0px))',
              'transition': 'transform var(--transition)',
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
