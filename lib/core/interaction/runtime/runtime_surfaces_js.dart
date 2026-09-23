library;

const String runtimeSurfacesJs = r'''
function surfaceState(el) {
  if (!el) return 'closed';
  return el.getAttribute('data-arcane-state') || 'closed';
}

function surfaceIsOpen(el) {
  return surfaceState(el) === 'open';
}

function surfaceType(el) {
  if (!el) return null;
  return el.getAttribute('data-arcane-surface');
}

function surfaceId(el) {
  if (!el) return null;
  return el.getAttribute('data-arcane-id');
}

function surfaceGroup(el) {
  if (!el) return null;
  return el.getAttribute('data-arcane-surface-group');
}

function trapFocus(surface, e) {
  if (!surface) return;
  if (surface.getAttribute('data-arcane-focus-trap') === 'false') return;
  const focusable = getFocusable(surface);
  if (focusable.length === 0) {
    e.preventDefault();
    if (!surface.hasAttribute('tabindex')) surface.setAttribute('tabindex', '-1');
    surface.focus();
    return;
  }
  const first = focusable[0];
  const last = focusable[focusable.length - 1];
  if (e.shiftKey) {
    if (document.activeElement === first || focusable.indexOf(document.activeElement) < 0) {
      e.preventDefault();
      last.focus();
    }
  } else {
    if (document.activeElement === last || focusable.indexOf(document.activeElement) < 0) {
      e.preventDefault();
      first.focus();
    }
  }
}

function syncSurfaceStack() {
  const previousTop = ARCANE.stack[ARCANE.stack.length - 1];
  ARCANE.stack = ARCANE.stack.filter(function(entry) {
    if (entry.el.isConnected && surfaceIsOpen(entry.el)) return true;
    if (entry.el._arcaneAnchorReposition) {
      window.removeEventListener('resize', entry.el._arcaneAnchorReposition);
      window.removeEventListener('scroll', entry.el._arcaneAnchorReposition, true);
      entry.el._arcaneAnchorReposition = null;
    }
    return false;
  });

  const opens = document.querySelectorAll('[data-arcane-surface][data-arcane-state="open"]');
  for (let i = 0; i < opens.length; i++) {
    const el = opens[i];
    if (surfaceIsOpen(el) && !ARCANE.stack.some(function(entry) { return entry.el === el; })) {
      openSurface(surfaceType(el), surfaceId(el));
    }
  }

  const hasOverlay = ARCANE.stack.some(function(entry) {
    return entry.type === 'dialog' || entry.type === 'sheet' || entry.type === 'drawer';
  });
  document.body.classList.toggle('arcane-overlay-open', hasOverlay);
  if (hasOverlay) document.body.setAttribute('data-arcane-overlay-open', 'true');
  else document.body.removeAttribute('data-arcane-overlay-open');

  if (previousTop && !ARCANE.stack.some(function(entry) { return entry.el === previousTop.el; })) {
    const el = previousTop.el;
    const target = el._arcanePrevFocus;
    const top = ARCANE.stack[ARCANE.stack.length - 1];
    if (el.getAttribute('data-arcane-restore-focus') !== 'false' &&
        target && target.isConnected && (!top || top.el.contains(target))) {
      target.focus({ preventScroll: true });
    }
    el._arcanePrevFocus = null;
  }
}

function observeSurfaces() {
  if (ARCANE._surfaceObserver) return;
  ARCANE._surfaceObserver = new MutationObserver(function(records) {
    const changed = records.some(function(record) {
      if (record.type === 'attributes') return record.target.hasAttribute('data-arcane-surface');
      const nodes = Array.from(record.addedNodes).concat(Array.from(record.removedNodes));
      return nodes.some(function(node) {
        return node.nodeType === 1 && (node.hasAttribute('data-arcane-surface') ||
          node.querySelector('[data-arcane-surface]'));
      });
    });
    if (changed) syncSurfaceStack();
  });
  ARCANE._surfaceObserver.observe(document.body, {
    childList: true,
    subtree: true,
    attributes: true,
    attributeFilter: ['data-arcane-state']
  });
}

function applyAnchor(surfaceEl) {
  if (!surfaceEl) return;
  const anchorId = surfaceEl.getAttribute('data-arcane-anchor');
  if (!anchorId) return;
  const anchorEl = document.querySelector(
    '[data-arcane-anchor-id="' + cssEscape(anchorId) + '"]'
  );
  if (!anchorEl) return;
  positionAnchored(surfaceEl, anchorEl);
}

function positionAnchored(surfaceEl, anchorEl) {
  const placement = surfaceEl.getAttribute('data-arcane-anchor-placement') || 'bottom';
  const align = surfaceEl.getAttribute('data-arcane-anchor-align') || 'start';
  const offset = parseInt(
    surfaceEl.getAttribute('data-arcane-anchor-offset') || '8', 10
  );
  const rect = anchorEl.getBoundingClientRect();
  const sw = surfaceEl.offsetWidth;
  const sh = surfaceEl.offsetHeight;
  const vw = window.innerWidth;
  const vh = window.innerHeight;
  let top = 0;
  let left = 0;

  let actualPlacement = placement;
  if (placement === 'bottom' && rect.bottom + offset + sh > vh && rect.top - offset - sh > 0) {
    actualPlacement = 'top';
  } else if (placement === 'top' && rect.top - offset - sh < 0 && rect.bottom + offset + sh < vh) {
    actualPlacement = 'bottom';
  } else if (placement === 'right' && rect.right + offset + sw > vw && rect.left - offset - sw > 0) {
    actualPlacement = 'left';
  } else if (placement === 'left' && rect.left - offset - sw < 0 && rect.right + offset + sw < vw) {
    actualPlacement = 'right';
  }

  if (actualPlacement === 'bottom') {
    top = rect.bottom + offset;
    left = align === 'end' ? rect.right - sw : (align === 'center' ? rect.left + (rect.width - sw) / 2 : rect.left);
  } else if (actualPlacement === 'top') {
    top = rect.top - sh - offset;
    left = align === 'end' ? rect.right - sw : (align === 'center' ? rect.left + (rect.width - sw) / 2 : rect.left);
  } else if (actualPlacement === 'right') {
    left = rect.right + offset;
    top = align === 'end' ? rect.bottom - sh : (align === 'center' ? rect.top + (rect.height - sh) / 2 : rect.top);
  } else if (actualPlacement === 'left') {
    left = rect.left - sw - offset;
    top = align === 'end' ? rect.bottom - sh : (align === 'center' ? rect.top + (rect.height - sh) / 2 : rect.top);
  }

  if (left < 4) left = 4;
  if (top < 4) top = 4;
  if (left + sw > vw - 4) left = vw - sw - 4;
  if (top + sh > vh - 4) top = vh - sh - 4;

  if (!surfaceEl._arcaneAnchorInlineStyle) {
    surfaceEl._arcaneAnchorInlineStyle = {
      position: surfaceEl.style.position,
      top: surfaceEl.style.top,
      left: surfaceEl.style.left,
      width: surfaceEl.style.width,
      minWidth: surfaceEl.style.minWidth
    };
  }
  surfaceEl.style.position = 'fixed';
  surfaceEl.style.width = sw + 'px';
  surfaceEl.style.minWidth = sw + 'px';
  surfaceEl.style.top = top + 'px';
  surfaceEl.style.left = left + 'px';
  surfaceEl.setAttribute('data-arcane-actual-placement', actualPlacement);
}

function openSurface(type, id, opts) {
  opts = opts || {};
  const el = querySurface(type, id);
  if (!el) return false;
  if (surfaceIsOpen(el) && ARCANE.stack.some(function(entry) { return entry.el === el; })) return true;

  const groupName = surfaceGroup(el);
  const exclusive = el.getAttribute('data-arcane-exclusive') === 'true';
  if (groupName) {
    const peers = document.querySelectorAll(
      '[data-arcane-surface-group="' + cssEscape(groupName) + '"][data-arcane-state="open"]'
    );
    for (let i = 0; i < peers.length; i++) {
      if (peers[i] !== el) {
        closeSurface(surfaceType(peers[i]), surfaceId(peers[i]), { silent: true });
      }
    }
  }

  if (exclusive) {
    const all = document.querySelectorAll(
      '[data-arcane-surface="' + type + '"][data-arcane-state="open"]'
    );
    for (let i = 0; i < all.length; i++) {
      if (all[i] !== el) closeSurface(type, surfaceId(all[i]), { silent: true });
    }
  }

  if (opts.trigger) {
    el._arcanePrevFocus = opts.trigger;
  } else {
    el._arcanePrevFocus = document.activeElement;
  }

  el.removeAttribute('hidden');
  el.setAttribute('data-arcane-state', 'open');
  el.setAttribute('aria-hidden', 'false');

  const anchorId = el.getAttribute('data-arcane-anchor');
  if (anchorId) {
    const anchorEl = document.querySelector(
      '[data-arcane-anchor-id="' + cssEscape(anchorId) + '"]'
    );
    if (anchorEl && anchorEl.hasAttribute('aria-expanded')) {
      anchorEl.setAttribute('aria-expanded', 'true');
    }
  }

  applyAnchor(el);

  ARCANE.stack.push({ type: type, id: id, el: el });

  if (type === 'dialog' || type === 'sheet' || type === 'drawer') {
    document.body.classList.add('arcane-overlay-open');
    document.body.setAttribute('data-arcane-overlay-open', 'true');
  }

  nextFrame(function() {
    if (!el.isConnected || !surfaceIsOpen(el) ||
        ARCANE.stack[ARCANE.stack.length - 1]?.el !== el) return;
    el.classList.add('arcane-surface-open');
    el.classList.remove('arcane-surface-closing');

    const focusTarget = el.querySelector('[data-arcane-autofocus]') ||
      getFocusable(el)[0];
    if (focusTarget) {
      if (!focusTarget.hasAttribute('tabindex') && focusTarget.tabIndex < 0) {
        focusTarget.setAttribute('tabindex', '-1');
      }
      try { focusTarget.focus({ preventScroll: false }); } catch (e) { focusTarget.focus(); }
    } else {
      if (!el.hasAttribute('tabindex')) el.setAttribute('tabindex', '-1');
      el.focus();
    }
  });

  fireEvent(el, 'arcane:open', { type: type, id: id });
  fireEvent(document, 'arcane:surface-open', { type: type, id: id });

  if (!opts.skipAnchorListener && el.getAttribute('data-arcane-anchor')) {
    el._arcaneAnchorReposition = function() { applyAnchor(el); };
    window.addEventListener('resize', el._arcaneAnchorReposition);
    window.addEventListener('scroll', el._arcaneAnchorReposition, true);
  }

  return true;
}

function closeSurface(type, id, opts) {
  opts = opts || {};
  let el;
  if (id) {
    el = querySurface(type, id);
  } else {
    const list = document.querySelectorAll(
      '[data-arcane-surface="' + type + '"][data-arcane-state="open"]'
    );
    if (list.length > 0) el = list[list.length - 1];
  }
  if (!el) return false;
  if (!surfaceIsOpen(el)) return false;

  el.setAttribute('data-arcane-state', 'closed');
  el.setAttribute('aria-hidden', 'true');
  el.classList.remove('arcane-surface-open');
  el.classList.add('arcane-surface-closing');

  const anchorId = el.getAttribute('data-arcane-anchor');
  if (anchorId) {
    const anchorEl = document.querySelector(
      '[data-arcane-anchor-id="' + cssEscape(anchorId) + '"]'
    );
    if (anchorEl && anchorEl.hasAttribute('aria-expanded')) {
      anchorEl.setAttribute('aria-expanded', 'false');
    }
  }

  ARCANE.stack = ARCANE.stack.filter(function(entry) {
    return entry.el !== el;
  });

  const stillOpen = document.querySelectorAll(
    '[data-arcane-surface="dialog"][data-arcane-state="open"], ' +
    '[data-arcane-surface="sheet"][data-arcane-state="open"], ' +
    '[data-arcane-surface="drawer"][data-arcane-state="open"]'
  ).length;
  if (stillOpen === 0) {
    document.body.classList.remove('arcane-overlay-open');
    document.body.removeAttribute('data-arcane-overlay-open');
  }

  if (el._arcaneAnchorReposition) {
    window.removeEventListener('resize', el._arcaneAnchorReposition);
    window.removeEventListener('scroll', el._arcaneAnchorReposition, true);
    el._arcaneAnchorReposition = null;
  }

  const restoreFocus = el.getAttribute('data-arcane-restore-focus') !== 'false';
  const prevFocus = el._arcanePrevFocus;

  const finalize = function() {
    if (surfaceIsOpen(el)) return;
    el.setAttribute('hidden', '');
    el.classList.remove('arcane-surface-closing');
    const inlineStyle = el._arcaneAnchorInlineStyle;
    el.style.position = inlineStyle ? inlineStyle.position : '';
    el.style.top = inlineStyle ? inlineStyle.top : '';
    el.style.left = inlineStyle ? inlineStyle.left : '';
    el.style.width = inlineStyle ? inlineStyle.width : '';
    el.style.minWidth = inlineStyle ? inlineStyle.minWidth : '';
    el._arcaneAnchorInlineStyle = null;
    el.removeAttribute('data-arcane-actual-placement');
    if (restoreFocus && prevFocus && prevFocus.focus) {
      try { prevFocus.focus({ preventScroll: true }); } catch (e) { prevFocus.focus(); }
    }
    el._arcanePrevFocus = null;
  };

  if (ARCANE.config.reducedMotion || opts.immediate) {
    finalize();
  } else {
    const cs = window.getComputedStyle(el);
    const dur = parseFloat(cs.transitionDuration || '0') || 0;
    if (dur > 0) {
      let done = false;
      const handler = function() {
        if (done) return;
        done = true;
        el.removeEventListener('transitionend', handler);
        finalize();
      };
      el.addEventListener('transitionend', handler);
      setTimeout(handler, dur * 1000 + 100);
    } else {
      finalize();
    }
  }

  if (!opts.silent) {
    fireEvent(el, 'arcane:close', { type: type, id: id });
    fireEvent(document, 'arcane:surface-close', { type: type, id: id });
  }
  return true;
}

function toggleSurface(type, id, opts) {
  const el = querySurface(type, id);
  if (!el) return false;
  if (surfaceIsOpen(el)) return closeSurface(type, id, opts);
  return openSurface(type, id, opts);
}

function dismissTopSurface() {
  if (ARCANE.stack.length === 0) return false;
  const top = ARCANE.stack[ARCANE.stack.length - 1];
  return closeSurface(top.type, top.id);
}

ARCANE.surfaces.open = openSurface;
ARCANE.surfaces.close = closeSurface;
ARCANE.surfaces.toggle = toggleSurface;
ARCANE.surfaces.dismissTop = dismissTopSurface;
ARCANE.surfaces.applyAnchor = applyAnchor;
''';
