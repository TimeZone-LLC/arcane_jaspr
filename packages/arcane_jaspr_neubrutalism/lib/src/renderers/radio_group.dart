import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart';

import 'package:arcane_jaspr/core/interaction/interaction_attrs.dart';
import 'package:arcane_jaspr/core/props/radio_group_props.dart';
import 'package:arcane_jaspr/core/rendering/base/radio_group_render_base.dart';

class NeubrutalismRadioGroup<T> extends RadioGroupRenderBase<T> {
  const NeubrutalismRadioGroup(super.props, {super.key});

  @override
  String get groupIdPrefix => 'nb-radio-';

  @override
  String get rootClasses =>
      'neubrutalism-radio-group ${props.disabled ? 'disabled' : ''}';

  @override
  Map<String, String> rootDataAttrs(String groupName) => <String, String>{
    'role': 'radiogroup',
    if (props.label != null) 'aria-labelledby': '$groupName-label',
    'data-disabled': '${props.disabled}',
    'data-layout': props.layout.name,
    'data-variant': props.variant.name,
  };

  @override
  Map<String, String> get rootStyles => <String, String>{
    'width': '100%',
    'opacity': props.disabled ? '0.55' : '1',
  };

  @override
  Component buildLabel(String groupName) => dom.div(
    id: '$groupName-label',
    classes: 'neubrutalism-radio-group-label',
    styles: const dom.Styles(
      raw: {
        'font-family': 'var(--font-heading)',
        'font-size': 'var(--font-size-xs)',
        'font-weight': 'var(--font-weight-semibold)',
        'letter-spacing': '0.08em',
        'text-transform': 'uppercase',
        'color': 'var(--muted-foreground)',
        'margin-bottom': '0.65rem',
      },
    ),
    [
      Component.text(props.label!),
      if (props.required)
        const dom.span(
          styles: dom.Styles(
            raw: {'color': 'var(--destructive)', 'margin-left': '0.35rem'},
          ),
          [Component.text('*')],
        ),
    ],
  );

  @override
  String get optionsClasses => 'neubrutalism-radio-group-options';

  @override
  Map<String, String> get optionsStyles => switch (props.layout) {
    RadioGroupLayout.vertical => {
      'display': 'flex',
      'flex-direction': 'column',
      'gap': props.gap,
    },
    RadioGroupLayout.horizontal => {
      'display': 'flex',
      'flex-wrap': 'wrap',
      'gap': props.gap,
    },
    RadioGroupLayout.grid => {
      'display': 'grid',
      'grid-template-columns': 'repeat(${props.gridColumns}, minmax(0, 1fr))',
      'gap': props.gap,
    },
  };

  @override
  List<Component> buildMessage() {
    if (props.error != null) {
      return <Component>[
        dom.div(
          classes: 'neubrutalism-radio-group-error',
          styles: const dom.Styles(
            raw: {
              'font-size': 'var(--font-size-sm)',
              'color': 'var(--destructive)',
              'margin-top': '0.6rem',
            },
          ),
          [Component.text(props.error!)],
        ),
      ];
    } else if (props.helperText != null) {
      return <Component>[
        dom.div(
          classes: 'neubrutalism-radio-group-helper',
          styles: const dom.Styles(
            raw: {
              'font-size': 'var(--font-size-sm)',
              'color': 'var(--muted-foreground)',
              'margin-top': '0.6rem',
            },
          ),
          [Component.text(props.helperText!)],
        ),
      ];
    }
    return const <Component>[];
  }

  @override
  Component buildStandardRadio(
    RadioOptionProps<T> option,
    String groupName,
    bool isSelected,
    bool isDisabled,
    bool hasError,
    Map<String, String> itemAttrs,
  ) {
    return dom.label(
      classes:
          'neubrutalism-radio-option ${isSelected ? 'selected' : ''} ${isDisabled ? 'disabled' : ''}',
      attributes: mergeAttrs(<Map<String, String>>[
        <String, String>{
          'role': 'radio',
          'aria-checked': '$isSelected',
          'aria-disabled': '$isDisabled',
          'tabindex': isDisabled ? '-1' : '0',
          'data-state': isSelected ? 'checked' : 'unchecked',
          'data-disabled': '$isDisabled',
        },
        itemAttrs,
      ]),
      styles: dom.Styles(
        raw: {
          'display': 'flex',
          'align-items': 'flex-start',
          'gap': '0.7rem',
          'padding': '0.25rem 0',
          'cursor': isDisabled ? 'not-allowed' : 'pointer',
        },
      ),
      events: isDisabled
          ? null
          : {'click': (_) => props.onChanged?.call(option.value)},
      [
        dom.div(
          classes: 'neubrutalism-radio-circle',
          attributes: const <String, String>{
            'data-arcane-intrinsic-shape': 'radio',
          },
          styles: dom.Styles(
            raw: {
              'width': '24px',
              'height': '24px',
              'border-radius': 'var(--nb-radius-tight, 0)',
              'border': 'var(--nb-border-base, 3px) solid var(--nb-line, #000)',
              'background': isSelected
                  ? 'var(--nb-accent-hot, var(--primary))'
                  : 'var(--nb-paper, var(--card))',
              'box-shadow': 'none',
              'display': 'flex',
              'align-items': 'center',
              'justify-content': 'center',
              'margin-top': '2px',
              'transition':
                  'background-color var(--nb-transition, 120ms ease), box-shadow var(--nb-transition, 120ms ease)',
              'flex-shrink': '0',
            },
          ),
          [
            const dom.div(
              classes: 'neubrutalism-radio-dot',
              attributes: <String, String>{
                'data-arcane-intrinsic-shape': 'radio-dot',
              },
              styles: dom.Styles(
                raw: {
                  'width': '10px',
                  'height': '10px',
                  'border-radius': 'var(--nb-radius-tight, 0)',
                  'background': 'var(--nb-on-accent-hot, #000)',
                },
              ),
              [],
            ),
          ],
        ),
        _optionText(option, isSelected),
      ],
    );
  }

