import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/component/view/icon.dart';
import 'package:arcane_jaspr/core/interaction/interaction.dart';
import 'package:arcane_jaspr/core/interaction/interaction_attrs.dart';
import 'package:arcane_jaspr/core/theme_provider.dart';
import 'package:arcane_jaspr_shadcn/src/renderers/field_styles.dart';

/// ShadCN-style select component
/// Reference: https://ui.shadcn.com/docs/components/select
class ShadcnSelect<T> extends StatelessComponent {
  final SelectProps<T> props;

  const ShadcnSelect(this.props, {super.key});

  /// SelectTrigger `data-[size=sm]:h-8`, default `h-9`; large is `h-10`.
  String get _triggerHeight => switch (props.size) {
    ComponentSize.sm => '2rem',
    ComponentSize.md => '2.25rem',
    ComponentSize.lg => '2.5rem',
  };

  bool get _hasSelection {
    if (props.multiSelect) {
      return (props.values ?? []).isNotEmpty;
    }
    return props.value != null;
  }

  String _getDisplayText() {
    if (props.multiSelect) {
      final List<T> values = props.values ?? <T>[];
      if (values.isEmpty) return props.placeholder;

      if (props.showSelectedCount && values.length > 1) {
        return '${values.length} selected';
      }

      final List<String> selectedLabels = props.options
          .where((SelectOptionProps<T> opt) => values.contains(opt.value))
          .map((SelectOptionProps<T> opt) => opt.label)
          .toList();
      return selectedLabels.join(', ');
    } else {
      final SelectOptionProps<T>? selectedOption = props.value != null
          ? props.options.cast<SelectOptionProps<T>?>().firstWhere(
              (SelectOptionProps<T>? opt) => opt?.value == props.value,
              orElse: () => null,
            )
          : null;
      return selectedOption?.label ?? props.placeholder;
    }
  }

  String _serializeValue(T? value) {
    if (value == null) return '';
    return value.toString();
  }

