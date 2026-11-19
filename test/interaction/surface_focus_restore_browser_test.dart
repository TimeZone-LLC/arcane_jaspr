@TestOn('browser')
library;

import 'dart:js_interop';

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/core/interaction/runtime/runtime.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

@JS('Arcane.config.reducedMotion')
external set _reducedMotion(bool value);

web.HTMLElement _element(String selector) =>
    web.document.querySelector(selector)! as web.HTMLElement;

void _key(String key) {
  web.document.activeElement!.dispatchEvent(
    web.KeyboardEvent(
      'keydown',
      web.KeyboardEventInit(key: key, bubbles: true, cancelable: true),
    ),
  );
}

Future<void> _frame() async {
  await pumpEventQueue();
  await Future<void>.delayed(const Duration(milliseconds: 40));
}

Future<void> _finishClose(web.HTMLElement surface) async {
  // The fallback runs after the 80ms transition plus its 100ms margin.
  await Future<void>.delayed(const Duration(milliseconds: 250));
  expect(surface.hasAttribute('hidden'), isTrue);
}

Future<web.HTMLElement> _openSelect(ClientTester tester) async {
  tester.pumpComponent(
    ArcaneApp(
      stylesheet: const NeubrutalismStylesheet(),
      includeFallbackScripts: false,
      home: dom.div(<Widget>[
        const ArcaneSelect(
          id: 'choice',
          label: 'Choice',
          value: 'art',
          options: <ArcaneSelectOption>[
            ArcaneSelectOption(value: 'art', label: 'Art'),
            ArcaneSelectOption(value: 'music', label: 'Music'),
          ],
        ),
        const dom.section(
          id: 'results',
          attributes: <String, String>{'tabindex': '-1'},
          <Widget>[Text('Results')],
        ),
        dom.button(
          id: 'open-animated',
          attributes: interactionAttrs(
            ArcaneInteraction.openPopover('animated'),
          ),
          const <Widget>[Text('Open animated panel')],
        ),
        dom.div(
          id: 'animated',
          attributes: surfaceAttrs(surface: 'popover', id: 'animated'),
          styles: const dom.Styles(
            raw: <String, String>{'transition': 'opacity 80ms linear'},
          ),
          <Widget>[
            dom.button(
              id: 'animated-close',
              attributes: interactionAttrs(
                ArcaneInteraction.closePopover('animated'),
              ),
              const <Widget>[Text('Close panel')],
            ),
          ],
        ),
        dom.button(
          id: 'open-next',
          attributes: interactionAttrs(ArcaneInteraction.openDialog('next')),
          const <Widget>[Text('Open next')],
        ),
        dom.div(
          id: 'next',
          attributes: <String, String>{
            'role': 'dialog',
            'aria-label': 'Next dialog',
            ...surfaceAttrs(surface: 'dialog', id: 'next'),
          },
          const <Widget>[
            dom.button(id: 'next-first', <Widget>[Text('Next action')]),
          ],
        ),
      ]),
    ),
  );
  await pumpEventQueue();
  web.document.head!.appendChild(
    web.HTMLScriptElement()..text = arcaneInteractivityRuntimeJs,
  );
  _reducedMotion = false;
  web.document.head!.appendChild(
    web.HTMLStyleElement()
      ..textContent =
          '#arcane-root#arcane-root #choice-listbox { '
          'transition: opacity 80ms linear !important; }',
  );
  await _frame();
  final web.HTMLElement surface = _element('#choice-listbox');
  _element('#choice').focus();
  _element('#choice').click();
  await _frame();
  expect(surface.getAttribute('data-arcane-state'), 'open');
  expect(surface.contains(web.document.activeElement), isTrue);
  surface.style.setProperty('transition', 'opacity 80ms linear', 'important');
  return surface;
}

void _closeSelect(web.HTMLElement surface, {required bool selection}) {
  expect(web.window.getComputedStyle(surface).transitionDuration, '0.08s');
  if (selection) {
    _element('#choice-listbox [data-arcane-value="music"]').focus();
    _key('Enter');
  } else {
    _key('Escape');
  }
  expect(surface.getAttribute('data-arcane-state'), 'closed');
}

