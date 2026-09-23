import 'package:arcane_jaspr/flutter.dart';

import '../../core/decoration/arcane_decoration.dart';
import '../../core/theme_provider.dart';
import '../../util/style_types/arcane_style_data.dart';

export '../../core/props/otp_input_props.dart'
    show OtpInputSizeVariant, OtpInputProps;

/// Size variants for OTP input.
enum OtpInputSize { sm, md, lg }

/// One-time password input with separate digit fields.
class ArcaneOtpInput extends StatefulWidget {
  final int length;
  final void Function(String)? onComplete;
  final void Function(String)? onChanged;
  final String? value;
  final bool obscure;
  final OtpInputSize size;
  final bool disabled;
  final String? error;
  final String? label;
  final String? separator;
  final int? separatorPosition;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation intent + theme-specific
  /// fields honored-or-ignored per theme).
  final ArcaneDecoration? decoration;

  const ArcaneOtpInput({
    this.length = 6,
    this.onComplete,
    this.onChanged,
    this.value,
    this.obscure = false,
    this.size = OtpInputSize.md,
    this.disabled = false,
    this.error,
    this.label,
    this.separator,
    this.separatorPosition,
    this.styles,
    this.decoration,
    super.key,
  });

  const ArcaneOtpInput.fourDigit({
    this.onComplete,
    this.onChanged,
    this.value,
    this.obscure = false,
    this.size = OtpInputSize.md,
    this.disabled = false,
    this.error,
    this.label,
    this.separator,
    this.separatorPosition,
    this.styles,
    this.decoration,
    super.key,
  }) : length = 4;

  const ArcaneOtpInput.sixDigit({
    this.onComplete,
    this.onChanged,
    this.value,
    this.obscure = false,
    this.size = OtpInputSize.md,
    this.disabled = false,
    this.error,
    this.label,
    this.separator,
    this.separatorPosition,
    this.styles,
    this.decoration,
    super.key,
  }) : length = 6;

  @override
  State<ArcaneOtpInput> createState() => _ArcaneOtpInputState();
}

class _ArcaneOtpInputState extends State<ArcaneOtpInput> {
  late List<String> _digits;

  @override
  void initState() {
    super.initState();
    _initDigits();
  }

  void _initDigits() {
    if (widget.value != null && widget.value!.length == widget.length) {
      _digits = widget.value!.split('');
    } else {
      _digits = List.filled(widget.length, '');
    }
  }

  String get _fullValue => _digits.join();

  void _handleInput(int index, String value) {
    if (widget.disabled) return;

    if (value.length > 1) {
      _handlePaste(value);
      return;
    }

    if (value.isNotEmpty && RegExp(r'[0-9]').hasMatch(value)) {
      setState(() {
        _digits[index] = value;
      });

      widget.onChanged?.call(_fullValue);

      if (_digits.every((d) => d.isNotEmpty)) {
        widget.onComplete?.call(_fullValue);
      }
    }
  }

  void _handlePaste(String pastedValue) {
    final digits = pastedValue.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return;

    setState(() {
      for (var i = 0; i < widget.length && i < digits.length; i++) {
        _digits[i] = digits[i];
      }
    });

    widget.onChanged?.call(_fullValue);

    if (_digits.every((d) => d.isNotEmpty)) {
      widget.onComplete?.call(_fullValue);
    }
  }

  OtpInputSizeVariant get _propsSize => switch (widget.size) {
    OtpInputSize.sm => OtpInputSizeVariant.sm,
    OtpInputSize.md => OtpInputSizeVariant.md,
    OtpInputSize.lg => OtpInputSizeVariant.lg,
  };

  @override
  Widget build(BuildContext context) {
    return context.renderers.otpInput(
      OtpInputProps(
        length: widget.length,
        digits: _digits,
        obscure: widget.obscure,
        size: _propsSize,
        disabled: widget.disabled,
        error: widget.error,
        label: widget.label,
        separator: widget.separator,
        separatorPosition: widget.separatorPosition,
        onInput: _handleInput,
        styles: widget.styles,
        decoration: widget.decoration,
      ),
    );
  }
}
