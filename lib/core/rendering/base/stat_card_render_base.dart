import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/props/stat_card_props.dart';
import 'package:arcane_jaspr/core/rendering/base/style_layering.dart';

/// Shared structural base for themed stat-card renderers.
///
/// A stat card is a compact metric surface: an optional icon, an
/// uppercase label, a large value, an optional trend, and a description. The
/// DOM and its inline chrome (built from theme CSS variables, so it adapts to
/// the active palette) are identical across themes; a concrete theme renderer
/// supplies only the root [cssClass] and may override [decorationStyles].
///
/// This base lives in core and depends only on core props; it must never
/// depend on a theme package.
abstract class StatCardRenderBase extends StatelessComponent {
  const StatCardRenderBase(this.props, {super.key});

  final StatCardProps props;

  /// Root CSS class (e.g. `'arcane-stat-card'`).
  String get cssClass;

  /// Per-instance decoration overrides. Default: none.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  @override
  Component build(BuildContext context) {
    final Map<String, String> rootStyles = layerStyles(
      <String, String>{
        'display': 'flex',
        'flex-direction': 'column',
        'gap': '0.35rem',
        'padding': '1.5rem',
        'background-color': 'var(--card)',
        'color': 'var(--card-foreground)',
        'border': '1px solid var(--border)',
        'border-radius': 'var(--radius-md)',
        'width': '100%',
      },
      <Map<String, String>?>[
        props.decoration?.universalStyles(),
        decorationStyles(props.decoration),
        props.styles?.toMap(),
      ],
    );

    return dom.div(
      classes: cssClass,
      attributes: const <String, String>{
        'data-arcane-surface': 'stat-card',
      },
      styles: dom.Styles(raw: rootStyles),
      <Component>[
        if (props.icon != null)
          dom.div(
            classes: '$cssClass-icon',
            styles: const dom.Styles(
              raw: <String, String>{
                'display': 'inline-flex',
                'align-items': 'center',
                'margin-bottom': '0.25rem',
                'color': 'var(--primary)',
                'font-size': '1.1rem',
              },
            ),
            <Component>[props.icon!],
          ),
        dom.span(
          styles: const dom.Styles(
            raw: <String, String>{
              'font-size': '0.75rem',
              'font-weight': '500',
              'text-transform': 'uppercase',
              'letter-spacing': '0.05em',
              'color': 'var(--muted-foreground)',
            },
          ),
          <Component>[Component.text(props.label)],
        ),
        dom.div(
          styles: const dom.Styles(
            raw: <String, String>{
              'display': 'flex',
              'align-items': 'baseline',
              'gap': '0.5rem',
            },
          ),
          <Component>[
            dom.span(
              styles: const dom.Styles(
                raw: <String, String>{
                  'font-size': '1.75rem',
                  'font-weight': '700',
                  'line-height': '1.1',
                  'color': 'var(--foreground)',
                },
              ),
              <Component>[Component.text(props.value)],
            ),
            if (props.trend != null)
              dom.span(
                styles: dom.Styles(
                  raw: <String, String>{
                    'font-size': '0.8rem',
                    'font-weight': '600',
                    'color': props.trendPositive
                        ? 'var(--success, #16a34a)'
                        : 'var(--destructive)',
                  },
                ),
                <Component>[Component.text(props.trend!)],
              ),
          ],
        ),
        if (props.description != null)
          dom.span(
            styles: const dom.Styles(
              raw: <String, String>{
                'font-size': '0.8rem',
                'color': 'var(--muted-foreground)',
              },
            ),
            <Component>[Component.text(props.description!)],
          ),
      ],
    );
  }
}

/// Shared structural base for themed stat-card-row renderers — a responsive
/// grid that lays out its [StatCardRowProps.cards] in [StatCardRowProps.columns]
/// equal columns.
abstract class StatCardRowRenderBase extends StatelessComponent {
  const StatCardRowRenderBase(this.props, {super.key});

  final StatCardRowProps props;

  /// Root CSS class (e.g. `'arcane-stat-card-row'`).
  String get cssClass;

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: cssClass,
      styles: dom.Styles(
        raw: <String, String>{
          'display': 'grid',
          'grid-template-columns': 'repeat(${props.columns}, minmax(0, 1fr))',
          'gap': props.gap ?? '1rem',
          'width': '100%',
        },
      ),
      props.cards,
    );
  }
}
