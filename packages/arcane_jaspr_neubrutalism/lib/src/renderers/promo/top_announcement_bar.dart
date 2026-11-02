import 'package:arcane_jaspr/core/props/promo_props.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart';

/// Flat, full-width announcement renderer.
class NeubrutalismTopAnnouncementBar extends StatelessComponent {
  final TopAnnouncementBarProps props;

  const NeubrutalismTopAnnouncementBar(this.props, {super.key});

  @override
  Component build(BuildContext context) => dom.div(
    classes: 'neubrutalism-top-announcement-bar',
    styles: const dom.Styles(
      raw: {
        'position': 'sticky',
        'top': '0',
        'z-index': '100',
        'display': 'flex',
        'align-items': 'center',
        'justify-content': 'center',
        'gap': '1rem',
        'padding': '0.5rem 1rem',
        'background': 'var(--card)',
        'color': 'var(--foreground)',
        'border-bottom': '1px solid var(--border)',
        'border-radius': '0',
      },
    ),
    [
      dom.span([Component.text(props.message)]),
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
      if (props.onDismiss != null)
        dom.button(
          attributes: const {'aria-label': 'Dismiss announcement'},
          styles: const dom.Styles(
            raw: {
              'padding': '0.25rem',
              'background': 'transparent',
              'border': '0',
              'border-radius': 'var(--nb-radius-tight, 0)',
              'color': 'var(--muted-foreground)',
              'cursor': 'pointer',
            },
          ),
          events: {'click': (_) => props.onDismiss!()},
          [Component.text('\u00d7')],
        ),
    ],
  );
}
