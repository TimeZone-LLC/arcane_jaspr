@TestOn('browser')
library;

import 'dart:math' as math;

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

class _FormContrastProbe {
  const _FormContrastProbe._();

  static web.HTMLElement element(String selector) =>
      web.document.querySelector(selector)! as web.HTMLElement;

  static web.CSSStyleDeclaration style(String selector) =>
      web.window.getComputedStyle(element(selector));

  static List<double> channels(String color) {
    final List<double> values = RegExp(r'\d+(?:\.\d+)?')
        .allMatches(color)
        .map((Match match) => double.parse(match.group(0)!))
        .toList();
    final double scale = color.startsWith('color(srgb ') ? 1 : 255;
    return <double>[
      for (int index = 0; index < 3; index++) values[index] / scale,
      values.length > 3 ? values[3] : 1,
    ];
  }

  static double luminance(List<double> color) {
    final List<double> linear = color
        .take(3)
        .map(
          (double channel) => channel <= 0.04045
              ? channel / 12.92
              : math.pow((channel + 0.055) / 1.055, 2.4).toDouble(),
        )
        .toList();
    return linear[0] * 0.2126 + linear[1] * 0.7152 + linear[2] * 0.0722;
  }

  static double contrast({
    required String foreground,
    required String background,
  }) {
    final List<double> front = channels(foreground);
    final List<double> back = channels(background);
    final double foregroundLuminance = luminance(<double>[
      for (int index = 0; index < 3; index++)
        front[index] * front[3] + back[index] * (1 - front[3]),
    ]);
    final double backgroundLuminance = luminance(back);
    return (math.max(foregroundLuminance, backgroundLuminance) + 0.05) /
        (math.min(foregroundLuminance, backgroundLuminance) + 0.05);
  }

  static void pump({
    required ClientTester tester,
    required Brightness brightness,
    required bool htmlTheme,
    required List<Widget> children,
    NeubrutalismTheme theme = NeubrutalismTheme.yellow,
  }) {
    web.document.documentElement!.className = htmlTheme ? brightness.name : '';
    tester.pumpComponent(
      ArcaneApp(
        stylesheet: NeubrutalismStylesheet(theme: theme),
        brightness: brightness,
        includeFallbackScripts: false,
        home: dom.div(children),
      ),
    );
  }
}

