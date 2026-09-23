import 'package:arcane_jaspr/flutter.dart';
import 'package:jaspr/jaspr.dart'
    hide
        BuildContext,
        InheritedComponent,
        Key,
        State,
        StatefulComponent,
        StatelessComponent,
        UniqueKey,
        ValueKey,
        runApp;
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
        BoxShadow,
        FontWeight,
        FontStyle,
        StyleRule,
        Display,
        Position,
        Overflow,
        Cursor,
        Visibility,
        TextDecoration,
        TextTransform,
        FontFamily,
        WhiteSpace;

import 'package:arcane_jaspr/component/typography/text_style.dart';
import 'package:arcane_jaspr/util/arcane.dart';
import 'package:arcane_jaspr/util/style_types/index.dart';

export 'package:arcane_jaspr/component/typography/text_style.dart';

/// Text with Flutter-shaped styling and optional Arcane typography tokens.
class Text extends StatelessWidget {
  final String data;
  final FontSize? size;
  final FontWeight? weight;
  final TextColor? color;
  final String? colorCustom;
  final TextAlign? textAlign;
  final LineHeight? lineHeight;
  final LetterSpacing? letterSpacing;
  final TextDecoration? decoration;
  final TextTransform? transform;
  final FontFamily? family;
  final FontStyle? fontStyle;
  final TextOverflow? overflow;
  final WhiteSpace? whiteSpace;
  final int? maxLines;
  final bool selectable;
  final TextStyle? style;
  final ArcaneStyleData? cssStyle;
  final bool? softWrap;
  final String element;

  const Text(
    this.data, {
    this.size,
    this.weight,
    this.color,
    this.colorCustom,
    this.textAlign,
    this.lineHeight,
    this.letterSpacing,
    this.decoration,
    this.transform,
    this.family,
    this.fontStyle,
    this.overflow,
    this.whiteSpace,
    this.maxLines,
    this.selectable = true,
    this.style,
    this.cssStyle,
    this.softWrap,
    this.element = 'span',
    super.key,
  }) : assert(maxLines == null || maxLines > 0);

  const Text.pageTitle(
    this.data, {
    this.color = TextColor.primary,
    this.textAlign,
    this.style,
    this.cssStyle,
    this.softWrap,
    super.key,
  }) : size = FontSize.mega,
       weight = FontWeight.bold,
       lineHeight = LineHeight.tight,
       letterSpacing = LetterSpacing.tight,
       colorCustom = null,
       decoration = null,
       transform = null,
       family = null,
       fontStyle = null,
       overflow = null,
       whiteSpace = null,
       maxLines = null,
       selectable = true,
       element = 'h1';

  const Text.sectionTitle(
    this.data, {
    this.color = TextColor.primary,
    this.textAlign,
    this.style,
    this.cssStyle,
    this.softWrap,
    super.key,
  }) : size = FontSize.hero,
       weight = FontWeight.bold,
       lineHeight = LineHeight.tight,
       letterSpacing = null,
       colorCustom = null,
       decoration = null,
       transform = null,
       family = null,
       fontStyle = null,
       overflow = null,
       whiteSpace = null,
       maxLines = null,
       selectable = true,
       element = 'h2';

  const Text.heading(
    this.data, {
    this.color = TextColor.primary,
    this.textAlign,
    this.style,
    this.cssStyle,
    this.softWrap,
    super.key,
  }) : size = FontSize.xl3,
       weight = FontWeight.bold,
       lineHeight = LineHeight.tight,
       letterSpacing = null,
       colorCustom = null,
       decoration = null,
       transform = null,
       family = null,
       fontStyle = null,
       overflow = null,
       whiteSpace = null,
       maxLines = null,
       selectable = true,
       element = 'h2';

  const Text.heading2(
    this.data, {
    this.color = TextColor.primary,
    this.textAlign,
    this.style,
    this.cssStyle,
    this.softWrap,
    super.key,
  }) : size = FontSize.xl2,
       weight = FontWeight.w600,
       lineHeight = LineHeight.snug,
       letterSpacing = null,
       colorCustom = null,
       decoration = null,
       transform = null,
       family = null,
       fontStyle = null,
       overflow = null,
       whiteSpace = null,
       maxLines = null,
       selectable = true,
       element = 'h3';

  const Text.heading3(
    this.data, {
    this.color = TextColor.primary,
    this.textAlign,
    this.style,
    this.cssStyle,
    this.softWrap,
    super.key,
  }) : size = FontSize.xl,
       weight = FontWeight.w600,
       lineHeight = LineHeight.snug,
       letterSpacing = null,
       colorCustom = null,
       decoration = null,
       transform = null,
       family = null,
       fontStyle = null,
       overflow = null,
       whiteSpace = null,
       maxLines = null,
       selectable = true,
       element = 'h4';

