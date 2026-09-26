import assert from 'node:assert/strict';
import { readFileSync, readdirSync } from 'node:fs';
import { createRequire } from 'node:module';
import { after, before, test } from 'node:test';

const require = createRequire(new URL('../../tool/browser_policy/package.json', import.meta.url));
const { chromium } = require('playwright');
const runtimeDirectory = new URL('../../lib/core/interaction/runtime/', import.meta.url);
const runtimeParts = new Map();
for (const file of readdirSync(runtimeDirectory).filter(file => file.endsWith('_js.dart'))) {
  const source = readFileSync(new URL(file, runtimeDirectory), 'utf8');
  for (const [, name, script] of source.matchAll(/const String (\w+) = r'''([\s\S]*?)''';/g)) {
    runtimeParts.set(name, script);
  }
}
const runtimeBuilder = readFileSync(new URL('runtime.dart', runtimeDirectory), 'utf8');
const runtime = [...runtimeBuilder.matchAll(/buffer\.writeln\((runtime\w+Js)\);/g)]
  .map(([, name]) => {
    assert.ok(runtimeParts.has(name), `Runtime fragment ${name} exists`);
    return runtimeParts.get(name);
  })
  .join('\n');
const commandPaletteSource = readFileSync(new URL(
  '../../lib/util/interactivity/scripts/navigation/command_palette_scripts.dart',
  import.meta.url,
), 'utf8');
const legacyCommandRuntime = commandPaletteSource.match(/static const String code = r'''([\s\S]*?)''';/)[1];

let browser;
before(async () => {
  browser = await chromium.launch({
    headless: true,
    executablePath: process.env.PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH || undefined,
  });
});
after(async () => {
  await browser?.close();
});

// A palette row for a same-tab link must announce the move with the runtime's
// cancelable `arcane:nav` event, so an app with its own router can take it
// in place; with nobody cancelling it, the row still sets `location`.
async function fixture(t, { claim }) {
  const page = await browser.newPage({ reducedMotion: 'reduce' });
  t.after(() => page.close());
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  t.after(() => assert.deepEqual(errors, [], 'Runtime does not raise browser errors'));
  page.setDefaultTimeout(3000);
  await page.setContent('<style>[hidden] { display: none !important; }</style>');
  await page.evaluate(claim => {
    window.navRequests = [];
    document.addEventListener('arcane:nav', event => {
      window.navRequests.push(event.detail.href);
      if (claim) event.preventDefault();
    });
  }, claim);
  await page.addScriptTag({ content: `(function() { 'use strict';\n${runtime}\n})();` });
  await page.addScriptTag({ content: `${legacyCommandRuntime}\nbindCommandPalettes();` });
  return page;
}

// [itemClass] picks the renderer: ShadCN rows are bound by the legacy
// palette script through `data-href`; Win95 rows only carry the runtime
// action the Dart renderer encodes.
async function openPalette(page, { overlayClass, itemClass, href, action }) {
  await page.evaluate(({ overlayClass, itemClass, href, action }) => {
    const actionAttribute = action == null ? '' : `data-arcane-action="${action}"`;
    document.body.insertAdjacentHTML('beforeend', `
      <button id="trigger" data-arcane-action="surface.open command palette">Search</button>
      <div id="palette" class="${overlayClass}" hidden
          data-arcane-surface="command" data-arcane-id="palette"
          data-arcane-state="closed">
        <input id="palette-input" data-arcane-command-input="palette">
        <div id="palette-item" class="${itemClass}" role="option" tabindex="0"
            data-arcane-command-item="true" data-label="Search all"
            data-href="${href}" ${actionAttribute}>Search all</div>
      </div>
    `);
  }, { overlayClass, itemClass, href, action });
  await page.locator('#trigger').click();
  await page.waitForFunction(() =>
    document.querySelector('#palette').getAttribute('data-arcane-state') === 'open');
}

const shadcn = {
  overlayClass: 'arcane-command-overlay',
  itemClass: 'arcane-command-item',
};
const win95 = {
  overlayClass: 'win95-command-overlay',
  itemClass: 'win95-command-item',
};

// A rendered row carries its runtime action, so the runtime dispatcher alone
// runs it: one `arcane:nav` per activation, and the surface closes through
// the runtime's own state.
test('a claimed palette row stays on the page and closes the palette', async t => {
  const page = await fixture(t, { claim: true });
  await openPalette(page, {
    ...shadcn,
    href: '/search?q=owl',
    action: 'nav.go %2Fsearch%3Fq%3Dowl;surface.close command palette',
  });
  await page.locator('#palette-item').click();
  assert.deepEqual(await page.evaluate(() => window.navRequests), ['/search?q=owl']);
  assert.equal(await page.evaluate(() => window.location.href), 'about:blank');
  await page.waitForFunction(() =>
    document.querySelector('#palette').getAttribute('data-arcane-state') === 'closed');
  assert.equal(await page.locator('#palette').isVisible(), false);
});

test('a row without a runtime action navigates through nav.go', async t => {
  const page = await fixture(t, { claim: true });
  await openPalette(page, { ...shadcn, href: '/search?q=owl', action: null });
  await page.locator('#palette-item').click();
  assert.deepEqual(await page.evaluate(() => window.navRequests), ['/search?q=owl']);
  assert.equal(await page.evaluate(() => window.location.href), 'about:blank');
  assert.equal(await page.locator('#palette').isVisible(), false);
});

test('an unclaimed palette row still sets location', async t => {
  const page = await fixture(t, { claim: false });
  await openPalette(page, {
    ...shadcn,
    href: '#palette-target',
    action: 'nav.go %23palette-target;surface.close command palette',
  });
  await page.locator('#palette-item').click();
  assert.deepEqual(await page.evaluate(() => window.navRequests), ['#palette-target']);
  await page.waitForFunction(() => window.location.hash === '#palette-target');
});

test('Enter on the palette input takes the same path as a click', async t => {
  const page = await fixture(t, { claim: true });
  await openPalette(page, {
    ...shadcn,
    href: '/search?q=owl',
    action: 'nav.go %2Fsearch%3Fq%3Dowl;surface.close command palette',
  });
  await page.locator('#palette-input').focus();
  await page.keyboard.press('Enter');
  assert.deepEqual(await page.evaluate(() => window.navRequests), ['/search?q=owl']);
  assert.equal(await page.evaluate(() => window.location.href), 'about:blank');
  await page.waitForFunction(() =>
    document.querySelector('#palette').getAttribute('data-arcane-state') === 'closed');
});

test('a row the legacy binder does not know navigates through its action', async t => {
  const page = await fixture(t, { claim: true });
  await openPalette(page, {
    ...win95,
    href: '/search?q=owl',
    action: 'nav.go %2Fsearch%3Fq%3Dowl;surface.close command palette',
  });
  await page.locator('#palette-item').click();
  assert.deepEqual(await page.evaluate(() => window.navRequests), ['/search?q=owl']);
  assert.equal(await page.evaluate(() => window.location.href), 'about:blank');
  await page.waitForFunction(() =>
    document.querySelector('#palette').getAttribute('data-arcane-state') === 'closed');
});
