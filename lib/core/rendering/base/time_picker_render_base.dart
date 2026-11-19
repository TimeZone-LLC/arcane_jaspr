import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart';

import 'package:arcane_jaspr/component/view/icon.dart';
import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/interaction/interaction.dart';
import 'package:arcane_jaspr/core/interaction/interaction_attrs.dart';
import 'package:arcane_jaspr/core/rendering/base/style_layering.dart';
import 'package:arcane_jaspr/core/props/time_picker_props.dart';

/// Shared structural base for themed time picker renderers.
///
/// Every theme renders the identical skeleton — a wrapper holding an optional
/// label, a trigger button (clock icon and display text), a clear button, an
/// open dropdown with hour/minute/(period) columns and cancel/confirm actions,
/// and an optional error message. Only the CSS classes and inline styles diverge
/// per theme (and the action buttons differ structurally), so this base factors
/// the skeleton, the column builder and the option/value generation and leaves
/// the value-producing members to the concrete subclass.
///
/// This base lives in core and depends only on core props and the shared icon
/// view; it must never depend on a theme package.
abstract class TimePickerRenderBase extends StatelessComponent {
  const TimePickerRenderBase(this.props, {super.key});

  final TimePickerProps props;

  /// Resolves `{'height': ..., 'fontSize': ...}` for the current size.
  Map<String, String> get sizeStyles;

  /// CSS classes for the wrapper element; receives the resolved error flag.
  String rootClasses(bool hasError);

  /// Attributes for the wrapper element.
  Map<String, String> get rootAttributes;

  /// Inline styles for the wrapper element.
  Map<String, String> get rootStyles;

  /// Per-instance decoration overrides. Default: none. Themes translate an
  /// ArcaneDecoration into their own CSS; unimplemented fields are ignored.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  /// Inline styles for the label span.
  Map<String, String> get labelStyles;

  /// CSS classes for the trigger button.
  String get triggerClasses;

  /// Attributes for the trigger button.
  Map<String, String> get triggerAttributes;

  /// Inline styles for the trigger button.
  Map<String, String> triggerStyles({
    required String height,
    required String fontSize,
    required bool hasError,
    required bool hasValue,
  });

  /// Inline styles for the leading clock icon span.
  Map<String, String> get iconStyles;

  /// CSS classes for the clear button.
  String get clearClasses;

  /// Inline styles for the clear button.
  Map<String, String> get clearStyles;

  /// CSS classes for the dropdown element.
  String get dropdownClasses;

  /// Inline styles for the dropdown element.
  Map<String, String> get dropdownStyles;

  /// Inline styles for the flex row holding the selection columns.
  Map<String, String> get columnsRowStyles;

  /// Inline styles for each selection column container (also the period column).
  Map<String, String> get columnStyles;

  /// Inline styles for each column label span (also the period label).
  Map<String, String> get columnLabelStyles;

  /// Inline styles for each column's scrollable list container.
  Map<String, String> get columnScrollStyles;

  /// CSS class shared by every selectable option/period button.
  String get optionClass;

  /// Inline styles for an option button; [selected] marks the active value.
  Map<String, String> optionButtonStyles({required bool selected});

  /// Inline styles for an AM/PM button; [selected] marks the active period.
  Map<String, String> amPmButtonStyles({required bool selected});

  /// Inline styles for the actions (cancel/confirm) row.
  Map<String, String> get actionsRowStyles;

  /// Builds a footer action button (cancel when [primary] is false, confirm
  /// when true).
  Component buildActionButton({
    required bool primary,
    required void Function()? onClick,
    required String label,
  });

