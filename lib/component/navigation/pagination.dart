import 'package:arcane_jaspr/flutter.dart';

import '../../core/decoration/arcane_decoration.dart';
import '../../core/theme_provider.dart';
import '../../util/style_types/arcane_style_data.dart';

export '../../core/props/pagination_props.dart'
    show PaginationStyleVariant, PaginationSizeVariant;

enum PaginationStyle { outline, filled, ghost, simple }

enum PaginationSize { sm, md, lg }

/// Page navigation component.
class ArcanePagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final void Function(int page)? onPageChange;
  final PaginationStyle variant;
  final PaginationSize size;
  final int siblingCount;
  final bool showFirstLast;
  final bool showPrevNext;
  final bool showPageCount;
  final String previousText;
  final String nextText;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation + theme-specific fields).
  final ArcaneDecoration? decoration;

  const ArcanePagination({
    required this.currentPage,
    required this.totalPages,
    this.onPageChange,
    this.variant = PaginationStyle.outline,
    this.size = PaginationSize.md,
    this.siblingCount = 1,
    this.showFirstLast = true,
    this.showPrevNext = true,
    this.showPageCount = false,
    this.previousText = '\u{2190}',
    this.nextText = '\u{2192}',
    this.styles,
    this.decoration,
    super.key,
  });

  const ArcanePagination.simple({
    required this.currentPage,
    required this.totalPages,
    this.onPageChange,
    this.size = PaginationSize.md,
    this.previousText = '\u{2190} Previous',
    this.nextText = 'Next \u{2192}',
    this.styles,
    this.decoration,
    super.key,
  }) : variant = PaginationStyle.simple,
       siblingCount = 0,
       showFirstLast = false,
       showPrevNext = true,
       showPageCount = true;

  List<int?> _getPageNumbers() {
    if (totalPages <= 5 + 2 * siblingCount) {
      return List<int?>.generate(totalPages, (int index) => index + 1);
    }
    final List<int?> pages = [];
    final int leftSiblingIndex = (currentPage - siblingCount).clamp(
      1,
      totalPages,
    );
    final int rightSiblingIndex = (currentPage + siblingCount).clamp(
      1,
      totalPages,
    );

    final bool showLeftDots = leftSiblingIndex > 2;
    final bool showRightDots = rightSiblingIndex < totalPages - 1;

    if (!showLeftDots && showRightDots) {
      for (var i = 1; i <= 3 + 2 * siblingCount && i <= totalPages; i++) {
        pages.add(i);
      }
      pages.add(null);
      pages.add(totalPages);
    } else if (showLeftDots && !showRightDots) {
      pages.add(1);
      pages.add(null);
      for (var i = totalPages - (2 + 2 * siblingCount); i <= totalPages; i++) {
        if (i > 1) pages.add(i);
      }
    } else if (showLeftDots && showRightDots) {
      pages.add(1);
      pages.add(null);
      for (var i = leftSiblingIndex; i <= rightSiblingIndex; i++) {
        pages.add(i);
      }
      pages.add(null);
      pages.add(totalPages);
    } else {
      for (var i = 1; i <= totalPages; i++) {
        pages.add(i);
      }
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final styleVariant = switch (variant) {
      PaginationStyle.outline => PaginationStyleVariant.outline,
      PaginationStyle.filled => PaginationStyleVariant.filled,
      PaginationStyle.ghost => PaginationStyleVariant.ghost,
      PaginationStyle.simple => PaginationStyleVariant.simple,
    };

    final sizeVariant = switch (size) {
      PaginationSize.sm => PaginationSizeVariant.sm,
      PaginationSize.md => PaginationSizeVariant.md,
      PaginationSize.lg => PaginationSizeVariant.lg,
    };

    return context.renderers.pagination(
      PaginationProps(
        currentPage: currentPage,
        totalPages: totalPages,
        onPageChange: onPageChange,
        variant: styleVariant,
        size: sizeVariant,
        siblingCount: siblingCount,
        showFirstLast: showFirstLast,
        showPrevNext: showPrevNext,
        showPageCount: showPageCount,
        previousText: previousText,
        nextText: nextText,
        pageNumbers: _getPageNumbers(),
        styles: styles,
        decoration: decoration,
      ),
    );
  }
}
