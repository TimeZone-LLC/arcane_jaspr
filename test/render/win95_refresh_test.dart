import 'dart:io';

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_win95/arcane_jaspr_win95.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr_test/server_test.dart';

class _Win95RefreshHarness extends StatelessWidget {
  const _Win95RefreshHarness();

  @override
  Widget build(BuildContext context) => dom.form(
    attributes: const <String, String>{'id': 'refresh-controls'},
    styles: const dom.Styles(
      raw: <String, String>{
        'max-width': '640px',
        'margin': '16px auto',
        'padding': '16px',
        'background': 'var(--w95-face)',
        'color': 'var(--w95-face-text)',
        'display': 'flex',
        'flex-direction': 'column',
        'gap': '20px',
      },
    ),
    <Widget>[
      for (final RadioGroupVariant variant in RadioGroupVariant.values)
        ArcaneRadioGroup<String>(
          id: 'radio-${variant.name}',
          name: 'radio-${variant.name}',
          label: '${variant.name} choices',
          value: 'first',
          variant: variant,
          layout: variant == RadioGroupVariant.standard
              ? RadioGroupLayout.vertical
              : RadioGroupLayout.grid,
          gridColumns: 2,
          gap: '12px',
          required: true,
          options: <RadioOption<String>>[
            RadioOption<String>(
              value: 'first',
              label: 'First choice',
              description: 'Available on this device',
              icon: ArcaneIcon.folder(),
            ),
            const RadioOption<String>(
              value: 'disabled',
              label: 'Unavailable choice',
              description: 'Unavailable on this device',
              disabled: true,
            ),
            const RadioOption<String>(
              value: 'last',
              label: 'Last choice',
              description: 'A longer description wraps inside the control',
            ),
          ],
        ),
      const ArcaneCheckbox(
        id: 'refresh-checkbox',
        checked: true,
        label: 'Enable notifications',
      ),
      const ArcaneToggleSwitch(
        id: 'refresh-switch',
        value: false,
        label: 'Enable sound',
      ),
      context.renderers.select<String>(
        const SelectProps<String>(
          id: 'refresh-select',
          label: 'Output device',
          value: 'speaker',
          maxDropdownHeight: '140px',
          options: <SelectOptionProps<String>>[
            SelectOptionProps<String>(
              value: 'speaker',
              label: 'Speakers',
              subtitle: 'Built-in audio',
            ),
            SelectOptionProps<String>(
              value: 'headset',
              label: 'Headset',
              subtitle: 'Disconnected',
              disabled: true,
            ),
            SelectOptionProps<String>(value: 'display', label: 'Display'),
            SelectOptionProps<String>(value: 'external', label: 'External'),
            SelectOptionProps<String>(value: 'digital', label: 'Digital'),
          ],
        ),
      ),
      const ArcaneAlert.warning(
        title: 'Changes are pending',
        message: 'Save your settings to apply them.',
      ),
      Button(label: 'Apply settings', onPressed: () {}),
    ],
  );
}

List<String> _inputTags(String html) => RegExp(r'<input\b[^>]*>')
    .allMatches(html)
    .map((RegExpMatch match) => match.group(0)!)
    .where((String tag) => tag.contains('win95-radio-control'))
    .toList();

void main() {
  for (final Brightness brightness in <Brightness>[
    Brightness.light,
    Brightness.dark,
  ]) {
    testServer('Win95 ${brightness.name} preserves native control semantics', (
      ServerTester tester,
    ) async {
      tester.pumpComponent(
        ArcaneApp(
          stylesheet: const Win95Stylesheet(),
          brightness: brightness,
          home: const _Win95RefreshHarness(),
        ),
      );
      final DocumentResponse response = await tester.request('/');
      expect(response.statusCode, 200, reason: response.body);
      final String html = response.body;
      final List<String> radios = _inputTags(html);
      expect(radios, hasLength(9));
      for (final RadioGroupVariant variant in RadioGroupVariant.values) {
        final List<String> options = radios
            .where((String tag) => tag.contains('name="radio-${variant.name}"'))
            .toList();
        expect(options, hasLength(3));
        expect(options.first, contains('checked'));
        expect(options.first, contains('required'));
        expect(options.first, contains('type="radio"'));
        expect(options[1], contains('disabled'));
        expect(options.last, contains('value="last"'));
        expect(html, contains('aria-labelledby="radio-${variant.name}-label"'));
      }
      expect(html, contains('win95-radio-description'));
      expect(html, contains('win95-radio-icon'));
      expect(
        html,
        contains('grid-template-columns: repeat(2, minmax(0, 1fr))'),
      );
      expect(html, contains('gap: 12px'));
      expect(html, contains('for="refresh-switch-control"'));
      expect(html, contains('aria-label="Enable sound"'));
      expect(html, contains('max-height: 140px'));
      expect(html, contains('overflow-y: auto'));

      final String? previewDirectory =
          Platform.environment['WIN95_REFRESH_PREVIEW_DIR'];
      if (previewDirectory != null) {
        Directory(previewDirectory).createSync(recursive: true);
        File(
          '$previewDirectory/win95-${brightness.name}.html',
        ).writeAsStringSync(
          html.replaceFirst('<head>', '<head><meta charset="utf-8">'),
        );
      }
    });
  }

  test('Win95 semantic text meets AA on silver and dark silver faces', () {
    for (final Win95Theme theme in Win95Theme.values) {
      final Win95Stylesheet stylesheet = Win95Stylesheet(theme: theme);
      for (final ThemeSeed seed in <ThemeSeed>[
        stylesheet.lightSeed,
        stylesheet.darkSeed,
      ]) {
        for (final int color in <int>[
          seed.destructive,
          seed.success,
          seed.warning,
          seed.info,
        ]) {
          expect(
            PaletteGenerator.contrastRatio(seed.background!, color),
            greaterThanOrEqualTo(4.5),
            reason:
                '${theme.name}, dark=${seed.isDark}, '
                'color=${PaletteGenerator.toHex(color)}',
          );
        }
        expect(seed.primary, theme.accent);
        expect(seed.accent, theme.titleEnd);
        expect(
          PaletteGenerator.contrastRatio(
            seed.accent!,
            PaletteGenerator.contrastingForeground(seed.accent!),
          ),
          greaterThanOrEqualTo(4.5),
        );
      }
    }
  });
}
