import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/props/feature_card_props.dart';
import 'package:arcane_jaspr/core/rendering/base/style_layering.dart';

/// Wraps [children] in the appropriate interactive surface: an anchor when
/// [href] is set (with `target=_blank` + `rel` for [isExternal]), a button when
/// only [onTap] is set, or a plain div otherwise. The DOM and chrome are shared
/// across themes; a concrete theme renderer supplies only the root [cssClass].
Component _interactiveSurface({
  required String cssClass,
  required Map<String, String> styles,
  required String? href,
  required bool isExternal,
  required void Function()? onTap,
  required List<Component> children,
}) {
  if (href != null) {
    return dom.a(
      classes: cssClass,
      href: href,
      attributes: <String, String>{
        'data-arcane-surface': 'feature-card',
        if (isExternal) 'target': '_blank',
        if (isExternal) 'rel': 'noopener noreferrer',
      },
      styles: dom.Styles(raw: styles),
      events: <String, EventCallback>{
        if (onTap != null) 'click': (_) => onTap(),
      },
      children,
    );
  }
  if (onTap != null) {
    return dom.button(
      type: dom.ButtonType.button,
      classes: '$cssClass clickable',
      attributes: const <String, String>{'data-arcane-surface': 'feature-card'},
      styles: dom.Styles(
        raw: <String, String>{
          // Button UA resets are defaults that theme/decoration/styles must be
          // able to override, so they precede the merged styles.
          'text-align': 'inherit',
          'font': 'inherit',
          ...styles,
        },
      ),
      events: <String, EventCallback>{'click': (_) => onTap()},
      children,
    );
  }
  return dom.div(
    classes: cssClass,
    attributes: const <String, String>{'data-arcane-surface': 'feature-card'},
    styles: dom.Styles(raw: styles),
    children,
  );
}

/// Shared structural base for themed feature-card renderers.
///
/// A feature card is a marketing/navigation surface: an optional icon, a bold
/// title, a muted description, and an optional call-to-action
/// row. It lays out vertically by default and horizontally when
/// [FeatureCardProps.horizontal] is set. When [FeatureCardProps.href] is set the
/// whole card becomes an anchor; otherwise [FeatureCardProps.onTap] makes it a
/// clickable button. The DOM and its inline chrome (built from theme CSS
/// variables, so it adapts to the active palette) are identical across themes; a
/// concrete theme renderer supplies only the root [cssClass] and may override
/// [decorationStyles].
///
/// This base lives in core and depends only on core props; it must never
/// depend on a theme package.
abstract class FeatureCardRenderBase extends StatelessComponent {
  const FeatureCardRenderBase(this.props, {super.key});

  final FeatureCardProps props;

  /// Root CSS class (e.g. `'arcane-feature-card'`).
  String get cssClass;

