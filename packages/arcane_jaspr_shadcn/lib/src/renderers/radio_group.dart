import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/radio_group_props.dart';
import 'package:arcane_jaspr/core/rendering/base/radio_group_render_base.dart';

/// ShadCN Radio Group renderer.
///
/// Outputs the exact HTML structure and CSS from ui.shadcn.com.
/// Reference: https://ui.shadcn.com/docs/components/radio-group
///
/// ShadCN v4 Radio Group:
/// - Item: size-4 rounded-full shadow-xs dark:bg-input/30, bordered with the
///   3:1 `--shadcn-control-border` instead of bare `border-input`
/// - Selected: indicator dot size-2 fill-primary
/// - Focus: border-ring ring-[3px] ring-ring/50
/// - Disabled: opacity-50, cursor-not-allowed
class ShadcnRadioGroup<T> extends RadioGroupRenderBase<T> {
  const ShadcnRadioGroup(super.props, {super.key});

  @override
  String get groupIdPrefix => 'radio_';

  @override
  String get rootClasses => 'arcane-radio-group';

  @override
  Map<String, String> rootDataAttrs(String groupName) => <String, String>{
    'role': 'radiogroup',
    if (props.label != null) 'aria-labelledby': '${groupName}_label',
    'data-disabled': '${props.disabled}',
  };

  @override
  Map<String, String> get rootStyles => <String, String>{
    'display': 'flex',
    'flex-direction': 'column',
    'gap': 'var(--space-2)', // ShadCN: space-y-2
  };

  @override
  Component buildLabel(String groupName) {
    // Label - ShadCN: text-sm font-medium
    return Component.element(
      tag: 'label',
      id: '${groupName}_label',
      styles: const dom.Styles(
        raw: {
          // ShadCN: text-sm font-medium leading-none
          'font-size': '0.875rem',
          'font-weight': '500',
          'line-height': '1',
          'color': 'var(--foreground)',
        },
      ),
      children: [
        Component.text(props.label!),
        if (props.required)
          const dom.span(
            styles: dom.Styles(raw: {'color': 'var(--destructive)'}),
            [Component.text(' *')],
          ),
      ],
    );
  }

  @override
  String get optionsClasses => 'arcane-radio-group-options';

  @override
  Map<String, String> get optionsStyles =>
      props.variant == RadioGroupVariant.buttons
      // Segmented control: one row with shared edges (see the theme CSS).
      ? const <String, String>{
          'display': 'flex',
          'flex-direction': 'row',
          'flex-wrap': 'nowrap',
          'gap': '0',
        }
      : <String, String>{
          'display': props.layout == RadioGroupLayout.grid ? 'grid' : 'flex',
          'flex-direction': props.layout == RadioGroupLayout.horizontal
              ? 'row'
              : 'column',
          'flex-wrap': props.layout == RadioGroupLayout.horizontal
              ? 'wrap'
              : 'nowrap',
          'gap': props.gap,
          if (props.layout == RadioGroupLayout.grid)
            'grid-template-columns':
                'repeat(${props.gridColumns}, minmax(0, 1fr))',
        };

