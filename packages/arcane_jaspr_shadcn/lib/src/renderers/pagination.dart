import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/component/view/icon.dart';
import 'package:arcane_jaspr/core/props/pagination_props.dart';

/// Arrow runs at either end of `previousText`/`nextText` (the defaults are
/// `<-` and `->`); the renderer draws a Lucide chevron instead, so they are
/// stripped from the label.
final RegExp _arrowGlyphs = RegExp(r'^[\s<>\-←→‹›«»]+|[\s<>\-←→‹›«»]+$');

/// ShadCN-style pagination component.
///
/// v4 PaginationLink is a ghost button (`size-9 rounded-md text-sm`) whose
/// active page switches to the outline variant (`border bg-background
/// shadow-xs`). Background, foreground, border colour and shadow route
/// through variables so the surfaces stylesheet can paint hover and
/// `:focus-visible`. Previous/next carry Lucide chevrons and the ellipsis is
/// the Lucide MoreHorizontal glyph.
///
/// Reference: https://ui.shadcn.com/docs/components/pagination
class ShadcnPagination extends StatelessComponent {
  final PaginationProps props;

  const ShadcnPagination(this.props, {super.key});

  /// (horizontal padding, box size) per size step: v4 `h-8`, `h-9`, `h-10`.
  (String padding, String size) get _sizeStyles => switch (props.size) {
    PaginationSizeVariant.sm => ('0 0.625rem', '2rem'),
    PaginationSizeVariant.md => ('0 0.75rem', '2.25rem'),
    PaginationSizeVariant.lg => ('0 1rem', '2.5rem'),
  };

  static String _stripArrows(String text) => text.replaceAll(_arrowGlyphs, '');

  @override
  Component build(BuildContext context) {
    final (String padding, String size) = _sizeStyles;

    if (props.variant == PaginationStyleVariant.simple) {
      return _buildSimplePagination(padding);
    }

    return dom.nav(
      classes: 'arcane-pagination',
      attributes: const <String, String>{
        'aria-label': 'Pagination',
        'role': 'navigation',
      },
      styles: const dom.Styles(
        raw: <String, String>{
          'display': 'flex',
          'width': '100%',
          'justify-content': 'center',
        },
      ),
      <Component>[
        dom.ul(
          classes: 'arcane-pagination-content',
          styles: const dom.Styles(
            raw: <String, String>{
              'display': 'flex',
              'flex-direction': 'row',
              'align-items': 'center',
              'gap': '0.25rem',
              'list-style': 'none',
              'margin': '0',
              'padding': '0',
            },
          ),
          <Component>[
            if (props.showFirstLast && props.totalPages > 3)
              dom.li(<Component>[
                _buildButton(
                  content: <Component>[
                    ArcaneIcon.chevronsLeft(size: IconSize.sm),
                  ],
                  label: 'Go to first page',
                  page: 1,
                  disabled: props.currentPage == 1,
                  padding: padding,
                  size: size,
                ),
              ]),
            if (props.showPrevNext)
              dom.li(<Component>[
                _buildPrevNext(
                  isNext: false,
                  disabled: props.currentPage == 1,
                  size: size,
                ),
              ]),
            for (final int? page in props.pageNumbers)
              dom.li(<Component>[
                if (page == null)
                  dom.span(
                    classes: 'arcane-pagination-ellipsis',
                    attributes: const <String, String>{'aria-hidden': 'true'},
                    styles: dom.Styles(
                      raw: <String, String>{
                        'display': 'flex',
                        'align-items': 'center',
                        'justify-content': 'center',
                        'width': size,
                        'height': size,
                      },
                    ),
                    <Component>[ArcaneIcon.moreHorizontal(size: IconSize.sm)],
                  )
                else
                  _buildButton(
                    content: <Component>[Component.text(page.toString())],
                    page: page,
                    isActive: page == props.currentPage,
                    padding: padding,
                    size: size,
                  ),
              ]),
            if (props.showPrevNext)
              dom.li(<Component>[
                _buildPrevNext(
                  isNext: true,
                  disabled: props.currentPage == props.totalPages,
                  size: size,
                ),
              ]),
            if (props.showFirstLast && props.totalPages > 3)
              dom.li(<Component>[
                _buildButton(
                  content: <Component>[
                    ArcaneIcon.chevronsRight(size: IconSize.sm),
                  ],
                  label: 'Go to last page',
                  page: props.totalPages,
                  disabled: props.currentPage == props.totalPages,
                  padding: padding,
                  size: size,
                ),
              ]),
          ],
        ),
      ],
    );
  }

