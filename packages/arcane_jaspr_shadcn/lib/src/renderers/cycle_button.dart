import 'dart:convert';

import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart'
    hide
        Color,
        Colors,
        ColorScheme,
        Gap,
        Padding,
        TextAlign,
        TextOverflow,
        Border,
        BorderRadius,
        BoxShadow,
        FontWeight;

import 'package:arcane_jaspr/core/props/cycle_button_props.dart';
import 'package:arcane_jaspr/core/interaction/interaction.dart';
import 'package:arcane_jaspr/core/interaction/interaction_attrs.dart';

/// Shared v4 button/toggle heights: sm h-8, default h-9, lg h-10.
Map<String, String> _shadcnSizeStyles(
  CycleButtonSize size, {
  required bool toggle,
}) => switch (size) {
  CycleButtonSize.small => <String, String>{
    'height': '2rem',
    'min-width': '2rem',
    'padding': toggle ? '0 0.375rem' : '0 0.75rem',
    'gap': '0.375rem',
  },
  CycleButtonSize.medium => <String, String>{
    'height': '2.25rem',
    'min-width': '2.25rem',
    'padding': toggle ? '0 0.5rem' : '0 1rem',
  },
  CycleButtonSize.large => <String, String>{
    'height': '2.5rem',
    'min-width': '2.5rem',
    'padding': toggle ? '0 0.625rem' : '0 1.5rem',
  },
  CycleButtonSize.icon => <String, String>{
    'height': '2.25rem',
    'width': '2.25rem',
    'padding': '0',
  },
  CycleButtonSize.iconSmall => <String, String>{
    'height': '2rem',
    'width': '2rem',
    'padding': '0',
  },
  CycleButtonSize.iconLarge => <String, String>{
    'height': '2.5rem',
    'width': '2.5rem',
    'padding': '0',
  },
};

const Map<String, String> _shadcnControlBase = <String, String>{
  'display': 'inline-flex',
  'align-items': 'center',
  'justify-content': 'center',
  'gap': '0.5rem',
  'box-sizing': 'border-box',
  'border-radius': 'var(--radius-md)',
  'font-size': '0.875rem',
  'font-weight': '500',
  'line-height': '1.25rem',
  'white-space': 'nowrap',
  'outline': 'none',
  'transition':
      'color var(--transition), background-color var(--transition), '
      'border-color var(--transition), box-shadow var(--transition)',
};

/// ShadCN Cycle Button renderer.
///
/// Carries `data-variant` so the shared button CSS supplies colours, the
/// single hover fill and the focus ring; only geometry is inline.
class ShadcnCycleButton<T> extends StatelessComponent {
  final CycleButtonProps<T> props;

  const ShadcnCycleButton(this.props);

