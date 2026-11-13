import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import vm from 'node:vm';

const source = readFileSync(
  new URL(
    '../../lib/core/interaction/runtime/runtime_surfaces_js.dart',
    import.meta.url,
  ),
  'utf8',
);
const start = source.indexOf('function positionAnchored(');
const end = source.indexOf('\nfunction ', start + 1);
assert.ok(start >= 0 && end > start, 'positionAnchored is present');

const context = vm.createContext({
  window: { innerWidth: 1280, innerHeight: 1000 },
  document: {
    querySelector(selector) {
      return selector === '#page' ? { getBoundingClientRect: () => ({ top: 48 }) } : null;
    },
  },
});
vm.runInContext(source.slice(start, end), context);

function surface(attributes, width, height) {
  return {
    offsetWidth: width,
    offsetHeight: height,
    style: {},
    attributes: { ...attributes },
    getAttribute(name) {
      return name in this.attributes ? this.attributes[name] : null;
    },
    setAttribute(name, value) {
      this.attributes[name] = value;
    },
  };
}

test('an in-flow surface that pushes its anchor is placed from the settled anchor', () => {
  // A centred parent holds the trigger at y=100 while the closed-but-measured
  // menu is still in flow, and re-centres it to y=150 once the menu is fixed.
  const menu = surface(
    { 'data-arcane-anchor-placement': 'bottom', 'data-arcane-anchor-offset': '4' },
    160,
    120,
  );
  const anchor = {
    getBoundingClientRect() {
      const top = menu.style.position === 'fixed' ? 150 : 100;
      return { top, bottom: top + 36, left: 400, right: 508, width: 108, height: 36 };
    },
  };

  context.positionAnchored(menu, anchor);

  assert.equal(menu.style.position, 'fixed');
  assert.equal(menu.style.top, `${150 + 36 + 4}px`);
  assert.equal(menu.style.left, '400px');
  assert.equal(menu.style.width, '160px');
});

test('a surface whose anchor scrolled under a top bar stays below the named element', () => {
  const holder = { getAttribute: (name) => (name === 'data-arcane-anchor-top' ? '#page' : null) };
  const menu = surface({ 'data-arcane-anchor-placement': 'bottom', 'data-arcane-anchor-offset': '4' }, 160, 120);
  menu.closest = (selector) => (selector === '[data-arcane-anchor-top]' ? holder : null);
  const anchor = {
    getBoundingClientRect() {
      return { top: -80, bottom: -44, left: 400, right: 508, width: 108, height: 36 };
    },
  };

  context.positionAnchored(menu, anchor);

  assert.equal(menu.style.top, `${48 + 4}px`);
});

test('without the attribute a surface is kept 4 px inside the window', () => {
  const menu = surface({ 'data-arcane-anchor-placement': 'bottom', 'data-arcane-anchor-offset': '4' }, 160, 120);
  menu.closest = () => null;
  const anchor = {
    getBoundingClientRect() {
      return { top: -80, bottom: -44, left: 400, right: 508, width: 108, height: 36 };
    },
  };

  context.positionAnchored(menu, anchor);

  assert.equal(menu.style.top, '4px');
});

test('a border-box surface is pinned at its width rounded up, not down', () => {
  const sizing = { boxSizing: 'border-box', width: '216.4px' };
  const measured = vm.createContext({
    window: { innerWidth: 1280, innerHeight: 1000, getComputedStyle: () => sizing },
    document: { querySelector: () => null },
  });
  vm.runInContext(source.slice(start, end), measured);
  const menu = surface({ 'data-arcane-anchor-placement': 'bottom', 'data-arcane-anchor-offset': '4' }, 216, 120);
  const anchor = {
    getBoundingClientRect() {
      return { top: 0, bottom: 36, left: 400, right: 508, width: 108, height: 36 };
    },
  };

  measured.positionAnchored(menu, anchor);

  assert.equal(menu.style.width, '217px');
  assert.equal(menu.style.minWidth, '217px');
});
