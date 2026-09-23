import 'package:arcane_jaspr/core/rendering/base/floating_render_base.dart';

/// ShadCN Floating renderer.
///
/// Unified component for tooltip, popover, and hovercard patterns. Plain-text
/// tooltips follow the v4 Tooltip (`bg-primary text-primary-foreground
/// px-3 py-1.5 text-xs rounded-md text-balance`, no border or shadow); rich
/// content keeps the v4 Popover surface (`bg-popover border p-4 shadow-md`).
///
/// Reference: https://ui.shadcn.com/docs/components/tooltip
/// Reference: https://ui.shadcn.com/docs/components/popover
/// Reference: https://ui.shadcn.com/docs/components/hover-card
class ShadcnFloating extends FloatingRenderBase {
  const ShadcnFloating(super.props, {super.key});

  @override
  String get containerClass => 'arcane-floating-container';

  @override
  String floatingContentClasses(bool hasRichContent) => hasRichContent
      ? 'arcane-floating-content arcane-floating-popover'
      : 'arcane-floating-content arcane-floating-tooltip';

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
    'outline': 'none',
    if (hasRichContent) ...<String, String>{
      if (maxWidth != null) 'max-width': '${maxWidth}px',
      'min-width': '180px',
      'background-color': 'var(--popover)',
      'color': 'var(--popover-foreground)',
      'border': '1px solid var(--border)',
      'border-radius': 'var(--radius-md)',
      'box-shadow': 'var(--shadcn-surface-shadow)',
      'padding': '1rem',
      '--shadcn-floating-fill': 'var(--popover)',
      '--shadcn-floating-edge': 'var(--border)',
    } else ...<String, String>{
      'width': 'max-content',
      'max-width': maxWidth != null ? 'min(${maxWidth}px, 20rem)' : '20rem',
      'background-color': 'var(--primary)',
      'color': 'var(--primary-foreground)',
      'border': '0',
      'border-radius': 'var(--radius-sm)',
      'box-shadow': 'none',
      'padding': '0.375rem 0.75rem',
      'font-size': '0.75rem',
      'line-height': '1rem',
      'text-wrap': 'balance',
      '--shadcn-floating-fill': 'var(--primary)',
      '--shadcn-floating-edge': 'transparent',
    },
  };

  @override
  String get arrowClass => 'arcane-floating-arrow';

  /// The arrow is a rotated square with a complete frame; `clip-path` keeps
  /// only its outward triangle, so the frame reads as the two outer edges
  /// without a one-sided border. Fill and edge come from the surface.
  @override
  Map<String, String> arrowStyles(Map<String, String> arrowPositionStyles) =>
      <String, String>{
        'position': 'absolute',
        'width': '12px',
        'height': '12px',
        'background-color': 'var(--shadcn-floating-fill, var(--popover))',
        'border': '1px solid var(--shadcn-floating-edge, var(--border))',
        'border-radius': '2px',
        'clip-path': 'polygon(0 0, 100% 0, 0 100%)',
        ...arrowPositionStyles,
      };

  static int _autoCounter = 0;

  @override
  String generateAutoId() {
    _autoCounter++;
    return 'arcane-floating-$_autoCounter';
  }
}