  /// v4 PaginationPrevious/Next: `gap-1 px-2.5` with a chevron beside the
  /// label; a label that is only an arrow glyph collapses to the chevron.
  Component _buildPrevNext({
    required bool isNext,
    required bool disabled,
    required String size,
  }) {
    final String text = _stripArrows(
      isNext ? props.nextText : props.previousText,
    );
    final Component chevron = isNext
        ? ArcaneIcon.chevronRight(size: IconSize.sm)
        : ArcaneIcon.chevronLeft(size: IconSize.sm);
    return _buildButton(
      content: <Component>[
        if (!isNext) chevron,
        if (text.isNotEmpty) dom.span(<Component>[Component.text(text)]),
        if (isNext) chevron,
      ],
      label: isNext ? 'Go to next page' : 'Go to previous page',
      page: isNext ? props.currentPage + 1 : props.currentPage - 1,
      disabled: disabled,
      padding: text.isEmpty ? '0' : '0 0.625rem',
      size: size,
      gap: '0.25rem',
    );
  }

  Component _buildSimplePagination(String padding) {
    final bool atStart = props.currentPage == 1;
    final bool atEnd = props.currentPage == props.totalPages;

    Map<String, String> simpleButton(bool disabled) => <String, String>{
      'padding': padding,
      'font-size': '0.875rem',
      'background': 'transparent',
      'border': 'none',
      'color': 'var(--primary)',
      'cursor': 'pointer',
      if (disabled) 'pointer-events': 'none',
      if (disabled) 'opacity': '0.5',
    };

    return dom.nav(
      attributes: const <String, String>{'aria-label': 'Pagination'},
      styles: const dom.Styles(
        raw: <String, String>{
          'display': 'flex',
          'align-items': 'center',
          'justify-content': 'space-between',
          'gap': '1rem',
        },
      ),
      <Component>[
        dom.button(
          attributes: <String, String>{
            'type': 'button',
            if (atStart) 'disabled': 'true',
          },
          styles: dom.Styles(raw: simpleButton(atStart)),
          events: atStart
              ? null
              : <String, EventCallback>{
                  'click': (_) =>
                      props.onPageChange?.call(props.currentPage - 1),
                },
          <Component>[Component.text(props.previousText)],
        ),
        if (props.showPageCount)
          dom.span(
            styles: const dom.Styles(
              raw: <String, String>{
                'font-size': '0.875rem',
                'color': 'var(--muted-foreground)',
              },
            ),
            <Component>[
              Component.text(
                'Page ${props.currentPage} of ${props.totalPages}',
              ),
            ],
          ),
        dom.button(
          attributes: <String, String>{
            'type': 'button',
            if (atEnd) 'disabled': 'true',
          },
          styles: dom.Styles(raw: simpleButton(atEnd)),
          events: atEnd
              ? null
              : <String, EventCallback>{
                  'click': (_) =>
                      props.onPageChange?.call(props.currentPage + 1),
                },
          <Component>[Component.text(props.nextText)],
        ),
      ],
    );
  }

  Component _buildButton({
    required List<Component> content,
    required int page,
    required String padding,
    required String size,
    String? label,
    String? gap,
    bool isActive = false,
    bool disabled = false,
  }) {
    final bool outlined =
        isActive && props.variant == PaginationStyleVariant.outline;
    final bool filled =
        isActive &&
        (props.variant == PaginationStyleVariant.filled ||
            props.variant == PaginationStyleVariant.ghost);

    return dom.button(
      classes:
          'arcane-pagination-link${isActive ? ' active' : ''}${disabled ? ' disabled' : ''}',
      attributes: <String, String>{
        'type': 'button',
        'aria-label': ?label,
        if (disabled) 'disabled': 'true',
        if (isActive) 'aria-current': 'page',
        'data-state': isActive ? 'active' : 'inactive',
        'data-disabled': '$disabled',
      },
      styles: dom.Styles(
        raw: <String, String>{
          'display': 'inline-flex',
          'align-items': 'center',
          'justify-content': 'center',
          'gap': ?gap,
          'box-sizing': 'border-box',
          'white-space': 'nowrap',
          'height': size,
          'min-width': size,
          'padding': padding,
          'border':
              '1px solid var(--shadcn-control-border-color, ${outlined ? 'var(--input)' : 'transparent'})',
          'border-radius': 'var(--radius-md)',
          'background-color':
              'var(--shadcn-item-background, ${outlined
                  ? 'var(--background)'
                  : filled
                  ? 'var(--accent)'
                  : 'transparent'})',
          'color':
              'var(--shadcn-item-foreground, ${filled ? 'var(--accent-foreground)' : 'var(--foreground)'})',
          'box-shadow':
              'var(--shadcn-control-shadow, ${outlined ? 'var(--shadow-xs)' : 'none'})',
          'font-size': '0.875rem',
          'line-height': '1.25rem',
          'font-weight': '500',
          'outline': 'none',
          'cursor': 'pointer',
          'transition':
              'color var(--transition), background-color var(--transition), box-shadow var(--transition)',
          if (disabled) 'pointer-events': 'none',
          if (disabled) 'opacity': '0.5',
          ...?props.decoration?.universalStyles(),
          ...?props.styles?.toMap(),
        },
      ),
      events: disabled
          ? null
          : <String, EventCallback>{
              'click': (_) => props.onPageChange?.call(page),
            },
      content,
    );
  }
}