  @override
  Component build(BuildContext context) {
    final bool hasError = props.error != null;
    final bool hasValue = props.value != null;
    final Map<String, String> size = sizeStyles;
    final String height = size['height']!;
    final String fontSize = size['fontSize']!;
    final String pickerId = props.id ?? 'timepicker-${identityHashCode(props)}';
    final String popupId = '$pickerId-pop';
    final String anchorId = '$pickerId-anchor';

    return dom.div(
      classes: rootClasses(hasError),
      attributes: rootAttributes,
      styles: dom.Styles(
        raw: layerStyles(
          <String, String>{...rootStyles},
          <Map<String, String>?>[
            props.decoration?.universalStyles(),
            decorationStyles(props.decoration),
            props.styles?.toMap(),
          ],
        ),
      ),
      <Component>[
        if (props.label != null)
          dom.span(styles: dom.Styles(raw: labelStyles), <Component>[
            Component.text(props.label!),
          ]),
        dom.div(
          styles: const dom.Styles(
            raw: <String, String>{'position': 'relative'},
          ),
          <Component>[
            dom.button(
              classes: triggerClasses,
              type: dom.ButtonType.button,
              attributes: <String, String>{
                ...triggerAttributes,
                ...anchorAttrs(anchorId),
                ...interactionAttrs(ArcaneInteraction.togglePopover(popupId)),
                'aria-controls': popupId,
                'aria-label': '${props.label ?? 'Time'}: ${props.displayText}',
              },
              styles: dom.Styles(
                raw: <String, String>{
                  ...triggerStyles(
                    height: height,
                    fontSize: fontSize,
                    hasError: hasError,
                    hasValue: hasValue,
                  ),
                  if (hasValue && props.clearable)
                    'padding-right': 'calc($height + 0.5rem)',
                },
              ),
              events: <String, EventCallback>{
                if (!props.disabled && props.onToggle != null)
                  'click': (event) {
                    event.stopPropagation();
                    props.onToggle?.call();
                  },
              },
              <Component>[
                dom.span(styles: dom.Styles(raw: iconStyles), <Component>[
                  ArcaneIcon.clock(size: IconSize.sm),
                ]),
                dom.span(
                  styles: const dom.Styles(
                    raw: <String, String>{
                      'flex': '1',
                      'overflow': 'hidden',
                      'text-overflow': 'ellipsis',
                      'white-space': 'nowrap',
                    },
                  ),
                  <Component>[Component.text(props.displayText)],
                ),
              ],
            ),
            if (hasValue && props.clearable)
              dom.button(
                classes: clearClasses,
                type: dom.ButtonType.button,
                attributes: <String, String>{
                  'aria-label': 'Clear time',
                  if (props.disabled) 'disabled': '',
                },
                styles: dom.Styles(
                  raw: <String, String>{
                    'position': 'absolute',
                    'top': '0',
                    'right': '0',
                    'width': height,
                    'height': '100%',
                    'display': 'flex',
                    'align-items': 'center',
                    'justify-content': 'center',
                    'background': 'transparent',
                    'border': '0',
                    'padding': '0',
                    ...clearStyles,
                    if (props.disabled) 'cursor': 'not-allowed',
                    if (props.disabled) 'opacity': '0.5',
                  },
                ),
                events: <String, EventCallback>{
                  if (!props.disabled)
                    'click': (event) {
                      event.stopPropagation();
                      props.onClear?.call();
                    },
                },
                <Component>[ArcaneIcon.x(size: IconSize.xs)],
              ),
          ],
        ),
        dom.div(
          classes: dropdownClasses,
          attributes: <String, String>{
            ...surfaceAttrs(
              surface: 'popover',
              id: popupId,
              anchorId: anchorId,
              anchorPlacement: 'bottom',
              anchorAlign: 'start',
              anchorOffset: '8',
              focusTrap: false,
              initiallyOpen: props.isOpen,
            ),
            'id': popupId,
            'role': 'dialog',
            'aria-label': props.label ?? 'Select time',
            'aria-hidden': '${!props.isOpen}',
            'data-arcane-time-popup': '',
            if (!props.isOpen) 'inert': '',
          },
          events: <String, EventCallback>{
            if (props.onCancel != null)
              'arcane:close': (event) {
                if (event.target == event.currentTarget && props.isOpen) {
                  props.onCancel?.call();
                }
              },
          },
          styles: dom.Styles(
            raw: <String, String>{...dropdownStyles, 'margin-top': '0'},
          ),
          <Component>[
            dom.div(styles: dom.Styles(raw: columnsRowStyles), <Component>[
              _buildTimeColumn(
                label: 'Hour',
                values: props.use24Hour
                    ? List<int>.generate(24, (int i) => i)
                    : List<int>.generate(12, (int i) => i == 0 ? 12 : i),
                selectedValue: props.selectedHour,
                onSelect: props.onSelectHour,
                autofocus: true,
              ),
              _buildTimeColumn(
                label: 'Minute',
                values: List<int>.generate(
                  60 ~/ props.minuteInterval,
                  (int i) => i * props.minuteInterval,
                ),
                selectedValue: props.selectedMinute,
                onSelect: props.onSelectMinute,
                padZero: true,
              ),
              if (!props.use24Hour)
                dom.div(styles: dom.Styles(raw: columnStyles), <Component>[
                  dom.span(
                    styles: dom.Styles(raw: columnLabelStyles),
                    <Component>[const Component.text('Period')],
                  ),
                  dom.button(
                    classes: '$optionClass ${!props.isPM ? 'selected' : ''}',
                    type: dom.ButtonType.button,
                    attributes: <String, String>{
                      'aria-pressed': '${!props.isPM}',
                    },
                    styles: dom.Styles(
                      raw: amPmButtonStyles(selected: !props.isPM),
                    ),
                    events: <String, EventCallback>{
                      'click': (_) {
                        if (props.isPM) props.onTogglePeriod?.call();
                      },
                    },
                    <Component>[const Component.text('AM')],
                  ),
                  dom.button(
                    classes: '$optionClass ${props.isPM ? 'selected' : ''}',
                    type: dom.ButtonType.button,
                    attributes: <String, String>{
                      'aria-pressed': '${props.isPM}',
                    },
                    styles: dom.Styles(
                      raw: amPmButtonStyles(selected: props.isPM),
                    ),
                    events: <String, EventCallback>{
                      'click': (_) {
                        if (!props.isPM) props.onTogglePeriod?.call();
                      },
                    },
                    <Component>[const Component.text('PM')],
                  ),
                ]),
            ]),
            dom.div(styles: dom.Styles(raw: actionsRowStyles), <Component>[
              buildActionButton(
                primary: false,
                onClick: props.onCancel,
                label: 'Cancel',
              ),
              buildActionButton(
                primary: true,
                onClick: props.onConfirm,
                label: 'Confirm',
              ),
            ]),
          ],
        ),
        if (props.error != null)
          dom.span(
            styles: const dom.Styles(
              raw: <String, String>{
                'font-size': 'var(--font-size-sm)',
                'color': 'var(--destructive)',
              },
            ),
            <Component>[Component.text(props.error!)],
          ),
      ],
    );
  }

