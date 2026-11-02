@TestOn('browser')
library;

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/core/interaction/runtime/runtime.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

web.HTMLElement _element(String selector) =>
    web.document.querySelector(selector)! as web.HTMLElement;

void _key(web.HTMLElement target, String key) => target.dispatchEvent(
  web.KeyboardEvent(
    'keydown',
    web.KeyboardEventInit(key: key, bubbles: true, cancelable: true),
  ),
);

void main() {
  setUpAll(() {
    web.document.head!.appendChild(
      web.HTMLScriptElement()..text = arcaneInteractivityRuntimeJs,
    );
  });

  for (final Brightness brightness in Brightness.values) {
    testClient('red black ${brightness.name} controls retain visible focus', (
      ClientTester tester,
    ) async {
      web.document.documentElement!.setAttribute('class', brightness.name);
      tester.pumpComponent(
        ArcaneApp(
          stylesheet: const NeubrutalismStylesheet(
            theme: NeubrutalismTheme.redBlack,
          ),
          brightness: brightness,
          includeFallbackScripts: false,
          home: const Column(
            children: <Widget>[
              TextInput(id: 'weight', label: 'Weight', value: '40'),
              TextInput(
                id: 'affixed-weight',
                label: 'Weight percent',
                value: '40',
                suffix: Text('%'),
              ),
              ArcaneSelect(
                id: 'activity',
                label: 'Activity',
                value: 'boss',
                options: <ArcaneSelectOption>[
                  ArcaneSelectOption(label: 'Boss', value: 'boss'),
                  ArcaneSelectOption(label: 'Dungeons', value: 'dungeons'),
                ],
              ),
              ArcaneSlider(id: 'damage', label: 'Damage', value: 40, step: 1),
              ArcaneTabs(
                tabs: <ArcaneTabItem>[
                  ArcaneTabItem(label: 'Equipment', content: Text('Equipment')),
                  ArcaneTabItem(label: 'Skills', content: Text('Skills')),
                ],
              ),
            ],
          ),
        ),
      );
      await pumpEventQueue();
      final web.CSSStyleDeclaration selectStyle = web.window.getComputedStyle(
        _element('#activity'),
      );
      expect(selectStyle.borderTopWidth, '3px');
      expect(
        selectStyle.backgroundColor,
        brightness == Brightness.dark
            ? 'rgb(27, 25, 25)'
            : 'rgb(255, 255, 255)',
      );
      for (final String selector in <String>[
        '#weight',
        '#activity',
        '[role="slider"]',
        '[role="tab"]',
      ]) {
        final web.HTMLElement control = _element(selector);
        control.focus();
        await pumpEventQueue();
        expect(web.document.activeElement, control);
        final web.CSSStyleDeclaration style = web.window.getComputedStyle(
          control,
        );
        expect(style.outlineStyle, 'solid', reason: selector);
        expect(style.outlineWidth, '3px', reason: selector);
      }
      final web.HTMLElement affixed = _element('#affixed-weight');
      affixed.focus();
      await pumpEventQueue();
      final web.HTMLElement shell =
          affixed.closest('[data-arcane-field-shell="true"]')!
              as web.HTMLElement;
      expect(web.window.getComputedStyle(shell).outlineStyle, 'solid');
      expect(web.window.getComputedStyle(shell).outlineWidth, '3px');
      expect(web.window.getComputedStyle(affixed).outlineStyle, 'none');
    });
  }

  for (final int viewportWidth in <int>[320, 390]) {
    for (final bool fill in <bool>[false, true]) {
      testClient('tabs fit a $viewportWidth pixel frame with fill=$fill', (
        ClientTester tester,
      ) async {
        web.document.documentElement!.setAttribute('class', 'dark');
        tester.pumpComponent(
          ArcaneApp(
            stylesheet: const NeubrutalismStylesheet(
              theme: NeubrutalismTheme.redBlack,
            ),
            includeFallbackScripts: false,
            home: dom.div(
              id: 'mobile-tab-frame',
              styles: dom.Styles(
                raw: <String, String>{
                  'width': '${viewportWidth}px',
                  'box-sizing': 'border-box',
                  'padding': '0 42px',
                },
              ),
              <Widget>[
                ArcaneTabs(
                  fill: fill,
                  tabs: const <ArcaneTabItem>[
                    ArcaneTabItem(
                      label: 'Equipment',
                      content: Text('Equipment'),
                    ),
                    ArcaneTabItem(label: 'Skills', content: Text('Skills')),
                    ArcaneTabItem(label: 'Paragon', content: Text('Paragon')),
                    ArcaneTabItem(label: 'Rotation', content: Text('Rotation')),
                    ArcaneTabItem(
                      label: 'Sources',
                      content: Text('Source details'),
                    ),
                    ArcaneTabItem(
                      label: 'VeryLongUnbrokenReferenceNameForNarrowPanels',
                      content: Text('Reference details'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
        await pumpEventQueue();
        final web.HTMLElement frame = _element('#mobile-tab-frame');
        final web.HTMLElement list = _element('[role="tablist"]');
        final web.DOMRect frameBounds = frame.getBoundingClientRect();
        final web.DOMRect listBounds = list.getBoundingClientRect();
        expect(listBounds.width, lessThanOrEqualTo(viewportWidth - 84 + 1));
        expect(listBounds.right, lessThanOrEqualTo(frameBounds.right - 42 + 1));
        expect(frame.scrollWidth, lessThanOrEqualTo(frame.clientWidth));
        final web.NodeList tabs = list.querySelectorAll('[role="tab"]');
        final web.HTMLElement first = tabs.item(0)! as web.HTMLElement;
        final web.HTMLElement last =
            tabs.item(tabs.length - 1)! as web.HTMLElement;
        expect(
          last.getBoundingClientRect().top,
          greaterThan(first.getBoundingClientRect().top),
        );
        for (int index = 0; index < tabs.length; index++) {
          final web.HTMLElement tab = tabs.item(index)! as web.HTMLElement;
          final web.DOMRect bounds = tab.getBoundingClientRect();
          expect(bounds.left, greaterThanOrEqualTo(listBounds.left));
          expect(bounds.right, lessThanOrEqualTo(listBounds.right + 1));
          expect(tab.scrollWidth, lessThanOrEqualTo(tab.clientWidth));
        }
        last.focus();
        await pumpEventQueue();
        expect(web.document.activeElement, last);
        expect(web.window.getComputedStyle(last).outlineStyle, 'solid');
        expect(web.window.getComputedStyle(list).overflowX, 'visible');
        last.click();
        await pumpEventQueue();
        expect(
          _element('.neubrutalism-tabs-content').textContent,
          'Reference details',
        );
        expect(
          _element('[role="tab"][aria-selected="true"]').textContent,
          'VeryLongUnbrokenReferenceNameForNarrowPanels',
        );
      });
    }
  }

  testClient(
    'tall dialogs retain visible headers, actions and keyboard focus',
    (ClientTester tester) async {
      web.document.documentElement!.setAttribute('class', 'dark');
      int closes = 0;
      tester.pumpComponent(
        ArcaneApp(
          stylesheet: const NeubrutalismStylesheet(
            theme: NeubrutalismTheme.redBlack,
          ),
          includeFallbackScripts: false,
          home: ArcaneDialog(
            id: 'tall-form',
            isOpen: true,
            title: 'Edit choices',
            onClose: () => closes++,
            children: <Widget>[
              for (int index = 0; index < 40; index++)
                TextInput(id: 'choice-$index', label: 'Choice $index'),
            ],
            actions: <Widget>[
              const dom.button(id: 'cancel-edit', <Widget>[Text('Cancel')]),
              const dom.button(id: 'apply-edit', <Widget>[
                Text('Apply choices'),
              ]),
            ],
          ),
        ),
      );
      await pumpEventQueue();
      final web.HTMLElement dialog = _element('[role="dialog"]');
      final web.HTMLElement content = _element('.neubrutalism-dialog-content');
      final web.HTMLElement title = _element('.neubrutalism-dialog-title');
      final web.HTMLElement actions = _element('.neubrutalism-dialog-actions');
      final web.DOMRect dialogBounds = dialog.getBoundingClientRect();
      expect(dialogBounds.top, greaterThanOrEqualTo(16));
      expect(
        dialogBounds.bottom,
        lessThanOrEqualTo(web.window.innerHeight - 16),
      );
      expect(content.scrollHeight, greaterThan(content.clientHeight));
      final double titleTop = title.getBoundingClientRect().top;
      final double actionsTop = actions.getBoundingClientRect().top;
      for (final String id in <String>['choice-39', 'choice-0']) {
        final web.HTMLElement field = _element('#$id');
        field.focus();
        await pumpEventQueue();
        final web.DOMRect fieldBounds = field.getBoundingClientRect();
        final web.DOMRect contentBounds = content.getBoundingClientRect();
        expect(web.document.activeElement, field);
        expect(fieldBounds.top, greaterThanOrEqualTo(contentBounds.top));
        expect(fieldBounds.bottom, lessThanOrEqualTo(contentBounds.bottom));
        expect(title.getBoundingClientRect().top, closeTo(titleTop, 1));
        expect(actions.getBoundingClientRect().top, closeTo(actionsTop, 1));
      }
      final web.HTMLElement apply = _element('#apply-edit');
      apply.focus();
      _key(apply, 'Tab');
      await pumpEventQueue();
      expect(
        web.document.activeElement,
        _element('.neubrutalism-dialog-close'),
      );
      _key(_element('.neubrutalism-dialog-close'), 'Escape');
      await pumpEventQueue();
      expect(closes, 1);
    },
  );

  testClient('red black slider keyboard change reaches the application', (
    ClientTester tester,
  ) async {
    web.document.documentElement!.setAttribute('class', 'dark');
    final List<double> changes = <double>[];
    tester.pumpComponent(
      ArcaneApp(
        stylesheet: const NeubrutalismStylesheet(
          theme: NeubrutalismTheme.redBlack,
        ),
        includeFallbackScripts: false,
        home: ArcaneSlider(
          id: 'priority',
          label: 'Priority',
          value: 40,
          step: 5,
          onChanged: changes.add,
        ),
      ),
    );
    await pumpEventQueue();
    final web.HTMLElement thumb = _element('[role="slider"]');
    thumb.focus();
    _key(thumb, 'ArrowRight');
    await pumpEventQueue();
    expect(changes, <double>[45]);
    expect(thumb.getAttribute('aria-valuenow'), '45');
  });
}