  @override
  Component build(BuildContext context) {
    final List<CycleOption<T>> options = props.options;
    final int currentIndex = options.indexWhere((o) => o.value == props.value);
    final int safeIndex = currentIndex >= 0 ? currentIndex : 0;
    final CycleOption<T> currentOption = options[safeIndex];
    final String cycleId =
        props.id ?? 'cycle-${identityHashCode(props).toRadixString(36)}';

    final List<String> values = options.map((o) => o.value.toString()).toList();
    final List<String> labels = options
        .map((o) => o.label ?? o.value.toString())
        .toList();

    final ArcaneInteraction action = ArcaneInteraction.cycleNext(cycleId);

    final Map<String, String> attrs = <String, String>{
      'type': 'button',
      'data-variant': props.variant.name,
      'data-disabled': '${props.disabled}',
      'data-arcane-cycle': cycleId,
      'data-arcane-cycle-active': safeIndex.toString(),
      'data-arcane-cycle-values': jsonEncode(values),
      'data-arcane-cycle-labels': jsonEncode(labels),
      'data-arcane-value': values[safeIndex],
      if (props.disabled) 'disabled': 'true',
      if (props.disabled) 'data-arcane-disabled': 'true',
      ...interactionAttrs(action),
      ...?props.attributes,
    };

    return button(
      id: props.id,
      classes: 'arcane-cycle-button ${props.disabled ? 'disabled' : ''}',
      attributes: attrs,
      styles: Styles(
        raw: <String, String>{
          ..._shadcnControlBase,
          ..._shadcnSizeStyles(props.size, toggle: false),
          'box-shadow': props.variant == CycleButtonVariant.ghost
              ? 'var(--shadcn-control-shadow, none)'
              : 'var(--shadcn-control-shadow, var(--shadow-xs))',
          'cursor': props.disabled ? 'not-allowed' : 'pointer',
          'pointer-events': props.disabled ? 'none' : 'auto',
          'opacity': props.disabled ? '0.5' : '1',
          ...?props.decoration?.universalStyles(),
          ...?props.styles?.toMap(),
        },
      ),
      events: props.onChanged == null
          ? null
          : <String, EventCallback>{
              'click': (event) {
                if (props.disabled) return;
                final int next = (safeIndex + 1) % options.length;
                props.onChanged!(options[next].value);
              },
            },
      <Component>[
        if (currentOption.icon != null) currentOption.icon!,
        span(
          classes: 'arcane-cycle-button-label',
          attributes: const <String, String>{'data-arcane-cycle-label': ''},
          [
            Component.text(
              currentOption.label ?? currentOption.value.toString(),
            ),
          ],
        ),
      ],
    );
  }
}

/// ShadCN Toggle Button renderer (v4 outline Toggle).
///
/// `border-input bg-transparent shadow-xs hover:bg-accent`; the "on" fill is
/// `bg-accent text-accent-foreground`, applied by the theme CSS from the
/// runtime-maintained `data-arcane-state`.
class ShadcnToggleButton extends StatelessComponent {
  final ToggleButtonProps props;

  const ShadcnToggleButton(this.props);

  @override
  Component build(BuildContext context) {
    final String groupId =
        props.id ?? 'toggle-${identityHashCode(props).toRadixString(36)}';
    final ArcaneInteraction action = ArcaneInteraction.toggleValue(
      groupId,
      'on',
    );

    final Map<String, String> attrs = <String, String>{
      'type': 'button',
      'aria-pressed': '${props.value}',
      'data-arcane-group': groupId,
      'data-arcane-group-mode': 'multi',
      'data-arcane-value': 'on',
      'data-arcane-state': props.value ? 'on' : 'off',
      if (props.value) 'data-arcane-selected': 'true',
      if (props.disabled) 'disabled': 'true',
      if (props.disabled) 'data-arcane-disabled': 'true',
      ...interactionAttrs(action),
      ...?props.attributes,
    };

    return button(
      id: props.id,
      classes:
          'arcane-toggle-button ${props.value ? 'active' : ''} ${props.disabled ? 'disabled' : ''}',
      attributes: attrs,
      styles: Styles(
        raw: <String, String>{
          ..._shadcnControlBase,
          ..._shadcnSizeStyles(props.size, toggle: true),
          'border':
              '1px solid var(--shadcn-control-border-color, var(--input))',
          'box-shadow': 'var(--shadcn-control-shadow, var(--shadow-xs))',
          'background-color': 'var(--shadcn-item-background, transparent)',
          'color': 'var(--shadcn-item-foreground, inherit)',
          'cursor': props.disabled ? 'not-allowed' : 'pointer',
          'pointer-events': props.disabled ? 'none' : 'auto',
          'opacity': props.disabled ? '0.5' : '1',
          ...?props.decoration?.universalStyles(),
          ...?props.styles?.toMap(),
        },
      ),
      events: props.onChanged == null
          ? null
          : <String, EventCallback>{
              'click': (event) {
                if (!props.disabled) {
                  props.onChanged!(!props.value);
                }
              },
            },
      <Component>[
        if (props.icon != null) props.icon!,
        if (props.label != null) Component.text(props.label!),
      ],
    );
  }
}
