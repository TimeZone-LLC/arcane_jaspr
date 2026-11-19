@TestOn('browser')
library;

import 'dart:math' as math;

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_ascii/arcane_jaspr_ascii.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

web.HTMLElement _element(String selector) =>
    web.document.querySelector(selector)! as web.HTMLElement;

web.CSSStyleDeclaration _style(String selector, [String? pseudo]) =>
    web.window.getComputedStyle(_element(selector), pseudo);

Widget _controls(Brightness brightness) => ArcaneApp(
  stylesheet: const AsciiStylesheet(),
  brightness: brightness,
  includeFallbackScripts: false,
  home: Column(
    children: <Widget>[
      for (final ComponentSize size in ComponentSize.values)
        Column(
          children: <Widget>[
            ArcaneCheckbox(
              id: 'checked-${size.name}',
              checked: true,
              label: 'Selected ${size.name}',
              size: size,
            ),
            ArcaneCheckbox(
              id: 'unchecked-${size.name}',
              checked: false,
              label: 'Unselected ${size.name}',
              size: size,
            ),
            ArcaneToggleSwitch(
              id: 'switch-${size.name}',
              value: true,
              size: size,
              label: 'Enabled ${size.name}',
            ),
          ],
        ),
      for (final ColorVariant color in ColorVariant.values)
        ArcaneCheckbox(
          id: 'color-${color.name}',
          checked: true,
          color: color,
          label: color.name,
        ),
      for (final ColorVariant color in ColorVariant.values)
        ArcaneToggleSwitch(
          id: 'switch-color-${color.name}',
          value: true,
          color: color,
          label: color.name,
        ),
      const ArcaneToggleSwitch(
        id: 'named-switch',
        value: true,
        ariaLabel: 'Follow player',
      ),
      const ArcaneCheckbox(
        id: 'disabled',
        checked: true,
        disabled: true,
        label: 'Unavailable',
      ),
      const ArcaneRadioGroup<String>(
        name: 'mode',
        value: 'first',
        options: <RadioOption<String>>[
          RadioOption<String>(value: 'first', label: 'First'),
          RadioOption<String>(value: 'second', label: 'Second'),
        ],
      ),
      const dom.div(
        id: 'narrow-parent',
        styles: dom.Styles(raw: <String, String>{'width': '160px'}),
        <Widget>[
          ArcaneToast(
            message: 'A_long_identifier_that_must_wrap_inside_the_toast',
            duration: 0,
            title: 'Saved',
          ),
          ArcaneCircularProgress(
            value: 0.4,
            size: '72px',
            label: 'Completed processing steps',
          ),
          ArcaneCircularProgress(value: 0.4, size: '72px'),
        ],
      ),
    ],
  ),
);

double _contrast(String first, String second) {
  double luminance(String color) {
    final List<double> channels = RegExp(r'[\d.]+')
        .allMatches(color)
        .take(3)
        .map((RegExpMatch match) {
          final double channel = double.parse(match.group(0)!) / 255;
          return channel <= 0.04045
              ? channel / 12.92
              : math.pow((channel + 0.055) / 1.055, 2.4).toDouble();
        })
        .toList();
    return channels[0] * 0.2126 + channels[1] * 0.7152 + channels[2] * 0.0722;
  }

  final double a = luminance(first);
  final double b = luminance(second);
  return (math.max(a, b) + 0.05) / (math.min(a, b) + 0.05);
}

