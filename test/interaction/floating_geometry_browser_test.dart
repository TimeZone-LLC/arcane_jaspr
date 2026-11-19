@TestOn('browser')
library;

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/core/interaction/runtime/runtime.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart' as jaspr;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

Future<void> _settle() async {
  await pumpEventQueue();
  await Future<void>.delayed(const Duration(milliseconds: 30));
}

web.HTMLElement _element(String selector) =>
    web.document.querySelector(selector)! as web.HTMLElement;

void main() {
  for (final FloatingPosition position in <FloatingPosition>[
    FloatingPosition.top,
    FloatingPosition.bottom,
    FloatingPosition.left,
    FloatingPosition.right,
    FloatingPosition.topEnd,
    FloatingPosition.bottomEnd,
  ]) {
    testClient('floating panel follows its $position anchor', (
      ClientTester tester,
    ) async {
      tester.pumpComponent(_frame(position: position));
      web.document.head!.appendChild(
        web.HTMLScriptElement()..text = arcaneInteractivityRuntimeJs,
      );
      await _settle();
      final web.HTMLElement panel = _element('.arcane-floating-content');
      final String originalTransform = panel.style.transform;
      final String originalBottom = panel.style.bottom;
      final String originalRight = panel.style.right;
      _element('#anchor-trigger').click();
      await _settle();
      final web.DOMRect anchor = _element(
        '[data-arcane-anchor-id]',
      ).getBoundingClientRect();
      final web.DOMRect rect = panel.getBoundingClientRect();
      expect(panel.hasAttribute('hidden'), isFalse);
      switch (position) {
        case FloatingPosition.top:
        case FloatingPosition.topEnd:
          expect(rect.bottom, closeTo(anchor.top - 8, 1));
        case FloatingPosition.bottom:
        case FloatingPosition.bottomEnd:
          expect(rect.top, closeTo(anchor.bottom + 8, 1));
        case FloatingPosition.left:
          expect(rect.right, closeTo(anchor.left - 8, 1));
        case FloatingPosition.right:
          expect(rect.left, closeTo(anchor.right + 8, 1));
        default:
          fail('Unexpected test position');
      }
      if (position == FloatingPosition.left ||
          position == FloatingPosition.right) {
        expect(
          rect.top + rect.height / 2,
          closeTo(anchor.top + anchor.height / 2, 1),
        );
      } else if (position == FloatingPosition.topEnd ||
          position == FloatingPosition.bottomEnd) {
        expect(rect.right, closeTo(anchor.right, 1));
      } else {
        expect(
          rect.left + rect.width / 2,
          closeTo(anchor.left + anchor.width / 2, 1),
        );
      }
      panel.dispatchEvent(
        web.KeyboardEvent(
          'keydown',
          web.KeyboardEventInit(key: 'Escape', bubbles: true),
        ),
      );
      await _settle();
      expect(panel.hasAttribute('hidden'), isTrue);
      expect(panel.style.transform, originalTransform);
      expect(panel.style.bottom, originalBottom);
      expect(panel.style.right, originalRight);
    });
  }

  for (final bool plainText in <bool>[true, false]) {
    testClient(
      'focused ${plainText ? 'tooltip' : 'hovercard'} stays centered',
      (ClientTester tester) async {
        tester.pumpComponent(
          _frame(
            position: FloatingPosition.top,
            hover: true,
            plainText: plainText,
          ),
        );
        web.document.head!.appendChild(
          web.HTMLScriptElement()..text = arcaneInteractivityRuntimeJs,
        );
        await _settle();
        _element('#anchor-trigger').focus();
        await _settle();
        final web.HTMLElement panel = _element('.arcane-floating-content');
        expect(panel.hasAttribute('hidden'), isFalse);
        final web.DOMRect anchor = _element(
          '[data-arcane-anchor-id]',
        ).getBoundingClientRect();
        final web.DOMRect rect = panel.getBoundingClientRect();
        expect(rect.bottom, closeTo(anchor.top - 8, 1));
        expect(
          rect.left + rect.width / 2,
          closeTo(anchor.left + anchor.width / 2, 1),
        );
      },
    );
  }

  testClient('anchoring preserves an explicit transform', (
    ClientTester tester,
  ) async {
    tester.pumpComponent(
      _frame(
        position: FloatingPosition.bottom,
        styles: const ArcaneStyleData(transformCustom: 'translateX(7px)'),
      ),
    );
    web.document.head!.appendChild(
      web.HTMLScriptElement()..text = arcaneInteractivityRuntimeJs,
    );
    await _settle();
    _element('#anchor-trigger').click();
    await _settle();
    final web.HTMLElement panel = _element('.arcane-floating-content');
    expect(panel.style.transform, 'translateX(7px)');
    final web.DOMRect anchor = _element(
      '[data-arcane-anchor-id]',
    ).getBoundingClientRect();
    final web.DOMRect rect = panel.getBoundingClientRect();
    expect(
      rect.left + rect.width / 2,
      closeTo(anchor.left + anchor.width / 2 + 7, 1),
    );
  });
}

Widget _frame({
  required FloatingPosition position,
  ArcaneStyleData? styles,
  bool hover = false,
  bool plainText = false,
}) => ArcaneApp(
  stylesheet: const ShadcnStylesheet(),
  includeFallbackScripts: false,
  home: dom.div(
    styles: const dom.Styles(
      raw: <String, String>{'margin': '200px 250px', 'width': '100px'},
    ),
    <Widget>[
      const jaspr.Component.element(
        tag: 'style',
        children: <jaspr.Component>[
          dom.RawText('''
.arcane-floating-content {
  animation: none !important;
  transition: none !important;
}
'''),
        ],
      ),
      ArcaneHoverCard(
        id: 'geometry-popover',
        trigger: const dom.button(id: 'anchor-trigger', <Widget>[
          Text('Open preview'),
        ]),
        content: plainText ? null : const Text('Preview details'),
        textContent: plainText ? 'Preview details' : null,
        triggerType: hover ? FloatingTrigger.hover : FloatingTrigger.click,
        position: position,
        styles: styles,
      ),
    ],
  ),
);
