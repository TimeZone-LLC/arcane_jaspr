import 'package:arcane_jaspr/flutter.dart';
import 'package:jaspr/dom.dart'
    hide
        Color,
        Colors,
        ColorScheme,
        Gap,
        Padding,
        TextAlign,
        TextOverflow,
        Border,
        BorderRadius,
        Radius,
        BoxShadow,
        FontWeight,
        FontStyle,
        StyleRule,
        Display,
        Position,
        Overflow,
        Cursor,
        Visibility,
        FlexWrap,
        WhiteSpace;

import 'package:arcane_jaspr/core/theme_provider.dart';
import 'package:arcane_jaspr/util/arcane.dart';
import 'package:arcane_jaspr/util/appearance/colors.dart';
import 'package:arcane_jaspr/util/style_types/index.dart';

/// Alignment of children across a run in a [Wrap].
enum WrapCrossAlignment { start, end, center }

/// Places children in runs when they exceed the available space.
class Wrap extends StatelessWidget {
  final List<Widget> children;
  final Axis direction;
  final WrapAlignment alignment;
  final WrapCrossAlignment crossAxisAlignment;
  final WrapAlignment runAlignment;
  final double spacing;
  final double runSpacing;
  final bool reverse;

  const Wrap({
    this.children = const <Widget>[],
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.runAlignment = WrapAlignment.start,
    this.spacing = 0,
    this.runSpacing = 0,
    this.reverse = false,
    super.key,
  }) : assert(spacing >= 0),
       assert(runSpacing >= 0);

  @override
  Widget build(BuildContext context) {
    return context.renderers.flow(
      FlowProps(
        children: children,
        direction: direction,
        mainAxisAlignment: switch (alignment) {
          WrapAlignment.start => MainAxisAlignment.start,
          WrapAlignment.end => MainAxisAlignment.end,
          WrapAlignment.center => MainAxisAlignment.center,
          WrapAlignment.spaceBetween => MainAxisAlignment.spaceBetween,
          WrapAlignment.spaceAround => MainAxisAlignment.spaceAround,
          WrapAlignment.spaceEvenly => MainAxisAlignment.spaceEvenly,
        },
        crossAxisAlignment: switch (crossAxisAlignment) {
          WrapCrossAlignment.start => CrossAxisAlignment.start,
          WrapCrossAlignment.end => CrossAxisAlignment.end,
          WrapCrossAlignment.center => CrossAxisAlignment.center,
        },
        wrapAlignment: runAlignment,
        gap: 0,
        rowGap: direction == Axis.horizontal ? runSpacing : spacing,
        columnGap: direction == Axis.horizontal ? spacing : runSpacing,
        reverse: reverse,
      ),
    );
  }
}

/// A flex layout whose main axis can change at runtime.
class Flex extends StatelessWidget {
  final Axis direction;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double spacing;
  final Gap? gapSize;
  final ArcaneStyleData? style;

  const Flex({
    required this.direction,
    this.children = const <Widget>[],
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.spacing = 0,
    this.gapSize,
    this.style,
    super.key,
  }) : assert(spacing >= 0);

  @override
  Widget build(BuildContext context) {
    final bool horizontal = direction == Axis.horizontal;
    if (style == null && gapSize == null) {
      if (horizontal) {
        return context.renderers.row(
          RowProps(
            children: children,
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            mainAxisSize: mainAxisSize,
            gap: spacing,
          ),
        );
      }
      return context.renderers.column(
        ColumnProps(
          children: children,
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: mainAxisSize,
          gap: spacing,
        ),
      );
    }

    final Map<String, String> baseStyles = <String, String>{
      'display': 'flex',
      'flex-direction': horizontal ? 'row' : 'column',
      'justify-content': mainAxisAlignment.css,
      'align-items': crossAxisAlignment.css,
      if (mainAxisSize == MainAxisSize.max)
        horizontal ? 'width' : 'height': '100%',
      if (mainAxisSize == MainAxisSize.min)
        horizontal ? 'width' : 'height': 'fit-content',
      if (gapSize != null)
        'gap': gapSize!.css
      else if (spacing > 0)
        'gap': '${spacing}px',
      ...?style?.toMap(),
    };

    return div(
      classes: horizontal ? 'arcane-row' : 'arcane-column',
      styles: Styles(raw: baseStyles),
      children,
    );
  }
}

/// Places children along the horizontal axis.
class Row extends Flex {
  const Row({
    super.children,
    super.mainAxisAlignment,
    super.crossAxisAlignment,
    super.mainAxisSize,
    super.spacing,
    super.gapSize,
    super.style,
    super.key,
  }) : super(direction: Axis.horizontal);
}

/// Places children along the vertical axis.
class Column extends Flex {
  const Column({
    super.children,
    super.mainAxisAlignment,
    super.crossAxisAlignment,
    super.mainAxisSize,
    super.spacing,
    super.gapSize,
    super.style,
    super.key,
  }) : super(direction: Axis.vertical);
}

