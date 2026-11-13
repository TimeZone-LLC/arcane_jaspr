import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/dom_value.dart';
import 'package:arcane_jaspr/core/rendering/base/style_layering.dart';
import 'package:arcane_jaspr/core/props/disclosure_props.dart';

/// Shared structural base for themed disclosure renderers.
///
/// Every theme renders the same native `<details>`/`<summary>` scaffold with
/// identical class-naming conventions, the same `open`/`showChevron`/
/// `showTreeLines` conditionals and the same content/tree-line assembly. The
/// themes diverge only in the per-variant container/summary/content style maps
/// (ShadCN uses `background-color` + `border-radius`; the neon/neubrutalism
/// themes use `background` + `clip-path`) and in the chevron span. Those
/// divergent nodes are exposed as abstract members the subclass supplies.
///
/// This base lives in core and depends only on core props; it must never depend
/// on a theme package.
abstract class DisclosureRenderBase extends StatelessComponent {
  const DisclosureRenderBase(this.props, {super.key});

  final DisclosureProps props;

  /// Theme class prefix (e.g. `'arcane'`, `'neon'`, `'neubrutalism'`).
  String get classPrefix;

  /// Inline styles for the root `<details>` element for the given variant.
  Map<String, String> containerStyles(DisclosureVariant variant);

  /// Inline styles for the `<summary>` element for the given variant.
  Map<String, String> summaryStyles(DisclosureVariant variant);

  /// Builds the chevron span (only rendered when [DisclosureProps.showChevron]).
  Component buildChevron();

  /// Per-variant content `padding` and `border-top` values.
  (String padding, String border) contentVariant(DisclosureVariant variant);

  /// Per-instance decoration overrides. Default: none. Themes translate an
  /// ArcaneDecoration into their own CSS; unimplemented fields are ignored.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  @override
  Component build(BuildContext context) {
    final DisclosureVariant variant = props.variant;
    final String allClasses = <String?>[
      '$classPrefix-disclosure',
      '$classPrefix-disclosure-${variant.name}',
      if (props.classes != null) props.classes,
    ].join(' ');

    final (String contentPadding, String contentBorder) = contentVariant(
      variant,
    );
    final void Function(bool open)? onOpenChange = props.onOpenChange;

    return Component.element(
      tag: 'details',
      classes: allClasses,
      attributes: <String, String>{if (props.open) 'open': ''},
      events: onOpenChange == null
          ? null
          : <String, EventCallback>{
              'toggle': (Object event) {
                final bool open = domEventCurrentTargetOpen(event);
                if (open != props.open) onOpenChange(open);
              },
            },
      styles: dom.Styles(
        raw: layerStyles(
          <String, String>{
            ...containerStyles(variant),
          },
          <Map<String, String>?>[
            props.decoration?.universalStyles(),
            decorationStyles(props.decoration),
            props.styles?.toMap(),
          ],
        ),
      ),
      children: <Component>[
        // Summary (clickable header)
        Component.element(
          tag: 'summary',
          classes: '$classPrefix-disclosure-summary',
          styles: dom.Styles(raw: summaryStyles(variant)),
          events: onOpenChange == null
              ? null
              : <String, EventCallback>{
                  'click': (Object event) {
                    if (!domEventActivatesSummary(event)) return;
                    domPreventDefault(event);
                    onOpenChange(!props.open);
                  },
                },
          children: <Component>[
            dom.span(
              classes: '$classPrefix-disclosure-summary-content',
              styles: const dom.Styles(
                raw: <String, String>{'flex': '1', 'min-width': '0'},
              ),
              <Component>[props.summary],
            ),
            if (props.showChevron) buildChevron(),
          ],
        ),
        // Content
        dom.div(
          classes:
              '$classPrefix-disclosure-content${props.showTreeLines ? ' arcane-tree-lines' : ''}',
          styles: dom.Styles(
            raw: <String, String>{
              'padding': contentPadding,
              'border-top': contentBorder,
              if (props.showTreeLines) ...<String, String>{
                'padding-left': '1.5rem',
                'position': 'relative',
              },
            },
          ),
          <Component>[props.child],
        ),
      ],
    );
  }
}

/// Shared structural base for themed disclosure-group renderers.
///
/// The group wrapper and item-prop mapping are identical across themes; only the
/// wrapper class prefix and the concrete per-item disclosure component differ.
abstract class DisclosureGroupRenderBase extends StatelessComponent {
  const DisclosureGroupRenderBase(this.props, {super.key});

  final DisclosureGroupProps props;

  /// Theme class prefix (e.g. `'arcane'`, `'neon'`, `'neubrutalism'`).
  String get classPrefix;

  /// Builds the theme's concrete disclosure for a derived item.
  Component buildDisclosure(DisclosureProps itemProps);

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: '$classPrefix-disclosure-group',
      styles: dom.Styles(
        raw: <String, String>{
          'display': 'flex',
          'flex-direction': 'column',
          'gap': props.gap,
        },
      ),
      <Component>[
        for (int i = 0; i < props.items.length; i++)
          buildDisclosure(
            DisclosureProps(
              summary: props.items[i].summary,
              child: props.items[i].content,
              open: i == props.initialOpenIndex,
              variant: props.variant,
              showChevron: props.items[i].showChevron,
            ),
          ),
      ],
    );
  }
}
