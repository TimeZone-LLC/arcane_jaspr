@TestOn('browser')
library;

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/core/interaction/runtime/runtime.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

web.HTMLElement _element(String selector) =>
    web.document.querySelector(selector)! as web.HTMLElement;

Future<void> _settle() async {
  await pumpEventQueue();
  await Future<void>.delayed(const Duration(milliseconds: 300));
}

Future<void> _key(web.Element element, String key) async {
  element.dispatchEvent(
    web.KeyboardEvent(
      'keydown',
      web.KeyboardEventInit(key: key, bubbles: true, cancelable: true),
    ),
  );
  await _settle();
}

void _expectInsideViewport(web.HTMLElement panel) {
  final web.DOMRect bounds = panel.getBoundingClientRect();
  expect(bounds.left, greaterThanOrEqualTo(0));
  expect(bounds.right, lessThanOrEqualTo(web.window.innerWidth));
}

void main() {
  for (final NeubrutalismVariant variant in NeubrutalismVariant.values) {
    testClient('${variant.name} mega menu supports touch and keyboard', (
      ClientTester tester,
    ) async {
      int actions = 0;
      tester.pumpComponent(
        ArcaneApp(
          stylesheet: NeubrutalismStylesheet(variant: variant),
          includeFallbackScripts: false,
          home: dom.div(<Widget>[
            ArcaneMegaMenu(
              label: 'Workshop tools',
              sections: <ArcaneMegaMenuSection>[
                ArcaneMegaMenuSection(
                  title: 'Print',
                  items: <ArcaneMenuItem>[
                    MenuItemAction(
                      label: 'Disabled',
                      disabled: true,
                      onSelect: () => actions += 100,
                    ),
                    MenuItemAction(
                      label: 'Duplicate edition',
                      onSelect: () => actions++,
                    ),
                  ],
                ),
                ArcaneMegaMenuSection(
                  title: 'Share',
                  items: <ArcaneMenuItem>[
                    MenuItemAction(
                      label: 'Archive edition',
                      onSelect: () => actions++,
                    ),
                  ],
                ),
              ],
            ),
            const dom.button(id: 'outside', <Widget>[Text('Outside')]),
          ]),
        ),
      );
      web.document.head!.appendChild(
        web.HTMLScriptElement()..text = arcaneInteractivityRuntimeJs,
      );
      await _settle();
      final web.HTMLElement trigger = _element('.arcane-mega-menu-trigger');
      trigger.focus();
      trigger.click();
      await _settle();
      final web.HTMLElement panel = _element('.arcane-mega-menu-panel');
      expect(panel.getAttribute('data-arcane-state'), 'open');
      expect(trigger.getAttribute('aria-expanded'), 'true');
      expect(trigger.querySelector('[aria-hidden="true"]'), isNotNull);
      _expectInsideViewport(panel);
      expect(
        web.document.activeElement!.textContent,
        contains('Duplicate edition'),
      );
      await _key(web.document.activeElement!, 'End');
      expect(
        web.document.activeElement!.textContent,
        contains('Archive edition'),
      );
      await _key(web.document.activeElement!, 'Home');
      expect(
        web.document.activeElement!.textContent,
        contains('Duplicate edition'),
      );
      await _key(web.document.activeElement!, 'Enter');
      expect(actions, 1);
      expect(panel.getAttribute('data-arcane-state'), 'closed');
      expect(web.document.activeElement, trigger);
      await _key(trigger, ' ');
      expect(panel.getAttribute('data-arcane-state'), 'open');
      await _key(web.document.activeElement!, 'Escape');
      expect(panel.getAttribute('data-arcane-state'), 'closed');
      trigger.click();
      await _settle();
      _element('#outside').click();
      await _settle();
      expect(panel.getAttribute('data-arcane-state'), 'closed');
    });

    testClient('${variant.name} mega menu stays above a bottom-edge trigger', (
      ClientTester tester,
    ) async {
      tester.pumpComponent(
        ArcaneApp(
          stylesheet: NeubrutalismStylesheet(variant: variant),
          includeFallbackScripts: false,
          home: const dom.div(
            styles: dom.Styles(
              raw: <String, String>{
                'position': 'fixed',
                'bottom': '12px',
                'left': '12px',
              },
            ),
            <Widget>[
              ArcaneMegaMenu(
                label: 'Workshop tools',
                sections: <ArcaneMegaMenuSection>[
                  ArcaneMegaMenuSection(
                    title: 'Edition',
                    items: <ArcaneMenuItem>[
                      MenuItemAction(label: 'Duplicate edition'),
                      MenuItemAction(label: 'Archive edition'),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      web.document.head!.appendChild(
        web.HTMLScriptElement()..text = arcaneInteractivityRuntimeJs,
      );
      await _settle();
      final web.HTMLElement trigger = _element('.arcane-mega-menu-trigger');
      final web.HTMLElement panel = _element('.arcane-mega-menu-panel');
      final String surfaceId = panel.id;
      final web.Element chevron = trigger.querySelector(
        '[aria-hidden="true"]',
      )!;
      final String closedTransform = web.window
          .getComputedStyle(chevron)
          .transform;

      for (int opening = 0; opening < 2; opening++) {
        trigger.focus();
        trigger.click();
        await _settle();
        final web.DOMRect bounds = panel.getBoundingClientRect();
        _expectInsideViewport(panel);
        expect(bounds.top, greaterThanOrEqualTo(0));
        expect(bounds.bottom, lessThanOrEqualTo(web.window.innerHeight));
        expect(
          bounds.bottom,
          lessThanOrEqualTo(trigger.getBoundingClientRect().top),
        );
        expect(panel.id, surfaceId);
        expect(trigger.getAttribute('aria-controls'), surfaceId);
        expect(trigger.getAttribute('aria-expanded'), 'true');
        expect(
          web.window.getComputedStyle(chevron).transform,
          isNot(closedTransform),
        );
        expect(
          web.document.activeElement!.textContent,
          contains('Duplicate edition'),
        );

        await _key(web.document.activeElement!, 'Escape');
        expect(panel.hasAttribute('hidden'), isTrue);
        expect(trigger.getAttribute('aria-expanded'), 'false');
        expect(web.document.activeElement, trigger);
        expect(web.window.getComputedStyle(chevron).transform, closedTransform);
      }
    });
  }
}
