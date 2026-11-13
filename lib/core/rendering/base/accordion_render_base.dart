import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/component/view/icon.dart';
import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/rendering/base/style_layering.dart';
import 'package:arcane_jaspr/core/props/accordion_props.dart';

/// Shared structural base for the neon/neubrutalism accordion renderers.
///
/// These two themes render an identical native `<details>`/`<summary>` tree —
/// the root container, summary scaffold, title, the category-badge/chevron
/// container, the chevron icon and the content block all match byte-for-byte.
/// They diverge only in the per-theme style values for the item card, the
/// category badge, the chevron button and the content border, which are exposed
/// as abstract members.
///
/// The ShadCN accordion is structurally divergent (no card styling, no accent
/// colors or category badges, a glyph chevron and a `bordered` root option) and
/// is therefore left standalone rather than forced through this base.
///
/// This base lives in core and depends only on core props and the shared icon
/// component; it must never depend on a theme package.
abstract class AccordionRenderBase extends StatelessComponent {
  const AccordionRenderBase(this.props, {super.key});

  final AccordionProps props;

  /// Theme class prefix (e.g. `'neon'`, `'neubrutalism'`).
  String get classPrefix;

  /// Fallback accent color when neither the item nor the props supply one.
  String get accentColorFallback;

  /// Inline styles for the item `<details>` card.
  Map<String, String> detailsStyles();

  /// Inline styles for the FAQ category badge (receives the resolved accent).
  Map<String, String> categoryBadgeStyles(String accentColor);

  /// Inline styles for the chevron button (receives the resolved accent).
  Map<String, String> chevronStyles(String accentColor);

  /// `border-top` value for the content block.
  String get contentBorderTop;

  /// Per-instance decoration overrides. Default: none. Themes translate an
  /// ArcaneDecoration into their own CSS; unimplemented fields are ignored.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: '$classPrefix-accordion faq-container',
      styles: dom.Styles(
        raw: layerStyles(
          <String, String>{
            'display': 'flex',
            'flex-direction': 'column',
            'gap': '0.75rem',
            'width': '100%',
          },
          <Map<String, String>?>[
            props.decoration?.universalStyles(),
            decorationStyles(props.decoration),
            props.styles?.toMap(),
          ],
        ),
      ),
      <Component>[
        for (int i = 0; i < props.items.length; i++)
          _buildItem(props.items[i], props.openItems.contains(i)),
      ],
    );
  }

  Component _buildItem(AccordionItemProps item, bool defaultOpen) {
    final String accentColor =
        item.accentColor ?? props.defaultAccentColor ?? accentColorFallback;
    final bool showCategory =
        props.variant == AccordionVariant.faq && item.category != null;

    return Component.element(
      tag: 'details',
      attributes: <String, String>{if (defaultOpen) 'open': ''},
      styles: dom.Styles(raw: detailsStyles()),
      children: <Component>[
        // Summary (clickable header)
        Component.element(
          tag: 'summary',
          styles: const dom.Styles(
            raw: <String, String>{
              'display': 'flex',
              'align-items': 'center',
              'justify-content': 'space-between',
              'gap': '1rem',
              'padding': '1.125rem 1.25rem',
              'cursor': 'pointer',
              'list-style': 'none',
              '-webkit-user-select': 'none',
              'user-select': 'none',
              'transition': 'background 140ms ease',
            },
          ),
          children: <Component>[
            // Title text
            dom.div(
              styles: const dom.Styles(
                raw: <String, String>{
                  'flex-grow': '1',
                  'font-family': 'var(--font-heading)',
                  'font-size': '0.9375rem',
                  'font-weight': 'var(--font-weight-semibold)',
                  'letter-spacing': '0.02em',
                  'color': 'var(--foreground)',
                  'line-height': '1.5',
                },
              ),
              <Component>[item.customTitle ?? Component.text(item.title)],
            ),
            // Category badge and chevron container
            dom.div(
              styles: const dom.Styles(
                raw: <String, String>{
                  'display': 'flex',
                  'align-items': 'center',
                  'gap': '0.75rem',
                  'flex-shrink': '0',
                },
              ),
              <Component>[
                // Category badge (FAQ variant only) — chamfered
                if (showCategory)
                  dom.span(
                    styles: dom.Styles(raw: categoryBadgeStyles(accentColor)),
                    <Component>[Component.text(item.category!)],
                  ),
                // Chevron button — chamfered
                dom.div(
                  classes: 'faq-chevron',
                  styles: dom.Styles(raw: chevronStyles(accentColor)),
                  <Component>[ArcaneIcon.chevronDown(size: IconSize.sm)],
                ),
              ],
            ),
          ],
        ),
        // Content (shown when open)
        dom.div(
          styles: dom.Styles(
            raw: <String, String>{
              'padding': '0 1.25rem 1.25rem 1.25rem',
              'border-top': contentBorderTop,
            },
          ),
          <Component>[
            dom.div(
              styles: const dom.Styles(
                raw: <String, String>{
                  'padding-top': '1.25rem',
                  'font-size': '0.875rem',
                  'color': 'var(--muted-foreground)',
                  'line-height': '1.75',
                },
              ),
              <Component>[item.customContent ?? Component.text(item.content)],
            ),
          ],
        ),
      ],
    );
  }
}
