import 'package:arcane_jaspr/core/props/otp_input_props.dart';
import 'package:arcane_jaspr/core/rendering/base/otp_input_render_base.dart';

/// ShadCN-style OTP input component.
/// Reference: https://ui.shadcn.com/docs/components/input-otp
///
/// Slots follow the v4 input recipe (`h-9 w-9 border-input text-sm
/// shadow-xs rounded-md`) as separate boxes, since joined slots would need
/// one-sided borders on rounded corners.
class ShadcnOtpInput extends OtpInputRenderBase {
  const ShadcnOtpInput(super.props, {super.key});

  @override
  String get rootClass => 'arcane-otp-input';

  @override
  String get idleState => 'default';

  @override
  Map<String, String> get extraRootAttrs => const <String, String>{};

  @override
  Map<String, String> get rootStyles => const <String, String>{
    'display': 'flex',
    'flex-direction': 'column',
    'gap': 'var(--space-2)',
  };

  @override
  Map<String, String> get labelStyles => const <String, String>{
    'font-size': '0.875rem',
    'font-weight': '500',
    'line-height': '1',
    'color': 'var(--foreground)',
  };

  @override
  String get digitsRowClass => 'arcane-otp-digits';

  @override
  Map<String, String> get digitsRowStyles => const <String, String>{
    'display': 'flex',
    'align-items': 'center',
    'gap': 'var(--space-2)',
  };

  @override
  Map<String, String> get separatorStyles => const <String, String>{
    'color': 'var(--muted-foreground)',
    'font-size': '0.875rem',
    'margin': '0 0.25rem',
  };

  @override
  String get digitClass => 'arcane-otp-digit';

  @override
  (String, String) sizeStyles(OtpInputSizeVariant size) => switch (size) {
    OtpInputSizeVariant.sm => ('2rem', '0.875rem'),
    OtpInputSizeVariant.md => ('2.25rem', '0.875rem'),
    OtpInputSizeVariant.lg => ('2.5rem', '1rem'),
  };

  @override
  Map<String, String> digitAttributes(
    int i,
    bool hasError,
    List<String> digits,
  ) => <String, String>{
    'maxlength': '1',
    'inputmode': 'numeric',
    'pattern': '[0-9]*',
    'autocomplete': 'one-time-code',
    'aria-label': 'Digit ${i + 1} of ${props.length}',
    'data-otp-index': '$i',
    'data-otp-length': '${props.length}',
    if (props.disabled) 'disabled': 'true',
    'value': digitValue(i, digits),
    'data-state': isFilled(i, digits) ? 'filled' : 'empty',
    'data-disabled': '${props.disabled}',
    if (hasError) 'aria-invalid': 'true',
  };

  @override
  Map<String, String> digitStyles(
    int i,
    bool hasError,
    List<String> digits,
    String size,
    String fontSize,
  ) => <String, String>{
    'width': size,
    'height': size,
    'font-size': fontSize,
    'box-sizing': 'border-box',
    'padding': '0',
    'text-align': 'center',
    'font-weight': '500',
    'color': 'var(--foreground)',
    'background-color': 'var(--shadcn-input-background, transparent)',
    'border':
        '1px solid var(--shadcn-control-border-color, ${hasError ? 'var(--destructive)' : 'var(--shadcn-control-border)'})',
    'border-radius': 'var(--radius-md)',
    'box-shadow': 'var(--shadcn-control-shadow, var(--shadow-xs))',
    'outline': 'none',
    'transition':
        'border-color var(--transition), box-shadow var(--transition)',
    'caret-color': 'transparent',
    if (props.disabled) 'opacity': '0.5',
    if (props.disabled) 'cursor': 'not-allowed',
  };
}
