import 'package:arcane_jaspr/stylesheets/stylesheet.dart';
import 'package:arcane_jaspr/theme/index.dart';
import 'package:arcane_jaspr_ascii/src/ascii_css.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';

class AsciiStylesheet extends ArcaneStylesheet {
  static const ShadcnStylesheet _semantics = ShadcnStylesheet();

  const AsciiStylesheet();

  @override
  String get id => 'ascii';

  @override
  String get name => 'Ascii';

  @override
  ComponentRenderers get renderers => _semantics.renderers;

  @override
  LayoutRenderers get layouts => _semantics.layouts;

  @override
  ThemeSeed get lightSeed => const ThemeSeed(
    primary: 0xff314e39,
    background: 0xfff6f5f0,
    secondary: 0xffeaece3,
    accent: 0xffe0e6d9,
    border: 0xffa0a898,
    destructive: 0xffa0372d,
    success: 0xff315c3a,
    warning: 0xff79520e,
    info: 0xff335a70,
  );

  @override
  ThemeSeed get darkSeed => const ThemeSeed(
    primary: 0xffb1cba1,
    background: 0xff111310,
    secondary: 0xff252a22,
    accent: 0xff30382a,
    border: 0xff616d58,
    destructive: 0xfff2a095,
    success: 0xffa8cf9c,
    warning: 0xffdfc28b,
    info: 0xffa1c4d6,
    isDark: true,
  );

  @override
  FontConfig get fonts => const FontConfig(
    sans:
        "'Geist Mono', 'IBM Plex Mono', 'Hack', 'SFMono-Regular', Consolas, 'Liberation Mono', monospace",
    heading:
        "'Geist Mono', 'IBM Plex Mono', 'Hack', 'SFMono-Regular', Consolas, 'Liberation Mono', monospace",
    mono:
        "'Geist Mono', 'IBM Plex Mono', 'Hack', 'SFMono-Regular', Consolas, 'Liberation Mono', monospace",
  );

  @override
  RadiusConfig get radius => const RadiusConfig.sharp();

  @override
  String get bodyClass => 'ascii';

  @override
  String get componentCss =>
      '${_semantics.componentCss.replaceAll('.arcane-theme-shadcn', '.arcane-theme-ascii')}\n$asciiCss';
}
