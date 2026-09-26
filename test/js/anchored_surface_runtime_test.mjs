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

const context = vm.createContext({ window: { innerWidth: 1280, innerHeight: 1000 } });
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
