@TestOn('browser')
library;

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:arcane_jaspr_win95/arcane_jaspr_win95.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart' as jaspr;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

const List<(String, ArcaneStylesheet)> _themes = <(String, ArcaneStylesheet)>[
  ('shadcn', ShadcnStylesheet()),
  ('win95', Win95Stylesheet()),
];

const List<double> _ratios = <double>[0.5, 1, 2, 0.5, 1, 2];

Widget _fixture({
  required ArcaneStylesheet theme,
  required int width,
  required ArcaneGalleryLayout layout,
}) => ArcaneThemeProvider(
  stylesheet: theme,
  child: dom.div(
    id: 'arcane-root',
    classes: 'dark ${theme.themeClass} ${theme.bodyClass ?? ''}',
    <Widget>[
      jaspr.Component.element(
        tag: 'style',
        children: <jaspr.Component>[dom.RawText(theme.baseCss)],
      ),
      dom.div(
        id: 'gallery-frame',
        styles: dom.Styles(raw: <String, String>{'width': '${width}px'}),
        <Widget>[
          ArcaneGallery(
            id: 'geometry-gallery',
            ariaLabel: 'Artwork',
            layout: layout,
            minColumnWidth: 160,
            tiles: <ArcaneGalleryTile>[
              for (int index = 0; index < _ratios.length; index++)
                ArcaneGalleryTile(
                  media: ArcaneGalleryMedia(
                    aspectRatio: _ratios[index],
                    src:
                        'data:image/svg+xml,%3Csvg '
                        'xmlns="http://www.w3.org/2000/svg" '
                        'width="${100 * _ratios[index]}" height="100"/%3E',
                    alt: 'Artwork $index',
                  ),
                  mediaChild: index >= 3
                      ? const dom.div(
                          classes: 'absolute-media',
                          styles: dom.Styles(
                            raw: <String, String>{
                              'position': 'absolute',
                              'inset': '0',
                            },
                          ),
                          <Widget>[],
                        )
                      : null,
                  title: 'Artwork $index',
                  meta: 'Artist',
                  footer: Text('Details $index'),
                ),
            ],
          ),
        ],
      ),
    ],
  ),
);

web.Element _element(String selector) => web.document.querySelector(selector)!;

void _expectContained(web.DOMRect child, web.DOMRect parent) {
  expect(child.left, greaterThanOrEqualTo(parent.left - 1));
  expect(child.top, greaterThanOrEqualTo(parent.top - 1));
  expect(child.right, lessThanOrEqualTo(parent.right + 1));
  expect(child.bottom, lessThanOrEqualTo(parent.bottom + 1));
}

void main() {
  for (final (String name, ArcaneStylesheet theme) in _themes) {
    for (final int width in <int>[840, 320]) {
      testClient('$name grid reserves uniform artwork at ${width}px', (
        ClientTester tester,
      ) async {
        tester.pumpComponent(
          _fixture(
            theme: theme,
            width: width,
            layout: ArcaneGalleryLayout.grid,
          ),
        );
        await pumpEventQueue();

        final web.DOMRect gallery = _element(
          '#geometry-gallery',
        ).getBoundingClientRect();
        final web.DOMRect frame = _element(
          '#gallery-frame',
        ).getBoundingClientRect();
        _expectContained(gallery, frame);
        final web.NodeList tiles = web.document.querySelectorAll(
          '[data-arcane-gallery-item]',
        );
        expect(tiles.length, _ratios.length);
        final List<web.DOMRect> bounds = <web.DOMRect>[];
        double? firstMediaHeight;
        for (int index = 0; index < tiles.length; index++) {
          final web.Element tile = tiles.item(index)! as web.Element;
          final web.DOMRect tileBounds = tile.getBoundingClientRect();
          final web.Element media = tile.querySelector(
            '.$name-gallery-tile-media',
          )!;
          final web.DOMRect mediaBounds = media.getBoundingClientRect();
          expect(mediaBounds.height, greaterThan(100));
          expect(mediaBounds.height, closeTo(mediaBounds.width, 1));
          firstMediaHeight ??= mediaBounds.height;
          expect(mediaBounds.height, closeTo(firstMediaHeight, 1));
          _expectContained(tileBounds, gallery);
          _expectContained(mediaBounds, tileBounds);
          _expectContained(
            media.firstElementChild!.getBoundingClientRect(),
            mediaBounds,
          );

          final web.DOMRect footer = tile
              .querySelector('.$name-gallery-tile-footer')!
              .getBoundingClientRect();
          expect(footer.top, greaterThanOrEqualTo(mediaBounds.bottom - 1));
          _expectContained(footer, tileBounds);
          if (name == 'win95') {
            final web.DOMRect header = tile
                .querySelector('.win95-gallery-tile-header')!
                .getBoundingClientRect();
            expect(header.height, greaterThan(0));
            expect(header.bottom, lessThanOrEqualTo(mediaBounds.top + 1));
            _expectContained(header, tileBounds);
          }
          for (final web.DOMRect previous in bounds) {
            final bool overlaps =
                tileBounds.left < previous.right - 1 &&
                tileBounds.right > previous.left + 1 &&
                tileBounds.top < previous.bottom - 1 &&
                tileBounds.bottom > previous.top + 1;
            expect(overlaps, isFalse, reason: 'Tile $index overlaps another');
          }
          bounds.add(tileBounds);
        }
      });
    }

    testClient('$name masonry retains its aspect-driven row heights', (
      ClientTester tester,
    ) async {
      tester.pumpComponent(
        _fixture(theme: theme, width: 840, layout: ArcaneGalleryLayout.masonry),
      );
      await pumpEventQueue();

      final web.NodeList tiles = web.document.querySelectorAll(
        '[data-arcane-gallery-item]',
      );
      const List<double> heights = <double>[350, 170, 260, 350, 170, 260];
      expect(tiles.length, heights.length);
      for (int index = 0; index < tiles.length; index++) {
        final web.Element tile = tiles.item(index)! as web.Element;
        final web.DOMRect bounds = tile.getBoundingClientRect();
        final web.DOMRect media = tile
            .querySelector('.$name-gallery-tile-media')!
            .getBoundingClientRect();
        expect(bounds.height, closeTo(heights[index], 1));
        expect(media.height, greaterThan(0));
        _expectContained(media, bounds);
      }
    });
  }
}
