/// Popover and hovercard interactivity scripts.
class PopoverScripts {
  PopoverScripts._();

  static const String code = r'''
  // Track if global click listener is already added
  var _popoverGlobalListenerAdded = false;
  var _activePopovers = new Set();

  function bindPopovers() {
    // Only target actual floating containers, not generic position:relative elements
    document.querySelectorAll('.arcane-floating-container, .neon-floating-container').forEach(function(container) {
      // Use the trigger class to find the trigger, not firstElementChild
      var trigger = container.querySelector('.arcane-floating-trigger') || container.firstElementChild;
      var popup = container.querySelector('.arcane-floating-content, .arcane-floating-tooltip, [style*="position: absolute"][style*="z-index"]');
      if (!trigger || !popup || container.dataset.arcanePopoverInteractive) return;
      // Hover cards, tooltips and popovers rendered as runtime surfaces open
      // through the interaction runtime and their own Dart state; binding
      // them here as well swallowed their clicks.
      if (popup.hasAttribute('data-arcane-surface')) return;
      container.dataset.arcanePopoverInteractive = 'true';

      var isClick = !popup.closest('.arcane-hovercard');

      if (isClick) {
        trigger.addEventListener('click', function(e) {
          e.stopPropagation();
          var isVisible = popup.style.opacity === '1';
          popup.style.opacity = isVisible ? '0' : '1';
          popup.style.visibility = isVisible ? 'hidden' : 'visible';
          popup.style.pointerEvents = isVisible ? 'none' : 'auto';
          if (!isVisible) {
            _activePopovers.add(container);
          } else {
            _activePopovers.delete(container);
          }
        });

        // Add global listener only once
        if (!_popoverGlobalListenerAdded) {
          _popoverGlobalListenerAdded = true;
          document.addEventListener('click', function(e) {
            _activePopovers.forEach(function(cont) {
              if (!cont.contains(e.target)) {
                var pop = cont.querySelector('.arcane-floating-content, .arcane-floating-tooltip, [style*="position: absolute"][style*="z-index"]');
                if (pop) {
                  pop.style.opacity = '0';
                  pop.style.visibility = 'hidden';
                  pop.style.pointerEvents = 'none';
                }
                _activePopovers.delete(cont);
              }
            });
          });
        }
      } else {
        container.addEventListener('mouseenter', function() {
          popup.style.opacity = '1';
          popup.style.visibility = 'visible';
        });
        container.addEventListener('mouseleave', function() {
          popup.style.opacity = '0';
          popup.style.visibility = 'hidden';
        });
      }
    });
  }
''';
}
