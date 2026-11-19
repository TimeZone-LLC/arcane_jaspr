import 'package:arcane_jaspr/core/props/otp_input_props.dart';
import 'package:arcane_jaspr/core/rendering/base/otp_input_render_base.dart';

/// Neubrutalism OTP input component.
class NeubrutalismOtpInput extends OtpInputRenderBase {
  const NeubrutalismOtpInput(super.props, {super.key});

  @override
  String get rootClass => 'neubrutalism-otp-input';

  @override
  String get idleState => 'idle';

  @override
  Map<String, String> get extraRootAttrs => <String, String>{
    'data-size': props.size.name,
  };

  @override
  Map<String, String> get rootStyles => const <String, String>{
    'display': 'flex',
    'flex-direction': 'column',
    'min-width': '0',
    'gap': '10px',
    'max-width': '100%',
  };

  @override
  Map<String, String> get labelStyles => const <String, String>{
    'font-family': 'var(--font-heading)',
    'font-size': '0.75rem',
    'font-weight': '600',
    'letter-spacing': '0.08em',
    'text-transform': 'uppercase',
    'color': 'var(--muted-foreground)',
  };

  @override
  String get digitsRowClass => 'neubrutalism-otp-digits';

  @override
  Map<String, String> get digitsRowStyles => const <String, String>{
    'display': 'flex',
    'align-items': 'center',
    'gap': 'clamp(4px, 1vw, 10px)',
    'max-width': '100%',
  };

  @override
  Map<String, String> get separatorStyles => const <String, String>{
    'color': 'var(--muted-foreground)',
    'font-size': 'var(--font-size-lg)',
    'font-weight': '700',
    'margin': '0 4px',
  };

  @override
  String get digitClass => 'neubrutalism-otp-digit';

  @override
  (String, String) sizeStyles(OtpInputSizeVariant size) => switch (size) {
    OtpInputSizeVariant.sm => ('44px', '1rem'),
    OtpInputSizeVariant.md => ('52px', '1.125rem'),
    OtpInputSizeVariant.lg => ('60px', '1.25rem'),
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
    'data-state': isFilled(i, digits) ? 'filled' : 'empty',
    'data-disabled': '${props.disabled}',
    if (props.disabled) 'disabled': 'true',
    'value': digitValue(i, digits),
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
    'min-width': '0',
    'flex': '0 1 $size',
    'padding': '0',
    'font-family': 'var(--font-heading)',
    'font-size': fontSize,
    'text-align': 'center',
    'font-weight': '700',
    'font-variant-numeric': 'tabular-nums',
    'color': 'var(--nb-ink, var(--foreground))',
    'background': isFilled(i, digits)
        ? 'var(--nb-accent, var(--primary))'
        : 'var(--nb-paper, var(--card))',
    'border':
        'var(--nb-border-thick, 3px) solid ${hasError ? 'var(--destructive)' : 'var(--nb-line, #000)'}',
    'transition':
        'transform var(--nb-transition, 120ms ease), box-shadow var(--nb-transition, 120ms ease), background var(--nb-transition, 120ms ease)',
    'caret-color': 'currentColor',
    'box-shadow': isFilled(i, digits)
        ? 'var(--nb-shadow-sm, 3px 3px 0 0 var(--nb-shadow-color, #000))'
        : 'var(--nb-shadow-md, 5px 5px 0 0 var(--nb-shadow-color, #000))',
    'transform': isFilled(i, digits)
        ? 'translate(2px, 2px)'
        : 'translate(0, 0)',
    'outline': 'none',
    if (props.disabled) 'opacity': '0.5',
    if (props.disabled) 'cursor': 'not-allowed',
  };
}
