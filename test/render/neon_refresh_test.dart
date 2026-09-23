import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neon/arcane_jaspr_neon.dart';
import 'package:jaspr_test/server_test.dart';

void main() {
  for (final RadioGroupVariant variant in RadioGroupVariant.values) {
    testServer(
      'Neon ${variant.name} radios retain native form and label semantics',
      (ServerTester tester) async {
        tester.pumpComponent(
          ArcaneThemeProvider(
            stylesheet: const NeonStylesheet(),
            child: ArcaneRadioGroup<String>(
              id: 'plan',
              name: 'plan',
              label: 'Plan',
              value: 'team',
              error: 'Choose an available plan',
              required: true,
              variant: variant,
              options: const <RadioOption<String>>[
                RadioOption<String>(
                  value: 'solo',
                  label: 'Solo',
                  description: 'One person',
                ),
                RadioOption<String>(
                  value: 'team',
                  label: 'Team',
                  description: 'Multiple people',
                ),
                RadioOption<String>(
                  value: 'enterprise',
                  label: 'Enterprise',
                  disabled: true,
                ),
              ],
            ),
          ),
        );
        final DocumentResponse response = await tester.request('/');
        expect(response.statusCode, 200, reason: response.body);
        final List<String> inputs = RegExp(r'<input[^>]+type="radio"[^>]*>')
            .allMatches(response.body)
            .map((RegExpMatch match) => match.group(0)!)
            .toList();
        expect(inputs, hasLength(3));
        expect(
          inputs.every((String input) => input.contains('name="plan"')),
          isTrue,
        );
        expect(
          inputs.every((String input) => input.contains('required')),
          isTrue,
        );
        expect(inputs[0], contains('aria-labelledby="plan-option-0-label"'));
        expect(
          inputs[0],
          contains('aria-describedby="plan-option-0-description plan-message"'),
        );
        expect(inputs[1], contains('checked'));
        expect(inputs[2], contains('disabled'));
        expect(
          inputs.every((String input) => !input.contains('data-arcane-action')),
          isTrue,
        );
        expect(
          inputs.every(
            (String input) => input.contains('data-arcane-group="plan"'),
          ),
          isTrue,
        );
        expect(response.body, contains('role="radiogroup"'));
        expect(response.body, contains('id="plan-label"'));
        expect(response.body, contains('id="plan-message"'));
      },
    );
  }

  test(
    'Neon accent ink remains readable on plain and highlighted surfaces',
    () {
      const NeonStylesheet stylesheet = NeonStylesheet();
      for (final ThemeSeed seed in <ThemeSeed>[
        stylesheet.lightSeed,
        stylesheet.darkSeed,
      ]) {
        final ThemePalette palette = PaletteGenerator.generate(seed);
        final int ink = seed.isDark ? 0xFF34d399 : 0xFF065f46;
        for (final int surface in <int>[
          palette.background,
          palette.card,
          PaletteGenerator.blendColors(palette.primary, palette.card, 0.16),
        ]) {
          expect(
            PaletteGenerator.contrastRatio(ink, surface),
            greaterThanOrEqualTo(4.5),
          );
        }
      }
    },
  );

  testServer('Neon compact prefixed inputs own one sized shell', (
    ServerTester tester,
  ) async {
    tester.pumpComponent(
      ArcaneThemeProvider(
        stylesheet: const NeonStylesheet(),
        child: TextInput(
          id: 'search',
          label: 'Search',
          size: ComponentSize.sm,
          prefix: ArcaneIcon.search(),
        ),
      ),
    );
    final DocumentResponse response = await tester.request('/');
    expect(response.statusCode, 200, reason: response.body);
    final String input = RegExp(
      r'<input id="search"[^>]*>',
    ).firstMatch(response.body)!.group(0)!;
    expect(input, contains('height: 32px'));
    expect(input, contains('data-arcane-field-inner="true"'));
    expect(response.body, contains('data-arcane-field-shell="true"'));
    expect(response.body, contains('1px solid var(--neon-control-border)'));
  });
}
