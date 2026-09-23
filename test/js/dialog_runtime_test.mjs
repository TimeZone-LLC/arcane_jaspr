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
assert.ok(runtime.includes('function arcaneInit()'));
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

async function fixture(t) {
  const page = await browser.newPage({ reducedMotion: 'reduce' });
  t.after(() => page.close());
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  t.after(() => assert.deepEqual(errors, [], 'Runtime does not raise browser errors'));
  page.setDefaultTimeout(3000);
  await page.setContent(`
    <style>[hidden] { display: none !important; }</style>
    <button id="trigger">Open editor</button>
    <button id="outside">Background action</button>
  `);
  await page.addScriptTag({ content: `(function() { 'use strict';\n${runtime}\n})();` });
  await page.locator('#trigger').focus();
  return page;
}

async function addDialog(page, id, { state = 'open', escape = true, empty = false } = {}) {
  await page.evaluate(({ id, state, escape, empty }) => {
    const dialog = document.createElement('div');
    dialog.id = id;
    dialog.tabIndex = -1;
    dialog.setAttribute('role', 'dialog');
    dialog.setAttribute('data-arcane-surface', 'dialog');
    dialog.setAttribute('data-arcane-id', id);
    dialog.setAttribute('data-arcane-state', state);
    dialog.hidden = state === 'closed';
    dialog.setAttribute('data-arcane-escape-closes', String(escape));
    dialog.innerHTML = empty ? '' : `
      <input id="${id}-first" aria-label="Title">
      <button disabled>Unavailable action</button>
      <button id="${id}-last">Save changes</button>
    `;
    dialog.addEventListener('arcane:close', () => {
      dialog.dataset.closeCount = String(Number(dialog.dataset.closeCount || 0) + 1);
    });
    document.body.append(dialog);
  }, { id, state, escape, empty });
}

async function expectStack(page, ids) {
  await page.waitForFunction(expected =>
    JSON.stringify(window.Arcane.stack.map(entry => entry.id)) === JSON.stringify(expected), ids);
}

async function expectFocus(page, id) {
  await page.waitForFunction(expected => document.activeElement?.id === expected, id);
}

async function addCommandPalette(page) {
  await page.evaluate(() => {
    document.body.insertAdjacentHTML('beforeend', `
      <button id="command-trigger" data-command-trigger data-arcane-action="surface.open command command-palette">Commands</button>
      <div id="command-palette" class="arcane-command-overlay" hidden
          data-arcane-surface="command" data-arcane-id="command-palette"
          data-arcane-state="closed" data-arcane-focus-trap="true">
        <input id="command-input" class="arcane-command-input" data-arcane-command-input="command-palette">
        <button id="command-item" class="arcane-command-item" data-arcane-command-item
            data-label="Open settings" data-arcane-state="visible">Open settings</button>
      </div>
    `);
  });
  await page.addScriptTag({ content: `${legacyCommandRuntime}\nbindCommandPalettes();` });
}

test('a dynamically mounted open dialog traps forward and backward Tab', async t => {
  const page = await fixture(t);
  await addDialog(page, 'editor');
  await expectStack(page, ['editor']);
  await expectFocus(page, 'editor-first');
  assert.equal(await page.locator('body').getAttribute('data-arcane-overlay-open'), 'true');
  await page.keyboard.press('Tab');
  await expectFocus(page, 'editor-last');
  await page.keyboard.press('Tab');
  await expectFocus(page, 'editor-first');
  await page.keyboard.press('Shift+Tab');
  await expectFocus(page, 'editor-last');
  await page.locator('#outside').focus();
  await page.keyboard.press('Tab');
  await expectFocus(page, 'editor-first');
  await page.locator('#outside').focus();
  await page.keyboard.press('Shift+Tab');
  await expectFocus(page, 'editor-last');
});

test('controlled state changes open, close and reopen a mounted dialog', async t => {
  const page = await fixture(t);
  await addDialog(page, 'editor', { state: 'closed' });
  await expectStack(page, []);
  await page.evaluate(() => document.querySelector('#editor').setAttribute('data-arcane-state', 'open'));
  await expectStack(page, ['editor']);
  await expectFocus(page, 'editor-first');
  await page.keyboard.press('Escape');
  await expectStack(page, []);
  await expectFocus(page, 'trigger');
  assert.equal(await page.locator('#editor').getAttribute('data-close-count'), '1');
  await page.evaluate(() => document.querySelector('#editor').setAttribute('data-arcane-state', 'open'));
  await expectStack(page, ['editor']);
  await expectFocus(page, 'editor-first');
  assert.equal(await page.locator('#editor').isVisible(), true);
  await page.evaluate(() => {
    const dialog = document.querySelector('#editor');
    dialog.setAttribute('data-arcane-state', 'closed');
    dialog.hidden = true;
  });
  await expectStack(page, []);
  assert.equal(await page.locator('body').getAttribute('data-arcane-overlay-open'), null);
});

