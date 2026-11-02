@TestOn('browser')
library;

import 'dart:math' as math;

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

web.HTMLElement _element(String selector) =>
    web.document.querySelector(selector)! as web.HTMLElement;

web.CSSStyleDeclaration _style(String selector) =>
    web.window.getComputedStyle(_element(selector));

double _contrast(String foreground, String background) {
  double luminance(String color) {
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
    return channels[0] * .2126 + channels[1] * .7152 + channels[2] * .0722;
  }

  final double front = luminance(foreground);
  final double back = luminance(background);
  return (math.max(front, back) + .05) / (math.min(front, back) + .05);
}

void main() {
  for (final NeubrutalismVariant variant in NeubrutalismVariant.values) {
    for (final Brightness brightness in Brightness.values) {
      testClient(
        '${variant.name} ${brightness.name} preserves authored card accents and default contrast',
        (ClientTester tester) async {
          final bool dark = brightness == Brightness.dark;
          final String featureAccent = dark ? '#F3ADB8' : '#8F3A50';
          final String featureRgb = dark
              ? 'rgb(243, 173, 184)'
              : 'rgb(143, 58, 80)';
          final String ctaAccent = dark ? '#B7D5A4' : '#97720C';
          final String ctaRgb = dark
              ? 'rgb(183, 213, 164)'
              : 'rgb(151, 114, 12)';
          web.document.documentElement!.className = brightness.name;
          tester.pumpComponent(
            ArcaneApp(
              stylesheet: NeubrutalismStylesheet(variant: variant),
              brightness: brightness,
              includeFallbackScripts: false,
              home: dom.div(<Widget>[
                dom.div(id: 'feature-custom', <Widget>[
                  FeatureCard(
                    title: 'Print',
                    description: 'Two colors.',
                    icon: ArcaneIcon.layers(),
                    showCta: true,
                    ctaText: 'Review',
                    accentColor: featureAccent,
                  ),
                ]),
                dom.div(id: 'cta-custom', <Widget>[
                  CtaCard(
                    title: 'Proof',
                    ctaText: 'Review',
                    icon: ArcaneIcon.layers(),
                    accentColor: ctaAccent,
                  ),
                ]),
                dom.div(id: 'feature-default', <Widget>[
                  FeatureCard(
                    title: 'Print',
                    description: 'Two colors.',
                    icon: ArcaneIcon.layers(),
                    showCta: true,
                    ctaText: 'Review',
                  ),
                ]),
                dom.div(id: 'cta-default', <Widget>[
                  CtaCard(
                    title: 'Proof',
                    ctaText: 'Review',
                    icon: ArcaneIcon.layers(),
                  ),
                ]),
              ]),
            ),
          );
          await pumpEventQueue();

          expect(
            _style('#feature-custom .neubrutalism-feature-card-icon').color,
            featureRgb,
          );
          expect(
            _style('#feature-custom .neubrutalism-feature-card-cta').color,
            featureRgb,
          );
          expect(_style('#feature-custom > *').borderTopColor, featureRgb);
          expect(
            _style('#cta-custom .neubrutalism-cta-card-icon').color,
            ctaRgb,
          );
          expect(
            _style('#cta-custom .neubrutalism-cta-card-button').backgroundColor,
            ctaRgb,
          );

          for (final String id in <String>['feature-custom', 'cta-custom']) {
            final web.CSSStyleDeclaration frame = _style('#$id > *');
            expect(
              frame.borderTopWidth,
              '3px',
              reason: '$id keeps its theme frame',
            );
            expect(frame.boxShadow, isNot('none'));
            expect(
              _element('#$id > *').hasAttribute('data-arcane-decorated'),
              isFalse,
            );
          }
          for (final String id in <String>[
            'feature-custom',
            'feature-default',
          ]) {
            expect(
              _contrast(
                _style('#$id .neubrutalism-feature-card-cta').color,
                _style('#$id > *').backgroundColor,
              ),
              greaterThanOrEqualTo(4.5),
            );
          }
          for (final String id in <String>['cta-custom', 'cta-default']) {
            final web.CSSStyleDeclaration button = _style(
              '#$id .neubrutalism-cta-card-button',
            );
            expect(
              _contrast(button.color, button.backgroundColor),
              greaterThanOrEqualTo(4.5),
            );
          }
          for (final String selector in <String>[
            '#feature-default .neubrutalism-feature-card-icon',
            '#cta-default .neubrutalism-cta-card-icon',
          ]) {
            final web.CSSStyleDeclaration icon = _style(selector);
            expect(
              _contrast(icon.color, icon.backgroundColor),
              greaterThanOrEqualTo(3),
            );
          }
        },
      );
    }
  }
}
