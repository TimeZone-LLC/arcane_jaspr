import 'package:arcane_jaspr/core/rendering/base/text_area_render_base.dart';

/// Neon text area renderer.
class NeonTextArea extends TextAreaRenderBase {
  const NeonTextArea(super.props, {super.key});

  @override
  String get classPrefix => 'neon';

  @override
  String get wrapperGap => '0.35rem';

  @override
  Map<String, String> textAreaStyles({
    required bool hasError,
    required bool isDisabled,
    required bool isReadOnly,
  }) => <String, String>{
    'padding': '0.5rem 0.75rem',
    'font-size': '1rem',
    'font-family': 'inherit',
    'line-height': '1.625',
    'background-color': isReadOnly ? 'var(--muted)' : 'var(--input)',
    'color': isReadOnly ? 'var(--muted-foreground)' : 'var(--foreground)',
    'caret-color': isReadOnly ? 'var(--muted-foreground)' : 'var(--foreground)',
    'border': hasError
        ? '1px solid var(--destructive)'
        : '1px solid var(--neon-control-border)',
    'border-radius': 'var(--radius-md)',
    'outline': 'none',
    'transition': 'border-color var(--transition)',
  };

  @override
  Map<String, String> errorStyles() => const <String, String>{
    'font-size': 'var(--font-size-xs)',
    'color': 'var(--destructive)',
  };

  @override
  Map<String, String> helperStyles() => const <String, String>{
    'font-size': 'var(--font-size-xs)',
    'color': 'var(--muted-foreground)',
  };
}
