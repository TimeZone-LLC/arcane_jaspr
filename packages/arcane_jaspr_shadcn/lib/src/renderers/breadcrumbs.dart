import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/component/view/icon.dart';
import 'package:arcane_jaspr/core/props/breadcrumbs_props.dart';

/// ShadCN-style breadcrumbs component.
///
/// v4 BreadcrumbList: `text-muted-foreground flex flex-wrap items-center
/// gap-1.5 text-sm break-words sm:gap-2.5`; separators are a Lucide
/// ChevronRight at `size-3.5`; links shift to `text-foreground` on hover; the
/// current page is `text-foreground font-normal`.
///
/// Reference: https://ui.shadcn.com/docs/components/breadcrumb
class ShadcnBreadcrumbs extends StatelessComponent {
  final BreadcrumbsProps props;

  const ShadcnBreadcrumbs(this.props, {super.key});

  String get _fontSize => switch (props.size) {
    BreadcrumbSizeVariant.sm => '0.75rem',
    BreadcrumbSizeVariant.md => '0.875rem',
    BreadcrumbSizeVariant.lg => '1rem',
  };

  Component get _separator => switch (props.separator) {
    BreadcrumbSeparatorStyle.chevron => ArcaneIcon.chevronRight(
      size: IconSize.sm,
    ),
    BreadcrumbSeparatorStyle.slash => const Component.text('/'),
    BreadcrumbSeparatorStyle.arrow => const Component.text('\u{2192}'),
    BreadcrumbSeparatorStyle.dot => const Component.text('\u{2022}'),
  };

  @override
  Component build(BuildContext context) {
    return dom.nav(
      classes: 'arcane-breadcrumb',
      attributes: const <String, String>{'aria-label': 'Breadcrumb'},
      styles: dom.Styles(
        raw: <String, String>{
          'display': 'flex',
          'align-items': 'center',
          ...?props.decoration?.universalStyles(),
          ...?props.styles?.toMap(),
        },
      ),
      <Component>[
        dom.ol(
          classes: 'arcane-breadcrumb-list',
          styles: dom.Styles(
            raw: <String, String>{
              'display': 'flex',
              'flex-wrap': 'wrap',
              'align-items': 'center',
              // Widened to 0.625rem at the `sm` breakpoint by the stylesheet.
              'gap': 'var(--shadcn-breadcrumb-gap, 0.375rem)',
              'list-style': 'none',
              'margin': '0',
              'padding': '0',
              'font-size': _fontSize,
              'line-height': '1.25rem',
              'color': 'var(--muted-foreground)',
              'word-break': 'break-word',
            },
          ),
          <Component>[
            for (int i = 0; i < props.items.length; i++) ...<Component>[
              dom.li(
                classes: 'arcane-breadcrumb-item',
                styles: const dom.Styles(
                  raw: <String, String>{
                    'display': 'inline-flex',
                    'align-items': 'center',
                    'gap': '0.375rem',
                  },
                ),
                <Component>[
                  _buildBreadcrumbItem(
                    props.items[i],
                    i,
                    i == props.items.length - 1,
                  ),
                ],
              ),
              if (i < props.items.length - 1)
                dom.li(
                  classes: 'arcane-breadcrumb-separator',
                  attributes: const <String, String>{
                    'role': 'presentation',
                    'aria-hidden': 'true',
                  },
                  styles: const dom.Styles(
                    raw: <String, String>{
                      'display': 'flex',
                      'align-items': 'center',
                      'user-select': 'none',
                    },
                  ),
                  <Component>[props.customSeparator ?? _separator],
                ),
            ],
          ],
        ),
      ],
    );
  }

  Component _buildBreadcrumbItem(
    BreadcrumbItemProps item,
    int index,
    bool isLast,
  ) {
    final Component content = dom.span(
      styles: const dom.Styles(
        raw: <String, String>{
          'display': 'inline-flex',
          'align-items': 'center',
          'gap': '0.375rem',
        },
      ),
      <Component>[
        if (item.icon != null) item.icon!,
        if (props.showHomeIcon && index == 0 && item.icon == null)
          ArcaneIcon.house(size: IconSize.sm),
        Component.text(item.label),
      ],
    );

    if (isLast || item.href == null) {
      // ShadCN BreadcrumbPage
      return dom.span(
        classes: 'arcane-breadcrumb-page',
        attributes: <String, String>{
          if (isLast) 'aria-current': 'page',
          if (isLast) 'aria-disabled': 'true',
        },
        styles: const dom.Styles(
          raw: <String, String>{
            'color': 'var(--foreground)',
            'font-weight': '400',
          },
        ),
        <Component>[content],
      );
    }

    // ShadCN BreadcrumbLink: hover:text-foreground transition-colors
    return dom.a(
      classes: 'arcane-breadcrumb-link',
      href: item.href!,
      styles: const dom.Styles(
        raw: <String, String>{
          'color': 'var(--shadcn-item-foreground, inherit)',
          'text-decoration': 'none',
          'border-radius': 'var(--radius-xs)',
          'outline': 'none',
          'box-shadow': 'var(--shadcn-control-shadow, none)',
          'transition': 'color var(--transition), box-shadow var(--transition)',
        },
      ),
      events: props.onItemClick != null
          ? <String, EventCallback>{
              'click': (event) {
                props.onItemClick!(item, index);
              },
            }
          : null,
      <Component>[content],
    );
  }
}
