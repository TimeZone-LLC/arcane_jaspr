import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/dom_value.dart';
import 'package:arcane_jaspr/core/rendering/base/style_layering.dart';
import 'package:arcane_jaspr/core/interaction/interaction.dart';
import 'package:arcane_jaspr/core/interaction/interaction_attrs.dart';
import 'package:arcane_jaspr/core/props/slider_props.dart';

/// Shared structural base for themed slider renderers.
///
/// Sliders share a sizable, error-prone tree: the root wrapper with its
/// `sliderAttrs` interaction wiring, the label/value row, the track container,
/// the track with its single fill node, optional step markers, one-to-two
/// thumbs (with identical `role`/`aria-*` wiring), and the fallback min/max
/// row. This base factors that structure plus the shared value/percentage math
/// and the thumb attribute/aria-label logic, leaving the genuinely
/// theme-specific values (class prefix, extra data attributes, size metrics and
/// every leaf style map) to abstract members the subclass supplies.
///
/// The fill percentage is computed via [percentFor]; the default guards a
/// zero-width range (Neon/Neubrutalism behaviour) while ShadCN overrides it to
/// omit the guard, so each theme's exact output is preserved.
///
/// This base lives in core and depends only on core props and interaction
/// helpers; it must never depend on a theme package.
abstract class SliderRenderBase extends StatelessComponent {
  const SliderRenderBase(this.props, {super.key});

  final SliderProps props;

  /// Prefix used for every CSS class (e.g. `'arcane-slider'`), driving the
  /// root, value span, track container, track, fill and thumb classes.
  String get classPrefix;

  /// `margin-bottom` of the label/value row container.
  String get labelRowMarginBottom;

  /// `margin-top` of the fallback min/max row container.
  String get minMaxRowMarginTop;

  /// Maximum number of step markers to render before bailing out.
  int get maxStepMarkers;

  /// Extra attributes merged after `sliderAttrs` on the root (empty for none).
  Map<String, String> extraRootAttrs();

  /// Extra attributes merged right after `data-arcane-slider-thumb` on each
  /// thumb (empty for none).
  Map<String, String> thumbStateAttrs();

  /// Resolves `(trackHeight, thumbSize, hitAreaHeight)` for the given size.
  (String, String, String) sizeMetrics(ComponentSize size);

  /// Inline styles for the label text span.
  Map<String, String> labelTextStyles();

  /// Inline styles for the value text span.
  Map<String, String> valueTextStyles();

  /// Inline styles for the track element.
  Map<String, String> trackStyles(String trackHeight);

  /// Inline styles for the single fill node; handles both the single-value and
  /// range branches internally.
  Map<String, String> trackFillStyles({
    required bool isRange,
    required double percentage,
    required double loPct,
    required double hiPct,
  });

  /// Inline styles for an individual step marker dot.
  Map<String, String> stepMarkerStyles();

  /// Inline styles for a thumb at the given left percentage.
  Map<String, String> thumbStyles({
    required double leftPct,
    required String thumbSize,
    required int thumbSizeNum,
  });

  /// Inline styles for a fallback min/max label span.
  Map<String, String> minMaxLabelStyles();

  /// Clamped fill percentage for [current]. Defaults to the guarded form used
  /// by Neon/Neubrutalism; ShadCN overrides to omit the zero-span guard.
  double percentFor(double current) {
    final double span = (props.max - props.min).abs();
    return span == 0
        ? 0
        : ((current - props.min) / (props.max - props.min) * 100).clamp(
            0.0,
            100.0,
          );
  }

