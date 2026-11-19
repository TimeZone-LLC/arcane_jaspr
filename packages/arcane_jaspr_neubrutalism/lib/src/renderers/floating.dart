import 'package:arcane_jaspr/core/rendering/base/floating_render_base.dart';

/// Neubrutalism Floating renderer.
///
/// Unified component for tooltip, popover, and hovercard patterns.
/// Implements the Neubrutalism design language with neutral structural depth.
class NeubrutalismFloating extends FloatingRenderBase {
  const NeubrutalismFloating(super.props, {super.key});

  @override
  String get containerClass => 'neubrutalism-floating-container';

  @override
  String floatingContentClasses(bool hasRichContent) => hasRichContent
      ? 'neubrutalism-floating-content neubrutalism-popover'
      : 'neubrutalism-floating-content neubrutalism-tooltip';

  @override
  Map<String, String> floatingContentStyles({
    required String positionProp,
    required String positionValue,
    required Map<String, String> alignment,
    required bool hasRichContent,
    required double? maxWidth,
  }) => <String, String>{
    'position': 'absolute',
    positionProp: positionValue,
    ...alignment,
    'z-index': '50',
    'width': 'max-content',
    'max-width': maxWidth == null
        ? 'calc(100vw - 24px)'
        : 'min(${maxWidth}px, calc(100vw - 24px))',
    if (hasRichContent) 'min-width': 'min(220px, calc(100vw - 24px))',
    'padding': hasRichContent ? '14px 16px' : '6px 10px',
    'background': hasRichContent
        ? 'var(--nb-paper, var(--card))'
        : 'var(--nb-ink, #000)',
    'color': hasRichContent
        ? 'var(--nb-ink, var(--popover-foreground))'
        : 'var(--nb-paper, #fff)',
    'border': 'var(--nb-border-thick, 3px) solid var(--nb-line, #000)',
    'border-radius': 'var(--nb-radius-soft, 0)',
    'box-shadow': hasRichContent
        ? 'var(--nb-shadow-md, 5px 5px 0 0 var(--nb-shadow-color, #000))'
        : 'var(--nb-shadow-sm, 3px 3px 0 0 var(--nb-shadow-color, #000))',
    'outline': 'none',
  };

  @override
  String get arrowClass => 'neubrutalism-floating-arrow';

  @override
  Map<String, String> arrowStyles(Map<String, String> arrowPositionStyles) =>
      <String, String>{
        'position': 'absolute',
        'width': '10px',
        'height': '10px',
        'background': 'transparent',
        'border-left': 'var(--nb-border-thin, 2px) solid var(--nb-line, #000)',
        'border-top': 'var(--nb-border-thin, 2px) solid var(--nb-line, #000)',
        ...arrowPositionStyles,
      };

  static int _autoCounter = 0;

  @override
  String generateAutoId() {
    _autoCounter++;
    return 'neubrutalism-floating-$_autoCounter';
  }
}