  @override
  Component build(BuildContext context) {
    final bool hasError = props.error != null;
    final String displayText = _getDisplayText();
    final String dropdownMaxHeight = props.maxDropdownHeight ?? '300px';
    final List<SelectOptionProps<T>> visibleOptions =
        props.onSearchChange != null && props.searchQuery.isNotEmpty
        ? props.filteredOptions
        : props.options;

    final String surfaceId =
        props.id ?? 'arcane-select-${identityHashCode(props)}';
    final String triggerId = props.triggerId ?? '$surfaceId-trigger';
    final String groupId = props.group ?? '$surfaceId-group';
    final String groupMode = props.multiSelect ? 'multi' : 'single';
    final String groupValue = props.multiSelect
        ? (props.values ?? <T>[])
              .map(_serializeValue)
              .where((String s) => s.isNotEmpty)
              .join('\u001f')
        : _serializeValue(props.value);
    final String? changeActionEncoded = props.onSelectAction != null
        ? encodeArcaneAction(props.onSelectAction!)
        : null;

    final ArcaneInteraction toggleAction = ArcaneInteraction.togglePopover(
      surfaceId,
    );
    final ArcaneInteraction dismissAction = ArcaneInteraction.closePopover(
      surfaceId,
    );

    return dom.div(
      classes: 'arcane-select-wrapper',
      attributes: <String, String>{
        'data-disabled': '${props.disabled}',
        'data-error': '$hasError',
      },
      styles: const dom.Styles(
        raw: <String, String>{
          'display': 'flex',
          'flex-direction': 'column',
          'gap': 'var(--space-2)',
          'position': 'relative',
          'width': '100%',
          'min-width': '0',
        },
      ),
      <Component>[
        // Label
        if (props.label != null)
          dom.label(
            htmlFor: triggerId,
            classes: 'arcane-select-label',
            styles: const dom.Styles(
              raw: <String, String>{
                ...shadcnFieldLabelStyles,
                'display': 'flex',
                'align-items': 'center',
                'gap': 'var(--space-1)',
              },
            ),
            <Component>[
              Component.text(props.label!),
              if (props.required)
                const dom.span(
                  styles: dom.Styles(
                    raw: <String, String>{'color': 'var(--destructive)'},
                  ),
                  <Component>[Component.text('*')],
                ),
            ],
          ),

        // Trigger button - ShadCN SelectTrigger
        dom.button(
          id: triggerId,
          classes:
              'arcane-select ${hasError ? 'error' : ''} ${props.disabled ? 'disabled' : ''}',
          attributes: <String, String>{
            'type': 'button',
            'role': 'combobox',
            'aria-haspopup': 'listbox',
            'aria-controls': surfaceId,
            'aria-expanded': '${props.isOpen}',
            if (props.disabled) 'disabled': 'true',
            'data-disabled': '${props.disabled || props.loading}',
            'data-error': '$hasError',
            ...anchorAttrs(triggerId),
            ...interactionAttrs(toggleAction),
          },
          styles: dom.Styles(
            raw: <String, String>{
              'display': 'flex',
              'align-items': 'center',
              'justify-content': 'space-between',
              'gap': 'var(--space-2)',
              'height': _triggerHeight,
              'padding': '0.25rem 0.75rem',
              'width': '100%',
              'min-width': '0',
              'background-color': 'var(--shadcn-input-background, transparent)',
              'border': hasError
                  ? '1px solid var(--shadcn-control-border-color, var(--destructive))'
                  : '1px solid var(--shadcn-control-border-color, var(--shadcn-control-border))',
              'border-radius': 'var(--radius-md)',
              'box-shadow': 'var(--shadcn-control-shadow, var(--shadow-xs))',
              'color': 'var(--foreground)',
              'font-size': '0.875rem',
              'font-family': 'var(--font-control, inherit)',
              'line-height': '1.25rem',
              'white-space': 'nowrap',
              'text-align': 'left',
              'outline': 'none',
              'cursor': props.disabled || props.loading
                  ? 'not-allowed'
                  : 'pointer',
              'opacity': props.disabled ? '0.5' : '1',
              'transition':
                  'color var(--transition), background-color var(--transition), '
                  'border-color var(--transition), box-shadow var(--transition)',
              ...?props.decoration?.universalStyles(),
              ...?props.styles?.toMap(),
            },
          ),
          events: props.onToggle != null
              ? <String, EventCallback>{
                  'click': (event) {
                    event.stopPropagation();
                    props.onToggle!();
                  },
                }
              : null,
          <Component>[
            // Prefix
            if (props.prefix != null)
              dom.span(
                styles: const dom.Styles(
                  raw: <String, String>{
                    'display': 'flex',
                    'align-items': 'center',
                    'color': 'var(--muted-foreground)',
                  },
                ),
                <Component>[props.prefix!],
              ),

            // Display text
            dom.span(
              styles: dom.Styles(
                raw: <String, String>{
                  'flex': '1',
                  'min-width': '0',
                  'color': _hasSelection
                      ? 'var(--foreground)'
                      : 'var(--muted-foreground)',
                  'overflow': 'hidden',
                  'text-overflow': 'ellipsis',
                  'white-space': 'nowrap',
                },
              ),
              <Component>[Component.text(displayText)],
            ),

            // Loading spinner
            if (props.loading)
              context.renderers.loadingSpinner(
                const LoadingSpinnerProps(
                  size: '16px',
                  color: 'var(--primary)',
                ),
              ),

            // Clear button
            if (!props.loading && props.clearable && _hasSelection)
              dom.span(
                classes: 'arcane-select-clear',
                attributes: interactionAttrs(
                  ArcaneInteraction.clearValue(groupId),
                ),
                styles: const dom.Styles(
                  raw: <String, String>{
                    'display': 'flex',
                    'align-items': 'center',
                    'padding': '2px',
                    'color': 'var(--muted-foreground)',
                    'cursor': 'pointer',
                    'border-radius': 'var(--radius-xs)',
                  },
                ),
                events: props.onClear != null
                    ? <String, EventCallback>{
                        'click': (event) {
                          event.stopPropagation();
                          props.onClear!();
                        },
                      }
                    : null,
                <Component>[ArcaneIcon.x(size: IconSize.xs)],
              ),

            // Arrow - ShadCN SelectIcon: ChevronDown size-4 opacity-50
            if (!props.loading)
              dom.span(
                classes: 'arcane-select-chevron',
                attributes: const <String, String>{'aria-hidden': 'true'},
                styles: const dom.Styles(
                  raw: <String, String>{
                    'display': 'flex',
                    'flex-shrink': '0',
                    'color': 'var(--muted-foreground)',
                    'opacity': '0.5',
                    'pointer-events': 'none',
                  },
                ),
                <Component>[ArcaneIcon.chevronDown(size: IconSize.sm)],
              ),
          ],
        ),

        // Dropdown - ShadCN SelectContent
        dom.div(
          id: surfaceId,
          classes: 'arcane-select-dropdown',
          attributes: <String, String>{
            'role': 'listbox',
            if (props.multiSelect) 'aria-multiselectable': 'true',
            'aria-label': props.label ?? props.placeholder,
            ...surfaceAttrs(
              surface: 'popover',
              id: surfaceId,
              initiallyOpen: props.isOpen,
              dismissible: true,
              escapeCloses: true,
              focusTrap: false,
              scrimCloses: true,
              restoreFocus: true,
              anchorId: triggerId,
              anchorPlacement:
                  props.dropdownDirection == SelectDropdownDirection.up
                  ? 'top'
                  : 'bottom',
              anchorAlign: 'start',
              anchorOffset: '4',
            ),
            ...groupAttrs(
              groupId: groupId,
              mode: groupMode,
              value: groupValue,
              required: props.required,
              disabled: props.disabled,
              maxSelections: props.maxSelections?.toString(),
              changeAction: changeActionEncoded,
            ),
            'data-arcane-command': surfaceId,
          },
          events: <String, EventCallback>{
            if (props.onToggle != null)
              'arcane:close': (_) {
                if (props.isOpen) props.onToggle!();
              },
          },
          styles: dom.Styles(
            raw: <String, String>{
              'background-color': 'var(--popover)',
              'color': 'var(--popover-foreground)',
              'border': '1px solid var(--border)',
              'border-radius': 'var(--radius-md)',
              'box-shadow': 'var(--shadcn-surface-shadow)',
              'max-height': dropdownMaxHeight,
              'min-width': '8rem',
              'overflow-x': 'hidden',
              'overflow-y': 'auto',
              'z-index': '50',
            },
          ),
          <Component>[
            // Search input
            if (props.searchable)
              dom.div(
                styles: const dom.Styles(
                  raw: <String, String>{
                    'padding': '8px',
                    'border-bottom': '1px solid var(--border)',
                    'position': 'sticky',
                    'top': '0',
                    'background': 'var(--popover)',
                    'z-index': '1',
                  },
                ),
                <Component>[
                  dom.input<String>(
                    type: dom.InputType.text,
                    value: props.searchQuery,
                    onInput: props.onSearchChange,
                    attributes: <String, String>{
                      'placeholder': props.searchPlaceholder,
                      'aria-label': props.searchPlaceholder,
                      'autocomplete': 'off',
                      'data-arcane-command-input': surfaceId,
                      'data-arcane-autofocus': 'true',
                    },
                    styles: const dom.Styles(
                      raw: <String, String>{
                        'width': '100%',
                        'padding': '4px 8px',
                        'border': '1px solid var(--input)',
                        'border-radius': 'var(--radius-sm)',
                        'background': 'transparent',
                        'color': 'var(--foreground)',
                        'font-size': 'var(--font-size-sm)',
                        'outline': 'none',
                      },
                    ),
                  ),
                ],
              ),

            // Loading state
            if (props.loading)
              dom.div(
                styles: const dom.Styles(
                  raw: <String, String>{
                    'padding': '24px 16px',
                    'color': 'var(--muted-foreground)',
                    'font-size': 'var(--font-size-sm)',
                    'text-align': 'center',
                  },
                ),
                <Component>[Component.text(props.loadingText)],
              )
            // Options - ShadCN SelectItem
            else
              dom.div(
                classes: 'arcane-select-options',
                styles: const dom.Styles(
                  raw: <String, String>{'padding': '0.25rem'},
                ),
                <Component>[
                  if (props.onSearchChange == null)
                    dom.div(
                      attributes: const <String, String>{
                        'data-arcane-command-empty': '',
                        'hidden': '',
                      },
                      styles: const dom.Styles(
                        raw: <String, String>{
                          'padding': '8px 16px',
                          'color': 'var(--muted-foreground)',
                          'font-size': 'var(--font-size-sm)',
                          'text-align': 'center',
                        },
                      ),
                      <Component>[Component.text(props.emptyMessage)],
                    ),
                  if (visibleOptions.isEmpty)
                    dom.div(
                      styles: const dom.Styles(
                        raw: <String, String>{
                          'padding': '8px 16px',
                          'color': 'var(--muted-foreground)',
                          'font-size': 'var(--font-size-sm)',
                          'text-align': 'center',
                        },
                      ),
                      <Component>[Component.text(props.emptyMessage)],
                    )
                  else
                    for (
                      int index = 0;
                      index < visibleOptions.length;
                      index++
                    ) ...<Component>[
                      // ShadCN SelectLabel: a group's heading.
                      if (visibleOptions[index].group != null &&
                          (index == 0 ||
                              visibleOptions[index - 1].group !=
                                  visibleOptions[index].group))
                        dom.div(
                          classes: 'arcane-select-label',
                          attributes: const <String, String>{
                            'role': 'presentation',
                          },
                          styles: const dom.Styles(
                            raw: <String, String>{
                              'padding': '0.375rem 0.5rem',
                              'font-size': '0.75rem',
                              'line-height': '1rem',
                              'color': 'var(--muted-foreground)',
                            },
                          ),
                          <Component>[
                            Component.text(visibleOptions[index].group!),
                          ],
                        ),
                      _buildOption(
                        visibleOptions[index],
                        groupId: groupId,
                        groupMode: groupMode,
                        surfaceId: surfaceId,
                        dismissAction: dismissAction,
                      ),
                    ],
                ],
              ),
            // Rows under the options, after a ShadCN SelectSeparator.
            if (props.footer != null)
              dom.div(
                classes: 'arcane-select-footer',
                styles: const dom.Styles(
                  raw: <String, String>{
                    'border-top': '1px solid var(--border)',
                    'padding': '0.25rem',
                  },
                ),
                <Component>[props.footer!],
              ),
          ],
        ),

        // Helper text
        if (props.helperText != null && props.error == null)
          dom.span(
            styles: const dom.Styles(
              raw: <String, String>{
                'font-size': '0.875rem',
                'color': 'var(--muted-foreground)',
              },
            ),
            <Component>[Component.text(props.helperText!)],
          ),

        // Error message
        if (props.error != null)
          dom.span(
            styles: const dom.Styles(
              raw: <String, String>{
                'font-size': '0.875rem',
                'color': 'var(--destructive)',
              },
            ),
            <Component>[Component.text(props.error!)],
          ),
      ],
    );
  }