  /// Per-instance decoration overrides. Default: none. A theme overrides this
  /// to translate an [ArcaneDecoration] (elevation intent, theme-specific
  /// fields) into its own CSS. Fields a theme does not implement are ignored.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  @override
  Component build(BuildContext context) {
    final String sliderId = props.id ?? 'slider-${identityHashCode(props)}';
    final double loValue = props.rangeMin ?? props.min;
    final double hiValue = props.rangeMax ?? props.max;
    final double singleValue = props.isRange ? loValue : props.value;

    final double percentage = percentFor(singleValue);
    final double loPct = percentFor(loValue);
    final double hiPct = percentFor(hiValue);

    final (String trackHeight, String thumbSize, String hitAreaHeight) =
        sizeMetrics(props.size);
    final int thumbSizeNum = int.parse(thumbSize.replaceAll('px', ''));

    final Map<String, String> rootAttrs = <String, String>{
      ...sliderAttrs(
        sliderId: sliderId,
        min: props.min,
        max: props.max,
        value: props.isRange ? null : props.value,
        lo: props.isRange ? loValue : null,
        hi: props.isRange ? hiValue : null,
        step: props.step,
        range: props.isRange,
        disabled: props.disabled,
        changeAction: props.onChangeAction == null
            ? null
            : encodeArcaneAction(props.onChangeAction!),
      ),
      ...extraRootAttrs(),
    };

    return dom.div(
      classes: '$classPrefix ${props.disabled ? 'disabled' : ''}',
      attributes: rootAttrs,
      events: _changeEvents(),
      styles: dom.Styles(
        raw: layerStyles(
          <String, String>{
            'width': '100%',
            'opacity': props.disabled ? '0.5' : '1',
            'pointer-events': props.disabled ? 'none' : 'auto',
          },
          <Map<String, String>?>[
            props.decoration?.universalStyles(),
            decorationStyles(props.decoration),
            props.styles?.toMap(),
          ],
        ),
      ),
      <Component>[
        if (props.label != null || props.showValue)
          dom.div(
            styles: dom.Styles(
              raw: <String, String>{
                'display': 'flex',
                'justify-content': 'space-between',
                'align-items': 'center',
                'margin-bottom': labelRowMarginBottom,
              },
            ),
            <Component>[
              if (props.label != null)
                dom.span(
                  styles: dom.Styles(raw: labelTextStyles()),
                  <Component>[Component.text(props.label!)],
                ),
              if (props.showValue)
                dom.span(
                  classes: '$classPrefix-value',
                  styles: dom.Styles(raw: valueTextStyles()),
                  <Component>[
                    Component.text(
                      '${props.valuePrefix ?? ''}${(props.isRange ? loValue : props.value).toStringAsFixed(props.valueDecimals)}${props.valueSuffix ?? ''}',
                    ),
                  ],
                ),
            ],
          ),
        dom.div(
          classes: '$classPrefix-track-container',
          attributes: const <String, String>{'data-arcane-slider-track': ''},
          styles: dom.Styles(
            raw: <String, String>{
              'position': 'relative',
              'width': '100%',
              'height': hitAreaHeight,
              'display': 'flex',
              'align-items': 'center',
              'cursor': 'pointer',
              'touch-action': 'none',
              'user-select': 'none',
            },
          ),
          <Component>[
            dom.div(
              classes: '$classPrefix-track',
              attributes: const <String, String>{
                'data-arcane-intrinsic-shape': 'slider-track',
              },
              styles: dom.Styles(raw: trackStyles(trackHeight)),
              <Component>[
                dom.div(
                  classes: '$classPrefix-track-fill',
                  attributes: const <String, String>{
                    'data-arcane-slider-fill': '',
                    'data-arcane-intrinsic-shape': 'slider-fill',
                  },
                  styles: dom.Styles(
                    raw: trackFillStyles(
                      isRange: props.isRange,
                      percentage: percentage,
                      loPct: loPct,
                      hiPct: hiPct,
                    ),
                  ),
                  const <Component>[],
                ),
              ],
            ),
            if (props.showSteps && props.step != null)
              _buildStepMarkers(trackHeight),
            if (!props.isRange)
              _buildThumb(
                kind: 'value',
                ariaValueNow: props.value,
                leftPct: percentage,
                thumbSize: thumbSize,
                thumbSizeNum: thumbSizeNum,
              )
            else ...<Component>[
              _buildThumb(
                kind: 'lo',
                ariaValueNow: loValue,
                leftPct: loPct,
                thumbSize: thumbSize,
                thumbSizeNum: thumbSizeNum,
              ),
              _buildThumb(
                kind: 'hi',
                ariaValueNow: hiValue,
                leftPct: hiPct,
                thumbSize: thumbSize,
                thumbSizeNum: thumbSizeNum,
              ),
            ],
          ],
        ),
        if (props.label == null && !props.showValue)
          dom.div(
            styles: dom.Styles(
              raw: <String, String>{
                'display': 'flex',
                'justify-content': 'space-between',
                'margin-top': minMaxRowMarginTop,
              },
            ),
            <Component>[
              dom.span(
                styles: dom.Styles(raw: minMaxLabelStyles()),
                <Component>[Component.text(props.min.toStringAsFixed(0))],
              ),
              dom.span(
                styles: dom.Styles(raw: minMaxLabelStyles()),
                <Component>[Component.text(props.max.toStringAsFixed(0))],
              ),
            ],
          ),
      ],
    );
  }

