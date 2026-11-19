@TestOn('browser')
library;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:arcane_jaspr/core/props/slot_counter_props.dart';
import 'package:arcane_jaspr_neubrutalism/src/renderers/slot_counter.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

void main() {
  late JSFunction originalMatchMedia;
  late web.EventTarget preference;
  bool hidden = false;

  setUp(() {
    hidden = false;
    final JSObject descriptor = JSObject();
    descriptor.setProperty('configurable'.toJS, true.toJS);
    descriptor.setProperty('get'.toJS, (() => hidden).toJS);
    globalContext
        .getProperty<JSObject>('Object'.toJS)
        .callMethod<JSAny?>(
          'defineProperty'.toJS,
          web.document,
          'hidden'.toJS,
          descriptor,
        );
    originalMatchMedia = web.window.getProperty<JSFunction>('matchMedia'.toJS);
    preference = web.EventTarget();
    preference.setProperty('matches'.toJS, true.toJS);
    web.window.setProperty(
      'matchMedia'.toJS,
      ((JSString query) => preference).toJS,
    );
  });

  tearDown(() {
    web.window.setProperty('matchMedia'.toJS, originalMatchMedia);
    web.document.delete('hidden'.toJS);
  });

  void setReduced(bool reduced) {
    preference.setProperty('matches'.toJS, reduced.toJS);
    preference.dispatchEvent(web.Event('change'));
  }

  void setHidden(bool value) {
    hidden = value;
    web.document.dispatchEvent(web.Event('visibilitychange'));
  }

  testClient(
    'counter timers follow preference, visibility, props and disposal',
    (ClientTester tester) async {
      final List<int> updates = <int>[];
      bool present = true;
      bool autoStart = true;
      int? fixedValue;
      late StateSetter update;
      tester.pumpComponent(
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            update = setState;
            return present
                ? NeubrutalismSlotCounter(
                    SlotCounterProps(
                      minValue: 5,
                      maxValue: 5,
                      fixedValue: fixedValue,
                      autoStart: autoStart,
                      basePauseSeconds: 0,
                      randomPauseSeconds: 0,
                      spinDurationMs: 80,
                      spinIntervalMs: 10,
                      onValueChange: updates.add,
                    ),
                  )
                : const dom.div(<Component>[]);
          },
        ),
      );
      await Future<void>.delayed(const Duration(milliseconds: 120));
      expect(updates, isEmpty, reason: 'Reduced motion starts with no timers.');

      setReduced(false);
      await Future<void>.delayed(const Duration(milliseconds: 30));
      expect(
        web.document
            .querySelector('.neubrutalism-slot-counter')!
            .getAttribute('data-state'),
        'spinning',
      );
      setReduced(true);
      await pumpEventQueue();
      expect(updates, <int>[5], reason: 'An interrupted spin settles once.');
      await Future<void>.delayed(const Duration(milliseconds: 120));
      expect(updates, <int>[5]);

      setReduced(false);
      await Future<void>.delayed(const Duration(milliseconds: 120));
      expect(updates.length, greaterThan(1));
      setHidden(true);
      final int hiddenUpdates = updates.length;
      await Future<void>.delayed(const Duration(milliseconds: 120));
      expect(updates.length, hiddenUpdates);
      setHidden(false);
      await Future<void>.delayed(const Duration(milliseconds: 120));
      expect(updates.length, greaterThan(hiddenUpdates));

      update(() => fixedValue = 12);
      await pumpEventQueue();
      final int fixedUpdates = updates.length;
      expect(
        web.document.querySelector('.neubrutalism-slot-counter')!.textContent,
        '12',
      );
      await Future<void>.delayed(const Duration(milliseconds: 120));
      expect(updates.length, fixedUpdates);

      update(() {
        fixedValue = null;
        autoStart = false;
      });
      await pumpEventQueue();
      setHidden(true);
      setHidden(false);
      await Future<void>.delayed(const Duration(milliseconds: 120));
      expect(
        updates.length,
        fixedUpdates,
        reason: 'Visibility cannot override autoStart:false.',
      );

      update(() => autoStart = true);
      await Future<void>.delayed(const Duration(milliseconds: 120));
      expect(updates.length, greaterThan(fixedUpdates));
      update(() => present = false);
      await pumpEventQueue();
      final int removedUpdates = updates.length;
      setReduced(true);
      setReduced(false);
      await Future<void>.delayed(const Duration(milliseconds: 120));
      expect(updates.length, removedUpdates);
    },
  );
}
