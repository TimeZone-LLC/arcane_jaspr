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
let directory, server, browser, url;

before(async () => {
  directory = mkdtempSync(join(tmpdir(), 'arcane-disclosure-test-'));
  const output = join(directory, 'fixture.dart.js');
  const environment = { ...process.env };
  delete environment.GIT_CONFIG_COUNT;
  execFileSync('dart', ['compile', 'js', 'test/fixtures/neubrutalism_disclosure_browser.dart', '-o', output], {
    cwd: root, env: environment, stdio: 'inherit',
  });
  server = createServer((request, response) => {
    response.setHeader('Content-Type', request.url === '/fixture.dart.js' ? 'text/javascript' : 'text/html');
    response.end(request.url === '/fixture.dart.js' ? readFileSync(output)
      : '<!doctype html><html><head><meta charset="utf-8"></head><body><script defer src="/fixture.dart.js"></script></body></html>');
  });
  await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
  url = `http://127.0.0.1:${server.address().port}/`;
  browser = await chromium.launch({headless: true, executablePath: process.env.PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH || undefined});
});

after(async () => {
  await browser?.close();
  server?.closeAllConnections();
  if (server) await new Promise(resolve => server.close(resolve));
  if (directory) rmSync(directory, {recursive: true, force: true});
});

async function settle(page) {
  await page.waitForFunction(() => document.getAnimations().every(animation => animation.playState === 'finished'));
}

for (const variant of ['classic', 'comic']) for (const mode of ['light', 'dark']) {
  for (const corners of ['square', 'rounded']) for (const motion of ['no-preference', 'reduce']) {
    test(`${variant} ${mode} ${corners} ${motion} disclosure framing and keyboard states`, async t => {
      const page = await browser.newPage({viewport: {width: 360, height: 1100}, reducedMotion: motion});
      t.after(() => page.close());
      const errors = [];
      page.on('pageerror', error => errors.push(error.message));
      await page.goto(`${url}?${variant}&${mode}&${corners}`);
      const accordion = page.locator('.neubrutalism-accordion').first();
      await accordion.waitFor();
      await settle(page);
      const layout = await accordion.evaluate(element => {
        const style = getComputedStyle(element);
        const [first, second] = element.querySelectorAll(':scope > details');
        const child = getComputedStyle(first);
        return {gap: style.gap, border: style.borderLeftWidth, radius: parseFloat(style.borderTopLeftRadius),
          childBorder: child.borderLeftWidth, childShadow: child.boxShadow,
          seam: second.getBoundingClientRect().top - first.getBoundingClientRect().bottom};
      });
      assert.equal(layout.gap, '0px');
      assert.notEqual(layout.border, '0px');
      assert.equal(layout.childBorder, '0px');
      assert.equal(layout.childShadow, 'none');
      assert.equal(layout.seam, 0);
      assert.equal(layout.radius > 0, corners === 'rounded');
      const first = accordion.locator('details').nth(0);
      const second = accordion.locator('details').nth(1);
      const arrow = first.locator('.faq-chevron');
      const appearance = await arrow.evaluate(element => {
        const style = getComputedStyle(element);
        const luminance = color => {
          const rgb = color.match(/[\d.]+/g).slice(0, 3).map(Number).map(value => value / 255);
          const linear = rgb.map(value => value <= .04045 ? value / 12.92 : ((value + .055) / 1.055) ** 2.4);
          return .2126 * linear[0] + .7152 * linear[1] + .0722 * linear[2];
        };
        const ink = luminance(style.color);
        const paper = luminance(getComputedStyle(element.closest('.neubrutalism-accordion')).backgroundColor);
        return {color: style.color, background: style.backgroundColor, border: style.borderWidth, transform: style.transform,
          contrast: (Math.max(ink, paper) + .05) / (Math.min(ink, paper) + .05)};
      });
      assert.equal(appearance.border, '0px');
      assert.notEqual(appearance.transform, 'none');
      assert.notEqual(appearance.color, appearance.background);
      assert.ok(appearance.contrast >= 4.5, `Chevron contrast ${appearance.contrast}`);
      await page.locator('#before').focus();
      await page.keyboard.press('Tab');
      assert.equal(await first.locator('summary').evaluate(element => document.activeElement === element), true);
      assert.equal(await first.locator('summary').evaluate(element => getComputedStyle(element).outlineStyle), 'solid');
      await page.keyboard.press('Tab');
      await page.keyboard.press('Enter');
      assert.equal(await first.getAttribute('open'), null);
      assert.notEqual(await second.getAttribute('open'), null);
      assert.equal(await second.locator(':scope > div').evaluate(element => getComputedStyle(element).animationName),
        motion === 'reduce' ? 'none' : 'nb-content-enter');
      await settle(page);
      assert.notEqual(await second.locator('.faq-chevron').evaluate(element => getComputedStyle(element).transform), 'none');
      await page.keyboard.press('Space');
      assert.equal(await second.getAttribute('open'), null);
      await settle(page);
      assert.equal(await second.locator('.faq-chevron').evaluate(element => getComputedStyle(element).transform), 'none');

      const standalone = page.locator('details.neubrutalism-disclosure').first();
      await standalone.locator('summary').focus();
      await page.keyboard.press('Enter');
      assert.notEqual(await standalone.getAttribute('open'), null);
      assert.equal(await standalone.locator('.neubrutalism-disclosure-content').evaluate(element => getComputedStyle(element).animationName),
        motion === 'reduce' ? 'none' : 'nb-content-enter');
      await settle(page);
      assert.notEqual(await standalone.locator('.neubrutalism-disclosure-chevron').evaluate(element => getComputedStyle(element).transform), 'none');
      const group = page.locator('.neubrutalism-disclosure-group');
      assert.equal(await group.evaluate(element => getComputedStyle(element).gap), '0px');
      assert.equal(await group.locator('details').first().evaluate(element => getComputedStyle(element).borderLeftWidth), '0px');
      assert.equal(await group.locator('details').nth(1).evaluate(element => parseFloat(getComputedStyle(element).borderTopWidth)), 2);
      await page.locator('#multiple summary').nth(0).click();
      await page.locator('#multiple summary').nth(1).click();
      assert.equal(await page.locator('#multiple details[open]').count(), 2);
      await settle(page);
      assert.equal(await page.evaluate(() => document.getAnimations().length), 0);
      if (motion === 'reduce') assert.equal(await arrow.evaluate(element => getComputedStyle(element).transitionDuration), '0s');
      if (process.env.ARCANE_DISCLOSURE_SCREENSHOTS && motion === 'no-preference') {
        await first.locator('summary').click();
        await page.locator('#before').hover();
        await settle(page);
        await page.screenshot({path: `${process.env.ARCANE_DISCLOSURE_SCREENSHOTS}/${variant}-${mode}-${corners}.png`, fullPage: true});
      }
      assert.deepEqual(errors, []);
    });
  }
}
