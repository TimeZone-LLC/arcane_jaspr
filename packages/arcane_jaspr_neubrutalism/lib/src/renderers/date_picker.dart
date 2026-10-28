import 'package:jaspr/jaspr.dart';

import 'package:arcane_jaspr/core/props/calendar_props.dart';
import 'package:arcane_jaspr/core/props/date_picker_props.dart';
import 'package:arcane_jaspr/core/rendering/base/date_picker_render_base.dart';
import 'calendar.dart';

/// Neubrutalism date picker renderer with restrained panel styling.
class NeubrutalismDatePicker extends DatePickerRenderBase {
  const NeubrutalismDatePicker(super.props, {super.key});

  @override
  (String, String) sizeStyles(DatePickerSizeVariant size) => switch (size) {
    DatePickerSizeVariant.sm => ('42px', '0.8125rem'),
    DatePickerSizeVariant.md => ('48px', '0.875rem'),
    DatePickerSizeVariant.lg => ('54px', '0.95rem'),
  };

  @override
  String get anchorOffset => '8';

  @override
  String get rootClasses =>
      'neubrutalism-date-picker ${props.disabled ? 'disabled' : ''}';

  @override
  Map<String, String> get rootAttributes => <String, String>{
    'data-disabled': '${props.disabled}',
    'data-size': props.size.name,
  };

  @override
  Map<String, String> get rootStyles => const <String, String>{
    'position': 'relative',
    'display': 'flex',
    'flex-direction': 'column',
    'gap': 'var(--space-2)',
  };

  @override
  Map<String, String> get labelStyles => const <String, String>{
    'font-family': 'var(--font-heading)',
    'font-size': '0.75rem',
    'font-weight': '600',
    'letter-spacing': '0.08em',
    'text-transform': 'uppercase',
    'color': 'var(--muted-foreground)',
  };

  @override
  String get triggerClasses => 'neubrutalism-date-picker-trigger';

  @override
  Map<String, String> triggerExtraAttrs(bool hasError) => <String, String>{
    'data-error': '$hasError',
    'aria-invalid': '$hasError',
  };

  @override
  Map<String, String> triggerStyles({
    required String height,
    required String fontSize,
    required bool hasError,
    required bool hasValue,
  }) => <String, String>{
    'display': 'flex',
    'align-items': 'center',
    'gap': '0.75rem',
    'width': '100%',
    'height': height,
    'padding': '0 1rem',
    'background': 'var(--nb-paper, var(--card))',
    'border': hasError
        ? 'var(--nb-border-thick, 3px) solid var(--destructive)'
        : 'var(--nb-border-thick, 3px) solid var(--nb-line, #000)',
    'font-size': fontSize,
    'font-weight': '600',
    'color': hasValue
        ? 'var(--nb-ink, var(--foreground))'
        : 'var(--muted-foreground)',
    'cursor': props.disabled ? 'not-allowed' : 'pointer',
    'transition':
        'transform var(--nb-transition, 120ms ease), box-shadow var(--nb-transition, 120ms ease)',
    'box-shadow':
        'var(--nb-shadow-md, 5px 5px 0 0 var(--nb-shadow-color, #000))',
    if (props.disabled) 'opacity': '0.5',
  };

  @override
  Map<String, String> get iconStyles => const <String, String>{
    'display': 'flex',
    'color': 'var(--muted-foreground)',
  };

  @override
  Map<String, String> get displayStyles => const <String, String>{
    'flex': '1',
    'overflow': 'hidden',
    'text-overflow': 'ellipsis',
    'white-space': 'nowrap',
    'text-align': 'left',
  };

  @override
  String get clearClasses => 'neubrutalism-date-picker-clear';

  @override
  Map<String, String> get clearExtraAttrs => const <String, String>{
    'data-state': 'clearable',
  };

  @override
  Map<String, String> get clearStyles => const <String, String>{
    'display': 'flex',
    'color': 'var(--muted-foreground)',
    'cursor': 'pointer',
  };

  @override
  String get dropdownClasses =>
      'neubrutalism-date-picker-dropdown neubrutalism-date-picker';

  @override
  Map<String, String> get dropdownStyles => const <String, String>{
    'position': 'absolute',
    'top': '100%',
    'left': '0',
    'margin-top': '0.5rem',
    'z-index': '50',
  };

  @override
  Component buildCalendar(CalendarProps calendarProps) =>
      NeubrutalismCalendar(calendarProps);
}
