@TestOn('browser')
library;

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart' as jaspr;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

void main() {
  for (final int width in <int>[235, 375]) {
    testClient('command input and hints fit a $width pixel panel', (
      ClientTester tester,
    ) async {
      tester.pumpComponent(
        ArcaneApp(
          stylesheet: const ShadcnStylesheet(),
          includeFallbackScripts: false,
          home: dom.div(
            styles: dom.Styles(
              raw: <String, String>{
                'position': 'relative',
                'width': '${width}px',
                'height': '360px',
              },
            ),
            <Widget>[
              const jaspr.Component.element(
                tag: 'style',
                children: <jaspr.Component>[
                  dom.RawText('''
.arcane-command-overlay {
  position: absolute !important;
  padding: 16px !important;
}
'''),
                ],
              ),
              const ArcaneCommand(
                isOpen: true,
                groups: <CommandGroup>[
                  CommandGroup(
                    heading: 'Navigation',
                    items: <CommandItem>[
                      CommandItem(
                        label: 'Open workspace configuration details',
                        shortcut: 'Cmd+,',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      await pumpEventQueue();
      final web.HTMLInputElement input =
          web.document.querySelector('.arcane-command-input')!
              as web.HTMLInputElement;
      input.focus();
      await pumpEventQueue();
      final web.HTMLElement dialog =
          web.document.querySelector('.arcane-command-dialog')!
              as web.HTMLElement;
      final web.DOMRect bounds = dialog.getBoundingClientRect();
      expect(dialog.scrollLeft, 0);
      expect(dialog.scrollWidth, lessThanOrEqualTo(dialog.clientWidth + 1));
      final web.NodeList content = dialog.querySelectorAll(
        '.arcane-command-input, .arcane-command-item > span, '
        '.arcane-command-dialog > div:last-child > div',
      );
      expect(content.length, greaterThanOrEqualTo(6));
      for (int index = 0; index < content.length; index++) {
        final web.Element element = content.item(index)! as web.Element;
        final web.DOMRect rect = element.getBoundingClientRect();
        expect(rect.left, greaterThanOrEqualTo(bounds.left));
        expect(rect.right, lessThanOrEqualTo(bounds.right));
        expect(element.scrollWidth, lessThanOrEqualTo(element.clientWidth + 1));
      }
    });
  }
}
