@TestOn('browser')
library;

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
  await Future<void>.delayed(const Duration(milliseconds: 300));
}

Future<void> _click(String selector) async {
  _element(selector).click();
  await _settle();
}

Future<void> _key(web.Element target, String key) async {
  (target as web.HTMLElement).focus();
  target.dispatchEvent(
    web.KeyboardEvent(
      'keydown',
      web.KeyboardEventInit(key: key, bubbles: true, cancelable: true),
    ),
  );
  await _settle();
}

void _expectCorners(String selector, bool rounded) {
  final web.CSSStyleDeclaration style = web.window.getComputedStyle(
    _element(selector),
  );
  final List<String> corners = <String>[
    style.borderTopLeftRadius,
    style.borderTopRightRadius,
    style.borderBottomLeftRadius,
    style.borderBottomRightRadius,
  ];
  for (final String corner in corners) {
    expect(
      double.parse(corner.replaceAll(RegExp(r'px|%'), '')),
      rounded ? greaterThan(0) : isZero,
      reason: '$selector follows the selected corner style.',
    );
  }
}

void main() {
  for (final NeubrutalismVariant variant in NeubrutalismVariant.values) {
    for (final Brightness brightness in Brightness.values) {
      testClient(
        '${variant.name} ${brightness.name} changes corners without replacing head or form state',
        (ClientTester tester) async {
          bool rounded = false;
          bool dialogOpen = false;
          bool enabled = false;
          String draft = '';
          String choice = 'riso';
          int menuActions = 0;
          tester.pumpComponent(
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) =>
                  ArcaneApp(
                    stylesheet: NeubrutalismStylesheet(
                      variant: variant,
                      rounded: rounded,
                    ),
                    brightness: brightness,
                    includeFallbackScripts: false,
                    home: dom.div(<Widget>[
                      Button(
                        id: 'corners',
                        label: 'Change corners',
                        onPressed: () => setState(() => rounded = !rounded),
                      ),
                      const Card(classes: 'corner-card', child: Text('Proof')),
                      const Card(
                        classes: 'explicit-square',
                        borderRadius: Radius.none,
                        child: Text('Square by request'),
                      ),
                      const dom.div(id: 'circle-avatar', <Widget>[
                        ArcaneAvatar.circle(initials: 'PC'),
                      ]),
                      const dom.div(id: 'square-avatar', <Widget>[
                        ArcaneAvatar.square(initials: 'PC'),
                      ]),
                      const ArcaneSkeleton.circle(),
                      TextInput(
                        id: 'draft',
                        name: 'draft',
                        label: 'Print title',
                        value: draft,
                        onChanged: (String value) => draft = value,
                      ),
                      ArcaneSelect(
                        id: 'stock',
                        name: 'stock',
                        label: 'Paper stock',
                        value: choice,
                        onChanged: (String value) => choice = value,
                        options: const <ArcaneSelectOption>[
                          ArcaneSelectOption(value: 'riso', label: 'Riso'),
                          ArcaneSelectOption(value: 'zine', label: 'Zine'),
                        ],
                      ),
                      ArcaneToggleSwitch(
                        id: 'proof',
                        value: enabled,
                        label: 'Keep a proof',
                        onChanged: (bool value) =>
                            setState(() => enabled = value),
                      ),
                      ArcaneDropdownMenu(
                        id: 'edition-menu',
                        trigger: const Button(
                          id: 'menu-trigger',
                          label: 'Edition actions',
                        ),
                        items: <ArcaneMenuItem>[
                          MenuItemAction(
                            label: 'Save edition',
                            onSelect: () => menuActions++,
                          ),
                        ],
                      ),
                      Button(
                        id: 'open-dialog',
                        label: 'Open proof',
                        onPressed: () => setState(() => dialogOpen = true),
                      ),
                      ArcaneDialog(
                        id: 'proof-dialog',
                        isOpen: dialogOpen,
                        title: 'Proof preview',
                        onClose: () => setState(() => dialogOpen = false),
                        child: const Text('The saved proof.'),
                      ),
                    ]),
                  ),
            ),
          );
          web.document.head!.appendChild(
            web.HTMLScriptElement()..text = arcaneInteractivityRuntimeJs,
          );
          await _settle();
          final String? initialHead = web.document.head!.textContent;
          final web.Element? initialStyle = web.document.head!.querySelector(
            'style',
          );
          final web.HTMLInputElement input =
              _element('#draft') as web.HTMLInputElement;
          input.value = 'Moonlit edition';
          input.dispatchEvent(web.Event('input', web.EventInit(bubbles: true)));
          await _settle();
          await _key(_element('#stock'), 'End');
          await _key(web.document.activeElement!, 'Enter');
          expect(choice, 'zine');
          await _click('[role="switch"]');

          int pass = 0;
          for (final bool expectedRounded in <bool>[false, true, false]) {
            if (pass > 0) await _click('#corners');
            expect(web.document.head!.textContent, initialHead);
            expect(web.document.head!.querySelector('style'), initialStyle);
            expect(_element('#draft'), input);
            expect(input.value, 'Moonlit edition');
            expect(
              (_element('select[data-arcane-select-backing="stock"]')
                      as web.HTMLSelectElement)
                  .value,
              'zine',
            );
            expect(_element('#stock').getAttribute('role'), 'combobox');
            expect(
              _element('[role="switch"]').getAttribute('aria-checked'),
              'true',
            );
            expect(_element('label[for="draft"]').textContent, 'Print title');
            for (final String selector in <String>[
              '#corners',
              '.corner-card',
              '#draft',
              '#stock',
              '[role="switch"]',
              '.neubrutalism-toggle-switch-thumb',
            ]) {
              _expectCorners(selector, expectedRounded);
            }
            _expectCorners('.explicit-square', false);
            _expectCorners('#square-avatar .neubrutalism-avatar-inner', false);
            for (final String selector in <String>[
              '#circle-avatar .neubrutalism-avatar-inner',
              '[data-arcane-intrinsic-shape="skeleton-circle"]',
            ]) {
              expect(
                web.window.getComputedStyle(_element(selector)).borderRadius,
                '50%',
              );
            }
            input.focus();
            expect(web.window.getComputedStyle(input).outlineStyle, 'solid');

            await _key(_element('#stock'), ' ');
            _expectCorners('#stock-listbox', expectedRounded);
            await _key(web.document.activeElement!, 'Escape');
            expect(
              web.document.activeElement,
              _element('#stock'),
              reason: 'Select Escape restores its trigger.',
            );

            _element('#menu-trigger').focus();
            await _click('#menu-trigger');
            _expectCorners('#edition-menu', expectedRounded);
            expect(
              web.document.activeElement!.getAttribute('role'),
              'menuitem',
            );
            await _key(web.document.activeElement!, 'Escape');
            expect(
              web.document.activeElement,
              _element('#menu-trigger'),
              reason: 'Menu Escape restores its trigger.',
            );

            _element('#open-dialog').focus();
            await _click('#open-dialog');
            _expectCorners('.neubrutalism-dialog', expectedRounded);
            expect(
              _element('[role="dialog"]').getAttribute('aria-modal'),
              'true',
            );
            await _key(web.document.activeElement!, 'Escape');
            expect(dialogOpen, isFalse);
            expect(
              web.document.activeElement,
              _element('#open-dialog'),
              reason: 'Dialog Escape restores its trigger.',
            );
            pass++;
          }
          await _key(_element('#menu-trigger'), 'ArrowDown');
          expect(web.document.activeElement!.getAttribute('role'), 'menuitem');
          await _key(web.document.activeElement!, 'Enter');
          expect(menuActions, 1);
          expect(
            web.document.activeElement,
            _element('#menu-trigger'),
            reason: 'Keyboard-opened menu restores the nested trigger button.',
          );
        },
      );
    }
  }
}
