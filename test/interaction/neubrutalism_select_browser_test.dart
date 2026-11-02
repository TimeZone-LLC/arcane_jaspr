@TestOn('browser')
library;

import 'dart:js_interop';

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/core/interaction/runtime/runtime.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart' show StatefulBuilder, StateSetter;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

web.HTMLElement _element(String selector) =>
    web.document.querySelector(selector)! as web.HTMLElement;

Future<void> _settle() async {
  await pumpEventQueue();
  await Future<void>.delayed(const Duration(milliseconds: 50));
  for (
    int frame = 0;
    frame < 30 && web.document.querySelector('.arcane-surface-closing') != null;
    frame++
  ) {
    await Future<void>.delayed(const Duration(milliseconds: 16));
  }
}

Future<void> _key(web.Element target, String key) async {
  target.dispatchEvent(
    web.KeyboardEvent(
      'keydown',
      web.KeyboardEventInit(key: key, bubbles: true, cancelable: true),
    ),
  );
  await _settle();
}

Future<void> _click(String selector) async {
  _element(selector).click();
  await _settle();
}

void main() {
  for (final NeubrutalismVariant variant in NeubrutalismVariant.values) {
    testClient(
      '${variant.name} select fits inside a dialog and restores its focus',
      (ClientTester tester) async {
        bool dialogOpen = true;
        int closes = 0;
        tester.pumpComponent(
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) => ArcaneApp(
              stylesheet: NeubrutalismStylesheet(variant: variant),
              includeFallbackScripts: false,
              home: ArcaneDialog(
                id: 'selection-dialog',
                isOpen: dialogOpen,
                title: 'Choose print',
                onClose: () => setState(() {
                  closes++;
                  dialogOpen = false;
                }),
                child: const ArcaneSelect(
                  id: 'in-dialog',
                  fullWidth: true,
                  value: 'art',
                  options: <ArcaneSelectOption>[
                    ArcaneSelectOption(value: 'art', label: 'Art'),
                    ArcaneSelectOption(
                      value: 'music',
                      label:
                          'A particularly long music and theatre workshop label that must remain inside the viewport',
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        web.document.head!.appendChild(
          web.HTMLScriptElement()..text = arcaneInteractivityRuntimeJs,
        );
        await _settle();
        await _click('#in-dialog');
        final web.HTMLElement surface = _element('#in-dialog-listbox');
        expect(surface.getAttribute('data-arcane-state'), 'open');
        final web.DOMRect rect = surface.getBoundingClientRect();
        final web.DOMRect anchor = _element(
          '#in-dialog',
        ).getBoundingClientRect();
        expect(rect.left, greaterThanOrEqualTo(0));
        expect(rect.right, lessThanOrEqualTo(web.window.innerWidth));
        expect(rect.top, greaterThanOrEqualTo(0));
        expect(rect.bottom, lessThanOrEqualTo(web.window.innerHeight));
        expect((rect.left - anchor.left).abs(), lessThan(10));
        await _key(web.document.activeElement!, 'Escape');
        expect(surface.getAttribute('data-arcane-state'), 'closed');
        expect(
          _element(
            '[data-arcane-id="selection-dialog"]',
          ).getAttribute('data-arcane-state'),
          'open',
        );
        expect(web.document.activeElement, _element('#in-dialog'));
        expect(closes, 0);
        await _click('#in-dialog');
        await _click('#in-dialog-listbox [data-arcane-value="music"]');
        expect(surface.getAttribute('data-arcane-state'), 'closed');
        expect(closes, 0);
        expect(
          _element('#in-dialog').textContent,
          contains('music and theatre'),
        );
        await _click('[data-arcane-id="selection-dialog"]');
        expect(closes, 1);
        expect(
          _element(
            '[data-arcane-id="selection-dialog"]',
          ).getAttribute('data-arcane-state'),
          'closed',
        );
      },
    );
    testClient(
      '${variant.name} select retains form semantics and controlled updates',
      (ClientTester tester) async {
        final List<String> changes = <String>[];
        String? value;
        tester.pumpComponent(
          StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) => ArcaneApp(
              stylesheet: NeubrutalismStylesheet(variant: variant),
              includeFallbackScripts: false,
              home: dom.form(id: 'form', <Widget>[
                ArcaneSelect(
                  id: 'category',
                  label: 'Category',
                  name: 'category',
                  placeholder: 'Choose a category',
                  required: true,
                  value: value,
                  onChanged: (String next) {
                    changes.add(next);
                    setState(() => value = next);
                  },
                  options: const <ArcaneSelectOption>[
                    ArcaneSelectOption(value: 'art', label: 'Art'),
                    ArcaneSelectOption(
                      value: 'books',
                      label: 'Books',
                      disabled: true,
                    ),
                    ArcaneSelectOption(value: 'music', label: 'Music'),
                    ArcaneSelectOption(value: 'theatre', label: 'Theatre'),
                  ],
                ),
                Button(
                  id: 'reset-value',
                  label: 'Reset category',
                  onPressed: () => setState(() => value = 'art'),
                ),
                const ArcaneSelect(
                  id: 'disabled',
                  disabled: true,
                  options: <ArcaneSelectOption>[
                    ArcaneSelectOption(value: 'art', label: 'Art'),
                  ],
                ),
                const ArcaneSelect(
                  id: 'styled',
                  styles: ArcaneStyleData(
                    heightCustom: '52px',
                    fontSizeCustom: '18px',
                    paddingStringCustom: '9px 18px',
                    backgroundCustom: '#f0ecff',
                    borderCustom: '5px solid #345678',
                  ),
                  options: <ArcaneSelectOption>[
                    ArcaneSelectOption(value: 'art', label: 'Art'),
                  ],
                ),
              ]),
            ),
          ),
        );
        web.document.head!.appendChild(
          web.HTMLScriptElement()..text = arcaneInteractivityRuntimeJs,
        );
        await _settle();
        final web.HTMLFormElement form =
            _element('#form') as web.HTMLFormElement;
        expect(form.checkValidity(), isFalse);
        expect(web.document.activeElement, _element('#category'));
        expect(_element('#category-error').textContent, isNotEmpty);
        expect(web.window.getComputedStyle(_element('select')).display, 'none');
        await _key(_element('#category'), 'ArrowDown');
        expect(_element('#category-listbox').hidden, isFalse);
        expect(web.document.activeElement?.textContent, 'Art');
        await _key(web.document.activeElement!, 'ArrowDown');
        expect(web.document.activeElement?.textContent, 'Music');
        await _key(web.document.activeElement!, 'End');
        expect(web.document.activeElement?.textContent, 'Theatre');
        await _key(web.document.activeElement!, 'Home');
        expect(web.document.activeElement?.textContent, 'Art');
        await _key(web.document.activeElement!, 'm');
        expect(web.document.activeElement?.textContent, 'Music');
        await _key(web.document.activeElement!, 'Enter');
        expect(changes, <String>['music']);
        expect(_element('#category').textContent, contains('Music'));
        expect(form.checkValidity(), isTrue);
        expect(_element('#category-error').hidden, isTrue);
        expect(
          (web.FormData(form).get('category') as JSString).toDart,
          'music',
        );
        expect(_element('#category-listbox').hidden, isTrue);
        expect(web.document.activeElement, _element('#category'));
        await _key(_element('#category'), ' ');
        expect(_element('#category-listbox').hidden, isFalse);
        await _key(web.document.activeElement!, 't');
        await _key(web.document.activeElement!, 'h');
        expect(web.document.activeElement?.textContent, 'Theatre');
        await _key(web.document.activeElement!, 'Escape');
        expect(_element('#category-listbox').hidden, isTrue);
        await _key(_element('#category'), 'Enter');
        expect(_element('#category-listbox').hidden, isFalse);
        await _click('body');
        expect(_element('#category-listbox').hidden, isTrue);
        await _click('#reset-value');
        expect(_element('#category').textContent, contains('Art'));
        expect((web.FormData(form).get('category') as JSString).toDart, 'art');
        await _click('#category');
        expect(
          _element(
            '[role="option"][data-arcane-value="art"]',
          ).getAttribute('aria-selected'),
          'true',
        );
        await _click('[role="option"][data-arcane-value="theatre"]');
        expect(changes, <String>['music', 'theatre']);
        await _click('#disabled');
        expect(_element('#disabled-listbox').hidden, isTrue);
        final web.CSSStyleDeclaration style = web.window.getComputedStyle(
          _element('#styled'),
        );
        expect(style.height, '52px');
        expect(style.fontSize, '18px');
        expect(style.paddingLeft, '18px');
        expect(style.backgroundColor, 'rgb(240, 236, 255)');
        expect(style.borderTopWidth, '5px');
        form.reset();
        await _settle();
        expect(
          _element('#category').textContent,
          contains('Choose a category'),
        );
        expect(changes, <String>['music', 'theatre']);
      },
    );
  }
}
