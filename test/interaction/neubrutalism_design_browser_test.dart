@TestOn('browser')
library;

import 'dart:math' as math;

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/core/interaction/runtime/runtime.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

web.HTMLElement _element(String selector) =>
    web.document.querySelector(selector)! as web.HTMLElement;

web.CSSStyleDeclaration _style(String selector) =>
    web.window.getComputedStyle(_element(selector));

double _luminance(String color) {
  final List<double> channels = RegExp(r'\d+(?:\.\d+)?')
      .allMatches(color)
      .take(3)
      .map((Match match) => double.parse(match.group(0)!) / 255)
      .map(
        (double channel) => channel <= 0.04045
            ? channel / 12.92
            : math.pow((channel + 0.055) / 1.055, 2.4).toDouble(),
      )
      .toList();
  return channels[0] * 0.2126 + channels[1] * 0.7152 + channels[2] * 0.0722;
}

double _contrast(String foreground, String background) {
  final double first = _luminance(foreground);
  final double second = _luminance(background);
  return (math.max(first, second) + 0.05) / (math.min(first, second) + 0.05);
}

void _pump(ClientTester tester, Brightness brightness, List<Widget> children) {
  web.document.documentElement!.setAttribute('class', brightness.name);
  tester.pumpComponent(
    ArcaneApp(
      stylesheet: const NeubrutalismStylesheet(),
      brightness: brightness,
      includeFallbackScripts: false,
      home: dom.div(children),
    ),
  );
}

