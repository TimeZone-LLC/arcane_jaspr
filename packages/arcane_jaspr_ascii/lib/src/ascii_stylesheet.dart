import 'package:arcane_jaspr/stylesheets/stylesheet.dart';
import 'package:arcane_jaspr/theme/index.dart';
import 'package:arcane_jaspr_ascii/src/ascii_css.dart';
import 'package:arcane_jaspr_ascii/src/ascii_motion_css.dart';
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
    primary: 0xff101014,
    background: 0xfff2f1ee,
    secondary: 0xffe8e7e3,
    accent: 0xffe3e1dc,
    border: 0xffd3d0c9,
    destructive: 0xffa0372d,
    success: 0xff315c3a,
    warning: 0xff79520e,
    info: 0xff335a70,
  );

  @override
  ThemeSeed get darkSeed => const ThemeSeed(
    primary: 0xffe9e8e3,
    background: 0xff101014,
    secondary: 0xff26262b,
    accent: 0xff303037,
    border: 0xff35353c,
    destructive: 0xfff2a095,
    success: 0xffa8cf9c,
    warning: 0xffdfc28b,
    info: 0xffa1c4d6,
    isDark: true,
  );

  @override
  FontConfig get fonts => const FontConfig(
    sans:
        "'Geist', 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif",
    heading:
        "'Geist', 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif",
    mono:
        "'Geist Mono', 'IBM Plex Mono', 'Hack', 'SFMono-Regular', Consolas, 'Liberation Mono', monospace",
  );

  @override
  RadiusConfig get radius => const RadiusConfig.sharp();

  @override
  String get bodyClass => 'ascii';

  @override
  String get componentCss =>
      '${_semantics.componentCss.replaceAll('.arcane-theme-shadcn', '.arcane-theme-ascii')}\n$asciiCss\n$asciiMotionCss';
}