void main() {
  for (final Brightness brightness in Brightness.values) {
    testClient('Ascii ${brightness.name} selection marks need no icon font', (
      ClientTester tester,
    ) async {
      tester.pumpComponent(_controls(brightness));
      await pumpEventQueue();
      for (final ComponentSize size in ComponentSize.values) {
        final String checkbox =
            '[data-arcane-group="checked-${size.name}"][role="checkbox"]';
        final String indicator = '$checkbox .arcane-checkbox-indicator';
        expect(_style('$indicator i').display, 'none');
        expect(_style(indicator).display, 'flex');
        expect(_style(indicator, '::after').borderRightWidth, '2px');
        expect(_style(indicator, '::after').borderBottomWidth, '2px');
        expect(_style(indicator, '::after').transform, isNot('none'));
        expect(
          _element(indicator).getBoundingClientRect().width,
          lessThanOrEqualTo(
            _element(checkbox).getBoundingClientRect().width - 2,
          ),
        );
        expect(
          _style(
            '[data-arcane-group="unchecked-${size.name}"] .arcane-checkbox-indicator',
          ).display,
          'none',
        );
        final String track =
            '[data-arcane-group="switch-${size.name}"][role="switch"]';
        final web.DOMRect trackRect = _element(track).getBoundingClientRect();
        final web.DOMRect thumbRect = _element(
          '$track .arcane-toggle-thumb',
        ).getBoundingClientRect();
        expect(thumbRect.right, closeTo(trackRect.right - 1, 0.1));
        expect(thumbRect.top, closeTo(trackRect.top + 1, 0.1));
      }
      for (final ColorVariant color in ColorVariant.values) {
        final String selector =
            '[data-arcane-group="color-${color.name}"][role="checkbox"]';
        final web.CSSStyleDeclaration control = _style(selector);
        expect(
          _contrast(
            control.backgroundColor,
            _style('$selector .arcane-checkbox-indicator').color,
          ),
          greaterThanOrEqualTo(3),
          reason: '${brightness.name} ${color.name} check',
        );
        expect(
          _contrast(
            control.borderTopColor,
            _style('#arcane-root').backgroundColor,
          ),
          greaterThanOrEqualTo(3),
          reason: '${brightness.name} ${color.name} border',
        );
        final String switchSelector =
            '[data-arcane-group="switch-color-${color.name}"][role="switch"]';
        final web.CSSStyleDeclaration track = _style(switchSelector);
        expect(
          _contrast(
            track.backgroundColor,
            _style('$switchSelector .arcane-toggle-thumb').backgroundColor,
          ),
          greaterThanOrEqualTo(3),
          reason: '${brightness.name} ${color.name} switch thumb',
        );
        expect(
          _contrast(
            track.borderTopColor,
            _style('#arcane-root').backgroundColor,
          ),
          greaterThanOrEqualTo(3),
          reason: '${brightness.name} ${color.name} switch border',
        );
      }
      expect(
        _element(
          '[data-arcane-group="named-switch"][role="switch"]',
        ).getAttribute('aria-label'),
        'Follow player',
      );
      final web.HTMLElement checkbox = _element(
        '[data-arcane-group="checked-md"][role="checkbox"]',
      );
      checkbox.focus();
      expect(web.window.getComputedStyle(checkbox).outlineWidth, '2px');
      expect(_element('[aria-disabled="true"]').tabIndex, -1);
      final web.HTMLElement radio = _element('input[type="radio"]');
      radio.focus();
      expect(_style('.arcane-radio-circle').outlineWidth, '2px');
      expect(_style('[data-arcane-intrinsic-shape="radio-dot"]').opacity, '1');
      _element('#arcane-root').setAttribute('data-ascii-motion', 'off');
      expect(
        _style('.arcane-toggle-switch').transitionDuration.split(', '),
        everyElement('0s'),
      );
      expect(
        _style('.arcane-toggle-thumb').transitionDuration.split(', '),
        everyElement('0s'),
      );
      expect(_style('.arcane-checkbox-indicator').animationName, 'none');
    });

    testClient('Ascii ${brightness.name} progress and toast fit narrow parents', (
      ClientTester tester,
    ) async {
      tester.pumpComponent(_controls(brightness));
      await pumpEventQueue();
      final web.DOMRect parent = _element(
        '#narrow-parent',
      ).getBoundingClientRect();
      final web.DOMRect toast = _element(
        '.arcane-toast',
      ).getBoundingClientRect();
      expect(toast.width, lessThanOrEqualTo(parent.width));
      expect(
        _element('.arcane-toast').scrollWidth,
        lessThanOrEqualTo(toast.width),
      );
      final web.DOMRect ring = _element(
        '[data-arcane-intrinsic-shape="circular-progress-ring"]',
      ).getBoundingClientRect();
      final web.DOMRect label = _element(
        '.arcane-circular-progress-label',
      ).getBoundingClientRect();
      expect(ring.width, 72);
      expect(ring.height, 72);
      expect(label.top, greaterThanOrEqualTo(ring.bottom));
      expect(label.width, lessThanOrEqualTo(parent.width));
      expect(label.width, greaterThan(ring.width));
      expect(
        _element('.arcane-circular-progress').getAttribute('aria-label'),
        'Completed processing steps',
      );
      expect(
        _element(
          '.arcane-circular-progress:not(:has(.arcane-circular-progress-label))',
        ).getBoundingClientRect().height,
        72,
      );
    });
  }
}
