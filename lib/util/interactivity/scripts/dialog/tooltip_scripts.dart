/// Tooltip interactivity scripts.
class TooltipScripts {
  TooltipScripts._();

  static const String code = r'''
  var arcaneTooltipHideTimers = new WeakMap();

  function showArcaneTooltip(trigger, tooltip) {
    var pendingHide = arcaneTooltipHideTimers.get(tooltip);
    if (pendingHide) {
      clearTimeout(pendingHide);
      arcaneTooltipHideTimers.delete(tooltip);
    }

    trigger.dataset.arcaneTooltipOpen = 'true';
    tooltip.style.display = 'block';
    tooltip.style.opacity = '0';
    tooltip.style.visibility = 'hidden';
    tooltip.style.translate = '0px 0px';

    var position = trigger.dataset.tooltipPosition || 'top';
    if (position === 'top' || position === 'bottom') {
      tooltip.style.transform = 'translateX(-50%) translateY(0)';
    } else {
      tooltip.style.transform = 'translateY(-50%) translateX(0)';
    }

    // Keep the complete tooltip inside the visual viewport. Hidden absolutely
    // positioned tooltips otherwise expand the document scroll width when a
    // trigger sits near an edge.
    var viewportPadding = 8;
    var viewportWidth = document.documentElement.clientWidth;
    var viewportHeight = document.documentElement.clientHeight;
    var rect = tooltip.getBoundingClientRect();
    var shiftX = Math.max(
      viewportPadding - rect.left,
      Math.min(0, viewportWidth - viewportPadding - rect.right)
    );
    var shiftY = Math.max(
      viewportPadding - rect.top,
      Math.min(0, viewportHeight - viewportPadding - rect.bottom)
    );
    tooltip.style.translate =
      Math.round(shiftX) + 'px ' + Math.round(shiftY) + 'px';
    tooltip.style.visibility = 'visible';

    requestAnimationFrame(function() {
      if (trigger.dataset.arcaneTooltipOpen === 'true') {
        tooltip.style.opacity = '1';
      }
    });
  }

  function hideArcaneTooltip(trigger, tooltip) {
    trigger.dataset.arcaneTooltipOpen = 'false';
    tooltip.style.opacity = '0';
    tooltip.style.visibility = 'hidden';

    var pendingHide = setTimeout(function() {
      if (trigger.dataset.arcaneTooltipOpen !== 'true') {
        tooltip.style.display = 'none';
        tooltip.style.translate = '0px 0px';
      }
      arcaneTooltipHideTimers.delete(tooltip);
    }, 160);
    arcaneTooltipHideTimers.set(tooltip, pendingHide);
  }

  // One shared tooltip on <body> with delegated events: a node a renderer
  // owns is never wrapped or moved (Jaspr cannot update a moved node).
  var arcaneTip = {
    element: null,
    trigger: null,
    own: null,
    title: null,
    side: 'top',
    frame: 0,
    hideTimer: 0
  };

  // The element whose tooltip the pointer or focus at [node] asks for. Like
  // the browser, the nearest title wins; `data-no-tooltip` keeps it native.
  function arcaneTooltipTriggerOf(node) {
    var el = node && node.nodeType === 1 ? node : node && node.parentElement;
    for (; el && el !== document.documentElement; el = el.parentElement) {
      if (el === arcaneTip.trigger) return el;
      if (el.hasAttribute('title') || el.classList.contains('arcane-tooltip-trigger')) {
        return el.hasAttribute('data-no-tooltip') ? null : el;
      }
    }
    return null;
  }

  function arcaneTooltipElement() {
    if (arcaneTip.element && arcaneTip.element.isConnected) return arcaneTip.element;
    var tooltip = document.createElement('div');
    tooltip.className = 'arcane-tooltip arcane-tooltip-shared';
    tooltip.setAttribute('role', 'tooltip');
    tooltip.style.cssText = 'display: none; position: fixed; top: 0; left: 0; z-index: 9999; width: max-content; max-width: min(320px, calc(100vw - 16px)); padding: 6px 12px; font-size: 12px; font-weight: 500; line-height: 1.4; color: var(--arcane-on-surface, #f8fafc); background: var(--arcane-surface, #1e1e2e); border-radius: 8px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); white-space: normal; overflow-wrap: anywhere; pointer-events: none; opacity: 0; visibility: hidden; transition: opacity 150ms ease, visibility 150ms ease;';
    tooltip.appendChild(document.createTextNode(''));
    var arrow = document.createElement('div');
    arrow.className = 'arcane-tooltip-arrow';
    tooltip.appendChild(arrow);
    document.body.appendChild(tooltip);
    arcaneTip.element = tooltip;
    return tooltip;
  }

  // Beside the trigger on its side (flipped when that side has no room),
  // 8px away and inside the viewport, the arrow pointing at its middle.
  function arcaneTooltipPlace() {
    var tooltip = arcaneTip.element;
    var box = arcaneTip.trigger.getBoundingClientRect();
    var gap = 8;
    var pad = 8;
    var width = tooltip.offsetWidth;
    var height = tooltip.offsetHeight;
    var viewWidth = document.documentElement.clientWidth;
    var viewHeight = document.documentElement.clientHeight;
    var side = arcaneTip.side;
    if (side === 'top' && box.top - gap - height < pad && box.bottom + gap + height <= viewHeight - pad) side = 'bottom';
    else if (side === 'bottom' && box.bottom + gap + height > viewHeight - pad && box.top - gap - height >= pad) side = 'top';
    else if (side === 'left' && box.left - gap - width < pad) side = 'right';
    else if (side === 'right' && box.right + gap + width > viewWidth - pad) side = 'left';
    var across = side === 'top' || side === 'bottom';
    var x = across ? box.left + box.width / 2 - width / 2 : side === 'left' ? box.left - gap - width : box.right + gap;
    var y = across ? (side === 'top' ? box.top - gap - height : box.bottom + gap) : box.top + box.height / 2 - height / 2;
    x = Math.round(Math.max(pad, Math.min(x, viewWidth - pad - width)));
    y = Math.round(Math.max(pad, Math.min(y, viewHeight - pad - height)));
    tooltip.style.left = x + 'px';
    tooltip.style.top = y + 'px';
    var arrowAt = across
      ? Math.max(8, Math.min(box.left + box.width / 2 - x, width - 8)) - 4
      : Math.max(8, Math.min(box.top + box.height / 2 - y, height - 8)) - 4;
    var edge = { top: 'bottom', bottom: 'top', left: 'right', right: 'left' }[side];
    tooltip.lastChild.style.cssText = 'position: absolute; width: 8px; height: 8px; background: var(--arcane-surface, #1e1e2e); transform: rotate(45deg); ' +
      edge + ': -4px; ' + (across ? 'left: ' : 'top: ') + Math.round(arrowAt) + 'px;';
  }

  // Follows the trigger each frame; a title the renderer writes back is the
  // new text, one it drops stays dropped.
  function arcaneTooltipFollow() {
    arcaneTip.frame = 0;
    var trigger = arcaneTip.trigger;
    if (!trigger || arcaneTip.own) return;
    if (!trigger.isConnected || trigger.hasAttribute('data-no-tooltip')) {
      arcaneTooltipHide();
      return;
    }
    if (arcaneTip.title !== null) {
      var title = trigger.getAttribute('title');
      if (title === null) {
        arcaneTip.title = null;
        arcaneTooltipHide();
        return;
      }
      if (title !== '') {
        arcaneTip.title = title;
        trigger.setAttribute('title', '');
        arcaneTip.element.firstChild.nodeValue = title;
      }
    }
    arcaneTooltipPlace();
    arcaneTip.element.style.opacity = '1';
    arcaneTip.frame = requestAnimationFrame(arcaneTooltipFollow);
  }

  function arcaneTooltipShow(trigger) {
    if (arcaneTip.trigger === trigger) return;
    arcaneTooltipHide();
    var marked = trigger.classList.contains('arcane-tooltip-trigger');
    var own = marked ? trigger.querySelector('.arcane-tooltip') : null;
    if (own) {
      arcaneTip.trigger = trigger;
      arcaneTip.own = own;
      showArcaneTooltip(trigger, own);
      return;
    }
    var text = marked ? trigger.dataset.tooltip : trigger.getAttribute('title');
    if (!text) return;
    var tooltip = arcaneTooltipElement();
    // An empty title keeps the browser's own tip away until this one closes.
    if (trigger.hasAttribute('title')) {
      arcaneTip.title = trigger.getAttribute('title');
      trigger.setAttribute('title', '');
    }
    arcaneTip.trigger = trigger;
    arcaneTip.side = trigger.dataset.tooltipPosition || 'top';
    clearTimeout(arcaneTip.hideTimer);
    tooltip.firstChild.nodeValue = text;
    tooltip.style.display = 'block';
    tooltip.style.visibility = 'visible';
    arcaneTooltipPlace();
    arcaneTip.frame = requestAnimationFrame(arcaneTooltipFollow);
  }

  function arcaneTooltipHide() {
    var trigger = arcaneTip.trigger;
    if (!trigger) return;
    arcaneTip.trigger = null;
    if (arcaneTip.own) {
      hideArcaneTooltip(trigger, arcaneTip.own);
      arcaneTip.own = null;
      return;
    }
    if (arcaneTip.frame) cancelAnimationFrame(arcaneTip.frame);
    arcaneTip.frame = 0;
    if (arcaneTip.title !== null) {
      if (trigger.getAttribute('title') === '') trigger.setAttribute('title', arcaneTip.title);
      arcaneTip.title = null;
    }
    var tooltip = arcaneTip.element;
    tooltip.style.opacity = '0';
    tooltip.style.visibility = 'hidden';
    clearTimeout(arcaneTip.hideTimer);
    arcaneTip.hideTimer = setTimeout(function() {
      if (!arcaneTip.trigger || arcaneTip.own) tooltip.style.display = 'none';
    }, 160);
  }

  function bindTooltips() {
    if (window.arcaneTooltipsBound) return;
    window.arcaneTooltipsBound = true;

    // Pointers only: a tap is not a hover.
    document.addEventListener('pointerover', function(event) {
      if (event.pointerType === 'touch') return;
      var trigger = arcaneTooltipTriggerOf(event.target);
      if (trigger) arcaneTooltipShow(trigger);
      else if (arcaneTip.trigger && !arcaneTip.trigger.contains(document.activeElement)) arcaneTooltipHide();
    });

    document.addEventListener('pointerout', function(event) {
      var trigger = arcaneTip.trigger;
      if (!trigger || event.pointerType === 'touch') return;
      if (event.relatedTarget && trigger.contains(event.relatedTarget)) return;
      if (trigger.contains(document.activeElement) && document.activeElement.matches(':focus-visible')) return;
      arcaneTooltipHide();
    });

    document.addEventListener('focusin', function(event) {
      var target = event.target;
      if (!target || !target.matches || !target.matches(':focus-visible')) return;
      var trigger = arcaneTooltipTriggerOf(target);
      if (trigger) arcaneTooltipShow(trigger);
    });

    document.addEventListener('focusout', function(event) {
      var trigger = arcaneTip.trigger;
      if (trigger && trigger.contains(event.target) && !trigger.contains(event.relatedTarget)) arcaneTooltipHide();
    });

    document.addEventListener('keydown', function(event) {
      if (event.key === 'Escape') arcaneTooltipHide();
    });
  }
''';
}
