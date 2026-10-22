import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/dom_value.dart';
import 'package:arcane_jaspr/core/props/gallery_props.dart';
import 'package:arcane_jaspr/core/rendering/base/style_layering.dart';

const Set<String> _galleryStructureAttributes = <String>{
  'data-arcane-gallery-item',
  'data-ratio',
  'data-span',
  'data-column-span',
};

const Set<String> _galleryDragAttributes = <String>{
  'data-arcane-draggable-item',
  'data-arcane-drag-key',
  'data-arcane-drag-handle',
  'draggable',
  'aria-keyshortcuts',
  'aria-description',
};

const Set<String> _rolesWithoutAuthorName = <String>{
  'caption',
  'code',
  'deletion',
  'emphasis',
  'generic',
  'insertion',
  'none',
  'paragraph',
  'presentation',
  'strong',
  'subscript',
  'superscript',
};

/// The CSS-grid base uses coarse, roughly-square cells (a row is ~half a column
/// wide) so wide artwork must span multiple COLUMNS — that is what produces the
/// variable-width mosaic. `grid-auto-rows` is set to `minColumnWidth / 2`.
double galleryRowUnitFor(double minColumnWidth) =>
    (minColumnWidth / 2).clamp(48, 240).toDouble();

double _clampAspect(double aspect) =>
    (aspect.isFinite && aspect > 0) ? aspect.clamp(0.2, 5.0).toDouble() : 1.0;

/// How many COLUMNS a tile of the given [aspect] (width/height) spans in the
/// CSS-grid base — wider artwork spans more columns. The opt-in packer refines.
int galleryColumnSpan(double aspect) {
  final double a = _clampAspect(aspect);
  if (a >= 1.68) return 3; // panorama
  if (a >= 1.28) return 2; // wide
  return 1;
}

/// How many coarse ROWS a tile of the given [aspect] spans in the CSS-grid
/// base. Buckets mirror the previous masonry (square ~2, portrait/wide ~3,
/// tall ~4) against the `minColumnWidth/2` row unit.
int galleryRowSpan(double aspect) {
  final double a = _clampAspect(aspect);
  if (a <= 0.62) return 4; // tall
  if (a <= 0.84) return 3; // portrait
  if (a >= 1.28) return 3; // wide / panorama (also spans columns)
  return 2; // square
}

/// Shared structural base for themed gallery renderers.
///
/// Emits a coarse CSS-grid masonry (`repeat(auto-fill, minmax(min,1fr))` with
/// `grid-auto-flow: dense`, aspect-driven column AND row spans) whose tiles
/// carry `data-arcane-gallery-item` / `data-ratio` / `data-span` so the opt-in
/// packing script can refine placements. Each tile stretches to fill its grid
/// cell; the media (the consumer's [ArcaneGalleryTile.mediaChild] or a default
/// `<img>`) covers the cell (object-fit: cover), with an optional title/meta
/// header, corner overlays, and a footer.
///
/// Lives in core; depends only on core props. Never import a theme package.
abstract class GalleryRenderBase extends StatelessComponent {
  const GalleryRenderBase(this.props, {super.key});

  final GalleryProps props;

  /// Root surface CSS class (e.g. `'win95-gallery'`).
  String get surfaceClass;

  /// Per-tile CSS class (e.g. `'win95-gallery-tile'`).
  String get tileClass;

  /// Extra inline styles merged onto the surface. Default: none.
  Map<String, String> surfaceStyles(GalleryProps props) =>
      const <String, String>{};

  /// Extra inline styles merged onto each tile frame. Default: none.
  Map<String, String> tileStyles(ArcaneGalleryTile tile) =>
      const <String, String>{};

  /// Extra inline styles merged onto each media region. Default: none.
  Map<String, String> mediaStyles(ArcaneGalleryTile tile) =>
      const <String, String>{};

  /// Whether the tile's title/meta render as a visible header block.
  ///
  /// Win95 shows it as the window's navy title bar; the card-style themes
  /// (shadcn, neubrutalism, neon) render clean media-only tiles — the title is
  /// exposed to assistive tech via the tile's `aria-label` instead of a visible
  /// caption, so a rounded card never grows a stray caption strip. Default:
  /// false; win95 overrides to true.
  bool get showsTileHeader => false;

