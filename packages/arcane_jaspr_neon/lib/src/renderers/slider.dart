import 'package:arcane_jaspr/core/props/slider_props.dart';
import 'package:arcane_jaspr/core/rendering/base/slider_render_base.dart';

/// Neon slider renderer (neutralized skeleton).
class NeonSlider extends SliderRenderBase {
  const NeonSlider(super.props, {super.key});

  @override
  String get classPrefix => 'neon-slider';

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
  Map<String, String> labelTextStyles() => const <String, String>{};

  @override
  Map<String, String> valueTextStyles() => const <String, String>{};

  @override
  Map<String, String> trackStyles(String trackHeight) => <String, String>{
    'position': 'relative',
    'width': '100%',
    'height': trackHeight,
    'border-radius': '9999px',
    'background': 'var(--muted)',
    'overflow': 'hidden',
  };

  @override
  Map<String, String> trackFillStyles({
    required bool isRange,
    required double percentage,
    required double loPct,
    required double hiPct,
  }) => <String, String>{
    'position': 'absolute',
    'top': '0',
    'bottom': '0',
    'left': isRange ? '$loPct%' : '0',
    'width': isRange ? '${hiPct - loPct}%' : '$percentage%',
    'background': 'var(--primary)',
  };

  @override
  Map<String, String> stepMarkerStyles() => const <String, String>{};

  @override
  Map<String, String> thumbStyles({
    required double leftPct,
    required String thumbSize,
    required int thumbSizeNum,
  }) => <String, String>{
    // Neon has no slider stylesheet rules, so the thumb carries its own
    // geometry: a bare percentage plus a centring transform keeps it on the
    // value after the runtime writes `left: x%` during a drag.
    'position': 'absolute',
    'left': '$leftPct%',
    'top': '50%',
    'transform': 'translate(-50%, -50%)',
    'width': thumbSize,
    'height': thumbSize,
    'border-radius': '50%',
    'background': 'var(--primary)',
    'cursor': props.disabled ? 'not-allowed' : 'grab',
    'z-index': '2',
  };

  @override
  Map<String, String> minMaxLabelStyles() => const <String, String>{};
}
