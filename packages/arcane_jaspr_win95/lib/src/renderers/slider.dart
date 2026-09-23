import 'package:arcane_jaspr/core/props/slider_props.dart';
import 'package:arcane_jaspr/core/rendering/base/slider_render_base.dart';

/// Win95 slider renderer (neutralized skeleton).
class Win95Slider extends SliderRenderBase {
  const Win95Slider(super.props, {super.key});

  @override
  String get classPrefix => 'win95-slider';

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
  Map<String, String> trackStyles(String trackHeight) => const <String, String>{};

  @override
  Map<String, String> trackFillStyles({
    required bool isRange,
    required double percentage,
    required double loPct,
    required double hiPct,
  }) => const <String, String>{};

  @override
  Map<String, String> stepMarkerStyles() => const <String, String>{};

  @override
  Map<String, String> thumbStyles({
    required double leftPct,
    required String thumbSize,
    required int thumbSizeNum,
  }) => <String, String>{
    // Only the value position is inline; the theme CSS centres the bitmap on
    // it with a transform, and the runtime writes the same bare `left: x%`.
    'left': '$leftPct%',
  };

  @override
  Map<String, String> minMaxLabelStyles() => const <String, String>{};
}
