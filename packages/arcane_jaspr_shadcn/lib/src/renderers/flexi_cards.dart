import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/flexi_cards_props.dart';

import 'package:arcane_jaspr_shadcn/src/renderers/card.dart';

/// ShadCN FlexiCards renderer (stateful version with hover tracking).
///
/// Uses CSS Grid with `grid-template-rows` for smooth height animations.
/// Text is stabilized by using fixed positioning within the animated container.
class ShadcnFlexiCards extends StatefulComponent {
  final FlexiCardsProps props;

  const ShadcnFlexiCards(this.props, {super.key});

  @override
  State<ShadcnFlexiCards> createState() => _ShadcnFlexiCardsState();
}

class _ShadcnFlexiCardsState extends State<ShadcnFlexiCards> {
  int? _hoveredIndex;

  void _onCardHover(int index) {
    setState(() => _hoveredIndex = index);
  }

  void _onCardLeave() {
    setState(() => _hoveredIndex = null);
  }

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'arcane-flexi-cards',
      styles: dom.Styles(
        raw: {
          'display': 'flex',
          'flex-direction': 'row',
          'gap': component.props.gap,
          'width': '100%',
          'align-items': 'stretch',
        },
      ),
      [
        for (int i = 0; i < component.props.items.length; i++)
          _buildCard(context, i, component.props.items[i]),
      ],
    );
  }

  Component _buildCard(BuildContext context, int index, FlexiCardItem item) {
    final bool isHovered = _hoveredIndex == index;
    final bool hasHoveredCard = _hoveredIndex != null;
    final int duration = component.props.transitionDuration;

    // Calculate flex values
    final double flexValue = isHovered
        ? component.props.expandedFlex
        : (hasHoveredCard
              ? component.props.collapsedFlex * 0.8
              : component.props.collapsedFlex);

    // Calculate height transform if enabled
    final String transform = component.props.scaleHeight && isHovered
        ? 'scale(1, ${component.props.heightScaleFactor})'
        : 'scale(1, 1)';

    // Whether to show expanded content

    final List<Component> cardContent = [
      // Header (optional)
      if (item.header != null)
        dom.div(
          classes: 'arcane-flexi-card-header',
          styles: const dom.Styles(
            raw: {
              'padding': '0.5rem 1rem',
              'border-bottom': '1px solid var(--border)',
              'margin': '-1.5rem -1.5rem 1rem -1.5rem',
            },
          ),
          [item.header!],
        ),

      // Icon
      dom.div(
        classes: 'arcane-flexi-card-icon',
        styles: const dom.Styles(
          raw: {
            'display': 'flex',
            'align-items': 'center',
            'justify-content': 'center',
            'width': '56px',
            'height': '56px',
            'border-radius': 'var(--radius-md, 8px)',
            'background-color': 'var(--accent)',
            'color': 'var(--accent-foreground)',
            'margin-bottom': '1rem',
            'flex-shrink': '0',
          },
        ),
        [item.icon],
      ),

      // Short text (title) - always visible
      dom.div(
        classes: 'arcane-flexi-card-title',
        styles: const dom.Styles(
          raw: {
            'font-size': 'var(--font-size-lg, 1.125rem)',
            'font-weight': 'var(--font-weight-semibold, 600)',
            'color': 'var(--foreground)',
            'margin-bottom': '0.5rem',
          },
        ),
        [Component.text(item.shortText)],
      ),

      // Long text is always present and visible.
      dom.div(
        classes: 'arcane-flexi-card-long-text-wrapper',
        styles: dom.Styles(
          raw: {'display': 'grid', 'grid-template-rows': '1fr'},
        ),
        [
          // Inner wrapper hides overflow and holds the content
          dom.div(
            classes: 'arcane-flexi-card-long-text-inner',
            styles: const dom.Styles(
              raw: {'overflow': 'hidden', 'min-height': '0'},
            ),
            [
              // Actual text content.
              dom.div(
                classes: 'arcane-flexi-card-long-text',
                styles: dom.Styles(
                  raw: {
                    'font-size': 'var(--font-size-base, 1rem)',
                    'line-height': '1.7',
                    'color': 'var(--muted-foreground)',
                    'opacity': '1',
                    'padding-bottom': '1rem',
                  },
                ),
                [Component.text(item.longText)],
              ),
            ],
          ),
        ],
      ),

      // Spacer to push footer to bottom
      const dom.div(styles: dom.Styles(raw: {'flex': '1'}), []),

      // Footer is always present when supplied.
      if (item.footer != null)
        dom.div(
          classes: 'arcane-flexi-card-footer-wrapper',
          styles: dom.Styles(
            raw: {'display': 'grid', 'grid-template-rows': '1fr'},
          ),
          [
            dom.div(
              classes: 'arcane-flexi-card-footer-inner',
              styles: const dom.Styles(
                raw: {'overflow': 'hidden', 'min-height': '0'},
              ),
              [
                dom.div(
                  classes: 'arcane-flexi-card-footer',
                  styles: dom.Styles(
                    raw: {
                      'padding-top': '1rem',
                      'border-top': '1px solid var(--border)',
                      'opacity': '1',
                    },
                  ),
                  [item.footer!],
                ),
              ],
            ),
          ],
        ),
    ];

    // Determine locked dimensions based on hover state
    final bool useLockedWidth =
        component.props.widthPreLock != null ||
        component.props.widthPostLock != null;
    final bool useLockedHeight =
        component.props.heightPreLock != null ||
        component.props.heightPostLock != null;

    // Calculate width - use locked values if provided, otherwise use flex
    String? cardWidth;
    if (useLockedWidth) {
      if (isHovered && component.props.widthPostLock != null) {
        cardWidth = component.props.widthPostLock;
      } else if (component.props.widthPreLock != null) {
        cardWidth = component.props.widthPreLock;
      }
    }

    // Calculate height - use locked values if provided
    String? cardHeight;
    if (useLockedHeight) {
      if (isHovered && component.props.heightPostLock != null) {
        cardHeight = component.props.heightPostLock;
      } else if (component.props.heightPreLock != null) {
        cardHeight = component.props.heightPreLock;
      }
    }

    final bool interactive = item.onTap != null || item.href != null;
    final Map<String, String> cardStyles = {
      // Only use flex if not using locked width
      if (!useLockedWidth) 'flex': '$flexValue',
      'width': ?cardWidth,
      'height': ?cardHeight,
      'min-width': component.props.minCardWidth,
      'display': 'flex',
      'flex-direction': 'column',
      'padding': '1.5rem',
      'background-color': interactive
          ? shadcnInteractiveCardBackground
          : 'var(--card)',
      'color': 'var(--card-foreground)',
      'border': '1px solid var(--border)',
      'border-radius': 'var(--radius-md)',
      'box-shadow': interactive
          ? shadcnInteractiveCardShadow
          : 'var(--shadow-sm)',
      'transform': transform,
      'transform-origin': 'center center',
      'transition':
          'flex ${duration}ms cubic-bezier(0.4, 0, 0.2, 1), '
          'width ${duration}ms cubic-bezier(0.4, 0, 0.2, 1), '
          'transform ${duration}ms cubic-bezier(0.4, 0, 0.2, 1), '
          'border-color ${duration}ms cubic-bezier(0.4, 0, 0.2, 1), '
          'box-shadow ${duration}ms cubic-bezier(0.4, 0, 0.2, 1)',
      'overflow': 'hidden',
      if (interactive) 'cursor': 'pointer',
    };

    // Wrap in link if href provided
    if (item.href != null) {
      return dom.a(
        classes: 'arcane-flexi-card${isHovered ? ' hovered' : ''}',
        attributes: const <String, String>{'data-arcane-surface': 'flexi-card'},
        href: item.href!,
        styles: dom.Styles(raw: {...cardStyles, 'text-decoration': 'none'}),
        events: {
          'mouseenter': (_) => _onCardHover(index),
          'mouseleave': (_) => _onCardLeave(),
        },
        cardContent,
      );
    }

    // Wrap in button if onTap provided
    if (item.onTap != null) {
      return dom.button(
        classes: 'arcane-flexi-card${isHovered ? ' hovered' : ''}',
        attributes: const <String, String>{'data-arcane-surface': 'flexi-card'},
        type: dom.ButtonType.button,
        styles: dom.Styles(raw: {...cardStyles, 'text-align': 'left'}),
        events: {
          'mouseenter': (_) => _onCardHover(index),
          'mouseleave': (_) => _onCardLeave(),
          'click': (_) => item.onTap!(),
        },
        cardContent,
      );
    }

    // Default div
    return dom.div(
      classes: 'arcane-flexi-card${isHovered ? ' hovered' : ''}',
      attributes: const <String, String>{'data-arcane-surface': 'flexi-card'},
      styles: dom.Styles(raw: cardStyles),
      events: {
        'mouseenter': (_) => _onCardHover(index),
        'mouseleave': (_) => _onCardLeave(),
      },
      cardContent,
    );
  }
}

