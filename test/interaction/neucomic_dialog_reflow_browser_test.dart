@TestOn('browser')
library;

// ignore_for_file: prefer_final_locals

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

void main() {
  tearDown(() {
    (web.document.documentElement! as web.HTMLElement).style.removeProperty(
      'font-size',
    );
  });

  for (Brightness brightness in Brightness.values) {
    for (int width in <int>[320, 390]) {
      testClient(
        'NeuComic dialog titles fit enlarged text at $width in ${brightness.name}',
        (ClientTester tester) async {
          (web.document.documentElement! as web.HTMLElement).style.fontSize =
              '200%';
          tester.pumpComponent(
            ArcaneApp(
              stylesheet: const NeubrutalismStylesheet(
                variant: NeubrutalismVariant.neuComic,
              ),
              brightness: brightness,
              home: ArcaneDialog(
                id: 'membership-chooser',
                isOpen: true,
                title: 'Choose your membership',
                maxWidth: width - 96,
                onClose: () {},
                child: const Text(
                  'Choose a monthly, annual, or lifetime plan.',
                ),
              ),
            ),
          );
          await pumpEventQueue();
          await Future<void>.delayed(const Duration(milliseconds: 150));
          web.HTMLElement title =
              web.document.querySelector('.neubrutalism-dialog-title')!
                  as web.HTMLElement;
          expect(title.scrollWidth, lessThanOrEqualTo(title.clientWidth + 1));
          expect(title.scrollHeight, lessThanOrEqualTo(title.clientHeight + 1));
          web.Element overlay = web.document.querySelector(
            '.neubrutalism-dialog-overlay',
          )!;
          expect(web.window.getComputedStyle(overlay).paddingLeft, '24px');
          expect(
            web.window.getComputedStyle(title).fontSize,
            '57.6px',
            reason: 'The heading wraps while retaining the enlarged text size',
          );
        },
      );
    }
  }
}
