@TestOn('browser')
library;

import 'dart:js_interop';

import 'package:arcane_jaspr/core/interaction/runtime/runtime.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart' show Component;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

@JS('Arcane.run')
external void _run(String actions, JSObject context);

void main() {
  testClient('a hover card opened after a menu leaves the menu its focus', (
    ClientTester tester,
  ) async {
    tester.pumpComponent(
      const dom.div(<Component>[
        dom.button(id: 'opener', <Component>[Component.text('Offers')]),
        dom.div(
          attributes: <String, String>{
            'data-arcane-surface': 'menu',
            'data-arcane-id': 'offers-menu',
            'data-arcane-state': 'closed',
            'role': 'menu',
            'hidden': '',
          },
          <Component>[
            dom.button(
              id: 'first-item',
              attributes: <String, String>{'role': 'menuitem'},
              <Component>[Component.text('Add trade')],
            ),
          ],
        ),
        dom.div(
          attributes: <String, String>{
            'data-arcane-surface': 'hovercard',
            'data-arcane-id': 'amount-tip',
            'data-arcane-state': 'closed',
            'hidden': '',
          },
          <Component>[Component.text('More: Takes 2 amount')],
        ),
      ]),
    );
    web.document.head!.appendChild(
      web.HTMLScriptElement()..text = arcaneInteractivityRuntimeJs,
    );
    await pumpEventQueue();
    final web.HTMLElement opener =
        web.document.getElementById('opener')! as web.HTMLElement;
    opener.focus();

    // The menu opens from the keyboard; a pointer resting on another
    // trigger opens that trigger's tip before the menu takes focus.
    _run('surface.open menu offers-menu', JSObject());
    _run('surface.open hovercard amount-tip', JSObject());
    await Future<void>.delayed(const Duration(milliseconds: 120));

    expect(web.document.activeElement?.id, 'first-item');
  });
}