  @override
  List<Component> buildMessage() {
    // Error or helper text - ShadCN: text-sm text-muted-foreground
    if (props.error != null) {
      return <Component>[
        dom.span(
          styles: const dom.Styles(
            raw: {
              // ShadCN: text-sm text-destructive
              'font-size': 'var(--font-size-sm)',
              'color': 'var(--destructive)',
            },
          ),
          [Component.text(props.error!)],
        ),
      ];
    } else if (props.helperText != null) {
      return <Component>[
        dom.span(
          styles: const dom.Styles(
            raw: {
              // ShadCN: text-sm text-muted-foreground
              'font-size': 'var(--font-size-sm)',
              'color': 'var(--muted-foreground)',
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
    return Component.element(
      tag: 'label',
      classes: 'arcane-radio-item',
      attributes: <String, String>{'data-disabled': '$isDisabled'},
      styles: dom.Styles(
        raw: {
          'position': 'relative',
          'display': 'flex',
          'align-items': option.description != null ? 'flex-start' : 'center',
          'gap': 'var(--space-2)',
          'cursor': isDisabled ? 'not-allowed' : 'pointer',
          // ShadCN: disabled:opacity-50 disabled:cursor-not-allowed
          'opacity': isDisabled ? '0.5' : '1',
          'pointer-events': isDisabled ? 'none' : 'auto',
        },
      ),
      children: [
        // Radio input (hidden, for accessibility)
        dom.input(
          type: dom.InputType.radio,
          name: groupName,
          value: option.value.toString(),
          checked: isSelected,
          disabled: isDisabled,
          classes: 'arcane-radio-input',
          attributes: <String, String>{
            for (final MapEntry<String, String> attribute in itemAttrs.entries)
              if (attribute.key != 'data-arcane-action')
                attribute.key: attribute.value,
            if (props.required) 'required': '',
            if (hasError) 'aria-invalid': 'true',
            'data-state': isSelected ? 'checked' : 'unchecked',
            'data-disabled': '$isDisabled',
            'data-arcane-intrinsic-shape': 'radio',
          },
          styles: const dom.Styles(
            raw: {
              'position': 'absolute',
              'opacity': '0',
              'pointer-events': 'none',
            },
          ),
          events: {
            if (!isDisabled && props.onChanged != null)
              'change': (e) => props.onChanged!(option.value),
          },
        ),

        // Custom radio circle - ShadCN size-4 rounded-full border-input
        dom.div(
          classes: 'arcane-radio-circle',
          attributes: {
            'data-state': isSelected ? 'checked' : 'unchecked',
            'data-disabled': '$isDisabled',
          },
          styles: dom.Styles(
            raw: {
              'display': 'flex',
              'align-items': 'center',
              'justify-content': 'center',
              'width': '16px',
              'height': '16px',
              'box-sizing': 'border-box',
              'border-radius': '50%',
              'border': hasError
                  ? '1px solid var(--shadcn-control-border-color, var(--destructive))'
                  : '1px solid var(--shadcn-control-border-color, var(--shadcn-radio-border, var(--shadcn-control-border)))',
              'background': 'var(--shadcn-input-background, transparent)',
              'box-shadow': 'var(--shadcn-control-shadow, var(--shadow-xs))',
              'flex-shrink': '0',
              'transition':
                  'color var(--transition), box-shadow var(--transition), border-color var(--transition)',
            },
          ),
          [
            // Inner dot when selected - ShadCN: size-2 (8px) fill-primary
            const dom.div(
              attributes: <String, String>{
                'data-arcane-intrinsic-shape': 'radio-dot',
              },
              styles: dom.Styles(
                raw: {
                  'opacity': 'var(--shadcn-radio-dot-opacity, 0)',
                  'width': '8px',
                  'height': '8px',
                  'border-radius': '50%',
                  // ShadCN: bg-primary
                  'background': 'var(--primary)',
                },
              ),
              [],
            ),
          ],
        ),

        // Label content
        dom.div(
          classes: 'arcane-radio-content',
          styles: const dom.Styles(raw: {'flex': '1'}),
          [
            // Icon + Label row
            dom.div(
              styles: const dom.Styles(
                raw: {
                  'display': 'flex',
                  'align-items': 'center',
                  'gap': 'var(--space-1)',
                },
              ),
              [
                if (option.icon != null) option.icon!,
                dom.span(
                  styles: const dom.Styles(
                    raw: {
                      // ShadCN: text-sm font-medium leading-none
                      'font-size': '0.875rem',
                      'font-weight': '500',
                      'color': 'var(--foreground)',
                      'line-height': '1',
                    },
                  ),
                  [Component.text(option.label)],
                ),
              ],
            ),
            // Description
            if (option.description != null)
              dom.span(
                styles: const dom.Styles(
                  raw: {
                    // ShadCN: text-sm text-muted-foreground
                    'font-size': 'var(--font-size-sm)',
                    'color': 'var(--muted-foreground)',
                    'margin-top': '0.25rem',
                  },
                ),
                [Component.text(option.description!)],
              ),
          ],
        ),
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
    return Component.element(
      tag: 'label',
      classes: 'arcane-radio-card',
      attributes: <String, String>{'data-disabled': '$isDisabled'},
      styles: dom.Styles(
        raw: {
          'position': 'relative',
          'display': 'flex',
          'flex-direction': 'column',
          'gap': 'var(--space-1)',
          'padding': '1rem',
          'border-radius': 'var(--radius-md)',
          '--shadcn-radio-idle-border': hasError
              ? 'var(--destructive)'
              : 'var(--input)',
          'border':
              '1px solid var(--shadcn-radio-border, var(--shadcn-radio-idle-border))',
          'background': 'var(--shadcn-radio-card-background, var(--card))',
          'cursor': isDisabled ? 'not-allowed' : 'pointer',
          'opacity': isDisabled ? '0.5' : '1',
          'transition':
              'border-color var(--transition), background-color var(--transition)',
        },
      ),
      children: [
        // Hidden input
        dom.input(
          type: dom.InputType.radio,
          name: groupName,
          value: option.value.toString(),
          checked: isSelected,
          disabled: isDisabled,
          attributes: <String, String>{
            for (final MapEntry<String, String> attribute in itemAttrs.entries)
              if (attribute.key != 'data-arcane-action')
                attribute.key: attribute.value,
            if (props.required) 'required': '',
            if (hasError) 'aria-invalid': 'true',
            'data-state': isSelected ? 'checked' : 'unchecked',
            'data-disabled': '$isDisabled',
          },
          styles: const dom.Styles(
            raw: {
              'position': 'absolute',
              'opacity': '0',
              'pointer-events': 'none',
            },
          ),
          events: {
            if (!isDisabled && props.onChanged != null)
              'change': (e) => props.onChanged!(option.value),
          },
        ),

        // Header with icon and indicator
        dom.div(
          styles: const dom.Styles(
            raw: {
              'display': 'flex',
              'align-items': 'center',
              'justify-content': 'space-between',
            },
          ),
          [
            if (option.icon != null)
              dom.div(
                styles: const dom.Styles(
                  raw: {
                    'color': 'var(--shadcn-radio-ink, var(--muted-foreground))',
                  },
                ),
                [option.icon!],
              ),
            // Selection indicator
            const dom.div(
              attributes: <String, String>{
                'data-arcane-intrinsic-shape': 'radio',
              },
              styles: dom.Styles(
                raw: {
                  'width': '16px',
                  'height': '16px',
                  'border-radius': '50%',
                  'box-sizing': 'border-box',
                  'border':
                      'var(--shadcn-radio-indicator-width, 1px) solid var(--shadcn-radio-border, var(--shadcn-control-border))',
                  'background': 'var(--background)',
                  'box-shadow': 'var(--shadow-xs)',
                },
              ),
              [],
            ),
          ],
        ),

        // Label
        dom.span(
          styles: const dom.Styles(
            raw: {
              'font-size': '0.875rem',
              'font-weight': '500',
              'color': 'var(--shadcn-radio-ink, var(--foreground))',
            },
          ),
          [Component.text(option.label)],
        ),

        // Description
        if (option.description != null)
          dom.span(
            styles: const dom.Styles(
              raw: {
                'font-size': 'var(--font-size-sm)',
                'color': 'var(--muted-foreground)',
              },
            ),
            [Component.text(option.description!)],
          ),
      ],
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
    return Component.element(
      tag: 'label',
      classes: 'arcane-radio-button',
      attributes: <String, String>{'data-disabled': '$isDisabled'},
      styles: dom.Styles(
        raw: {
          // Segment corners and the 1px edge overlap come from the theme CSS
          // (:first-child / :last-child), so no per-item radius or margin.
          'position': 'relative',
          'display': 'inline-flex',
          'align-items': 'center',
          'justify-content': 'center',
          'gap': '0.5rem',
          'height': '2.25rem',
          'padding': '0 1rem',
          'box-sizing': 'border-box',
          '--shadcn-radio-idle-border': hasError
              ? 'var(--destructive)'
              : 'var(--input)',
          'border':
              '1px solid var(--shadcn-radio-border, var(--shadcn-radio-idle-border))',
          'background':
              'var(--shadcn-radio-button-background, var(--background))',
          'color': 'var(--shadcn-radio-button-ink, var(--foreground))',
          'font-size': '0.875rem',
          'font-weight': '500',
          'white-space': 'nowrap',
          'cursor': isDisabled ? 'not-allowed' : 'pointer',
          'opacity': isDisabled ? '0.5' : '1',
          'transition':
              'color var(--transition), background-color var(--transition), border-color var(--transition), box-shadow var(--transition)',
        },
      ),
      children: [
        dom.input(
          type: dom.InputType.radio,
          name: groupName,
          value: option.value.toString(),
          checked: isSelected,
          disabled: isDisabled,
          attributes: <String, String>{
            for (final MapEntry<String, String> attribute in itemAttrs.entries)
              if (attribute.key != 'data-arcane-action')
                attribute.key: attribute.value,
            if (props.required) 'required': '',
            if (hasError) 'aria-invalid': 'true',
            'data-state': isSelected ? 'checked' : 'unchecked',
            'data-disabled': '$isDisabled',
          },
          styles: const dom.Styles(
            raw: {
              'position': 'absolute',
              'opacity': '0',
              'pointer-events': 'none',
            },
          ),
          events: {
            if (!isDisabled && props.onChanged != null)
              'change': (e) => props.onChanged!(option.value),
          },
        ),
        if (option.icon != null) option.icon!,
        Component.text(option.label),
      ],
    );
  }
}
