import 'package:arcane_jaspr/core/props/text_input_props.dart';
import 'package:arcane_jaspr/core/rendering/base/text_input_render_base.dart';

/// ShadCN Text Input renderer.
///
/// Outputs the exact HTML structure and CSS from ui.shadcn.com.
/// Reference: https://ui.shadcn.com/docs/components/input
///
/// ShadCN Input:
/// - flex h-10 w-full rounded-md border border-input bg-background
/// - px-3 py-2 text-base
/// - ring-offset-background
/// - file:border-0 file:bg-transparent file:text-sm file:font-medium file:text-foreground
/// - placeholder:text-muted-foreground
/// - focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2
/// - disabled:cursor-not-allowed disabled:opacity-50
/// - md:text-sm
class ShadcnTextInput extends TextInputRenderBase {
  const ShadcnTextInput(super.props, {super.key});

  @override
  String get classPrefix => 'arcane';

  @override
  String get wrapperGap => 'var(--space-2)'; // ShadCN: space-y-2

  @override
  bool get borderlessInputReflectsState => true;

  // ShadCN sizes: default h-10 (40px), px-3, py-2, text-base/md:text-sm
  @override
  (String, String, String, String) sizeValues(ComponentSize size) =>
      switch (size) {
        ComponentSize.sm => ('32px', '0.5rem', '0.25rem', '0.75rem'),
        ComponentSize.md => ('40px', '0.75rem', '0.5rem', '0.875rem'),
        ComponentSize.lg => ('48px', '1rem', '0.75rem', '1rem'),
      };

  // ShadCN: flex h-10 w-full rounded-md border border-input bg-background
  //         px-3 py-2 text-base ring-offset-background
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
    'border-radius': 'var(--radius-sm)',
    'border': hasError
        ? '1px solid var(--destructive)'
        : '1px solid var(--shadcn-control-border)',
    'background-color': 'var(--background)',
    'padding': '$paddingY $paddingX',
    'font-size': fontSize,
    'font-family': 'inherit',
    'line-height': '1.5',
    'color': 'var(--foreground)',
    'outline': 'none',
    if (isDisabled) 'cursor': 'not-allowed',
    if (isDisabled) 'opacity': '0.5',
    'transition':
        'border-color var(--transition), box-shadow var(--transition)',
  };

  @override
  Map<String, String> containerStyles(bool hasError) => <String, String>{
    'display': 'flex',
    'align-items': 'center',
    'border-radius': 'var(--radius-sm)',
    'border': hasError
        ? '1px solid var(--destructive)'
        : '1px solid var(--shadcn-control-border)',
    'background-color': 'var(--background)',
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
    'height': height,
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
