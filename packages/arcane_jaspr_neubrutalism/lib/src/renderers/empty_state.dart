import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/empty_state_props.dart';
import 'package:arcane_jaspr/core/rendering/base/empty_state_render_base.dart';

/// Neubrutalism Empty State renderer.
///
/// Implements the Neubrutalism design language:
/// - Larger spacing
/// - Card variant with subtle border
/// - Accent-colored icon
class NeubrutalismEmptyState extends EmptyStateRenderBase {
  const NeubrutalismEmptyState(super.props, {super.key});

  // Neubrutalism sizes
  (String iconSize, String titleSize, String descSize, String gap)
  get _sizeStyles => switch (props.size) {
    EmptyStateSizeVariant.sm => ('48px', '1rem', '0.8125rem', '0.75rem'),
    EmptyStateSizeVariant.md => (
      '64px',
      '1.25rem',
      '0.875rem',
      '1rem',
    ), // Neubrutalism: larger
    EmptyStateSizeVariant.lg => ('80px', '1.5rem', '1rem', '1.25rem'),
  };

  @override
  String get contentClass => 'neubrutalism-empty-state-content';

  @override
  Map<String, String> get contentStyles {
    final (_, _, _, gap) = _sizeStyles;
    return <String, String>{
      'display': 'flex',
      'flex-direction': props.variant == EmptyStateStyleVariant.compact
          ? 'row'
          : 'column',
      'align-items': 'center',
      'text-align': props.variant == EmptyStateStyleVariant.compact
          ? 'left'
          : 'center',
      'gap': gap,
      if (props.variant == EmptyStateStyleVariant.compact) 'text-align': 'left',
    };
  }

  @override
  String get iconClass => 'neubrutalism-empty-state-icon';

  @override
  Map<String, String> get iconStyles {
    final (iconSize, _, _, _) = _sizeStyles;
    return <String, String>{
      'display': 'flex',
      'align-items': 'center',
      'justify-content': 'center',
      'width': iconSize,
      'height': iconSize,
      'padding': '0.5rem',
      'box-sizing': 'border-box',
      'background': 'var(--nb-paper-soft, var(--card))',
      'border': 'var(--nb-border-thick, 3px) solid var(--nb-line, #000)',
      'border-radius': 'var(--nb-radius-tight, 0)',
      'box-shadow':
          'var(--nb-shadow-sm, 3px 3px 0 0 var(--nb-shadow-color, #000))',
      'color': 'var(--nb-accent, var(--primary))',
      'flex-shrink': '0',
      'filter': 'none',
    };
  }

  @override
  String get actionsClass => 'neubrutalism-empty-state-actions';

  @override
  Map<String, String> get actionsStyles => <String, String>{
    'display': 'flex',
    'gap': '0.75rem', // Neubrutalism: more gap
    'margin-top': props.variant == EmptyStateStyleVariant.compact
        ? '0'
        : '0.75rem',
    if (props.variant == EmptyStateStyleVariant.compact) 'margin-left': 'auto',
  };

  @override
  List<Component> buildBody() {
    final (_, titleSize, descSize, _) = _sizeStyles;
    return <Component>[
      // Text content
      dom.div(
        classes: 'neubrutalism-empty-state-text',
        styles: const dom.Styles(
          raw: <String, String>{
            'display': 'flex',
            'flex-direction': 'column',
            'gap': 'var(--space-2)',
          },
        ),
        [
          // Title
          dom.h3(
            classes: 'neubrutalism-empty-state-title',
            styles: dom.Styles(
              raw: <String, String>{
                'font-family': 'var(--font-heading)',
                'font-size': titleSize,
                'font-weight': '900',
                'letter-spacing': '-0.01em',
                'color': 'var(--foreground)',
                'margin': '0',
              },
            ),
            [Component.text(props.title)],
          ),

          // Description
          if (props.description != null)
            dom.p(
              classes: 'neubrutalism-empty-state-description',
              styles: dom.Styles(
                raw: <String, String>{
                  'font-size': descSize,
                  'font-weight': '600',
                  'color': 'var(--muted-foreground)',
                  'margin': '0',
                  'max-width': '420px',
                  'line-height': '1.5',
                },
              ),
              [Component.text(props.description!)],
            ),
        ],
      ),
    ];
  }

  @override
  Component buildRoot(Component content, Map<String, String> extraStyles) {
    // Wrap in card if variant is card
    if (props.variant == EmptyStateStyleVariant.card) {
      return dom.div(
        classes: 'neubrutalism-empty-state neubrutalism-empty-state-card',
        attributes: const <String, String>{
          'data-arcane-surface': 'empty-state-card',
        },
        styles: dom.Styles(
          raw: <String, String>{
            'padding': '2.5rem',
            'background': 'var(--nb-paper, var(--card))',
            'border': 'var(--nb-border-thick, 3px) solid var(--nb-line, #000)',
            'border-radius': 'var(--nb-radius-tight, 0)',
            'box-shadow':
                'var(--nb-shadow-md, 5px 5px 0 0 var(--nb-shadow-color, #000))',
            ...extraStyles,
          },
        ),
        [content],
      );
    }

    return dom.div(
      classes: 'neubrutalism-empty-state',
      styles: dom.Styles(
        raw: <String, String>{
          'padding': props.variant == EmptyStateStyleVariant.compact
              ? '1rem'
              : '2rem', // Neubrutalism: more padding
          ...extraStyles,
        },
      ),
      [content],
    );
  }
}
