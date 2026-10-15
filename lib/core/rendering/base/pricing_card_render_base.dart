import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/props/pricing_card_props.dart';
import 'package:arcane_jaspr/core/rendering/base/style_layering.dart';

/// Shared structural base for themed pricing-card renderers.
///
/// A pricing card is a plan surface: an optional icon,
/// a bold title, a price row, an optional subtitle, an included/excluded
/// feature list, an optional spec table, and a call-to-action button. The DOM and its
/// inline chrome (built from theme CSS variables, so it adapts to the active
/// palette) are identical across themes; a concrete theme renderer supplies only
/// the root [cssClass] and may override [decorationStyles].
///
/// This base lives in core and depends only on core props; it must never
/// depend on a theme package.
abstract class PricingCardRenderBase extends StatelessComponent {
  const PricingCardRenderBase(this.props, {super.key});

  final PricingCardProps props;

  /// Root CSS class (e.g. `'arcane-pricing-card'`).
  String get cssClass;

  /// Per-instance decoration overrides. Default: none.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  @override
  Component build(BuildContext context) {
    final String padding = switch (props.variant) {
      PricingCardVariant.compact => '1.25rem',
      PricingCardVariant.standard => '1.75rem',
    };
    final String priceSize = switch (props.variant) {
      PricingCardVariant.compact => '1.75rem',
      PricingCardVariant.standard => '2.25rem',
    };
    const String titleSize = '1.15rem';

    final Map<String, String> rootStyles = layerStyles(
      <String, String>{
        'position': 'relative',
        'display': 'flex',
        'flex-direction': 'column',
        'gap': '1rem',
        'padding': padding,
        'background-color': 'var(--card)',
        'color': 'var(--card-foreground)',
        'border': '1px solid var(--border)',
        'border-radius': 'var(--radius-md)',
        'width': '100%',
        'box-sizing': 'border-box',
      },
      <Map<String, String>?>[
        props.decoration?.universalStyles(),
        decorationStyles(props.decoration),
        props.styles?.toMap(),
      ],
    );

    final String? subtitle = props.effectiveSubtitle;
    final List<String> features = props.effectiveFeatures;
    final List<String> excluded = props.excludedFeatures;
    final List<SpecEntry>? specs = props.specs;

    return dom.div(
      classes: cssClass,
      attributes: const <String, String>{'data-arcane-surface': 'pricing-card'},
      styles: dom.Styles(raw: rootStyles),
      <Component>[
        if (props.icon != null)
          dom.div(
            classes: '$cssClass-icon',
            styles: dom.Styles(
              raw: <String, String>{
                'display': 'inline-flex',
                'align-items': 'center',
                'color': 'var(--foreground)',
                'font-size': '1.25rem',
              },
            ),
            <Component>[props.icon!],
          ),
        dom.div(
          styles: dom.Styles(
            raw: <String, String>{
              'font-size': titleSize,
              'font-weight': '700',
              'line-height': '1.3',
              'color': 'var(--foreground)',
            },
          ),
          <Component>[Component.text(props.effectiveTitle)],
        ),
        dom.div(
          styles: const dom.Styles(
            raw: <String, String>{
              'display': 'flex',
              'align-items': 'baseline',
              'gap': '0.4rem',
              'flex-wrap': 'wrap',
            },
          ),
          <Component>[
            dom.span(
              styles: dom.Styles(
                raw: <String, String>{
                  'font-size': priceSize,
                  'font-weight': '700',
                  'line-height': '1.1',
                  'color': 'var(--foreground)',
                },
              ),
              <Component>[Component.text(props.effectivePrice)],
            ),
            dom.span(
              styles: const dom.Styles(
                raw: <String, String>{
                  'font-size': '0.9rem',
                  'color': 'var(--muted-foreground)',
                },
              ),
              <Component>[Component.text(props.effectivePeriod)],
            ),
          ],
        ),
        if (subtitle != null)
          dom.div(
            styles: const dom.Styles(
              raw: <String, String>{
                'font-size': '0.875rem',
                'line-height': '1.5',
                'color': 'var(--muted-foreground)',
              },
            ),
            <Component>[Component.text(subtitle)],
          ),
        if (specs != null && specs.isNotEmpty)
          dom.div(
            classes: '$cssClass-specs',
            styles: const dom.Styles(
              raw: <String, String>{
                'display': 'flex',
                'flex-direction': 'column',
                'border-top': '1px solid var(--border)',
                'border-bottom': '1px solid var(--border)',
                'padding': '0.15rem 0',
              },
            ),
            <Component>[
              for (int i = 0; i < specs.length; i++)
                _specRow(specs[i], isLast: i == specs.length - 1),
            ],
          ),
        if (features.isNotEmpty || excluded.isNotEmpty)
          dom.ul(
            classes: '$cssClass-features',
            styles: const dom.Styles(
              raw: <String, String>{
                'display': 'flex',
                'flex-direction': 'column',
                'gap': '0.5rem',
                'margin': '0',
                'padding': '0',
                'list-style': 'none',
              },
            ),
            <Component>[
              for (final String feature in features)
                _featureItem(feature, included: true),
              for (final String feature in excluded)
                _featureItem(feature, included: false),
            ],
          ),
        _ctaButton(
          cssClass: cssClass,
          label: props.effectiveCtaText,
          buttonLink: props.buttonLink,
          onClick: props.onButtonClick ?? props.onCtaPressed,
        ),
      ],
    );
  }
}

