import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:jaspr_test/server_test.dart';

const List<ShadcnTheme> _neutralThemes = <ShadcnTheme>[
  ShadcnTheme.midnight,
  ShadcnTheme.charcoal,
  ShadcnTheme.cream,
  ShadcnTheme.slate,
];

class _RendererHarness extends StatelessWidget {
  const _RendererHarness(this.builder);

  final Widget Function(BuildContext context) builder;

  @override
  Widget build(BuildContext context) => builder(context);
}

Future<String> _renderShadcn(
  ServerTester tester,
  Widget Function(BuildContext context) builder,
) async {
  tester.pumpComponent(
    ArcaneThemeProvider(
      stylesheet: const ShadcnStylesheet(),
      child: _RendererHarness(builder),
    ),
  );
  final DocumentResponse response = await tester.request('/');
  expect(response.statusCode, 200, reason: response.body);
  return response.body;
}

String _tagForClass(String html, String className) {
  for (final RegExpMatch match in RegExp(
    r'<[^>]+class="([^"]*)"[^>]*>',
  ).allMatches(html)) {
    if (match.group(1)!.split(' ').contains(className)) {
      return match.group(0)!;
    }
  }
  fail('Missing .$className in rendered HTML');
}

String _tagForId(String html, String id) {
  final RegExpMatch? match = RegExp(
    '<[^>]+ id="${RegExp.escape(id)}"[^>]*>',
  ).firstMatch(html);
  expect(match, isNotNull, reason: 'Missing #$id in rendered HTML');
  return match!.group(0)!;
}

List<String> _blocks(String css, String selector) {
  final List<String> blocks = RegExp(
    '(?:^|\\n)${RegExp.escape(selector)} \\{([^}]*)\\}',
  ).allMatches(css).map((RegExpMatch match) => match.group(1)!).toList();
  expect(blocks, isNotEmpty, reason: 'Missing block for $selector');
  return blocks;
}

String _rule(String css, String selectorStart) {
  final int selectorIndex = css.indexOf(selectorStart);
  expect(selectorIndex, isNonNegative, reason: 'Missing $selectorStart');
  final int blockEnd = css.indexOf('}', selectorIndex);
  return css.substring(selectorIndex, blockEnd + 1);
}

int _hexToken(String block, String token) {
  final RegExpMatch? match = RegExp(
    '${RegExp.escape(token)}:\\s*#([0-9a-fA-F]{6});',
  ).firstMatch(block);
  expect(match, isNotNull, reason: 'Missing hex $token');
  return int.parse('FF${match!.group(1)!}', radix: 16);
}

/// ARGB value of a `#rrggbb` or `rgba(r, g, b, a)` token, or null when the
/// block does not declare it (the generated palette value applies then).
int? _colorToken(String block, String token) {
  final RegExpMatch? hex = RegExp(
    '${RegExp.escape(token)}:\\s*#([0-9a-fA-F]{6});',
  ).firstMatch(block);
  if (hex != null) return int.parse('FF${hex.group(1)!}', radix: 16);
  final RegExpMatch? rgba = RegExp(
    '${RegExp.escape(token)}:\\s*rgba\\((\\d+),\\s*(\\d+),\\s*(\\d+),\\s*([0-9.]+)\\);',
  ).firstMatch(block);
  if (rgba == null) return null;
  final int alpha = (double.parse(rgba.group(4)!) * 255).round();
  return (alpha << 24) |
      (int.parse(rgba.group(1)!) << 16) |
      (int.parse(rgba.group(2)!) << 8) |
      int.parse(rgba.group(3)!);
}

/// The `--input` share declared by the `--shadcn-control-border` mix.
double _controlBorderShare(String block) {
  final RegExpMatch? match = RegExp(
    r'--shadcn-control-border: color-mix\(in srgb, var\(--input\) (\d+)%, '
    r'var\(--foreground\)\);',
  ).firstMatch(block);
  expect(match, isNotNull, reason: 'Missing --shadcn-control-border mix');
  return int.parse(match!.group(1)!) / 100;
}

