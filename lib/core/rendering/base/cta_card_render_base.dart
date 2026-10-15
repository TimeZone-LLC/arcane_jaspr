import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/props/cta_card_props.dart';
import 'package:arcane_jaspr/core/rendering/base/style_layering.dart';

/// Shared structural base for themed CTA-card renderers.
///
/// A CTA (call-to-action) card is a bordered, centered surface: an optional
/// icon, a bold title, a muted description, and a
/// prominent call-to-action control (an `<a>` when [CTACardProps.href] is set,
/// otherwise a `<button>` wired to [CTACardProps.onTap]). The DOM and its inline
/// chrome (built from theme CSS variables, so it adapts to the active palette)
/// are identical across themes; a concrete theme renderer supplies only the
/// root [cssClass] and may override [decorationStyles].
///
/// This base lives in core and depends only on core props; it must never
/// depend on a theme package.
abstract class CtaCardRenderBase extends StatelessComponent {
  const CtaCardRenderBase(this.props, {super.key});

  final CTACardProps props;

  /// Root CSS class (e.g. `'arcane-cta-card'`).
  String get cssClass;

  /// Per-instance decoration overrides. Default: none.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  @override
  Component build(BuildContext context) {
    final String accent = props.accentColor ?? 'var(--primary)';

    final Map<String, String> rootStyles = layerStyles(
      <String, String>{
        'display': 'flex',
        'flex-direction': 'column',
        'align-items': 'center',
        'justify-content': 'center',
        'gap': '1rem',
        'padding': '2rem',
        'text-align': 'center',
        'background-color': 'var(--card)',
        'color': 'var(--card-foreground)',
        'border': '1px solid var(--border)',
        'border-radius': 'var(--radius-md)',
        'width': '100%',
        'min-height': props.height,
        'box-sizing': 'border-box',
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
        'data-arcane-surface': 'cta-card',
      },
      styles: dom.Styles(raw: rootStyles),
      <Component>[
        if (props.icon != null)
          dom.div(
            classes: '$cssClass-icon',
            styles: dom.Styles(
              raw: <String, String>{
                'display': 'inline-flex',
                'align-items': 'center',
                'color': accent,
                'font-size': '1.5rem',
              },
            ),
            <Component>[props.icon!],
          ),
        dom.h3(
          styles: const dom.Styles(
            raw: <String, String>{
              'margin': '0',
              'font-size': '1.25rem',
              'font-weight': '700',
              'line-height': '1.2',
              'color': 'var(--foreground)',
            },
          ),
          <Component>[Component.text(props.title)],
        ),
        if (props.description != null)
          dom.p(
            styles: const dom.Styles(
              raw: <String, String>{
                'margin': '0',
                'font-size': '0.9rem',
                'line-height': '1.5',
                'max-width': '32ch',
                'color': 'var(--muted-foreground)',
              },
            ),
            <Component>[Component.text(props.description!)],
          ),
        _ctaControl(accent),
      ],
    );
  }

  /// The call-to-action control: an anchor when [CTACardProps.href] is set,
  /// otherwise a button wired to [CTACardProps.onTap].
  Component _ctaControl(String accent) {
    final Map<String, String> ctaStyles = <String, String>{
      'display': 'inline-flex',
      'align-items': 'center',
      'justify-content': 'center',
      'gap': '0.5rem',
      'margin-top': '0.5rem',
      'padding': '0.6rem 1.25rem',
      'font-size': '0.9rem',
      'font-weight': '600',
      'line-height': '1',
      'border': 'none',
      'border-radius': 'var(--radius-sm)',
      'background-color': accent,
      'color': 'var(--primary-foreground)',
      'cursor': 'pointer',
      'text-decoration': 'none',
    };

    if (props.href != null) {
      return dom.a(
        classes: '$cssClass-button',
        href: props.href!,
        attributes: props.isExternal
            ? const <String, String>{
                'target': '_blank',
                'rel': 'noopener noreferrer',
              }
            : null,
        styles: dom.Styles(raw: ctaStyles),
        <Component>[
          Component.text(props.ctaText),
          if (props.isExternal)
            const dom.span(<Component>[Component.text('↗')]),
        ],
      );
    }

    return dom.button(
      classes: '$cssClass-button',
      attributes: const <String, String>{'type': 'button'},
      styles: dom.Styles(raw: ctaStyles),
      events: <String, EventCallback>{'click': (_) => props.onTap?.call()},
      <Component>[Component.text(props.ctaText)],
    );
  }
}