/// A flexible spacer component.
class Spacer extends StatelessWidget {
  final int flex;

  const Spacer({this.flex = 1, super.key}) : assert(flex > 0);

  @override
  Widget build(BuildContext context) {
    return context.renderers.spacer(SpacerProps(flex: flex));
  }
}

/// A center alignment component.
class Center extends StatelessWidget {
  final Widget child;

  const Center({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return context.renderers.center(CenterProps(child: child));
  }
}

/// Whether a flexible child must fill or may shrink within available space.
enum FlexFit { tight, loose }

/// Controls a child's sizing in a [Row], [Column], or [Flex].
///
/// A loose fit keeps the child's natural size and permits CSS flex shrinking.
/// A tight fit fills the remaining space according to [flex].
class Flexible extends StatelessWidget {
  final Widget child;
  final int flex;
  final FlexFit fit;

  const Flexible({
    required this.child,
    this.flex = 1,
    this.fit = FlexFit.loose,
    super.key,
  }) : assert(flex >= 0);

  @override
  Widget build(BuildContext context) {
    if (fit == FlexFit.tight && flex > 0) {
      return context.renderers.expanded(
        ExpandedProps(child: child, flex: flex),
      );
    }
    return div(
      classes: 'arcane-flexible',
      styles: Styles(
        raw: <String, String>{
          'flex': '0 $flex auto',
          'min-width': '0',
          'min-height': '0',
        },
      ),
      <Widget>[child],
    );
  }
}

/// Fills remaining space in a [Row], [Column], or [Flex].
class Expanded extends Flexible {
  const Expanded({required super.child, super.flex, super.key})
    : super(fit: FlexFit.tight);
}

/// A padding wrapper component.
class Padding extends StatelessWidget {
  final EdgeInsets padding;
  final Widget child;

  const Padding({required this.padding, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return context.renderers.paddingWrapper(
      PaddingWrapperProps(padding: padding, child: child),
    );
  }
}

/// A sized box component.
class SizedBox extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget? child;

  const SizedBox({this.width, this.height, this.child, super.key})
    : assert(width == null || width >= 0),
      assert(height == null || height >= 0);

  const SizedBox.shrink({this.child, super.key}) : width = 0, height = 0;

  const SizedBox.expand({this.child, super.key})
    : width = double.infinity,
      height = double.infinity;

  @override
  Widget build(BuildContext context) {
    return context.renderers.sizedBox(
      SizedBoxProps(width: width, height: height, child: child),
    );
  }
}

/// A container component with styling options.
class Container extends StatelessWidget {
  final Widget? child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final Color? color;
  final BoxDecoration? decoration;
  final Alignment? alignment;

  /// Semantic HTML tag to render (e.g. `'nav'`, `'section'`, `'header'`).
  /// Defaults to a `div`.
  final String? tag;

  const Container({
    this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.color,
    this.decoration,
    this.alignment,
    this.tag,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> styles = {};

    if (padding != null) styles['padding'] = padding!.padding;
    if (margin != null) styles['margin'] = margin!.margin;
    if (width != null) {
      styles['width'] = width == double.infinity ? '100%' : '${width}px';
    }
    if (height != null) {
      styles['height'] = height == double.infinity ? '100%' : '${height}px';
    }
    if (color != null) styles['background-color'] = color!.css;

    if (decoration != null) {
      if (decoration!.color != null) {
        styles['background-color'] = decoration!.color!.css;
      }
      if (decoration!.borderRadius != null) {
        styles['border-radius'] = decoration!.borderRadius!.css;
      }
      if (decoration!.border != null) {
        styles['border'] = decoration!.border!.css;
      }
      if (decoration!.boxShadow != null) {
        styles['box-shadow'] = decoration!.boxShadow!
            .map((shadow) => shadow.css)
            .join(', ');
      }
    }

    if (alignment != null) {
      styles['display'] = 'flex';
      styles['justify-content'] = alignment!.cssJustifyContent;
      styles['align-items'] = alignment!.cssAlignItems;
    }

    final List<Widget> children = child != null
        ? <Widget>[child!]
        : const <Widget>[];
    final String elementTag = tag ?? 'div';
    if (elementTag == 'div') {
      return div(
        classes: 'arcane-container',
        styles: Styles(raw: styles),
        children,
      );
    }
    return Widget.element(
      tag: elementTag,
      classes: 'arcane-container',
      styles: Styles(raw: styles),
      children: children,
    );
  }
}

/// Box decoration for Container.
class BoxDecoration {
  final Color? color;
  final Radius? borderRadius;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  const BoxDecoration({
    this.color,
    this.borderRadius,
    this.border,
    this.boxShadow,
  });
}

/// Border for BoxDecoration.
class Border {
  final Color color;
  final double width;
  final String style;

  const Border({required this.color, this.width = 1, this.style = 'solid'});

  const Border.all({required this.color, this.width = 1}) : style = 'solid';

  String get css => '${width}px $style ${color.css}';
}
