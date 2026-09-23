/// Command palette interactivity scripts.
class CommandPaletteScripts {
  CommandPaletteScripts._();

  static const String code = r'''
  function bindCommandPalettes() {
    // Guard against multiple bindings
    if (window.__arcaneCommandBound) return;
    window.__arcaneCommandBound = true;

    // Track selection state per overlay
    var selectedIndices = new WeakMap();

    // Inject hover/selected CSS styles if not already present
    if (!document.getElementById('arcane-command-styles')) {
      var style = document.createElement('style');
      style.id = 'arcane-command-styles';
      style.textContent = '\
        .arcane-command-item:hover:not(.disabled),\
        .neon-command-item:hover:not(.disabled) {\
          background-color: var(--accent, var(--secondary, rgba(255,255,255,0.1)));\
        }\
        .arcane-command-item.selected:not(.disabled),\
        .neon-command-item.selected:not(.disabled) {\
          background-color: var(--accent, var(--secondary, rgba(255,255,255,0.1)));\
          outline: 2px solid var(--ring, var(--primary, #3b82f6));\
          outline-offset: -2px;\
        }\
        .arcane-command-item.js-hidden,\
        .neon-command-item.js-hidden,\
        .arcane-command-group-heading.js-hidden,\
        .neon-command-group-heading.js-hidden {\
          display: none !important;\
        }\
      ';
      document.head.appendChild(style);
    }

    // Helper to find the overlay from any target
    function findOverlay(target) {
      return target.closest('.arcane-command-overlay, .neon-command-overlay');
    }

    // Helper to get current visible items in an overlay
    function getVisibleItems(overlay) {
      var allItems = overlay.querySelectorAll('.arcane-command-item:not(.disabled):not(.js-hidden), .neon-command-item:not(.disabled):not(.js-hidden)');
      return Array.from(allItems).filter(function(item) {
        return item.offsetParent !== null;
      });
    }

    // Get/set selected index for an overlay
    function getSelectedIndex(overlay) {
      return selectedIndices.get(overlay) || -1;
    }
    function setSelectedIndex(overlay, index) {
      selectedIndices.set(overlay, index);
    }

    function updateSelection(overlay, items) {
      var selectedIndex = getSelectedIndex(overlay);
      overlay.querySelectorAll('.arcane-command-item, .neon-command-item').forEach(function(item) {
        item.classList.remove('selected');
      });
      if (selectedIndex >= 0 && items[selectedIndex]) {
        items[selectedIndex].classList.add('selected');
        items[selectedIndex].scrollIntoView({ block: 'nearest' });
      }
    }

    // Close overlay helper
    function closeOverlay(overlay) {
      if (!overlay) return;
      overlay.style.display = 'none';
      setSelectedIndex(overlay, -1);
      // Dispatch custom event for Jaspr to handle state update
      overlay.dispatchEvent(new CustomEvent('arcane-command-close', { bubbles: true }));
    }

    // Handle item click - navigate via data-href
    function handleItemClick(item, overlay) {
      var href = item.dataset.href;
      var target = item.dataset.target;
      if (href) {
        if (target === '_blank') {
          window.open(href, '_blank', 'noopener,noreferrer');
        } else {
          window.location.href = href;
        }
        closeOverlay(overlay);
      }
    }

    // Filter items based on search query
    function filterItems(overlay, query) {
      var list = overlay.querySelector('.arcane-command-list, .neon-command-list');
      if (!list) return;

      var q = query.toLowerCase().trim();

      // Get all children of the list (headings and items are siblings)
      var children = Array.from(list.children);

      // First pass: filter all items
      children.forEach(function(child) {
        if (child.classList.contains('arcane-command-item') || child.classList.contains('neon-command-item')) {
          if (!q) {
            child.classList.remove('js-hidden');
            return;
          }
          var label = (child.dataset.label || '').toLowerCase();
          var keywords = (child.dataset.keywords || '').toLowerCase();
          var matches = label.includes(q) || keywords.includes(q);
          child.classList.toggle('js-hidden', !matches);
        }
      });

      // Second pass: hide headings that have no visible items following them
      var currentHeading = null;
      var hasVisibleItems = false;

      children.forEach(function(child, index) {
        var isHeading = child.classList.contains('arcane-command-group-heading') ||
                        child.classList.contains('neon-command-group-heading');
        var isItem = child.classList.contains('arcane-command-item') ||
                     child.classList.contains('neon-command-item');

        if (isHeading) {
          // Before processing new heading, finalize the previous one
          if (currentHeading) {
            if (!q) {
              currentHeading.classList.remove('js-hidden');
            } else {
              currentHeading.classList.toggle('js-hidden', !hasVisibleItems);
            }
          }
          // Start tracking new heading
          currentHeading = child;
          hasVisibleItems = false;
        } else if (isItem && currentHeading) {
          // Check if this item is visible
          if (!child.classList.contains('js-hidden')) {
            hasVisibleItems = true;
          }
        }
      });

      // Finalize the last heading
      if (currentHeading) {
        if (!q) {
          currentHeading.classList.remove('js-hidden');
        } else {
          currentHeading.classList.toggle('js-hidden', !hasVisibleItems);
        }
      }
    }

    // Auto-focus input when overlay appears
    function focusCommandInput(overlay) {
      if (!overlay) return;
      var input = overlay.querySelector('.arcane-command-input, .neon-command-input');
      if (input) {
        setTimeout(function() {
          input.focus();
        }, 50);
      }
    }

    // Watch for overlay appearance using MutationObserver
    var observer = new MutationObserver(function(mutations) {
      mutations.forEach(function(mutation) {
        mutation.addedNodes.forEach(function(node) {
          if (node.nodeType === 1) {
            // Check if the added node is an overlay or contains one
            if (node.classList && (node.classList.contains('arcane-command-overlay') ||
                                   node.classList.contains('neon-command-overlay'))) {
              focusCommandInput(node);
            } else if (node.querySelector) {
              var overlay = node.querySelector('.arcane-command-overlay, .neon-command-overlay');
              if (overlay) {
                focusCommandInput(overlay);
              }
            }
          }
        });
      });
    });

    observer.observe(document.body, { childList: true, subtree: true });

    // Also focus any existing overlay on page load
    var existingOverlay = document.querySelector('.arcane-command-overlay, .neon-command-overlay');
    if (existingOverlay && existingOverlay.style.display !== 'none') {
      focusCommandInput(existingOverlay);
    }

    // Document-level click handler (works for dynamically rendered overlays)
    document.addEventListener('click', function(e) {
      var overlay = findOverlay(e.target);

      // Handle item clicks
      var item = e.target.closest('.arcane-command-item, .neon-command-item');
      if (item && overlay && !item.classList.contains('disabled')) {
        e.preventDefault();
        e.stopPropagation();
        handleItemClick(item, overlay);
        return;
      }

      // Handle click-outside to close
      var anyOverlay = document.querySelector('.arcane-command-overlay, .neon-command-overlay');
      if (anyOverlay && anyOverlay.style.display !== 'none') {
        var dialog = anyOverlay.querySelector('.arcane-command-dialog, .neon-command-dialog');
        if (anyOverlay.dataset.commandClosable === 'true') {
          if (!dialog || !dialog.contains(e.target)) {
            closeOverlay(anyOverlay);
          }
        }
      }
    }, true); // Capture phase

    // Document-level mouseover for hover selection
    document.addEventListener('mouseover', function(e) {
      var item = e.target.closest('.arcane-command-item, .neon-command-item');
      if (!item) return;
      var overlay = findOverlay(item);
      if (!overlay) return;
      if (item.classList.contains('disabled') || item.classList.contains('js-hidden')) return;

      var items = getVisibleItems(overlay);
      var idx = items.indexOf(item);
      if (idx >= 0) {
        setSelectedIndex(overlay, idx);
        updateSelection(overlay, items);
      }
    });

    // Document-level keyboard handler (works for dynamically rendered overlays)
    document.addEventListener('keydown', function(e) {
      var overlay = document.querySelector('.arcane-command-overlay, .neon-command-overlay');
      if (overlay && overlay.hasAttribute('data-arcane-surface')) return;
      if (!overlay || overlay.style.display === 'none') {
        // Only handle Ctrl+K when no overlay is open
        if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
          e.preventDefault();
          e.stopPropagation();
          var trigger = document.querySelector('[data-command-trigger]');
          if (trigger) {
            trigger.click();
          }
        }
        return;
      }

      var items = getVisibleItems(overlay);
      var selectedIndex = getSelectedIndex(overlay);

      if (e.key === 'ArrowDown') {
        e.preventDefault();
        e.stopPropagation();
        if (items.length > 0) {
          selectedIndex = selectedIndex < 0 ? 0 : Math.min(selectedIndex + 1, items.length - 1);
          setSelectedIndex(overlay, selectedIndex);
          updateSelection(overlay, items);
        }
      } else if (e.key === 'ArrowUp') {
        e.preventDefault();
        e.stopPropagation();
        if (items.length > 0) {
          selectedIndex = Math.max(selectedIndex - 1, 0);
          setSelectedIndex(overlay, selectedIndex);
          updateSelection(overlay, items);
        }
      } else if (e.key === 'Enter') {
        e.preventDefault();
        e.stopPropagation();
        if (selectedIndex >= 0 && items[selectedIndex]) {
          handleItemClick(items[selectedIndex], overlay);
        } else if (items.length > 0) {
          handleItemClick(items[0], overlay);
        }
      } else if (e.key === 'Escape') {
        e.preventDefault();
        e.stopPropagation();
        closeOverlay(overlay);
      }
    }, true); // Capture phase

    // Document-level input handler for search filtering
    document.addEventListener('input', function(e) {
      var input = e.target;
      if (!input.classList.contains('arcane-command-input') && !input.classList.contains('neon-command-input')) return;
      var overlay = findOverlay(input);
      if (!overlay) return;

      setSelectedIndex(overlay, -1);
      filterItems(overlay, input.value);
    });
  }
''';
}
