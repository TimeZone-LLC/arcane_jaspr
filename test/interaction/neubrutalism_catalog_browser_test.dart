@TestOn('browser')
library;

import 'dart:math' as math;

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/component/card/flexi_cards.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

web.HTMLElement _element(String selector) =>
    web.document.querySelector(selector)! as web.HTMLElement;

web.CSSStyleDeclaration _style(String selector) =>
    web.window.getComputedStyle(_element(selector));

double _contrast(String foreground, String background) {
  double luminance(String color) {
    final List<double> channels = RegExp(r'\d+(?:\.\d+)?')
        .allMatches(color)
        .take(3)
        .map((Match match) => double.parse(match.group(0)!) / 255)
        .map(
          (double value) => value <= 0.04045
              ? value / 12.92
              : math.pow((value + 0.055) / 1.055, 2.4).toDouble(),
        )
        .toList();
    return channels[0] * .2126 + channels[1] * .7152 + channels[2] * .0722;
  }

  final double front = luminance(foreground);
  final double back = luminance(background);
  return (math.max(front, back) + .05) / (math.min(front, back) + .05);
}

void _pump(
  ClientTester tester,
  NeubrutalismVariant variant,
  Brightness brightness,
  List<Widget> children,
) {
  web.document.documentElement!.className = brightness.name;
  tester.pumpComponent(
    ArcaneApp(
      stylesheet: NeubrutalismStylesheet(variant: variant),
      brightness: brightness,
      includeFallbackScripts: false,
      home: dom.div(children),
    ),
  );
}

