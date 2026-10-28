@TestOn('browser')
library;

import 'dart:math' as math;

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart' show StatefulBuilder, StateSetter;
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
        (double value) => value <= 0.04045
            ? value / 12.92
            : math.pow((value + 0.055) / 1.055, 2.4).toDouble(),
      )
      .toList();
  return channels[0] * 0.2126 + channels[1] * 0.7152 + channels[2] * 0.0722;
}

double _contrast(String foreground, String background) {
  final double first = _luminance(foreground);
  final double second = _luminance(background);
  return (math.max(first, second) + 0.05) / (math.min(first, second) + 0.05);
}

void _pump(
  ClientTester tester,
  Brightness brightness, {
  NeubrutalismTheme theme = NeubrutalismTheme.yellow,
}) {
  tester.pumpComponent(
    ArcaneApp(
      stylesheet: NeubrutalismStylesheet(
        variant: NeubrutalismVariant.neuComic,
        theme: theme,
      ),
      brightness: brightness,
      includeFallbackScripts: false,
      home: dom.div(<Widget>[
        const dom.h1(<Widget>[Text('Draw your next chapter')]),
        const Card(classes: 'paper-panel', child: Text('Paper panel')),
        const Card(
          classes: 'neucomic-halftone dot-card',
          child: Text('Dotted panel'),
        ),
        const Card(
          classes: 'neucomic-hatch hatch-card',
          child: Text('Hatched panel'),
        ),
        const Card.ghost(classes: 'ghost-panel', child: Text('Ghost panel')),
        const Card(
          classes: 'custom-panel',
          decoration: ArcaneDecoration(
            color: '#f0ecff',
            border: '5px solid #345678',
            elevation: Elevation.none,
          ),
          child: Text('Custom panel'),
        ),
        const TextInput(id: 'title', label: 'Title', placeholder: 'Your title'),
        const TextInput(
          id: 'invalid-title',
          label: 'Edition',
          error: 'Add an edition name.',
        ),
        const ArcaneDatePicker(
          id: 'invalid-date',
          label: 'Proof date',
          error: 'Choose a valid date.',
        ),
        Button(id: 'save', label: 'Save story', onPressed: () {}),
        const Button.outline(
          id: 'custom-outline',
          label: 'Custom border',
          decoration: ArcaneDecoration(border: '5px solid #345678'),
        ),
        const ArcaneToggleSwitch(
          id: 'proof-switch',
          value: true,
          label: 'Proof',
        ),
        const ArcaneToggleSwitch(
          id: 'disabled-proof-switch',
          value: true,
          label: 'Required proof',
          disabled: true,
        ),
        const ArcaneSlider(id: 'proof-slider', value: 50, label: 'Ink'),
        const dom.input(
          id: 'native-slider',
          type: dom.InputType.range,
          attributes: <String, String>{'min': '0', 'max': '100', 'value': '50'},
        ),
        const dom.div(classes: 'neucomic-caption', <Widget>[Text('Caption')]),
        const dom.div(classes: 'neucomic-halftone', <Widget>[Text('Dots')]),
        const dom.div(classes: 'neucomic-hatch', <Widget>[Text('Hatching')]),
      ]),
    ),
  );
}

