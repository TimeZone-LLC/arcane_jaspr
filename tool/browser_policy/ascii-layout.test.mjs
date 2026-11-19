import assert from 'node:assert/strict';
import { mkdir } from 'node:fs/promises';
import { chromium } from 'playwright';

const baseUrl = (process.env.ARCANE_DOCS_URL ?? 'http://127.0.0.1:41737').replace(/\/$/, '');
const output = process.env.ARCANE_LAYOUT_SCREENSHOTS;
if (output) await mkdir(output, { recursive: true });
const browser = await chromium.launch({
  headless: true,
  executablePath: process.env.PLAYWRIGHT_CHROMIUM_EXECUTABLE,
});
const results = [];

async function fieldGeometry(control) {
  return control.evaluate((element) => {
    const label = element.closest('.ascii-workbench').querySelector(`label[for="${element.id}"]`);
    const rect = element.getBoundingClientRect();
    const labelRect = label.getBoundingClientRect();
    const style = getComputedStyle(element);
    const labelStyle = getComputedStyle(label);
    return {
      height: rect.height,
      top: rect.top,
      labelTop: labelRect.top,
      gap: rect.top - labelRect.bottom,
      font: style.fontSize,
      family: style.fontFamily,
      line: style.lineHeight,
      labelFont: labelStyle.fontSize,
      labelLine: labelStyle.lineHeight,
      trailingSpace: element.closest('.arcane-text-input-wrapper, .arcane-select-wrapper').getBoundingClientRect().right - rect.right,
    };
  });
}

function compareFields(first, second, height, font) {
  for (const field of [first, second]) {
    assert.equal(field.height, height);
    assert.equal(field.gap, 8);
    assert.equal(field.font, font);
    assert.equal(field.line, '20px');
    assert.equal(field.labelFont, '14px');
    assert.equal(field.labelLine, '20px');
    assert.ok(Math.abs(field.trailingSpace) < 1, 'Controls must fill their allocated field width');
    assert.match(field.family, /monospace/);
  }
  if (Math.abs(first.labelTop - second.labelTop) < 1) {
    assert.ok(Math.abs(first.top - second.top) < 1, 'Adjacent controls must align');
  }
}

async function selectDemo(bench, name, selector) {
  const details = bench.locator('.ascii-showcase-all-components');
  if (!await details.evaluate((element) => element.open)) {
    await details.locator('summary').click();
  }
  await details.getByRole('button', { name, exact: true }).click();
  const preview = bench.locator('.arcane-demo-preview-scope');
  await preview.locator(selector).first().waitFor();
  return preview;
}

try {
  for (const width of [375, 600, 768, 1024, 1440]) {
    for (const mode of ['light', 'dark']) {
      const touch = width <= 600;
      const context = await browser.newContext({
        viewport: { width, height: 1000 },
        hasTouch: touch,
        reducedMotion: 'reduce',
      });
      await context.addInitScript((mode) => {
        localStorage.setItem('arcane-stylesheet-id', 'ascii');
        localStorage.setItem('arcane-theme-mode', mode);
      }, mode);
      const page = await context.newPage();
      const errors = [];
      page.on('pageerror', (error) => errors.push(error.message));
      assert.ok((await page.goto(`${baseUrl}/ascii/`))?.ok());
      const bench = page.locator('.ascii-workbench:visible');
      await bench.waitFor();
      await page.waitForFunction((mode) => {
        const root = document.querySelector('#arcane-root');
        return root?.dataset.arcaneTheme === 'ascii' && root.classList.contains(mode);
      }, mode);
      await bench.getByRole('button', { name: 'Pause specimens', exact: true }).click();
      await bench.getByRole('button', { name: 'Enable motion', exact: true }).click();
      await bench.getByRole('button', { name: 'Pause specimens', exact: true }).waitFor();
      const expectedHeight = touch ? 44 : 36;
      const expectedFont = touch ? '16px' : '14px';
      compareFields(
        await fieldGeometry(bench.getByLabel('Specimen text', { exact: true })),
        await fieldGeometry(bench.getByLabel('Duration', { exact: true })),
        expectedHeight,
        expectedFont,
      );
      const controls = bench.locator('.ascii-showcase-component-controls');
      compareFields(
        await fieldGeometry(controls.locator('input')),
        await fieldGeometry(controls.locator('select')),
        expectedHeight,
        expectedFont,
      );
      const actions = bench.locator('.ascii-showcase-motion-actions');
      assert.ok(await actions.evaluate((element) => {
        const [pause, replay] = [...element.querySelectorAll('button')]
          .map((button) => button.getBoundingClientRect());
        return Math.abs(pause.top - replay.top) < 1
          && Math.abs(pause.height - replay.height) < 1;
      }), 'Motion actions must stay together on one row');
      if (output) {
        const motion = bench.locator('.ascii-showcase-motion-controls');
        await motion.evaluate((element) => element.scrollIntoView({ block: 'center' }));
        await motion.screenshot({ path: `${output}/fields-${width}-${mode}.png` });
      }
      const group = (await selectDemo(bench, 'Input Group', '.arcane-input-group'))
        .locator('.arcane-input-group');
      assert.ok(await group.evaluate((element) => {
        const input = element.querySelector('input').getBoundingClientRect();
        const button = element.querySelector('button').getBoundingClientRect();
        return Math.abs(input.top - button.top) < 1
          && Math.abs(input.height - button.height) < 1
          && element.scrollWidth <= element.clientWidth + 1;
      }), 'Input-group fields and actions must align and fit');
      const tabs = (await selectDemo(bench, 'Tabs', '.arcane-tabs-list')).locator('.arcane-tabs-list');
      assert.ok(await tabs.evaluate((element) => {
        const bounds = element.getBoundingClientRect();
        return [...element.querySelectorAll('[role="tab"]')].every((tab) => {
          const rect = tab.getBoundingClientRect();
          return rect.top >= bounds.top && rect.bottom <= bounds.bottom;
        });
      }), 'Tab targets must fit inside their list');
      assert.ok(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth));
      assert.deepEqual(errors, []);
      results.push({ width, mode, touch, alignedFields: true, inputGroup: true, tabs: true });
      await context.close();
    }
  }
  console.log(JSON.stringify(results, null, 2));
} finally {
  await browser.close();
}
