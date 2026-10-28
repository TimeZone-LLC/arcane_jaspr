import 'package:arcane_jaspr/core/props/gallery_props.dart';
import 'package:arcane_jaspr/core/rendering/base/gallery_render_base.dart';
import 'package:arcane_jaspr_neubrutalism/src/neubrutalism_variant.dart';

/// Classic framed tiles or NeuComic panels with narration captions.
class NeubrutalismGallery extends GalleryRenderBase {
  final NeubrutalismVariant variant;

  const NeubrutalismGallery(
    super.props, {
    this.variant = NeubrutalismVariant.classic,
    super.key,
  });

  @override
  String get surfaceClass => 'neubrutalism-gallery';

  @override
  String get tileClass => 'neubrutalism-gallery-tile';

  @override
  ArcaneGalleryCaptionPlacement get captionPlacement =>
      variant == NeubrutalismVariant.neuComic
      ? ArcaneGalleryCaptionPlacement.belowMedia
      : ArcaneGalleryCaptionPlacement.hidden;

  @override
  bool get preservesMediaAspectRatio => variant == NeubrutalismVariant.neuComic;

  @override
  bool get usesJustifiedRows => variant == NeubrutalismVariant.neuComic;

  @override
  Map<String, String> surfaceStyles(GalleryProps props) =>
      variant == NeubrutalismVariant.neuComic
      ? const <String, String>{
          'column-gap': '36px',
          'row-gap': '48px',
          'padding': '24px 20px',
          'box-sizing': 'border-box',
        }
      : const <String, String>{};

  @override
  Map<String, String> tileStyles(ArcaneGalleryTile tile) =>
      variant == NeubrutalismVariant.neuComic
      ? const <String, String>{
          'background': 'var(--card)',
          'color': 'var(--foreground)',
          'border': '3px solid var(--neucomic-ink, var(--foreground))',
          'border-radius': '0',
          'box-shadow': 'none',
          'overflow': 'hidden',
        }
      : const <String, String>{
          'background': 'var(--nb-paper, var(--card))',
          'color': 'var(--card-foreground)',
          'border': 'var(--nb-border-base, 3px) solid var(--nb-line, #000)',
          'border-radius': 'var(--nb-radius-soft, 0)',
          'box-shadow':
              'var(--nb-shadow-md, 5px 5px 0 0 var(--nb-shadow-color, #000))',
        };
}
