import 'package:arcane_jaspr/core/props/kbd_props.dart';
import 'package:arcane_jaspr/core/rendering/base/kbd_render_base.dart';

/// ShadCN keyboard key.
///
/// ShadCN Kbd: bg-muted text-muted-foreground inline-flex h-5 min-w-5
/// items-center justify-center gap-1 rounded-sm px-1 font-sans text-xs
/// font-medium. ShadCN has no 3D key, so the default `raised` style and `flat`
/// both render that flat muted key; `outline` swaps the fill for a hairline.
///
/// Reference: https://ui.shadcn.com/docs/components/kbd
class ShadcnKbd extends KbdRenderBase {
  const ShadcnKbd(super.props, {super.key});

  @override
  String? get kbdClasses => null;

  @override
  String get keysWrapperGap => '0.25rem';

  // (height/min-width, horizontal padding, font-size)
  (String, String, String) get _sizeStyles => switch (props.size) {
    ComponentSize.sm => ('1rem', '0.1875rem', '0.625rem'),
    ComponentSize.md => ('1.25rem', '0.25rem', '0.75rem'),
    ComponentSize.lg => ('1.5rem', '0.375rem', '0.875rem'),
  };

  @override
  Map<String, String> get styleMap {
    final (String box, String inline, String fontSize) = _sizeStyles;

    final Map<String, String> base = <String, String>{
      'display': 'inline-flex',
      'align-items': 'center',
      'justify-content': 'center',
      'gap': '0.25rem',
      'width': 'fit-content',
      'height': box,
      'min-width': box,
      'padding': '0 $inline',
      'box-sizing': 'border-box',
      'border-radius': 'var(--radius-xs)',
      'font-family': 'var(--font-sans)',
      'font-size': fontSize,
      'font-weight': '500',
      'line-height': '1',
      'white-space': 'nowrap',
      'user-select': 'none',
      'pointer-events': 'none',
      'box-shadow': 'none',
    };

    return switch (props.variant) {
      KbdStyle.raised || KbdStyle.flat => <String, String>{
        ...base,
        'background': 'var(--muted)',
        'border': '0',
        'color': 'var(--muted-foreground)',
      },
      KbdStyle.outline => <String, String>{
        ...base,
        'background': 'transparent',
        'border': '1px solid var(--border)',
        'color': 'var(--muted-foreground)',
      },
    };
  }
}
