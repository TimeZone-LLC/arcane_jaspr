import 'package:arcane_jaspr/core/props/text_input_props.dart';
import 'package:arcane_jaspr/core/rendering/base/text_input_render_base.dart';

/// ShadCN v4 text input renderer.
///
/// Reference: https://ui.shadcn.com/docs/components/input
///
/// `h-9 w-full min-w-0 rounded-md border border-input bg-transparent px-3
/// py-1 text-base md:text-sm shadow-xs dark:bg-input/30
/// transition-[color,box-shadow]`. Focus and invalid states flip the
/// `--shadcn-control-*` variables the inline styles read. The resting border
/// is `--shadcn-control-border` (`--input` mixed toward the foreground to
/// 3:1) rather than bare `border-input`.
class ShadcnTextInput extends TextInputRenderBase {
  const ShadcnTextInput(super.props, {super.key});

  @override
  String get classPrefix => 'arcane';

  @override
  String get wrapperGap => 'var(--space-2)';

  @override
  bool get borderlessInputReflectsState => true;

  @override
  (String, String, String, String) sizeValues(ComponentSize size) =>
      switch (size) {
        ComponentSize.sm => ('2rem', '0.625rem', '0.25rem', '0.875rem'),
        ComponentSize.md => ('2.25rem', '0.75rem', '0.25rem', '0.875rem'),
        ComponentSize.lg => ('2.5rem', '0.75rem', '0.25rem', '0.875rem'),
      };

  static String _border(bool hasError) => hasError
      ? '1px solid var(--shadcn-control-border-color, var(--destructive))'
      : '1px solid var(--shadcn-control-border-color, var(--shadcn-control-border))';

  @override
  Map<String, String> inputStyles({
    required bool hasError,
    required bool isDisabled,
    required String height,
    required String paddingX,
    required String paddingY,
    required String fontSize,
  }) => <String, String>{
    'display': 'flex',
    'height': height,
    'width': '100%',
    'min-width': '0',
    'border-radius': 'var(--radius-md)',
    'border': _border(hasError),
    'background-color': 'var(--shadcn-input-background, transparent)',
    'box-shadow': 'var(--shadcn-control-shadow, var(--shadow-xs))',
    'padding': '$paddingY $paddingX',
    'font-size': fontSize,
    'font-family': 'inherit',
    'line-height': '1.5',
    'color': 'var(--foreground)',
    'outline': 'none',
    if (isDisabled) 'cursor': 'not-allowed',
    if (isDisabled) 'opacity': '0.5',
    'transition':
        'color var(--transition), border-color var(--transition), box-shadow var(--transition)',
  };

  @override
  Map<String, String> containerStyles(bool hasError) => <String, String>{
    'display': 'flex',
    'align-items': 'center',
    'min-width': '0',
    'border-radius': 'var(--radius-md)',
    'border': _border(hasError),
    'background-color': 'var(--shadcn-input-background, transparent)',
    'box-shadow': 'var(--shadcn-control-shadow, var(--shadow-xs))',
    'overflow': 'hidden',
    'transition':
        'border-color var(--transition), box-shadow var(--transition)',
  };

  // The shell owns the 1px perimeter, so the inner field is 2px shorter and
  // the composed control keeps the same outer height as a bare input.
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
    'height': 'calc($height - 2px)',
    'border': 'none',
    'background': 'transparent',
    'padding': '$paddingY $paddingX',
    'font-size': fontSize,
    'font-family': 'inherit',
    'color': 'var(--foreground)',
    'outline': 'none',
    if (isDisabled) 'cursor': 'not-allowed',
    if (isDisabled) 'opacity': '0.5',
  };

  @override
  Map<String, String> prefixStyles() => <String, String>{
    'display': 'flex',
    'align-items': 'center',
    'padding-left': '0.75rem',
    'color': 'var(--muted-foreground)',
  };

  @override
  Map<String, String> suffixStyles() => <String, String>{
    'display': 'flex',
    'align-items': 'center',
    'padding-right': '0.75rem',
    'color': 'var(--muted-foreground)',
  };
}
