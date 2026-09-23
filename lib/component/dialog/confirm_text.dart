import 'package:arcane_jaspr/component/dialog/dialog.dart';
import 'package:arcane_jaspr/component/input/button.dart';
import 'package:arcane_jaspr/component/input/text_input.dart';
import 'package:arcane_jaspr/component/layout/flow.dart';
import 'package:arcane_jaspr/flutter.dart';
import 'package:arcane_jaspr/component/typography/text.dart';
import 'package:arcane_jaspr/util/arcane.dart';

class ConfirmText extends StatefulWidget {
  final String title;
  final String confirmPhrase;
  final void Function(String value)? onConfirm;
  final void Function()? onCancel;
  final String? description;

  const ConfirmText({
    required this.title,
    required this.confirmPhrase,
    this.onConfirm,
    this.onCancel,
    this.description,
    super.key,
  });

  @override
  State<ConfirmText> createState() => _ConfirmTextState();
}

class _ConfirmTextState extends State<ConfirmText> {
  String _value = '';

  @override
  Widget build(BuildContext context) => ArcaneDialog(
    title: widget.title,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: <Widget>[
        if (widget.description != null) Text.body(widget.description!),
        Text.body('Type ${widget.confirmPhrase} to continue.'),
        TextInput(
          value: _value,
          onChanged: (String value) {
            setState(() {
              _value = value;
            });
          },
        ),
      ],
    ),
    actions: <Widget>[
      Button.ghost(onPressed: widget.onCancel, label: 'Cancel'),
      Button.destructive(
        onPressed: _value == widget.confirmPhrase
            ? () => widget.onConfirm?.call(_value)
            : null,
        label: 'Confirm',
      ),
    ],
  );
}
