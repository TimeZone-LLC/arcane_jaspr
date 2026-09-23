import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:jaspr_test/jaspr_test.dart';

const double _minimumTextContrast = 4.5;

String _hex(int color) =>
    '#${(color & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

int _cssHexToken(String block, String token) {
  final RegExpMatch? match = RegExp(
    '${RegExp.escape(token)}:\\s*(#[0-9a-fA-F]{6})',
  ).firstMatch(block);
  expect(match, isNotNull, reason: 'Missing $token in Midnight CSS block');
  return int.parse('FF${match!.group(1)!.substring(1)}', radix: 16);
}

void _expectMutedForegroundContrast({
  required String label,
  required int foreground,
  required Map<String, int> surfaces,
}) {
  for (final MapEntry<String, int> surface in surfaces.entries) {
    final double ratio = PaletteGenerator.contrastRatio(
      foreground,
      surface.value,
    );
    expect(
      ratio,
      greaterThanOrEqualTo(_minimumTextContrast),
      reason:
          '$label muted foreground ${_hex(foreground)} has '
          '${ratio.toStringAsFixed(3)}:1 contrast on '
          '${surface.key} ${_hex(surface.value)}',
    );
  }
}

void main() {
  group('generated ShadCN palette contrast', () {
    for (final ShadcnTheme theme in ShadcnTheme.values) {
      final ShadcnStylesheet stylesheet = ShadcnStylesheet(theme: theme);
      final List<(String, ThemeSeed)> modes = <(String, ThemeSeed)>[
        ('light', stylesheet.lightSeed),
        ('dark', stylesheet.darkSeed),
      ];

      for (final (String mode, ThemeSeed seed) in modes) {
        test('${theme.name} $mode muted text clears WCAG AA', () {
          final ThemePalette palette = PaletteGenerator.generate(seed);
          _expectMutedForegroundContrast(
            label: '${theme.name} $mode',
            foreground: palette.mutedForeground,
            surfaces: <String, int>{
              'background': palette.background,
              'card': palette.card,
              'muted': palette.muted,
              'popover': palette.popover,
            },
          );
        });
      }
    }
  });

  test('Midnight light CSS override preserves the contrast floor', () {
    final String css = const ShadcnStylesheet(
      theme: ShadcnTheme.midnight,
    ).componentCss;
    final RegExpMatch? lightBlockMatch = RegExp(
      r'#arcane-root\.arcane-theme-shadcn \{([^}]*)\}',
      dotAll: true,
    ).firstMatch(css);
    expect(lightBlockMatch, isNotNull);

    final String lightBlock = lightBlockMatch!.group(1)!;
    final int mutedForeground = _cssHexToken(lightBlock, '--muted-foreground');
    _expectMutedForegroundContrast(
      label: 'Midnight light CSS override',
      foreground: mutedForeground,
      surfaces: <String, int>{
        'card': _cssHexToken(lightBlock, '--card'),
        'muted': _cssHexToken(lightBlock, '--muted'),
        'popover': _cssHexToken(lightBlock, '--popover'),
      },
    );
  });

  test('Midnight dark CSS override preserves the contrast floor', () {
    final String css = const ShadcnStylesheet(
      theme: ShadcnTheme.midnight,
    ).componentCss;
    final RegExpMatch? darkBlockMatch = RegExp(
      r'#arcane-root\.dark\.arcane-theme-shadcn \{([^}]*)\}',
      dotAll: true,
    ).firstMatch(css);
    expect(darkBlockMatch, isNotNull);

    final String darkBlock = darkBlockMatch!.group(1)!;
    final int mutedForeground = _cssHexToken(darkBlock, '--muted-foreground');
    _expectMutedForegroundContrast(
      label: 'Midnight dark CSS override',
      foreground: mutedForeground,
      surfaces: <String, int>{
        'background': _cssHexToken(darkBlock, '--background'),
        'card': _cssHexToken(darkBlock, '--card'),
        'muted': _cssHexToken(darkBlock, '--muted'),
        'popover': _cssHexToken(darkBlock, '--popover'),
      },
    );
  });
}
