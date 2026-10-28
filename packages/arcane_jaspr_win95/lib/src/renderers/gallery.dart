import 'package:arcane_jaspr/core/rendering/base/gallery_render_base.dart';
import 'package:arcane_jaspr/core/props/gallery_props.dart';

/// Win95 gallery renderer.
class Win95Gallery extends GalleryRenderBase {
  const Win95Gallery(super.props, {super.key});

  @override
  String get surfaceClass => 'win95-gallery';

  @override
  String get tileClass => 'win95-gallery-tile';

  /// Each tile is a chromed application window, so the title/meta render as the
  /// navy title bar (lifted above the media by `order: -1` in the win95 CSS).
  @override
  ArcaneGalleryCaptionPlacement get captionPlacement =>
      ArcaneGalleryCaptionPlacement.aboveMedia;
}
