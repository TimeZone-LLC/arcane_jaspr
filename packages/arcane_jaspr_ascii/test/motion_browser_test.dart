@TestOn('browser')
library;

import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:arcane_jaspr_ascii/arcane_jaspr_ascii.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

@JS('Object.defineProperty')
external JSObject _defineProperty(
  JSObject target,
  JSString property,
  JSObject descriptor,
);

web.HTMLElement _element(String selector) =>
    web.document.querySelector(selector)! as web.HTMLElement;

Future<void> _settle() =>
    Future<void>.delayed(const Duration(milliseconds: 100));

Component _example({bool animated = true, bool belowFold = false}) => dom.div(
  <Component>[
    Component.element(
      tag: 'style',
      children: <Component>[
        Component.text(const AsciiStylesheet().componentCss),
      ],
    ),
    AsciiOrbit(
      animated: animated,
      duration: const Duration(seconds: 4),
      children: const <Component>[
        dom.a(<Component>[Component.text('Read guide')], href: '#guide'),
      ],
    ),
    const AsciiReveal(
      duration: Duration(seconds: 4),
      child: dom.a(<Component>[
        Component.text('More details'),
      ], href: '#details'),
    ),
  ],
  id: 'motion-parent',
  styles: dom.Styles(
    raw: <String, String>{
      'width': '320px',
      'margin': belowFold ? '200vh 40px 40px' : '40px',
    },
  ),
);

void main() {
  testClient('orbit pauses for live ancestor preference and keyboard focus', (
    ClientTester tester,
  ) async {
    bool animated = true;
    late StateSetter update;
    tester.pumpComponent(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          update = setState;
          return _example(animated: animated);
        },
      ),
    );
    await _settle();
    final web.HTMLElement orbit = _element('.ascii-orbit');
    final web.HTMLElement track = _element('.ascii-orbit-track');
    expect(orbit.getAttribute('data-ascii-motion-state'), 'running');
    expect(web.window.getComputedStyle(track).animationPlayState, 'running');
    _element('#motion-parent').setAttribute('data-ascii-motion', 'off');
    await _settle();
    expect(orbit.getAttribute('data-ascii-motion-state'), 'paused');
    expect(web.window.getComputedStyle(track).animationPlayState, 'paused');
    final String pausedTransform = web.window.getComputedStyle(track).transform;
    await _settle();
    expect(web.window.getComputedStyle(track).transform, pausedTransform);
    _element('#motion-parent').removeAttribute('data-ascii-motion');
    await _settle();
    expect(orbit.getAttribute('data-ascii-motion-state'), 'running');
    expect(
      web.window.getComputedStyle(track).transform,
      isNot(pausedTransform),
    );
    _element('.ascii-orbit a').focus();
    expect(web.window.getComputedStyle(track).animationPlayState, 'paused');
    expect(_element('.ascii-orbit a').closest('[aria-hidden="true"]'), isNull);
    _element('.ascii-orbit a').blur();
    update(() {
      animated = false;
    });
    await _settle();
    expect(orbit.getAttribute('data-ascii-motion-state'), 'paused');
    expect(web.window.getComputedStyle(track).animationPlayState, 'paused');
    expect(
      _element('.ascii-reveal').getAttribute('data-ascii-reveal'),
      'complete',
    );
    update(() {
      animated = true;
    });
    await _settle();
    expect(orbit.getAttribute('data-ascii-motion-state'), 'running');
    expect(web.window.getComputedStyle(track).animationPlayState, 'running');
  });

  testClient('offscreen orbit pauses and reveal enters once when visible', (
    ClientTester tester,
  ) async {
    tester.pumpComponent(_example(belowFold: true));
    await _settle();
    final web.HTMLElement orbit = _element('.ascii-orbit');
    final web.HTMLElement reveal = _element('.ascii-reveal');
    expect(orbit.getAttribute('data-ascii-motion-state'), 'paused');
    expect(reveal.getAttribute('data-ascii-reveal'), 'waiting');
    reveal.scrollIntoView();
    await _settle();
    expect(reveal.getAttribute('data-ascii-reveal'), 'entered');
    orbit.scrollIntoView();
    await _settle();
    expect(orbit.getAttribute('data-ascii-motion-state'), 'running');
    web.window.scrollTo(0.toJS, 0);
    await _settle();
    expect(orbit.getAttribute('data-ascii-motion-state'), 'paused');
    expect(reveal.getAttribute('data-ascii-reveal'), 'entered');
  });

  testClient('reduced motion changes live and unmount removes listeners', (
    ClientTester tester,
  ) async {
    final JSFunction original = web.window.getProperty<JSFunction>(
      'matchMedia'.toJS,
    );
    final web.EventTarget preference = web.EventTarget();
    preference.setProperty('matches'.toJS, false.toJS);
    web.window.setProperty(
      'matchMedia'.toJS,
      ((JSString query) => preference).toJS,
    );
    try {
      tester.pumpComponent(_example());
      await _settle();
      final web.HTMLElement orbit = _element('.ascii-orbit');
      final web.HTMLElement reveal = _element('.ascii-reveal');
      orbit.scrollIntoView();
      await _settle();
      expect(orbit.getAttribute('data-ascii-motion-state'), 'running');
      _defineProperty(
        web.document,
        'hidden'.toJS,
        <String, Object>{'configurable': true, 'value': true}.jsify()!
            as JSObject,
      );
      web.document.dispatchEvent(web.Event('visibilitychange'));
      expect(orbit.getAttribute('data-ascii-motion-state'), 'paused');
      web.document.delete('hidden'.toJS);
      web.document.dispatchEvent(web.Event('visibilitychange'));
      expect(orbit.getAttribute('data-ascii-motion-state'), 'running');
      preference.setProperty('matches'.toJS, true.toJS);
      preference.dispatchEvent(web.Event('change'));
      expect(orbit.getAttribute('data-ascii-motion-state'), 'paused');
      expect(reveal.getAttribute('data-ascii-reveal'), 'complete');
      preference.setProperty('matches'.toJS, false.toJS);
      preference.dispatchEvent(web.Event('change'));
      expect(orbit.getAttribute('data-ascii-motion-state'), 'running');
      expect(reveal.getAttribute('data-ascii-reveal'), 'complete');
      tester.binding.detachRootComponent();
      await _settle();
      orbit.setAttribute('data-ascii-motion-state', 'disposed');
      preference.setProperty('matches'.toJS, true.toJS);
      preference.dispatchEvent(web.Event('change'));
      web.document.dispatchEvent(web.Event('visibilitychange'));
      web.document.documentElement!.setAttribute('data-ascii-motion', 'off');
      await _settle();
      expect(orbit.getAttribute('data-ascii-motion-state'), 'disposed');
    } finally {
      web.window.setProperty('matchMedia'.toJS, original);
      web.document.delete('hidden'.toJS);
      web.document.documentElement!.removeAttribute('data-ascii-motion');
    }
  });
}
