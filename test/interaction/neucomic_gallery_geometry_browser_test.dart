@TestOn('browser')
library;

import 'dart:math' as math;

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/util/interactivity/scripts/gallery/gallery_scripts.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

const List<double> _ratios = <double>[2.3256, 0.65, 1, 1.7, 0.8, 1.4, 1];

void _mount(
  ClientTester tester,
  int width,
  Brightness brightness, {
  ArcaneGalleryLayout layout = ArcaneGalleryLayout.masonry,
  List<double> sourceRatios = _ratios,
  double? appendedRatio,
}) {
  final List<double> ratios = <double>[...sourceRatios, ?appendedRatio];
  tester.pumpComponent(
    ArcaneApp(
      stylesheet: const NeubrutalismStylesheet(
        variant: NeubrutalismVariant.neuComic,
      ),
      brightness: brightness,
      includeFallbackScripts: false,
      home: dom.div(
        id: 'gallery-frame',
        styles: dom.Styles(
          raw: <String, String>{'width': '${width}px', 'display': 'grid'},
        ),
        <Widget>[
          ArcaneGallery(
            id: 'comic-gallery',
            ariaLabel: 'Artist panels',
            layout: layout,
            minColumnWidth: 220,
            packing: layout == ArcaneGalleryLayout.masonry,
            minimumTileArea: 4,
            targetTileArea: 6,
            tiles: <ArcaneGalleryTile>[
              for (int index = 0; index < ratios.length; index++)
                ArcaneGalleryTile(
                  media: ArcaneGalleryMedia(
                    aspectRatio: ratios[index],
                    src:
                        'data:image/svg+xml,%3Csvg '
                        'xmlns="http://www.w3.org/2000/svg" '
                        'width="${100 * ratios[index]}" height="100"/%3E',
                    alt: 'Artwork $index',
                  ),
                  mediaChild: index == 5
                      ? const dom.div(
                          styles: dom.Styles(
                            raw: <String, String>{
                              'position': 'absolute',
                              'inset': '0',
                            },
                          ),
                          <Widget>[],
                        )
                      : null,
                  title: 'Artwork $index with a readable title',
                  meta: 'Artist $index',
                  href: '/art/$index',
                  footer: index == 0 ? const Text('Original print') : null,
                ),
            ],
          ),
        ],
      ),
    ),
  );
}

Future<void> _settle() async {
  await pumpEventQueue();
  await Future<void>.delayed(const Duration(milliseconds: 160));
}

void _expectContained(web.DOMRect inner, web.DOMRect outer) {
  expect(inner.left, greaterThanOrEqualTo(outer.left - 1));
  expect(inner.right, lessThanOrEqualTo(outer.right + 1));
  expect(inner.top, greaterThanOrEqualTo(outer.top - 1));
  expect(inner.bottom, lessThanOrEqualTo(outer.bottom + 1));
}

double _pixels(String value) =>
    double.tryParse(value.replaceAll('px', '')) ?? 0;

web.DOMRect _layoutBounds(web.Element element) {
  final web.HTMLElement html = element as web.HTMLElement;
  final web.CSSStyleDeclaration style = web.window.getComputedStyle(element);
  double left = html.offsetLeft.toDouble();
  double top = html.offsetTop.toDouble();
  web.HTMLElement? parent = html.offsetParent as web.HTMLElement?;
  while (parent != null) {
    left += parent.offsetLeft + parent.clientLeft;
    top += parent.offsetTop + parent.clientTop;
    parent = parent.offsetParent as web.HTMLElement?;
  }
  final bool borderBox = style.boxSizing == 'border-box';
  final double width =
      _pixels(style.width) +
      (borderBox
          ? 0
          : _pixels(style.paddingLeft) +
                _pixels(style.paddingRight) +
                _pixels(style.borderLeftWidth) +
                _pixels(style.borderRightWidth));
  final double height =
      _pixels(style.height) +
      (borderBox
          ? 0
          : _pixels(style.paddingTop) +
                _pixels(style.paddingBottom) +
                _pixels(style.borderTopWidth) +
                _pixels(style.borderBottomWidth));
  return web.DOMRect(left, top, width, height);
}

