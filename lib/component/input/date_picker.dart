import 'package:arcane_jaspr/flutter.dart';

import '../../core/decoration/arcane_decoration.dart';
import '../../core/theme_provider.dart';
import '../../util/style_types/arcane_style_data.dart';
import 'calendar.dart';

export '../../core/props/date_picker_props.dart'
    show DatePickerSizeVariant, DatePickerProps;

/// Size variants for date picker.
enum DatePickerSize { sm, md, lg }

/// A date picker input with calendar dropdown.
class ArcaneDatePicker extends StatefulWidget {
  final String? id;
  final DateTime? value;
  final void Function(DateTime?)? onChanged;
  final String? label;
  final String? placeholder;
  final String Function(DateTime)? formatDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  final bool Function(DateTime)? disabledDates;
  final bool disabled;
  final String? error;
  final bool clearable;
  final DatePickerSize size;
  final CalendarMode mode;
  final DateRange? rangeValue;
  final void Function(DateRange?)? onRangeChanged;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation + theme-specific fields).
  final ArcaneDecoration? decoration;

  const ArcaneDatePicker({
    this.id,
    this.value,
    this.onChanged,
    this.label,
    this.placeholder,
    this.formatDate,
    this.minDate,
    this.maxDate,
    this.disabledDates,
    this.disabled = false,
    this.error,
    this.clearable = true,
    this.size = DatePickerSize.md,
    this.mode = CalendarMode.single,
    this.rangeValue,
    this.onRangeChanged,
    this.styles,
    this.decoration,
    super.key,
  });

  const ArcaneDatePicker.range({
    this.id,
    this.rangeValue,
    this.onRangeChanged,
    this.label,
    this.placeholder,
    this.formatDate,
    this.minDate,
    this.maxDate,
    this.disabledDates,
    this.disabled = false,
    this.error,
    this.clearable = true,
    this.size = DatePickerSize.md,
    this.styles,
    this.decoration,
    super.key,
  }) : value = null,
       onChanged = null,
       mode = CalendarMode.range;

  @override
  State<ArcaneDatePicker> createState() => _ArcaneDatePickerState();
}

class _ArcaneDatePickerState extends State<ArcaneDatePicker> {
  bool _isOpen = false;
  late DateTime _displayMonth;

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  void initState() {
    super.initState();
    _displayMonth = widget.value ?? DateTime.now();
    _displayMonth = DateTime(_displayMonth.year, _displayMonth.month, 1);
  }

  String _defaultFormat(DateTime date) {
    return '${_months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String get _displayText {
    if (widget.mode == CalendarMode.range) {
      if (widget.rangeValue == null) {
        return widget.placeholder ?? 'Select date range...';
      }
      final format = widget.formatDate ?? _defaultFormat;
      return '${format(widget.rangeValue!.start)} - ${format(widget.rangeValue!.end)}';
    }

    if (widget.value == null) {
      return widget.placeholder ?? 'Select date...';
    }
    return (widget.formatDate ?? _defaultFormat)(widget.value!);
  }

  void _toggleOpen() {
    if (widget.disabled) return;
    setState(() => _isOpen = !_isOpen);
  }

  void _selectDate(DateTime date) {
    widget.onChanged?.call(date);
    setState(() => _isOpen = false);
  }

  void _selectRange(DateRange range) {
    widget.onRangeChanged?.call(range);
    setState(() => _isOpen = false);
  }

  void _clear() {
    if (widget.mode == CalendarMode.range) {
      widget.onRangeChanged?.call(null);
    } else {
      widget.onChanged?.call(null);
    }
  }

  bool _isDisabled(DateTime date) {
    if (widget.disabledDates?.call(date) ?? false) return true;
    if (widget.minDate != null && date.isBefore(widget.minDate!)) return true;
    if (widget.maxDate != null && date.isAfter(widget.maxDate!)) return true;
    return false;
  }

  DatePickerSizeVariant get _propsSize => switch (widget.size) {
    DatePickerSize.sm => DatePickerSizeVariant.sm,
    DatePickerSize.md => DatePickerSizeVariant.md,
    DatePickerSize.lg => DatePickerSizeVariant.lg,
  };

  CalendarModeVariant get _propsMode => switch (widget.mode) {
    CalendarMode.single => CalendarModeVariant.single,
    CalendarMode.range => CalendarModeVariant.range,
  };

  DateRangeValue? get _propsRangeValue {
    if (widget.rangeValue == null) return null;
    return DateRangeValue(
      start: widget.rangeValue!.start,
      end: widget.rangeValue!.end,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String resolvedId =
        widget.id ?? 'datepicker-${identityHashCode(widget)}';
    final String calendarId = '$resolvedId-cal';
    return context.renderers.datePicker(
      DatePickerProps(
        id: resolvedId,
        value: widget.value,
        label: widget.label,
        placeholder: widget.placeholder,
        minDate: widget.minDate,
        maxDate: widget.maxDate,
        disabled: widget.disabled,
        error: widget.error,
        clearable: widget.clearable,
        size: _propsSize,
        mode: _propsMode,
        rangeValue: _propsRangeValue,
        isOpen: _isOpen,
        displayText: _displayText,
        onToggle: _toggleOpen,
        onSelect: _selectDate,
        onRangeSelect: (range) =>
            _selectRange(DateRange(start: range.start, end: range.end)),
        onClear: _clear,
        styles: widget.styles,
        decoration: widget.decoration,
        calendarProps: CalendarProps(
          id: calendarId,
          selected: widget.value,
          displayMonth: _displayMonth,
          minDate: widget.minDate,
          maxDate: widget.maxDate,
          mode: _propsMode,
          selectedRange: _propsRangeValue,
          isDisabled: _isDisabled,
          onPreviousMonth: () {
            setState(() {
              _displayMonth = DateTime(
                _displayMonth.year,
                _displayMonth.month - 1,
                1,
              );
            });
          },
          onNextMonth: () {
            setState(() {
              _displayMonth = DateTime(
                _displayMonth.year,
                _displayMonth.month + 1,
                1,
              );
            });
          },
          onGoToToday: () {
            final DateTime now = DateTime.now();
            setState(() {
              _displayMonth = DateTime(now.year, now.month, 1);
            });
          },
          onSelectDate: _selectDate,
        ),
      ),
    );
  }
}