  @override
  Component build(BuildContext context) {
    final bool masonry = props.layout == ArcaneGalleryLayout.masonry;
    final int rowUnit = galleryRowUnitFor(props.minColumnWidth).round();
    final Map<String, String> surface = layerStyles(
      <String, String>{
        'display': 'grid',
        'grid-template-columns':
            'repeat(auto-fill, minmax(${props.minColumnWidth.round()}px, 1fr))',
        if (masonry) ...<String, String>{
          'grid-auto-rows': '${rowUnit}px',
          'grid-auto-flow': 'dense',
        },
        'gap': '10px',
        'width': '100%',
        'align-items': 'stretch',
      },
      <Map<String, String>?>[surfaceStyles(props)],
    );

    return dom.div(
      id: props.id,
      classes: _join(<String>[surfaceClass, props.classes]),
      attributes: <String, String>{
        'role': 'region',
        'aria-label': props.ariaLabel,
        'data-arcane-gallery': 'true',
        if (props.packing) 'data-packing': 'true',
        if (props.minimumTileArea != null)
          'data-arcane-gallery-minimum-tile-area': props.minimumTileArea!
              .toString(),
        if (props.targetTileArea != null)
          'data-arcane-gallery-target-tile-area': props.targetTileArea!
              .toString(),
        if (props.draggableTiles) ...<String, String>{
          'data-arcane-gallery-draggable': 'true',
          'data-arcane-drag-keyboard-step': props.dragKeyboardStep.toString(),
          'data-arcane-drag-inset': props.dragInset.toString(),
          if (props.id != null) 'data-arcane-gallery-drag-id': props.id!,
        },
      },
      styles: dom.Styles(raw: surface),
      <Component>[
        for (int index = 0; index < props.tiles.length; index++)
          _tile(props.tiles[index], masonry, index),
      ],
    );
  }

