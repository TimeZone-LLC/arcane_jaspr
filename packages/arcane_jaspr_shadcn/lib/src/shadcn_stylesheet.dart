import 'package:arcane_jaspr/theme/index.dart';
import 'package:arcane_jaspr/stylesheets/stylesheet.dart';

import 'package:arcane_jaspr_shadcn/src/renderers/shadcn_renderers.dart';
import 'package:arcane_jaspr_shadcn/src/shadcn_css.dart';
import 'package:arcane_jaspr_shadcn/src/shadcn_layout_renderers.dart';
import 'package:arcane_jaspr_shadcn/src/shadcn_theme.dart';

/// ShadCN UI stylesheet.
///
/// Implements the ShadCN/ui design language:
/// - Rounded corners (0.5rem default radius)
/// - Minimal shadows
/// - Border-focused design
/// - Product fonts supplied by committed site assets
/// - Accessible, clean aesthetic
///
/// Supports multiple color themes via [ShadcnTheme].
///
/// Reference: https://ui.shadcn.com
class ShadcnStylesheet extends ArcaneStylesheet {
  /// The color theme to use. Defaults to midnight (OLED black).
  final ShadcnTheme theme;

  const ShadcnStylesheet({this.theme = ShadcnTheme.midnight});

  @override
  String get id => 'shadcn';

  @override
  String get name => 'ShadCN UI';

  @override
  ComponentRenderers get renderers => const ShadcnRenderers();

  @override
  LayoutRenderers get layouts => const ShadcnLayoutRenderers();

  // ============================================
  // Theme Seeds
  // ============================================

  @override
  ThemeSeed get lightSeed => ThemeSeed(
    primary: theme.lightPrimary,
    background: theme.lightBackground,
    // Only pass secondary/accent if explicitly defined in theme
    // Otherwise let PaletteGenerator derive them with primary tinting
    secondary: theme.lightSecondary,
    accent: theme.lightAccent,
    destructive: 0xFFb91c1c,
    success: 0xFF166534,
    warning: 0xFF854d0e,
    info: 0xFF1d4ed8,
  );

  @override
  ThemeSeed get darkSeed => ThemeSeed(
    primary: theme.darkPrimary,
    background: theme.darkBackground,
    secondary: theme.darkSecondary,
    accent: theme.darkAccent,
    destructive: 0xFFf87171,
    success: 0xFF4ade80,
    warning: 0xFFfbbf24,
    info: 0xFF60a5fa,
    isDark: true,
  );

  // ============================================
  // Fonts
  // ============================================

  @override
  FontConfig get fonts => const FontConfig(
    sans: "'Akzidenz-GroteskPro'",
    heading: "'ITCAvantGardeStd'",
    mono: "'Hack'",
  );

  @override
  String get bodyClass => 'shadcn-${theme.name}';

  @override
  String get componentCss => ShadcnCss.componentCss(theme);
}
