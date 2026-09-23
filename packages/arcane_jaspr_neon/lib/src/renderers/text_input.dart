import 'package:arcane_jaspr/core/props/text_input_props.dart';
import 'package:arcane_jaspr/core/rendering/base/text_input_render_base.dart';

/// Neon text input with one perimeter around optional prefix and suffix slots.
class NeonTextInput extends TextInputRenderBase {
  const NeonTextInput(super.props, {super.key});

  @override
  String get classPrefix => 'neon';

  @override
  String get wrapperGap => '0.625rem';

  @override
  bool get borderlessInputReflectsState => true;

  @override
  (String, String, String, String) sizeValues(ComponentSize size) =>
      switch (size) {
        ComponentSize.sm => ('32px', '0.625rem', '0.375rem', '0.8125rem'),
        ComponentSize.md => ('40px', '0.75rem', '0.5rem', '0.875rem'),
        ComponentSize.lg => ('48px', '1rem', '0.75rem', '1rem'),
      };

  @override
  Map<String, String> inputStyles({
    required bool hasError,
    required bool isDisabled,
    required String height,
    required String paddingX,
    required String paddingY,
    required String fontSize,
  }) => <String, String>{
    'height': height,
    'min-height': height,
    'padding': '$paddingY $paddingX',
    'font-size': fontSize,
    if (isDisabled) 'opacity': '0.5',
    if (isDisabled) 'cursor': 'not-allowed',
  };

  @override
  Map<String, String> containerStyles(bool hasError) => <String, String>{
    'display': 'flex',
    'align-items': 'center',
    'min-width': '0',
    'border': hasError
        ? '1px solid var(--destructive)'
        : '1px solid var(--neon-control-border)',
    'border-radius': 'var(--radius-sm)',
    'background': 'var(--input)',
    'overflow': 'hidden',
  };

  @override
  Map<String, String> borderlessInputStyles({
    required bool isDisabled,
    required String height,
    required String paddingX,
    required String paddingY,
    required String fontSize,
  }) => <String, String>{
    'flex': '1',
    'min-width': '0',
    'height': height,
    'min-height': height,
    'padding': '$paddingY $paddingX',
    'font-size': fontSize,
    'background': 'transparent',
    'border': '0',
    if (isDisabled) 'opacity': '0.5',
    if (isDisabled) 'cursor': 'not-allowed',
  };

  @override
  Map<String, String> prefixStyles() => const <String, String>{
    'display': 'flex',
    'align-items': 'center',
    'padding-inline-start': '0.75rem',
    'color': 'var(--muted-foreground)',
  };

  @override
  Map<String, String> suffixStyles() => const <String, String>{
    'display': 'flex',
    'align-items': 'center',
    'padding-inline-end': '0.75rem',
    'color': 'var(--muted-foreground)',
  };
}