test('Escape closes only the topmost dialog and emits one close event', async t => {
  const page = await fixture(t);
  await addDialog(page, 'parent');
  await expectFocus(page, 'parent-first');
  await addDialog(page, 'child');
  await expectFocus(page, 'child-first');
  await expectStack(page, ['parent', 'child']);
  await page.keyboard.press('Escape');
  await expectStack(page, ['parent']);
  await expectFocus(page, 'parent-first');
  assert.equal(await page.locator('#child').getAttribute('data-close-count'), '1');
  assert.equal(await page.locator('#parent').getAttribute('data-close-count'), null);
  assert.equal(await page.locator('body').getAttribute('data-arcane-overlay-open'), 'true');
  await page.keyboard.press('Escape');
  await expectStack(page, []);
  await expectFocus(page, 'trigger');
  assert.equal(await page.locator('#parent').getAttribute('data-close-count'), '1');
});

test('escapeCloses false keeps the topmost dialog and its parent open', async t => {
  const page = await fixture(t);
  await addDialog(page, 'parent');
  await expectFocus(page, 'parent-first');
  await addDialog(page, 'saving', { escape: false });
  await expectFocus(page, 'saving-first');
  await page.keyboard.press('Escape');
  await expectStack(page, ['parent', 'saving']);
  assert.equal(await page.locator('#saving').getAttribute('data-close-count'), null);
  await page.locator('#saving-last').focus();
  await page.keyboard.press('Tab');
  await expectFocus(page, 'saving-first');
});

test('removing a mounted dialog prunes stale stack entries and preserves the remaining trap', async t => {
  const page = await fixture(t);
  await addDialog(page, 'parent');
  await expectFocus(page, 'parent-first');
  await addDialog(page, 'child');
  await expectFocus(page, 'child-first');
  await page.locator('#child').evaluate(element => element.remove());
  await expectStack(page, ['parent']);
  await page.locator('#parent-last').focus();
  await page.keyboard.press('Tab');
  await expectFocus(page, 'parent-first');
  await page.locator('#parent').evaluate(element => element.remove());
  await expectStack(page, []);
  assert.equal(await page.locator('body').getAttribute('data-arcane-overlay-open'), null);
});

test('a dialog without focusable children receives and retains keyboard focus', async t => {
  const page = await fixture(t);
  await addDialog(page, 'empty', { empty: true });
  await expectStack(page, ['empty']);
  await expectFocus(page, 'empty');
  await page.keyboard.press('Tab');
  await expectFocus(page, 'empty');
  await page.keyboard.press('Shift+Tab');
  await expectFocus(page, 'empty');
});

test('a closing transition cannot hide a dialog that has reopened', async t => {
  const page = await fixture(t);
  await addDialog(page, 'editor');
  await expectFocus(page, 'editor-first');
  await page.evaluate(() => {
    const dialog = document.querySelector('#editor');
    window.Arcane.config.reducedMotion = false;
    dialog.style.transitionDuration = '1s';
    window.Arcane.surfaces.close('dialog', 'editor');
    window.Arcane.surfaces.open('dialog', 'editor');
    dialog.dispatchEvent(new Event('transitionend'));
  });
  await expectStack(page, ['editor']);
  assert.equal(await page.locator('#editor').isVisible(), true);
  await expectFocus(page, 'editor-first');
  await page.locator('#editor-last').focus();
  await page.keyboard.press('Tab');
  await expectFocus(page, 'editor-first');
});

test('a hidden command palette does not swallow Escape from an active dialog', async t => {
  const page = await fixture(t);
  await addCommandPalette(page);
  await addDialog(page, 'editor');
  await expectFocus(page, 'editor-first');
  await page.keyboard.press('Escape');
  await expectStack(page, []);
  assert.equal(await page.locator('#editor').getAttribute('data-close-count'), '1');
  assert.equal(await page.locator('#editor').isVisible(), false);
  assert.equal(await page.locator('#command-palette').getAttribute('data-arcane-state'), 'closed');
});

test('Ctrl+K reaches the application shortcut handler and palette keys retain runtime ownership', async t => {
  const page = await fixture(t);
  await addCommandPalette(page);
  await page.evaluate(() => {
    document.addEventListener('keydown', event => {
      if ((event.ctrlKey || event.metaKey) && event.key === 'k') {
        document.body.dataset.shortcutPrevented = String(event.defaultPrevented);
        event.preventDefault();
        document.querySelector('#command-trigger').click();
      }
    });
  });
  await page.keyboard.press('Control+k');
  await expectStack(page, ['command-palette']);
  assert.equal(await page.locator('body').getAttribute('data-shortcut-prevented'), 'false');
  await expectFocus(page, 'command-input');
  await page.keyboard.press('ArrowDown');
  assert.equal(await page.locator('#command-item').getAttribute('data-arcane-state'), 'active');
  await page.keyboard.press('Escape');
  await expectStack(page, []);
  assert.equal(await page.locator('#command-palette').getAttribute('data-arcane-state'), 'closed');
  assert.equal(await page.locator('#command-palette').isVisible(), false);
});
