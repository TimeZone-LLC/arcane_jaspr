import 'package:arcane_jaspr/stylesheets/stylesheet.dart';
import 'package:arcane_jaspr/theme/index.dart';

import 'package:arcane_jaspr_neon/src/neon_css.dart';
import 'package:arcane_jaspr_neon/src/neon_theme.dart';
import 'package:arcane_jaspr_neon/src/renderers/neon_renderers.dart';

/// Green and grayscale theme for technical product interfaces.
///
/// Component styling lives in [NeonCss] and is scoped to
/// `#arcane-root.arcane-theme-neon`, so it never affects other themes.
class NeonStylesheet extends ArcaneStylesheet {
  /// The color palette. Green is the only supported palette.
  final NeonTheme theme;

  const NeonStylesheet({this.theme = NeonTheme.green});

  @override
  String get id => 'neon';

  @override
  String get name => 'Neon';

  @override
  ComponentRenderers get renderers => const NeonRenderers();

  @override
  ThemeSeed get lightSeed => ThemeSeed(
    primary: theme.color,
    background: 0xFFF7F7F6,
    secondary: 0xFFEDEDEB,
    accent: 0xFFE3E3E0,
    border: 0xFFC9C9C5,
    destructive: 0xFF525252,
    success: theme.color,
    warning: 0xFF666666,
    info: 0xFF404040,
  );

  @override
  ThemeSeed get darkSeed => ThemeSeed(
    primary: theme.color,
    background: 0xFF0B0B0B,
    secondary: 0xFF181818,
    accent: 0xFF222222,
    border: 0xFF303030,
    destructive: 0xFFA3A3A3,
    success: theme.color,
    warning: 0xFF8A8A8A,
    info: 0xFFB3B3B3,
    isDark: true,
  );

  @override
  FontConfig get fonts => const FontConfig(
    sans: "'Akzidenz-GroteskPro'",
    heading: "'ITCAvantGardeStd'",
    mono: "'Hack'",
  );

  @override
  RadiusConfig get radius => const RadiusConfig.dense();

  @override
  String get bodyClass => 'neon-${theme.name}';

  @override
  String get componentCss => NeonCss.componentCss(theme);
}