/// A single feature row: a leading `✓` (or `✗` for excluded) glyph and a label.
/// Excluded features are muted and struck through.
Component _featureItem(String text, {required bool included}) {
  return dom.li(
    styles: dom.Styles(
      raw: <String, String>{
        'display': 'flex',
        'align-items': 'flex-start',
        'gap': '0.5rem',
        'font-size': '0.875rem',
        'line-height': '1.4',
        'color': included
            ? 'var(--card-foreground)'
            : 'var(--muted-foreground)',
        if (!included) 'text-decoration': 'line-through',
      },
    ),
    <Component>[
      dom.span(
        styles: dom.Styles(
          raw: <String, String>{
            'flex-shrink': '0',
            'font-weight': '600',
            'color': included
                ? 'var(--success, #16a34a)'
                : 'var(--muted-foreground)',
          },
        ),
        <Component>[Component.text(included ? '✓' : '✗')],
      ),
      dom.span(<Component>[Component.text(text)]),
    ],
  );
}

/// A single spec row: a muted label on the left and a value on the right,
Component _specRow(SpecEntry spec, {bool isLast = false}) {
  return dom.div(
    styles: dom.Styles(
      raw: <String, String>{
        'display': 'flex',
        'justify-content': 'space-between',
        'gap': '0.75rem',
        'font-size': '0.85rem',
        'padding': '0.4rem 0',
        if (!isLast) 'border-bottom': '1px solid var(--border)',
      },
    ),
    <Component>[
      dom.span(
        styles: const dom.Styles(
          raw: <String, String>{'color': 'var(--muted-foreground)'},
        ),
        <Component>[Component.text(spec.label)],
      ),
      dom.span(
        styles: dom.Styles(
          raw: <String, String>{
            'font-weight': '600',
            'color': 'var(--foreground)',
          },
        ),
        <Component>[Component.text(spec.value)],
      ),
    ],
  );
}

/// The call-to-action surface: an anchor when [buttonLink] is set, otherwise a
/// button that invokes [onClick].
///
Component _ctaButton({
  required String cssClass,
  required String label,
  required String? buttonLink,
  required void Function()? onClick,
}) {
  final Map<String, String> base = <String, String>{
    'display': 'inline-flex',
    'align-items': 'center',
    'justify-content': 'center',
    'gap': '0.4rem',
    'margin-top': 'auto',
    'padding': '0.7rem 1rem',
    'width': '100%',
    'box-sizing': 'border-box',
    'font-size': '0.9rem',
    'font-weight': '600',
    'border': '1px solid var(--border)',
    'border-radius': 'var(--radius-sm)',
    'background-color': 'transparent',
    'color': 'var(--foreground)',
    'text-decoration': 'none',
    'text-align': 'center',
    'cursor': 'pointer',
  };

  if (buttonLink != null) {
    return dom.a(
      classes: '$cssClass-cta',
      href: buttonLink,
      styles: dom.Styles(raw: base),
      events: <String, EventCallback>{
        if (onClick != null) 'click': (_) => onClick(),
      },
      <Component>[Component.text(label)],
    );
  }
  return dom.button(
    type: dom.ButtonType.button,
    classes: '$cssClass-cta clickable',
    styles: dom.Styles(
      raw: <String, String>{
        // Button UA resets precede the merged styles so they can be overridden.
        'font': 'inherit',
        ...base,
      },
    ),
    events: <String, EventCallback>{
      if (onClick != null) 'click': (_) => onClick(),
    },
    <Component>[Component.text(label)],
  );
}

/// Shared structural base for themed pricing-grid renderers — a responsive grid
/// that maps each [PricingTier] onto a [PricingCardProps] and renders it with
/// the theme's own pricing-card renderer via [tierCard].
///
/// This base lives in core and depends only on core props; it must never
/// depend on a theme package.
abstract class PricingGridRenderBase extends StatelessComponent {
  const PricingGridRenderBase(this.props, {super.key});

  final PricingGridProps props;

  /// Root CSS class (e.g. `'arcane-pricing-grid'`).
  String get cssClass;

  /// Builds the theme's pricing-card renderer for a single tier's [props].
  Component tierCard(PricingCardProps props);

  @override
  Component build(BuildContext context) {
    final List<PricingTier> tiers = props.tiers;
    final int columns = props.columns ?? tiers.length;

    return dom.div(
      classes: cssClass,
      styles: dom.Styles(
        raw: <String, String>{
          'display': 'grid',
          'grid-template-columns': 'repeat($columns, minmax(0, 1fr))',
          'gap': '1.5rem',
          'width': '100%',
        },
      ),
      <Component>[
        for (final PricingTier tier in tiers) tierCard(_tierToProps(tier)),
      ],
    );
  }

  PricingCardProps _tierToProps(PricingTier tier) => PricingCardProps(
    title: tier.name,
    price: tier.price != null ? '${tier.currency}${tier.price}' : null,
    period: '/${tier.period}',
    subtitle: tier.description,
    features: tier.features,
    buttonText: tier.ctaText,
  );
}
