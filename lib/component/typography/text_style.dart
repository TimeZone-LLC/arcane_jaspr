import 'package:arcane_jaspr/util/appearance/colors.dart';
import 'package:arcane_jaspr/util/arcane.dart';
import 'package:arcane_jaspr/util/style_types/typography.dart';
import 'package:meta/meta.dart';

/// Flutter-shaped text styling rendered with CSS typography properties.
@immutable
class TextStyle {
  final bool inherit;
  final Color? color;
  final Color? backgroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final String? fontFamily;
  final List<String>? fontFamilyFallback;
  final double? letterSpacing;
  final double? wordSpacing;
  final double? height;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final TextOverflow? overflow;

  const TextStyle({
    this.inherit = true,
    this.color,
    this.backgroundColor,
    this.fontSize,
    this.fontWeight,
    this.fontStyle,
    this.fontFamily,
    this.fontFamilyFallback,
    this.letterSpacing,
    this.wordSpacing,
    this.height,
    this.decoration,
    this.decorationColor,
    this.overflow,
  });

  TextStyle copyWith({
    bool? inherit,
    Color? color,
    Color? backgroundColor,
    double? fontSize,
    FontWeight? fontWeight,
    FontStyle? fontStyle,
    String? fontFamily,
    List<String>? fontFamilyFallback,
    double? letterSpacing,
    double? wordSpacing,
    double? height,
    TextDecoration? decoration,
    Color? decorationColor,
    TextOverflow? overflow,
  }) => TextStyle(
    inherit: inherit ?? this.inherit,
    color: color ?? this.color,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    fontSize: fontSize ?? this.fontSize,
    fontWeight: fontWeight ?? this.fontWeight,
    fontStyle: fontStyle ?? this.fontStyle,
    fontFamily: fontFamily ?? this.fontFamily,
    fontFamilyFallback: fontFamilyFallback ?? this.fontFamilyFallback,
    letterSpacing: letterSpacing ?? this.letterSpacing,
    wordSpacing: wordSpacing ?? this.wordSpacing,
    height: height ?? this.height,
    decoration: decoration ?? this.decoration,
    decorationColor: decorationColor ?? this.decorationColor,
    overflow: overflow ?? this.overflow,
  );

  /// Applies the supplied non-null values, or replaces this style when detached.
  TextStyle merge(TextStyle? other) {
    if (other == null) return this;
    if (!other.inherit) return other;
    return copyWith(
      color: other.color,
      backgroundColor: other.backgroundColor,
      fontSize: other.fontSize,
      fontWeight: other.fontWeight,
      fontStyle: other.fontStyle,
      fontFamily: other.fontFamily,
      fontFamilyFallback: other.fontFamilyFallback,
      letterSpacing: other.letterSpacing,
      wordSpacing: other.wordSpacing,
      height: other.height,
      decoration: other.decoration,
      decorationColor: other.decorationColor,
      overflow: other.overflow,
    );
  }

  static String _quoteFontFamily(String family) =>
      '"${family.replaceAll(r'\', r'\\').replaceAll('"', r'\"').replaceAll('\n', r'\a ').replaceAll('\r', r'\d ')}"';

  Map<String, String> toMap() => <String, String>{
    if (!inherit) ...<String, String>{
      'color': 'initial',
      'background-color': 'initial',
      'font-family': 'initial',
      'font-size': 'initial',
      'font-weight': 'initial',
      'font-style': 'initial',
      'letter-spacing': 'initial',
      'word-spacing': 'initial',
      'line-height': 'initial',
      'text-decoration': 'initial',
      'text-decoration-color': 'initial',
    },
    'color': ?color?.css,
    'background-color': ?backgroundColor?.css,
    if (fontSize != null) 'font-size': '${fontSize}px',
    'font-weight': ?fontWeight?.css,
    'font-style': ?fontStyle?.css,
    if (fontFamily != null || (fontFamilyFallback?.isNotEmpty ?? false))
      'font-family': <String>[
        ?fontFamily,
        ...?fontFamilyFallback,
      ].map(_quoteFontFamily).join(', '),
    if (letterSpacing != null) 'letter-spacing': '${letterSpacing}px',
    if (wordSpacing != null) 'word-spacing': '${wordSpacing}px',
    if (height != null) 'line-height': height == 0 ? 'normal' : '$height',
    'text-decoration': ?decoration?.css,
    'text-decoration-color': ?decorationColor?.css,
    if (overflow != null)
      'text-overflow': overflow == TextOverflow.visible
          ? 'clip'
          : overflow!.css,
  };
}
