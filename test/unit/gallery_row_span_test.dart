// Unit tests for the ArcaneGallery CSS-masonry base span buckets.

import 'package:arcane_jaspr/core/props/gallery_props.dart';
import 'package:arcane_jaspr/core/rendering/base/gallery_render_base.dart';
import 'package:jaspr_test/jaspr_test.dart';

/// Minimal concrete subclass exercising the render-base defaults.
class _BareGallery extends GalleryRenderBase {
  const _BareGallery(super.props);

  @override
  String get surfaceClass => 'bare-gallery';

  @override
  String get tileClass => 'bare-gallery-tile';
}

void main() {
  group('tile caption header', () {
    test('card-style themes hide the visible caption by default', () {
      const _BareGallery gallery = _BareGallery(
        GalleryProps(tiles: <ArcaneGalleryTile>[], ariaLabel: 'g'),
      );
      // Default: no title bar leaking a rounded caption strip onto card tiles.
      expect(gallery.captionPlacement, ArcaneGalleryCaptionPlacement.hidden);
    });
  });

  group('gallery span buckets', () {
    test('wider artwork spans more columns', () {
      expect(galleryColumnSpan(2.5), 3); // panorama
      expect(galleryColumnSpan(1.5), 2); // wide
      expect(galleryColumnSpan(1.0), 1); // square
      expect(galleryColumnSpan(0.5), 1); // tall: one column, more rows
    });

    test('taller artwork spans more rows than a square tile', () {
      expect(galleryRowSpan(0.5), greaterThan(galleryRowSpan(1.0)));
      expect(galleryRowSpan(1.0), 2); // square
    });

    test('non-finite or non-positive aspect falls back to square', () {
      expect(galleryColumnSpan(double.nan), 1);
      expect(galleryColumnSpan(0), 1);
      expect(galleryColumnSpan(-2), 1);
      expect(galleryRowSpan(double.infinity), galleryRowSpan(1.0));
      expect(galleryRowSpan(0), galleryRowSpan(1.0));
    });

    test('extreme aspects clamp to the 0.2-5.0 range', () {
      expect(galleryColumnSpan(50), galleryColumnSpan(5.0));
      expect(galleryRowSpan(0.001), galleryRowSpan(0.2));
    });

    test('row unit is coarse (half the min column width, clamped)', () {
      expect(galleryRowUnitFor(188), 94);
      expect(galleryRowUnitFor(220), 110);
    });
  });
}