web.DOMRect _galleryContentBounds() {
  final web.Element gallery = web.document.querySelector('#comic-gallery')!;
  final web.DOMRect bounds = _layoutBounds(gallery);
  final web.CSSStyleDeclaration style = web.window.getComputedStyle(gallery);
  final double left = _pixels(style.paddingLeft);
  final double top = _pixels(style.paddingTop);
  return web.DOMRect(
    bounds.left + left,
    bounds.top + top,
    bounds.width - left - _pixels(style.paddingRight),
    bounds.height - top - _pixels(style.paddingBottom),
  );
}

double _rotation(web.Element tile) {
  final String transform = web.window.getComputedStyle(tile).transform;
  if (transform == 'none') return 0;
  final List<double> matrix = transform
      .substring(7, transform.length - 1)
      .split(',')
      .map((String value) => double.parse(value.trim()))
      .toList();
  expect(matrix.length, 6);
  expect(matrix[0] * matrix[0] + matrix[1] * matrix[1], closeTo(1, 0.00001));
  expect(matrix[2], closeTo(-matrix[1], 0.00001));
  expect(matrix[3], closeTo(matrix[0], 0.00001));
  expect(matrix[4], 0);
  expect(matrix[5], 0);
  return math.atan2(matrix[1], matrix[0]) * 180 / math.pi;
}

List<web.DOMRect> _checkPanels(
  int width,
  List<double> ratios, {
  bool requireSharedRows = true,
}) {
  final web.Element gallery = web.document.querySelector('#comic-gallery')!;
  final web.DOMRect galleryBounds = gallery.getBoundingClientRect();
  expect(galleryBounds.width, closeTo(width, 1));
  final web.DOMRect contentBounds = _galleryContentBounds();
  expect(gallery.classList.contains('is-arcane-gallery-ready'), isTrue);
  final web.NodeList tiles = gallery.querySelectorAll(
    '[data-arcane-gallery-item]',
  );
  expect(tiles.length, ratios.length);
  final List<web.DOMRect> bounds = <web.DOMRect>[];
  final List<web.DOMRect> inkBounds = <web.DOMRect>[];
  final List<double> rotations = <double>[];
  web.DOMRect? previous;
  double? rowImageHeight;
  bool hasSharedRow = false;
  for (int index = 0; index < tiles.length; index++) {
    final web.Element tile = tiles.item(index)! as web.Element;
    final web.DOMRect tileBounds = _layoutBounds(tile);
    final web.DOMRect visualBounds = tile.getBoundingClientRect();
    final web.DOMRect ink = web.DOMRect(
      visualBounds.left - 7,
      visualBounds.top - 7,
      visualBounds.width + 14,
      visualBounds.height + 14,
    );
    _expectContained(ink, galleryBounds);
    for (final web.DOMRect other in inkBounds) {
      final double overlapWidth =
          math.min(ink.right, other.right) - math.max(ink.left, other.left);
      final double overlapHeight =
          math.min(ink.bottom, other.bottom) - math.max(ink.top, other.top);
      expect(
        overlapWidth > 0 && overlapHeight > 0,
        isFalse,
        reason: 'Paper edges and shadows must not cover adjacent panels',
      );
    }
    inkBounds.add(ink);
    final double rotation = _rotation(tile);
    rotations.add(rotation);
    expect(rotation.abs(), lessThanOrEqualTo(3.01));
    if (contentBounds.width <= 600) {
      expect(rotation.abs(), lessThanOrEqualTo(1.51));
    }
    final web.Element media = tile.querySelector(
      '[data-arcane-gallery-media]',
    )!;
    final web.DOMRect mediaBounds = _layoutBounds(media);
    final web.CSSStyleDeclaration style = web.window.getComputedStyle(media);
    final double imageWidth =
        mediaBounds.width -
        _pixels(style.borderLeftWidth) -
        _pixels(style.borderRightWidth) -
        _pixels(style.paddingLeft) -
        _pixels(style.paddingRight);
    final double imageHeight =
        mediaBounds.height -
        _pixels(style.borderTopWidth) -
        _pixels(style.borderBottomWidth) -
        _pixels(style.paddingTop) -
        _pixels(style.paddingBottom);
    expect(imageWidth, greaterThan(0));
    expect(imageHeight, greaterThan(0));
    expect(
      imageWidth / imageHeight,
      closeTo(ratios[index], ratios[index] * 0.01),
      reason: 'Panel $index must fit the complete artwork without letterboxing',
    );
    _expectContained(tileBounds, contentBounds);
    _expectContained(mediaBounds, tileBounds);
    _expectContained(_layoutBounds(media.firstElementChild!), mediaBounds);
    final web.Element caption = tile.querySelector(
      '[data-arcane-gallery-caption]',
    )!;
    final web.DOMRect captionBounds = _layoutBounds(caption);
    expect(caption.textContent, contains('Artist $index'));
    expect(captionBounds.height, greaterThan(25));
    expect(captionBounds.top, greaterThanOrEqualTo(mediaBounds.bottom - 1));
    _expectContained(captionBounds, tileBounds);
    final web.Element? footer = tile.querySelector(
      '[data-arcane-gallery-footer]',
    );
    if (footer != null) {
      _expectContained(_layoutBounds(footer), tileBounds);
    }
    if (previous != null && (tileBounds.top - previous.top).abs() < 1) {
      hasSharedRow = true;
      expect(tileBounds.left, greaterThanOrEqualTo(previous.right));
      expect(tileBounds.bottom, closeTo(previous.bottom, 1));
      expect(imageHeight, closeTo(rowImageHeight!, 1));
    } else {
      if (previous != null) {
        expect(tileBounds.top, greaterThanOrEqualTo(previous.bottom));
      }
      expect(tileBounds.left, closeTo(contentBounds.left, 1));
      rowImageHeight = imageHeight;
    }
    if (contentBounds.width <= 600) {
      expect(tileBounds.width, closeTo(contentBounds.width, 1));
    } else {
      expect(imageHeight, lessThanOrEqualTo(601));
    }
    previous = tileBounds;
    bounds.add(tileBounds);
  }
  if (requireSharedRows) expect(hasSharedRow, contentBounds.width > 600);
  if (contentBounds.width > 600 && ratios.length >= 5) {
    expect(rotations.any((double angle) => angle < -0.1), isTrue);
    expect(rotations.any((double angle) => angle > 0.1), isTrue);
    expect(rotations.any((double angle) => angle.abs() < 1), isTrue);
  }
  return bounds;
}

