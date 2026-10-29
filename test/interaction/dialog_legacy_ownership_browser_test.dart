@TestOn('browser')
library;

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/core/interaction/runtime/runtime.dart';
import 'package:arcane_jaspr/util/interactivity/scripts/dialog/modal_scripts.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart' show EventCallback;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

class _DialogProbe {
  const _DialogProbe._();

  static web.HTMLElement element(String selector) =>
      web.document.querySelector(selector)! as web.HTMLElement;

  static void bindScripts() {
    web.document.head!.appendChild(
      web.HTMLScriptElement()..text = arcaneInteractivityRuntimeJs,
    );
    web.document.head!.appendChild(
      web.HTMLScriptElement()
        ..text = '(function() { ${ModalScripts.code}\nbindDialogs(); })();',
    );
  }

  static void key(String key, {bool shift = false}) {
    web.document.activeElement!.dispatchEvent(
      web.KeyboardEvent(
        'keydown',
        web.KeyboardEventInit(
          key: key,
          shiftKey: shift,
          bubbles: true,
          cancelable: true,
        ),
      ),
    );
  }
}

class _DialogHarness extends StatefulWidget {
  final ArcaneStylesheet stylesheet;

  const _DialogHarness({required this.stylesheet});

  @override
  State<_DialogHarness> createState() => _DialogHarnessState();
}

class _DialogHarnessState extends State<_DialogHarness> {
  bool _open = false;
  Brightness _brightness = Brightness.light;

  @override
  Widget build(BuildContext context) => ArcaneApp(
    stylesheet: widget.stylesheet,
    brightness: _brightness,
    includeFallbackScripts: false,
    home: Column(
      children: <Widget>[
        dom.button(
          id: 'review',
          events: <String, EventCallback>{
            'click': (_) => setState(() => _open = true),
          },
          const <Widget>[Text('Review plan')],
        ),
        dom.button(
          id: 'theme',
          events: <String, EventCallback>{
            'click': (_) => setState(() => _brightness = Brightness.dark),
          },
          const <Widget>[Text('Dark mode')],
        ),
        ArcaneDialog(
          id: 'booking',
          isOpen: _open,
          title: 'Review plan',
          onClose: () => setState(() => _open = false),
          children: const <Widget>[Text('Your workshop details')],
          actions: const <Widget>[
            dom.button(id: 'confirm', <Widget>[Text('Add to plan')]),
          ],
        ),
      ],
    ),
  );
}

void main() {
  for (final ArcaneStylesheet stylesheet in <ArcaneStylesheet>[
    const NeubrutalismStylesheet(),
    const ShadcnStylesheet(),
  ]) {
    testClient('${stylesheet.id} rapid reopen survives legacy close timers', (
      ClientTester tester,
    ) async {
      tester.pumpComponent(_DialogHarness(stylesheet: stylesheet));
      await pumpEventQueue();
      _DialogProbe.bindScripts();
      _DialogProbe.element('#review').focus();
      _DialogProbe.element('#review').click();
      await pumpEventQueue();
      final web.HTMLElement surface = _DialogProbe.element(
        '[data-arcane-surface="dialog"]',
      );
      expect(surface.getAttribute('data-arcane-state'), 'open');

      _DialogProbe.key('Escape');
      await pumpEventQueue(times: 1);
      expect(surface.getAttribute('data-arcane-state'), 'closed');
      _DialogProbe.element('#theme').click();
      await pumpEventQueue(times: 1);
      _DialogProbe.element('#review').focus();
      _DialogProbe.element('#review').click();
      await pumpEventQueue(times: 1);
      await Future<void>.delayed(const Duration(milliseconds: 250));

      final web.HTMLElement dialog = _DialogProbe.element('[role="dialog"]');
      expect(surface.getAttribute('data-arcane-state'), 'open');
      expect(surface.hasAttribute('hidden'), isFalse);
      expect(dialog.getBoundingClientRect().height, greaterThan(0));
      expect(web.window.getComputedStyle(dialog).opacity, '1');
      dialog.focus();
      _DialogProbe.key('Tab', shift: true);
      await pumpEventQueue();
      expect(surface.contains(web.document.activeElement), isTrue);
      expect(web.document.activeElement!.tagName, 'BUTTON');
      _DialogProbe.key('Escape');
      await pumpEventQueue();
      expect(surface.getAttribute('data-arcane-state'), 'closed');
      await Future<void>.delayed(const Duration(milliseconds: 250));
      expect(web.document.activeElement, _DialogProbe.element('#review'));
    });
  }

  testClient('standalone legacy dialogs still close with Escape', (
    ClientTester tester,
  ) async {
    tester.pumpComponent(
      const dom.div(
        id: 'legacy-dialog',
        attributes: <String, String>{'role': 'dialog', 'tabindex': '-1'},
        <Widget>[Text('Legacy dialog')],
      ),
    );
    await pumpEventQueue();
    _DialogProbe.bindScripts();
    final web.HTMLElement dialog = _DialogProbe.element('#legacy-dialog');
    dialog.focus();
    _DialogProbe.key('Escape');
    await Future<void>.delayed(const Duration(milliseconds: 200));
    expect(web.window.getComputedStyle(dialog).display, 'none');
  });
}
