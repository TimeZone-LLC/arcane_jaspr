import 'package:arcane_jaspr/flutter.dart';

import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/theme_provider.dart';
import 'package:arcane_jaspr/util/style_types/arcane_style_data.dart';

export 'package:arcane_jaspr/core/props/otp_input_props.dart'
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
    final String value = (widget.value ?? '').replaceAll(RegExp(r'[^0-9]'), '');
    _digits = List<String>.generate(
      widget.length,
      (int index) => index < value.length ? value[index] : '',
    );
  }

  @override
  void didUpdateWidget(covariant ArcaneOtpInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.length != oldWidget.length ||
        (widget.value != oldWidget.value && widget.value != _fullValue)) {
      _initDigits();
    }
  }

  String get _fullValue => _digits.join();

  void _handleInput(int index, String value) {
    if (widget.disabled) return;

    final String digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    final List<String> next = List<String>.of(_digits);
    if (digits.length > 1) {
      final int start = digits.length >= widget.length ? 0 : index;
      for (int i = start; i < widget.length; i++) {
        next[i] = i - start < digits.length ? digits[i - start] : '';
      }
    } else {
      next[index] = digits;
    }
    if (_digits.asMap().entries.every(
      (MapEntry<int, String> entry) => next[entry.key] == entry.value,
    )) {
      return;
    }
    setState(() => _digits = next);
    widget.onChanged?.call(_fullValue);
    if (_digits.every((String digit) => digit.isNotEmpty)) {
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
