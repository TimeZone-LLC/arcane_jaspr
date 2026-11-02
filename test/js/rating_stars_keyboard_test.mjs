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
  directory = mkdtempSync(join(tmpdir(), 'arcane-rating-test-'));
  const output = join(directory, 'rating.dart.js');
  const environment = { ...process.env };
  delete environment.GIT_CONFIG_COUNT;
  execFileSync('dart', ['compile', 'js', 'test/fixtures/rating_stars_browser.dart', '-o', output], {
    cwd: root, env: environment, stdio: 'inherit',
  });
  server = createServer((request, response) => {
    response.setHeader('Content-Type', request.url === '/rating.dart.js' ? 'text/javascript' : 'text/html');
    response.end(request.url === '/rating.dart.js'
      ? readFileSync(output)
      : '<!doctype html><html><head><meta charset="utf-8"></head><body><script defer src="/rating.dart.js"></script></body></html>');
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

test('Tab, Enter, Space, and pointer activation each report one rating without submitting', async t => {
  const page = await browser.newPage();
  t.after(() => page.close());
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  await page.goto(url);
  await page.locator('#before').waitFor();
  assert.equal(await page.locator('#interactive button').count(), 5);
  await page.locator('#before').focus();
  await page.keyboard.press('Tab');
  assert.equal(await page.evaluate(() => document.activeElement.getAttribute('aria-label')), 'Rate 1 out of 5');
  await page.keyboard.press('Enter');
  await page.waitForFunction(() => document.querySelector('#changes').textContent === '1');
  assert.equal(await page.locator('#rating').textContent(), '1');
  assert.equal(await page.getByRole('button', { name: 'Rate 1 out of 5' }).getAttribute('aria-pressed'), 'true');

  await page.keyboard.press('Tab');
  await page.keyboard.press('Space');
  await page.waitForFunction(() => document.querySelector('#changes').textContent === '2');
  assert.equal(await page.locator('#rating').textContent(), '2');
  await page.getByRole('button', { name: 'Rate 4 out of 5' }).click();
  await page.waitForFunction(() => document.querySelector('#changes').textContent === '3');
  assert.equal(await page.locator('#rating').textContent(), '4');
  assert.equal(await page.locator('#submissions').textContent(), '0');

  await page.getByRole('button', { name: 'Rate 5 out of 5' }).focus();
  await page.keyboard.press('Tab');
  assert.equal(await page.evaluate(() => document.activeElement.id), 'after');
  assert.equal(await page.locator('#static button, #no-callback button').count(), 0);
  assert.deepEqual(errors, []);
});
