import 'package:arcane_jaspr/flutter.dart';

import '../../core/theme_provider.dart';

export '../../core/props/scroll_area_props.dart'
    show
        ScrollDirectionVariant,
        ScrollbarVisibilityVariant,
        ScrollbarStyleVariant,
        ScrollAreaProps,
        VirtualScrollProps;

typedef ScrollDirection = ScrollDirectionVariant;
typedef ScrollbarVisibility = ScrollbarVisibilityVariant;
typedef ScrollbarStyle = ScrollbarStyleVariant;

/// A scrollable area with custom styled scrollbars.
class ArcaneScrollArea extends StatelessWidget {
  final Widget child;
  final String? height;
  final String? width;
  final String? maxHeight;
  final String? maxWidth;
  final ScrollDirection direction;
  final ScrollbarVisibility scrollbar;
  final ScrollbarStyle scrollbarStyle;
  final String? trackColor;
  final String? thumbColor;
  final String scrollbarSize;
  final String? padding;
  final String? className;

  const ArcaneScrollArea({
    required this.child,
    this.height,
    this.width,
    this.maxHeight,
    this.maxWidth,
    this.direction = ScrollDirection.vertical,
    this.scrollbar = ScrollbarVisibility.hover,
    this.scrollbarStyle = ScrollbarStyle.thin,
    this.trackColor,
    this.thumbColor,
    this.scrollbarSize = '8px',
    this.padding,
    this.className,
    super.key,
  });

  const ArcaneScrollArea.vertical({
    required this.child,
    required String this.height,
    this.maxHeight,
    this.scrollbar = ScrollbarVisibility.hover,
    this.scrollbarStyle = ScrollbarStyle.thin,
    this.thumbColor,
    this.trackColor,
    this.padding,
    this.className,
    super.key,
  }) : width = null,
       maxWidth = null,
       direction = ScrollDirection.vertical,
       scrollbarSize = '8px';

  const ArcaneScrollArea.horizontal({
    required this.child,
    required String this.width,
    this.maxWidth,
    this.scrollbar = ScrollbarVisibility.hover,
    this.scrollbarStyle = ScrollbarStyle.thin,
    this.thumbColor,
    this.trackColor,
    this.padding,
    this.className,
    super.key,
  }) : height = null,
       maxHeight = null,
       direction = ScrollDirection.horizontal,
       scrollbarSize = '8px';

  ScrollDirectionVariant get _propsDirection => switch (direction) {
    ScrollDirection.vertical => ScrollDirectionVariant.vertical,
    ScrollDirection.horizontal => ScrollDirectionVariant.horizontal,
    ScrollDirection.both => ScrollDirectionVariant.both,
  };

  ScrollbarVisibilityVariant get _propsScrollbar => switch (scrollbar) {
    ScrollbarVisibility.always => ScrollbarVisibilityVariant.always,
    ScrollbarVisibility.hover => ScrollbarVisibilityVariant.hover,
    ScrollbarVisibility.auto_ => ScrollbarVisibilityVariant.auto_,
    ScrollbarVisibility.hidden => ScrollbarVisibilityVariant.hidden,
  };

  ScrollbarStyleVariant get _propsScrollbarStyle => switch (scrollbarStyle) {
    ScrollbarStyle.default_ => ScrollbarStyleVariant.default_,
    ScrollbarStyle.thin => ScrollbarStyleVariant.thin,
    ScrollbarStyle.minimal => ScrollbarStyleVariant.minimal,
    ScrollbarStyle.custom => ScrollbarStyleVariant.custom,
  };

  @override
  Widget build(BuildContext context) {
    return context.renderers.scrollArea(
      ScrollAreaProps(
        child: child,
        height: height,
        width: width,
        maxHeight: maxHeight,
        maxWidth: maxWidth,
        direction: _propsDirection,
        scrollbar: _propsScrollbar,
        scrollbarStyle: _propsScrollbarStyle,
        trackColor: trackColor,
        thumbColor: thumbColor,
        scrollbarSize: scrollbarSize,
        padding: padding,
        className: className,
        instanceId: identityHashCode(this),
      ),
    );
  }
}

/// A virtualized scroll list for large datasets.
class ArcaneVirtualScroll<T> extends StatefulWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final double itemHeight;
  final String height;
  final int overscan;

  const ArcaneVirtualScroll({
    required this.items,
    required this.itemBuilder,
    required this.itemHeight,
    required this.height,
    this.overscan = 3,
    super.key,
  });

  @override
  State<ArcaneVirtualScroll<T>> createState() => _ArcaneVirtualScrollState<T>();
}

class _ArcaneVirtualScrollState<T> extends State<ArcaneVirtualScroll<T>> {
  double _scrollTop = 0;

  @override
  Widget build(BuildContext context) {
    return context.renderers.virtualScroll<T>(
      VirtualScrollProps<T>(
        items: widget.items,
        itemBuilder: widget.itemBuilder,
        itemHeight: widget.itemHeight,
        height: widget.height,
        overscan: widget.overscan,
        scrollTop: _scrollTop,
        onScroll: (scrollTop) => setState(() => _scrollTop = scrollTop),
      ),
    );
  }
}
