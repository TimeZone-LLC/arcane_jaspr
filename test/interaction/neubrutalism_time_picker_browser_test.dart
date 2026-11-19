@TestOn('browser')
library;

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/component/input/time_picker.dart';
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

Future<void> _click(String selector) async {
  _element(selector).click();
  await _settle();
}

void _pump(
  ClientTester tester,
  NeubrutalismVariant variant,
  List<TimeOfDay?> changes,
) {
  tester.pumpComponent(
    ArcaneApp(
      stylesheet: NeubrutalismStylesheet(variant: variant),
      brightness: Brightness.light,
      includeFallbackScripts: false,
      home: dom.div(
        styles: const dom.Styles(
          raw: <String, String>{
            'margin': '24px',
            'width': 'min(268px, calc(100vw - 48px))',
          },
        ),
        <Widget>[
          ArcaneTimePicker(
            id: 'time',
            value: const TimeOfDay(hour: 23, minute: 55),
            label: 'Start time',
            onChanged: changes.add,
          ),
          const dom.button(id: 'outside', <Widget>[Text('Outside')]),
        ],
      ),
    ),
  );
  web.document.head!.appendChild(
    web.HTMLScriptElement()..text = arcaneInteractivityRuntimeJs,
  );
}

void main() {
  for (final NeubrutalismVariant variant in NeubrutalismVariant.values) {
    testClient('${variant.name} time picker fits and reveals selected time', (
      ClientTester tester,
    ) async {
      _pump(tester, variant, <TimeOfDay?>[]);
      await _settle();
      await _click('.neubrutalism-time-picker-trigger');
      final web.HTMLElement popup = _element(
        '.neubrutalism-time-picker-dropdown',
      );
      final web.DOMRect bounds = popup.getBoundingClientRect();
      final web.DOMRect trigger = _element(
        '.neubrutalism-time-picker-trigger',
      ).getBoundingClientRect();
      expect(bounds.width, lessThanOrEqualTo(trigger.width + 1));
      expect(bounds.left, greaterThanOrEqualTo(4));
      expect(bounds.right, lessThanOrEqualTo(web.window.innerWidth - 4));
      expect(bounds.top, closeTo(trigger.bottom + 8, 1));
      expect(popup.scrollWidth, lessThanOrEqualTo(popup.clientWidth));
      for (final String column in <String>['hour', 'minute']) {
        final web.HTMLElement list = _element(
          '[data-arcane-time-column="$column"]',
        );
        final web.HTMLElement selected =
            list.querySelector('[aria-pressed="true"]')! as web.HTMLElement;
        final web.DOMRect listBounds = list.getBoundingClientRect();
        final web.DOMRect selectedBounds = selected.getBoundingClientRect();
        expect(list.scrollTop, greaterThan(0));
        expect(selectedBounds.top, greaterThanOrEqualTo(listBounds.top - 1));
        expect(
          selectedBounds.bottom,
          lessThanOrEqualTo(listBounds.bottom + 1),
          reason:
              '$column selection: scroll ${list.scrollTop}/'
              '${list.scrollHeight}, viewport ${list.clientHeight}, '
              'offset ${selected.offsetTop}, height ${selected.offsetHeight}',
        );
        expect(selectedBounds.height, greaterThanOrEqualTo(44));
      }
      popup.dispatchEvent(
        web.KeyboardEvent(
          'keydown',
          web.KeyboardEventInit(key: 'Escape', bubbles: true),
        ),
      );
      await _settle();
    });

    testClient('${variant.name} time picker dismissal keeps hydrated state', (
      ClientTester tester,
    ) async {
      final List<TimeOfDay?> changes = <TimeOfDay?>[];
      _pump(tester, variant, changes);
      await _settle();
      final web.HTMLElement trigger = _element(
        '.neubrutalism-time-picker-trigger',
      );
      trigger.focus();
      await _click('.neubrutalism-time-picker-trigger');
      final web.HTMLElement popup = _element(
        '.neubrutalism-time-picker-dropdown',
      );
      expect(popup.getAttribute('data-arcane-state'), 'open');
      expect(trigger.getAttribute('aria-expanded'), 'true');
      expect(popup.contains(web.document.activeElement), isTrue);
      popup.dispatchEvent(
        web.KeyboardEvent(
          'keydown',
          web.KeyboardEventInit(key: 'Escape', bubbles: true),
        ),
      );
      await _settle();
      expect(popup.getAttribute('data-arcane-state'), 'closed');
      expect(popup.hasAttribute('hidden'), isTrue);
      expect(web.document.activeElement, trigger);
      expect(changes, isEmpty);

      await _click('.neubrutalism-time-picker-trigger');
      expect(popup.getAttribute('data-arcane-state'), 'open');
      await _click('[data-arcane-time-column="hour"] button:nth-child(3)');
      expect(changes, isEmpty, reason: 'Selection is pending until Confirm.');
      await _click('#outside');
      expect(popup.getAttribute('data-arcane-state'), 'closed');
      await _click('.neubrutalism-time-picker-trigger');
      expect(
        _element(
          '[data-arcane-time-column="hour"] [aria-pressed="true"]',
        ).textContent,
        '11',
        reason: 'Outside dismissal cancels the pending hour.',
      );
      await _click('[data-arcane-time-column="minute"] button:nth-child(6)');
      await _click(
        '.neubrutalism-time-picker-dropdown button[data-variant="primary"]',
      );
      expect(changes, <TimeOfDay?>[const TimeOfDay(hour: 23, minute: 5)]);
      expect(popup.getAttribute('data-arcane-state'), 'closed');
      expect(web.document.activeElement, trigger);
    });
  }
}
