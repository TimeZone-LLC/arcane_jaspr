import 'package:arcane_jaspr/theme/index.dart';
import 'package:arcane_jaspr/stylesheets/stylesheet.dart';

import 'package:arcane_jaspr_neubrutalism/src/neubrutalism_css.dart';
import 'package:arcane_jaspr_neubrutalism/src/neubrutalism_fonts.dart';
import 'package:arcane_jaspr_neubrutalism/src/neubrutalism_layout_renderers.dart';
import 'package:arcane_jaspr_neubrutalism/src/neubrutalism_motion_css.dart';
import 'package:arcane_jaspr_neubrutalism/src/neubrutalism_theme.dart';
import 'package:arcane_jaspr_neubrutalism/src/neubrutalism_variant.dart';
import 'package:arcane_jaspr_neubrutalism/src/neucomic_css.dart';
import 'package:arcane_jaspr_neubrutalism/src/neucomic_fonts.dart';
import 'package:arcane_jaspr_neubrutalism/src/neucomic_gallery_css.dart';
import 'package:arcane_jaspr_neubrutalism/src/neucomic_surfaces_css.dart';
import 'package:arcane_jaspr_neubrutalism/src/renderers/neubrutalism_renderers.dart';

class NeubrutalismStylesheet extends ArcaneStylesheet {
  final NeubrutalismTheme theme;
  final NeubrutalismVariant variant;
  final bool rounded;

  const NeubrutalismStylesheet({
    NeubrutalismTheme? theme,
    this.variant = NeubrutalismVariant.classic,
    this.rounded = false,
  }) : theme =
           theme ??
           (variant == NeubrutalismVariant.neuComic
               ? NeubrutalismTheme.red
               : NeubrutalismTheme.yellow);

  @override
  String get id => 'neubrutalism';

  @override
  String get name =>
      variant == NeubrutalismVariant.neuComic ? 'NeuComic' : 'Neubrutalism';

  @override
  ComponentRenderers get renderers => NeubrutalismRenderers(variant: variant);

  @override
  LayoutRenderers get layouts => const NeubrutalismLayoutRenderers();

  @override
  ThemeSeed get lightSeed => ThemeSeed(
    primary:
        variant == NeubrutalismVariant.neuComic &&
            theme == NeubrutalismTheme.red
        ? NeuComicCss.redAccent
        : theme.color,
    background: variant == NeubrutalismVariant.neuComic
        ? NeuComicCss.lightPaper
        : theme.lightSurface,
    secondary: variant == NeubrutalismVariant.neuComic
        ? NeuComicCss.lightPanel
        : theme.lightSecondary,
    accent: theme.lightAccent,
    border: variant == NeubrutalismVariant.neuComic
        ? NeuComicCss.lightInk
        : theme.lightBorder,
    destructive: 0xFFFF4444,
    success: 0xFF88D498,
    warning: 0xFFFFD23F,
    info: 0xFF74B9FF,
  );

  @override
  ThemeSeed get darkSeed => ThemeSeed(
    primary:
        variant == NeubrutalismVariant.neuComic &&
            theme == NeubrutalismTheme.red
        ? NeuComicCss.darkRedAccent
        : theme.color,
    background: variant == NeubrutalismVariant.neuComic
        ? NeuComicCss.darkPaper
        : theme.darkBackground,
    secondary: variant == NeubrutalismVariant.neuComic
        ? NeuComicCss.darkPanel
        : theme.darkSecondary,
    accent: theme.color,
    border: variant == NeubrutalismVariant.neuComic
        ? NeuComicCss.darkBorder
        : theme.darkBorder,
    destructive: 0xFFFF4444,
    success: 0xFF88D498,
    warning: 0xFFFFD23F,
    info: 0xFF74B9FF,
    isDark: true,
  );

  @override
  FontConfig get fonts => variant == NeubrutalismVariant.neuComic
      ? const FontConfig(
          sans: "'Inter', Arial, Helvetica, sans-serif",
          heading: "'Inter', Arial, Helvetica, sans-serif",
          mono: "'Space Mono', 'SFMono-Regular', Consolas, monospace",
        )
      : const FontConfig(
          sans: "'Inter', Arial, Helvetica, sans-serif",
          heading: "'Space Grotesk', Arial, Helvetica, sans-serif",
          mono: "'Space Mono', 'SFMono-Regular', Consolas, monospace",
        );

  @override
  RadiusConfig get radius =>
      rounded ? const RadiusConfig() : const RadiusConfig.sharp();

  // ArcaneApp injects its head once; both treatments must survive live switching.
  @override
  String get fontFaces => '$neubrutalismFontFaces\n$neuComicFontFaces';

  @override
  String get bodyClass =>
      'neubrutalism-${theme.name}'
      '${variant == NeubrutalismVariant.neuComic ? ' neucomic' : ''}'
      '${rounded ? ' neubrutalism-rounded' : ''}';

  @override
  String get componentCss =>
      '${NeubrutalismCss.componentCss(theme)}'
      '${NeubrutalismMotionCss.styles}'
      '${NeuComicCss.styles}'
      '${NeuComicSurfacesCss.styles}'
      '${NeuComicGalleryCss.styles}';
}
