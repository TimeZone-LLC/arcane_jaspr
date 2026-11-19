/// Theme generation system for Arcane Jaspr.
///
/// This library provides automatic color palette generation from minimal seed colors.
///
/// ## Usage
///
/// ```dart
/// // Define minimal seed colors
/// final seed = ThemeSeed(
///   primary: 0xFF09090b,
///   destructive: 0xFFef4444,
///   success: 0xFF22c55e,
///   warning: 0xFFf59e0b,
///   info: 0xFF3b82f6,
/// );
///
/// // Generate full palette
/// final palette = PaletteGenerator.generate(seed);
///
/// // Generate CSS
/// final css = CssGenerator.generate(palette);
/// ```
library;

export 'color_seed.dart';
export 'control_config.dart';
export 'css_generator.dart';
export 'font_config.dart';
export 'motion_config.dart';
export 'palette.dart';
export 'palette_generator.dart';
export 'radius_config.dart';
