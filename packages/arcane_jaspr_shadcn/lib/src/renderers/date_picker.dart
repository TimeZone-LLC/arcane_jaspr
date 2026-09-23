import 'package:jaspr/jaspr.dart';

import 'package:arcane_jaspr/core/props/calendar_props.dart';
import 'package:arcane_jaspr/core/props/date_picker_props.dart';
import 'package:arcane_jaspr/core/rendering/base/date_picker_render_base.dart';
import 'calendar.dart';

/// ShadCN-style date picker component
/// Reference: https://ui.shadcn.com/docs/components/date-picker
class ShadcnDatePicker extends DatePickerRenderBase {
  const ShadcnDatePicker(super.props, {super.key});

  @override
  (String, String) sizeStyles(DatePickerSizeVariant size) => switch (size) {
    DatePickerSizeVariant.sm => ('32px', '13px'),
    DatePickerSizeVariant.md => ('36px', '14px'),
    DatePickerSizeVariant.lg => ('40px', '14px'),
  };

  @override
  String get anchorOffset => '4';

  @override
  String get rootClasses => 'arcane-date-picker';

  @override
  Map<String, String> get rootAttributes => <String, String>{
    'data-disabled': '${props.disabled}',
  };

  @override
  Map<String, String> get rootStyles => const <String, String>{
    'position': 'relative',
    'display': 'flex',
    'flex-direction': 'column',
    'gap': 'var(--space-1)',
  };

  @override
  Map<String, String> get labelStyles => const <String, String>{
    'font-size': 'var(--font-size-sm)',
    'font-weight': 'var(--font-weight-medium)',
    'color': 'var(--foreground)',
  };

  @override
  String get triggerClasses => 'arcane-date-picker-trigger';

  @override
  Map<String, String> triggerExtraAttrs(bool hasError) => <String, String>{
    'data-error': '$hasError',
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
    'gap': 'var(--space-2)',
    'width': '100%',
    'height': height,
    'padding': '0 12px',
    'background-color': 'var(--shadcn-item-background, var(--background))',
    'border':
        '1px solid var(--shadcn-control-border-color, ${hasError ? 'var(--destructive)' : 'var(--input)'})',
    'border-radius': 'var(--radius-md)',
    'box-shadow': 'var(--shadcn-control-shadow, var(--shadow-xs))',
    'font-size': fontSize,
    'color':
        'var(--shadcn-item-foreground, ${hasValue ? 'var(--foreground)' : 'var(--muted-foreground)'})',
    'cursor': props.disabled ? 'not-allowed' : 'pointer',
    'transition':
        'background-color var(--transition), color var(--transition), '
        'border-color var(--transition), box-shadow var(--transition)',
    'text-align': 'left',
    if (props.disabled) 'opacity': '0.5',
  };

  @override
  Map<String, String> get iconStyles => const <String, String>{
    'color': 'var(--muted-foreground)',
  };

  @override
  Map<String, String> get displayStyles => const <String, String>{
    'flex': '1',
    'overflow': 'hidden',
    'text-overflow': 'ellipsis',
    'white-space': 'nowrap',
  };

  @override
  String get clearClasses => 'arcane-date-picker-clear';

  @override
  Map<String, String> get clearExtraAttrs => const <String, String>{};

  @override
  Map<String, String> get clearStyles => const <String, String>{
    'color': 'var(--muted-foreground)',
    'cursor': 'pointer',
    'transition': 'color var(--transition)',
  };

  @override
  String get dropdownClasses => 'arcane-date-picker-dropdown';

  @override
  Map<String, String> get dropdownStyles => const <String, String>{
    'position': 'absolute',
    'top': '100%',
    'left': '0',
    'margin-top': '4px',
    'z-index': '50',
    'border-radius': 'var(--radius-md)',
    'box-shadow': 'var(--shadcn-surface-shadow)',
  };

  @override
  Component buildCalendar(CalendarProps calendarProps) =>
      ShadcnCalendar(calendarProps);
}
