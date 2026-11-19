import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/rendering/base/style_layering.dart';
import 'package:arcane_jaspr/core/props/progress_props.dart';

/// Shared structural base for themed linear progress-bar renderers.
///
/// Factors the identical build logic shared by themes that wrap the indicator
/// in a track element (root container, the track wrapper, the single indicator
/// node whose class/styles depend on the indeterminate flag, and the optional
/// value readout) into one place. A concrete theme renderer only supplies the
/// CSS classes and the track/indicator/value style maps.
///
/// Note: not every theme uses this skeleton — themes whose root carries the
/// `progressbar` ARIA attributes directly and render the indicator without a
/// track wrapper (e.g. ShadCN) do not extend this base.
///
/// This base lives in core and depends only on core props; it must never
/// depend on a theme package.
abstract class ProgressRenderBase extends StatelessComponent {
  const ProgressRenderBase(this.props, {super.key});

  final ProgressProps props;

  /// CSS class applied to the root element (e.g. `'neon-progress'`).
  String get rootClass;

  /// CSS class applied to the track wrapper element.
  String get trackClass;

  /// CSS class applied to the value readout element.
  String get valueClass;

  /// Inline styles for the track wrapper (theme resolves height/colors).
  Map<String, String> trackStyles(ProgressProps props);

  /// CSS class for the indicator element; receives the resolved indeterminate
  /// flag so themes can append their indeterminate marker.
  String indicatorClasses(bool indeterminate);

  /// Inline styles for the indicator element. [percentage] is the clamped value
  /// scaled to 0..100; [indeterminate] selects animation vs width/transition.
  Map<String, String> indicatorStyles(
    ProgressProps props,
    double percentage,
    bool indeterminate,
  );

  /// Inline styles for the value readout element.
  Map<String, String> get valueStyles;

  /// Per-instance decoration overrides. Default: none. A theme overrides this
  /// to translate an [ArcaneDecoration] (elevation intent, theme-specific
  /// fields) into its own CSS. Fields a theme does not implement are ignored.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  @override
  Component build(BuildContext context) {
    final double clampedValue = props.value.clamp(0.0, 1.0);
    final double percentage = clampedValue * 100;

    return dom.div(
      classes: rootClass,
      styles: const dom.Styles(raw: <String, String>{'width': '100%'}),
      <Component>[
        dom.div(
          classes: trackClass,
          attributes: const <String, String>{
            'data-arcane-intrinsic-shape': 'progress-track',
          },
          styles: dom.Styles(
            raw: <String, String>{
              ...trackStyles(props),
              ...?props.decoration?.universalStyles(),
              ...decorationStyles(props.decoration),
              ...?props.styles?.toMap(),
            },
          ),
          <Component>[
            dom.div(
              classes: indicatorClasses(props.indeterminate),
              attributes: const <String, String>{
                'data-arcane-intrinsic-shape': 'progress-fill',
              },
              styles: dom.Styles(
                raw: indicatorStyles(props, percentage, props.indeterminate),
              ),
              const <Component>[],
            ),
          ],
        ),
        if (props.showValue)
          dom.div(
            classes: valueClass,
            styles: dom.Styles(raw: valueStyles),
            <Component>[Component.text('${percentage.toStringAsFixed(0)}%')],
          ),
      ],
    );
  }
}

/// Shared structural base for themed circular progress renderers.
///
/// Every theme renders the same tree: a `progressbar` root, an absolutely
/// positioned conic-gradient ring, and a center content block holding an
/// optional percentage span and an optional label span. The themes differ only
/// in CSS classes, the root/ring style maps, the span style maps, and whether
/// the center content block is always present or only rendered when there is
/// something to show — exposed via the [showCenter] hook.
///
/// This base lives in core and depends only on core props; it must never
/// depend on a theme package.
abstract class CircularProgressRenderBase extends StatelessComponent {
  const CircularProgressRenderBase(this.props, {super.key});

  final CircularProgressProps props;

  /// CSS class applied to the root element.
  String get rootClass;

  /// Inline styles for the root element (theme resolves size/layout).
  Map<String, String> rootStyles(CircularProgressProps props);

