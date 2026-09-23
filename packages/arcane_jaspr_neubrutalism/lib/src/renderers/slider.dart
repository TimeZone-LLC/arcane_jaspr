import 'package:arcane_jaspr/core/props/slider_props.dart';
import 'package:arcane_jaspr/core/rendering/base/slider_render_base.dart';

/// Neubrutalism slider renderer with restrained accent treatment.
class NeubrutalismSlider extends SliderRenderBase {
  const NeubrutalismSlider(super.props, {super.key});

  String get _tone => switch (props.variant) {
    SliderVariant.primary => 'var(--nb-accent, var(--primary))',
    SliderVariant.success => 'var(--success)',
    SliderVariant.warning => 'var(--warning)',
    SliderVariant.error => 'var(--destructive)',
  };

  @override
  String get classPrefix => 'neubrutalism-slider';

  @override
  String get labelRowMarginBottom => '0.75rem';

  @override
  String get minMaxRowMarginTop => '0.4rem';

  @override
  int get maxStepMarkers => 24;

  @override
  Map<String, String> extraRootAttrs() => <String, String>{
    'data-state': props.disabled ? 'disabled' : 'enabled',
    'data-disabled': '${props.disabled}',
    'data-variant': props.variant.name,
    'data-size': props.size.name,
  };

  @override
  Map<String, String> thumbStateAttrs() => <String, String>{
    'data-state': props.disabled ? 'disabled' : 'active',
  };

  @override
  (String, String, String) sizeMetrics(ComponentSize size) => switch (size) {
    ComponentSize.sm => ('8px', '18px', '32px'),
    ComponentSize.md => ('10px', '20px', '36px'),
    ComponentSize.lg => ('12px', '24px', '40px'),
  };

  @override
  Map<String, String> labelTextStyles() => const <String, String>{
    'font-family': 'var(--font-heading)',
    'font-size': '0.75rem',
    'font-weight': '600',
    'letter-spacing': '0.08em',
    'text-transform': 'uppercase',
    'color': 'var(--muted-foreground)',
  };

  @override
  Map<String, String> valueTextStyles() => const <String, String>{
    'font-size': 'var(--font-size-sm)',
    'font-weight': 'var(--font-weight-semibold)',
    'font-variant-numeric': 'tabular-nums',
    'color': 'var(--nb-accent, var(--primary))',
    'min-width': '52px',
    'text-align': 'right',
  };

  @override
  Map<String, String> trackStyles(String trackHeight) => <String, String>{
    'position': 'absolute',
    'left': '0',
    'right': '0',
    'height': trackHeight,
    'background': 'var(--nb-paper, var(--card))',
    'border': 'var(--nb-border-base, 3px) solid var(--nb-line, #000)',
    'border-radius': 'var(--nb-radius-soft, 4px)',
    'overflow': 'hidden',
    'box-shadow':
        'var(--nb-shadow-xs, 2px 2px 0 0 var(--nb-shadow-color, #000))',
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
        'background': _tone,
        'border-right': 'var(--nb-border-thin, 2px) solid var(--nb-line, #000)',
        'transition': 'width 0.1s ease-out',
      };
    }
    return <String, String>{
      'position': 'absolute',
      'left': '$loPct%',
      'right': '${100 - hiPct}%',
      'top': '0',
      'height': '100%',
      'background': _tone,
      'transition': 'left 0.1s ease-out, right 0.1s ease-out',
    };
  }

  @override
  Map<String, String> stepMarkerStyles() => const <String, String>{
    'width': '4px',
    'height': '4px',
    'background': 'var(--nb-line, #000)',
  };

  @override
  Map<String, String> thumbStyles({
    required double leftPct,
    required String thumbSize,
    required int thumbSizeNum,
  }) => <String, String>{
    'position': 'absolute',
    // A bare percentage plus a centring transform keeps the thumb on the
    // value after the runtime writes `left: x%` during a drag.
    'left': '$leftPct%',
    'top': '50%',
    'transform': 'translate(-50%, -50%)',
    'width': thumbSize,
    'height': thumbSize,
    'background': 'var(--nb-accent, var(--primary))',
    'border': 'var(--nb-border-thick, 3px) solid var(--nb-line, #000)',
    'border-radius': '0',
    'box-shadow':
        'var(--nb-shadow-sm, 3px 3px 0 0 var(--nb-shadow-color, #000))',
    'transition': 'left 0.1s ease-out',
    'cursor': props.disabled ? 'not-allowed' : 'grab',
    'z-index': '2',
  };

  @override
  Map<String, String> minMaxLabelStyles() => const <String, String>{
    'font-size': 'var(--font-size-sm)',
    'font-variant-numeric': 'tabular-nums',
    'color': 'var(--muted-foreground)',
  };
}