void _declarativeClose(web.HTMLElement surface, {required bool remove}) {
  if (remove) {
    surface.remove();
  } else {
    surface.setAttribute('data-arcane-state', 'closed');
    surface.setAttribute('hidden', '');
  }
}

void main() {
  for (final bool selection in <bool>[true, false]) {
    final String action = selection ? 'selection' : 'Escape';
    testClient('$action returns focus to the select trigger', (
      ClientTester tester,
    ) async {
      final web.HTMLElement surface = await _openSelect(tester);
      _closeSelect(surface, selection: selection);
      await _finishClose(surface);
      expect(web.document.activeElement, _element('#choice'));
      if (selection) {
        expect(_element('#choice').textContent, contains('Music'));
      }
    });

    testClient('$action keeps focus moved to results before close finishes', (
      ClientTester tester,
    ) async {
      final web.HTMLElement surface = await _openSelect(tester);
      _closeSelect(surface, selection: selection);
      _element('#results').focus();
      await _finishClose(surface);
      expect(web.document.activeElement, _element('#results'));
    });
  }

  for (final String destination in <String>['trigger', 'results', 'dialog']) {
    testClient('animated close respects $destination focus', (
      ClientTester tester,
    ) async {
      final web.HTMLElement select = await _openSelect(tester);
      _closeSelect(select, selection: false);
      await _finishClose(select);
      _element('#open-animated').focus();
      _element('#open-animated').click();
      await _frame();
      final web.HTMLElement surface = _element('#animated');
      surface.style.setProperty(
        'transition',
        'opacity 80ms linear',
        'important',
      );
      expect(web.window.getComputedStyle(surface).transitionDuration, '0.08s');
      expect(web.document.activeElement, _element('#animated-close'));
      _element('#animated-close').click();
      expect(surface.classList.contains('arcane-surface-closing'), isTrue);
      expect(surface.hasAttribute('hidden'), isFalse);
      if (destination == 'results') {
        _element('#results').focus();
      } else if (destination == 'dialog') {
        _element('#open-next').focus();
        _element('#open-next').click();
        await _frame();
        expect(web.document.activeElement, _element('#next-first'));
      }
      await _finishClose(surface);
      final String expected = switch (destination) {
        'results' => '#results',
        'dialog' => '#next-first',
        _ => '#open-animated',
      };
      expect(web.document.activeElement, _element(expected));
    });
  }

  testClient(
    'a newer dialog keeps focus when the old select finishes closing',
    (ClientTester tester) async {
      final web.HTMLElement surface = await _openSelect(tester);
      _closeSelect(surface, selection: true);
      _element('#open-next').focus();
      _element('#open-next').click();
      await _frame();
      expect(web.document.activeElement, _element('#next-first'));
      await _finishClose(surface);
      expect(web.document.activeElement, _element('#next-first'));
      _key('Escape');
      await _frame();
      expect(web.document.activeElement, _element('#open-next'));
    },
  );

  for (final bool remove in <bool>[false, true]) {
    final String action = remove ? 'removal' : 'declarative close';
    testClient('$action returns focus when no other control owns it', (
      ClientTester tester,
    ) async {
      final web.HTMLElement surface = await _openSelect(tester);
      _declarativeClose(surface, remove: remove);
      await _frame();
      expect(web.document.activeElement, _element('#choice'));
    });

    testClient('$action preserves focus moved outside before observer runs', (
      ClientTester tester,
    ) async {
      final web.HTMLElement surface = await _openSelect(tester);
      _declarativeClose(surface, remove: remove);
      _element('#results').focus();
      await _frame();
      expect(web.document.activeElement, _element('#results'));
    });
  }

  testClient('declarative close does not override a newer pending dialog', (
    ClientTester tester,
  ) async {
    final web.HTMLElement surface = await _openSelect(tester);
    int returnedToTrigger = 0;
    _element(
      '#choice',
    ).addEventListener('focus', ((web.Event _) => returnedToTrigger++).toJS);
    _declarativeClose(surface, remove: false);
    _element('#next').removeAttribute('hidden');
    _element('#next').setAttribute('data-arcane-state', 'open');
    await _frame();
    expect(returnedToTrigger, 0);
    expect(web.document.activeElement, _element('#next-first'));
  });
}
