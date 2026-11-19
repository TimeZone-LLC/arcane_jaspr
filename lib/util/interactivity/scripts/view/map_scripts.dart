/// Map debug mode interactivity scripts.
///
/// Handles coordinate display on hover and clipboard copy on click
/// for ArcaneMap components when Shift key is held.
class MapScripts {
  MapScripts._();

  static const String code = r'''
  // ===== MAP SHIFT+HOVER COORDINATE MODE =====
  var _shiftKeyHeld = false;
  var _mapCoordTooltips = {};
  var _mapCoordCounter = 0;

  function bindMapCoordinateMode() {
    // Track Shift key globally (only bind once)
    if (!window._arcaneShiftKeyBound) {
      window._arcaneShiftKeyBound = true;

      document.addEventListener('keydown', function(e) {
        if (e.key === 'Shift' && !_shiftKeyHeld) {
          _shiftKeyHeld = true;
          document.querySelectorAll('.arcane-world-map, .arcane-usa-map').forEach(function(map) {
            map.classList.add('arcane-map-picking');
          });
        }
      });

      document.addEventListener('keyup', function(e) {
        if (e.key === 'Shift') {
          _shiftKeyHeld = false;
          document.querySelectorAll('.arcane-world-map, .arcane-usa-map').forEach(function(map) {
            map.classList.remove('arcane-map-picking');
          });
          // Hide all coord tooltips
          Object.values(_mapCoordTooltips).forEach(function(tooltip) {
            if (tooltip) {
              tooltip.style.opacity = '0';
              tooltip.style.visibility = 'hidden';
            }
          });
        }
      });

      // Watch for new maps being added (for tabs, etc.)
      var observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
          mutation.addedNodes.forEach(function(node) {
            if (node.nodeType === 1) {
              // Check if the added node is a map or contains maps
              if (node.classList && (node.classList.contains('arcane-world-map') || node.classList.contains('arcane-usa-map'))) {
                bindSingleMap(node);
              }
              // Also check children
              if (node.querySelectorAll) {
                node.querySelectorAll('.arcane-world-map, .arcane-usa-map').forEach(function(map) {
                  bindSingleMap(map);
                });
              }
            }
          });
        });
      });
      observer.observe(document.body, { childList: true, subtree: true });
    }

    // Bind to all existing maps
    bindAllMaps();
  }

  function bindAllMaps() {
    document.querySelectorAll('.arcane-world-map, .arcane-usa-map').forEach(function(map) {
      bindSingleMap(map);
    });
  }

  function bindSingleMap(map) {
    if (map.dataset.arcaneCoordModeBound) return;
    map.dataset.arcaneCoordModeBound = 'true';
    bindMapCoordinates(map);
  }

  function bindMapCoordinates(map) {
    // Create tooltip and append to body (not map) to avoid Jaspr DOM conflicts
    var tooltip = createMapCoordTooltip();
    var mapId = 'coord-map-' + (_mapCoordCounter++);
    map.dataset.coordMapId = mapId;
    _mapCoordTooltips[mapId] = tooltip;
    document.body.appendChild(tooltip);

    // Helper to get map dimensions based on class at event time
    function getMapDimensions(mapEl) {
      var isUsa = mapEl.classList.contains('arcane-usa-map');
      return {
        width: isUsa ? 1000 : 2000,
        height: isUsa ? 589 : 857,
        latMax: isUsa ? 50 : 83,
        latRange: isUsa ? 25 : 143,
        isUsa: isUsa
      };
    }

    function calculateCoords(relX, relY, dims) {
      var svgX = relX * dims.width;
      var svgY = relY * dims.height;

      var lat, lng;
      if (dims.isUsa) {
        // USA map projection inverse
        lng = ((svgX - 50) / 900) * 58 - 125;
        lat = 50 - ((svgY - 50) / 450) * 25;
      } else {
        // World map projection (equirectangular)
        lng = (svgX / dims.width) * 360 - 180;
        lat = dims.latMax - (svgY / dims.height) * dims.latRange;
      }

      return { lat: lat, lng: lng, svgX: svgX, svgY: svgY };
    }

    map.addEventListener('mousemove', function(e) {
      if (!_shiftKeyHeld) {
        tooltip.style.opacity = '0';
        tooltip.style.visibility = 'hidden';
        return;
      }

      var dims = getMapDimensions(map);
      var rect = map.getBoundingClientRect();
      var mouseX = e.clientX - rect.left;
      var mouseY = e.clientY - rect.top;
      var relX = Math.max(0, Math.min(1, mouseX / rect.width));
      var relY = Math.max(0, Math.min(1, mouseY / rect.height));

      var coords = calculateCoords(relX, relY, dims);

      // Position tooltip fixed to viewport
      tooltip.style.position = 'fixed';
      tooltip.style.left = (e.clientX) + 'px';
      tooltip.style.top = (e.clientY + 20) + 'px';
      tooltip.style.transform = 'translateX(-50%)';
      tooltip.style.opacity = '1';
      tooltip.style.visibility = 'visible';

      // Update content
      var latEl = tooltip.querySelector('.coord-lat');
      var lngEl = tooltip.querySelector('.coord-lng');
      var svgEl = tooltip.querySelector('.coord-svg');

      if (latEl) latEl.textContent = 'Lat: ' + coords.lat.toFixed(4);
      if (lngEl) lngEl.textContent = 'Lng: ' + coords.lng.toFixed(4);
      if (svgEl) svgEl.textContent = 'SVG: ' + Math.round(coords.svgX) + ', ' + Math.round(coords.svgY);
    });

    map.addEventListener('mouseleave', function() {
      tooltip.style.opacity = '0';
      tooltip.style.visibility = 'hidden';
    });

    map.addEventListener('click', function(e) {
      // Always stop propagation and prevent default to prevent Jaspr DOM reconciliation issues
      e.stopPropagation();
      e.preventDefault();

      if (!_shiftKeyHeld) return;

      var dims = getMapDimensions(map);
      var rect = map.getBoundingClientRect();
      var relX = Math.max(0, Math.min(1, (e.clientX - rect.left) / rect.width));
      var relY = Math.max(0, Math.min(1, (e.clientY - rect.top) / rect.height));

      var coords = calculateCoords(relX, relY, dims);

      var coordText = 'Lat: ' + coords.lat.toFixed(4) + ', Lng: ' + coords.lng.toFixed(4) + ', SVG: (' + Math.round(coords.svgX) + ', ' + Math.round(coords.svgY) + ')';

      if (navigator.clipboard && navigator.clipboard.writeText) {
        navigator.clipboard.writeText(coordText).then(function() {
          showCoordCopiedFeedback(tooltip);
        }).catch(function(err) {
          console.warn('[Arcane] Clipboard write failed:', err);
          fallbackCopyToClipboard(coordText, tooltip);
        });
      } else {
        fallbackCopyToClipboard(coordText, tooltip);
      }
    }, true);
  }

  function fallbackCopyToClipboard(text, tooltip) {
    var textArea = document.createElement('textarea');
    textArea.value = text;
    textArea.style.position = 'fixed';
    textArea.style.left = '-9999px';
    document.body.appendChild(textArea);
    textArea.select();
    try {
      document.execCommand('copy');
      showCoordCopiedFeedback(tooltip);
    } catch (err) {
      console.warn('[Arcane] Fallback copy failed:', err);
    }
    document.body.removeChild(textArea);
  }

  function createMapCoordTooltip() {
    var tooltip = document.createElement('div');
    tooltip.className = 'arcane-map-coord-tooltip';
    tooltip.style.cssText = 'position: fixed; z-index: 9999; pointer-events: none; opacity: 0; visibility: hidden; transition: opacity 150ms ease;';

    var inner = document.createElement('div');
    inner.style.cssText = 'background: var(--popover); border: 1px solid var(--border); border-radius: var(--radius-sm); box-shadow: 0 4px 12px rgba(0,0,0,0.32); padding: 10px 14px;';

    var latDiv = document.createElement('div');
    latDiv.className = 'coord-lat';
    latDiv.style.cssText = 'font-size: 13px; font-family: var(--font-mono); color: var(--popover-foreground); white-space: nowrap; font-weight: 500;';
    latDiv.textContent = 'Lat: 0.0000';

    var lngDiv = document.createElement('div');
    lngDiv.className = 'coord-lng';
    lngDiv.style.cssText = 'font-size: 13px; font-family: var(--font-mono); color: var(--popover-foreground); white-space: nowrap; font-weight: 500;';
    lngDiv.textContent = 'Lng: 0.0000';

    var svgDiv = document.createElement('div');
    svgDiv.className = 'coord-svg';
    svgDiv.style.cssText = 'font-size: 11px; font-family: var(--font-mono); color: var(--muted-foreground); white-space: nowrap; margin-top: 6px;';
    svgDiv.textContent = 'SVG: 0, 0';

    var hintDiv = document.createElement('div');
    hintDiv.className = 'coord-hint';
    hintDiv.style.cssText = 'font-size: 11px; color: var(--primary); margin-top: 6px; font-weight: 500;';
    hintDiv.textContent = 'Click to copy';

    inner.appendChild(latDiv);
    inner.appendChild(lngDiv);
    inner.appendChild(svgDiv);
    inner.appendChild(hintDiv);
    tooltip.appendChild(inner);

    return tooltip;
  }

  function showCoordCopiedFeedback(tooltip) {
    var hint = tooltip.querySelector('.coord-hint');
    if (hint) {
      var original = hint.textContent;
      hint.textContent = 'Copied!';
      hint.style.color = '#22c55e';
      setTimeout(function() {
        hint.textContent = original;
        hint.style.color = '#60a5fa';
      }, 1500);
    }
  }

  // Legacy function name for backward compatibility
  function bindMapDebugMode() {
    bindMapCoordinateMode();
  }

  // ===== MAP PIN TOOLTIPS =====
  function bindMapPinTooltips() {
    // Set up observer for dynamically added maps (only once)
    if (!window._arcanePinTooltipsObserver) {
      window._arcanePinTooltipsObserver = true;
      var observer = new MutationObserver(function(mutations) {
        mutations.forEach(function(mutation) {
          mutation.addedNodes.forEach(function(node) {
            if (node.nodeType === 1 && node.querySelectorAll) {
              node.querySelectorAll('.arcane-world-map[data-has-tooltips="true"], .arcane-usa-map[data-has-tooltips="true"]').forEach(function(map) {
                if (!map.dataset.arcaneMapTooltipsBound) {
                  map.dataset.arcaneMapTooltipsBound = 'true';
                  bindPinTooltips(map);
                }
              });
              // Also bind location list items
              node.querySelectorAll('.location-list-item').forEach(function(item) {
                bindLocationListItem(item);
              });
            }
          });
        });
      });
      observer.observe(document.body, { childList: true, subtree: true });
    }

    document.querySelectorAll('.arcane-world-map[data-has-tooltips="true"], .arcane-usa-map[data-has-tooltips="true"]').forEach(function(map) {
      if (map.dataset.arcaneMapTooltipsBound) return;
      map.dataset.arcaneMapTooltipsBound = 'true';
      bindPinTooltips(map);
    });
  }

  function bindPinTooltips(map) {
    var pins = map.querySelectorAll('.arcane-map-pin[data-location]');
    pins.forEach(function(pin) {
      var locationId = pin.getAttribute('data-location');
      if (!locationId) return;

      pin.addEventListener('mouseenter', function() {
        if (_shiftKeyHeld) return;
        highlightMapPin(map, locationId);
      });

      pin.addEventListener('mouseleave', function() {
        unhighlightMapPin(map, locationId);
      });
    });
  }

  function highlightMapPin(map, locationId) {
    var pin = map.querySelector('.arcane-map-pin[data-location="' + locationId + '"]');
    var tooltip = map.querySelector('.arcane-map-tooltip[data-for-location="' + locationId + '"]');

    if (pin) {
      pin.style.transform = 'translate(-50%, -50%) scale(1.5)';
      pin.style.boxShadow = '0 0 20px 10px rgba(34, 197, 94, 0.6)';
    }
    if (tooltip) {
      tooltip.style.opacity = '1';
      tooltip.style.visibility = 'visible';
    }
  }

  function unhighlightMapPin(map, locationId) {
    var pin = map.querySelector('.arcane-map-pin[data-location="' + locationId + '"]');
    var tooltip = map.querySelector('.arcane-map-tooltip[data-for-location="' + locationId + '"]');

    if (pin) {
      pin.style.transform = 'translate(-50%, -50%) scale(1)';
      pin.style.boxShadow = '';
    }
    if (tooltip) {
      tooltip.style.opacity = '0';
      tooltip.style.visibility = 'hidden';
    }
  }

  // ===== LOCATION LIST HOVER =====
  function bindLocationListHover() {
    document.querySelectorAll('.location-list-item').forEach(function(item) {
      bindLocationListItem(item);
    });
  }

  function bindLocationListItem(item) {
    if (item.dataset.arcaneListHoverBound) return;
    item.dataset.arcaneListHoverBound = 'true';

    var itemId = item.getAttribute('id');
    var locationId = itemId ? itemId.replace('location-item-', '') : null;
    if (!locationId) return;

    item.addEventListener('mouseenter', function() {
      if (_shiftKeyHeld) return;
      // Find the closest visible map
      var mapContainer = document.querySelector('.arcane-world-map, .arcane-usa-map');
      if (!mapContainer) return;

      item.style.background = 'var(--arcane-surface-variant, rgba(255,255,255,0.05))';
      highlightMapPin(mapContainer, locationId);
    });

    item.addEventListener('mouseleave', function() {
      var mapContainer = document.querySelector('.arcane-world-map, .arcane-usa-map');
      item.style.background = '';
      if (mapContainer) {
        unhighlightMapPin(mapContainer, locationId);
      }
    });
  }
''';
}
