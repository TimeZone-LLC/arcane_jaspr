@TestOn('browser')
library;

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/core/interaction/runtime/runtime.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

web.HTMLElement _element(String selector) =>
    web.document.querySelector(selector)! as web.HTMLElement;

Future<void> _tab({bool reverse = false}) async {
  web.document.activeElement!.dispatchEvent(
    web.KeyboardEvent(
      'keydown',
      web.KeyboardEventInit(
        key: 'Tab',
        shiftKey: reverse,
        bubbles: true,
        cancelable: true,
      ),
    ),
  );
  await pumpEventQueue();
}

void main() {
  testClient('dialog wraps focus around visible disclosure content', (
    ClientTester tester,
  ) async {
    tester.pumpComponent(
      dom.div(<Widget>[
        const dom.button(id: 'outside', <Widget>[Text('Outside')]),
        dom.div(
          <Widget>[
            const dom.button(id: 'first', <Widget>[Text('First')]),
            const dom.details(<Widget>[
              dom.summary(
                id: 'outer-summary',
                attributes: <String, String>{'tabindex': '0'},
                <Widget>[Text('Sections')],
              ),
              dom.a(id: 'outer-link', href: '#outer', <Widget>[
                Text('Outer destination'),
              ]),
              dom.details(id: 'inner', <Widget>[
                dom.summary(
                  id: 'inner-summary',
                  attributes: <String, String>{'tabindex': '0'},
                  <Widget>[Text('More destinations')],
                ),
                dom.a(id: 'inner-link', href: '#inner', <Widget>[
                  Text('Inner destination'),
                ]),
              ]),
            ], id: 'outer'),
          ],
          attributes: <String, String>{
            'role': 'dialog',
            'aria-label': 'Sections',
            ...surfaceAttrs(
              surface: 'dialog',
              id: 'sections',
              initiallyOpen: true,
            ),
          },
        ),
      ]),
    );
    await pumpEventQueue();
    web.document.head!.appendChild(
      web.HTMLScriptElement()..text = arcaneInteractivityRuntimeJs,
    );
    await Future<void>.delayed(const Duration(milliseconds: 100));

    for (final String last in <String>[
      'outer-summary',
      'inner-summary',
      'inner-link',
    ]) {
      _element('#$last').focus();
      await _tab();
      expect(web.document.activeElement, _element('#first'), reason: last);
      await _tab(reverse: true);
      expect(web.document.activeElement, _element('#$last'), reason: last);
      if (last == 'outer-summary') _element('#outer').setAttribute('open', '');
      if (last == 'inner-summary') _element('#inner').setAttribute('open', '');
    }
  });
}