/// Contrast of `color-mix(in srgb, input share%, foreground)` (premultiplied
/// alpha, as browsers interpolate) once composited over [surface].
double _mixedBorderContrast({
  required int input,
  required int foreground,
  required double inputShare,
  required int surface,
}) {
  final double inputAlpha = ((input >> 24) & 0xFF) / 255;
  final double alpha = inputShare * inputAlpha + (1 - inputShare);
  int channel(int shift) {
    final double mixed =
        (inputShare * inputAlpha * ((input >> shift) & 0xFF) +
            (1 - inputShare) * ((foreground >> shift) & 0xFF)) /
        alpha;
    final int base = (surface >> shift) & 0xFF;
    return (base + alpha * (mixed - base)).round().clamp(0, 255);
  }

  final int composed =
      0xFF000000 | (channel(16) << 16) | (channel(8) << 8) | channel(0);
  return PaletteGenerator.contrastRatio(composed, surface);
}

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
        inputs.every(
          (String input) => input.contains('data-arcane-group="plan"'),
        ),
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

  group('ShadCN v4 token contract', () {
    for (final ShadcnTheme theme in ShadcnTheme.values) {
      test(
        '${theme.name} defines the shared focus, surface and item tokens',
        () {
          final String css = ShadcnStylesheet(theme: theme).componentCss;
          final String root = _blocks(
            css,
            '#arcane-root.arcane-theme-shadcn',
          ).join('\n');
          expect(
            root,
            contains(
              '--shadcn-focus-ring: 0 0 0 3px '
              'color-mix(in oklab, var(--ring) 50%, transparent);',
            ),
          );
          expect(root, contains('--shadcn-focus-border: var(--ring);'));
          expect(root, contains('--shadcn-surface-shadow: var(--shadow-md);'));
          expect(root, contains('--shadcn-item-radius: var(--radius-sm);'));
          expect(root, contains('--shadcn-input-background: transparent;'));
          final String dark = _blocks(
            css,
            'html.dark #arcane-root.arcane-theme-shadcn,\n'
            '#arcane-root.dark.arcane-theme-shadcn',
          ).join('\n');
          expect(
            dark,
            contains(
              '--shadcn-input-background: '
              'color-mix(in srgb, var(--input) 30%, transparent);',
            ),
          );
        },
      );
    }

    for (final ShadcnTheme theme in _neutralThemes) {
      test('${theme.name} light surfaces follow the shadcn neutral ladder', () {
        final String css = ShadcnStylesheet(theme: theme).componentCss;
        final String light = _blocks(
          css,
          '#arcane-root.arcane-theme-shadcn',
        ).first;
        for (final String token in <String>[
          '--secondary',
          '--accent',
          '--muted',
        ]) {
          final int value = _hexToken(light, token);
          expect(
            PaletteGenerator.contrastRatio(value, 0xFFFFFFFF),
            lessThan(1.12),
            reason: '${theme.name} $token must stay a light shadcn surface',
          );
        }
        for (final String token in <String>['--border', '--input']) {
          final double ratio = PaletteGenerator.contrastRatio(
            _hexToken(light, token),
            0xFFFFFFFF,
          );
          expect(ratio, inInclusiveRange(1.15, 1.35), reason: token);
        }
        final double ringRatio = PaletteGenerator.contrastRatio(
          _hexToken(light, '--ring'),
          0xFFFFFFFF,
        );
        expect(ringRatio, inInclusiveRange(2.2, 3.2));
        final int mutedForeground = _hexToken(light, '--muted-foreground');
        for (final String surface in <String>[
          '--card',
          '--popover',
          '--muted',
          '--secondary',
          '--accent',
        ]) {
          expect(
            PaletteGenerator.contrastRatio(
              mutedForeground,
              _hexToken(light, surface),
            ),
            greaterThanOrEqualTo(4.5),
            reason: '${theme.name} muted-foreground on $surface',
          );
        }
      });

      test('${theme.name} dark block uses translucent v4 borders', () {
        final String css = ShadcnStylesheet(theme: theme).componentCss;
        final String dark = _blocks(
          css,
          'html.dark #arcane-root.arcane-theme-shadcn,\n'
          '#arcane-root.dark.arcane-theme-shadcn',
        ).first;
        expect(dark, contains('--border: rgba(255, 255, 255, 0.1);'));
        expect(dark, contains('--input: rgba(255, 255, 255, 0.15);'));
        final double ringRatio = PaletteGenerator.contrastRatio(
          _hexToken(dark, '--ring'),
          0xFF000000,
        );
        expect(ringRatio, inInclusiveRange(3.5, 6));
      });
    }

    test('midnight dark follows the shadcn neutral scale', () {
      final String css = const ShadcnStylesheet().componentCss;
      final String dark = _blocks(
        css,
        'html.dark #arcane-root.arcane-theme-shadcn,\n'
        '#arcane-root.dark.arcane-theme-shadcn',
      ).first;
      expect(dark, contains('--background: #0a0a0a;'));
      expect(dark, contains('--card: #171717;'));
      expect(dark, contains('--secondary: #262626;'));
      expect(dark, contains('--accent: #262626;'));
      expect(dark, contains('--muted: #262626;'));
      expect(dark, contains('--muted-foreground: #a3a3a3;'));
      expect(dark, contains('--ring: #737373;'));
    });

    for (final ShadcnTheme theme in ShadcnTheme.values) {
      test('${theme.name} control border clears 3:1 on page and card', () {
        final ShadcnStylesheet stylesheet = ShadcnStylesheet(theme: theme);
        final String css = stylesheet.componentCss;
        final Map<String, (String, ThemePalette)> modes =
            <String, (String, ThemePalette)>{
              'light': (
                _blocks(css, '#arcane-root.arcane-theme-shadcn').join('\n'),
                PaletteGenerator.generate(stylesheet.lightSeed),
              ),
              'dark': (
                _blocks(
                  css,
                  'html.dark #arcane-root.arcane-theme-shadcn,\n'
                  '#arcane-root.dark.arcane-theme-shadcn',
                ).join('\n'),
                PaletteGenerator.generate(stylesheet.darkSeed),
              ),
            };
        for (final MapEntry<String, (String, ThemePalette)> mode
            in modes.entries) {
          final (String block, ThemePalette palette) = mode.value;
          final double share = _controlBorderShare(block);
          final int input = _colorToken(block, '--input') ?? palette.input;
          final int foreground =
              _colorToken(block, '--foreground') ?? palette.foreground;
          final Map<String, int> surfaces = <String, int>{
            'background':
                _colorToken(block, '--background') ?? palette.background,
            'card': _colorToken(block, '--card') ?? palette.card,
          };
          for (final MapEntry<String, int> surface in surfaces.entries) {
            final double ratio = _mixedBorderContrast(
              input: input,
              foreground: foreground,
              inputShare: share,
              surface: surface.value,
            );
            expect(
              ratio,
              greaterThanOrEqualTo(3),
              reason:
                  '${theme.name} ${mode.key} control border on '
                  '${surface.key} is ${ratio.toStringAsFixed(2)}:1',
            );
          }
        }
      });
    }

    test('pastel palettes keep their explicit surfaces', () {
      final String css = const ShadcnStylesheet(
        theme: ShadcnTheme.rose,
      ).componentCss;
      final String root = _blocks(
        css,
        '#arcane-root.arcane-theme-shadcn',
      ).join('\n');
      expect(root, isNot(contains('--secondary:')));
      expect(root, isNot(contains('--accent:')));
      expect(root, isNot(contains('--input:')));
    });

    test('scrims keep the generated 50% overlay', () {
      final String css = const ShadcnStylesheet().baseCss;
      expect(css, contains('--overlay: rgba(0, 0, 0, 0.50);'));
    });

    test('state selectors target attributes the runtime maintains', () {
      final String css = const ShadcnStylesheet().componentCss;
      expect(css, isNot(contains("[data-open='true']")));
      expect(css, isNot(contains("[data-state='checked']")));
      expect(css, isNot(contains('0 0 0 2px var(--background), 0 0 0 4px')));
      expect(css, contains(".arcane-select[aria-expanded='true']"));
      // Tabs, menu rows and the docs sidebar header are styled by the
      // surfaces part; the token file must not carry competing rules.
      expect(css, isNot(contains(".arcane-tab[data-state='active']")));
      expect(css, isNot(contains('.arcane-dropdown-item:focus-visible')));
      expect(css, isNot(contains('.arcane-context-menu-item:focus-visible')));
      expect(css, isNot(contains('.arcane-tab:hover')));
      expect(css, isNot(contains('box-shadow: 0 1px 0')));
      expect(css, isNot(contains(".arcane-text-input[data-error='true']")));
      final String option = _rule(css, '.arcane-select-option:is(');
      expect(option, contains("[aria-selected='true']"));
      expect(option, contains("[data-arcane-state='active']"));
      expect(option, contains('--shadcn-item-background: var(--accent);'));
      expect(
        option,
        contains('--shadcn-item-foreground: var(--accent-foreground);'),
      );
      final String focus = _rule(css, '.arcane-button:focus-visible,');
      expect(focus, contains('outline: none;'));
      expect(
        focus,
        contains(
          '--shadcn-control-shadow: var(--shadow-xs), var(--shadcn-focus-ring);',
        ),
      );
      expect(
        focus,
        contains('--shadcn-control-border-color: var(--shadcn-focus-border);'),
      );
    });

    test('buttons use one hover treatment without the base filter', () {
      final String css = const ShadcnStylesheet().componentCss;
      final String filter = _rule(
        css,
        '#arcane-root.arcane-theme-shadcn .arcane-button:hover,',
      );
      expect(filter, contains('filter: none;'));
      expect(
        css,
        contains('color-mix(in srgb, var(--primary) 90%, transparent)'),
      );
      expect(
        css,
        contains('color-mix(in srgb, var(--secondary) 80%, transparent)'),
      );
      expect(
        css,
        contains('color-mix(in srgb, var(--destructive) 90%, transparent)'),
      );
      expect(css, isNot(contains('88%, var(--shadcn-button-foreground)')));
      expect(
        css,
        contains(
          'border-color: var(--shadcn-control-border-color, var(--input));',
        ),
      );
    });
  });

  group('ShadCN v4 control sizing', () {
    testServer('buttons use v4 heights, radius and shadow-xs', (
      ServerTester tester,
    ) async {
      final String html = await _renderShadcn(
        tester,
        (BuildContext context) => Column(
          children: <Widget>[
            for (final ButtonSize size in ButtonSize.values)
              context.renderers.button(
                ButtonProps(id: 'button-${size.name}', label: 'Go', size: size),
              ),
            context.renderers.button(
              const ButtonProps(
                id: 'button-ghost',
                label: 'Ghost',
                variant: ButtonVariant.ghost,
              ),
            ),
          ],
        ),
      );
      final Map<ButtonSize, String> heights = <ButtonSize, String>{
        ButtonSize.sm: 'height: 2rem',
        ButtonSize.md: 'height: 2.25rem',
        ButtonSize.lg: 'height: 2.5rem',
        ButtonSize.iconSm: 'height: 2rem',
        ButtonSize.iconMd: 'height: 2.25rem',
        ButtonSize.iconLg: 'height: 2.5rem',
      };
      for (final MapEntry<ButtonSize, String> entry in heights.entries) {
        final String tag = _tagForId(html, 'button-${entry.key.name}');
        expect(tag, contains(entry.value), reason: entry.key.name);
        expect(tag, contains('border-radius: var(--radius-md)'));
        expect(
          tag,
          contains(
            'box-shadow: var(--shadcn-control-shadow, var(--shadow-xs))',
          ),
        );
        expect(tag, isNot(contains('color:')));
      }
      expect(_tagForId(html, 'button-sm'), contains('padding: 0 0.75rem'));
      expect(_tagForId(html, 'button-lg'), contains('padding: 0 1.5rem'));
      expect(_tagForId(html, 'button-iconMd'), contains('width: 2.25rem'));
      expect(
        _tagForId(html, 'button-ghost'),
        contains('box-shadow: var(--shadcn-control-shadow, none)'),
      );
    });

    testServer('text inputs and text areas follow the v4 input recipe', (
      ServerTester tester,
    ) async {
      final String html = await _renderShadcn(
        tester,
        (BuildContext context) => Column(
          children: <Widget>[
            context.renderers.textInput(
              const TextInputProps(id: 'plain', placeholder: 'Email'),
            ),
            context.renderers.textInput(
              const TextInputProps(id: 'invalid', error: 'Required'),
            ),
            const TextArea(id: 'notes'),
          ],
        ),
      );
      final String input = _tagForId(html, 'plain');
      expect(input, contains('height: 2.25rem'));
      expect(input, contains('padding: 0.25rem 0.75rem'));
      expect(input, contains('font-size: 0.875rem'));
      expect(input, contains('border-radius: var(--radius-md)'));
      expect(
        input,
        contains(
          'border: 1px solid var(--shadcn-control-border-color, var(--shadcn-control-border))',
        ),
      );
      expect(
        input,
        contains(
          'background-color: var(--shadcn-input-background, transparent)',
        ),
      );
      expect(
        input,
        contains('box-shadow: var(--shadcn-control-shadow, var(--shadow-xs))'),
      );
      expect(
        _tagForId(html, 'invalid'),
        contains(
          'border: 1px solid var(--shadcn-control-border-color, var(--destructive))',
        ),
      );
      final String textArea = _tagForId(html, 'notes');
      expect(textArea, contains('min-height: 4rem'));
      expect(textArea, contains('padding: 0.5rem 0.75rem'));
      expect(textArea, contains('font-size: 0.875rem'));
      expect(textArea, contains('border-radius: var(--radius-md)'));
      expect(
        textArea,
        contains(
          'border: 1px solid var(--shadcn-control-border-color, var(--shadcn-control-border))',
        ),
      );
      final String css = const ShadcnStylesheet().componentCss;
      expect(css, contains('.arcane-text-input::placeholder'));
      final String invalid = _rule(
        css,
        '#arcane-root.arcane-theme-shadcn :is(.arcane-text-input,',
      );
      expect(invalid, contains("[aria-invalid='true']"));
      expect(
        invalid,
        contains('--shadcn-control-border-color: var(--destructive);'),
      );
      expect(
        invalid,
        contains('--shadcn-focus-ring: var(--shadcn-invalid-ring);'),
      );
    });

    testServer('select trigger, content and options follow v4 sizing', (
      ServerTester tester,
    ) async {
      final String html = await _renderShadcn(
        tester,
        (BuildContext context) => context.renderers.select<String>(
          const SelectProps<String>(
            id: 'fruit',
            value: 'apple',
            options: <SelectOptionProps<String>>[
              SelectOptionProps<String>(value: 'apple', label: 'Apple'),
              SelectOptionProps<String>(value: 'pear', label: 'Pear'),
            ],
          ),
        ),
      );
      final String trigger = _tagForClass(html, 'arcane-select');
      expect(trigger, contains('height: 2.25rem'));
      expect(trigger, contains('padding: 0.25rem 0.75rem'));
      expect(trigger, contains('font-size: 0.875rem'));
      expect(trigger, contains('border-radius: var(--radius-md)'));
      expect(
        trigger,
        contains(
          'border: 1px solid var(--shadcn-control-border-color, var(--shadcn-control-border))',
        ),
      );
      expect(
        trigger,
        contains('box-shadow: var(--shadcn-control-shadow, var(--shadow-xs))'),
      );
      final String chevron = _tagForClass(html, 'arcane-select-chevron');
      expect(chevron, contains('opacity: 0.5'));
      expect(html, contains(String.fromCharCode(0xe06d)));
      expect(html, isNot(contains(String.fromCharCode(0xe211))));
      final String content = _tagForClass(html, 'arcane-select-dropdown');
      expect(content, contains('border-radius: var(--radius-md)'));
      expect(content, contains('box-shadow: var(--shadcn-surface-shadow)'));
      expect(content, contains('min-width: 8rem'));
      expect(content, contains('background-color: var(--popover)'));
      expect(
        _tagForClass(html, 'arcane-select-options'),
        contains('padding: 0.25rem'),
      );
      final String option = _tagForClass(html, 'arcane-select-option');
      expect(option, contains('padding: 0.375rem 0.5rem'));
      expect(option, contains('border-radius: var(--shadcn-item-radius)'));
      expect(
        option,
        contains(
          'background-color: var(--shadcn-item-background, transparent)',
        ),
      );
      expect(option, contains('color: var(--shadcn-item-foreground, inherit)'));
    });

    testServer('native select renderer uses the v4 input recipe', (
      ServerTester tester,
    ) async {
      final String html = await _renderShadcn(
        tester,
        (BuildContext context) => context.renderers.nativeSelect(
          const NativeSelectProps(
            id: 'native',
            options: <NativeSelectOptionProps>[
              NativeSelectOptionProps(label: 'One', value: 'one'),
            ],
          ),
        ),
      );
      final String select = _tagForId(html, 'native');
      expect(select, contains('height: 2.25rem'));
      expect(select, contains('font-size: 0.875rem'));
      expect(select, contains('border-radius: var(--arcane-radius-md, 8px)'));
      expect(
        select,
        contains(
          'border: 1px solid var(--shadcn-control-border-color, var(--shadcn-control-border))',
        ),
      );
      expect(select, contains('var(--shadcn-input-background, transparent)'));
      expect(select.replaceAll(' ', ''), contains('padding-right:40px'));
    });

    testServer('checkbox, radio and switch follow v4 geometry', (
      ServerTester tester,
    ) async {
      final String html = await _renderShadcn(
        tester,
        (BuildContext context) => Column(
          children: <Widget>[
            context.renderers.checkbox(
              const CheckboxProps(id: 'terms', checked: true),
            ),
            context.renderers.toggleSwitch(
              const ToggleSwitchProps(id: 'wifi', value: true),
            ),
            context.renderers.radioGroup<String>(
              const RadioGroupProps<String>(
                name: 'plan',
                value: 'solo',
                options: <RadioOptionProps<String>>[
                  RadioOptionProps<String>(value: 'solo', label: 'Solo'),
                ],
              ),
            ),
          ],
        ),
      );
      final String checkbox = _tagForClass(html, 'arcane-checkbox');
      expect(checkbox, contains('width: 16px'));
      expect(checkbox, contains('border-radius: var(--radius-xs)'));
      expect(
        checkbox,
        contains(
          'border: 1px solid var(--shadcn-control-border-color, '
          'var(--shadcn-checkbox-border, var(--shadcn-control-border)))',
        ),
      );
      expect(
        checkbox,
        contains('box-shadow: var(--shadcn-control-shadow, var(--shadow-xs))'),
      );
      final String track = _tagForClass(html, 'arcane-toggle-switch');
      expect(track, contains('width: 32px'));
      expect(track, contains('height: 18px'));
      expect(track, contains('border-radius: var(--radius-md)'));
      expect(
        track,
        contains(
          'border: 1px solid var(--shadcn-control-border-color, transparent)',
        ),
      );
      final String thumb = _tagForClass(html, 'arcane-toggle-thumb');
      expect(thumb, contains('width: 16px'));
      expect(thumb, contains('border-radius: var(--radius-md)'));
      expect(thumb, isNot(contains('box-shadow')));
      final String circle = _tagForClass(html, 'arcane-radio-circle');
      expect(
        circle,
        contains(
          'border: 1px solid var(--shadcn-control-border-color, '
          'var(--shadcn-radio-border, var(--shadcn-control-border)))',
        ),
      );
      expect(
        circle,
        contains('box-shadow: var(--shadcn-control-shadow, var(--shadow-xs))'),
      );
      final RegExpMatch? dot = RegExp(
        r'<div[^>]*data-arcane-intrinsic-shape="radio-dot"[^>]*>',
      ).firstMatch(html);
      expect(dot, isNotNull, reason: 'Missing radio dot in rendered HTML');
      expect(dot!.group(0), contains('width: 8px'));
      expect(dot.group(0), contains('height: 8px'));
      final String css = const ShadcnStylesheet().componentCss;
      final String checked = _rule(
        css,
        "#arcane-root.arcane-theme-shadcn .arcane-checkbox[data-arcane-state='selected']",
      );
      expect(
        checked,
        contains('--shadcn-checkbox-border: var(--shadcn-checkbox-fill);'),
      );
      final String on = _rule(
        css,
        "#arcane-root.arcane-theme-shadcn .arcane-toggle-switch[data-arcane-state='selected']",
      );
      expect(on, contains('--shadcn-switch-offset: calc(100% - 2px);'));
    });

    testServer('segmented radio buttons round only the outer corners', (
      ServerTester tester,
    ) async {
      final String html = await _renderShadcn(
        tester,
        (BuildContext context) => context.renderers.radioGroup<String>(
          const RadioGroupProps<String>(
            name: 'view',
            value: 'grid',
            variant: RadioGroupVariant.buttons,
            options: <RadioOptionProps<String>>[
              RadioOptionProps<String>(value: 'grid', label: 'Grid'),
              RadioOptionProps<String>(value: 'list', label: 'List'),
            ],
          ),
        ),
      );
      expect(
        _tagForClass(html, 'arcane-radio-group-options'),
        contains('gap: 0'),
      );
      final String item = _tagForClass(html, 'arcane-radio-button');
      expect(item, contains('height: 2.25rem'));
      expect(item, isNot(contains('margin-left')));
      expect(item, isNot(contains('border-radius')));
      final String css = const ShadcnStylesheet().componentCss;
      expect(
        _rule(
          css,
          '#arcane-root.arcane-theme-shadcn .arcane-radio-button:first-child',
        ),
        contains('border-radius: var(--radius-md) 0 0 var(--radius-md);'),
      );
      expect(
        _rule(
          css,
          '#arcane-root.arcane-theme-shadcn .arcane-radio-button:last-child',
        ),
        contains('border-radius: 0 var(--radius-md) var(--radius-md) 0;'),
      );
    });

    testServer('toggle group, OTP, cycle and toggle buttons are 36px', (
      ServerTester tester,
    ) async {
      final String html = await _renderShadcn(
        tester,
        (BuildContext context) => Column(
          children: <Widget>[
            context.renderers.toggleGroup(
              const ToggleGroupProps(
                value: 'b',
                items: <ToggleGroupItemProps>[
                  ToggleGroupItemProps(value: 'b', child: Text('B')),
                ],
              ),
            ),
            context.renderers.otpInput(const OtpInputProps(length: 4)),
            context.renderers.cycleButton<String>(
              const CycleButtonProps<String>(
                id: 'cycle',
                value: 'a',
                options: <CycleOption<String>>[
                  CycleOption<String>(value: 'a', label: 'A'),
                ],
              ),
            ),
            context.renderers.toggleButton(
              const ToggleButtonProps(id: 'bold', value: true, label: 'Bold'),
            ),
          ],
        ),
      );
      final String item = _tagForClass(html, 'arcane-toggle-group-item');
      expect(item, contains('height: 2.25rem'));
      expect(item, contains('border-radius: var(--radius-md)'));
      expect(
        item,
        contains(
          'background-color: var(--shadcn-item-background, transparent)',
        ),
      );
      final String digit = _tagForClass(html, 'arcane-otp-digit');
      expect(digit, contains('height: 2.25rem'));
      expect(digit, contains('font-size: 0.875rem'));
      expect(
        digit,
        contains(
          'border: 1px solid var(--shadcn-control-border-color, var(--shadcn-control-border))',
        ),
      );
      expect(digit, contains('border-radius: var(--radius-md)'));
      final String cycle = _tagForId(html, 'cycle');
      expect(cycle, contains('height: 2.25rem'));
      expect(cycle, contains('data-variant="outline"'));
      expect(cycle, isNot(contains('background-color:')));
      final String toggle = _tagForId(html, 'bold');
      expect(toggle, contains('height: 2.25rem'));
      expect(
        toggle,
        contains(
          'background-color: var(--shadcn-item-background, transparent)',
        ),
      );
    });

    testServer('field wrapper and form use v4 label rhythm and buttons', (
      ServerTester tester,
    ) async {
      final String html = await _renderShadcn(
        tester,
        (BuildContext context) => context.renderers.form(
          FormProps(
            onCancel: () {},
            children: <Widget>[
              context.renderers.fieldWrapper(
                const FieldWrapperProps(
                  field: Text('Field'),
                  labelText: 'Email',
                  description: 'Work address',
                  error: 'Required',
                ),
              ),
            ],
          ),
        ),
      );
      expect(
        _tagForClass(html, 'arcane-field-wrapper'),
        contains('gap: 0.5rem'),
      );
      final String label = _tagForClass(html, 'arcane-field-label');
      expect(label, contains('font-size: 0.875rem'));
      expect(label, contains('line-height: 1'));
      expect(
        _tagForClass(html, 'arcane-field-description'),
        contains('font-size: 0.875rem'),
      );
      expect(
        _tagForClass(html, 'arcane-field-error'),
        contains('font-size: 0.875rem'),
      );
      final List<String> actions = RegExp(
        r'<button[^>]*class="arcane-button"[^>]*>',
      ).allMatches(html).map((RegExpMatch match) => match.group(0)!).toList();
      expect(actions, hasLength(2));
      expect(actions.first, contains('data-variant="outline"'));
      expect(actions.last, contains('data-variant="primary"'));
      expect(actions.last, contains('type="submit"'));
    });
  });
}