void main() {
  testClient('greyscale comic controls agree under root and html dark scopes', (
    ClientTester tester,
  ) async {
    _pump(tester, Brightness.dark, theme: NeubrutalismTheme.greyscale);
    await pumpEventQueue();
    web.document.documentElement!.className = '';
    final String rootPanel = _style('.paper-panel').backgroundColor;
    final String rootInput = _style('#title').backgroundColor;
    final String rootColor = _style('#title').color;
    web.document.documentElement!.className = 'dark';
    expect(_style('.paper-panel').backgroundColor, rootPanel);
    expect(_style('#title').backgroundColor, rootInput);
    expect(_style('#title').color, rootColor);
    expect(_contrast(rootColor, rootInput), greaterThanOrEqualTo(4.5));
  });
  testClient(
    'switching comic treatment preserves fields and restores classic',
    (ClientTester tester) async {
      bool comic = false;
      tester.pumpComponent(
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) => ArcaneApp(
            stylesheet: NeubrutalismStylesheet(
              variant: comic
                  ? NeubrutalismVariant.neuComic
                  : NeubrutalismVariant.classic,
            ),
            brightness: Brightness.light,
            includeFallbackScripts: false,
            home: dom.div(<Widget>[
              Button(
                id: 'variant',
                label: 'Change style',
                onPressed: () => setState(() => comic = !comic),
              ),
              const TextInput(id: 'draft', value: 'Keep my story'),
              const dom.h1(<Widget>[Text('A new chapter')]),
            ]),
          ),
        ),
      );
      await pumpEventQueue();
      final String classicBackground = _style('#arcane-root').backgroundColor;
      final String classicHeading = _style('h1').fontFamily;
      _element('#variant').click();
      await pumpEventQueue();
      expect(_element('#arcane-root').classList.contains('neucomic'), isTrue);
      expect(_style('h1').fontFamily, contains('Bangers'));
      expect(_style('#arcane-root').backgroundImage, 'none');
      expect(
        (_element('#draft') as web.HTMLInputElement).value,
        'Keep my story',
      );
      _element('#variant').click();
      await pumpEventQueue();
      expect(_element('#arcane-root').classList.contains('neucomic'), isFalse);
      expect(_style('#arcane-root').backgroundColor, classicBackground);
      expect(_style('h1').fontFamily, classicHeading);
      expect(_style('#arcane-root').backgroundImage, 'none');
      expect(
        (_element('#draft') as web.HTMLInputElement).value,
        'Keep my story',
      );
    },
  );
  for (final Brightness brightness in Brightness.values) {
    testClient(
      '${brightness.name} comic controls use square geometry and visible native focus',
      (ClientTester tester) async {
        _pump(tester, brightness);
        await pumpEventQueue();
        web.document.documentElement!.className = brightness.name;
        expect(_style('[role="switch"]').borderRadius, '0px');
        expect(_style('.neubrutalism-toggle-switch-thumb').display, 'none');
        final web.HTMLElement disabledSwitch = _element(
          '[role="switch"][disabled]',
        );
        disabledSwitch.click();
        expect(disabledSwitch.getAttribute('aria-checked'), 'true');
        expect(
          web.window.getComputedStyle(disabledSwitch, '::after').opacity,
          '1',
        );
        _element('[role="switch"]').focus();
        expect(_style('[role="switch"]').outlineStyle, 'solid');
        disabledSwitch.focus();
        expect(web.document.activeElement, _element('[role="switch"]'));
        expect(_style('.neubrutalism-slider-track').height, '4px');
        expect(_style('.neubrutalism-slider-track').borderRadius, '0px');
        final web.CSSStyleDeclaration thumb = _style(
          '.neubrutalism-slider-thumb',
        );
        expect(thumb.borderRadius, '0px');
        expect(thumb.width, '22px');
        expect(thumb.height, '26px');
        expect(thumb.backgroundImage, 'none');
        expect(_style('#native-slider').appearance, 'none');
        expect(_style('#native-slider').borderRadius, '0px');
        _element('#native-slider').focus();
        await pumpEventQueue();
        expect(_style('#native-slider').outlineStyle, 'solid');
        expect(
          _contrast(
            _style('#native-slider').outlineColor,
            _style('#arcane-root').backgroundColor,
          ),
          greaterThanOrEqualTo(3),
        );
        if (brightness == Brightness.dark) {
          expect(_style('#arcane-root').backgroundColor, 'rgb(23, 25, 28)');
          expect(_style('#arcane-root').color, 'rgb(216, 212, 202)');
          expect(_style('.paper-panel').backgroundColor, 'rgb(36, 39, 44)');
          expect(_style('.paper-panel').borderTopColor, 'rgb(17, 19, 21)');
          expect(
            _style('.neucomic-caption').backgroundColor,
            'rgb(45, 48, 53)',
          );
          expect(_style('#save').backgroundColor, 'rgb(184, 92, 80)');
          expect(
            _contrast(_style('#save').color, _style('#save').backgroundColor),
            greaterThanOrEqualTo(4.5),
          );
        }
        _element('#arcane-root').style
          ..setProperty('--nb-accent-in', '#426870')
          ..setProperty('--nb-on-accent-in', '#ffffff');
        expect(
          web.window
              .getComputedStyle(_element('[role="switch"]'), '::before')
              .backgroundColor,
          'rgb(66, 104, 112)',
        );
        expect(
          web.window
              .getComputedStyle(_element('[role="switch"]'), '::after')
              .borderRightColor,
          'rgb(255, 255, 255)',
        );
        expect(_style('#save').backgroundColor, 'rgb(66, 104, 112)');
        expect(_style('#save').color, 'rgb(255, 255, 255)');
      },
    );
    for (final bool htmlTheme in <bool>[false, true]) {
      testClient('${brightness.name} comic fills keep controls readable '
          'with ${htmlTheme ? 'html' : 'root'} scope', (
        ClientTester tester,
      ) async {
        _pump(tester, brightness);
        await pumpEventQueue();
        web.document.documentElement!.className = htmlTheme
            ? brightness.name
            : '';
        expect(_style('h1').fontFamily, contains('Bangers'));
        expect(_style('#arcane-root').backgroundImage, 'none');
        expect(_style('.neucomic-halftone').backgroundImage, 'none');
        expect(_style('.neucomic-hatch').backgroundImage, 'none');
        final web.CSSStyleDeclaration root = _style('#arcane-root');
        final web.CSSStyleDeclaration input = _style('#title');
        final web.CSSStyleDeclaration button = _style('#save');
        expect(
          _contrast(root.color, root.backgroundColor),
          greaterThanOrEqualTo(4.5),
        );
        expect(
          _contrast(input.color, input.backgroundColor),
          greaterThanOrEqualTo(4.5),
        );
        expect(
          _contrast(input.borderTopColor, input.backgroundColor),
          greaterThanOrEqualTo(3),
        );
        expect(
          _contrast(button.color, button.backgroundColor),
          greaterThanOrEqualTo(4.5),
        );
        expect(input.backgroundImage, 'none');
        expect(
          _style('#invalid-title').borderTopColor,
          isNot(input.borderTopColor),
        );
        expect(_style('#invalid-title').borderTopWidth, '2px');
        final web.HTMLElement invalidDate = _element(
          '.neubrutalism-date-picker-trigger[data-error="true"]',
        );
        expect(invalidDate.getAttribute('aria-invalid'), 'true');
        expect(
          web.window.getComputedStyle(invalidDate).borderTopColor,
          _style('#invalid-title').borderTopColor,
        );
        final web.CSSStyleDeclaration placeholder = web.window.getComputedStyle(
          _element('#title'),
          '::placeholder',
        );
        expect(
          _contrast(placeholder.color, input.backgroundColor),
          greaterThanOrEqualTo(4.5),
        );
        _element('#arcane-root').style.setProperty('--nb-accent-in', '#ffffff');
        _element('#title').focus();
        await pumpEventQueue();
        expect(_style('#title').outlineStyle, 'solid');
        expect(
          _contrast(_style('#title').outlineColor, input.backgroundColor),
          greaterThanOrEqualTo(3),
          reason: 'A white custom accent must not hide the focus ring.',
        );
        expect(
          double.parse(_style('#title').outlineWidth.replaceAll('px', '')),
          greaterThanOrEqualTo(2),
        );
      });
    }
    testClient(
      '${brightness.name} comic surfaces preserve explicit decoration and ghost cards',
      (ClientTester tester) async {
        _pump(tester, brightness);
        await pumpEventQueue();
        expect(_style('.paper-panel').backgroundImage, 'none');
        expect(_style('.dot-card').backgroundImage, 'none');
        expect(_style('.hatch-card').backgroundImage, 'none');
        expect(_style('.ghost-panel').backgroundImage, 'none');
        expect(_style('.ghost-panel').borderTopWidth, '0px');
        expect(_style('.custom-panel').backgroundImage, 'none');
        expect(_style('.custom-panel').backgroundColor, 'rgb(240, 236, 255)');
        expect(_style('.custom-panel').borderTopColor, 'rgb(52, 86, 120)');
        expect(_style('.custom-panel').borderTopWidth, '5px');
        expect(_style('.custom-panel').boxShadow, 'none');
        expect(
          _element('#custom-outline').hasAttribute('data-arcane-decorated'),
          isTrue,
        );
        expect(_style('#custom-outline').borderTopWidth, '5px');
        expect(_style('#custom-outline').borderTopColor, 'rgb(52, 86, 120)');
      },
    );
  }
}
