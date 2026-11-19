@TestOn('browser')
library;

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:arcane_jaspr_neubrutalism/src/renderers/toast.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

web.HTMLElement _element(String selector) =>
    web.document.querySelector(selector)! as web.HTMLElement;

Future<void> _mount(
  ClientTester tester,
  NeubrutalismVariant variant,
  Brightness brightness,
  int width,
  Widget child,
) async {
  web.document.documentElement!.className = brightness.name;
  tester.pumpComponent(
    ArcaneApp(
      stylesheet: NeubrutalismStylesheet(variant: variant),
      brightness: brightness,
      includeFallbackScripts: false,
      home: dom.div(
        id: 'geometry-frame',
        styles: dom.Styles(
          raw: <String, String>{
            'position': 'relative',
            'width': '${width}px',
            'height': '600px',
            // A transformed ancestor provides a bounded viewport for fixed UI.
            'transform': 'translateZ(0)',
          },
        ),
        <Widget>[
          const dom.RawText(
            '<style>#geometry-frame * { animation: none !important; '
            'transition: none !important; }</style>',
          ),
          child,
        ],
      ),
    ),
  );
  await pumpEventQueue();
}

void _expectInside(String selector, String parent, {double margin = 0}) {
  final web.HTMLElement element = _element(selector);
  final web.DOMRect bounds = element.getBoundingClientRect();
  final web.DOMRect frame = _element(parent).getBoundingClientRect();
  expect(bounds.width, greaterThan(0), reason: '$selector is visible');
  expect(
    bounds.left,
    greaterThanOrEqualTo(frame.left + margin - 1),
    reason: '$selector keeps its left inset',
  );
  expect(
    bounds.right,
    lessThanOrEqualTo(frame.right - margin + 1),
    reason: '$selector keeps its right inset',
  );
  expect(
    bounds.top,
    greaterThanOrEqualTo(frame.top - 1),
    reason: '$selector stays below the top edge',
  );
  expect(
    bounds.bottom,
    lessThanOrEqualTo(frame.bottom + 1),
    reason: '$selector stays above the bottom edge',
  );
  expect(
    element.scrollWidth,
    lessThanOrEqualTo(element.clientWidth + 1),
    reason: '$selector content fits horizontally',
  );
}

void main() {
  for (final NeubrutalismVariant variant in NeubrutalismVariant.values) {
    for (final Brightness brightness in Brightness.values) {
      for (final int width in <int>[320, 390]) {
        final String appearance = '${variant.name} ${brightness.name} $width';
        testClient('$appearance drawers fit every edge', (
          ClientTester tester,
        ) async {
          for (final DrawerPosition position in DrawerPosition.values) {
            int closes = 0;
            await _mount(
              tester,
              variant,
              brightness,
              width,
              ArcaneDrawer(
                isOpen: true,
                position: position,
                size: DrawerSize.lg,
                header: const Text('Review the final edition before printing'),
                child: const Text(
                  'Export: final_edition_print_ready_registration_marks.pdf',
                ),
                footer: const Button(label: 'Continue reviewing'),
                onClose: () => closes++,
              ),
            );
            _expectInside('.neubrutalism-drawer', '#geometry-frame');
            for (final String part in <String>[
              'header',
              'content',
              'footer',
              'close',
            ]) {
              _expectInside(
                '.neubrutalism-drawer-$part',
                '.neubrutalism-drawer',
              );
            }
            _element('.neubrutalism-drawer-close').click();
            expect(closes, 1);
          }
        });

        testClient(
          '$appearance toast positions retain their configured inset',
          (ClientTester tester) async {
            for (final ToastPosition position in ToastPosition.values) {
              for (final double offset in <double>[8, 20, 32]) {
                int actions = 0;
                int dismisses = 0;
                await _mount(
                  tester,
                  variant,
                  brightness,
                  width,
                  NeubrutalismToastContainer(
                    ToastContainerProps(
                      position: position,
                      offset: offset,
                      toasts: <ToastProps>[
                        ToastProps(
                          title: 'Your edition is ready',
                          message:
                              'final_edition_registration_marks.pdf exported',
                          variant: ToastVariant.success,
                          action: ToastAction(
                            label: 'Review exported artwork',
                            onPressed: () => actions++,
                          ),
                          onDismiss: () => dismisses++,
                        ),
                      ],
                    ),
                  ),
                );
                _expectInside(
                  '.neubrutalism-toast',
                  '#geometry-frame',
                  margin: offset,
                );
                _expectInside(
                  '.neubrutalism-toast-content',
                  '.neubrutalism-toast',
                );
                _expectInside(
                  '.neubrutalism-toast-action',
                  '.neubrutalism-toast-content',
                );
                _expectInside(
                  '.neubrutalism-toast-dismiss',
                  '.neubrutalism-toast',
                );
                _element('.neubrutalism-toast-action').click();
                _element('.neubrutalism-toast-dismiss').click();
                expect(actions, 1);
                expect(dismisses, 1);
              }
            }
          },
        );

        testClient('$appearance command search keeps a safe gutter', (
          ClientTester tester,
        ) async {
          await _mount(
            tester,
            variant,
            brightness,
            width,
            ArcaneCommand(
              isOpen: true,
              groups: <CommandGroup>[
                CommandGroup(
                  heading: 'Editions',
                  items: <CommandItem>[
                    for (int index = 0; index < 20; index++)
                      CommandItem(
                        label: 'Open final edition artwork number $index',
                        shortcut: 'Cmd+K',
                      ),
                  ],
                ),
              ],
            ),
          );
          _element('.neubrutalism-command-input').focus();
          _expectInside(
            '.neubrutalism-command-dialog',
            '#geometry-frame',
            margin: 12,
          );
          for (final String selector in <String>[
            '.arcane-command-search-row',
            '.neubrutalism-command-input',
            '.neubrutalism-command-list',
            '.neubrutalism-command-item',
            '.neubrutalism-command-dialog > div:last-child',
          ]) {
            _expectInside(selector, '.neubrutalism-command-dialog');
          }
          expect(
            _element('.neubrutalism-command-list').scrollHeight,
            greaterThan(_element('.neubrutalism-command-list').clientHeight),
          );
        });
      }
    }
  }
}
