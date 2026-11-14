@TestOn('browser')
library;

import 'package:arcane_jaspr/core/interaction/runtime/runtime.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart' show Component;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

void main() {
  testClient(
    'Enter on a menu button inside a summary opens the menu, not the row',
    (ClientTester tester) async {
      tester.pumpComponent(
        const dom.div(<Component>[
          dom.details(id: 'row', <Component>[
            dom.summary(<Component>[
              Component.text('Offer 2'),
              dom.div(
                attributes: <String, String>{
                  'aria-haspopup': 'menu',
                  'aria-controls': 'row-menu',
                  'data-arcane-action': 'surface.toggle menu row-menu',
                },
                <Component>[
                  dom.button(
                    id: 'row-menu-button',
                    attributes: <String, String>{'type': 'button'},
                    <Component>[Component.text('Actions')],
                  ),
                ],
              ),
            ]),
          ]),
          dom.div(
            id: 'row-menu',
            attributes: <String, String>{
              'data-arcane-surface': 'menu',
              'data-arcane-id': 'row-menu',
              'data-arcane-state': 'closed',
              'role': 'menu',
              'hidden': '',
            },
            <Component>[
              dom.button(
                attributes: <String, String>{'role': 'menuitem'},
                <Component>[Component.text('Move up')],
              ),
            ],
          ),
        ]),
      );
      web.document.head!.appendChild(
        web.HTMLScriptElement()..text = arcaneInteractivityRuntimeJs,
      );
      await pumpEventQueue();
      final web.HTMLElement button =
          web.document.getElementById('row-menu-button')! as web.HTMLElement;
      button.focus();

      button.dispatchEvent(
        web.KeyboardEvent(
          'keydown',
          web.KeyboardEventInit(key: 'Enter', bubbles: true, cancelable: true),
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 120));

      final web.HTMLDetailsElement row =
          web.document.getElementById('row')! as web.HTMLDetailsElement;
      final web.Element menu = web.document.querySelector(
        '[data-arcane-id="row-menu"]',
      )!;
      expect(row.open, isFalse, reason: 'the row stays closed');
      expect(menu.getAttribute('data-arcane-state'), 'open');
    },
  );
}
