@TestOn('browser')
library;

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neon/arcane_jaspr_neon.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:arcane_jaspr_win95/arcane_jaspr_win95.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

const List<(String, ArcaneStylesheet)> _themes = <(String, ArcaneStylesheet)>[
  ('shadcn', ShadcnStylesheet()),
  ('neon', NeonStylesheet()),
  ('neubrutalism', NeubrutalismStylesheet()),
  ('win95', Win95Stylesheet()),
];

web.HTMLElement _element(String id) =>
    web.document.getElementById(id)! as web.HTMLElement;

Widget _wrapFixture({required bool bounded}) => SizedBox(
  width: 200,
  height: bounded ? 100 : null,
  child: Wrap(
    direction: Axis.vertical,
    spacing: 4,
    runSpacing: 6,
    children: <Widget>[
      for (final int index in <int>[0, 1, 2, 3])
        dom.div(
          id: 'wrap-item-$index',
          styles: const dom.Styles(
            raw: <String, String>{
              'width': '50px',
              'height': '40px',
              'flex-shrink': '0',
            },
          ),
          <Widget>[Text('Item $index')],
        ),
    ],
  ),
);

void main() {
  for (final (String name, ArcaneStylesheet theme) in _themes) {
    testClient('$name vertical Wrap forms columns within a bounded height', (
      ClientTester tester,
    ) async {
      tester.pumpComponent(
        ArcaneThemeProvider(
          stylesheet: theme,
          child: _wrapFixture(bounded: true),
        ),
      );
      await pumpEventQueue();

      final web.DOMRect first = _element('wrap-item-0').getBoundingClientRect();
      final web.DOMRect second = _element(
        'wrap-item-1',
      ).getBoundingClientRect();
      final web.DOMRect third = _element('wrap-item-2').getBoundingClientRect();
      final web.HTMLElement wrap =
          _element('wrap-item-0').parentElement! as web.HTMLElement;

      expect(wrap.getBoundingClientRect().height, closeTo(100, 0.1));
      expect(second.y - first.y, closeTo(44, 0.1));
      expect(second.x, closeTo(first.x, 0.1));
      expect(third.x - first.x, closeTo(56, 0.1));
      expect(third.y, closeTo(first.y, 0.1));
    });

    testClient('$name vertical Wrap stays content-sized without a height', (
      ClientTester tester,
    ) async {
      tester.pumpComponent(
        ArcaneThemeProvider(
          stylesheet: theme,
          child: _wrapFixture(bounded: false),
        ),
      );
      await pumpEventQueue();

      final web.DOMRect first = _element('wrap-item-0').getBoundingClientRect();
      final web.DOMRect fourth = _element(
        'wrap-item-3',
      ).getBoundingClientRect();
      final web.HTMLElement wrap =
          _element('wrap-item-0').parentElement! as web.HTMLElement;

      expect(wrap.getBoundingClientRect().height, closeTo(172, 0.1));
      expect(fourth.x, closeTo(first.x, 0.1));
      expect(fourth.y - first.y, closeTo(132, 0.1));
    });
  }

  for (final TextOverflow? overflow in <TextOverflow?>[
    null,
    TextOverflow.clip,
    TextOverflow.ellipsis,
    TextOverflow.visible,
  ]) {
    testClient(
      'softWrap false constrains ${overflow?.name ?? 'default'} text',
      (ClientTester tester) async {
        tester.pumpComponent(
          dom.div(
            id: 'text-frame',
            styles: const dom.Styles(raw: <String, String>{'width': '140px'}),
            <Widget>[
              Text(
                'Long text must remain on one line within the available width.',
                softWrap: false,
                overflow: overflow,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        );
        await pumpEventQueue();

        final web.HTMLElement text =
            _element('text-frame').firstElementChild! as web.HTMLElement;
        final web.CSSStyleDeclaration style = web.window.getComputedStyle(text);
        expect(text.clientWidth, 140);
        expect(text.clientHeight, 24);
        expect(text.scrollWidth, greaterThan(text.clientWidth));
        expect(style.whiteSpace, 'nowrap');
        expect(
          style.overflow,
          overflow == TextOverflow.visible ? 'visible' : 'hidden',
        );
        expect(
          style.textOverflow,
          overflow == TextOverflow.ellipsis ? 'ellipsis' : 'clip',
        );
      },
    );
  }
}
