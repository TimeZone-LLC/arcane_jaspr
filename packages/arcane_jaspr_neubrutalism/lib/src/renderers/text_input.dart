import 'package:arcane_jaspr/core/props/text_input_props.dart';
import 'package:arcane_jaspr/core/rendering/base/text_input_render_base.dart';

class NeubrutalismTextInput extends TextInputRenderBase {
  const NeubrutalismTextInput(super.props, {super.key});

  static const String _surface = 'var(--nb-control-paper, var(--card))';

  @override
  String get classPrefix => 'neubrutalism';

  @override
  String get wrapperGap => '0.625rem';

  @override
  bool get borderlessInputReflectsState => false;

  @override
  (String, String, String, String) sizeValues(ComponentSize size) =>
      switch (size) {
        ComponentSize.sm => ('38px', '0.875rem', '0.5rem', '0.8125rem'),
        ComponentSize.md => ('46px', '1rem', '0.675rem', '0.875rem'),
        ComponentSize.lg => ('54px', '1.125rem', '0.875rem', '1rem'),
      };

  @override
  Map<String, String> inputStyles({
    required bool hasError,
    required bool isDisabled,
    required String height,
    required String paddingX,
    required String paddingY,
    required String fontSize,
  }) {
    final String borderColor = hasError
        ? 'var(--destructive)'
        : 'var(--nb-ink, #000)';
    return <String, String>{
      'display': 'flex',
      'height': height,
      'width': '100%',
      'border-radius': 'var(--nb-radius-soft, 4px)',
      'border': 'var(--nb-border-base, 3px) solid $borderColor',
      'background-color': _surface,
      'padding': '$paddingY $paddingX',
      'font-size': fontSize,
      'font-family': 'inherit',
      'line-height': '1.5',
      'color': 'var(--foreground)',
      'outline': 'none',
      'box-shadow':
          'var(--nb-shadow-xs, 2px 2px 0 0 var(--nb-shadow-color, #000))',
      if (isDisabled) 'cursor': 'not-allowed',
      if (isDisabled) 'opacity': '0.5',
      'transition':
          'transform 120ms cubic-bezier(0.2, 0.8, 0.2, 1), box-shadow 120ms cubic-bezier(0.2, 0.8, 0.2, 1)',
    };
  }

  @override
  Map<String, String> containerStyles(bool hasError) {
    final String borderColor = hasError
        ? 'var(--destructive)'
        : 'var(--nb-control-line, var(--nb-line, #000))';
    return <String, String>{
      'display': 'flex',
      'align-items': 'center',
      'border-radius': 'var(--nb-radius-soft, 4px)',
      'border': 'var(--nb-border-base, 3px) solid $borderColor',
      'background-color': _surface,
      'box-shadow':
          'var(--nb-shadow-sm, 3px 3px 0 0 var(--nb-shadow-color, #000))',
      'transition':
          'transform 120ms cubic-bezier(0.2, 0.8, 0.2, 1), box-shadow 120ms cubic-bezier(0.2, 0.8, 0.2, 1)',
    };
  }

  @override
  Map<String, String> borderlessInputStyles({
    required bool isDisabled,
    required String height,
    required String paddingX,
    required String paddingY,
    required String fontSize,
  }) => <String, String>{
    'flex': '1',
    'height': height,
    'border': 'none',
    'background-color': 'transparent',
    'padding': '$paddingY $paddingX',
    'font-size': fontSize,
    'font-family': 'inherit',
    'color': 'var(--foreground)',
    'outline': 'none',
    'box-shadow': 'none',
    if (isDisabled) 'cursor': 'not-allowed',
    if (isDisabled) 'opacity': '0.5',
  };

  @override
  Map<String, String> prefixStyles() => <String, String>{
    'display': 'flex',
    'align-items': 'center',
    'padding-left': '0.875rem',
    'color': 'var(--muted-foreground)',
  };

  @override
  Map<String, String> suffixStyles() => <String, String>{
    'display': 'flex',
    'align-items': 'center',
    'padding-right': '0.875rem',
    'color': 'var(--muted-foreground)',
  };
}
