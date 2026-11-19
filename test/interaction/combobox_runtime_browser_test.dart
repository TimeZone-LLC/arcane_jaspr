@TestOn('browser')
library;

import 'dart:js_interop';

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/core/interaction/runtime/runtime.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

Future<void> _click(String selector) async {
  (web.document.querySelector(selector)! as web.HTMLElement).click();
  await pumpEventQueue();
}

Future<void> _search(web.HTMLInputElement input, String query) async {
  input.value = query;
  input.dispatchEvent(web.Event('input', web.EventInit(bubbles: true)));
  await pumpEventQueue();
}

Future<void> _key(web.Element target, String key) async {
  target.dispatchEvent(
    web.KeyboardEvent(
      'keydown',
      web.KeyboardEventInit(key: key, bubbles: true, cancelable: true),
    ),
  );
  await pumpEventQueue();
}

void main() {
  testClient('combobox opens once, filters, dismisses and reopens', (
    ClientTester tester,
  ) async {
    final List<String?> changes = <String?>[];
    int actionCount = 0;
    web.document.addEventListener(
      'combobox-selection',
      ((web.Event event) => actionCount++).toJS,
    );
    tester.pumpComponent(
      ArcaneApp(
        stylesheet: const ShadcnStylesheet(),
        includeFallbackScripts: false,
        home: ArcaneCombobox<String>(
          label: 'Framework',
          value: 'jaspr',
          options: const <ComboboxOption<String>>[
            ComboboxOption<String>(value: 'jaspr', label: 'Jaspr'),
            ComboboxOption<String>(value: 'flutter', label: 'Flutter'),
          ],
          onChanged: changes.add,
          onChangedAction: ArcaneInteraction.dispatch('combobox-selection'),
        ),
      ),
    );
    final web.HTMLScriptElement runtime = web.HTMLScriptElement()
      ..text = arcaneInteractivityRuntimeJs;
    web.document.head!.appendChild(runtime);
    await pumpEventQueue();

    await _click('button.arcane-select');
    final web.Element dropdown = web.document.querySelector(
      '.arcane-select-dropdown',
    )!;
    expect(dropdown.getAttribute('data-arcane-state'), 'open');
    expect(dropdown.hasAttribute('hidden'), isFalse);
    final String? surfaceId = dropdown.getAttribute('data-arcane-id');
    final web.HTMLInputElement search =
        dropdown.querySelector('input')! as web.HTMLInputElement;
    await _search(search, 'missing');
    expect(dropdown.querySelectorAll('[role="option"]').length, 0);
    expect(
      'No results found'.allMatches(dropdown.textContent ?? ''),
      hasLength(1),
    );
    await _search(search, 'flu');
    expect(dropdown.getAttribute('data-arcane-id'), surfaceId);
    expect(dropdown.getAttribute('data-arcane-state'), 'open');
    expect(dropdown.querySelector('[data-arcane-value="jaspr"]'), isNull);
    await _key(search, 'ArrowDown');
    expect(
      dropdown
          .querySelector('[data-arcane-value="flutter"]')!
          .getAttribute('data-arcane-state'),
      'active',
    );
    await _key(search, 'Enter');
    expect(changes, <String?>['flutter']);
    expect(actionCount, 1);
    expect(dropdown.getAttribute('data-arcane-state'), 'closed');

    await _click('button.arcane-select');
    expect(dropdown.getAttribute('data-arcane-state'), 'open');
    await _key(dropdown, 'Escape');
    expect(dropdown.getAttribute('data-arcane-state'), 'closed');
    await _click('button.arcane-select');
    expect(dropdown.getAttribute('data-arcane-state'), 'open');
    expect(
      web.document
          .querySelector('button.arcane-select')!
          .getAttribute('aria-expanded'),
      'true',
    );
    await _click('body');
    expect(dropdown.getAttribute('data-arcane-state'), 'closed');
    await _click('button.arcane-select');
    expect(dropdown.getAttribute('data-arcane-state'), 'open');
    expect(dropdown.getAttribute('data-arcane-id'), surfaceId);
  });
}