void main() {
  for (Brightness brightness in Brightness.values) {
    for (bool htmlTheme in <bool>[false, true]) {
      final String mode =
          '${brightness.name} ${htmlTheme ? 'html' : 'root'} theme';

      testClient('$mode placeholders have readable contrast', (
        ClientTester tester,
      ) async {
        _FormContrastProbe.pump(
          tester: tester,
          brightness: brightness,
          htmlTheme: htmlTheme,
          children: const <Widget>[
            TextInput(id: 'plain', placeholder: 'Print title'),
            TextInput(id: 'prefix', prefix: Text('#'), placeholder: 'Edition'),
            TextInput(
              id: 'suffix',
              suffix: Text('copies'),
              placeholder: 'Count',
            ),
            TextArea(id: 'notes', placeholder: 'Printing notes'),
          ],
        );
        await pumpEventQueue();
        for (String selector in <String>[
          '#plain',
          '#prefix',
          '#suffix',
          '#notes',
        ]) {
          final web.CSSStyleDeclaration placeholder = web.window
              .getComputedStyle(
                _FormContrastProbe.element(selector),
                '::placeholder',
              );
          expect(
            _FormContrastProbe.contrast(
              foreground: placeholder.color,
              background: _FormContrastProbe.style(selector).backgroundColor,
            ),
            greaterThanOrEqualTo(4.5),
            reason: '$selector placeholder',
          );
          expect(placeholder.opacity, '1');
        }
      });

      testClient('$mode validation messages have readable contrast', (
        ClientTester tester,
      ) async {
        _FormContrastProbe.pump(
          tester: tester,
          brightness: brightness,
          htmlTheme: htmlTheme,
          children: const <Widget>[
            TextInput(id: 'title', label: 'Title', error: 'Enter a title'),
            TextInput(
              id: 'count',
              suffix: Text('copies'),
              error: 'Enter a count',
            ),
            TextArea(id: 'notes', error: 'Describe the print'),
            ArcaneFieldWrapper(
              field: TextInput(id: 'edition'),
              error: 'Enter an edition',
            ),
            ArcaneSelect(
              id: 'paper',
              label: 'Paper',
              error: 'Choose a paper',
              options: <ArcaneSelectOption>[
                ArcaneSelectOption(label: 'Cotton', value: 'cotton'),
              ],
            ),
          ],
        );
        await pumpEventQueue();
        for (String selector in <String>[
          '#title-error',
          '#count-error',
          '#notes-error',
          '.neubrutalism-field-error',
          '#paper-error',
        ]) {
          final String background = _FormContrastProbe.style(
            '#arcane-root',
          ).backgroundColor;
          expect(
            _FormContrastProbe.contrast(
              foreground: _FormContrastProbe.style(selector).color,
              background: background,
            ),
            greaterThanOrEqualTo(4.5),
            reason: selector,
          );
        }
      });

      for (final NeubrutalismTheme theme in <NeubrutalismTheme>[
        NeubrutalismTheme.yellow,
        NeubrutalismTheme.greyscale,
      ]) {
        testClient(
          '$mode ${theme.name} fields keep readable control boundaries',
          (ClientTester tester) async {
            _FormContrastProbe.pump(
              tester: tester,
              brightness: brightness,
              htmlTheme: htmlTheme,
              theme: theme,
              children: const <Widget>[
                TextInput(id: 'plain', value: '12'),
                TextInput(id: 'prefix', prefix: Text('#'), value: '12'),
                TextInput(id: 'suffix', suffix: Text('copies'), value: '12'),
                TextArea(id: 'notes', value: 'Edition of 12'),
                ArcaneSelect(
                  id: 'paper',
                  options: <ArcaneSelectOption>[
                    ArcaneSelectOption(label: 'Cotton', value: 'cotton'),
                  ],
                ),
                Button(
                  id: 'outline',
                  label: 'Cancel',
                  variant: ButtonVariant.outline,
                ),
                Button(id: 'primary', label: 'Save'),
                Button(
                  id: 'custom-outline',
                  label: 'Custom',
                  variant: ButtonVariant.outline,
                  decoration: ArcaneDecoration(border: '5px solid #345678'),
                ),
                ArcaneTabs(
                  tabs: <ArcaneTabItem>[
                    ArcaneTabItem(
                      label: 'Workshops',
                      content: Text('Workshops'),
                    ),
                    ArcaneTabItem(label: 'Editions', content: Text('Editions')),
                  ],
                ),
                Card(classes: 'dark-frame', child: Text('Edition')),
                Card(
                  classes: 'custom-frame',
                  decoration: ArcaneDecoration(border: '5px solid #345678'),
                  child: Text('Custom'),
                ),
              ],
            );
            await pumpEventQueue();
            final web.CSSStyleDeclaration plain = _FormContrastProbe.style(
              '#plain',
            );
            for (final String selector in <String>[
              '#plain',
              '#notes',
              '#paper',
              '#outline',
            ]) {
              final web.CSSStyleDeclaration control = _FormContrastProbe.style(
                selector,
              );
              expect(
                _FormContrastProbe.contrast(
                  foreground: control.borderTopColor,
                  background: control.backgroundColor,
                ),
                greaterThanOrEqualTo(3),
                reason: '$selector boundary',
              );
              expect(
                _FormContrastProbe.contrast(
                  foreground: control.color,
                  background: control.backgroundColor,
                ),
                greaterThanOrEqualTo(4.5),
                reason: '$selector text',
              );
            }
            if (brightness == Brightness.dark) {
              expect(
                _FormContrastProbe.style('.dark-frame').boxShadow,
                startsWith('rgb(8, 8, 8)'),
              );
              expect(
                _FormContrastProbe.style('#primary').borderTopColor,
                'rgb(8, 8, 8)',
              );
              expect(
                plain.borderTopColor,
                isNot(_FormContrastProbe.style('#primary').borderTopColor),
              );
            }
            expect(
              _FormContrastProbe.style('.custom-frame').borderTopWidth,
              '5px',
            );
            expect(
              _FormContrastProbe.style('.custom-frame').borderTopColor,
              'rgb(52, 86, 120)',
            );
            expect(
              _FormContrastProbe.style('#custom-outline').borderTopWidth,
              '5px',
            );
            expect(
              _FormContrastProbe.style('#custom-outline').borderTopColor,
              'rgb(52, 86, 120)',
            );
            _FormContrastProbe.element(
              '.neubrutalism-tabs-trigger[data-state="inactive"]',
            ).click();
            await pumpEventQueue();
            await Future<void>.delayed(const Duration(milliseconds: 200));
            final web.CSSStyleDeclaration inactiveTab =
                _FormContrastProbe.style(
                  '.neubrutalism-tabs-trigger[data-state="inactive"]',
                );
            expect(
              _FormContrastProbe.contrast(
                foreground: inactiveTab.borderTopColor,
                background: inactiveTab.backgroundColor,
              ),
              greaterThanOrEqualTo(3),
            );
            if (brightness == Brightness.dark) {
              expect(
                _FormContrastProbe.style(
                  '.neubrutalism-tabs-trigger[data-state="active"]',
                ).borderTopColor,
                'rgb(8, 8, 8)',
              );
            }
            for (String selector in <String>['#prefix', '#suffix']) {
              final web.HTMLElement input = _FormContrastProbe.element(
                selector,
              );
              final web.CSSStyleDeclaration shell = web.window.getComputedStyle(
                input.closest('[data-arcane-field-shell="true"]')!,
              );
              expect(shell.borderTopWidth, plain.borderTopWidth);
              expect(shell.borderTopColor, plain.borderTopColor);
              expect(shell.boxShadow, plain.boxShadow);
              expect(
                _FormContrastProbe.contrast(
                  foreground: shell.borderTopColor,
                  background: shell.backgroundColor,
                ),
                greaterThanOrEqualTo(3),
              );
              expect(_FormContrastProbe.style(selector).borderTopWidth, '0px');
              expect(_FormContrastProbe.style(selector).boxShadow, 'none');
            }
            _FormContrastProbe.element(
              '#arcane-root',
            ).style.setProperty('--nb-line-in', '#aabbcc');
            expect(
              _FormContrastProbe.style('.dark-frame').borderTopColor,
              'rgb(170, 187, 204)',
            );
            expect(
              _FormContrastProbe.style('#plain').borderTopColor,
              'rgb(170, 187, 204)',
            );
            expect(
              _FormContrastProbe.style('.custom-frame').borderTopColor,
              'rgb(52, 86, 120)',
            );
            expect(
              _FormContrastProbe.style('#custom-outline').borderTopColor,
              'rgb(52, 86, 120)',
            );
          },
        );
      }
    }
  }
}
