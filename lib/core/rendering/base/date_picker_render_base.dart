import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart';

import 'package:arcane_jaspr/component/view/icon.dart';
import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/interaction/interaction.dart';
import 'package:arcane_jaspr/core/interaction/interaction_attrs.dart';
import 'package:arcane_jaspr/core/props/calendar_props.dart';
import 'package:arcane_jaspr/core/props/date_picker_props.dart';

/// Shared structural base for themed date picker renderers.
///
/// Every theme renders the identical skeleton — a wrapper holding an optional
/// label, a trigger button (display text and one calendar or clear glyph),
/// a popover dropdown that hosts the theme's calendar, and an optional error
/// message — wired with the same id/anchor/popover interaction attributes. Only
/// the CSS classes and inline styles diverge per theme, so this base factors the
/// skeleton and the interaction wiring and leaves the value-producing members
/// (including the theme calendar) to the concrete subclass.
///
/// This base lives in core and depends only on core props, interaction helpers
/// and the shared icon view; it must never depend on a theme package.
abstract class DatePickerRenderBase extends StatelessComponent {
  const DatePickerRenderBase(this.props, {super.key});

  final DatePickerProps props;

  /// Resolves the `(height, fontSize)` pair for the given size variant.
  (String, String) sizeStyles(DatePickerSizeVariant size);

  /// `anchorOffset` passed to the popover surface attributes.
  String get anchorOffset;

  /// CSS classes for the wrapper element.
  String get rootClasses;

  /// Attributes for the wrapper element.
  Map<String, String> get rootAttributes;

  /// Inline styles for the wrapper element.
  Map<String, String> get rootStyles;

  /// Inline styles for the label span.
  Map<String, String> get labelStyles;

  /// CSS classes for the trigger button.
  String get triggerClasses;

  /// Extra trigger attributes appended after the disabled flag.
  Map<String, String> triggerExtraAttrs(bool hasError);

  /// Inline styles for the trigger button.
  Map<String, String> triggerStyles({
    required String height,
    required String fontSize,
    required bool hasError,
    required bool hasValue,
  });

  /// Per-instance decoration overrides. Default: none. A theme overrides this
  /// to translate an [ArcaneDecoration] (elevation intent, theme-specific
  /// fields) into its own CSS. Fields a theme does not implement are ignored.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  /// Inline styles for the leading calendar icon span.
  Map<String, String> get iconStyles;

  /// Inline styles for the display text span.
  Map<String, String> get displayStyles;

  /// CSS classes for the clear button span.
  String get clearClasses;

  /// Extra clear-button attributes inserted before the interaction attributes.
  Map<String, String> get clearExtraAttrs;

  /// Inline styles for the clear button span.
  Map<String, String> get clearStyles;

  /// CSS classes for the dropdown element.
  String get dropdownClasses;

  /// Inline styles for the dropdown element.
  Map<String, String> get dropdownStyles;

  /// Builds the theme's calendar for the dropdown.
  Component buildCalendar(CalendarProps calendarProps);

  @override
  Component build(BuildContext context) {
    final bool hasError = props.error != null;
    final bool hasValue = props.mode == CalendarModeVariant.range
        ? props.rangeValue != null
        : props.value != null;
    final (String height, String fontSize) = sizeStyles(props.size);
    final String pickerId = props.id ?? 'datepicker-${identityHashCode(props)}';
    final String popoverId = '$pickerId-pop';
    final String calendarId = props.calendarProps?.id ?? '$pickerId-cal';
    final String triggerAnchorId = '$pickerId-anchor';

    final Map<String, String> triggerAttrs = mergeAttrs(<Map<String, String>>[
      anchorAttrs(triggerAnchorId),
      calendarTriggerAttrs(calendarId),
      interactionAttrs(ArcaneInteraction.togglePopover(popoverId)),
      <String, String>{
        'type': 'button',
        'aria-haspopup': 'dialog',
        'aria-controls': popoverId,
        'aria-expanded': '${props.isOpen}',
        'data-arcane-placeholder': props.placeholder ?? '',
      },
    ]);

    final Map<String, String> popoverAttrs = mergeAttrs(<Map<String, String>>[
      surfaceAttrs(
        surface: 'popover',
        id: popoverId,
        anchorId: triggerAnchorId,
        anchorPlacement: 'bottom',
        anchorAlign: 'start',
        anchorOffset: anchorOffset,
        focusTrap: false,
        initiallyOpen: props.isOpen,
      ),
      calendarPickerAttrs(calendarId),
    ]);

    return dom.div(
      classes: rootClasses,
      attributes: rootAttributes,
      styles: dom.Styles(raw: rootStyles),
      <Component>[
        if (props.label != null)
          dom.span(styles: dom.Styles(raw: labelStyles), <Component>[
            Component.text(props.label!),
          ]),
        dom.button(
          classes: triggerClasses,
          attributes: <String, String>{
            ...triggerAttrs,
            if (props.disabled) 'disabled': 'true',
            ...triggerExtraAttrs(hasError),
          },
          events: <String, EventCallback>{
            if (!props.disabled && props.onToggle != null)
              'click': (event) {
                event.stopPropagation();
                props.onToggle?.call();
              },
          },
          styles: dom.Styles(
            raw: <String, String>{
              ...triggerStyles(
                height: height,
                fontSize: fontSize,
                hasError: hasError,
                hasValue: hasValue,
              ),
              ...?props.decoration?.universalStyles(),
              ...decorationStyles(props.decoration),
              ...?props.styles?.toMap(),
            },
          ),
          <Component>[
            if (!hasValue || !props.clearable)
              dom.span(styles: dom.Styles(raw: iconStyles), <Component>[
                ArcaneIcon.calendar(size: IconSize.sm),
              ]),
            dom.span(
              attributes: const <String, String>{
                'data-arcane-calendar-display': '',
              },
              styles: dom.Styles(raw: displayStyles),
              <Component>[Component.text(props.displayText)],
            ),
            if (hasValue && props.clearable)
              dom.span(
                classes: clearClasses,
                attributes: <String, String>{
                  'role': 'button',
                  'aria-label': 'Clear date',
                  ...clearExtraAttrs,
                  ...interactionAttrs(
                    ArcaneInteraction.calendarToday(calendarId),
                  ),
                },
                events: <String, EventCallback>{
                  if (props.onClear != null)
                    'click': (event) {
                      event.stopPropagation();
                      props.onClear?.call();
                    },
                },
                styles: dom.Styles(raw: clearStyles),
                <Component>[ArcaneIcon.x(size: IconSize.xs)],
              ),
          ],
        ),
        dom.div(
          classes: dropdownClasses,
          attributes: popoverAttrs,
          events: <String, EventCallback>{
            if (props.onToggle != null)
              'arcane:close': (_) {
                if (props.isOpen) {
                  props.onToggle?.call();
                }
              },
          },
          styles: dom.Styles(raw: dropdownStyles),
          <Component>[
            if (props.calendarProps != null)
              buildCalendar(props.calendarProps!),
          ],
        ),
        if (hasError)
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
}
