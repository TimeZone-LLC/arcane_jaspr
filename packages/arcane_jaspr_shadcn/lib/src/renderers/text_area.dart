import 'package:arcane_jaspr/core/rendering/base/text_area_render_base.dart';

/// ShadCN text area renderer.
class ShadcnTextArea extends TextAreaRenderBase {
  const ShadcnTextArea(super.props, {super.key});

  @override
  String get classPrefix => 'arcane';

  @override
  String get wrapperGap => 'var(--space-2)';

  @override
  Map<String, String> textAreaStyles({
    required bool hasError,
    required bool isDisabled,
    required bool isReadOnly,
  }) => <String, String>{
    'padding': '0.5rem 1rem',
    'font-size': '1rem',
    'font-family': 'inherit',
    'line-height': '1.625',
    'background-color': isReadOnly ? 'var(--muted)' : 'var(--background)',
    'border': hasError
        ? '1px solid var(--destructive)'
        : '1px solid var(--shadcn-control-border)',
    'border-radius': '0.375rem',
    'color': isReadOnly ? 'var(--muted-foreground)' : 'var(--foreground)',
    'caret-color': isReadOnly ? 'var(--muted-foreground)' : 'var(--foreground)',
    'outline': 'none',
    'transition':
        'color var(--transition), background-color var(--transition), '
        'border-color var(--transition), box-shadow var(--transition)',
  };
}
