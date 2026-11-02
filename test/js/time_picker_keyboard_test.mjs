import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { mkdtempSync, readFileSync, rmSync } from 'node:fs';
import { createServer } from 'node:http';
import { createRequire } from 'node:module';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { after, before, test } from 'node:test';
import { fileURLToPath } from 'node:url';

const require = createRequire(new URL('../../tool/browser_policy/package.json', import.meta.url));
const { chromium } = require('playwright');
const root = fileURLToPath(new URL('../../', import.meta.url));
let directory;
let server;
let browser;
let url;

before(async () => {
  directory = mkdtempSync(join(tmpdir(), 'arcane-time-test-'));
  const output = join(directory, 'time.dart.js');
  const environment = { ...process.env };
  delete environment.GIT_CONFIG_COUNT;
  execFileSync('dart', ['compile', 'js', 'test/fixtures/time_picker_browser.dart', '-o', output], {
    cwd: root, env: environment, stdio: 'inherit',
  });
  server = createServer((request, response) => {
    response.setHeader('Content-Type', request.url === '/time.dart.js' ? 'text/javascript' : 'text/html');
    response.end(request.url === '/time.dart.js'
      ? readFileSync(output)
      : '<!doctype html><html><head><meta charset="utf-8"></head><body><script defer src="/time.dart.js"></script></body></html>');
  });
  await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
  url = `http://127.0.0.1:${server.address().port}/`;
  browser = await chromium.launch({
    headless: true,
    executablePath: process.env.PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH || undefined,
  });
});

after(async () => {
  await browser?.close();
  server?.closeAllConnections();
  if (server) await new Promise(resolve => server.close(resolve));
  if (directory) rmSync(directory, { recursive: true, force: true });
});

for (const variant of ['classic', 'neucomic']) {
  test(`${variant} clear supports Tab, Enter, Space, and click without submitting`, async t => {
    const page = await browser.newPage({ viewport: { width: 320, height: 900 } });
    t.after(() => page.close());
    const errors = [];
    page.on('pageerror', error => errors.push(error.message));
    await page.goto(`${url}?${variant}`);
    const clear = page.locator('#interactive .neubrutalism-time-picker-clear');
    const trigger = page.locator('#interactive .neubrutalism-time-picker-trigger');
    await clear.waitFor();
    assert.equal(await clear.evaluate(element => element.tagName), 'BUTTON');
    assert.equal(await clear.getAttribute('type'), 'button');
    assert.equal(await trigger.locator('.neubrutalism-time-picker-clear').count(), 0);
    const target = await clear.boundingBox();
    assert.ok(target.width >= 44 && target.height >= 44);
    await page.locator('#before').focus();
    await page.keyboard.press('Tab');
    assert.equal(await trigger.evaluate(element => document.activeElement === element), true);
    await page.keyboard.press('Tab');
    assert.equal(await clear.evaluate(element => document.activeElement === element), true);
    assert.equal(await clear.evaluate(element => getComputedStyle(element).outlineStyle), 'solid');
    await page.keyboard.press('Enter');
    await page.waitForFunction(() => document.querySelector('#changes').textContent === '1');
    assert.equal(await page.locator('#value').textContent(), 'null');
    await page.keyboard.press('Space');
    await page.waitForFunction(() => document.querySelector('#changes').textContent === '2');
    await clear.click();
    await page.waitForFunction(() => document.querySelector('#changes').textContent === '3');
    assert.equal(await page.locator('#submissions').textContent(), '0');
    assert.equal(await trigger.getAttribute('aria-expanded'), 'false');
    await page.keyboard.press('Tab');
    assert.equal(await page.evaluate(() => document.activeElement.id), 'after');
    assert.equal(await page.locator('#disabled .neubrutalism-time-picker-clear').isDisabled(), true);
    assert.deepEqual(errors, []);
  });
}
