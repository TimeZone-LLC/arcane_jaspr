@TestOn('browser')
library;

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/core/interaction/runtime/runtime.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

web.HTMLElement _element(String selector) =>
    web.document.querySelector(selector)! as web.HTMLElement;

Future<void> _settle() async {
  await pumpEventQueue();
  await Future<void>.delayed(const Duration(milliseconds: 30));
}

void main() {
  for (final bool withRuntime in <bool>[false, true]) {
    testClient('tooltip keyboard lifecycle with runtime=$withRuntime', (
      ClientTester tester,
    ) async {
      tester.pumpComponent(
        const ArcaneApp(
          stylesheet: ShadcnStylesheet(),
          includeFallbackScripts: false,
          home: Column(
            children: <Widget>[
              ArcaneTooltip(
                text: 'Switch to light theme',
                child: dom.button(id: 'theme-trigger', <Widget>[
                  Text('Theme'),
                ]),
              ),
              dom.button(id: 'outside', <Widget>[Text('Outside')]),
            ],
          ),
        ),
      );
      if (withRuntime) {
        web.document.head!.appendChild(
          web.HTMLScriptElement()..text = arcaneInteractivityRuntimeJs,
        );
      }
      await _settle();
      final web.HTMLElement trigger = _element('#theme-trigger');
      final web.HTMLElement outside = _element('#outside');
      trigger.focus();
      await _settle();
      expect(_element('[role="tooltip"]').hasAttribute('hidden'), isFalse);
      expect(web.document.activeElement, trigger);

      trigger.dispatchEvent(
        web.KeyboardEvent(
          'keydown',
          web.KeyboardEventInit(key: 'Escape', bubbles: true, cancelable: true),
        ),
      );
      await _settle();
      expect(_element('[role="tooltip"]').hasAttribute('hidden'), isTrue);
      expect(web.document.activeElement, trigger);

      outside.focus();
      trigger.focus();
      await _settle();
      expect(_element('[role="tooltip"]').hasAttribute('hidden'), isFalse);
      _element(
        '.arcane-floating-container',
      ).dispatchEvent(web.MouseEvent('mouseleave'));
      await _settle();
      expect(_element('[role="tooltip"]').hasAttribute('hidden'), isFalse);

      outside.focus();
      await _settle();
      expect(_element('[role="tooltip"]').hasAttribute('hidden'), isTrue);
      expect(web.document.activeElement, outside);
      trigger.focus();
      await _settle();
      expect(_element('[role="tooltip"]').hasAttribute('hidden'), isFalse);
    });
  }

  testClient('hovercard disposes a pending delayed open', (
    ClientTester tester,
  ) async {
    tester.pumpComponent(
      const ArcaneApp(
        stylesheet: ShadcnStylesheet(),
        includeFallbackScripts: false,
        home: ArcaneHoverCard.hovercard(
          trigger: dom.button(<Widget>[Text('Preview')]),
          content: Text('Details'),
          openDelay: 100,
        ),
      ),
    );
    await pumpEventQueue();
    _element(
      '.arcane-floating-container',
    ).dispatchEvent(web.MouseEvent('mouseenter'));
    tester.pumpComponent(const SizedBox());
    await Future<void>.delayed(const Duration(milliseconds: 150));
    expect(web.document.querySelector('[role="tooltip"]'), isNull);
  });
}
