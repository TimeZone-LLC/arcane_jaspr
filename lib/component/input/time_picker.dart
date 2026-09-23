import 'package:arcane_jaspr/core/theme_provider.dart';
import 'package:arcane_jaspr/flutter.dart';

import '../../core/decoration/arcane_decoration.dart';
import '../../util/style_types/arcane_style_data.dart';

export 'package:arcane_jaspr/core/props/time_picker_props.dart';

/// A time picker input with dropdown selection.
class ArcaneTimePicker extends StatefulWidget {
  final String? id;
  final TimeOfDay? value;
  final void Function(TimeOfDay?)? onChanged;
  final String? label;
  final String? placeholder;
  final bool use24Hour;
  final int minuteInterval;
  final bool disabled;
  final String? error;
  final bool clearable;
  final bool showSeconds;
  final ComponentSize size;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation + theme-specific fields).
  final ArcaneDecoration? decoration;

  const ArcaneTimePicker({
    this.id,
    this.value,
    this.onChanged,
    this.label,
    this.placeholder,
    this.use24Hour = false,
    this.minuteInterval = 1,
    this.disabled = false,
    this.error,
    this.clearable = true,
    this.showSeconds = false,
    this.size = ComponentSize.md,
    this.styles,
    this.decoration,
    super.key,
  });

  @override
  State<ArcaneTimePicker> createState() => _ArcaneTimePickerState();
}

class _ArcaneTimePickerState extends State<ArcaneTimePicker> {
  bool _isOpen = false;
  late TimeOfDay _workingTime;

  @override
  void initState() {
    super.initState();
    _workingTime = _baseTime;
  }

  @override
  void didUpdateWidget(covariant ArcaneTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isOpen && widget.value != oldWidget.value) {
      _workingTime = _baseTime;
    }
  }

  TimeOfDay get _baseTime => widget.value ?? TimeOfDay.now();

  int get _minuteInterval {
    if (widget.minuteInterval <= 0) {
      return 1;
    }
    if (widget.minuteInterval > 60) {
      return 60;
    }
    return widget.minuteInterval;
  }

  String get _displayText {
    if (widget.value == null) {
      return widget.placeholder ?? 'Select time...';
    }
    return widget.value!.format(use24Hour: widget.use24Hour);
  }

  int get _selectedHour {
    if (widget.use24Hour) {
      return _workingTime.hour;
    }
    return _workingTime.hourOfPeriod;
  }

  void _toggleOpen() {
    if (widget.disabled) {
      return;
    }
    setState(() {
      if (!_isOpen) {
        _workingTime = _baseTime;
      }
      _isOpen = !_isOpen;
    });
  }

  void _clear() {
    widget.onChanged?.call(null);
    setState(() {
      _workingTime = _baseTime;
      _isOpen = false;
    });
  }

  void _selectHour(int hour) {
    int resolvedHour = hour;
    if (!widget.use24Hour) {
      if (_workingTime.isPM) {
        resolvedHour = hour == 12 ? 12 : hour + 12;
      } else {
        resolvedHour = hour == 12 ? 0 : hour;
      }
    }
    setState(() {
      _workingTime = _workingTime.copyWith(hour: resolvedHour);
    });
  }

  void _selectMinute(int minute) {
    setState(() {
      _workingTime = _workingTime.copyWith(minute: minute);
    });
  }

  void _togglePeriod() {
    int hour = _workingTime.hour;
    if (_workingTime.isPM) {
      hour -= 12;
    } else {
      hour += 12;
    }
    setState(() {
      _workingTime = _workingTime.copyWith(hour: hour);
    });
  }

  void _cancel() {
    setState(() {
      _workingTime = _baseTime;
      _isOpen = false;
    });
  }

  void _confirm() {
    widget.onChanged?.call(_workingTime);
    setState(() {
      _isOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String resolvedId =
        widget.id ?? 'timepicker-${identityHashCode(widget)}';
    return context.renderers.timePicker(
      TimePickerProps(
        id: resolvedId,
        value: widget.value,
        displayText: _displayText,
        placeholder: widget.placeholder,
        label: widget.label,
        disabled: widget.disabled,
        error: widget.error,
        clearable: widget.clearable,
        size: widget.size,
        use24Hour: widget.use24Hour,
        minuteInterval: _minuteInterval,
        isOpen: _isOpen,
        selectedHour: _selectedHour,
        selectedMinute: _workingTime.minute,
        isPM: _workingTime.isPM,
        onToggle: _toggleOpen,
        onClear: _clear,
        onSelectHour: _selectHour,
        onSelectMinute: _selectMinute,
        onTogglePeriod: _togglePeriod,
        onCancel: _cancel,
        onConfirm: _confirm,
        styles: widget.styles,
        decoration: widget.decoration,
      ),
    );
  }
}
