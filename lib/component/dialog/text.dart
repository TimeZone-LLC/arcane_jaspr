import 'package:arcane_jaspr/component/dialog/dialog.dart';
import 'package:arcane_jaspr/component/input/button.dart';
import 'package:arcane_jaspr/component/input/text_input.dart';
import 'package:arcane_jaspr/component/layout/flow.dart';
import 'package:arcane_jaspr/flutter.dart';
import 'package:arcane_jaspr/component/typography/text.dart';
import 'package:arcane_jaspr/util/arcane.dart';

class DialogText extends StatefulWidget {
  final String title;
  final String? description;
  final Widget descriptionWidget;
  final String confirmText;
  final String cancelText;
  final Widget? placeholder;
  final bool obscureText;
  final String? initialValue;
  final void Function(String result) onConfirm;
  final List<Widget>? actions;
  final int maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType keyboardType;

  const DialogText({
    required this.title,
    required this.onConfirm,
    this.description,
    this.descriptionWidget = const SizedBox.shrink(),
    this.confirmText = 'Done',
    this.cancelText = 'Cancel',
    this.placeholder,
    this.obscureText = false,
    this.initialValue,
    this.actions,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType = TextInputType.text,
    super.key,
  });

  @override
  State<DialogText> createState() => _DialogTextState();
}

class _DialogTextState extends State<DialogText> {
  late String _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final Widget input = widget.maxLines > 1
        ? TextArea(
            value: _value,
            rows: widget.maxLines,
            onChanged: (String value) {
              _value = value;
            },
          )
        : TextInput(
            value: _value,
            type: widget.keyboardType,
            onChanged: (String value) {
              _value = value;
            },
          );

    return ArcaneDialog(
      title: widget.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: <Widget>[
          if (widget.description != null) Text.body(widget.description!),
          if (widget.descriptionWidget is! SizedBox) widget.descriptionWidget,
          input,
        ],
      ),
      actions: <Widget>[
        Button.ghost(onPressed: () {}, label: widget.cancelText),
        Button.primary(
          onPressed: () => widget.onConfirm(_value),
          label: widget.confirmText,
        ),
        ...?widget.actions,
      ],
    );
  }
}