  Component _tile(ArcaneGalleryTile tile, bool masonry, int index) {
    final double aspect = _clampAspect(tile.media.aspectRatio);
    final int rowSpan = galleryRowSpan(aspect);
    final int columnSpan = galleryColumnSpan(aspect);
    final bool hasVisibleHeader =
        showsTileHeader && (tile.title != null || tile.meta != null);

    final Map<String, String> frame = layerStyles(
      <String, String>{
        if (masonry) ...<String, String>{
          'grid-column-end': 'span $columnSpan',
          'grid-row-end': 'span $rowSpan',
        },
        'display': 'flex',
        'flex-direction': 'column',
        'overflow': 'hidden',
        'min-width': '0',
        'height': '100%',
        'text-decoration': 'none',
        'color': 'inherit',
      },
      <Map<String, String>?>[tileStyles(tile)],
    );

    final Component media = dom.div(
      classes: '$tileClass-media',
      styles: dom.Styles(
        raw: layerStyles(
          <String, String>{
            'position': 'relative',
            'flex': masonry ? '1 1 auto' : '0 0 auto',
            if (!masonry) 'aspect-ratio': '1',
            'min-height': '0',
            'width': '100%',
            'overflow': 'hidden',
          },
          <Map<String, String>?>[mediaStyles(tile)],
        ),
      ),
      <Component>[
        tile.mediaChild ?? _defaultImage(tile.media),
        for (final Component overlay in tile.overlay.cast<Component>()) overlay,
      ],
    );

    final List<Component> children = <Component>[
      media,
      if (hasVisibleHeader)
        dom.div(
          classes: '$tileClass-header',
          attributes: <String, String>{
            if (props.draggableTiles) 'data-arcane-drag-handle': 'true',
          },
          <Component>[
            if (tile.title != null)
              dom.span(classes: '$tileClass-title', <Component>[
                Component.text(tile.title!),
              ]),
            if (tile.meta != null)
              dom.span(classes: '$tileClass-meta', <Component>[
                Component.text(tile.meta!),
              ]),
          ],
        ),
      if (tile.footer != null)
        dom.div(classes: '$tileClass-footer', <Component>[tile.footer!]),
    ];

    final bool ownsKeyboardSemantics =
        tile.href == null && (props.draggableTiles || tile.onTap != null);
    final Map<String, String> callerAttributes =
        Map<String, String>.fromEntries(
          tile.attributes.entries.where((MapEntry<String, String> entry) {
            if (_galleryStructureAttributes.contains(entry.key)) {
              return false;
            }
            if (props.draggableTiles &&
                _galleryDragAttributes.contains(entry.key)) {
              return false;
            }
            if (ownsKeyboardSemantics &&
                (entry.key == 'tabindex' || entry.key == 'role')) {
              return false;
            }
            return entry.key != 'aria-label';
          }),
        );
    final String? explicitAriaLabel = _nonEmpty(tile.attributes['aria-label']);
    final String? callerRole = _nonEmpty(callerAttributes['role']);
    final String? hiddenTitle = showsTileHeader ? null : _nonEmpty(tile.title);
    final bool suppressesAccessibleName =
        callerRole != null &&
        _rolesWithoutAuthorName.contains(callerRole.toLowerCase());
    final bool hasNameableSemantics =
        !suppressesAccessibleName &&
        (tile.href != null ||
            tile.onTap != null ||
            props.draggableTiles ||
            explicitAriaLabel != null ||
            hiddenTitle != null);
    final String? accessibleLabel = hasNameableSemantics
        ? explicitAriaLabel ??
              _nonEmpty(tile.title) ??
              _nonEmpty(tile.media.alt) ??
              'Gallery item ${index + 1}'
        : null;

    final Map<String, String> attributes = <String, String>{
      ...callerAttributes,
      'data-arcane-surface': 'gallery-tile',
      'data-arcane-gallery-item': 'true',
      'data-ratio': aspect.toStringAsFixed(4),
      'data-span': '$rowSpan',
      'data-column-span': '$columnSpan',
      if (props.draggableTiles) ...<String, String>{
        'data-arcane-draggable-item': 'true',
        'draggable': 'false',
        'aria-keyshortcuts':
            'Shift+ArrowUp Shift+ArrowDown Shift+ArrowLeft Shift+ArrowRight',
        'aria-description':
            'Hold Shift and use the arrow keys to reposition this item.',
        'data-arcane-drag-key': tile.dragId ?? index.toString(),
        if (!hasVisibleHeader) 'data-arcane-drag-handle': 'true',
      },
      if (tile.href == null && (props.draggableTiles || tile.onTap != null))
        'tabindex': '0',
      if (tile.href == null && (tile.onTap != null || props.draggableTiles))
        'role': tile.onTap != null ? 'button' : 'group',
      if (tile.href == null &&
          tile.onTap == null &&
          !props.draggableTiles &&
          (explicitAriaLabel != null || hiddenTitle != null) &&
          callerRole == null)
        'role': 'group',
      'aria-label': ?accessibleLabel,
    };

    final String cls = _join(<String>[tileClass, tile.classes]);

    if (tile.href != null) {
      return dom.a(
        href: tile.href!,
        classes: cls,
        styles: dom.Styles(raw: frame),
        attributes: attributes,
        children,
      );
    }
    return dom.div(
      classes: cls,
      styles: dom.Styles(raw: frame),
      attributes: attributes,
      events: tile.onTap != null
          ? <String, void Function(dynamic)>{
              'click': (dynamic _) => tile.onTap!(),
              'keydown': (dynamic event) {
                final String key = domEventKey(event);
                if (key == 'Enter' || key == ' ') {
                  domPreventDefault(event);
                  tile.onTap!();
                }
              },
            }
          : null,
      children,
    );
  }

  Component _defaultImage(ArcaneGalleryMedia media) {
    return dom.img(
      src: media.src ?? '',
      alt: media.alt,
      attributes: <String, String>{
        if (media.srcset != null) 'srcset': media.srcset!,
        if (media.thumbHash != null) 'data-thumbhash': media.thumbHash!,
        'loading': 'lazy',
      },
      styles: const dom.Styles(
        raw: <String, String>{
          'position': 'absolute',
          'inset': '0',
          'width': '100%',
          'height': '100%',
          'object-fit': 'cover',
          'display': 'block',
        },
      ),
    );
  }
}

String _join(List<String> names) => names
    .map((String name) => name.trim())
    .where((String name) => name.isNotEmpty)
    .join(' ');

String? _nonEmpty(String? value) {
  final String trimmed = value?.trim() ?? '';
  return trimmed.isEmpty ? null : trimmed;
}