  const Text.subheading(
    this.data, {
    this.color = TextColor.secondary,
    this.textAlign,
    this.style,
    this.cssStyle,
    this.softWrap,
    super.key,
  }) : size = FontSize.lg,
       weight = FontWeight.w500,
       lineHeight = LineHeight.normal,
       letterSpacing = null,
       colorCustom = null,
       decoration = null,
       transform = null,
       family = null,
       fontStyle = null,
       overflow = null,
       whiteSpace = null,
       maxLines = null,
       selectable = true,
       element = 'p';

  const Text.body(
    this.data, {
    this.color = TextColor.muted,
    this.textAlign,
    this.style,
    this.cssStyle,
    this.softWrap,
    super.key,
  }) : size = FontSize.base,
       weight = null,
       lineHeight = LineHeight.relaxed,
       letterSpacing = null,
       colorCustom = null,
       decoration = null,
       transform = null,
       family = null,
       fontStyle = null,
       overflow = null,
       whiteSpace = null,
       maxLines = null,
       selectable = true,
       element = 'p';

  const Text.bodyLarge(
    this.data, {
    this.color = TextColor.muted,
    this.textAlign,
    this.style,
    this.cssStyle,
    this.softWrap,
    super.key,
  }) : size = FontSize.lg,
       weight = null,
       lineHeight = LineHeight.relaxed,
       letterSpacing = null,
       colorCustom = null,
       decoration = null,
       transform = null,
       family = null,
       fontStyle = null,
       overflow = null,
       whiteSpace = null,
       maxLines = null,
       selectable = true,
       element = 'p';

  const Text.bodySmall(
    this.data, {
    this.color = TextColor.muted,
    this.textAlign,
    this.style,
    this.cssStyle,
    this.softWrap,
    super.key,
  }) : size = FontSize.sm,
       weight = null,
       lineHeight = LineHeight.normal,
       letterSpacing = null,
       colorCustom = null,
       decoration = null,
       transform = null,
       family = null,
       fontStyle = null,
       overflow = null,
       whiteSpace = null,
       maxLines = null,
       selectable = true,
       element = 'p';

  const Text.label(
    this.data, {
    this.color = TextColor.primary,
    this.textAlign,
    this.style,
    this.cssStyle,
    this.softWrap,
    super.key,
  }) : size = FontSize.sm,
       weight = FontWeight.w500,
       lineHeight = null,
       letterSpacing = null,
       colorCustom = null,
       decoration = null,
       transform = null,
       family = null,
       fontStyle = null,
       overflow = null,
       whiteSpace = null,
       maxLines = null,
       selectable = true,
       element = 'span';

  const Text.caption(
    this.data, {
    this.color = TextColor.subtle,
    this.textAlign,
    this.style,
    this.cssStyle,
    this.softWrap,
    super.key,
  }) : size = FontSize.xs,
       weight = null,
       lineHeight = null,
       letterSpacing = null,
       colorCustom = null,
       decoration = null,
       transform = null,
       family = null,
       fontStyle = null,
       overflow = null,
       whiteSpace = null,
       maxLines = null,
       selectable = true,
       element = 'span';

  const Text.code(
    this.data, {
    this.color = TextColor.accent,
    this.textAlign,
    this.style,
    this.cssStyle,
    this.softWrap,
    super.key,
  }) : size = FontSize.sm,
       weight = null,
       lineHeight = null,
       letterSpacing = null,
       colorCustom = null,
       decoration = null,
       transform = null,
       family = FontFamily.mono,
       fontStyle = null,
       overflow = null,
       whiteSpace = null,
       maxLines = null,
       selectable = true,
       element = 'code';

  const Text.link(
    this.data, {
    this.color = TextColor.accent,
    this.textAlign,
    this.style,
    this.cssStyle,
    this.softWrap,
    super.key,
  }) : size = null,
       weight = null,
       lineHeight = null,
       letterSpacing = null,
       colorCustom = null,
       decoration = TextDecoration.none,
       transform = null,
       family = null,
       fontStyle = null,
       overflow = null,
       whiteSpace = null,
       maxLines = null,
       selectable = true,
       element = 'span';

  const Text.truncated(
    this.data, {
    this.size,
    this.weight,
    this.color,
    this.textAlign,
    this.style,
    this.cssStyle,
    this.softWrap,
    super.key,
  }) : overflow = TextOverflow.ellipsis,
       whiteSpace = WhiteSpace.nowrap,
       maxLines = 1,
       lineHeight = null,
       letterSpacing = null,
       colorCustom = null,
       decoration = null,
       transform = null,
       family = null,
       fontStyle = null,
       selectable = true,
       element = 'span';

