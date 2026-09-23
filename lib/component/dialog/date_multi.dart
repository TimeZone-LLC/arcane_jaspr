import 'package:arcane_jaspr/component/dialog/dialog.dart';
import 'package:arcane_jaspr/component/input/button.dart';
import 'package:arcane_jaspr/component/input/date_picker.dart';
import 'package:arcane_jaspr/component/layout/flow.dart';
import 'package:arcane_jaspr/flutter.dart';
import 'package:arcane_jaspr/component/typography/text.dart';
import 'package:arcane_jaspr/util/arcane.dart';

class DialogDateMulti extends StatefulWidget {
  final String title;
  final List<DateTime> values;
  final void Function(List<DateTime>) onConfirm;

  const DialogDateMulti({
    required this.title,
    required this.onConfirm,
    this.values = const <DateTime>[],
    super.key,
  });

  @override
  State<DialogDateMulti> createState() => _DialogDateMultiState();
}

class _DialogDateMultiState extends State<DialogDateMulti> {
  late List<DateTime> _values;
  DateTime? _draft;

  @override
  void initState() {
    super.initState();
    _values = List<DateTime>.from(widget.values);
  }

  @override
  Widget build(BuildContext context) => ArcaneDialog(
    title: widget.title,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: <Widget>[
        ArcaneDatePicker(
          value: _draft,
          onChanged: (DateTime? value) {
            setState(() {
              _draft = value;
            });
          },
        ),
        Button.secondary(
          onPressed: _draft == null
              ? null
              : () {
                  setState(() {
                    _values.add(_draft!);
                    _draft = null;
                  });
                },
          label: 'Add date',
        ),
        ..._values.map(
          (DateTime value) =>
              Text.body(value.toIso8601String().split('T').first),
        ),
      ],
    ),
    actions: <Widget>[
      Button.primary(onPressed: () => widget.onConfirm(_values), label: 'Done'),
    ],
  );
}