  Component _buildThumb({
    required String kind,
    required double ariaValueNow,
    required double leftPct,
    required String thumbSize,
    required int thumbSizeNum,
  }) {
    final Map<String, String> attrs = <String, String>{
      'data-arcane-slider-thumb': kind,
      'data-arcane-intrinsic-shape': 'slider-thumb',
      ...thumbStateAttrs(),
      'role': 'slider',
      'tabindex': props.disabled ? '-1' : '0',
      'aria-valuemin': props.min.toString(),
      'aria-valuemax': props.max.toString(),
      'aria-valuenow': ariaValueNow.toString(),
      ..._thumbAriaLabel(kind),
    };

    return dom.div(
      classes: '$classPrefix-thumb',
      attributes: attrs,
      styles: dom.Styles(
        raw: thumbStyles(
          leftPct: leftPct,
          thumbSize: thumbSize,
          thumbSizeNum: thumbSizeNum,
        ),
      ),
      const <Component>[],
    );
  }

  /// The runtime owns pointer and keyboard handling and reports every value
  /// change as an `arcane:slider-change` CustomEvent on the root, so the
  /// hydrated callbacks listen there instead of duplicating the gesture logic.
  Map<String, EventCallback>? _changeEvents() {
    if (props.disabled) return null;
    if (props.isRange ? props.onRangeChanged == null : props.onChanged == null) {
      return null;
    }
    return <String, EventCallback>{
      'arcane:slider-change': (event) {
        if (props.isRange) {
          final double? lo = domEventDetailNumber(event, 'lo');
          final double? hi = domEventDetailNumber(event, 'hi');
          if (lo != null && hi != null) props.onRangeChanged!(lo, hi);
          return;
        }
        final double? value = domEventDetailNumber(event, 'value');
        if (value != null) props.onChanged!(value);
      },
    };
  }

  Map<String, String> _thumbAriaLabel(String kind) {
    switch (kind) {
      case 'value':
        return props.label != null
            ? <String, String>{'aria-label': props.label!}
            : const <String, String>{};
      case 'lo':
        return <String, String>{
          'aria-label': props.label != null
              ? '${props.label} minimum'
              : 'Minimum',
        };
      default: // 'hi'
        return <String, String>{
          'aria-label': props.label != null
              ? '${props.label} maximum'
              : 'Maximum',
        };
    }
  }

  Component _buildStepMarkers(String trackHeight) {
    if (props.step == null || props.step! <= 0) {
      return const dom.div(
        <Component>[],
        styles: dom.Styles(raw: <String, String>{}),
      );
    }

    final int steps = ((props.max - props.min) / props.step!).floor();
    if (steps > maxStepMarkers) {
      return const dom.div(
        <Component>[],
        styles: dom.Styles(raw: <String, String>{}),
      );
    }

    return dom.div(
      styles: dom.Styles(
        raw: <String, String>{
          'position': 'absolute',
          'left': '0',
          'right': '0',
          'height': trackHeight,
          'display': 'flex',
          'justify-content': 'space-between',
          'align-items': 'center',
          'pointer-events': 'none',
        },
      ),
      <Component>[
        for (int i = 0; i <= steps; i++)
          dom.div(
            styles: dom.Styles(raw: stepMarkerStyles()),
            const <Component>[],
          ),
      ],
    );
  }
}