  Component _buildTimeColumn({
    required String label,
    required List<int> values,
    required int selectedValue,
    required void Function(int)? onSelect,
    bool padZero = false,
    bool autofocus = false,
  }) {
    return dom.div(styles: dom.Styles(raw: columnStyles), <Component>[
      dom.span(styles: dom.Styles(raw: columnLabelStyles), <Component>[
        Component.text(label),
      ]),
      dom.div(
        attributes: <String, String>{
          'data-arcane-time-column': label.toLowerCase(),
          'role': 'group',
          'aria-label': label,
        },
        styles: dom.Styles(
          raw: <String, String>{'position': 'relative', ...columnScrollStyles},
        ),
        <Component>[
          for (final int value in values)
            dom.button(
              classes:
                  '$optionClass ${value == selectedValue ? 'selected' : ''}',
              type: dom.ButtonType.button,
              attributes: <String, String>{
                'aria-pressed': '${value == selectedValue}',
                if (autofocus && value == selectedValue)
                  'data-arcane-autofocus': '',
              },
              styles: dom.Styles(
                raw: optionButtonStyles(selected: value == selectedValue),
              ),
              events: <String, EventCallback>{
                'click': (_) => onSelect?.call(value),
              },
              <Component>[
                Component.text(
                  padZero ? value.toString().padLeft(2, '0') : '$value',
                ),
              ],
            ),
        ],
      ),
    ]);
  }
}