  Component _buildOption(
    SelectOptionProps<T> option, {
    required String groupId,
    required String groupMode,
    required String surfaceId,
    required ArcaneInteraction dismissAction,
  }) {
    final bool isSelected = props.multiSelect
        ? (props.values?.contains(option.value) ?? false)
        : props.value == option.value;
    final bool isDisabled = option.disabled;

    final bool maxReached =
        props.multiSelect &&
        props.maxSelections != null &&
        !isSelected &&
        (props.values?.length ?? 0) >= props.maxSelections!;

    final String value = _serializeValue(option.value);
    final ArcaneInteraction selectAction = groupMode == 'multi'
        ? ArcaneInteraction.toggleValue(groupId, value)
        : ArcaneInteraction.selectValue(groupId, value);
    final ArcaneInteraction itemAction =
        props.onSelect == null && props.closeOnSelect && !props.multiSelect
        ? ArcaneInteraction.compose(<ArcaneInteraction>[
            selectAction,
            dismissAction,
          ])
        : selectAction;

    final List<String> keywords = <String>[
      option.label,
      if (option.description != null) option.description!,
      if (option.subtitle != null) option.subtitle!,
      if (option.searchKeywords != null) ...option.searchKeywords!,
    ];

    return dom.button(
      classes:
          'arcane-select-option ${isSelected ? 'selected' : ''} ${isDisabled || maxReached ? 'disabled' : ''}',
      attributes: <String, String>{
        'type': 'button',
        'role': 'option',
        'aria-selected': '$isSelected',
        if (props.onSelect != null) 'data-arcane-keep-open': 'true',
        if (isDisabled || maxReached) 'disabled': 'true',
        'data-arcane-command-item': '',
        'data-arcane-command-group-id': '$surfaceId-default',
        'data-label': option.label,
        'data-keywords': keywords.join(' '),
        ...groupItemAttrs(
          groupId: groupId,
          value: value,
          selected: isSelected,
          disabled: isDisabled || maxReached,
        ),
        if (!isDisabled && !maxReached) ...interactionAttrs(itemAction),
      },
      styles: dom.Styles(
        raw: <String, String>{
          'display': 'flex',
          'align-items': 'center',
          'gap': 'var(--space-2)',
          'width': '100%',
          'min-width': '0',
          'padding': '0.375rem 0.5rem',
          'background-color': 'var(--shadcn-item-background, transparent)',
          'color': 'var(--shadcn-item-foreground, inherit)',
          'border': 'none',
          'border-radius': 'var(--shadcn-item-radius)',
          'outline': 'none',
          'cursor': (isDisabled || maxReached) ? 'not-allowed' : 'pointer',
          'opacity': (isDisabled || maxReached) ? '0.5' : '1',
          'transition':
              'background-color var(--transition), color var(--transition)',
          'text-align': 'left',
          'font-size': '0.875rem',
          'line-height': '1.25rem',
        },
      ),
      events: props.onSelect != null && !isDisabled && !maxReached
          ? <String, EventCallback>{
              'click': (_) => props.onSelect!(option.value),
            }
          : null,
      <Component>[
        // Checkbox for multi-select
        if (props.multiSelect && props.showCheckboxes)
          dom.div(
            classes: 'arcane-select-option-check',
            attributes: const <String, String>{'aria-hidden': 'true'},
            styles: dom.Styles(
              raw: <String, String>{
                'width': '16px',
                'height': '16px',
                'box-sizing': 'border-box',
                'border': isSelected
                    ? '1px solid var(--primary)'
                    : '1px solid var(--shadcn-control-border)',
                'border-radius': 'var(--radius-xs)',
                'box-shadow': 'var(--shadow-xs)',
                'display': 'flex',
                'align-items': 'center',
                'justify-content': 'center',
                'background': isSelected ? 'var(--primary)' : 'transparent',
                'flex-shrink': '0',
              },
            ),
            <Component>[
              if (isSelected)
                dom.span(
                  styles: const dom.Styles(
                    raw: <String, String>{'color': 'var(--primary-foreground)'},
                  ),
                  <Component>[ArcaneIcon.check(size: IconSize.xs)],
                ),
            ],
          ),

        // Icon
        if (option.icon != null) option.icon!,

        // A leading picture (swatch, face).
        if (option.leading != null)
          dom.span(
            attributes: const <String, String>{'aria-hidden': 'true'},
            styles: const dom.Styles(
              raw: <String, String>{
                'display': 'inline-flex',
                'flex-shrink': '0',
              },
            ),
            <Component>[option.leading!],
          ),

        // Label and subtitle
        dom.div(
          styles: const dom.Styles(
            raw: <String, String>{
              'flex': '1',
              'min-width': '0',
              'display': 'flex',
              'flex-direction': 'column',
              'gap': '2px',
              'overflow': 'hidden',
            },
          ),
          <Component>[
            dom.span(
              styles: const dom.Styles(
                raw: <String, String>{
                  'overflow': 'hidden',
                  'text-overflow': 'ellipsis',
                  'white-space': 'nowrap',
                },
              ),
              <Component>[Component.text(option.label)],
            ),
            if (option.subtitle != null)
              dom.span(
                classes: 'arcane-select-option-subtitle',
                styles: dom.Styles(
                  raw: <String, String>{
                    'font-size': 'var(--font-size-xs)',
                    'color': isSelected
                        ? 'var(--accent-foreground)'
                        : 'var(--muted-foreground)',
                    'overflow': 'hidden',
                    'text-overflow': 'ellipsis',
                    'white-space': 'nowrap',
                  },
                ),
                <Component>[Component.text(option.subtitle!)],
              ),
          ],
        ),

        // Description
        if (option.description != null)
          dom.span(
            classes: 'arcane-select-option-description',
            styles: dom.Styles(
              raw: <String, String>{
                'font-size': 'var(--font-size-xs)',
                'color': isSelected
                    ? 'var(--accent-foreground)'
                    : 'var(--muted-foreground)',
                'min-width': '0',
                'flex-shrink': '0',
              },
            ),
            <Component>[Component.text(option.description!)],
          ),

        // Checkmark for single select
        if (!props.multiSelect && isSelected)
          dom.span(
            classes: 'arcane-select-option-checkmark',
            attributes: const <String, String>{'aria-hidden': 'true'},
            styles: const dom.Styles(
              raw: <String, String>{
                'color': 'var(--accent-foreground)',
                'flex-shrink': '0',
              },
            ),
            <Component>[ArcaneIcon.check(size: IconSize.xs)],
          ),
      ],
    );
  }
}
