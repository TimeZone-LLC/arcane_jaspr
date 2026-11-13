import 'package:jaspr/jaspr.dart';

import '../../util/style_types/arcane_style_data.dart';
import '../decoration/arcane_decoration.dart';
import '../interaction/interaction.dart';
import '../shared/shared.dart';

export '../shared/shared.dart' show ComponentSize;

enum SliderVariant { primary, success, warning, error }

/// Slider component properties.
class SliderProps {
  final String? id;
  final double value;
  final double min;
  final double max;
  final double? step;
  final String? label;

  /// Names the thumb without drawing [label].
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

  /// Semantic, theme-interpreted decoration (elevation intent + theme-specific
  /// fields honored-or-ignored per theme).
  final ArcaneDecoration? decoration;

  const SliderProps({
    this.id,
    this.value = 0,
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
    this.isRange = false,
    this.rangeMin,
    this.rangeMax,
    this.onRangeChanged,
    this.onChangeAction,
    this.styles,
    this.decoration,
  });

  const SliderProps.range({
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
  }) : value = 0,
       onChanged = null,
       isRange = true,
       rangeMin = minValue,
       rangeMax = maxValue;

  SliderProps copyWith({
    String? id,
    double? value,
    double? min,
    double? max,
    double? step,
    String? label,
    String? ariaLabel,
    bool? showBounds,
    bool? showValue,
    String? valuePrefix,
    String? valueSuffix,
    int? valueDecimals,
    SliderVariant? variant,
    ComponentSize? size,
    bool? showSteps,
    bool? disabled,
    void Function(double)? onChanged,
    bool? isRange,
    double? rangeMin,
    double? rangeMax,
    void Function(double min, double max)? onRangeChanged,
    ArcaneInteraction? onChangeAction,
    ArcaneStyleData? styles,
    ArcaneDecoration? decoration,
  }) {
    return SliderProps(
      id: id ?? this.id,
      value: value ?? this.value,
      min: min ?? this.min,
      max: max ?? this.max,
      step: step ?? this.step,
      label: label ?? this.label,
      ariaLabel: ariaLabel ?? this.ariaLabel,
      showBounds: showBounds ?? this.showBounds,
      showValue: showValue ?? this.showValue,
      valuePrefix: valuePrefix ?? this.valuePrefix,
      valueSuffix: valueSuffix ?? this.valueSuffix,
      valueDecimals: valueDecimals ?? this.valueDecimals,
      variant: variant ?? this.variant,
      size: size ?? this.size,
      showSteps: showSteps ?? this.showSteps,
      disabled: disabled ?? this.disabled,
      onChanged: onChanged ?? this.onChanged,
      isRange: isRange ?? this.isRange,
      rangeMin: rangeMin ?? this.rangeMin,
      rangeMax: rangeMax ?? this.rangeMax,
      onRangeChanged: onRangeChanged ?? this.onRangeChanged,
      onChangeAction: onChangeAction ?? this.onChangeAction,
      styles: styles ?? this.styles,
      decoration: decoration ?? this.decoration,
    );
  }
}

// ============================================================================
// RENDERER CONTRACT
// ============================================================================

/// Mixin defining the renderer method for slider components.
mixin SliderRendererContract {
  /// Render a slider component.
  Component slider(SliderProps props);
}