void main() {
  setUpAll(() {
    web.document.body!.appendChild(
      web.HTMLScriptElement()..text = GalleryScripts.code,
    );
  });

  for (final Brightness brightness in Brightness.values) {
    testClient(
      'NeuComic panels keep assertive desktop and safe phone angles in ${brightness.name}',
      (ClientTester tester) async {
        const List<double> ratios = <double>[2.3, 1.7, 1, 1, 1, 1, 1, 1];
        _mount(tester, 1320, brightness, sourceRatios: ratios);
        await _settle();
        _checkPanels(1320, ratios);
        web.Element first = web.document.querySelector(
          '[data-arcane-gallery-item]',
        )!;
        expect(_layoutBounds(first).width, greaterThan(650));
        expect(_rotation(first), lessThanOrEqualTo(-2.4));
        final web.Element second =
            web.document.querySelectorAll('[data-arcane-gallery-item]').item(1)!
                as web.Element;
        expect(_rotation(second), greaterThanOrEqualTo(2.8));

        final web.HTMLElement frame =
            web.document.querySelector('#gallery-frame')! as web.HTMLElement;
        frame.style.width = '320px';
        await _settle();
        _checkPanels(320, ratios);
        first = web.document.querySelector('[data-arcane-gallery-item]')!;
        expect(_rotation(first), lessThanOrEqualTo(-1));
      },
    );

    testClient(
      'NeuComic wide tilted panels keep their paper edges inside the gallery in ${brightness.name}',
      (ClientTester tester) async {
        const List<double> ratios = <double>[8, 8, 8, 8, 8, 8];
        _mount(tester, 1422, brightness, sourceRatios: ratios);
        await _settle();
        _checkPanels(1422, ratios, requireSharedRows: false);
      },
    );

    testClient(
      'NeuComic paper rotation does not change measured caption height in ${brightness.name}',
      (ClientTester tester) async {
        _mount(tester, 980, brightness);
        await _settle();
        final web.NodeList tiles = web.document.querySelectorAll(
          '[data-arcane-gallery-item]',
        );
        final List<double> heights = <double>[
          for (int index = 0; index < tiles.length; index++)
            _pixels(
              web.window
                  .getComputedStyle(tiles.item(index)! as web.Element)
                  .height,
            ),
        ];
        for (int index = 0; index < tiles.length; index++) {
          (tiles.item(index)! as web.HTMLElement).style.setProperty(
            'transform',
            'rotate(${index.isEven ? 4 : -3}deg)',
            'important',
          );
        }
        await _settle();
        for (int index = 0; index < tiles.length; index++) {
          expect(
            _pixels(
              web.window
                  .getComputedStyle(tiles.item(index)! as web.Element)
                  .height,
            ),
            closeTo(heights[index], 0.1),
            reason: 'Rigid panel rotation must not enlarge the caption band',
          );
        }
      },
    );

    testClient(
      'NeuComic mixed feed fills strips without narrowing captions in ${brightness.name}',
      (ClientTester tester) async {
        const List<double> ratios = <double>[
          2.332613,
          1.776316,
          1,
          2.332613,
          1,
          1.776316,
          0.562963,
          1.776316,
          1,
          2.332613,
          1,
          0.562963,
          0.562963,
          0.562963,
          0.75,
          1.776316,
          0.562963,
          2.332613,
          1.776316,
          0.562963,
          0.75,
          1,
          0.562963,
          1,
          1.776316,
          1,
          1,
          0.75,
          0.562963,
          1.776316,
          1,
          0.75,
          0.562963,
          1,
          1.776316,
          2.332613,
          0.75,
          1.776316,
          0.562963,
          1,
          0.562963,
          0.562963,
          1,
          1.776316,
          0.562963,
          1.776316,
          1,
        ];
        _mount(tester, 1320, brightness, sourceRatios: ratios);
        await _settle();
        final List<web.DOMRect> bounds = _checkPanels(1320, ratios);
        final web.NodeList panels = web.document.querySelectorAll(
          '[data-arcane-gallery-item]',
        );
        expect(
          _rotation(panels.item(0)! as web.Element),
          lessThanOrEqualTo(-2.4),
        );
        expect(
          _rotation(panels.item(1)! as web.Element),
          greaterThanOrEqualTo(2.8),
        );
        for (int index = 0; index < bounds.length; index++) {
          expect(bounds[index].width, greaterThanOrEqualTo(179.9));
          if (index + 1 < bounds.length &&
              bounds[index + 1].top > bounds[index].top + 1) {
            expect(
              bounds[index].right,
              closeTo(_galleryContentBounds().right, 1),
              reason: 'A non-final strip must fill the available width',
            );
          }
        }
      },
    );

    testClient(
      'NeuComic captioned portraits keep readable widths in ${brightness.name}',
      (ClientTester tester) async {
        const List<double> ratios = <double>[
          1,
          0.563,
          0.563,
          0.563,
          0.75,
          1.776,
          0.563,
          1,
        ];
        _mount(tester, 1320, brightness, sourceRatios: ratios);
        await _settle();
        final List<web.DOMRect> bounds = _checkPanels(1320, ratios);
        for (final web.DOMRect panel in bounds.take(5)) {
          expect(panel.width, greaterThanOrEqualTo(179.9));
          expect(panel.top, closeTo(bounds.first.top, 1));
        }
        expect(bounds[4].right, closeTo(_galleryContentBounds().right, 1));
        expect(bounds[5].top, greaterThan(bounds[4].bottom));
      },
    );

    for (final List<double> ratios in <List<double>>[
      const <double>[0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3, 0.3],
      const <double>[0.2, 0.3, 0.4, 0.25, 1.8, 0.35, 0.3, 0.2],
    ]) {
      testClient(
        'NeuComic capped rows stay separate for $ratios in ${brightness.name}',
        (ClientTester tester) async {
          _mount(tester, 1320, brightness, sourceRatios: ratios);
          await _settle();
          _checkPanels(1320, ratios);
          final web.NodeList tiles = web.document.querySelectorAll(
            '[data-arcane-gallery-item]',
          );
          web.Element? previous;
          for (int index = 0; index < tiles.length; index++) {
            final web.Element tile = tiles.item(index)! as web.Element;
            if (previous != null &&
                tile.getAttribute('data-arcane-gallery-row') !=
                    previous.getAttribute('data-arcane-gallery-row')) {
              expect(
                _layoutBounds(tile).top,
                greaterThan(_layoutBounds(previous).bottom),
                reason: 'A capped row must end before the next row starts',
              );
            }
            previous = tile;
          }

          final web.HTMLElement frame =
              web.document.querySelector('#gallery-frame')! as web.HTMLElement;
          frame.style.width = '320px';
          await _settle();
          _checkPanels(320, ratios);
          frame.style.width = '1320px';
          await _settle();
          _checkPanels(1320, ratios);
          _mount(
            tester,
            1320,
            brightness,
            sourceRatios: ratios,
            appendedRatio: 0.25,
          );
          await _settle();
          _checkPanels(1320, <double>[...ratios, 0.25]);
        },
      );
    }

    for (final int width in <int>[1422, 980, 600, 360]) {
      testClient(
        'NeuComic strips preserve artwork and reading order at $width in ${brightness.name}',
        (ClientTester tester) async {
          _mount(tester, width, brightness);
          await _settle();
          final List<web.DOMRect> initial = _checkPanels(width, _ratios);
          final web.HTMLElement focusedTile =
              web.document
                      .querySelectorAll('[data-arcane-gallery-item]')
                      .item(1)!
                  as web.HTMLElement;
          final double initialRotation = _rotation(focusedTile);
          focusedTile.focus();
          await _settle();
          expect(web.document.activeElement, focusedTile);
          expect(
            _layoutBounds(focusedTile).width,
            closeTo(initial[1].width, 0.1),
          );
          expect(
            _layoutBounds(focusedTile).height,
            closeTo(initial[1].height, 0.1),
          );
          expect(_rotation(focusedTile), closeTo(initialRotation, 0.001));
          final web.CSSStyleDeclaration focusStyle = web.window
              .getComputedStyle(focusedTile);
          expect(focusStyle.outlineStyle, 'solid');
          expect(_pixels(focusStyle.outlineWidth), greaterThanOrEqualTo(3));
          focusedTile.blur();

          final web.HTMLElement frame =
              web.document.querySelector('#gallery-frame')! as web.HTMLElement;
          final int alternateWidth = width > 600 ? 320 : 980;
          frame.style.width = '${alternateWidth}px';
          await _settle();
          _checkPanels(alternateWidth, _ratios);
          frame.style.width = '${width}px';
          await _settle();
          final List<web.DOMRect> restored = _checkPanels(width, _ratios);
          for (int index = 0; index < initial.length; index++) {
            expect(restored[index].width, closeTo(initial[index].width, 1));
            expect(restored[index].height, closeTo(initial[index].height, 1));
            expect(restored[index].top, closeTo(initial[index].top, 1));
            expect(restored[index].left, closeTo(initial[index].left, 1));
          }

          _mount(tester, width, brightness, appendedRatio: 2.75);
          await _settle();
          _checkPanels(width, <double>[..._ratios, 2.75]);
          if (width == 1422) {
            final web.HTMLElement title =
                web.document.querySelector('.neubrutalism-gallery-tile-title')!
                    as web.HTMLElement;
            title.style.whiteSpace = 'normal';
            title.textContent = List<String>.filled(
              12,
              'A caption that wraps',
            ).join(' ');
            await _settle();
            _checkPanels(width, <double>[..._ratios, 2.75]);
          }
        },
      );
    }

    testClient(
      'NeuComic grid preference also preserves artwork in ${brightness.name}',
      (ClientTester tester) async {
        _mount(tester, 980, brightness, layout: ArcaneGalleryLayout.grid);
        await _settle();
        _checkPanels(980, _ratios);
      },
    );
  }
}
