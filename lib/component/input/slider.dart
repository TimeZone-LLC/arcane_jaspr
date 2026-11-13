import 'package:arcane_jaspr/flutter.dart';

import '../../core/interaction/interaction.dart';

export '../../core/props/slider_props.dart' show ComponentSize, SliderVariant;

import '../../core/decoration/arcane_decoration.dart';
import '../../core/theme_provider.dart';
import '../../util/style_types/arcane_style_data.dart';

/// Slider input component with single value or range mode.
class ArcaneSlider extends StatelessWidget {
  final String? id;
  final double value;
  final double min;
  final double max;
  final double? step;
  final String? label;

  /// Names the thumb for assistive technology without drawing [label].
  final String? ariaLabel;

  /// Draws the min and max under the track when there is no label or value.
  final bool showBounds;
  final bool showValue;
  final String? valuePrefix;
  final String? valueSuffix;
  final int valueDecimals;
  final SliderVariant variant;
  final ComponentSize size;
  final bool showSteps;
  final bool disabled;
  final void Function(double)? onChanged;
  final bool isRange;
  final double? rangeMin;
  final double? rangeMax;
  final void Function(double min, double max)? onRangeChanged;
  final ArcaneInteraction? onChangeAction;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation + theme-specific fields).
  final ArcaneDecoration? decoration;

  const ArcaneSlider({
    this.id,
    required this.value,
    this.min = 0,
    this.max = 100,
    this.step,
    this.label,
    this.ariaLabel,
    this.showBounds = true,
    this.showValue = true,
    this.valuePrefix,
    this.valueSuffix,
    this.valueDecimals = 0,
    this.variant = SliderVariant.primary,
    this.size = ComponentSize.md,
    this.showSteps = false,
    this.disabled = false,
    this.onChanged,
    this.onChangeAction,
    this.styles,
    this.decoration,
    super.key,
  }) : isRange = false,
       rangeMin = null,
       rangeMax = null,
       onRangeChanged = null;

  const ArcaneSlider.range({
    this.id,
    required double minValue,
    required double maxValue,
    this.min = 0,
    this.max = 100,
    this.step,
    this.label,
    this.ariaLabel,
    this.showBounds = true,
    this.showValue = true,
    this.valuePrefix,
    this.valueSuffix,
    this.valueDecimals = 0,
    this.variant = SliderVariant.primary,
    this.size = ComponentSize.md,
    this.showSteps = false,
    this.disabled = false,
    this.onRangeChanged,
    this.onChangeAction,
    this.styles,
    this.decoration,
    super.key,
  }) : value = 0,
       onChanged = null,
       isRange = true,
       rangeMin = minValue,
       rangeMax = maxValue;

  const ArcaneSlider.primary({
    this.id,
    required this.value,
    this.min = 0,
    this.max = 100,
    this.step,
    this.label,
    this.ariaLabel,
    this.showBounds = true,
    this.showValue = true,
    this.valuePrefix,
    this.valueSuffix,
    this.valueDecimals = 0,
    this.size = ComponentSize.md,
    this.showSteps = false,
    this.disabled = false,
    this.onChanged,
    this.onChangeAction,
    this.styles,
    this.decoration,
    super.key,
  }) : variant = SliderVariant.primary,
       isRange = false,
       rangeMin = null,
       rangeMax = null,
       onRangeChanged = null;

  const ArcaneSlider.success({
    this.id,
    required this.value,
    this.min = 0,
    this.max = 100,
    this.step,
    this.label,
    this.ariaLabel,
    this.showBounds = true,
    this.showValue = true,
    this.valuePrefix,
    this.valueSuffix,
    this.valueDecimals = 0,
    this.size = ComponentSize.md,
    this.showSteps = false,
    this.disabled = false,
    this.onChanged,
    this.onChangeAction,
    this.styles,
    this.decoration,
    super.key,
  }) : variant = SliderVariant.success,
       isRange = false,
       rangeMin = null,
       rangeMax = null,
       onRangeChanged = null;

  const ArcaneSlider.warning({
    this.id,
    required this.value,
    this.min = 0,
    this.max = 100,
    this.step,
    this.label,
    this.ariaLabel,
    this.showBounds = true,
    this.showValue = true,
    this.valuePrefix,
    this.valueSuffix,
    this.valueDecimals = 0,
    this.size = ComponentSize.md,
    this.showSteps = false,
    this.disabled = false,
    this.onChanged,
    this.onChangeAction,
    this.styles,
    this.decoration,
    super.key,
  }) : variant = SliderVariant.warning,
       isRange = false,
       rangeMin = null,
       rangeMax = null,
       onRangeChanged = null;

  const ArcaneSlider.error({
    this.id,
    required this.value,
    this.min = 0,
    this.max = 100,
    this.step,
    this.label,
    this.ariaLabel,
    this.showBounds = true,
    this.showValue = true,
    this.valuePrefix,
    this.valueSuffix,
    this.valueDecimals = 0,
    this.size = ComponentSize.md,
    this.showSteps = false,
    this.disabled = false,
    this.onChanged,
    this.onChangeAction,
    this.styles,
    this.decoration,
    super.key,
  }) : variant = SliderVariant.error,
       isRange = false,
       rangeMin = null,
       rangeMax = null,
       onRangeChanged = null;

  @override
  Widget build(BuildContext context) {
    return context.renderers.slider(
      SliderProps(
        id: id,
        value: value,
        min: min,
        max: max,
        step: step,
        label: label,
        ariaLabel: ariaLabel,
        showBounds: showBounds,
        showValue: showValue,
        valuePrefix: valuePrefix,
        valueSuffix: valueSuffix,
        valueDecimals: valueDecimals,
        variant: variant,
        size: size,
        showSteps: showSteps,
        disabled: disabled,
        onChanged: onChanged,
        isRange: isRange,
        rangeMin: rangeMin,
        rangeMax: rangeMax,
        onRangeChanged: onRangeChanged,
        onChangeAction: onChangeAction,
        styles: styles,
        decoration: decoration,
      ),
    );
  }
}

@Deprecated('Use ArcaneSlider.range instead.')
class ArcaneRangeSlider extends StatelessWidget {
  final double minValue;
  final double maxValue;
  final double min;
  final double max;
  final double? step;
  final String? label;
  final bool showValues;
  final SliderVariant variant;
  final ComponentSize size;
  final bool disabled;
  final void Function(double min, double max)? onChanged;

  const ArcaneRangeSlider({
    required this.minValue,
    required this.maxValue,
    this.min = 0,
    this.max = 100,
    this.step,
    this.label,
    this.showValues = true,
    this.variant = SliderVariant.primary,
    this.size = ComponentSize.md,
    this.disabled = false,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ArcaneSlider.range(
      minValue: minValue,
      maxValue: maxValue,
      min: min,
      max: max,
      step: step,
      label: label,
      showValue: showValues,
      variant: variant,
      size: size,
      disabled: disabled,
      onRangeChanged: onChanged,
    );
  }
}