/// ShadCN FlexiCardsSimple renderer (CSS-only hover, no state management).
class ShadcnFlexiCardsSimple extends StatelessComponent {
  final FlexiCardsSimpleProps props;

  const ShadcnFlexiCardsSimple(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'arcane-flexi-cards-simple',
      styles: dom.Styles(
        raw: {
          'display': 'flex',
          'flex-direction': 'row',
          'gap': props.gap,
          'width': '100%',
        },
      ),
      [for (final item in props.items) _buildCard(item)],
    );
  }

  Component _buildCard(FlexiCardItem item) {
    return dom.div(
      classes: 'arcane-flexi-card-simple',
      attributes: const <String, String>{'data-arcane-surface': 'flexi-card'},
      styles: const dom.Styles(
        raw: {
          'flex': '1',
          'min-width': '200px',
          'display': 'flex',
          'flex-direction': 'column',
          'padding': '1.5rem',
          'background-color': 'var(--card)',
          'color': 'var(--card-foreground)',
          'border': '1px solid var(--border)',
          'border-radius': 'var(--radius-md)',
          'box-shadow': 'var(--shadow-sm)',
        },
      ),
      [
        // Icon
        dom.div(
          styles: const dom.Styles(
            raw: {
              'display': 'flex',
              'align-items': 'center',
              'justify-content': 'center',
              'width': '56px',
              'height': '56px',
              'border-radius': 'var(--radius-md)',
              'background-color': 'var(--accent)',
              'color': 'var(--accent-foreground)',
              'margin-bottom': '1rem',
            },
          ),
          [item.icon],
        ),

        // Title
        dom.div(
          classes: 'arcane-flexi-card-simple-title',
          styles: const dom.Styles(
            raw: {
              'font-size': 'var(--font-size-lg)',
              'font-weight': 'var(--font-weight-semibold)',
              'color': 'var(--foreground)',
              'margin-bottom': '0.5rem',
            },
          ),
          [Component.text(item.shortText)],
        ),

        // Description (shown/hidden via CSS)
        dom.div(
          classes: 'arcane-flexi-card-simple-desc',
          styles: const dom.Styles(
            raw: {
              'font-size': 'var(--font-size-base)',
              'line-height': '1.7',
              'color': 'var(--muted-foreground)',
            },
          ),
          [Component.text(item.longText)],
        ),

        // Spacer
        const dom.div(styles: dom.Styles(raw: {'flex': '1'}), []),

        // Footer
        if (item.footer != null)
          dom.div(
            classes: 'arcane-flexi-card-simple-footer',
            styles: const dom.Styles(
              raw: {
                'padding-top': '1rem',
                'border-top': '1px solid var(--border)',
              },
            ),
            [item.footer!],
          ),
      ],
    );
  }
}
