library;

import 'package:arcane_jaspr/core/interaction/runtime/runtime.dart';
import 'package:arcane_jaspr/stylesheets/base_css.dart';
import 'package:arcane_jaspr/theme/index.dart';

class ArcaneStylesheetCss {
  static final Expando<String> _cache = Expando<String>('ArcaneStylesheetCss');

  const ArcaneStylesheetCss._();

  static String resolve({
    required Object cacheKey,
    required String fontFaces,
    required ThemeSeed lightSeed,
    required ThemeSeed darkSeed,
    required FontConfig fonts,
    required RadiusConfig radius,
    required String Function() componentCss,
  }) {
    final String? cached = _cache[cacheKey];
    if (cached != null) return cached;

    final ThemePalette lightPalette = PaletteGenerator.generate(lightSeed);
    final ThemePalette darkPalette = PaletteGenerator.generate(darkSeed);
    final String generated =
        '''
$fontFaces

${CssGenerator.generateBoth(light: lightPalette, dark: darkPalette, fonts: fonts, radius: radius)}

${ArcaneBaseCss.shared}

$arcaneInteractivityRuntimeCss

${componentCss()}
''';
    _cache[cacheKey] = generated;
    return generated;
  }
}
