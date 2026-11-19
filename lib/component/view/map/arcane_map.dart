import 'package:arcane_jaspr/flutter.dart';
import 'package:jaspr/dom.dart' as dom;

import 'map_data.dart';
import 'map_projection.dart';
import 'map_style.dart';

export 'map_data.dart';
export 'map_projection.dart';
export 'map_style.dart';

/// Unified map component supporting both world and USA maps.
///
/// Renders an SVG map image with location pins overlaid on top.
/// The SVG should be served from /assets/map/world.svg or /assets/map/us.svg.
class ArcaneMap extends StatelessWidget {
  /// The type of map to display.
  final MapType type;

  /// Location pins to display on the map.
  final List<MapLocation> locations;

  /// Callback when a location pin is tapped.
  final MapLocationCallback? onLocationTap;

  /// Callback when hovering over a location pin.
  final MapLocationCallback? onLocationHover;

  /// Custom tooltip builder for location pins.
  final Widget Function(MapLocation)? tooltipBuilder;

  /// Style configuration for the map.
  final MapStyle style;

  /// Whether to show tooltips on hover.
  final bool showTooltips;

  /// Optional fixed height (CSS value).
  final String? height;

  /// Enable debug mode to show coordinates on hover.
  final bool debugMode;

  /// Custom SVG URL (overrides default asset path).
  final String? svgUrl;

  /// Accessible name for the map image; defaults to the map type.
  final String? label;

  const ArcaneMap({
    this.type = MapType.world,
    this.locations = const [],
    this.onLocationTap,
    this.onLocationHover,
    this.tooltipBuilder,
    this.style = const MapStyle(),
    this.showTooltips = true,
    this.height,
    this.debugMode = false,
    this.svgUrl,
    this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dims = MapProjection.dimensions(type);
    final className = type == MapType.world
        ? 'arcane-world-map'
        : 'arcane-usa-map';
    final mapUrl =
        svgUrl ??
        (type == MapType.world
            ? '/assets/map/world.svg'
            : '/assets/map/us.svg');

    // Use aspect-ratio container to ensure pins align with SVG
    return dom.div(
      classes: className,
      attributes: {
        if (debugMode) 'data-debug-mode': 'true',
        'data-map-type': type.name,
        if (showTooltips && tooltipBuilder != null) 'data-has-tooltips': 'true',
      },
      styles: dom.Styles(
        raw: {
          'display': 'flex',
          'background': style.backgroundColor,
          'justify-content': 'center',
          'align-items': 'center',
          'width': '100%',
          'height': ?height,
          'max-height': '80vh',
          'overflow': 'visible',
        },
      ),
      [
        // Inner container with aspect ratio matching the SVG
        dom.div(
          styles: dom.Styles(
            raw: {
              'position': 'relative',
              'width': '100%',
              'max-width': '100%',
              'aspect-ratio': '${dims.aspectRatio}',
              'max-height': '100%',
              'overflow': 'visible',
            },
          ),
          [
            // Land drawn from the map SVG as a mask so style.regionFill paints it.
            dom.div(
              attributes: <String, String>{
                'role': 'img',
                'aria-label':
                    label ??
                    (type == MapType.world ? 'World map' : 'United States map'),
              },
              styles: dom.Styles(
                raw: <String, String>{
                  'width': '100%',
                  'height': '100%',
                  'background-color': style.regionFill,
                  'mask-image': 'url("$mapUrl")',
                  '-webkit-mask-image': 'url("$mapUrl")',
                  'mask-size': '100% 100%',
                  '-webkit-mask-size': '100% 100%',
                  'mask-repeat': 'no-repeat',
                  '-webkit-mask-repeat': 'no-repeat',
                },
              ),
              const <Widget>[],
            ),
            // Pins container
            dom.div(
              key: const ValueKey('pins-container'),
              classes: 'arcane-map-pins',
              styles: const dom.Styles(
                raw: {
                  'position': 'absolute',
                  'top': '0',
                  'left': '0',
                  'width': '100%',
                  'height': '100%',
                  'pointer-events': 'none',
                  'z-index': '10',
                },
              ),
              [
                for (final location in locations)
                  _buildPin(
                    location,
                    dims,
                    key: ValueKey('pin-${location.id}'),
                  ),
              ],
            ),
            // Tooltip containers
            if (showTooltips && tooltipBuilder != null)
              dom.div(
                key: const ValueKey('tooltips-container'),
                classes: 'arcane-map-tooltips',
                styles: const dom.Styles(
                  raw: {
                    'position': 'absolute',
                    'top': '0',
                    'left': '0',
                    'width': '100%',
                    'height': '100%',
                    'pointer-events': 'none',
                    'z-index': '100',
                  },
                ),
                [
                  for (final location in locations)
                    _buildTooltipWrapper(
                      location,
                      dims,
                      key: ValueKey('tooltip-${location.id}'),
                    ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildPin(
    MapLocation location,
    ({double width, double height, String viewBox, double aspectRatio}) dims, {
    Key? key,
  }) {
    final (x, y) = MapProjection.getCoordinates(
      type,
      location.id,
      location.latitude,
      location.longitude,
    );

    // Calculate percentage position
    final leftPct = (x / dims.width) * 100;
    final topPct = (y / dims.height) * 100;
    // Use location's custom color if provided, otherwise fall back to style
    final color =
        location.color ??
        (location.isActive ? style.pinActiveColor : style.pinColor);
    final size = style.pinSize * 2; // Double for HTML rendering

    return dom.div(
      key: key,
      classes: 'arcane-map-pin',
      attributes: {'data-location': location.id},
      styles: dom.Styles(
        raw: {
          'position': 'absolute',
          'left': '${leftPct.toStringAsFixed(2)}%',
          'top': '${topPct.toStringAsFixed(2)}%',
          'width': '${size}px',
          'height': '${size}px',
          'background': color,
          'border-radius': '50%',
          'transform': 'translate(-50%, -50%)',
          'pointer-events': 'auto',
          'cursor': onLocationTap != null ? 'pointer' : 'default',
          'transition': 'transform 150ms ease',
          'z-index': '10',
        },
      ),
      [],
    );
  }

  Widget _buildTooltipWrapper(
    MapLocation location,
    ({double width, double height, String viewBox, double aspectRatio}) dims, {
    Key? key,
  }) {
    final (x, y) = MapProjection.getCoordinates(
      type,
      location.id,
      location.latitude,
      location.longitude,
    );

    // Calculate percentage position for absolute positioning
    final leftPct = (x / dims.width) * 100;
    final topPct = (y / dims.height) * 100;

    return dom.div(
      key: key,
      classes: 'arcane-map-tooltip',
      attributes: {'data-for-location': location.id},
      styles: dom.Styles(
        raw: {
          'position': 'absolute',
          'left': '${leftPct.toStringAsFixed(2)}%',
          'top': '${topPct.toStringAsFixed(2)}%',
          'transform': 'translate(-50%, -100%) translateY(-16px)',
          'z-index': '100',
          'pointer-events': 'none',
          'opacity': '0',
          'visibility': 'hidden',
          'transition': 'opacity 150ms ease, visibility 150ms ease',
        },
      ),
      [tooltipBuilder!(location)],
    );
  }
}
