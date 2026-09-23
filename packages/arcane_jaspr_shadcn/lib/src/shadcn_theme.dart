library;

/// Color themes for ShadCN stylesheet.
///
/// Each theme defines colors for both light and dark modes.
/// For neutral themes, light secondary/accent are null to allow
/// the palette generator to derive them with primary hue tinting.
enum ShadcnTheme {
  // ============================================
  // Neutral Themes (auto-tinted light surfaces)
  // ============================================

  /// OLED-optimized with pure black/white.
  /// Maximum contrast, perfect for AMOLED screens.
  /// Light mode surfaces are auto-tinted with the primary color.
  midnight(
    // Light: pure white background, near-black primary
    // Secondary/accent derived with subtle primary tinting
    lightBackground: 0xFFffffff,
    lightPrimary: 0xFF09090b,
    // Dark: pure black background, near-white primary
    darkBackground: 0xFF050505,
    darkPrimary: 0xFFF7F4EC,
    darkSecondary: 0xFF111111,
    darkAccent: 0xFF1A1A1A,
  ),

  /// Softer dark theme with off-black.
  /// Easier on the eyes in dark environments.
  charcoal(
    // Light: soft white background with auto-tinted surfaces
    lightBackground: 0xFFfafafa,
    lightPrimary: 0xFF18181b,
    // Dark: off-black background (easier on eyes)
    darkBackground: 0xFF18181B,
    darkPrimary: 0xFFF2F0EA,
    darkSecondary: 0xFF242427,
    darkAccent: 0xFF303036,
  ),

  /// Warm cream/ivory tones.
  /// Reduces eye strain with warmer whites.
  cream(
    // Light: warm ivory background
    lightBackground: 0xFFfefdfb,
    lightPrimary: 0xFF57534e, // Warm stone primary for cohesive tinting
    // Dark: warm dark brown
    darkBackground: 0xFF1D1712,
    darkPrimary: 0xFFF2E5D2,
    darkSecondary: 0xFF2A2119,
    darkAccent: 0xFF3A2B1F,
  ),

  /// Cool slate/gray tones.
  /// Professional, neutral appearance.
  slate(
    // Light: cool gray-white with slate tinting
    lightBackground: 0xFFf8fafc,
    lightPrimary: 0xFF475569, // Slate primary for cool tinting
    // Dark: deep slate
    darkBackground: 0xFF12151C,
    darkPrimary: 0xFFE8ECF2,
    darkSecondary: 0xFF191D26,
    darkAccent: 0xFF1B222C,
  ),

  // ============================================
  // Pastel Themes (richer colored surfaces)
  // ============================================

  /// Rose/pink theme.
  /// Warm, elegant, with visible rose surfaces.
  rose(
    // Light: clean white with rich rose-tinted surfaces
    lightBackground: 0xFFfff7fb,
    lightPrimary: 0xFFbe123c, // Vibrant rose
    lightSecondary: 0xFFfce7f3, // Rich pink surface
    lightAccent: 0xFFfbcfe8, // Deeper pink for interaction
    // Dark: deep rose
    darkBackground: 0xFF180A10,
    darkPrimary: 0xFFFDA4AF,
    darkSecondary: 0xFF251018,
    darkAccent: 0xFF4C1023,
  ),

  /// Lavender/purple theme.
  /// Calming and creative with visible purple surfaces.
  lavender(
    // Light: clean white with rich lavender-tinted surfaces
    lightBackground: 0xFFfbf8ff,
    lightPrimary: 0xFF7e22ce, // Vibrant purple
    lightSecondary: 0xFFede9fe, // Rich lavender surface
    lightAccent: 0xFFddd6fe, // Deeper lavender for interaction
    // Dark: deep purple
    darkBackground: 0xFF120A1F,
    darkPrimary: 0xFFC4B5FD,
    darkSecondary: 0xFF201333,
    darkAccent: 0xFF3B2367,
  ),

  /// Mint/green theme.
  /// Fresh and natural with visible green surfaces.
  mint(
    // Light: clean white with rich mint-tinted surfaces
    lightBackground: 0xFFf6fff9,
    lightPrimary: 0xFF166534, // Vibrant green
    lightSecondary: 0xFFdcfce7, // Rich mint surface
    lightAccent: 0xFFbbf7d0, // Deeper mint for interaction
    // Dark: deep forest
    darkBackground: 0xFF06140E,
    darkPrimary: 0xFF86EFAC,
    darkSecondary: 0xFF0B2117,
    darkAccent: 0xFF14532D,
  ),

  /// Sky/blue theme.
  /// Clean and professional with visible blue surfaces.
  sky(
    // Light: clean white with rich sky-tinted surfaces
    lightBackground: 0xFFf5fbff,
    lightPrimary: 0xFF0369a1, // Vibrant sky blue
    lightSecondary: 0xFFe0f2fe, // Rich sky surface
    lightAccent: 0xFFbae6fd, // Deeper blue for interaction
    // Dark: deep ocean
    darkBackground: 0xFF06131D,
    darkPrimary: 0xFF7DD3FC,
    darkSecondary: 0xFF0C2232,
    darkAccent: 0xFF075985,
  ),

  /// Peach/orange theme.
  /// Warm and energetic with visible orange surfaces.
  peach(
    // Light: clean white with rich peach-tinted surfaces
    lightBackground: 0xFFfffaf5,
    lightPrimary: 0xFF9a3412, // Vibrant orange
    lightSecondary: 0xFFffedd5, // Rich peach surface
    lightAccent: 0xFFfed7aa, // Deeper orange for interaction
    // Dark: deep amber
    darkBackground: 0xFF1B1007,
    darkPrimary: 0xFFFDBA74,
    darkSecondary: 0xFF281808,
    darkAccent: 0xFF7C2D12,
  ),

  /// Teal/cyan theme.
  /// Modern and vibrant with visible teal surfaces.
  teal(
    // Light: clean white with rich teal-tinted surfaces
    lightBackground: 0xFFf5fffc,
    lightPrimary: 0xFF0f766e, // Vibrant teal
    lightSecondary: 0xFFccfbf1, // Rich teal surface
    lightAccent: 0xFF99f6e4, // Deeper teal for interaction
    // Dark: deep teal
    darkBackground: 0xFF061514,
    darkPrimary: 0xFF5EEAD4,
    darkSecondary: 0xFF0B2422,
    darkAccent: 0xFF134E4A,
  );

  /// Light mode background color.
  final int lightBackground;

  /// Light mode primary color (used for tinting and interactive elements).
  final int lightPrimary;

  /// Light mode secondary color. If null, derived with primary tinting.
  final int? lightSecondary;

  /// Light mode accent color. If null, derived with primary tinting.
  final int? lightAccent;

  /// Dark mode background color.
  final int darkBackground;

  /// Dark mode primary color.
  final int darkPrimary;

  /// Dark mode secondary color.
  final int darkSecondary;

  /// Dark mode accent color.
  final int darkAccent;

  const ShadcnTheme({
    required this.lightBackground,
    required this.lightPrimary,
    this.lightSecondary,
    this.lightAccent,
    required this.darkBackground,
    required this.darkPrimary,
    required this.darkSecondary,
    required this.darkAccent,
  });
}