  @override
  Component buildCardRadio(
    RadioOptionProps<T> option,
    String groupName,
    bool isSelected,
    bool isDisabled,
    bool hasError,
    Map<String, String> itemAttrs,
  ) {
    return dom.div(
      classes:
          'neubrutalism-radio-card ${isSelected ? 'selected' : ''} ${isDisabled ? 'disabled' : ''}',
      attributes: mergeAttrs(<Map<String, String>>[
        <String, String>{
          'role': 'radio',
          'aria-checked': '$isSelected',
          'aria-disabled': '$isDisabled',
          'tabindex': isDisabled ? '-1' : '0',
          'data-state': isSelected ? 'checked' : 'unchecked',
          'data-disabled': '$isDisabled',
        },
        itemAttrs,
      ]),
      styles: dom.Styles(
        raw: {
          'display': 'flex',
          'align-items': 'flex-start',
          'gap': '0.7rem',
          'padding': '0.9rem 1rem',
          'border': 'var(--nb-border-base, 3px) solid var(--nb-line, #000)',
          'border-radius': 'var(--nb-radius-soft, 0)',
          'background': isSelected
              ? 'var(--nb-accent, var(--primary))'
              : 'var(--nb-paper, var(--card))',
          'color': isSelected
              ? 'var(--nb-on-accent, #000)'
              : 'var(--foreground)',
          'box-shadow':
              'var(--nb-shadow-xs, 2px 2px 0 0 var(--nb-shadow-color, #000))',
          'cursor': isDisabled ? 'not-allowed' : 'pointer',
          'transition':
              'transform var(--nb-transition, 120ms ease), box-shadow var(--nb-transition, 120ms ease), background-color var(--nb-transition, 120ms ease), color var(--nb-transition, 120ms ease)',
        },
      ),
      events: isDisabled
          ? null
          : {'click': (_) => props.onChanged?.call(option.value)},
      [if (option.icon != null) option.icon!, _optionText(option, isSelected)],
    );
  }

  @override
  Component buildButtonRadio(
    RadioOptionProps<T> option,
    String groupName,
    bool isSelected,
    bool isDisabled,
    bool hasError,
    Map<String, String> itemAttrs,
  ) {
    return dom.button(
      classes:
          'neubrutalism-radio-button ${isSelected ? 'selected' : ''} ${isDisabled ? 'disabled' : ''}',
      attributes: mergeAttrs(<Map<String, String>>[
        <String, String>{
          'type': 'button',
          'role': 'radio',
          'aria-checked': '$isSelected',
          'aria-disabled': '$isDisabled',
          'data-state': isSelected ? 'checked' : 'unchecked',
          'data-disabled': '$isDisabled',
          if (isDisabled) 'disabled': 'true',
        },
        itemAttrs,
      ]),
      styles: dom.Styles(
        raw: {
          'display': 'inline-flex',
          'align-items': 'center',
          'justify-content': 'center',
          'gap': '0.55rem',
          'padding': '0.6rem 1rem',
          'border': 'var(--nb-border-base, 3px) solid var(--nb-line, #000)',
          'border-radius': 'var(--nb-radius-soft, 0)',
          'background': isSelected
              ? 'var(--nb-accent, var(--primary))'
              : 'var(--nb-paper, var(--card))',
          'color': isSelected
              ? 'var(--nb-on-accent, #000)'
              : 'var(--foreground)',
          'font-family': 'var(--font-heading)',
          'font-weight': '800',
          'letter-spacing': '0.02em',
          'box-shadow':
              'var(--nb-shadow-xs, 2px 2px 0 0 var(--nb-shadow-color, #000))',
          'cursor': isDisabled ? 'not-allowed' : 'pointer',
          'transition':
              'transform var(--nb-transition, 120ms ease), box-shadow var(--nb-transition, 120ms ease), background-color var(--nb-transition, 120ms ease), color var(--nb-transition, 120ms ease)',
        },
      ),
      events: isDisabled
          ? null
          : {'click': (_) => props.onChanged?.call(option.value)},
      [if (option.icon != null) option.icon!, Component.text(option.label)],
    );
  }

  Component _optionText(RadioOptionProps<T> option, bool isSelected) {
    final bool onAccent =
        isSelected && props.variant == RadioGroupVariant.cards;
    return dom.div(styles: const dom.Styles(raw: {'flex': '1'}), [
      dom.div(
        classes: 'neubrutalism-radio-label',
        styles: dom.Styles(
          raw: {
            'font-size': 'var(--font-size-sm)',
            'font-weight': 'var(--font-weight-medium)',
            'color': onAccent
                ? 'var(--nb-on-accent, #000)'
                : 'var(--foreground)',
          },
        ),
        [Component.text(option.label)],
      ),
      if (option.description != null)
        dom.div(
          classes: 'neubrutalism-radio-description',
          styles: dom.Styles(
            raw: {
              'font-size': 'var(--font-size-sm)',
              'color': onAccent
                  ? 'var(--nb-on-accent, #000)'
                  : 'var(--muted-foreground)',
              'margin-top': '0.2rem',
              'line-height': '1.35',
            },
          ),
          [Component.text(option.description!)],
        ),
    ]);
  }
}
