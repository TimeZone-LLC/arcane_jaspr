import 'package:arcane_jaspr/core/props/promo_props.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart';

/// Flat inline announcement renderer.
class ShadcnInlineHeroBanner extends StatelessComponent {
  final InlineHeroBannerProps props;

  const ShadcnInlineHeroBanner(this.props, {super.key});

  @override
  Component build(BuildContext context) => dom.div(
    classes: 'shadcn-inline-hero-banner',
    styles: const dom.Styles(
      raw: {
        'display': 'flex',
        'align-items': 'center',
        'gap': '1rem',
        'padding': '0.75rem 1rem',
        'background': 'var(--card)',
        'color': 'var(--foreground)',
        'border': '1px solid var(--border)',
        'border-radius': '0',
      },
    ),
    [
      if (props.icon != null)
        dom.span(styles: const dom.Styles(raw: {'flex-shrink': '0'}), [
          props.icon!,
        ]),
      dom.span(styles: const dom.Styles(raw: {'flex': '1'}), [
        Component.text(props.message),
      ]),
      if (props.ctaText != null)
        dom.a(
          href: props.ctaHref ?? '#',
          styles: const dom.Styles(
            raw: {
              'color': 'var(--primary)',
              'text-decoration': 'underline',
              'text-underline-offset': '0.2em',
            },
          ),
          events: props.onCtaClick == null
              ? null
              : {
                  'click': (event) {
                    event.preventDefault();
                    props.onCtaClick!();
                  },
                },
          [Component.text(props.ctaText!)],
        ),
      if (props.dismissible && props.onDismiss != null)
        dom.button(
          attributes: const {'aria-label': 'Dismiss announcement'},
          styles: const dom.Styles(
            raw: {
              'padding': '0.25rem',
              'background': 'transparent',
              'border': '0',
              'border-radius': '0',
              'color': 'var(--muted-foreground)',
              'cursor': 'pointer',
            },
          ),
          events: {'click': (_) => props.onDismiss!()},
          const <Component>[Component.text('\u00d7')],
        ),
    ],
  );
}
