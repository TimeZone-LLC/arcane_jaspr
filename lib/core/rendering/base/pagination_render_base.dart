import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/props/pagination_props.dart';

/// Shared structural base for the Neon-family pagination renderers.
///
/// The Neon and Neubrutalism paginations share an identical structure (a `nav`
/// holding the first/prev/page/next/last buttons and an optional page-count
/// span directly). They differ only in the CSS class prefix and the per-variant
/// button styles. This base factors the shared layout, the button scaffold and
/// the ellipsis, leaving those values to the concrete renderer.
///
/// The ShadCN pagination uses a different DOM (a `ul`/`li` list with a separate
/// simple-pagination path) and therefore does not extend this base.
///
/// This base lives in core and depends only on core props; it must never
/// depend on a theme package.
abstract class PaginationRenderBase extends StatelessComponent {
  const PaginationRenderBase(this.props, {super.key});

  final PaginationProps props;

  /// CSS class prefix (e.g. `'neon'`, `'neubrutalism'`).
  String get themePrefix;

  /// Per-variant button styles merged onto the shared button styles. The switch
  /// over [PaginationProps.variant] lives in the concrete renderer because the
  /// values are entirely theme-specific.
  Map<String, String> buttonStyleVariant(bool isActive);

  /// Per-instance decoration overrides. Default: none. A theme overrides this
  /// to translate an [ArcaneDecoration] (elevation intent, theme-specific
  /// fields) into its own CSS. Fields a theme does not implement are ignored.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  @override
  Component build(BuildContext context) {
    final (String buttonSize, String fontSize, String gap) = switch (props
        .size) {
      PaginationSizeVariant.sm => ('32px', '0.75rem', '0.375rem'),
      PaginationSizeVariant.md => ('40px', '0.875rem', '0.5rem'),
      PaginationSizeVariant.lg => ('48px', '1rem', '0.625rem'),
    };

    return dom.nav(
      classes: '$themePrefix-pagination',
      attributes: <String, String>{'aria-label': 'Pagination'},
      styles: dom.Styles(
        raw: <String, String>{
          'display': 'flex',
          'align-items': 'center',
          'gap': gap,
        },
      ),
      <Component>[
        if (props.showFirstLast && props.totalPages > 2)
          _buildButton(
            text: '«',
            page: 1,
            disabled: props.currentPage == 1,
            buttonSize: buttonSize,
            fontSize: fontSize,
          ),
        if (props.showPrevNext)
          _buildButton(
            text: props.previousText,
            page: props.currentPage - 1,
            disabled: props.currentPage == 1,
            buttonSize: buttonSize,
            fontSize: fontSize,
          ),
        for (final int? pageNum in props.pageNumbers)
          if (pageNum == null)
            _buildEllipsis(fontSize)
          else
            _buildButton(
              text: '$pageNum',
              page: pageNum,
              isActive: pageNum == props.currentPage,
              buttonSize: buttonSize,
              fontSize: fontSize,
            ),
        if (props.showPrevNext)
          _buildButton(
            text: props.nextText,
            page: props.currentPage + 1,
            disabled: props.currentPage == props.totalPages,
            buttonSize: buttonSize,
            fontSize: fontSize,
          ),
        if (props.showFirstLast && props.totalPages > 2)
          _buildButton(
            text: '»',
            page: props.totalPages,
            disabled: props.currentPage == props.totalPages,
            buttonSize: buttonSize,
            fontSize: fontSize,
          ),
        if (props.showPageCount)
          dom.span(
            styles: dom.Styles(
              raw: <String, String>{
                'margin-left': '0.75rem',
                'font-size': fontSize,
                'color': 'var(--muted-foreground)',
              },
            ),
            <Component>[
              Component.text('Page ${props.currentPage} of ${props.totalPages}'),
            ],
          ),
      ],
    );
  }

  Component _buildButton({
    required String text,
    required int page,
    bool isActive = false,
    bool disabled = false,
    required String buttonSize,
    required String fontSize,
  }) {
    final Map<String, String> styleVariant = buttonStyleVariant(isActive);

    return dom.button(
      classes:
          '$themePrefix-pagination-button ${isActive ? 'active' : ''} ${disabled ? 'disabled' : ''}',
      attributes: <String, String>{
        'type': 'button',
        if (disabled) 'disabled': 'true',
        if (isActive) 'aria-current': 'page',
      },
      styles: dom.Styles(
        raw: <String, String>{
          'display': 'inline-flex',
          'align-items': 'center',
          'justify-content': 'center',
          'min-width': buttonSize,
          'height': buttonSize,
          'padding': '0 0.75rem',
          'font-size': fontSize,
          'font-weight': '600',
          'font-variant-numeric': 'tabular-nums',
          'cursor': disabled ? 'not-allowed' : 'pointer',
          'transition':
              'background 0.18s ease, color 0.18s ease, box-shadow 0.18s ease, border-color 0.18s ease',
          'opacity': disabled ? '0.45' : '1',
          ...styleVariant,
          ...?props.decoration?.universalStyles(),
          ...decorationStyles(props.decoration),
          ...?props.styles?.toMap(),
        },
      ),
      events: disabled || props.onPageChange == null
          ? null
          : <String, EventCallback>{'click': (_) => props.onPageChange!(page)},
      <Component>[Component.text(text)],
    );
  }

  Component _buildEllipsis(String fontSize) {
    return dom.span(
      classes: '$themePrefix-pagination-ellipsis',
      attributes: const <String, String>{'aria-hidden': 'true'},
      styles: dom.Styles(
        raw: <String, String>{
          'display': 'inline-flex',
          'align-items': 'center',
          'justify-content': 'center',
          'padding': '0 0.375rem',
          'font-size': fontSize,
          'color': 'var(--muted-foreground)',
        },
      ),
      <Component>[const Component.text('…')],
    );
  }
}