  /// Per-instance decoration overrides. Default: none.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  @override
  Component build(BuildContext context) {
    final String? accent = props.accentColor;
    final bool horizontal = props.horizontal;

    final Map<String, String> rootStyles = layerStyles(
      <String, String>{
        'display': 'flex',
        'flex-direction': horizontal ? 'row' : 'column',
        'align-items': horizontal ? 'flex-start' : 'stretch',
        'gap': horizontal ? '1rem' : '0.75rem',
        'padding': '1.5rem',
        'background-color': 'var(--card)',
        'color': 'var(--card-foreground)',
        'border': '1px solid var(--border)',
        'border-color': ?accent,
        'border-radius': 'var(--radius-md)',
        'width': '100%',
        'box-sizing': 'border-box',
        'text-decoration': 'none',
        if (props.href != null || props.onTap != null) 'cursor': 'pointer',
      },
      <Map<String, String>?>[
        props.decoration?.universalStyles(),
        decorationStyles(props.decoration),
        props.styles?.toMap(),
      ],
    );

    final String ctaLabel =
        props.ctaText ?? (props.isExternal ? 'View Docs' : 'Learn More');

    final List<Component> body = <Component>[
      dom.div(
        styles: const dom.Styles(
          raw: <String, String>{
            'font-size': '1.05rem',
            'font-weight': '700',
            'line-height': '1.3',
            'color': 'var(--foreground)',
          },
        ),
        <Component>[Component.text(props.title)],
      ),
      dom.div(
        styles: const dom.Styles(
          raw: <String, String>{
            'font-size': '0.875rem',
            'line-height': '1.5',
            'color': 'var(--muted-foreground)',
          },
        ),
        <Component>[Component.text(props.description)],
      ),
      if (props.showCta)
        dom.div(
          classes: '$cssClass-cta',
          styles: dom.Styles(
            raw: <String, String>{
              'display': 'inline-flex',
              'align-items': 'center',
              'gap': '0.35rem',
              'margin-top': '0.5rem',
              'font-size': '0.875rem',
              'font-weight': '600',
              'color': accent ?? 'var(--primary)',
            },
          ),
          <Component>[Component.text(ctaLabel)],
        ),
    ];

    final List<Component> children = <Component>[
      if (props.icon != null)
        dom.div(
          classes: '$cssClass-icon',
          attributes: const <String, String>{
            'data-arcane-semantic-icon': 'leading',
          },
          styles: dom.Styles(
            raw: <String, String>{
              'display': 'inline-flex',
              'align-items': 'center',
              'flex-shrink': '0',
              'color': accent ?? 'var(--primary)',
              'font-size': '1.25rem',
            },
          ),
          <Component>[props.icon!],
        ),
      dom.div(
        styles: const dom.Styles(
          raw: <String, String>{
            'display': 'flex',
            'flex-direction': 'column',
            'gap': '0.35rem',
            'flex': '1',
            'min-width': '0',
          },
        ),
        body,
      ),
    ];

    return _interactiveSurface(
      cssClass: cssClass,
      styles: rootStyles,
      href: props.href,
      isExternal: props.isExternal,
      onTap: props.onTap,
      children: children,
    );
  }
}

/// Shared structural base for themed icon-card renderers.
///
/// An icon card is a compact row: an icon, a bold title, and
/// an optional muted subtitle. It becomes an anchor when [IconCardProps.href] is
/// set or a clickable button when [IconCardProps.onTap] is set. Secondary
/// surface — no decoration/styles seam.
///
/// This base lives in core and depends only on core props; it must never
/// depend on a theme package.
abstract class IconCardRenderBase extends StatelessComponent {
  const IconCardRenderBase(this.props, {super.key});

  final IconCardProps props;

  /// Root CSS class (e.g. `'arcane-icon-card'`).
  String get cssClass;

  @override
  Component build(BuildContext context) {
    final List<Component> children = <Component>[
      dom.div(
        classes: '$cssClass-icon',
        styles: const dom.Styles(
          raw: <String, String>{
            'display': 'inline-flex',
            'align-items': 'center',
            'flex-shrink': '0',
            'color': 'var(--primary)',
            'font-size': '1.1rem',
          },
        ),
        <Component>[props.icon],
      ),
      dom.div(
        styles: const dom.Styles(
          raw: <String, String>{
            'display': 'flex',
            'flex-direction': 'column',
            'gap': '0.15rem',
            'min-width': '0',
          },
        ),
        <Component>[
          dom.div(
            styles: const dom.Styles(
              raw: <String, String>{
                'font-size': '0.9rem',
                'font-weight': '600',
                'line-height': '1.3',
                'color': 'var(--foreground)',
              },
            ),
            <Component>[Component.text(props.title)],
          ),
          if (props.subtitle != null)
            dom.div(
              styles: const dom.Styles(
                raw: <String, String>{
                  'font-size': '0.8rem',
                  'line-height': '1.3',
                  'color': 'var(--muted-foreground)',
                },
              ),
              <Component>[Component.text(props.subtitle!)],
            ),
        ],
      ),
    ];

    final Map<String, String> rootStyles = <String, String>{
      'display': 'flex',
      'align-items': 'center',
      'gap': '0.75rem',
      'padding': '0.875rem 1rem',
      'background-color': 'var(--card)',
      'color': 'var(--card-foreground)',
      'border': '1px solid var(--border)',
      'border-radius': 'var(--radius-md)',
      'width': '100%',
      'box-sizing': 'border-box',
      'text-decoration': 'none',
      if (props.href != null || props.onTap != null) 'cursor': 'pointer',
    };

    return _interactiveSurface(
      cssClass: cssClass,
      styles: rootStyles,
      href: props.href,
      isExternal: false,
      onTap: props.onTap,
      children: children,
    );
  }
}
