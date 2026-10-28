import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:jaspr_test/jaspr_test.dart';

String _hex(int color) =>
    '#${(color & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

void main() {
  test('comic seeds keep the subdued dark accent readable', () {
    const NeubrutalismStylesheet sheet = NeubrutalismStylesheet(
      variant: NeubrutalismVariant.neuComic,
    );
    expect(sheet.lightSeed.primary, 0xFFD42D38);
    expect(sheet.darkSeed.primary, 0xFFB85C50);
    final ThemePalette palette = PaletteGenerator.generate(sheet.darkSeed);
    expect(
      PaletteGenerator.contrastRatio(
        palette.primary,
        palette.primaryForeground,
      ),
      greaterThanOrEqualTo(4.5),
    );
  });

  for (final NeubrutalismTheme theme in NeubrutalismTheme.values) {
    test('${theme.name} dark seed agrees with renderer surfaces', () {
      final NeubrutalismStylesheet sheet = NeubrutalismStylesheet(theme: theme);
      final ThemeSeed seed = sheet.darkSeed;
      final String css = sheet.componentCss;
      expect(seed.background, theme.darkBackground);
      expect(seed.secondary, theme.darkSecondary);
      expect(seed.border, theme.darkBorder);
      expect(
        PaletteGenerator.contrastRatio(theme.darkBorder, theme.darkSecondary),
        greaterThanOrEqualTo(3),
        reason: 'Control boundaries remain visible on panel surfaces',
      );
      expect(
        PaletteGenerator.contrastRatio(
          theme.darkForeground,
          theme.darkSecondary,
        ),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        css,
        contains(
          '--background: var(--nb-dark-bg-in, ${_hex(seed.background!)});',
        ),
      );
      expect(
        css,
        contains('--secondary-background: ${_hex(seed.secondary!)};'),
      );
      expect(css, contains('--border: ${_hex(seed.border!)};'));
    });
  }

  test('red black text, emphasis, and control boundaries have contrast', () {
    const NeubrutalismTheme theme = NeubrutalismTheme.redBlack;
    for (final int surface in <int>[
      theme.darkBackground,
      theme.darkSecondary,
      theme.darkMuted,
      theme.darkCardHover,
    ]) {
      expect(
        PaletteGenerator.contrastRatio(theme.darkForeground, surface),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        PaletteGenerator.contrastRatio(theme.color, surface),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        PaletteGenerator.contrastRatio(theme.darkBorder, surface),
        greaterThanOrEqualTo(3),
      );
    }
    final ThemePalette palette = PaletteGenerator.generate(
      const NeubrutalismStylesheet(theme: theme).darkSeed,
    );
    expect(
      PaletteGenerator.contrastRatio(
        palette.primary,
        palette.primaryForeground,
      ),
      greaterThanOrEqualTo(4.5),
    );
    expect(theme.accentHot, theme.color);
    expect(theme.accentHot, isNot(NeubrutalismTheme.yellow.color));
  });

  test('focus ring can override renderer inline outline resets', () {
    final String css = const NeubrutalismStylesheet(
      theme: NeubrutalismTheme.redBlack,
    ).componentCss;
    expect(
      css,
      contains(
        '#arcane-root.arcane-theme-neubrutalism :focus-visible {\n'
        '  outline: var(--nb-border-base) solid var(--ring) !important;',
      ),
    );
  });
}
