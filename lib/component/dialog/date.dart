import 'package:arcane_jaspr/component/dialog/dialog.dart';
import 'package:arcane_jaspr/component/input/button.dart';
import 'package:arcane_jaspr/component/input/date_picker.dart';
import 'package:arcane_jaspr/component/layout/flow.dart';
import 'package:arcane_jaspr/flutter.dart';
import 'package:arcane_jaspr/component/typography/text.dart';
import 'package:arcane_jaspr/util/arcane.dart';

class DialogDate extends StatefulWidget {
  final String title;
  final DateTime? value;
  final void Function(DateTime?) onConfirm;
  final String? description;

  const DialogDate({
    required this.title,
    required this.onConfirm,
    this.value,
    this.description,
    super.key,
  });

  @override
  State<DialogDate> createState() => _DialogDateState();
}

class _DialogDateState extends State<DialogDate> {
  DateTime? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) => ArcaneDialog(
    title: widget.title,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: <Widget>[
        if (widget.description != null) Text.body(widget.description!),
        ArcaneDatePicker(
          value: _value,
          onChanged: (DateTime? value) {
            setState(() {
              _value = value;
            });
          },
        ),
      ],
    ),
    actions: <Widget>[
      Button.ghost(onPressed: () {}, label: 'Cancel'),
      Button.primary(onPressed: () => widget.onConfirm(_value), label: 'Done'),
    ],
  );
}
