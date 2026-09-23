import 'package:arcane_jaspr/flutter.dart';

import '../../core/decoration/arcane_decoration.dart';
import '../../core/theme_provider.dart';
import '../../util/style_types/arcane_style_data.dart';

export '../../core/props/calendar_props.dart'
    show CalendarModeVariant, DateRangeValue, CalendarProps;

/// Calendar selection mode.
enum CalendarMode { single, range }

/// A date range.
class DateRange {
  final DateTime start;
  final DateTime end;

  const DateRange({required this.start, required this.end});
}

/// A calendar component for date selection.
class ArcaneCalendar extends StatefulWidget {
  final String? id;
  final DateTime? selected;
  final void Function(DateTime)? onSelect;
  final DateTime? month;
  final void Function(DateTime)? onMonthChange;
  final DateTime? minDate;
  final DateTime? maxDate;
  final bool Function(DateTime)? disabledDates;
  final bool showWeekNumbers;
  final bool showToday;
  final int firstDayOfWeek;
  final CalendarMode mode;
  final DateRange? selectedRange;
  final void Function(DateRange)? onRangeSelect;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation + theme-specific fields).
  final ArcaneDecoration? decoration;

  const ArcaneCalendar({
    this.id,
    this.selected,
    this.onSelect,
    this.month,
    this.onMonthChange,
    this.minDate,
    this.maxDate,
    this.disabledDates,
    this.showWeekNumbers = false,
    this.showToday = true,
    this.firstDayOfWeek = 0,
    this.mode = CalendarMode.single,
    this.selectedRange,
    this.onRangeSelect,
    this.styles,
    this.decoration,
    super.key,
  });

  @override
  State<ArcaneCalendar> createState() => _ArcaneCalendarState();
}

class _ArcaneCalendarState extends State<ArcaneCalendar> {
  late DateTime _displayMonth;
  DateTime? _rangeStart;

  @override
  void initState() {
    super.initState();
    _displayMonth = widget.month ?? widget.selected ?? DateTime.now();
    _displayMonth = DateTime(_displayMonth.year, _displayMonth.month, 1);
  }

  void _previousMonth() {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month - 1, 1);
    });
    widget.onMonthChange?.call(_displayMonth);
  }

  void _nextMonth() {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + 1, 1);
    });
    widget.onMonthChange?.call(_displayMonth);
  }

  void _goToToday() {
    final now = DateTime.now();
    setState(() {
      _displayMonth = DateTime(now.year, now.month, 1);
    });
    widget.onMonthChange?.call(_displayMonth);
  }

  bool _isDisabled(DateTime date) {
    if (widget.disabledDates?.call(date) ?? false) return true;
    if (widget.minDate != null && date.isBefore(widget.minDate!)) return true;
    if (widget.maxDate != null && date.isAfter(widget.maxDate!)) return true;
    return false;
  }

  void _selectDate(DateTime date) {
    if (_isDisabled(date)) return;

    if (widget.mode == CalendarMode.range) {
      if (_rangeStart == null) {
        setState(() => _rangeStart = date);
      } else {
        final start = _rangeStart!.isBefore(date) ? _rangeStart! : date;
        final end = _rangeStart!.isBefore(date) ? date : _rangeStart!;
        widget.onRangeSelect?.call(DateRange(start: start, end: end));
        setState(() => _rangeStart = null);
      }
    } else {
      widget.onSelect?.call(date);
    }
  }

  CalendarModeVariant get _propsMode => switch (widget.mode) {
    CalendarMode.single => CalendarModeVariant.single,
    CalendarMode.range => CalendarModeVariant.range,
  };

  DateRangeValue? get _propsSelectedRange {
    if (widget.selectedRange == null) return null;
    return DateRangeValue(
      start: widget.selectedRange!.start,
      end: widget.selectedRange!.end,
    );
  }

  @override
  Widget build(BuildContext context) {
    return context.renderers.calendar(
      CalendarProps(
        id: widget.id,
        selected: widget.selected,
        displayMonth: _displayMonth,
        minDate: widget.minDate,
        maxDate: widget.maxDate,
        showWeekNumbers: widget.showWeekNumbers,
        showToday: widget.showToday,
        firstDayOfWeek: widget.firstDayOfWeek,
        mode: _propsMode,
        selectedRange: _propsSelectedRange,
        rangeStart: _rangeStart,
        isDisabled: _isDisabled,
        onPreviousMonth: _previousMonth,
        onNextMonth: _nextMonth,
        onGoToToday: _goToToday,
        onSelectDate: _selectDate,
        styles: widget.styles,
        decoration: widget.decoration,
      ),
    );
  }
}
