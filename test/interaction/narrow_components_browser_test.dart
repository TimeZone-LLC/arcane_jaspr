@TestOn('browser')
library;

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/component/card/flexi_cards.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

Widget _frame(Widget child) => ArcaneApp(
  stylesheet: const ShadcnStylesheet(),
  includeFallbackScripts: false,
  home: dom.div(
    id: 'narrow-frame',
    styles: const dom.Styles(
      raw: <String, String>{
        'width': '235px',
        'display': 'flex',
        'justify-content': 'center',
        'margin': '10px',
      },
    ),
    <Widget>[child],
  ),
);

void _expectContained(String selector) {
  final web.DOMRect bounds = web.document
      .getElementById('narrow-frame')!
      .getBoundingClientRect();
  final web.NodeList elements = web.document.querySelectorAll(selector);
  expect(elements.length, greaterThan(0));
  for (int index = 0; index < elements.length; index++) {
    final web.Element element = elements.item(index)! as web.Element;
    final web.DOMRect rect = element.getBoundingClientRect();
    expect(rect.left, greaterThanOrEqualTo(bounds.left - 1));
    expect(rect.right, lessThanOrEqualTo(bounds.right + 1));
    expect(element.scrollWidth, lessThanOrEqualTo(element.clientWidth + 1));
  }
}

void main() {
  for (final bool weekNumbers in <bool>[false, true]) {
    testClient('calendar fits a narrow panel with week numbers $weekNumbers', (
      ClientTester tester,
    ) async {
      final List<DateTime?> selections = <DateTime?>[];
      tester.pumpComponent(
        _frame(
          ArcaneCalendar(
            selected: DateTime(2026, 4, 24),
            showWeekNumbers: weekNumbers,
            onSelect: selections.add,
          ),
        ),
      );
      await pumpEventQueue();
      _expectContained('.arcane-calendar-grid, .arcane-calendar-day');
      final web.HTMLElement saturday =
          web.document.querySelector('[data-arcane-value="2026-04-04"]')!
              as web.HTMLElement;
      final web.DOMRect rect = saturday.getBoundingClientRect();
      expect(
        web.document.elementFromPoint(
          rect.left + rect.width / 2,
          rect.top + rect.height / 2,
        ),
        same(saturday),
      );
      saturday.click();
      await pumpEventQueue();
      expect(selections, <DateTime?>[DateTime(2026, 4, 4)]);
    });
  }

  testClient('pagination keeps every action inside a narrow panel', (
    ClientTester tester,
  ) async {
    final List<int> pages = <int>[];
    tester.pumpComponent(
      _frame(
        ArcanePagination(
          currentPage: 2,
          totalPages: 8,
          onPageChange: pages.add,
        ),
      ),
    );
    await pumpEventQueue();
    _expectContained('.arcane-pagination-content, .arcane-pagination-link');
    (web.document.querySelector('[aria-label="Go to last page"]')!
            as web.HTMLElement)
        .click();
    await pumpEventQueue();
    expect(pages, <int>[8]);
  });

  testClient('both flexi card variants wrap and expand with their panel', (
    ClientTester tester,
  ) async {
    int selections = 0;
    final List<FlexiCardItem> items = <FlexiCardItem>[
      for (final String title in <String>['Structure', 'Details'])
        FlexiCardItem(
          icon: ArcaneIcon.box(),
          shortText: title,
          longText: 'Hover, focus, or select a card to explore its content.',
          onTap: () => selections++,
        ),
    ];
    tester.pumpComponent(
      _frame(
        Column(
          children: <Widget>[
            ArcaneFlexiCards(items: items),
            ArcaneFlexiCardsSimple(items: items),
          ],
        ),
      ),
    );
    await pumpEventQueue();
    _expectContained('.arcane-flexi-card, .arcane-flexi-card-simple');
    final web.NodeList cards = web.document.querySelectorAll(
      '.arcane-flexi-card',
    );
    final web.HTMLElement first = cards.item(0)! as web.HTMLElement;
    final web.HTMLElement second = cards.item(1)! as web.HTMLElement;
    expect(
      second.getBoundingClientRect().top,
      greaterThan(first.getBoundingClientRect().bottom),
    );
    first.click();
    await pumpEventQueue();
    expect(selections, 1);
    (web.document.getElementById('narrow-frame')! as web.HTMLElement)
            .style
            .width =
        '640px';
    await pumpEventQueue();
    _expectContained('.arcane-flexi-card, .arcane-flexi-card-simple');
    expect(
      second.getBoundingClientRect().top,
      closeTo(first.getBoundingClientRect().top, 1),
    );
  });
}