  /// Inline styles for the conic-gradient ring element.
  Map<String, String> ringStyles(CircularProgressProps props);

  /// Whether the center content block should be rendered. Some themes always
  /// render it; others render it only when there is a percentage or label.
  bool showCenter(CircularProgressProps props);

  /// Inline styles for the percentage span.
  Map<String, String> get percentStyles;

  /// Inline styles for the label span.
  Map<String, String> get labelStyles;

  /// Per-instance decoration overrides. Default: none. A theme overrides this
  /// to translate an [ArcaneDecoration] (elevation intent, theme-specific
  /// fields) into its own CSS. Fields a theme does not implement are ignored.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  @override
  Component build(BuildContext context) {
    final double clampedValue = props.value.clamp(0.0, 1.0);
    final int percentage = (clampedValue * 100).round();

    return dom.div(
      classes: rootClass,
      attributes: <String, String>{
        'role': 'progressbar',
        'aria-valuemin': '0',
        'aria-valuemax': '100',
        'aria-valuenow': '$percentage',
        'data-arcane-intrinsic-shape': 'circular-progress',
        if (props.label != null) 'aria-label': props.label!,
      },
      styles: dom.Styles(raw: rootStyles(props)),
      <Component>[
        // Ring using a conic gradient masked into a stroke.
        dom.div(
          attributes: const <String, String>{
            'data-arcane-intrinsic-shape': 'circular-progress-ring',
          },
          styles: dom.Styles(
            raw: <String, String>{
              ...ringStyles(props),
              ...?props.decoration?.universalStyles(),
              ...decorationStyles(props.decoration),
              ...?props.styles?.toMap(),
            },
          ),
          const <Component>[],
        ),
        // Center content.
        if (showCenter(props))
          dom.div(
            classes: '$rootClass-center',
            styles: const dom.Styles(
              raw: <String, String>{
                'display': 'flex',
                'flex-direction': 'column',
                'align-items': 'center',
                'justify-content': 'center',
              },
            ),
            <Component>[
              if (props.showPercentage)
                dom.span(
                  classes: '$rootClass-percentage',
                  styles: dom.Styles(raw: percentStyles),
                  <Component>[Component.text('$percentage%')],
                ),
              if (props.label != null)
                dom.span(
                  classes: '$rootClass-label',
                  styles: dom.Styles(raw: labelStyles),
                  <Component>[Component.text(props.label!)],
                ),
            ],
          ),
      ],
    );
  }
}

/// Shared structural base for themed loading-spinner renderers that render a
/// bare `<span>` (no ARIA attributes), with the visual treatment supplied
/// entirely through [spinnerStyles].
///
/// Themes that render a `<div>` with `role="status"` (e.g. ShadCN) do not
/// extend this base.
///
/// This base lives in core and depends only on core props; it must never
/// depend on a theme package.
abstract class LoadingSpinnerRenderBase extends StatelessComponent {
  const LoadingSpinnerRenderBase(this.props, {super.key});

  final LoadingSpinnerProps props;

  /// CSS class applied to the spinner element.
  String get rootClass;

  /// Inline styles for the spinner element (theme resolves size/color).
  Map<String, String> spinnerStyles(LoadingSpinnerProps props);

  /// Per-instance decoration overrides. Default: none. A theme overrides this
  /// to translate an [ArcaneDecoration] (elevation intent, theme-specific
  /// fields) into its own CSS. Fields a theme does not implement are ignored.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  @override
  Component build(BuildContext context) {
    return dom.span(
      classes: 'arcane-loader $rootClass',
      attributes: const <String, String>{
        'role': 'status',
        'aria-label': 'Loading',
        'data-arcane-intrinsic-shape': 'circular-loader',
      },
      styles: dom.Styles(
        raw: layerStyles(
          <String, String>{
            '--arcane-loader-size': props.size ?? '24px',
            '--arcane-loader-color': props.color ?? 'currentColor',
            ...spinnerStyles(props),
          },
          <Map<String, String>?>[
            props.decoration?.universalStyles(),
            decorationStyles(props.decoration),
            props.styles?.toMap(),
          ],
        ),
      ),
      const <Component>[],
    );
  }
}
