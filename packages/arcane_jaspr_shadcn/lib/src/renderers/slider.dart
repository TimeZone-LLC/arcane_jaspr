import 'package:arcane_jaspr/core/props/slider_props.dart';
import 'package:arcane_jaspr/core/rendering/base/slider_render_base.dart';

/// ShadCN Slider renderer.
///
/// Outputs the exact HTML structure and CSS from ui.shadcn.com.
/// Reference: https://ui.shadcn.com/docs/components/slider
class ShadcnSlider extends SliderRenderBase {
  const ShadcnSlider(super.props, {super.key});

  String get _fillColor => switch (props.variant) {
    SliderVariant.primary => 'var(--primary)',
    SliderVariant.success => 'var(--success)',
    SliderVariant.warning => 'var(--warning)',
    SliderVariant.error => 'var(--destructive)',
  };

  @override
  String get classPrefix => 'arcane-slider';

  @override
  String get labelRowMarginBottom => '0.5rem';

  @override
  String get minMaxRowMarginTop => '0.25rem';

  @override
  int get maxStepMarkers => 20;

  @override
  Map<String, String> extraRootAttrs() => const <String, String>{};

  @override
  Map<String, String> thumbStateAttrs() => const <String, String>{};

  // (trackHeight, thumbSize, hitAreaHeight). ShadCN v4 default: h-1.5 track,
  // size-4 thumb.
  @override
  (String, String, String) sizeMetrics(ComponentSize size) => switch (size) {
    ComponentSize.sm => ('4px', '14px', '20px'),
    ComponentSize.md => ('6px', '16px', '24px'),
    ComponentSize.lg => ('8px', '20px', '32px'),
  };

  @override
  double percentFor(double current) =>
      ((current - props.min) / (props.max - props.min) * 100).clamp(0.0, 100.0);

  @override
  Map<String, String> labelTextStyles() => const <String, String>{
    'font-size': 'var(--font-size-sm)',
    'font-weight': 'var(--font-weight-medium)',
    'color': 'var(--foreground)',
  };

  @override
  Map<String, String> valueTextStyles() => const <String, String>{
    'font-size': 'var(--font-size-sm)',
    'font-weight': 'var(--font-weight-medium)',
    'font-variant-numeric': 'tabular-nums',
    'color': 'var(--muted-foreground)',
    'min-width': '40px',
    'text-align': 'right',
  };

  @override
  Map<String, String> trackStyles(String trackHeight) => <String, String>{
    'position': 'absolute',
    'left': '0',
    'right': '0',
    'height': trackHeight,
    'background-color': 'var(--muted)',
    'border-radius': 'var(--radius-md)',
    'overflow': 'hidden',
  };

  @override
  Map<String, String> trackFillStyles({
    required bool isRange,
    required double percentage,
    required double loPct,
    required double hiPct,
  }) {
    if (!isRange) {
      return <String, String>{
        'position': 'absolute',
        'left': '0',
        'top': '0',
        'width': '$percentage%',
        'height': '100%',
        'background-color': _fillColor,
        'transition': 'width 0.1s ease-out',
      };
    }
    return <String, String>{
      'position': 'absolute',
      'left': '$loPct%',
      'right': '${100 - hiPct}%',
      'top': '0',
      'height': '100%',
      'background-color': _fillColor,
      'transition': 'left 0.1s ease-out, right 0.1s ease-out',
    };
  }

  @override
  Map<String, String> stepMarkerStyles() => const <String, String>{
    'width': '2px',
    'height': '2px',
    'background': 'var(--muted-foreground)',
    'border-radius': '50%',
  };

  @override
  Map<String, String> thumbStyles({
    required double leftPct,
    required String thumbSize,
    required int thumbSizeNum,
  }) => <String, String>{
    // Centred with a transform so the runtime, which writes a bare `left: x%`
    // while dragging, keeps the thumb aligned with the value.
    'position': 'absolute',
    'left': '$leftPct%',
    'top': '50%',
    'transform': 'translate(-50%, -50%)',
    'width': thumbSize,
    'height': thumbSize,
    'box-sizing': 'border-box',
    'background-color': 'var(--background)',
    'border': '1px solid $_fillColor',
    'border-radius': '50%',
    'box-shadow': 'var(--shadcn-slider-thumb-shadow, var(--shadow-sm))',
    'transition': 'left 0.1s ease-out, box-shadow var(--transition)',
    'z-index': '2',
    'cursor': props.disabled ? 'not-allowed' : 'grab',
  };

  @override
  Map<String, String> minMaxLabelStyles() => const <String, String>{
    'font-size': 'var(--font-size-xs)',
    'color': 'var(--muted-foreground)',
  };
}
