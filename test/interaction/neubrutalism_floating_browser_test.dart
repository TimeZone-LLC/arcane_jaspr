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
  await Future<void>.delayed(const Duration(milliseconds: 250));
}

void main() {
  for (final NeubrutalismVariant variant in NeubrutalismVariant.values) {
    testClient(
      '${variant.name} hydrated popover toggles once and restores focus',
      (ClientTester tester) async {
        tester.pumpComponent(
          ArcaneApp(
            stylesheet: NeubrutalismStylesheet(variant: variant),
            includeFallbackScripts: false,
            home: const dom.div(<Widget>[
              ArcanePopover(
                trigger: dom.button(id: 'open-proof', <Widget>[
                  Text('Open proof'),
                ]),
                content: Text('Recycled paper details'),
              ),
              dom.button(id: 'outside', <Widget>[Text('Outside')]),
            ]),
          ),
        );
        web.document.head!.appendChild(
          web.HTMLScriptElement()..text = arcaneInteractivityRuntimeJs,
        );
        await _settle();
        final web.HTMLElement trigger = _element('#open-proof');
        trigger.focus();
        trigger.click();
        await _settle();
        expect(
          _element('.neubrutalism-popover').getAttribute('data-arcane-state'),
          'open',
        );
        trigger.click();
        await _settle();
        expect(
          _element('.neubrutalism-popover').getAttribute('data-arcane-state'),
          'closed',
        );
        trigger.click();
        await _settle();
        _element('.neubrutalism-popover').dispatchEvent(
          web.KeyboardEvent(
            'keydown',
            web.KeyboardEventInit(key: 'Escape', bubbles: true),
          ),
        );
        await _settle();
        expect(
          _element('.neubrutalism-popover').hasAttribute('hidden'),
          isTrue,
        );
        expect(web.document.activeElement, trigger);
        trigger.click();
        await _settle();
        _element('#outside').click();
        await _settle();
        expect(
          _element('.neubrutalism-popover').hasAttribute('hidden'),
          isTrue,
        );
      },
    );

    testClient(
      '${variant.name} tooltip uses readable width beside a short trigger',
      (ClientTester tester) async {
        tester.pumpComponent(
          ArcaneApp(
            stylesheet: NeubrutalismStylesheet(variant: variant),
            includeFallbackScripts: false,
            home: const dom.div(
              styles: dom.Styles(
                raw: <String, String>{'padding': '200px 20px'},
              ),
              <Widget>[
                ArcaneTooltip(
                  text: 'A test sheet before the full print run.',
                  child: dom.button(id: 'hint', <Widget>[Text('Proof?')]),
                ),
              ],
            ),
          ),
        );
        web.document.head!.appendChild(
          web.HTMLScriptElement()..text = arcaneInteractivityRuntimeJs,
        );
        await _settle();
        _element('#hint').focus();
        await _settle();
        final web.DOMRect box = _element(
          '[role="tooltip"]',
        ).getBoundingClientRect();
        expect(box.width, greaterThanOrEqualTo(200));
        expect(box.height, lessThan(110));
        expect(box.left, greaterThanOrEqualTo(0));
        expect(box.right, lessThanOrEqualTo(web.window.innerWidth));
      },
    );
  }
}
