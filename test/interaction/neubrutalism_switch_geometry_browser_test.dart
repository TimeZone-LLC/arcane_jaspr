@TestOn('browser')
library;

import 'dart:js_interop';

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/core/interaction/runtime/runtime.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart' show StatefulBuilder, StateSetter;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

extension _SwitchGeometry on web.HTMLElement {
  void expectGeometry({
    required bool checked,
    required bool rounded,
    ComponentSize? squareBoxSize,
  }) {
    final web.HTMLElement thumb =
        querySelector('.neubrutalism-toggle-switch-thumb')! as web.HTMLElement;
    final web.DOMRect trackBounds = getBoundingClientRect();
    final web.DOMRect thumbBounds = thumb.getBoundingClientRect();
    final web.CSSStyleDeclaration trackStyle = web.window.getComputedStyle(
      this,
    );
    expect(getAttribute('aria-checked'), '$checked');
    if (squareBoxSize != null) {
      final web.CSSStyleDeclaration box = web.window.getComputedStyle(
        this,
        '::before',
      );
      final web.CSSStyleDeclaration check = web.window.getComputedStyle(
        this,
        '::after',
      );
      final String expectedSize = switch (squareBoxSize) {
        ComponentSize.sm => '20px',
        ComponentSize.md => '24px',
        ComponentSize.lg => '28px',
      };
      expect(trackBounds.width, greaterThanOrEqualTo(44));
      expect(trackBounds.height, greaterThanOrEqualTo(44));
      expect(box.width, expectedSize);
      expect(box.height, box.width, reason: 'The visible control is square.');
      expect(box.borderRadius, '0px');
      expect(box.borderTopWidth, '2px');
      expect(check.opacity, checked ? '1' : '0');
      expect(check.borderRightWidth, '2px');
      expect(check.borderBottomWidth, '2px');
      expect(web.window.getComputedStyle(thumb).display, 'none');
      expect(web.window.getComputedStyle(thumb).transform, 'none');
      return;
    }
    final double topGap =
        thumbBounds.top -
        trackBounds.top -
        double.parse(trackStyle.borderTopWidth.replaceAll('px', ''));
    final double bottomGap =
        trackBounds.bottom -
        thumbBounds.bottom -
        double.parse(trackStyle.borderBottomWidth.replaceAll('px', ''));
    final double endGap = checked
        ? trackBounds.right -
              thumbBounds.right -
              double.parse(trackStyle.borderRightWidth.replaceAll('px', ''))
        : thumbBounds.left -
              trackBounds.left -
              double.parse(trackStyle.borderLeftWidth.replaceAll('px', ''));

    expect(thumbBounds.width, closeTo(thumbBounds.height, 0.1));
    expect(topGap, greaterThan(0), reason: 'Thumb clears the top border.');
    expect(bottomGap, closeTo(topGap, 0.1));
    expect(
      endGap,
      closeTo(topGap, 0.1),
      reason: 'The active end has the same clearance as the top and bottom.',
    );
    expect(
      web.window.getComputedStyle(thumb).borderRadius,
      rounded ? '50%' : '0px',
    );
    if (rounded) {
      expect(
        double.parse(trackStyle.borderTopLeftRadius.replaceAll('px', '')),
        greaterThanOrEqualTo(trackBounds.height / 2),
      );
    } else {
      expect(trackStyle.borderRadius, '0px');
    }
  }
}

void main() {
  setUpAll(() {
    final web.HTMLStyleElement stylesheet = web.HTMLStyleElement()
      ..textContent =
          '${const NeubrutalismStylesheet().baseCss}\n'
          '.neubrutalism-toggle-switch, '
          '.neubrutalism-toggle-switch-thumb { transition: none !important; }';
    web.document.head!.appendChild(stylesheet);
    final web.HTMLScriptElement runtime = web.HTMLScriptElement()
      ..text = arcaneInteractivityRuntimeJs;
    web.document.head!.appendChild(runtime);
  });
  tearDown(() => web.document.body!.replaceChildren(<web.Node>[].toJS));

  for (final NeubrutalismVariant variant in NeubrutalismVariant.values) {
    for (final bool rounded in <bool>[false, true]) {
      for (ComponentSize size in ComponentSize.values) {
        for (Brightness brightness in Brightness.values) {
          for (bool hydrated in <bool>[false, true]) {
            testClient(
              '${variant.name} ${rounded ? 'rounded' : 'square'} ${size.name} ${brightness.name} switch preserves its indicator geometry '
              'when toggled (hydrated: $hydrated)',
              (ClientTester tester) async {
                bool enabled = false;
                final List<bool> changes = <bool>[];
                tester.pumpComponent(
                  ArcaneThemeProvider(
                    stylesheet: NeubrutalismStylesheet(
                      variant: variant,
                      rounded: rounded,
                    ),
                    brightness: brightness,
                    child: dom.div(
                      id: 'arcane-root',
                      classes:
                          'arcane-theme-neubrutalism ${brightness.name} '
                          '${variant == NeubrutalismVariant.neuComic ? 'neucomic ' : ''}'
                          '${rounded ? 'neubrutalism-rounded' : ''}',
                      <Widget>[
                        StatefulBuilder(
                          builder:
                              (
                                BuildContext context,
                                StateSetter setState,
                              ) => ArcaneToggleSwitch(
                                id: 'switch-${size.name}-${brightness.name}-$hydrated',
                                size: size,
                                value: enabled,
                                label: 'Dark mode',
                                onChanged: hydrated
                                    ? (bool value) => setState(() {
                                        enabled = value;
                                        changes.add(value);
                                      })
                                    : null,
                              ),
                        ),
                      ],
                    ),
                  ),
                );
                await pumpEventQueue();
                final web.HTMLElement control =
                    web.document.querySelector('[role="switch"]')!
                        as web.HTMLElement;
                control.expectGeometry(
                  checked: false,
                  rounded: rounded && variant == NeubrutalismVariant.classic,
                  squareBoxSize: variant == NeubrutalismVariant.neuComic
                      ? size
                      : null,
                );

                control.click();
                await pumpEventQueue();
                control.expectGeometry(
                  checked: true,
                  rounded: rounded && variant == NeubrutalismVariant.classic,
                  squareBoxSize: variant == NeubrutalismVariant.neuComic
                      ? size
                      : null,
                );

                control.click();
                await pumpEventQueue();
                control.expectGeometry(
                  checked: false,
                  rounded: rounded && variant == NeubrutalismVariant.classic,
                  squareBoxSize: variant == NeubrutalismVariant.neuComic
                      ? size
                      : null,
                );
                if (hydrated) {
                  expect(changes, <bool>[true, false]);
                }
              },
            );
          }
        }
      }
    }
  }
}
