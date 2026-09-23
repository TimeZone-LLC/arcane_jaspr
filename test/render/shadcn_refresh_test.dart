import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:jaspr_test/server_test.dart';

void main() {
  for (final RadioGroupVariant variant in RadioGroupVariant.values) {
    testServer('ShadCN ${variant.name} radio visuals follow native selection', (
      ServerTester tester,
    ) async {
      tester.pumpComponent(
        ArcaneThemeProvider(
          stylesheet: const ShadcnStylesheet(),
          child: ArcaneRadioGroup<String>(
            name: 'plan',
            value: 'solo',
            required: true,
            variant: variant,
            options: const <RadioOption<String>>[
              RadioOption<String>(value: 'solo', label: 'Solo'),
              RadioOption<String>(value: 'team', label: 'Team'),
            ],
          ),
        ),
      );
      final DocumentResponse response = await tester.request('/');
      final List<String> inputs = RegExp(r'<input[^>]*>')
          .allMatches(response.body)
          .map((RegExpMatch match) => match.group(0)!)
          .toList();
      expect(inputs, hasLength(2));
      expect(
        inputs.every((String input) => input.contains('required')),
        isTrue,
      );
      expect(inputs[0], contains('checked'));
      expect(inputs[1], isNot(contains(' checked')));
      expect(
        inputs.every((String input) => input.contains('data-arcane-group="plan"')),
        isTrue,
      );
      expect(response.body, isNot(contains('data-arcane-action')));
      if (variant == RadioGroupVariant.standard) {
        expect(
          RegExp(
            'data-arcane-intrinsic-shape="radio-dot"',
          ).allMatches(response.body),
          hasLength(2),
        );
        expect(response.body, contains('var(--shadcn-radio-dot-opacity, 0)'));
      } else {
        expect(response.body, contains('var(--shadcn-radio-border,'));
        expect(
          response.body,
          contains(
            variant == RadioGroupVariant.cards
                ? 'var(--shadcn-radio-card-background,'
                : 'var(--shadcn-radio-button-background,',
          ),
        );
      }
    });
  }

  test('every ShadCN palette keeps accent and status text readable', () {
    for (final ShadcnTheme theme in ShadcnTheme.values) {
      final ShadcnStylesheet stylesheet = ShadcnStylesheet(theme: theme);
      for (final ThemeSeed seed in <ThemeSeed>[
        stylesheet.lightSeed,
        stylesheet.darkSeed,
      ]) {
        final ThemePalette palette = PaletteGenerator.generate(seed);
        for (final int foreground in <int>[
          palette.primary,
          palette.destructive,
          palette.success,
          palette.warning,
          palette.info,
        ]) {
          for (final int background in <int>[
            palette.background,
            palette.card,
          ]) {
            expect(
              PaletteGenerator.contrastRatio(foreground, background),
              greaterThanOrEqualTo(4.5),
              reason:
                  '${theme.name} ${seed.isDark ? 'dark' : 'light'} '
                  '${foreground.toRadixString(16)} on ${background.toRadixString(16)}',
            );
          }
        }
      }
    }
  });

  testServer('button colors remain available to hover and instance overrides', (
    ServerTester tester,
  ) async {
    tester.pumpComponent(
      const ArcaneThemeProvider(
        stylesheet: ShadcnStylesheet(),
        child: Column(
          children: <Widget>[
            Button(id: 'primary', label: 'Save'),
            Button(
              id: 'link',
              label: 'Details',
              variant: ButtonVariant.link,
              href: '/details',
            ),
          ],
        ),
      ),
    );
    final DocumentResponse response = await tester.request('/');
    expect(response.statusCode, 200);
    final String button = RegExp(
      r'<button id="primary"[^>]*>',
    ).firstMatch(response.body)!.group(0)!;
    expect(button, isNot(contains('background-color:')));
    expect(button, isNot(contains('color:')));
    final String link = RegExp(
      r'<a id="link"[^>]*>',
    ).firstMatch(response.body)!.group(0)!;
    expect(link, contains('text-decoration: underline'));
  });
}
