import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/component/view/icon.dart';
import 'package:arcane_jaspr/core/props/accordion_props.dart';

/// ShadCN Accordion renderer.
///
/// Uses native HTML details/summary elements for reliable expand/collapse
/// behavior that works in SSR environments without JavaScript hydration issues.
///
/// Mirrors v4: items are square rows divided by a `border-b` (the last row
/// drops it), the trigger is `py-4 text-sm font-medium` with a Lucide
/// ChevronDown that the surfaces stylesheet rotates on `[open]`, and the
/// content is `pb-4 text-sm`.
///
/// Reference: https://ui.shadcn.com/docs/components/accordion
class ShadcnAccordion extends StatelessComponent {
  final AccordionProps props;

  const ShadcnAccordion(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'arcane-accordion faq-container',
      styles: dom.Styles(
        raw: <String, String>{
          'display': 'flex',
          'flex-direction': 'column',
          'width': '100%',
          if (props.bordered) ...<String, String>{
            'border': '1px solid var(--border)',
            'border-radius': 'var(--radius-md)',
            'padding': '0 1rem',
            'overflow': 'hidden',
          },
          ...?props.decoration?.universalStyles(),
          ...?props.styles?.toMap(),
        },
      ),
      <Component>[
        for (int i = 0; i < props.items.length; i++)
          _buildItem(
            props.items[i],
            props.openItems.contains(i),
            isLast: i == props.items.length - 1,
          ),
      ],
    );
  }

  Component _buildItem(
    AccordionItemProps item,
    bool defaultOpen, {
    required bool isLast,
  }) {
    return Component.element(
      tag: 'details',
      classes: 'arcane-accordion-item',
      attributes: <String, String>{if (defaultOpen) 'open': ''},
      // A square row, so the divider is not an edge accent on a rounded box.
      styles: dom.Styles(
        raw: <String, String>{
          'border-radius': '0',
          if (!isLast) 'border-bottom': '1px solid var(--border)',
        },
      ),
      children: <Component>[
        Component.element(
          tag: 'summary',
          classes: 'arcane-accordion-trigger',
          styles: const dom.Styles(
            raw: <String, String>{
              'display': 'flex',
              'align-items': 'flex-start',
              'justify-content': 'space-between',
              'gap': '1rem',
              'padding': '1rem 0',
              'border-radius': 'var(--radius-md)',
              'font-size': '0.875rem',
              'line-height': '1.25rem',
              'font-weight': '500',
              'text-align': 'left',
              'color': 'var(--foreground)',
              'cursor': 'pointer',
              'list-style': 'none',
              'outline': 'none',
              'box-shadow': 'var(--shadcn-control-shadow, none)',
              '-webkit-user-select': 'none',
              'user-select': 'none',
            },
          ),
          children: <Component>[
            dom.span(
              classes: 'arcane-accordion-title',
              styles: const dom.Styles(
                raw: <String, String>{'flex': '1', 'min-width': '0'},
              ),
              <Component>[Component.text(item.title)],
            ),
            dom.span(
              classes: 'arcane-accordion-chevron',
              styles: const dom.Styles(
                raw: <String, String>{
                  'display': 'flex',
                  'flex-shrink': '0',
                  'margin-top': '0.125rem',
                  'color': 'var(--muted-foreground)',
                  'pointer-events': 'none',
                  'transition': 'transform 200ms ease',
                },
              ),
              <Component>[ArcaneIcon.chevronDown(size: IconSize.sm)],
            ),
          ],
        ),
        dom.div(
          classes: 'arcane-accordion-content',
          styles: const dom.Styles(
            raw: <String, String>{
              'padding-bottom': '1rem',
              'font-size': '0.875rem',
              'line-height': '1.25rem',
            },
          ),
          <Component>[item.customContent ?? Component.text(item.content)],
        ),
      ],
    );
  }
}