void main() {
  setUpAll(() {
    web.document.head!.appendChild(
      web.HTMLScriptElement()..text = arcaneInteractivityRuntimeJs,
    );
  });

  for (final Brightness brightness in Brightness.values) {
    testClient('${brightness.name} card variants preserve surface intent', (
      ClientTester tester,
    ) async {
      _pump(tester, brightness, const <Widget>[
        Card(classes: 'elevated-card', child: Text('Elevated')),
        Card.flat(classes: 'flat-card', child: Text('Flat')),
        Card.ghost(classes: 'ghost-card', child: Text('Ghost')),
        Card(
          classes: 'decorated-card',
          decoration: ArcaneDecoration(
            color: '#f0ecff',
            border: '5px solid #345678',
            elevation: Elevation.none,
          ),
          child: Text('Decorated'),
        ),
      ]);
      await pumpEventQueue();
      expect(_style('.flat-card').boxShadow, 'none');
      expect(_style('.flat-card').borderTopWidth, '3px');
      expect(_style('.ghost-card').boxShadow, 'none');
      expect(_style('.ghost-card').borderTopWidth, '0px');
      expect(_style('.ghost-card').backgroundColor, 'rgba(0, 0, 0, 0)');
      expect(_style('.decorated-card').boxShadow, 'none');
      expect(_style('.decorated-card').borderTopWidth, '5px');
      expect(_style('.decorated-card').borderTopColor, 'rgb(52, 86, 120)');
      expect(_style('.decorated-card').backgroundColor, 'rgb(240, 236, 255)');
      expect(_style('.elevated-card').paddingTop, '32px');
      expect(_style('.elevated-card').borderRadius, '0px');
      expect(_style('.elevated-card').boxShadow, contains('5px 5px 0px 0px'));
    });

    testClient('${brightness.name} buttons retain ghost and reference sizing', (
      ClientTester tester,
    ) async {
      _pump(tester, brightness, <Widget>[
        Button(id: 'primary-button', label: 'Save changes', onPressed: () {}),
        Button.ghost(id: 'ghost-button', label: 'Cancel', onPressed: () {}),
      ]);
      await pumpEventQueue();
      final web.CSSStyleDeclaration ghost = _style('#ghost-button');
      expect(ghost.backgroundColor, 'rgba(0, 0, 0, 0)');
      expect(ghost.borderTopWidth, '0px');
      expect(ghost.boxShadow, 'none');
      final web.CSSStyleDeclaration primary = _style('#primary-button');
      expect(primary.fontFamily, contains('Space Grotesk'));
      expect(primary.fontWeight, '700');
      expect(primary.fontSize, '16px');
      expect(primary.paddingTop, '12px');
      expect(primary.paddingLeft, '24px');
      expect(primary.borderRadius, '0px');
      expect(
        _element('#primary-button').getBoundingClientRect().height,
        greaterThanOrEqualTo(44),
      );
    });

    testClient('${brightness.name} badges use compact mono labels', (
      ClientTester tester,
    ) async {
      _pump(tester, brightness, const <Widget>[
        ArcaneStatusBadge(label: 'Available', variant: BadgeVariant.primary),
        ArcaneStatusBadge.success('Online'),
      ]);
      await pumpEventQueue();
      for (final String selector in <String>[
        '.neubrutalism-badge',
        '.neubrutalism-status-badge > span:last-child',
      ]) {
        final web.CSSStyleDeclaration style = _style(selector);
        expect(style.fontFamily, contains('Space Mono'));
        expect(style.fontSize, '12px');
        expect(style.textTransform, 'uppercase');
      }
      expect(_style('.neubrutalism-badge').borderRadius, '0px');
      expect(
        _style('.neubrutalism-badge').boxShadow,
        contains('3px 3px 0px 0px'),
      );
    });

    testClient('${brightness.name} semantic button labels remain readable', (
      ClientTester tester,
    ) async {
      _pump(tester, brightness, <Widget>[
        for (final ButtonVariant variant in ButtonVariant.values)
          Button(
            id: 'semantic-${variant.name}',
            variant: variant,
            label: variant.name,
            onPressed: () {},
          ),
      ]);
      await pumpEventQueue();
      for (final ButtonVariant variant in ButtonVariant.values) {
        final web.CSSStyleDeclaration style = _style(
          '#semantic-${variant.name}',
        );
        final String background = style.backgroundColor == 'rgba(0, 0, 0, 0)'
            ? _style('#arcane-root').backgroundColor
            : style.backgroundColor;
        expect(
          _contrast(style.color, background),
          greaterThanOrEqualTo(4.5),
          reason: '${variant.name} button contrast',
        );
      }
    });

    testClient('${brightness.name} selected radios remain square and readable', (
      ClientTester tester,
    ) async {
      _pump(tester, brightness, const <Widget>[
        ArcaneRadioGroup<String>(
          id: 'standard-choices',
          value: 'one',
          options: <RadioOption<String>>[
            RadioOption(value: 'one', label: 'One'),
            RadioOption(value: 'two', label: 'Two'),
          ],
        ),
        ArcaneRadioGroup<String>(
          id: 'card-choices',
          value: 'one',
          variant: RadioGroupVariant.cards,
          options: <RadioOption<String>>[
            RadioOption(value: 'one', label: 'One', description: 'Selected'),
            RadioOption(value: 'two', label: 'Two', description: 'Available'),
          ],
        ),
      ]);
      await pumpEventQueue();
      const String selectedCircle =
          '.neubrutalism-radio-option[data-state="checked"] .neubrutalism-radio-circle';
      const String uncheckedCircle =
          '.neubrutalism-radio-option[data-state="unchecked"] .neubrutalism-radio-circle';
      expect(_style(selectedCircle).borderRadius, '0px');
      expect(_style(selectedCircle).width, '24px');
      expect(
        _style(selectedCircle).backgroundColor,
        isNot(_style(uncheckedCircle).backgroundColor),
      );
      for (final String state in <String>['checked', 'unchecked']) {
        final String card = '.neubrutalism-radio-card[data-state="$state"]';
        final String background = _style(card).backgroundColor;
        for (final String role in <String>['label', 'description']) {
          expect(
            _contrast(
              _style('$card .neubrutalism-radio-$role').color,
              background,
            ),
            greaterThanOrEqualTo(4.5),
            reason: '$state radio $role contrast',
          );
        }
      }
    });

    testClient(
      '${brightness.name} radio selections update after click and Space',
      (ClientTester tester) async {
        _pump(tester, brightness, <Widget>[
          for (final RadioGroupVariant variant in <RadioGroupVariant>[
            RadioGroupVariant.standard,
            RadioGroupVariant.cards,
          ])
            ArcaneRadioGroup<String>(
              id: 'runtime-${variant.name}',
              variant: variant,
              value: 'one',
              options: const <RadioOption<String>>[
                RadioOption(
                  value: 'one',
                  label: 'One',
                  description: 'First choice',
                ),
                RadioOption(
                  value: 'two',
                  label: 'Two',
                  description: 'Second choice',
                ),
              ],
            ),
        ]);
        await pumpEventQueue();
        for (final String variant in <String>['standard', 'cards']) {
          final String group = '[data-arcane-group="runtime-$variant"]';
          final String first = '$group[data-arcane-value="one"]';
          final String second = '$group[data-arcane-value="two"]';
          final String selectedBackground = _style(first).backgroundColor;
          _element(second).click();
          await pumpEventQueue();
          await Future<void>.delayed(const Duration(milliseconds: 200));
          expect(_element(first).getAttribute('data-state'), 'unchecked');
          expect(_element(second).getAttribute('data-state'), 'checked');
          expect(_element(second).getAttribute('aria-checked'), 'true');
          if (variant == 'standard') {
            expect(
              _style('$first .neubrutalism-radio-dot').visibility,
              'hidden',
            );
            expect(
              _style('$second .neubrutalism-radio-dot').visibility,
              'visible',
            );
          } else {
            expect(_style(second).backgroundColor, selectedBackground);
            expect(
              _contrast(
                _style(first).borderTopColor,
                _style(first).backgroundColor,
              ),
              greaterThanOrEqualTo(3),
              reason: 'Deselected card keeps a visible boundary',
            );
            if (brightness == Brightness.dark) {
              expect(_style(second).borderTopColor, 'rgb(8, 8, 8)');
              expect(
                _style(first).borderTopColor,
                isNot(_style(second).borderTopColor),
              );
            }
            expect(
              _contrast(
                _style('$second .neubrutalism-radio-label').color,
                _style(second).backgroundColor,
              ),
              greaterThanOrEqualTo(4.5),
            );
          }
          _element(first).focus();
          expect(web.document.activeElement, _element(first));
          _element(first).dispatchEvent(
            web.KeyboardEvent(
              'keydown',
              web.KeyboardEventInit(key: ' ', bubbles: true, cancelable: true),
            ),
          );
          await pumpEventQueue();
          expect(_element(first).getAttribute('data-state'), 'checked');
          expect(_element(second).getAttribute('data-state'), 'unchecked');
          if (variant == 'cards' && brightness == Brightness.dark) {
            await Future<void>.delayed(const Duration(milliseconds: 200));
            expect(_style(first).borderTopColor, 'rgb(8, 8, 8)');
            expect(
              _contrast(
                _style(second).borderTopColor,
                _style(second).backgroundColor,
              ),
              greaterThanOrEqualTo(3),
            );
          }
        }
      },
    );
  }
}