  @override
  Widget build(BuildContext context) {
    final Map<String, String> textStyles = <String, String>{};

    if (size != null) textStyles['font-size'] = size!.css;
    if (weight != null) textStyles['font-weight'] = weight!.css;
    if (color != null) textStyles['color'] = color!.css;
    if (colorCustom != null) textStyles['color'] = colorCustom!;
    if (lineHeight != null) textStyles['line-height'] = lineHeight!.css;
    if (letterSpacing != null) {
      textStyles['letter-spacing'] = letterSpacing!.css;
    }
    if (decoration != null) textStyles['text-decoration'] = decoration!.css;
    if (transform != null) textStyles['text-transform'] = transform!.css;
    if (family != null) textStyles['font-family'] = family!.css;
    if (fontStyle != null) textStyles['font-style'] = fontStyle!.css;
    textStyles.addAll(style?.toMap() ?? const <String, String>{});

    if (textAlign != null) textStyles['text-align'] = textAlign!.css;
    final TextOverflow? effectiveOverflow = overflow ?? style?.overflow;
    if (effectiveOverflow != null) {
      textStyles['text-overflow'] = effectiveOverflow == TextOverflow.visible
          ? 'clip'
          : effectiveOverflow.css;
      if (effectiveOverflow == TextOverflow.ellipsis) {
        textStyles['overflow'] = 'hidden';
      } else if (effectiveOverflow == TextOverflow.visible) {
        textStyles['overflow'] = 'visible';
      }
    }
    if (softWrap != null) {
      textStyles['white-space'] = softWrap! ? 'normal' : 'nowrap';
    }
    if (whiteSpace != null) textStyles['white-space'] = whiteSpace!.css;

    if (!selectable) {
      textStyles['user-select'] = 'none';
      textStyles['-webkit-user-select'] = 'none';
    }

    if (maxLines == 1 || softWrap == false) {
      textStyles['display'] = 'inline-block';
      textStyles['max-width'] = '100%';
      textStyles['white-space'] = 'nowrap';
      textStyles['overflow'] = effectiveOverflow == TextOverflow.visible
          ? 'visible'
          : 'hidden';
    } else if (maxLines != null && maxLines! > 1) {
      if (effectiveOverflow == TextOverflow.ellipsis) {
        textStyles['display'] = '-webkit-box';
        textStyles['-webkit-line-clamp'] = '$maxLines';
        textStyles['-webkit-box-orient'] = 'vertical';
        textStyles['overflow'] = 'hidden';
      } else {
        textStyles['display'] = 'block';
        textStyles['max-height'] = '${maxLines}lh';
        textStyles['overflow'] = effectiveOverflow == TextOverflow.visible
            ? 'visible'
            : 'hidden';
      }
    }

    textStyles.addAll(cssStyle?.toMap() ?? const <String, String>{});

    return _buildElement(textStyles);
  }

  Widget _buildElement(Map<String, String> styles) {
    final String tag = switch (element) {
      'h1' ||
      'h2' ||
      'h3' ||
      'h4' ||
      'h5' ||
      'h6' ||
      'p' ||
      'code' ||
      'pre' ||
      'strong' ||
      'em' ||
      'small' => element,
      _ => 'span',
    };
    return Widget.element(
      tag: tag,
      classes: 'arcane-text',
      styles: Styles(raw: styles),
      children: <Widget>[Widget.text(data)],
    );
  }
}

/// Rich text component supporting mixed styling.
class RichText extends StatelessWidget {
  final List<Widget> children;
  final ArcaneStyleData? style;

  const RichText({required this.children, this.style, super.key});

  @override
  Widget build(BuildContext context) {
    return span(
      classes: 'arcane-rich-text',
      styles: style?.toStyles() ?? const Styles(raw: {}),
      children,
    );
  }
}

/// Text span for use within RichText.
class TextSpan extends StatelessWidget {
  final String text;
  final FontSize? size;
  final FontWeight? weight;
  final TextColor? color;
  final String? colorCustom;
  final TextDecoration? decoration;
  final FontFamily? family;
  final FontStyle? fontStyle;
  final ArcaneStyleData? style;

  const TextSpan(
    this.text, {
    this.size,
    this.weight,
    this.color,
    this.colorCustom,
    this.decoration,
    this.family,
    this.fontStyle,
    this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, String> spanStyles = {};

    if (size != null) spanStyles['font-size'] = size!.css;
    if (weight != null) spanStyles['font-weight'] = weight!.css;
    if (color != null) spanStyles['color'] = color!.css;
    if (colorCustom != null) spanStyles['color'] = colorCustom!;
    if (decoration != null) spanStyles['text-decoration'] = decoration!.css;
    if (family != null) spanStyles['font-family'] = family!.css;
    if (fontStyle != null) spanStyles['font-style'] = fontStyle!.css;

    if (style != null) {
      spanStyles.addAll(style!.toMap());
    }

    return span(styles: Styles(raw: spanStyles), [Component.text(text)]);
  }
}
