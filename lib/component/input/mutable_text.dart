import 'package:arcane_jaspr/component/input/icon_button.dart';
import 'package:arcane_jaspr/component/input/text_input.dart';
import 'package:arcane_jaspr/component/layout/flow.dart';
import 'package:arcane_jaspr/component/support/icons.dart';
import 'package:arcane_jaspr/flutter.dart';
import 'package:arcane_jaspr/component/typography/text.dart';
import 'package:arcane_jaspr/util/arcane.dart';
import 'package:arcane_jaspr/util/style_types/index.dart';

import 'mutable_text_types.dart';

class MutableText extends StatefulWidget {
  final String value;
  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function()? onEditingStarted;
  final int maxLines;
  final int? minLines;
  final String? placeholder;
  final MutableTextTrigger trigger;
  final MutableTextInputType inputType;
  final MutableTextStyle variant;

  const MutableText(
    this.value, {
    this.onChanged,
    this.onEditingComplete,
    this.onEditingStarted,
    this.maxLines = 1,
    this.minLines,
    this.placeholder,
    this.trigger = MutableTextTrigger.click,
    this.inputType = MutableTextInputType.text,
    this.variant = MutableTextStyle.inline,
    super.key,
  });

  @override
  State<MutableText> createState() => _MutableTextState();
}

class _MutableTextState extends State<MutableText> {
  bool _editing = false;
  late String _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant MutableText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_editing && widget.value != oldWidget.value) {
      _value = widget.value;
    }
  }

  void _startEditing() {
    if (widget.onChanged == null) {
      return;
    }
    setState(() {
      _editing = true;
      _value = widget.value;
    });
    widget.onEditingStarted?.call();
  }

  void _finishEditing() {
    setState(() {
      _editing = false;
    });
    widget.onEditingComplete?.call();
  }

  TextInputType get _textInputType => switch (widget.inputType) {
    MutableTextInputType.email => TextInputType.email,
    MutableTextInputType.number => TextInputType.number,
    MutableTextInputType.url => TextInputType.url,
    _ => TextInputType.text,
  };

  Widget get _displayText => switch (widget.variant) {
    MutableTextStyle.subtle => Text.bodySmall(widget.value),
    MutableTextStyle.underline => Text(
      widget.value,
      decoration: TextDecoration.underline,
    ),
    MutableTextStyle.dashed => Text(
      widget.value,
      decoration: TextDecoration.underline,
    ),
    MutableTextStyle.input => Text.body(widget.value),
    _ => Text(widget.value),
  };

  @override
  Widget build(BuildContext context) {
    if (_editing) {
      final Widget field =
          widget.maxLines > 1 ||
              widget.inputType == MutableTextInputType.multiline
          ? TextArea(
              value: _value,
              rows: widget.maxLines,
              placeholder: widget.placeholder,
              onChanged: (String value) {
                _value = value;
              },
            )
          : TextInput(
              value: _value,
              placeholder: widget.placeholder,
              type: _textInputType,
              onChanged: (String value) {
                _value = value;
              },
              onSubmitted: (String value) {
                widget.onChanged?.call(value);
                _finishEditing();
              },
            );

      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: <Widget>[
          Expanded(child: field),
          IconButton(
            icon: Icons.check(),
            onPressed: () {
              widget.onChanged?.call(_value);
              _finishEditing();
            },
          ),
          IconButton(icon: Icons.x(), onPressed: _finishEditing),
        ],
      );
    }

    if (widget.onChanged == null) {
      return _displayText;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 8,
      children: <Widget>[
        _displayText,
        IconButton(icon: Icons.pencil(), onPressed: _startEditing),
      ],
    );
  }
}
