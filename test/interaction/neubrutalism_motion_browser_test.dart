@TestOn('browser')
library;

import 'dart:js_interop';

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/core/interaction/runtime/runtime.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:arcane_jaspr_neubrutalism/src/renderers/floating.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

web.HTMLElement _element(String selector) =>
    web.document.querySelector(selector)! as web.HTMLElement;

web.CSSStyleDeclaration _style(String selector) =>
    web.window.getComputedStyle(_element(selector));

bool get _reduced =>
    web.window.matchMedia('(prefers-reduced-motion: reduce)').matches;

Future<void> _frame() async {
  await pumpEventQueue();
  await Future<void>.delayed(const Duration(milliseconds: 30));
}

void _pump(
  ClientTester tester,
  NeubrutalismVariant variant,
  List<Widget> children,
) {
  tester.pumpComponent(
    ArcaneApp(
      stylesheet: NeubrutalismStylesheet(variant: variant),
      brightness: Brightness.light,
      includeFallbackScripts: false,
      home: dom.div(
        styles: const dom.Styles(
          raw: <String, String>{'padding': '80px 240px'},
        ),
        children,
      ),
    ),
  );
  web.document.head!.appendChild(
    web.HTMLScriptElement()..text = arcaneInteractivityRuntimeJs,
  );
}

