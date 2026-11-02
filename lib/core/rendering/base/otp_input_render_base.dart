import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/dom_value.dart';
import 'package:arcane_jaspr/core/props/otp_input_props.dart';

/// Shared structural base for themed OTP input renderers.
///
/// Every theme's OTP input has the identical skeleton: a column wrapper, an
/// optional label, a row of single-character digit inputs (with optional
/// separator), and an optional error message. This base factors that skeleton
/// — including the digit loop, the separator placement and the shared input
/// element/type/event wiring — into one place. A concrete theme renderer only
/// supplies the value-producing members below: the root/digit CSS classes, the
/// idle `data-state`, the per-size dimensions, and the various style maps.
///
/// The digit `attributes` map deliberately remains theme-supplied because its
/// key ORDER differs between themes; returning it per theme preserves the exact
/// rendered HTML byte-for-byte.
///
/// This base lives in core and depends only on core props; it must never depend
/// on a theme package.
abstract class OtpInputRenderBase extends StatelessComponent {
  const OtpInputRenderBase(this.props, {super.key});

  final OtpInputProps props;

  /// CSS class applied to the root wrapper (e.g. `'arcane-otp-input'`).
  String get rootClass;

  /// `data-state` value used when there is no error (e.g. `'default'`/`'idle'`).
  String get idleState;

  /// Extra root attributes merged after `data-state`/`data-disabled`
  /// (e.g. `data-size`); return an empty map for none.
  Map<String, String> get extraRootAttrs;

  /// Inline styles for the root wrapper.
  Map<String, String> get rootStyles;

  /// Inline styles for the label text span.
  Map<String, String> get labelStyles;

  /// CSS class applied to the digits row (e.g. `'arcane-otp-digits'`).
  String get digitsRowClass;

  /// Inline styles for the digits row.
  Map<String, String> get digitsRowStyles;

  /// Inline styles for the separator span.
  Map<String, String> get separatorStyles;

  /// Leading CSS class for each digit input (e.g. `'arcane-otp-digit'`).
  String get digitClass;

  /// Per-size `(width/height, font-size)` dimensions for a digit input.
  (String, String) sizeStyles(OtpInputSizeVariant size);

  /// Theme-ordered `attributes` map for the digit input at [i]. Kept abstract
  /// because the key order is theme-specific and must be preserved exactly.
  Map<String, String> digitAttributes(
    int i,
    bool hasError,
    List<String> digits,
  );

  /// Inline styles for the digit input at [i].
  Map<String, String> digitStyles(
    int i,
    bool hasError,
    List<String> digits,
    String size,
    String fontSize,
  );

  /// Per-instance decoration overrides. Default: none. A theme overrides this
  /// to translate an [ArcaneDecoration] (elevation intent, theme-specific
  /// fields) into its own CSS. Fields a theme does not implement are ignored.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  /// Whether the digit slot at [i] currently holds a value.
  bool isFilled(int i, List<String> digits) =>
      digits.length > i && digits[i].isNotEmpty;

  /// The current value for the digit slot at [i] (empty when none).
  String digitValue(int i, List<String> digits) =>
      digits.length > i ? digits[i] : '';

  @override
  Component build(BuildContext context) {
    final bool hasError = props.error != null;
    final (String size, String fontSize) = sizeStyles(props.size);
    final int? sepPos = props.separatorPosition;
    final List<String> digits = props.digits.isEmpty
        ? List<String>.filled(props.length, '')
        : props.digits;

    return dom.div(
      classes: rootClass,
      attributes: <String, String>{
        'data-arcane-otp': 'true',
        'data-state': hasError ? 'error' : idleState,
        'data-disabled': '${props.disabled}',
        ...extraRootAttrs,
      },
      styles: dom.Styles(raw: rootStyles),
      <Component>[
        if (props.label != null)
          dom.span(styles: dom.Styles(raw: labelStyles), <Component>[
            Component.text(props.label!),
          ]),

        // Digit inputs row
        dom.div(
          classes: digitsRowClass,
          styles: dom.Styles(raw: digitsRowStyles),
          <Component>[
            for (int i = 0; i < props.length; i++) ...<Component>[
              // Separator
              if (sepPos != null && i == sepPos && props.separator != null)
                dom.span(styles: dom.Styles(raw: separatorStyles), <Component>[
                  Component.text(props.separator!),
                ]),

              // Digit input
              dom.input(
                classes:
                    '$digitClass ${hasError ? 'error' : ''} ${isFilled(i, digits) ? 'filled' : ''}',
                type: props.obscure
                    ? dom.InputType.password
                    : dom.InputType.text,
                attributes: digitAttributes(i, hasError, digits),
                styles: dom.Styles(
                  raw: <String, String>{
                    ...digitStyles(i, hasError, digits, size, fontSize),
                    ...?props.decoration?.universalStyles(),
                    ...decorationStyles(props.decoration),
                    ...?props.styles?.toMap(),
                  },
                ),
                events: props.onInput != null
                    ? <String, EventCallback>{
                        'input': (e) {
                          if (!domEventIsComposing(e)) {
                            props.onInput!(i, domOtpInputValue(e));
                          }
                        },
                      }
                    : null,
              ),
            ],
          ],
        ),

        // Error message
        if (hasError)
          dom.span(
            styles: const dom.Styles(
              raw: <String, String>{
                'font-size': 'var(--font-size-sm)',
                'color': 'var(--destructive)',
              },
            ),
            <Component>[Component.text(props.error!)],
          ),
      ],
    );
  }
}
