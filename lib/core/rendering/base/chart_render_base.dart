import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart';

import 'package:arcane_jaspr/core/props/chart_props.dart';

/// Shared structural base for themed chart renderers.
///
/// Every theme renders the identical skeleton: a container with an optional
/// title and description followed by one row per data point (label, a track
/// holding a proportional fill bar, and a value). Only the inline styles and
/// the root CSS class differ per theme, so this base factors the skeleton and
/// the proportional-width computation, leaving the style maps to the subclass.
///
/// This base lives in core and depends only on core props; it must never depend
/// on a theme package.
abstract class ChartRenderBase extends StatelessComponent {
  const ChartRenderBase(this.props, {super.key});

  final ChartProps props;

  /// CSS class applied to the chart root element.
  String get cssClass;

  /// Inline styles for the chart root element.
  Map<String, String> get rootStyles;

  /// Inline styles for the title span.
  Map<String, String> get titleStyles;

  /// Inline styles for the description span.
  Map<String, String> get descriptionStyles;

  /// Inline styles for each point row.
  Map<String, String> get pointRowStyles;

  /// Inline styles for each point label span.
  Map<String, String> get pointLabelStyles;

  /// Inline styles for each point's track (the bar background).
  Map<String, String> get trackStyles;

  /// Inline styles for a point's fill bar; [width] is the resolved CSS width.
  Map<String, String> fillStyles(String width);

  /// Inline styles for each point value span.
  Map<String, String> get pointValueStyles;

  @override
  Component build(BuildContext context) {
    final num maxValue = props.points.isEmpty
        ? 1
        : props.points
              .map((ChartPointProps point) => point.value)
              .reduce((num a, num b) => a > b ? a : b);

    return dom.div(classes: cssClass, styles: dom.Styles(raw: rootStyles), <
      Component
    >[
      if (props.title != null)
        dom.span(styles: dom.Styles(raw: titleStyles), <Component>[
          Component.text(props.title!),
        ]),
      if (props.description != null)
        dom.span(styles: dom.Styles(raw: descriptionStyles), <Component>[
          Component.text(props.description!),
        ]),
      for (final ChartPointProps point in props.points)
        dom.div(
          classes: 'arcane-chart-row',
          styles: dom.Styles(raw: pointRowStyles),
          <Component>[
            dom.span(
              classes: 'arcane-chart-label',
              styles: dom.Styles(raw: pointLabelStyles),
              <Component>[Component.text(point.label)],
            ),
            dom.div(
              classes: 'arcane-chart-track',
              attributes: const <String, String>{'aria-hidden': 'true'},
              styles: dom.Styles(raw: trackStyles),
              <Component>[
                dom.div(
                  classes: 'arcane-chart-fill',
                  styles: dom.Styles(
                    raw: fillStyles(
                      '${(maxValue > 0 ? (point.value / maxValue * 100).clamp(0, 100) : 0).toStringAsFixed(2)}%',
                    ),
                  ),
                  const <Component>[],
                ),
              ],
            ),
            dom.span(
              classes: 'arcane-chart-value',
              styles: dom.Styles(raw: pointValueStyles),
              <Component>[Component.text(point.value.toString())],
            ),
          ],
        ),
    ]);
  }
}
