import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/component/view/icon.dart';
import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/dom_value.dart';
import 'package:arcane_jaspr/core/interaction/interaction.dart';
import 'package:arcane_jaspr/core/interaction/interaction_attrs.dart';
import 'package:arcane_jaspr/core/props/select_props.dart';

/// Shared structural base for the Win95, Neon and Neubrutalism select
/// renderers.
///
/// These themes render an identical popover-select tree: the wrapper, the
/// label/required asterisk, the trigger button with its prefix/display/clear/
/// chevron, the dropdown surface/group attribute wiring, the search box, the
/// loading/empty states and the per-option buttons (with their group-item and
/// interaction attributes, keyword payload and label/subtitle/description
/// layout) all match byte-for-byte. They diverge only in style values, the
/// surface-id prefix, the accent/border colors and a handful of per-node style
/// maps, which are exposed as abstract members.
///
/// The ShadCN select is structurally divergent (a different size config, a
/// wrapper element, a trigger loading spinner, a different attribute set and a
/// different option layout) and is left standalone.
///
/// This base lives in core and depends only on core props, interaction helpers
/// and the shared icon component; it must never depend on a theme package.
abstract class SelectRenderBase<T> extends StatelessComponent {
  const SelectRenderBase(this.props, {super.key});

  final SelectProps<T> props;

  /// Theme class prefix (e.g. `'neon'`, `'neubrutalism'`).
  String get classPrefix;

  /// Prefix used to derive a fallback surface id (e.g. `'neon-select-'`).
  String get surfaceIdPrefix;

  /// Color for the required-field asterisk.
  String get requiredAsteriskColor;

  /// Border color used by the trigger when there is no error.
  String get controlBorderColor;

  /// Full inline style map for the trigger button.
  Map<String, String> triggerStyles(
    String height,
    String padding,
    String fontSize,
    String triggerColor,
    String borderColor,
  );

  /// Full inline style map for the dropdown surface.
  Map<String, String> dropdownStyles(String maxHeight);

  /// Inline styles for the search-box wrapper.
  Map<String, String> get searchWrapperStyles;

  /// Inline styles for the search input.
  Map<String, String> get searchInputStyles;

  /// Inline styles for an option button.
  Map<String, String> optionStyles(bool isSelected, bool isDisabled);

  /// Inline styles for the multi-select checkbox box of an option.
  Map<String, String> optionCheckboxStyles(bool isSelected);

  /// Color of the checkmark inside a selected multi-select checkbox.
  String get optionCheckColor;

  /// Color of an option's leading icon for the given selection state.
  String optionIconColor(bool isSelected);

  /// Gap in px between the trigger and the option list.
  String get anchorOffset => '8';

  /// Padding around the option rows inside the list.
  String get optionsPadding => '0.5rem';

