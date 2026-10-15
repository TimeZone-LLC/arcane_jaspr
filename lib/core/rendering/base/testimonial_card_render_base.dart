import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/props/testimonial_card_props.dart';
import 'package:arcane_jaspr/core/rendering/base/style_layering.dart';

/// Shared structural base for themed testimonial-card renderers.
///
/// A testimonial card is a quote surface: an optional uniform accent border, a
/// large decorative quote, an optional rating row, and an author row (avatar or
/// initials, name, and a muted `title · company` line). The DOM and its inline
/// chrome (built from theme CSS variables, so it adapts to the active palette)
/// are identical across themes; a concrete theme renderer supplies only the
/// root [cssClass] and may override [decorationStyles].
///
/// This base lives in core and depends only on core props; it must never
/// depend on a theme package.
abstract class TestimonialCardRenderBase extends StatelessComponent {
  const TestimonialCardRenderBase(this.props, {super.key});

  final TestimonialCardProps props;

  /// Root CSS class (e.g. `'arcane-testimonial-card'`).
  String get cssClass;

  /// Per-instance decoration overrides. Default: none.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  @override
  Component build(BuildContext context) {
    final String accent = props.effectiveAccentColor;

    final Map<String, String> rootStyles = layerStyles(
      <String, String>{
        'display': 'flex',
        'flex-direction': 'column',
        'gap': '1rem',
        'padding': '1.5rem',
        'background-color': 'var(--card)',
        'color': 'var(--card-foreground)',
        'border': '1px solid var(--border)',
        if (props.showAccentBorder) 'border-color': accent,
        'border-radius': 'var(--radius-md)',
        'width': '100%',
      },
      <Map<String, String>?>[
        props.decoration?.universalStyles(),
        decorationStyles(props.decoration),
        props.styles?.toMap(),
      ],
    );

    final String? subtitle = _authorSubtitle(props);

    return dom.div(
      classes: cssClass,
      attributes: const <String, String>{
        'data-arcane-surface': 'testimonial-card',
      },
      styles: dom.Styles(raw: rootStyles),
      <Component>[
        // Quote block.
        dom.div(
          styles: const dom.Styles(
            raw: <String, String>{
              'display': 'flex',
              'flex-direction': 'column',
              'gap': '0.4rem',
            },
          ),
          <Component>[
            if (props.showQuotes)
              dom.span(
                styles: dom.Styles(
                  raw: <String, String>{
                    'font-family': 'var(--font-heading)',
                    'font-size': '2.5rem',
                    'line-height': '1',
                    'font-weight': '700',
                    'color': accent,
                  },
                ),
                const <Component>[Component.text('“')],
              ),
            dom.p(
              styles: const dom.Styles(
                raw: <String, String>{
                  'margin': '0',
                  'font-size': '1.05rem',
                  'line-height': '1.6',
                  'color': 'var(--card-foreground)',
                },
              ),
              <Component>[Component.text(props.quote)],
            ),
          ],
        ),
        // Rating row.
        if (props.rating != null)
          dom.div(
            styles: const dom.Styles(
              raw: <String, String>{
                'display': 'flex',
                'align-items': 'center',
                'gap': '0.5rem',
              },
            ),
            <Component>[
              dom.span(
                styles: const dom.Styles(
                  raw: <String, String>{
                    'font-size': '1rem',
                    'letter-spacing': '0.1em',
                    'color': 'var(--warning, #eab308)',
                  },
                ),
                <Component>[Component.text(_stars(props.rating!))],
              ),
              if (props.showRatingBadge)
                dom.span(
                  styles: const dom.Styles(
                    raw: <String, String>{
                      'font-size': '0.8rem',
                      'font-weight': '600',
                      'color': 'var(--muted-foreground)',
                    },
                  ),
                  <Component>[Component.text('${props.rating}/5')],
                ),
            ],
          ),
        // Author row.
        dom.div(
          styles: const dom.Styles(
            raw: <String, String>{
              'display': 'flex',
              'align-items': 'center',
              'gap': '0.75rem',
              'margin-top': '0.25rem',
            },
          ),
          <Component>[
            _avatar(props, accent),
            dom.div(
              styles: const dom.Styles(
                raw: <String, String>{
                  'display': 'flex',
                  'flex-direction': 'column',
                  'gap': '0.1rem',
                },
              ),
              <Component>[
                dom.span(
                  styles: const dom.Styles(
                    raw: <String, String>{
                      'font-weight': '600',
                      'font-size': '0.95rem',
                      'color': 'var(--card-foreground)',
                    },
                  ),
                  <Component>[Component.text(props.authorName)],
                ),
                if (subtitle != null)
                  dom.span(
                    styles: const dom.Styles(
                      raw: <String, String>{
                        'font-size': '0.8rem',
                        'color': 'var(--muted-foreground)',
                      },
                    ),
                    <Component>[Component.text(subtitle)],
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// Round avatar image, or an initials circle tinted with the accent color.
  Component _avatar(TestimonialCardProps props, String accent) {
    if (props.avatarUrl != null) {
      return dom.img(
        src: props.avatarUrl!,
        alt: props.authorName,
        attributes: const <String, String>{
          'data-arcane-intrinsic-shape': 'avatar',
        },
        styles: const dom.Styles(
          raw: <String, String>{
            'width': '2.5rem',
            'height': '2.5rem',
            'border-radius': '50%',
            'object-fit': 'cover',
            'flex-shrink': '0',
          },
        ),
      );
    }
    return dom.div(
      attributes: const <String, String>{
        'data-arcane-intrinsic-shape': 'avatar',
      },
      styles: dom.Styles(
        raw: <String, String>{
          'display': 'inline-flex',
          'align-items': 'center',
          'justify-content': 'center',
          'width': '2.5rem',
          'height': '2.5rem',
          'border-radius': '50%',
          'flex-shrink': '0',
          'background-color': 'color-mix(in srgb, $accent 15%, transparent)',
          'color': accent,
          'font-weight': '600',
          'font-size': '0.9rem',
        },
      ),
      <Component>[Component.text(_initials(props.authorName))],
    );
  }

  /// Filled/empty text stars for [rating] out of 5.
  static String _stars(int rating) {
    final int filled = rating.clamp(0, 5);
    return '★' * filled + '☆' * (5 - filled);
  }

  /// Up to two uppercase initials derived from [name].
  static String _initials(String name) {
    final List<String> parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((String p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  /// Joins the author's title and company with a middot, or null if neither.
  static String? _authorSubtitle(TestimonialCardProps props) {
    final List<String> parts = <String>[
      if (props.authorTitle != null && props.authorTitle!.isNotEmpty)
        props.authorTitle!,
      if (props.authorCompany != null && props.authorCompany!.isNotEmpty)
        props.authorCompany!,
    ];
    return parts.isEmpty ? null : parts.join(' · ');
  }
}

/// Shared structural base for themed simple rating-stars renderers.
///
/// Renders [RatingStarsSimpleProps.rating] filled stars out of
/// [RatingStarsSimpleProps.maxStars] using text stars (★/☆), sized by
/// [RatingStarsSimpleProps.size] and colored with the palette's warning token.
/// When interactive, each star click reports its 1-based position via
/// [RatingStarsSimpleProps.onRatingChanged].
abstract class RatingStarsSimpleRenderBase extends StatelessComponent {
  const RatingStarsSimpleRenderBase(this.props, {super.key});

  final RatingStarsSimpleProps props;

  /// Root CSS class (e.g. `'arcane-rating-stars'`).
  String get cssClass;

  @override
  Component build(BuildContext context) {
    final int filled = props.rating.round().clamp(0, props.maxStars);

    return dom.div(
      classes: cssClass,
      styles: dom.Styles(
        raw: <String, String>{
          'display': 'inline-flex',
          'align-items': 'center',
          'gap': '0.1em',
          'font-size': '${props.size}px',
          'line-height': '1',
          'color': 'var(--warning, #eab308)',
        },
      ),
      <Component>[
        for (int i = 0; i < props.maxStars; i++)
          dom.span(
            styles: dom.Styles(
              raw: <String, String>{if (props.interactive) 'cursor': 'pointer'},
            ),
            events: props.interactive && props.onRatingChanged != null
                ? <String, EventCallback>{
                    'click': (_) => props.onRatingChanged!(i + 1),
                  }
                : null,
            <Component>[Component.text(i < filled ? '★' : '☆')],
          ),
      ],
    );
  }
}
