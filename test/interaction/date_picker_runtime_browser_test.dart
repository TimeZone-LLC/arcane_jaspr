@TestOn('browser')
library;

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/core/interaction/runtime/runtime.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart' show Component;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

Future<void> _click(String selector) async {
  (web.document.querySelector(selector)! as web.HTMLElement).click();
  await pumpEventQueue();
}

void main() {
  testClient('hydrated date picker and runtime share one interaction', (
    ClientTester tester,
  ) async {
    final List<DateTime?> changes = <DateTime?>[];
    tester.pumpComponent(
      ArcaneApp(
        stylesheet: const ShadcnStylesheet(),
        includeFallbackScripts: false,
        home: dom.div(
          styles: const dom.Styles(
            raw: <String, String>{'margin': '80px 120px', 'width': '320px'},
          ),
          <Component>[
            ArcaneDatePicker(
              id: 'date',
              value: DateTime(2026, 4, 24),
              onChanged: changes.add,
            ),
          ],
        ),
      ),
    );
    final web.HTMLScriptElement runtime = web.HTMLScriptElement()
      ..text = arcaneInteractivityRuntimeJs;
    web.document.head!.appendChild(runtime);
    await pumpEventQueue();
    await _click('.arcane-date-picker-trigger');
    final web.Element popover = web.document.querySelector(
      '.arcane-date-picker-dropdown',
    )!;
    expect(popover.getAttribute('data-arcane-state'), 'open');
    expect(popover.hasAttribute('hidden'), isFalse);
    final web.DOMRect triggerRect = web.document
        .querySelector('.arcane-date-picker-trigger')!
        .getBoundingClientRect();
    final web.DOMRect popupRect = popover.getBoundingClientRect();
    expect(popupRect.left, closeTo(triggerRect.left, 1));
    expect(popupRect.top, closeTo(triggerRect.bottom + 8, 1));
    expect(
      web.window
          .getComputedStyle(
            web.document.querySelector('.arcane-calendar-grid')!,
          )
          .display,
      'grid',
    );
    await _click('.arcane-calendar-next');
    expect(
      web.document.querySelector('.arcane-calendar-label')!.textContent,
      'May 2026',
    );
    await _click('[data-arcane-value="2026-05-17"]');
    expect(changes, <DateTime?>[DateTime(2026, 5, 17)]);
    expect(popover.getAttribute('data-arcane-state'), 'closed');
    await _click('.arcane-date-picker-trigger');
    expect(popover.getAttribute('data-arcane-state'), 'open');
    popover.dispatchEvent(
      web.KeyboardEvent(
        'keydown',
        web.KeyboardEventInit(key: 'Escape', bubbles: true),
      ),
    );
    await pumpEventQueue();
    expect(popover.getAttribute('data-arcane-state'), 'closed');
    await _click('.arcane-date-picker-trigger');
    expect(popover.getAttribute('data-arcane-state'), 'open');
    expect(
      web.document
          .querySelector('.arcane-date-picker-trigger')!
          .getAttribute('aria-expanded'),
      'true',
    );
  });
}
