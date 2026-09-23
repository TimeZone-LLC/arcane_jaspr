library;

/// Appearance schemes for the Windows 95 theme.
///
/// Modeled on the real "Appearance" color schemes shipped in the Windows 95
/// Display control panel. Each scheme keeps the signature 3D silver control face
/// (`#c0c0c0`) constant — the bevel shading is identical across schemes — and
/// varies only the desktop backdrop and the title-bar / selection color.
/// The default [standard] is the iconic teal desktop with a navy title bar.
///
/// Dark mode keeps each scheme's caption and desktop hues on dark silver faces.
enum Win95Theme {
  /// The classic out-of-the-box look: teal desktop, navy title bars.
  standard(
    label: 'Standard',
    desktop: 0xFF008080,
    titleStart: 0xFF000080,
    titleEnd: 0xFF1084D0,
    accent: 0xFF000080,
    swatch: 0xFF008080,
  ),

  /// Slate-blue desktop with a deep blue title bar.
  rainyDay(
    label: 'Rainy Day',
    desktop: 0xFF3A5A78,
    titleStart: 0xFF0A246A,
    titleEnd: 0xFF3A6EA5,
    accent: 0xFF0A246A,
    swatch: 0xFF3A5A78,
  ),

  /// Muted plum desktop with a violet title bar.
  eggplant(
    label: 'Eggplant',
    desktop: 0xFF524E66,
    titleStart: 0xFF3E3557,
    titleEnd: 0xFF6E5E8E,
    accent: 0xFF3E3557,
    swatch: 0xFF524E66,
  ),

  /// Warm khaki desktop with an olive/brown title bar.
  desert(
    label: 'Desert',
    desktop: 0xFF9C8A63,
    titleStart: 0xFF6E5A2E,
    titleEnd: 0xFFA98E3E,
    accent: 0xFF6E5A2E,
    swatch: 0xFF9C8A63,
  ),

  /// Dusty rose desktop with a maroon title bar.
  rose(
    label: 'Rose',
    desktop: 0xFF7A5A5A,
    titleStart: 0xFF6E2E3A,
    titleEnd: 0xFFA85A66,
    accent: 0xFF6E2E3A,
    swatch: 0xFF7A5A5A,
  );

  /// Human-readable scheme name.
  final String label;

  /// The desktop backdrop color (behind windows).
  final int desktop;

  /// The active title-bar color. Win95 captions are painted solid with this.
  final int titleStart;

  /// The scheme's companion caption color (`--w95-title-b`). Windows 95 never
  /// blended the two — the navy-to-cyan caption gradient is a Windows 98
  /// feature — so this only feeds the dark scheme's accent and any host that
  /// redeclares `--w95-title-bar` as that later gradient.
  final int titleEnd;

  /// Selection / primary highlight color (menu selection, focused defaults).
  final int accent;

  /// The color-picker swatch shown in docs.
  final int swatch;

  const Win95Theme({
    required this.label,
    required this.desktop,
    required this.titleStart,
    required this.titleEnd,
    required this.accent,
    required this.swatch,
  });
}