void main() {
  for (final NeubrutalismVariant variant in NeubrutalismVariant.values) {
    final String scenario =
        '${variant.name} ${_reduced ? 'reduced' : 'active'}';
    testClient('$scenario command palette uses shared surface motion', (
      ClientTester tester,
    ) async {
      _pump(tester, variant, <Widget>[
        dom.button(
          id: 'open-command',
          attributes: interactionAttrs(
            ArcaneInteraction.openCommand('motion-command'),
          ),
          const <Widget>[Text('Open command')],
        ),
        const ArcaneCommand(id: 'motion-command', groups: <CommandGroup>[]),
      ]);
      await _frame();
      _element('#open-command').click();
      expect(
        _style('.neubrutalism-command-overlay').animationName,
        _reduced ? 'none' : 'nb-scrim-enter',
      );
      expect(
        _style('.neubrutalism-command-dialog').animationName,
        _reduced ? 'none' : 'nb-surface-enter',
      );
      expect(
        _element('.neubrutalism-command-dialog').getAnimations().toDart,
        _reduced ? isEmpty : isNotEmpty,
      );
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(
        _element('.neubrutalism-command-dialog').getAnimations().toDart,
        isEmpty,
      );
      expect(_style('.neubrutalism-command-dialog').opacity, '1');
    });

    testClient('$scenario preserves explicit motion and static surfaces', (
      ClientTester tester,
    ) async {
      _pump(tester, variant, <Widget>[
        const Card(classes: 'static-card', child: Text('Printed content')),
        const ArcaneSkeleton(
          styles: ArcaneStyleData(animation: AnimationPreset.none),
        ),
        const ArcaneCheckbox(
          checked: true,
          disabled: true,
          label: 'Unavailable',
        ),
        Button(
          id: 'custom-motion',
          label: 'Keep authored motion',
          onPressed: () {},
          styles: const ArcaneStyleData(
            animation: AnimationPreset.none,
            transitionCustom: 'none',
            transformCustom: 'rotate(3deg)',
          ),
        ),
      ]);
      await _frame();
      for (final String selector in <String>[
        '.static-card',
        '.neubrutalism-skeleton',
        '[role="checkbox"]',
        '#custom-motion',
      ]) {
        expect(_element(selector).getAnimations().toDart, isEmpty);
      }
      _element('#custom-motion').focus();
      expect(_style('#custom-motion').transitionDuration, '0s');
      expect(_element('#custom-motion').style.transform, 'rotate(3deg)');
      expect(_style('#custom-motion').transform, isNot('none'));
    });

    testClient('$scenario animates only active loading indicators', (
      ClientTester tester,
    ) async {
      _pump(tester, variant, const <Widget>[
        ArcaneSkeleton(),
        ArcaneSkeleton(animate: false),
        ArcaneProgressBar(value: 0, indeterminate: true),
        ArcaneProgressBar(value: .5),
        ArcaneLoadingSpinner(),
        Text('Static content'),
      ]);
      await _frame();
      for (final String selector in <String>[
        '.neubrutalism-skeleton.animate',
        '.neubrutalism-progress-fill.indeterminate',
        '.neubrutalism-loading-spinner',
      ]) {
        expect(
          _element(selector).getAnimations().toDart,
          _reduced ? isEmpty : isNotEmpty,
          reason: '$selector must reflect the actual motion preference.',
        );
      }
      for (final String selector in <String>[
        '.neubrutalism-skeleton:not(.animate)',
        '.neubrutalism-progress-fill:not(.indeterminate)',
      ]) {
        expect(_element(selector).getAnimations().toDart, isEmpty);
      }
      expect(
        double.parse(_style('.neubrutalism-skeleton.animate').opacity),
        greaterThan(0),
      );
    });

    testClient('$scenario checks settle and keyboard focus stays visible', (
      ClientTester tester,
    ) async {
      _pump(tester, variant, const <Widget>[
        ArcaneCheckbox(id: 'check', label: 'Remember choice', checked: false),
        ArcaneToggleSwitch(id: 'switch', value: false, label: 'Notifications'),
      ]);
      await _frame();
      final web.HTMLElement checkbox = _element('[role="checkbox"]');
      checkbox.focus();
      checkbox.dispatchEvent(
        web.KeyboardEvent(
          'keydown',
          web.KeyboardEventInit(key: ' ', bubbles: true, cancelable: true),
        ),
      );
      await _frame();
      expect(checkbox.getAttribute('aria-checked'), 'true');
      expect(_style('[role="checkbox"]').outlineStyle, 'solid');
      expect(
        _style('[role="checkbox"]').animationName,
        _reduced ? 'none' : 'nb-mark-settle',
      );
      final web.HTMLElement toggle = _element('[role="switch"]');
      final web.HTMLElement thumb = _element(
        '.neubrutalism-toggle-switch-thumb',
      );
      toggle.focus();
      toggle.click();
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(toggle.getAttribute('aria-checked'), 'true');
      final web.DOMRect trackRect = toggle.getBoundingClientRect();
      final web.DOMRect thumbRect = thumb.getBoundingClientRect();
      expect(thumbRect.left, greaterThan(trackRect.left));
      expect(thumbRect.right, lessThan(trackRect.right));
      expect(checkbox.getAnimations().toDart, isEmpty);
      if (_reduced) {
        expect(
          _style('.neubrutalism-toggle-switch-thumb').transitionDuration,
          '0s',
        );
      }
    });

    testClient('$scenario disclosures animate only their opened content', (
      ClientTester tester,
    ) async {
      _pump(tester, variant, const <Widget>[
        ArcaneDisclosure(
          summary: Text('Read details'),
          child: Text('Revealed content'),
        ),
      ]);
      await _frame();
      expect(_style('.neubrutalism-disclosure-content').animationName, 'none');
      _element('summary').click();
      await _frame();
      expect(_element('details').hasAttribute('open'), isTrue);
      expect(
        _style('.neubrutalism-disclosure-content').animationName,
        _reduced ? 'none' : 'nb-content-enter',
      );
      _element('summary').click();
      await _frame();
      expect(_element('details').hasAttribute('open'), isFalse);
      expect(_style('.neubrutalism-disclosure-content').animationName, 'none');
    });

    testClient('$scenario floating motion preserves anchoring and close', (
      ClientTester tester,
    ) async {
      _pump(tester, variant, <Widget>[
        const NeubrutalismFloating(
          FloatingProps(
            id: 'motion-panel',
            position: FloatingPosition.bottom,
            triggerType: FloatingTrigger.click,
            trigger: dom.button(id: 'open', <Widget>[Text('Open options')]),
            content: dom.button(
              id: 'inside',
              styles: dom.Styles(
                raw: <String, String>{'pointer-events': 'auto'},
              ),
              <Widget>[Text('Choose')],
            ),
          ),
        ),
      ]);
      await _frame();
      final web.HTMLElement surface = _element(
        '[data-arcane-surface="popover"]',
      );
      final String originalTransform = surface.style.transform;
      _element('#open').focus();
      _element('#open').click();
      await _frame();
      expect(surface.getAttribute('data-arcane-state'), 'open');
      expect(
        web.window.getComputedStyle(surface).animationName,
        _reduced ? 'none' : 'nb-surface-enter',
      );
      expect(surface.getAnimations().toDart, _reduced ? isEmpty : isNotEmpty);
      await Future<void>.delayed(const Duration(milliseconds: 300));
      final web.DOMRect anchor = _element(
        '[data-arcane-anchor-id]',
      ).getBoundingClientRect();
      final web.DOMRect panel = surface.getBoundingClientRect();
      expect(panel.top, closeTo(anchor.bottom + 8, 1));
      expect(
        panel.left + panel.width / 2,
        closeTo(anchor.left + anchor.width / 2, 1),
      );
      _element('#inside').dispatchEvent(
        web.KeyboardEvent(
          'keydown',
          web.KeyboardEventInit(key: 'Escape', bubbles: true),
        ),
      );
      await pumpEventQueue(times: 1);
      expect(surface.getAttribute('aria-hidden'), 'true');
      expect(web.window.getComputedStyle(surface).pointerEvents, 'none');
      expect(_style('#inside').pointerEvents, 'none');
      expect(surface.hasAttribute('inert'), isTrue);
      _element('#open').focus();
      _element('#inside').focus();
      expect(web.document.activeElement?.id, 'open');
      await Future<void>.delayed(const Duration(milliseconds: 300));
      expect(surface.hasAttribute('hidden'), isTrue);
      expect(surface.style.transform, originalTransform);
      expect(web.document.activeElement?.id, 'open');

      _element('#open').click();
      await _frame();
      expect(surface.getAttribute('data-arcane-state'), 'open');
      expect(surface.hasAttribute('inert'), isFalse);
      expect(_style('#inside').pointerEvents, 'auto');
      _element('#inside').focus();
      expect(web.document.activeElement?.id, 'inside');
    });
  }
}