void main() {
  for (final NeubrutalismVariant variant in NeubrutalismVariant.values) {
    for (final Brightness brightness in Brightness.values) {
      final String mode = '${variant.name} ${brightness.name}';

      testClient('$mode small accents and custom card frames stay readable', (
        ClientTester tester,
      ) async {
        _pump(tester, variant, brightness, const <Widget>[
          ArcaneAvatar(initials: 'PC'),
          ArcaneKbd('Ctrl'),
          ArcaneBreadcrumbs(
            items: <BreadcrumbItem>[
              BreadcrumbItem(label: 'Studio'),
              BreadcrumbItem(label: 'Edition'),
            ],
          ),
          FeatureCard(
            title: 'Riso',
            description: 'Two inks',
            ctaText: 'Choose',
            showCta: true,
          ),
          dom.div(id: 'custom-card', <Widget>[
            FeatureCard(
              title: 'Custom',
              description: 'Keep the explicit frame',
              decoration: ArcaneDecoration(
                border: '5px solid #345678',
                elevation: Elevation.none,
              ),
            ),
          ]),
        ]);
        await pumpEventQueue();
        expect(
          _contrast(
            _style('.neubrutalism-avatar-inner span').color,
            _style('.neubrutalism-avatar-inner').backgroundColor,
          ),
          greaterThanOrEqualTo(4.5),
        );
        for (final String selector in <String>[
          '.neubrutalism-kbd',
          '.neubrutalism-breadcrumb-current',
          '.neubrutalism-feature-card-cta',
        ]) {
          expect(
            _contrast(
              _style(selector).color,
              _style('#arcane-root').backgroundColor,
            ),
            greaterThanOrEqualTo(4.5),
            reason: selector,
          );
        }
        expect(_style('.neubrutalism-feature-card').borderTopWidth, '3px');
        final web.CSSStyleDeclaration custom = _style('#custom-card > div');
        expect(custom.borderTopWidth, '5px');
        expect(custom.borderTopColor, 'rgb(52, 86, 120)');
        expect(custom.boxShadow, 'none');
      });

      testClient('$mode pagination and flexible cards reflow at 248 pixels', (
        ClientTester tester,
      ) async {
        _pump(tester, variant, brightness, <Widget>[
          dom.div(
            id: 'narrow-layout',
            styles: const dom.Styles(raw: <String, String>{'width': '248px'}),
            <Widget>[
              const ArcanePagination(currentPage: 3, totalPages: 12),
              ArcaneFlexiCards(
                minCardWidth: '160px',
                items: <FlexiCardItem>[
                  for (final String label in <String>['Layer', 'Fold'])
                    FlexiCardItem(
                      icon: ArcaneIcon.plus(),
                      shortText: label,
                      longText: 'A print technique',
                    ),
                ],
              ),
              ArcaneFlexiCardsSimple(
                items: <FlexiCardItem>[
                  FlexiCardItem(
                    icon: ArcaneIcon.plus(),
                    shortText: 'Fold',
                    longText: 'A print technique',
                  ),
                ],
              ),
            ],
          ),
        ]);
        await pumpEventQueue();
        final web.HTMLElement frame = _element('#narrow-layout');
        expect(frame.scrollWidth, lessThanOrEqualTo(frame.clientWidth));
      });

      testClient('$mode command search placeholder stays readable', (
        ClientTester tester,
      ) async {
        _pump(tester, variant, brightness, const <Widget>[
          ArcaneCommand(
            id: 'catalog-command',
            isOpen: true,
            groups: <CommandGroup>[],
          ),
        ]);
        await pumpEventQueue();
        final web.CSSStyleDeclaration placeholder = web.window.getComputedStyle(
          _element('.neubrutalism-command-input'),
          '::placeholder',
        );
        expect(
          _contrast(
            placeholder.color,
            _style('.neubrutalism-command-dialog').backgroundColor,
          ),
          greaterThanOrEqualTo(4.5),
        );
        expect(placeholder.opacity, '1');
      });

      testClient('$mode slider thumb and rail have visible boundaries', (
        ClientTester tester,
      ) async {
        _pump(tester, variant, brightness, const <Widget>[
          ArcaneSlider(value: 40, label: 'Ink coverage'),
        ]);
        await pumpEventQueue();
        for (final String selector in <String>[
          '.neubrutalism-slider-thumb',
          '.neubrutalism-slider-track',
        ]) {
          expect(
            _contrast(
              _style(selector).borderTopColor,
              _style('#arcane-root').backgroundColor,
            ),
            greaterThanOrEqualTo(3),
            reason: selector,
          );
        }
      });

      testClient('$mode table headers and selected rows stay readable', (
        ClientTester tester,
      ) async {
        _pump(tester, variant, brightness, <Widget>[
          DataTable<String>(
            items: const <String>['Cotton', 'Recycled'],
            columns: <DataColumn<String>>[
              DataColumn<String>(
                header: 'Paper stock',
                builder: (String item) => Text(item),
              ),
            ],
            selectable: true,
          ),
          const StaticTable(
            headers: <String>['Edition'],
            rows: <List<Widget>>[
              <Widget>[Text('Thirty copies')],
            ],
          ),
        ]);
        await pumpEventQueue();
        final web.CSSStyleDeclaration header = _style(
          '.neubrutalism-data-table-header th:last-child',
        );
        expect(
          _contrast(
            header.color,
            _style('.neubrutalism-data-table-header').backgroundColor,
          ),
          greaterThanOrEqualTo(4.5),
          reason: 'Column text on the accent header',
        );
        _element('.neubrutalism-data-table-body input').click();
        await pumpEventQueue();
        await Future<void>.delayed(const Duration(milliseconds: 200));
        expect(
          _contrast(
            _style('.neubrutalism-data-table-row.selected td:last-child').color,
            _style('.neubrutalism-data-table-row.selected').backgroundColor,
          ),
          greaterThanOrEqualTo(4.5),
          reason: 'Selected table row text on the accent fill',
        );
        if (variant == NeubrutalismVariant.neuComic) {
          expect(header.fontFamily, contains('Comic Neue'));
          expect(
            _style('.neubrutalism-static-table th').fontFamily,
            contains('Comic Neue'),
          );
        }
      });

      testClient(
        '$mode six digit entry fits narrow panels with a visible caret',
        (ClientTester tester) async {
          _pump(tester, variant, brightness, <Widget>[
            const dom.div(
              id: 'narrow',
              styles: dom.Styles(raw: <String, String>{'width': '248px'}),
              <Widget>[
                ArcaneOtpInput(
                  label: 'Verification code',
                  separator: '-',
                  separatorPosition: 3,
                ),
              ],
            ),
          ]);
          await pumpEventQueue();
          final web.HTMLElement panel = _element('#narrow');
          expect(panel.scrollWidth, lessThanOrEqualTo(panel.clientWidth));
          _element('.neubrutalism-otp-digit').focus();
          await pumpEventQueue();
          final web.CSSStyleDeclaration digit = _style(
            '.neubrutalism-otp-digit',
          );
          expect(
            _contrast(digit.caretColor, digit.backgroundColor),
            greaterThanOrEqualTo(3),
            reason: 'Caret must be visible on dark input paper',
          );
        },
      );
    }
  }
}
