library;

enum NeubrutalismTheme {
  yellow(
    color: 0xFFFFD23F,
    accentHot: 0xFFFF6B6B,
    accentCool: 0xFF74B9FF,
    lightSurface: 0xFFFFFDF5,
    lightSecondary: 0xFFF5F0E8,
    lightAccent: 0xFFFFF3C4,
    lightBorder: 0xFF000000,
    lightInk: 0xFF000000,
  ),

  pink(
    color: 0xFFFF6B6B,
    accentHot: 0xFFFFD23F,
    accentCool: 0xFF88D498,
    lightSurface: 0xFFFFFDF5,
    lightSecondary: 0xFFF5F0E8,
    lightAccent: 0xFFFFE0E0,
    lightBorder: 0xFF000000,
    lightInk: 0xFF000000,
  ),

  mint(
    color: 0xFF88D498,
    accentHot: 0xFFFF6B6B,
    accentCool: 0xFF7FDBDA,
    lightSurface: 0xFFFFFDF5,
    lightSecondary: 0xFFF5F0E8,
    lightAccent: 0xFFE8F5E9,
    lightBorder: 0xFF000000,
    lightInk: 0xFF000000,
  ),

  orange(
    color: 0xFFFFA552,
    accentHot: 0xFFFFD23F,
    accentCool: 0xFF88D498,
    lightSurface: 0xFFFFFDF5,
    lightSecondary: 0xFFF5F0E8,
    lightAccent: 0xFFFFF0E0,
    lightBorder: 0xFF000000,
    lightInk: 0xFF000000,
  ),

  sky(
    color: 0xFF74B9FF,
    accentHot: 0xFFFFD23F,
    accentCool: 0xFF88D498,
    lightSurface: 0xFFFFFDF5,
    lightSecondary: 0xFFF5F0E8,
    lightAccent: 0xFFE3F2FD,
    lightBorder: 0xFF000000,
    lightInk: 0xFF000000,
  ),

  lavender(
    color: 0xFFB8A9FA,
    accentHot: 0xFFFF6B6B,
    accentCool: 0xFF74B9FF,
    lightSurface: 0xFFFFFDF5,
    lightSecondary: 0xFFF5F0E8,
    lightAccent: 0xFFF0ECFF,
    lightBorder: 0xFF000000,
    lightInk: 0xFF000000,
  ),

  lime(
    color: 0xFFC1FF72,
    accentHot: 0xFFFF6B6B,
    accentCool: 0xFF74B9FF,
    lightSurface: 0xFFF6FFE8,
    lightSecondary: 0xFFD9FFAA,
    lightAccent: 0xFFC1FF72,
    lightBorder: 0xFF000000,
    lightInk: 0xFF000000,
  ),

  red(
    color: 0xFFFF4444,
    accentHot: 0xFFFFD23F,
    accentCool: 0xFFFF8A8A,
    lightSurface: 0xFFFFFDF5,
    lightSecondary: 0xFFF5F0E8,
    lightAccent: 0xFFFFE0E0,
    lightBorder: 0xFF000000,
    lightInk: 0xFF000000,
  ),

  /// Red emphasis on neutral dark surfaces, with no yellow brand accent.
  redBlack(
    color: 0xFFFF5A5F,
    accentHot: 0xFFFF5A5F,
    accentCool: 0xFFFF9296,
    lightSurface: 0xFFFFF7F5,
    lightSecondary: 0xFFF5E9E7,
    lightAccent: 0xFFFFD5D5,
    lightBorder: 0xFF191616,
    lightInk: 0xFF191616,
    darkBackgroundColor: 0xFF111010,
    darkSecondaryColor: 0xFF1B1919,
    darkMutedColor: 0xFF262323,
    darkCardHoverColor: 0xFF302C2C,
    darkForeground: 0xFFF5F0E8,
    darkBorder: 0xFF79766A,
  ),

  greyscale(
    darkBackgroundColor: 0xFF101010,
    darkSecondaryColor: 0xFF1A1A1A,
    darkMutedColor: 0xFF292929,
    darkCardHoverColor: 0xFF292929,
    darkForeground: 0xFFF4F4F4,
    darkBorder: 0xFF797979,
    color: 0xFF1F1F1F,
    accentHot: 0xFF000000,
    accentCool: 0xFF6E6E6E,
    lightSurface: 0xFFF5F5F5,
    lightSecondary: 0xFFE6E6E6,
    lightAccent: 0xFFCFCFCF,
    lightBorder: 0xFF000000,
    lightInk: 0xFF000000,
  );

  final int color;

  final int accentHot;

  final int accentCool;

  final int lightSurface;

  final int lightSecondary;

  final int lightAccent;

  final int lightBorder;

  final int lightInk;

  final int? _darkBackgroundColor;
  final int? _darkSecondaryColor;
  final int? _darkMutedColor;
  final int? _darkCardHoverColor;
  final int darkForeground;
  final int darkBorder;

  /// These resolved surfaces also seed the generated stylesheet palette.
  int get darkBackground => _darkBackgroundColor ?? 0xFF191917;
  int get darkSecondary => _darkSecondaryColor ?? 0xFF282824;
  int get darkMuted => _darkMutedColor ?? 0xFF33332D;
  int get darkCardHover => _darkCardHoverColor ?? 0xFF34342E;

  const NeubrutalismTheme({
    required this.color,
    required this.accentHot,
    required this.accentCool,
    required this.lightSurface,
    required this.lightSecondary,
    required this.lightAccent,
    required this.lightBorder,
    required this.lightInk,
    int? darkBackgroundColor,
    int? darkSecondaryColor,
    int? darkMutedColor,
    int? darkCardHoverColor,
    this.darkForeground = 0xFFF3F0E7,
    this.darkBorder = 0xFF79766A,
  }) : _darkBackgroundColor = darkBackgroundColor,
       _darkSecondaryColor = darkSecondaryColor,
       _darkMutedColor = darkMutedColor,
       _darkCardHoverColor = darkCardHoverColor;
}
