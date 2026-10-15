@TestOn('browser')
library;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:arcane_jaspr/core/props/slot_counter_props.dart';
import 'package:arcane_jaspr_shadcn/src/motion/motion_observer.dart';
import 'package:arcane_jaspr_shadcn/src/renderers/slot_counter.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

class _CounterHost extends StatefulComponent {
  final Component child;
  final void Function(_CounterHostState) onCreated;

  const _CounterHost({required this.child, required this.onCreated});

  @override
  State<_CounterHost> createState() {
    final _CounterHostState state = _CounterHostState();
    onCreated(state);
    return state;
  }
}

class _CounterHostState extends State<_CounterHost> {
  bool visible = true;

  void removeCounter() => setState(() => visible = false);

  @override
  Component build(BuildContext context) =>
      visible ? component.child : const dom.div(<Component>[]);
}

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
    preference.setProperty('matches'.toJS, false.toJS);
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

  test('motion observer reports preferences and releases its listener', () {
    final List<bool> changes = <bool>[];
    final MotionObserver observer = MotionObserver(changes.add);
    expect(observer.canAnimate, isTrue);
    setReduced(true);
    expect(observer.canAnimate, isFalse);
    expect(changes, <bool>[false]);
    setReduced(false);
    expect(changes, <bool>[false, true]);
    setHidden(true);
    expect(observer.canAnimate, isFalse);
    expect(changes, <bool>[false, true, false]);
    setHidden(false);
    expect(observer.canAnimate, isTrue);
    expect(changes, <bool>[false, true, false, true]);
    observer.dispose();
    setReduced(true);
    setHidden(true);
    expect(changes, <bool>[false, true, false, true]);
  });

  testClient('slot counter settles, resumes, and cancels pending work', (
    ClientTester tester,
  ) async {
    final List<int> updates = <int>[];
    late _CounterHostState host;
    tester.pumpComponent(
      _CounterHost(
        onCreated: (_CounterHostState state) => host = state,
        child: ShadcnSlotCounter(
          SlotCounterProps(
            minValue: 10,
            maxValue: 99,
            basePauseSeconds: 0,
            randomPauseSeconds: 0,
            spinDurationMs: 100,
            spinIntervalMs: 10,
            onValueChange: updates.add,
          ),
        ),
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 35));
    setReduced(true);
    await pumpEventQueue();
    final int settledUpdates = updates.length;
    final String? settledText = web.document
        .querySelector('.arcane-slot-counter')!
        .textContent;
    expect(settledUpdates, greaterThan(0));
    await Future<void>.delayed(const Duration(milliseconds: 160));
    expect(updates.length, settledUpdates);
    expect(
      web.document.querySelector('.arcane-slot-counter')!.textContent,
      settledText,
    );
    setReduced(false);
    await Future<void>.delayed(const Duration(milliseconds: 160));
    expect(updates.length, greaterThan(settledUpdates));
    setHidden(true);
    final int hiddenUpdates = updates.length;
    await Future<void>.delayed(const Duration(milliseconds: 160));
    expect(updates.length, hiddenUpdates);
    setHidden(false);
    await Future<void>.delayed(const Duration(milliseconds: 160));
    expect(updates.length, greaterThan(hiddenUpdates));
    host.removeCounter();
    await pumpEventQueue();
    final int removedUpdates = updates.length;
    await Future<void>.delayed(const Duration(milliseconds: 160));
    expect(updates.length, removedUpdates);
  });
}
