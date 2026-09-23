import 'package:arcane_jaspr/component/dialog/dialog.dart';
import 'package:arcane_jaspr/component/input/button.dart';
import 'package:arcane_jaspr/component/input/time_picker.dart';
import 'package:arcane_jaspr/flutter.dart';

class DialogTime extends StatefulWidget {
  final String title;
  final TimeOfDay? value;
  final void Function(TimeOfDay?) onConfirm;

  const DialogTime({
    required this.title,
    required this.onConfirm,
    this.value,
    super.key,
  });

  @override
  State<DialogTime> createState() => _DialogTimeState();
}

class _DialogTimeState extends State<DialogTime> {
  TimeOfDay? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) => ArcaneDialog(
    title: widget.title,
    child: ArcaneTimePicker(
      value: _value,
      onChanged: (TimeOfDay? value) {
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
