import 'package:arcane_jaspr/flutter.dart';

/// How an [ArcaneGallery] arranges its tiles.
enum ArcaneGalleryLayout {
  /// Variable-height masonry (aspect-ratio-driven row spans). Squared-off
  /// bottoms come from the opt-in packing script when enabled.
  masonry,

  /// Uniform aspect-locked grid cells.
  grid,
}

/// The caption position chosen by a gallery renderer.
enum ArcaneGalleryCaptionPlacement { hidden, aboveMedia, belowMedia }

/// The primary media of a gallery tile.
///
/// [aspectRatio] (width / height) is REQUIRED — it drives the masonry row span
/// and the reserved-space box, so the layout is stable before images load. The
/// remaining fields feed the default `<img>` the render base emits; a consumer
/// that renders its own media element (canvas, protected-media blob, video)
/// passes [ArcaneGalleryTile.mediaChild] instead and only [aspectRatio] here.
class ArcaneGalleryMedia {
  final double aspectRatio;
  final String? src;
  final String? srcset;
  final String? thumbHash;
  final String alt;

  const ArcaneGalleryMedia({
    required this.aspectRatio,
    this.src,
    this.srcset,
    this.thumbHash,
    this.alt = '',
  });
}

/// One tile in an [ArcaneGallery]. Arcane owns the themed frame, the title/meta
/// placement, and the layout; the consumer fills the app-specific slots.
class ArcaneGalleryTile {
  /// Layout + default-image descriptor. Its [ArcaneGalleryMedia.aspectRatio] is
  /// always used; its image fields are used only when [mediaChild] is null.
  final ArcaneGalleryMedia media;

  /// Custom media element replacing the default `<img>` (e.g. a canvas or a
  /// hover-preview video). Sized by [media]'s aspect ratio.
  final Widget? mediaChild;

  /// The tile caption. Win95 uses a title bar and NeuComic places it below the
  /// artwork. Media-only themes expose it through the tile's accessible name.
  final String? title;

  /// Secondary line (author, subtitle).
  final String? meta;

  /// Wraps the tile in an `<a>` when set.
  final String? href;
  final void Function()? onTap;

  /// Stable key used to preserve a drag offset across item rerenders.
  ///
  /// When omitted, the renderer falls back to the tile's list index. Supply a
  /// key when tiles can be reordered while retaining their positions.
  final String? dragId;

  /// Slot: corner badges rendered over the media.
  final List<Widget> overlay;

  /// Slot: a stats / actions row under the media.
  final Widget? footer;

  final String classes;
  final Map<String, String> attributes;

  const ArcaneGalleryTile({
    required this.media,
    this.mediaChild,
    this.title,
    this.meta,
    this.href,
    this.onTap,
    this.dragId,
    this.overlay = const <Widget>[],
    this.footer,
    this.classes = '',
    this.attributes = const <String, String>{},
  });
}

/// Properties for the gallery surface, passed to `context.renderers.gallery`.
class GalleryProps {
  final String? id;
  final List<ArcaneGalleryTile> tiles;
  final String ariaLabel;
  final ArcaneGalleryLayout layout;

  /// Opt-in ratio-aware packing (squared-off bottoms) via the fallback script.
  final bool packing;

  /// Opt-in pointer and keyboard repositioning within the gallery bounds.
  final bool draggableTiles;

  /// Distance, in logical pixels, moved by Shift+Arrow keyboard commands.
  final double dragKeyboardStep;

  /// Minimum space, in logical pixels, retained inside the gallery edge.
  final double dragInset;

  /// The `minmax()` minimum column width in px for the CSS-grid base.
  final double minColumnWidth;

  /// Optional minimum rendered tile area in grid cells.
  ///
  /// A tile's area is its column span multiplied by its row span. The
  /// ratio-aware packer excludes candidate spans smaller than this value. This
  /// only affects galleries with [packing] enabled.
  final int? minimumTileArea;

  /// Optional preferred rendered tile area in grid cells.
  ///
  /// Unlike the packer's legacy aspect-derived area target, this value is
  /// shared by every tile so aspect ratio chooses shape without deciding how
  /// much visual weight the artwork receives. This only affects galleries with
  /// [packing] enabled.
  final int? targetTileArea;

  final String classes;

  const GalleryProps({
    this.id,
    required this.tiles,
    required this.ariaLabel,
    this.layout = ArcaneGalleryLayout.masonry,
    this.packing = false,
    this.draggableTiles = false,
    this.dragKeyboardStep = 16,
    this.dragInset = 4,
    this.minColumnWidth = 220,
    this.minimumTileArea,
    this.targetTileArea,
    this.classes = '',
  }) : assert(dragKeyboardStep > 0 && dragKeyboardStep < double.infinity),
       assert(dragInset >= 0 && dragInset < double.infinity),
       assert(minimumTileArea == null || minimumTileArea > 0),
       assert(targetTileArea == null || targetTileArea > 0),
       assert(
         minimumTileArea == null ||
             targetTileArea == null ||
             minimumTileArea <= targetTileArea,
       );
}

/// Renderer contract for the gallery component.
mixin GalleryRendererContract {
  Widget gallery(GalleryProps props);
}
