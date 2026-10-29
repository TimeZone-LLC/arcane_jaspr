library;

const String runtimeCoreJs = r'''
const ARCANE = (window.Arcane = window.Arcane || {});
ARCANE.version = '1';
ARCANE.surfaces = ARCANE.surfaces || {};
ARCANE.groups = ARCANE.groups || {};
ARCANE.tabs = ARCANE.tabs || {};
ARCANE.panels = ARCANE.panels || {};
ARCANE.stack = ARCANE.stack || [];
ARCANE.actions = ARCANE.actions || {};
ARCANE.scripts = ARCANE.scripts || {};
ARCANE.config = ARCANE.config || {
  reducedMotion: window.matchMedia &&
    window.matchMedia('(prefers-reduced-motion: reduce)').matches,
  storageKey: 'arcane.state',
  themeStorageKey: 'arcane.theme'
};

const FOCUSABLE_SELECTOR = [
  'a[href]',
  'area[href]',
  'button:not([disabled])',
  'input:not([disabled]):not([type="hidden"])',
  'select:not([disabled])',
  'textarea:not([disabled])',
  'iframe',
  'object',
  'embed',
  '[tabindex]:not([tabindex="-1"])',
  '[contenteditable="true"]'
].join(',');

function dec(s) {
  if (s == null) return '';
  try { return decodeURIComponent(s); } catch (e) { return s; }
}

function enc(s) {
  if (s == null) return '';
  try { return encodeURIComponent(s); } catch (e) { return s; }
}

function parseAction(str) {
  if (!str) return null;
  const trimmed = str.trim();
  if (!trimmed) return null;
  const parts = trimmed.split(/\s+/);
  const verb = parts[0];
  const args = parts.slice(1).map(dec);
  return { verb: verb, args: args };
}

function parseActions(str) {
  if (!str) return [];
  return str.split(';').map(parseAction).filter(Boolean);
}

function fireEvent(el, name, detail) {
  if (!el) el = document;
  const evt = new CustomEvent(name, {
    bubbles: true,
    cancelable: true,
    detail: detail || {}
  });
  el.dispatchEvent(evt);
  return evt;
}

function getFocusable(root) {
  if (!root) return [];
  const list = root.querySelectorAll(FOCUSABLE_SELECTOR);
  const out = [];
  for (let i = 0; i < list.length; i++) {
    const el = list[i];
    if (el.offsetParent === null && el.getClientRects().length === 0) continue;
    if (el.hasAttribute('disabled')) continue;
    if (el.getAttribute('aria-hidden') === 'true') continue;
    // Closed details can retain layout boxes for content that is not tabbable.
    let closedDetailsContent = false;
    for (let ancestor = el.parentElement; ancestor && root.contains(ancestor); ancestor = ancestor.parentElement) {
      if (ancestor.tagName !== 'DETAILS' || ancestor.hasAttribute('open')) continue;
      const summary = Array.from(ancestor.children).find(function(child) {
        return child.tagName === 'SUMMARY';
      });
      if (!summary || !summary.contains(el)) {
        closedDetailsContent = true;
        break;
      }
    }
    if (closedDetailsContent) continue;
    out.push(el);
  }
  return out;
}

function findClosest(el, sel) {
  if (!el) return null;
  if (el.closest) return el.closest(sel);
  let cur = el;
  while (cur && cur.nodeType === 1) {
    if (cur.matches && cur.matches(sel)) return cur;
    cur = cur.parentNode;
  }
  return null;
}

function querySurface(type, id) {
  if (!id) return null;
  const sel = '[data-arcane-surface="' + type + '"][data-arcane-id="' +
    cssEscape(id) + '"]';
  return document.querySelector(sel);
}

function querySurfaceById(id) {
  if (!id) return null;
  const sel = '[data-arcane-surface][data-arcane-id="' + cssEscape(id) + '"]';
  return document.querySelector(sel);
}

function cssEscape(value) {
  if (window.CSS && window.CSS.escape) return window.CSS.escape(value);
  return String(value).replace(/[!"#$%&'()*+,./:;<=>?@\[\\\]^`{|}~]/g, '\\$&');
}

function withinSurface(el, type) {
  return findClosest(el, '[data-arcane-surface' +
    (type ? '="' + type + '"' : '') + ']');
}

function setBoolAttr(el, name, value) {
  if (!el) return;
  if (value) el.setAttribute(name, '');
  else el.removeAttribute(name);
}

function readJson(str, fallback) {
  if (!str) return fallback;
  try { return JSON.parse(str); } catch (e) { return fallback; }
}

function debounce(fn, delay) {
  let t = null;
  return function() {
    const args = arguments;
    const ctx = this;
    if (t) clearTimeout(t);
    t = setTimeout(function() { fn.apply(ctx, args); }, delay);
  };
}

function nextFrame(fn) {
  if (window.requestAnimationFrame) {
    requestAnimationFrame(function() { requestAnimationFrame(fn); });
  } else {
    setTimeout(fn, 16);
  }
}

ARCANE.util = {
  parseAction: parseAction,
  parseActions: parseActions,
  fireEvent: fireEvent,
  getFocusable: getFocusable,
  findClosest: findClosest,
  cssEscape: cssEscape,
  querySurface: querySurface,
  querySurfaceById: querySurfaceById,
  enc: enc,
  dec: dec,
  readJson: readJson,
  debounce: debounce,
  nextFrame: nextFrame
};
''';
