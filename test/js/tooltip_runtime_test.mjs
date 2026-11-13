import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import vm from 'node:vm';

const source = readFileSync(
  new URL(
    '../../lib/util/interactivity/scripts/dialog/tooltip_scripts.dart',
    import.meta.url,
  ),
  'utf8',
);
const quotes = "'".repeat(3);
const marker = `static const String code = r${quotes}`;
const start = source.indexOf(marker) + marker.length;
const end = source.lastIndexOf(`${quotes};`);

assert.ok(start >= marker.length, 'Dart raw JavaScript start marker is present');
assert.ok(end > start, 'Dart raw JavaScript end marker is present');

const script = source.slice(start, end);
const context = vm.createContext({});
vm.runInContext(script, context);

test('the checked-in tooltip runtime parses and exposes its shared helpers', () => {
  assert.equal(typeof context.showArcaneTooltip, 'function');
  assert.equal(typeof context.hideArcaneTooltip, 'function');
  assert.equal(typeof context.bindTooltips, 'function');
  assert.equal(typeof context.arcaneTooltipShow, 'function');
  assert.equal(typeof context.arcaneTooltipHide, 'function');
});

test('titled nodes stay where their renderer put them', () => {
  // Only the shared tooltip is built and attached; no trigger is wrapped,
  // moved or given children.
  assert.doesNotMatch(script, /insertBefore|replaceWith|\.before\(|\.after\(/);
  const appends = script.match(/\b[\w.]+\.appendChild\(/g) ?? [];
  assert.deepEqual(
    [...new Set(appends)].sort(),
    ['document.body.appendChild(', 'tooltip.appendChild('],
  );
});

test('hidden tooltips leave layout and visible tooltips clamp to the viewport', () => {
  assert.match(script, /display: none/);
  assert.match(script, /width: max-content/);
  assert.match(script, /document\.documentElement\.clientWidth/);
  assert.match(script, /document\.documentElement\.clientHeight/);
  assert.match(script, /tooltip\.style\.translate/);
});

test('legacy tooltips support keyboard focus and Escape dismissal', () => {
  assert.match(script, /addEventListener\('focusin'/);
  assert.match(script, /addEventListener\('focusout'/);
  assert.match(script, /event\.key === 'Escape'/);
});
