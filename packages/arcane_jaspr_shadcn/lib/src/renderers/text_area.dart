import 'package:arcane_jaspr/core/rendering/base/text_area_render_base.dart';

/// ShadCN v4 textarea renderer.
///
/// Reference: https://ui.shadcn.com/docs/components/textarea
///
/// `min-h-16 rounded-md border border-input bg-transparent px-3 py-2
/// text-base md:text-sm shadow-xs dark:bg-input/30`, with the 3:1
/// `--shadcn-control-border` in place of bare `border-input`.
class ShadcnTextArea extends TextAreaRenderBase {
  const ShadcnTextArea(super.props, {super.key});

  @override
  String get classPrefix => 'arcane';

  @override
  String get wrapperGap => 'var(--space-2)';

  @override
  Map<String, String> labelStyles() => const <String, String>{
    'font-size': '0.875rem',
    'font-weight': '500',
    'line-height': '1',
    'color': 'var(--foreground)',
  };

  @override
  Map<String, String> textAreaStyles({
    required bool hasError,
    required bool isDisabled,
    required bool isReadOnly,
  }) => <String, String>{
    'min-height': '4rem',
    'padding': '0.5rem 0.75rem',
    'font-size': '0.875rem',
    'font-family': 'inherit',
    'line-height': '1.5',
    'background-color': isReadOnly
        ? 'var(--muted)'
        : 'var(--shadcn-input-background, transparent)',
    'border': hasError
        ? '1px solid var(--shadcn-control-border-color, var(--destructive))'
        : '1px solid var(--shadcn-control-border-color, var(--shadcn-control-border))',
    'border-radius': 'var(--radius-md)',
    'box-shadow': 'var(--shadcn-control-shadow, var(--shadow-xs))',
    'color': isReadOnly ? 'var(--muted-foreground)' : 'var(--foreground)',
    'caret-color': isReadOnly ? 'var(--muted-foreground)' : 'var(--foreground)',
    'outline': 'none',
    'transition':
        'color var(--transition), background-color var(--transition), '
        'border-color var(--transition), box-shadow var(--transition)',
  };
}
