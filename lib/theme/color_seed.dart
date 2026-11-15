/// Minimal color input for theme generation.
///
/// Only define the essential colors that can't be derived.
/// Everything else (foregrounds, containers, hovers, RGB values)
/// is computed by [PaletteGenerator].
class ThemeSeed {
  /// Primary brand color. Used for buttons, links, focus rings.
  /// Foreground is auto-calculated for WCAG contrast.
  final int primary;

  /// Background color.
  /// If null, defaults to white (light mode) or black (dark mode).
  final int? background;

  /// Secondary/muted surface color.
  /// If null, derived from background (slightly darker/lighter).
  final int? secondary;

  /// Accent color for highlights and hover states.
  /// If null, defaults to secondary.
  final int? accent;

  /// Border color.
  /// If null, derived from foreground at low opacity.
  final int? border;

  /// Focus ring color.
  /// If null, derived from [primary].
  final int? ring;

  /// Error/destructive action color.
  final int destructive;

  /// Success/positive action color.
  final int success;

  /// Warning/caution color.
  final int warning;

  /// Info/neutral action color.
  final int info;

  /// Whether this is a dark theme.
  /// Affects how derived colors are calculated.
  final bool isDark;

  const ThemeSeed({
    required this.primary,
    this.background,
    this.secondary,
    this.accent,
    this.border,
    this.ring,
    this.destructive = 0xFFef4444,
    this.success = 0xFF22c55e,
    this.warning = 0xFFf59e0b,
    this.info = 0xFF3b82f6,
    this.isDark = false,
  });

  /// Create a dark mode variant of this seed.
  ///
  /// - Inverts background to black
  /// - Adjusts semantic colors to darker variants
  /// - Preserves primary color
  ThemeSeed toDark({
    int? background,
    int? destructive,
    int? success,
    int? warning,
    int? info,
  }) {
    return ThemeSeed(
      primary: primary,
      background: background ?? 0xFF000000,
      secondary: null, // Re-derive for dark
      accent: null, // Re-derive for dark
      border: null, // Re-derive for dark
      ring: ring,
      destructive: destructive ?? 0xFF7f1d1d,
      success: success ?? 0xFF166534,
      warning: warning ?? 0xFF92400e,
      info: info ?? 0xFF1e40af,
      isDark: true,
    );
  }

  /// Create a copy with some fields replaced.
  ThemeSeed copyWith({
    int? primary,
    int? background,
    int? secondary,
    int? accent,
    int? border,
    int? ring,
    int? destructive,
    int? success,
    int? warning,
    int? info,
    bool? isDark,
  }) {
    return ThemeSeed(
      primary: primary ?? this.primary,
      background: background ?? this.background,
      secondary: secondary ?? this.secondary,
      accent: accent ?? this.accent,
      border: border ?? this.border,
      ring: ring ?? this.ring,
      destructive: destructive ?? this.destructive,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      isDark: isDark ?? this.isDark,
    );
  }
}
