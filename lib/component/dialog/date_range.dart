import 'package:arcane_jaspr/component/dialog/dialog.dart';
import 'package:arcane_jaspr/component/input/button.dart';
import 'package:arcane_jaspr/component/input/date_picker.dart';
import 'package:arcane_jaspr/flutter.dart';
import 'package:arcane_jaspr/component/input/calendar.dart';

class DialogDateRange extends StatefulWidget {
  final String title;
  final DateRange? value;
  final void Function(DateRange?) onConfirm;

  const DialogDateRange({
    required this.title,
    required this.onConfirm,
    this.value,
    super.key,
  });

  @override
  State<DialogDateRange> createState() => _DialogDateRangeState();
}

class _DialogDateRangeState extends State<DialogDateRange> {
  DateRange? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) => ArcaneDialog(
    title: widget.title,
    child: ArcaneDatePicker.range(
      rangeValue: _value,
      onRangeChanged: (DateRange? value) {
        setState(() {
          _value = value;
        });
      },
    ),
    actions: <Widget>[
      Button.primary(onPressed: () => widget.onConfirm(_value), label: 'Done'),
    ],
  );
}