  /// Per-instance decoration overrides for the trigger. Default: none. A
  /// theme overrides this to translate an [ArcaneDecoration] (elevation
  /// intent, theme-specific fields) into its own CSS. Fields a theme does
  /// not implement are ignored.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  String _serializeValue(T? value) {
    if (value == null) return '';
    return value.toString();
  }

  void _handleRuntimeSelection(dynamic event) {
    if (props.onSelect == null) return;
    final String serializedValue =
        domEventTargetAttribute(
          event,
          'data-arcane-group-value',
        ).split('\u001f').firstOrNull ??
        '';
    final SelectOptionProps<T>? selectedOption = props.options
        .where(
          (SelectOptionProps<T> option) =>
              _serializeValue(option.value) == serializedValue,
        )
        .firstOrNull;
    if (selectedOption != null) {
      props.onSelect!(selectedOption.value);
    }
  }

  String _getDisplayText() {
    if (props.multiSelect) {
      if (props.values == null || props.values!.isEmpty) {
        return props.placeholder;
      }
      if (props.showSelectedCount) {
        return '${props.values!.length} selected';
      }
      final List<String> labels = props.values!
          .map(
            (T v) => props.options
                .firstWhere((SelectOptionProps<T> o) => o.value == v)
                .label,
          )
          .toList();
      return labels.join(', ');
    }

    if (props.value == null) {
      return props.placeholder;
    }

    final SelectOptionProps<T>? selectedOption = props.options
        .where((SelectOptionProps<T> o) => o.value == props.value)
        .firstOrNull;

    return selectedOption?.label ?? props.placeholder;
  }

  @override
  Component build(BuildContext context) {
    final (
      String height,
      String fontSize,
      String padding,
    ) = switch (props.size) {
      ComponentSize.sm => ('40px', '0.8125rem', '0.625rem 1rem'),
      ComponentSize.md => ('48px', '0.875rem', '0.75rem 1.25rem'),
      ComponentSize.lg => ('56px', '1rem', '1rem 1.5rem'),
    };

    final String displayText = _getDisplayText();

    final bool hasError = props.error != null;
    final String borderColor = hasError
        ? 'var(--destructive)'
        : controlBorderColor;
    final String triggerColor =
        props.value != null ||
            (props.values != null && props.values!.isNotEmpty)
        ? 'var(--foreground)'
        : 'var(--muted-foreground)';

    final String surfaceId =
        props.id ?? '$surfaceIdPrefix${identityHashCode(props)}';
    final String triggerId = '$surfaceId-trigger';
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

    final String maxHeight = props.maxDropdownHeight ?? '320px';

    return dom.div(
      classes:
          '$classPrefix-select ${props.disabled ? 'disabled' : ''} ${hasError ? 'error' : ''}',
      attributes: <String, String>{
        'data-disabled': '${props.disabled}',
        'data-size': props.size.name,
      },
      styles: const dom.Styles(
        raw: <String, String>{'position': 'relative', 'width': '100%'},
      ),
      <Component>[
        if (props.label != null)
          dom.label(
            htmlFor: triggerId,
            classes: '$classPrefix-select-label',
            styles: const dom.Styles(
              raw: <String, String>{
                'display': 'block',
                'font-family': 'var(--font-heading)',
                'font-size': '0.75rem',
                'font-weight': '600',
                'letter-spacing': '0.08em',
                'text-transform': 'uppercase',
                'color': 'var(--muted-foreground)',
                'margin-bottom': '0.625rem',
              },
            ),
            <Component>[
              Component.text(props.label!),
              if (props.required)
                dom.span(
                  styles: dom.Styles(
                    raw: <String, String>{
                      'color': requiredAsteriskColor,
                      'margin-left': '0.375rem',
                    },
                  ),
                  <Component>[const Component.text('*')],
                ),
            ],
          ),

        dom.button(
          id: triggerId,
          classes: '$classPrefix-select-trigger',
          attributes: <String, String>{
            'type': 'button',
            'aria-haspopup': 'listbox',
            'aria-controls': surfaceId,
            'aria-expanded': '${props.isOpen}',
            if (hasError) 'aria-invalid': 'true',
            if (hasError)
              'aria-describedby': '$surfaceId-error'
            else if (props.helperText != null)
              'aria-describedby': '$surfaceId-helper',
            'data-disabled': '${props.disabled}',
            'data-variant': props.multiSelect ? 'multi' : 'single',
            'data-size': props.size.name,
            if (props.disabled) 'disabled': 'true',
            ...anchorAttrs(triggerId),
            if (!props.disabled) ...interactionAttrs(toggleAction),
          },
          styles: dom.Styles(
            raw: <String, String>{
              ...triggerStyles(
                height,
                padding,
                fontSize,
                triggerColor,
                borderColor,
              ),
              ...?props.decoration?.universalStyles(),
              ...decorationStyles(props.decoration),
              ...?props.styles?.toMap(),
            },
          ),
          <Component>[
            if (props.prefix != null)
              dom.span(
                styles: const dom.Styles(
                  raw: <String, String>{
                    'margin-right': '0.75rem',
                    'color': 'var(--muted-foreground)',
                  },
                ),
                <Component>[props.prefix!],
              ),

            // Display text
            dom.span(
              styles: const dom.Styles(
                raw: <String, String>{
                  'flex': '1',
                  'text-align': 'left',
                  'overflow': 'hidden',
                  'text-overflow': 'ellipsis',
                  'white-space': 'nowrap',
                },
              ),
              <Component>[Component.text(displayText)],
            ),

            if (props.clearable &&
                (props.value != null ||
                    (props.values != null && props.values!.isNotEmpty)))
              dom.span(
                classes: '$classPrefix-select-clear',
                attributes: interactionAttrs(
                  ArcaneInteraction.clearValue(groupId),
                ),
                styles: const dom.Styles(
                  raw: <String, String>{
                    'display': 'flex',
                    'align-items': 'center',
                    'justify-content': 'center',
                    'width': '20px',
                    'height': '20px',
                    'margin-right': '0.5rem',
                    'color': 'var(--destructive)',
                    'cursor': 'pointer',
                    'transition': 'all 0.2s ease',
                  },
                ),
                events: props.onClear == null
                    ? null
                    : <String, void Function(dynamic)>{
                        'click': (dynamic e) {
                          domStopPropagation(e);
                          props.onClear!();
                        },
                      },
                <Component>[ArcaneIcon.x(size: IconSize.xs)],
              ),

            dom.span(
              styles: const dom.Styles(
                raw: <String, String>{
                  'display': 'flex',
                  'align-items': 'center',
                  'color': 'var(--muted-foreground)',
                },
              ),
              <Component>[ArcaneIcon.chevronsUpDown(size: IconSize.sm)],
            ),
          ],
        ),

        dom.div(
          id: surfaceId,
          classes: '$classPrefix-select-dropdown $classPrefix-select-content',
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
              anchorOffset: anchorOffset,
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
          styles: dom.Styles(raw: dropdownStyles(maxHeight)),
          events: props.onSelect == null
              ? null
              : <String, void Function(dynamic)>{
                  'arcane:change': _handleRuntimeSelection,
                },
          <Component>[
            if (props.searchable)
              dom.div(
                classes: '$classPrefix-select-search',
                styles: dom.Styles(raw: searchWrapperStyles),
                <Component>[
                  dom.input(
                    type: dom.InputType.text,
                    attributes: <String, String>{
                      'placeholder': props.searchPlaceholder,
                      'aria-label': props.searchPlaceholder,
                      'autocomplete': 'off',
                      'data-arcane-command-input': surfaceId,
                      'data-arcane-autofocus': 'true',
                    },
                    styles: dom.Styles(raw: searchInputStyles),
                  ),
                ],
              ),

            if (props.loading)
              dom.div(
                classes: '$classPrefix-select-loading',
                styles: const dom.Styles(
                  raw: <String, String>{
                    'padding': '1.5rem',
                    'text-align': 'center',
                    'color': 'var(--muted-foreground)',
                  },
                ),
                <Component>[Component.text(props.loadingText)],
              )
            else
              dom.div(
                classes: '$classPrefix-select-options',
                styles: dom.Styles(
                  raw: <String, String>{'padding': optionsPadding},
                ),
                <Component>[
                  dom.div(
                    attributes: const <String, String>{
                      'data-arcane-command-empty': '',
                      'hidden': '',
                    },
                    classes: '$classPrefix-select-empty',
                    styles: const dom.Styles(
                      raw: <String, String>{
                        'padding': '1.5rem',
                        'text-align': 'center',
                        'color': 'var(--muted-foreground)',
                      },
                    ),
                    <Component>[Component.text(props.emptyMessage)],
                  ),
                  if (props.options.isEmpty)
                    dom.div(
                      classes: '$classPrefix-select-empty',
                      styles: const dom.Styles(
                        raw: <String, String>{
                          'padding': '1.5rem',
                          'text-align': 'center',
                          'color': 'var(--muted-foreground)',
                        },
                      ),
                      <Component>[Component.text(props.emptyMessage)],
                    )
                  else
                    for (final SelectOptionProps<T> option in props.options)
                      _buildOption(
                        option,
                        groupId: groupId,
                        groupMode: groupMode,
                        surfaceId: surfaceId,
                        dismissAction: dismissAction,
                      ),
                ],
              ),
          ],
        ),

        if (hasError)
          dom.div(
            id: '$surfaceId-error',
            classes: '$classPrefix-select-error',
            styles: const dom.Styles(
              raw: <String, String>{
                'font-size': 'var(--font-size-sm)',
                'color': 'var(--destructive)',
                'margin-top': '0.75rem',
              },
            ),
            <Component>[Component.text(props.error!)],
          )
        else if (props.helperText != null)
          dom.div(
            id: '$surfaceId-helper',
            classes: '$classPrefix-select-helper',
            styles: const dom.Styles(
              raw: <String, String>{
                'font-size': 'var(--font-size-sm)',
                'color': 'var(--muted-foreground)',
                'margin-top': '0.75rem',
              },
            ),
            <Component>[Component.text(props.helperText!)],
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
        ? props.values?.contains(option.value) ?? false
        : props.value == option.value;
    final String value = _serializeValue(option.value);

    final ArcaneInteraction selectAction = groupMode == 'multi'
        ? ArcaneInteraction.toggleValue(groupId, value)
        : ArcaneInteraction.selectValue(groupId, value);
    final ArcaneInteraction itemAction =
        props.closeOnSelect && !props.multiSelect
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
          '$classPrefix-select-option ${isSelected ? 'selected' : ''} ${option.disabled ? 'disabled' : ''}',
      attributes: <String, String>{
        'type': 'button',
        'role': 'option',
        'aria-selected': '$isSelected',
        if (option.disabled) 'disabled': 'true',
        'data-arcane-command-item': '',
        'data-arcane-command-group-id': '$surfaceId-default',
        'data-label': option.label,
        'data-keywords': keywords.join(' '),
        ...groupItemAttrs(
          groupId: groupId,
          value: value,
          selected: isSelected,
          disabled: option.disabled,
        ),
        if (!option.disabled) ...interactionAttrs(itemAction),
      },
      styles: dom.Styles(raw: optionStyles(isSelected, option.disabled)),
      <Component>[
        if (props.multiSelect && props.showCheckboxes)
          dom.div(
            classes: '$classPrefix-select-option-check',
            styles: dom.Styles(raw: optionCheckboxStyles(isSelected)),
            <Component>[
              if (isSelected)
                dom.span(
                  styles: dom.Styles(
                    raw: <String, String>{'color': optionCheckColor},
                  ),
                  <Component>[ArcaneIcon.check(size: IconSize.xs)],
                ),
            ],
          ),

        if (option.icon != null)
          dom.div(
            styles: dom.Styles(
              raw: <String, String>{'color': optionIconColor(isSelected)},
            ),
            <Component>[option.icon!],
          ),

        // Label and subtitle
        dom.div(
          styles: const dom.Styles(
            raw: <String, String>{'flex': '1', 'min-width': '0'},
          ),
          <Component>[
            dom.div(
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
              dom.div(
                styles: const dom.Styles(
                  raw: <String, String>{
                    'font-size': 'var(--font-size-xs)',
                    'color': 'var(--muted-foreground)',
                    'margin-top': '0.25rem',
                  },
                ),
                <Component>[Component.text(option.subtitle!)],
              ),
          ],
        ),

        // Description (right side)
        if (option.description != null)
          dom.span(
            styles: const dom.Styles(
              raw: <String, String>{
                'font-size': 'var(--font-size-xs)',
                'color': 'var(--muted-foreground)',
                'flex-shrink': '0',
              },
            ),
            <Component>[Component.text(option.description!)],
          ),
      ],
    );
  }
}
