import { chromium } from 'playwright';

const baseUrl = (process.env.ARCANE_DOCS_URL ?? 'http://127.0.0.1:41737')
  .replace(/\/$/, '');
const viewports = [
  { name: 'desktop', width: 1440, height: 1000 },
  { name: 'tablet', width: 768, height: 900 },
  { name: 'mobile', width: 375, height: 812 },
];
const themeModes = ['light', 'dark'];
const policySelector = [
  '[data-arcane-surface]',
  'button',
  'a',
  'summary',
  'input',
  'select',
  'textarea',
  '[role="button"]',
  '[role="tab"]',
  '[role="menuitem"]',
  '[class*="badge"]',
  '[class*="tag"]',
  '[data-arcane-semantic-icon]',
].join(',');

const interactions = [
  {
    route: '/docs/components/accordion/',
    action: 'double-click',
    text: 'What is Arcane Jaspr?',
    expectedText: 'A Flutter-like DX for Jaspr with semantic HTML output.',
  },
  {
    route: '/docs/components/collapsible/',
    action: 'double-click',
    text: 'Toggle content',
    expectedText: 'This disclosure is rendered by the active theme.',
  },
  {
    route: '/docs/components/dialog/',
    action: 'click',
    text: 'Open dialog',
    expectedText: 'Apply changes to your current workspace?',
  },
  {
    route: '/docs/components/alert-dialog/',
    action: 'click',
    text: 'Delete project',
    expectedText: 'This action cannot be undone.',
  },
  {
    route: '/docs/components/command/',
    action: 'click',
    text: 'Open command',
    expectedText: 'Go to Dashboard',
  },
  {
    route: '/docs/components/drawer/',
    action: 'click',
    text: 'Open drawer',
    expectedText: 'Drawer content',
  },
  {
    route: '/docs/components/sheet/',
    action: 'click',
    text: 'Open sheet',
    expectedText: 'Sheet content',
  },
  {
    route: '/docs/components/dropdown-menu/',
    action: 'click',
    text: 'Open menu',
    expectedText: 'Profile',
  },
  {
    route: '/docs/components/context-menu/',
    action: 'contextmenu',
    text: 'Right-click me',
    expectedText: 'Rename',
  },
  {
    route: '/docs/components/menubar/',
    action: 'click',
    text: 'File',
    expectedText: 'New',
  },
  {
    route: '/docs/components/navigation-menu/',
    action: 'hover',
    text: 'Products',
    expectedText: 'Core UI',
  },
  {
    route: '/docs/components/hover-card/',
    action: 'hover',
    text: 'Hover card',
    expectedText: 'A lightweight profile or preview.',
  },
  {
    route: '/docs/components/tooltip/',
    action: 'hover',
    text: 'Hover target',
    expectedText: 'This is a tooltip',
  },
  {
    route: '/docs/components/popover/',
    action: 'click',
    text: 'Open popover',
    expectedText: 'Popover content',
  },
  {
    route: '/docs/components/tabs/',
    action: 'click',
    text: 'Billing',
    expectedText: 'Billing tab content',
  },
  {
    route: '/docs/components/select/',
    action: 'select-option',
    selector: '.arcane-demo-preview-scope select.arcane-select',
    option: 'enterprise',
    expectedValue: 'enterprise',
  },
  {
    route: '/docs/components/combobox/',
    action: 'click',
    selector: '.arcane-demo-preview-scope button[aria-haspopup="listbox"]',
    expectedText: 'React',
  },
];

function auditDom(selector) {
  const visible = (element) => {
    const style = getComputedStyle(element);
    const rect = element.getBoundingClientRect();
    return style.display !== 'none' &&
      style.visibility !== 'hidden' &&
      Number.parseFloat(style.opacity || '1') > 0 &&
      rect.width > 0 && rect.height > 0;
  };
  const describe = (element) => [
    element.tagName.toLowerCase(),
    element.getAttribute('data-arcane-surface') ?? '',
    element.getAttribute('role') ?? '',
    String(element.className ?? '').slice(0, 160),
  ].filter(Boolean).join('.');
  const borderSignature = (style, side) => [
    style[`border${side}Width`],
    style[`border${side}Style`],
    style[`border${side}Color`],
  ].join(' ');
  const hasGlow = (shadow) => {
    if (!shadow || shadow === 'none') return false;
    const colored = [...shadow.matchAll(/rgba?\((\d+)[, ]+(\d+)[, ]+(\d+)/g)]
      .some((match) => match[1] !== match[2] || match[2] !== match[3]);
    const blurred = [...shadow.matchAll(
      /(-?[\d.]+)px\s+(-?[\d.]+)px\s+([\d.]+)px/g,
    )].some((match) => {
      const x = Number.parseFloat(match[1]);
      const y = Number.parseFloat(match[2]);
      const blur = Number.parseFloat(match[3]);
      return blur > 0 && (colored || x === 0 && y === 0);
    });
    return blurred;
  };
  // A gradient whose stops share one colour paints a flat block. Win95 draws
  // its pixel glyphs that way, so only multi-colour gradients count.
  const hasGradient = (backgroundImage) => {
    for (const match of backgroundImage.matchAll(/gradient\(/gi)) {
      let depth = 1;
      let end = match.index + match[0].length;
      while (end < backgroundImage.length && depth > 0) {
        if (backgroundImage[end] === '(') depth++;
        if (backgroundImage[end] === ')') depth--;
        end++;
      }
      const colors = backgroundImage
        .slice(match.index, end)
        .match(/rgba?\([^)]*\)|#[\da-f]{3,8}\b|\b(?:currentcolor|transparent)\b/gi);
      if (new Set(colors ?? []).size !== 1) return true;
    }
    return false;
  };
  // The Neon contract permits frost on its transient menu overlays only.
  const frostOverlay = '#arcane-root.arcane-theme-neon :is(' +
    '.neon-dropdown-menu, .neon-dropdown-submenu, .neon-select-dropdown, ' +
    '.arcane-nav-dropdown-panel)';
  const intrinsicRound = (element) => {
    if (element.matches('input[type="radio"],input[type="checkbox"]')) {
      return true;
    }
    const className = String(element.className ?? '');
    const rect = element.getBoundingClientRect();
    return Math.abs(rect.width - rect.height) <= 1 &&
      /(?:avatar|radio|checkbox|switch|slider|fab|icon-button)/i.test(className);
  };
  const violations = [];
  const elements = [...document.querySelectorAll(selector)].filter(visible);

  for (const element of elements) {
    const style = getComputedStyle(element);
    const radius = Math.max(
      Number.parseFloat(style.borderTopLeftRadius) || 0,
      Number.parseFloat(style.borderTopRightRadius) || 0,
      Number.parseFloat(style.borderBottomRightRadius) || 0,
      Number.parseFloat(style.borderBottomLeftRadius) || 0,
    );
    const borders = ['Top', 'Right', 'Bottom', 'Left']
      .map((side) => borderSignature(style, side));
    const renderedIcons = [...element.querySelectorAll('i,svg,img')]
      .filter(visible);
    const identity = describe(element);

    if (hasGradient(style.backgroundImage)) {
      violations.push(['gradient/image', identity, style.backgroundImage]);
    }
    if (
      (style.backdropFilter !== 'none' ||
        style.webkitBackdropFilter && style.webkitBackdropFilter !== 'none') &&
      !element.matches(frostOverlay)
    ) {
      violations.push(['backdrop/frost', identity]);
    }
    if (hasGlow(style.boxShadow)) {
      violations.push(['shadow/glow', identity, style.boxShadow]);
    }
    if (radius > 8 && !intrinsicRound(element)) {
      violations.push(['large radius/pill', identity, radius]);
    }
    if (radius > 0 && new Set(borders).size > 1) {
      violations.push(['one-sided border', identity, borders]);
    }
    if (
      element.matches(
        'button,[role="button"],[class*="badge"],[class*="tag"],' +
        '[data-arcane-semantic-icon]',
      ) && renderedIcons.length > 1
    ) {
      violations.push(['multiple visible icons', identity, renderedIcons.length]);
    }

    for (const pseudo of ['::before', '::after']) {
      const pseudoStyle = getComputedStyle(element, pseudo);
      if (!pseudoStyle || ['none', 'normal'].includes(pseudoStyle.content)) {
        continue;
      }
      if (hasGradient(pseudoStyle.backgroundImage)) {
        violations.push(['gradient/image', `${identity}${pseudo}`]);
      }
      if (hasGlow(pseudoStyle.boxShadow)) {
        violations.push(['shadow/glow', `${identity}${pseudo}`]);
      }
    }
  }

  for (const parent of [...document.querySelectorAll('[data-arcane-surface]')]) {
    if (!visible(parent)) continue;
    const nested = [...parent.querySelectorAll('[data-arcane-surface]')]
      .find(visible);
    if (nested) {
      violations.push([
        'nested visible surface',
        describe(parent),
        describe(nested),
      ]);
    }
  }

  const fontRoot = document.getElementById('arcane-root') ?? document.body;
  const bodyFont = getComputedStyle(fontRoot).fontFamily;
  const code = document.querySelector('code');
  const codeFont = code ? getComputedStyle(code).fontFamily : '';
  if (
    !bodyFont.includes('Akzidenz-GroteskPro') &&
    !bodyFont.includes('Pixelated MS Sans Serif')
  ) {
    violations.push(['remote/unapproved body font', bodyFont]);
  }
  if (
    code &&
    !codeFont.includes('Hack') &&
    !codeFont.includes('Fixedsys')
  ) {
    violations.push(['remote/unapproved code font', codeFont]);
  }
  if (!document.fonts.check('16px "Akzidenz-GroteskPro"')) {
    violations.push(['bundled body font failed to load']);
  }
  if (!document.fonts.check('16px "Hack"')) {
    violations.push(['bundled code font failed to load']);
  }

  const remoteStyle = [...document.querySelectorAll('link[rel="stylesheet"]')]
    .find((link) => {
      const href = link.getAttribute('href') ?? '';
      if (!/^https?:/i.test(href)) return false;
      try {
        return new URL(href, document.baseURI).origin !== location.origin;
      } catch (_) {
        return true;
      }
    });
  const remoteFontStyle = [...document.querySelectorAll('style')]
    .find((element) =>
      /(?:@import|@font-face)[^}]*https?:/is.test(element.textContent)
    );
  if (remoteStyle || remoteFontStyle) {
    violations.push(['remote font/style source']);
  }

  return violations;
}

async function loadPublishedRoutes() {
  const response = await fetch(`${baseUrl}/search-index.json`);
  if (!response.ok) {
    throw new Error(`Unable to load published route index: ${response.status}`);
  }
  const index = await response.json();
  const paths = index.entries.map((entry) => entry.path);
  return [...new Set(['/', ...paths])].map((path) =>
    path === '/' || path.endsWith('/') ? path : `${path}/`
  );
}

async function waitForClient(page) {
  await page.waitForFunction(() =>
    document.querySelector('.kb-style-slot-active') &&
    document.querySelector('[data-kb-stylesheet-select]')
  );
  await page.evaluate(() => document.fonts.ready);
}

async function availableStylesheets(page) {
  const select = page.locator(
    '.kb-style-slot-active [data-kb-stylesheet-select]',
  ).first();
  if (!await select.count()) throw new Error('Stylesheet selector is missing');
  const values = await select.locator('option').evaluateAll((options) =>
    options.map((option) => option.value).filter(Boolean)
  );
  if (!values.length) throw new Error('Stylesheet selector has no options');
  return values;
}

async function selectTheme(page, stylesheet, mode) {
  const stylesheetSelect = page.locator(
    '.kb-style-slot-active [data-kb-stylesheet-select]',
  ).first();
  await stylesheetSelect.selectOption(stylesheet, { force: true });
  await page.waitForFunction(({ stylesheet, mode }) => {
    const root = document.getElementById('arcane-root');
    return localStorage.getItem('arcane-stylesheet-id') === stylesheet &&
      root?.classList.contains(`kb-style-${stylesheet}`);
  }, { stylesheet, mode });
  const currentMode = await page.evaluate(() =>
    localStorage.getItem('arcane-theme-mode') ?? 'dark'
  );
  if (currentMode !== mode) {
    const themeToggle = page.locator(
      '.kb-style-slot-active [data-kb-theme-toggle],' +
      '.kb-style-slot-active #theme-toggle',
    ).first();
    if (!await themeToggle.count()) throw new Error('Theme toggle is missing');
    await themeToggle.evaluate((element) => element.click());
  }
  await page.waitForFunction((mode) => {
    const root = document.getElementById('arcane-root');
    return localStorage.getItem('arcane-theme-mode') === mode &&
      root?.classList.contains(mode);
  }, mode);
  await page.waitForTimeout(20);
}

async function audit(page) {
  // A theme can leave a bundled weight unused, so request both faces before
  // checking them. A missing or broken font file still fails the check.
  await page.evaluate(() => Promise.allSettled([
    document.fonts.load('16px "Akzidenz-GroteskPro"'),
    document.fonts.load('16px "Hack"'),
  ]));
  return page.evaluate(auditDom, policySelector);
}

async function recordAudit(
  failures,
  page,
  viewport,
  route,
  state,
  stylesheet = 'neon',
  mode = 'dark',
) {
  const result = await audit(page);
  for (const violation of result) {
    failures.push({ viewport, route, state, stylesheet, mode, violation });
  }
}

async function findVisibleText(page, text) {
  return page.locator('.arcane-demo-preview-scope')
    .getByText(text, { exact: false }).filter({ visible: true }).first();
}

async function runInteraction(failures, page, viewport, interaction) {
  await page.goto(`${baseUrl}${interaction.route}`, { waitUntil: 'networkidle' });
  await waitForClient(page);
  await selectTheme(page, 'neon', 'dark');
  const trigger = interaction.selector
    ? page.locator(interaction.selector).filter({ visible: true }).first()
    : await findVisibleText(page, interaction.text);
  if (!await trigger.count()) {
    failures.push({
      viewport,
      route: interaction.route,
      state: interaction.action,
      violation: ['interactive trigger missing', interaction.text ?? interaction.selector],
    });
    return;
  }
  try {
    if (interaction.action === 'hover') await trigger.hover();
    else if (interaction.action === 'contextmenu') {
      await trigger.click({ button: 'right' });
    } else if (interaction.action === 'select-option') {
      await trigger.selectOption(interaction.option);
    } else if (interaction.action === 'double-click') {
      await trigger.evaluate((element) => element.click());
      await trigger.evaluate((element) => element.click());
    } else await trigger.evaluate((element) => element.click());
  } catch (error) {
    failures.push({
      viewport,
      route: interaction.route,
      state: interaction.action,
      violation: ['interaction could not be exercised', String(error)],
    });
    return;
  }
  await page.waitForTimeout(interaction.action === 'hover' ? 400 : 400);

  const expectedPresent = interaction.expectedValue
    ? await trigger.inputValue() === interaction.expectedValue
    : await (await findVisibleText(page, interaction.expectedText)).count() > 0;
  if (!expectedPresent) {
    failures.push({
      viewport,
      route: interaction.route,
      state: interaction.action,
      violation: [
        'opened interaction state missing',
        interaction.expectedText ?? interaction.expectedValue,
      ],
    });
  }
  await recordAudit(
    failures,
    page,
    viewport,
    interaction.route,
    interaction.action,
  );
}

const mutations = [
  {
    name: 'gradient',
    expected: 'gradient/image',
    apply: () => {
      document.querySelector('[data-arcane-policy-probe]')
        .style.backgroundImage = 'linear-gradient(red, blue)';
    },
  },
  {
    name: 'frost',
    expected: 'backdrop/frost',
    apply: () => {
      document.querySelector('[data-arcane-policy-probe]')
        .style.backdropFilter = 'blur(8px)';
    },
  },
  {
    name: 'glow',
    expected: 'shadow/glow',
    apply: () => {
      document.querySelector('[data-arcane-policy-probe]')
        .style.boxShadow = '0 0 20px lime';
    },
  },
  {
    name: 'pill radius',
    expected: 'large radius/pill',
    apply: () => {
      document.querySelector('[data-arcane-policy-probe]')
        .style.borderRadius = '999px';
    },
  },
  {
    name: 'one-sided border',
    expected: 'one-sided border',
    apply: () => {
      const probe = document.querySelector('[data-arcane-policy-probe]');
      probe.style.border = '1px solid gray';
      probe.style.borderLeft = '5px solid green';
    },
  },
  {
    name: 'multiple icons',
    expected: 'multiple visible icons',
    apply: () => {
      const button = document.createElement('button');
      button.innerHTML = '<i>one</i><svg><path d="M0 0h1v1z"/></svg>';
      button.style.cssText = 'width:120px;height:40px;border-radius:0';
      button.dataset.arcaneMutation = 'true';
      document.body.append(button);
    },
  },
  {
    name: 'nested surface',
    expected: 'nested visible surface',
    apply: () => {
      const child = document.createElement('div');
      child.dataset.arcaneSurface = 'mutation-child';
      child.dataset.arcaneMutation = 'true';
      child.style.cssText = 'display:block;width:20px;height:20px';
      document.querySelector('[data-arcane-policy-probe]').append(child);
    },
  },
  {
    name: 'remote font source',
    expected: 'remote font/style source',
    apply: () => {
      const style = document.createElement('style');
      style.dataset.arcaneMutation = 'true';
      const remoteFontUrl = ['https://example.com', 'x.woff2'].join('/');
      style.textContent =
        `@font-face{font-family:x;src:url(${remoteFontUrl})}`;
      document.head.append(style);
    },
  },
  {
    name: 'unapproved body font',
    expected: 'remote/unapproved body font',
    apply: () => {
      document.getElementById('arcane-root')
        .style.setProperty('font-family', 'Arial', 'important');
    },
  },
  {
    name: 'unapproved code font',
    expected: 'remote/unapproved code font',
    apply: () => {
      document.querySelector('code')
        .style.setProperty('font-family', 'Courier', 'important');
    },
  },
];

async function resetMutation(page) {
  await page.evaluate(() => {
    document.querySelectorAll('[data-arcane-mutation="true"]')
      .forEach((element) => element.remove());
    const probe = document.querySelector('[data-arcane-policy-probe]');
    if (probe) {
      probe.style.cssText =
        'display:block;width:120px;height:40px;border:0;border-radius:4px';
    }
    document.getElementById('arcane-root')?.style.removeProperty('font-family');
    document.querySelector('code')?.style.removeProperty('font-family');
  });
}

async function runMutationSelfTests(failures, page, viewport) {
  await page.evaluate(() => {
    const probe = document.createElement('div');
    probe.dataset.arcaneSurface = 'policy-probe';
    probe.dataset.arcanePolicyProbe = 'true';
    probe.style.cssText =
      'display:block;width:120px;height:40px;border:0;border-radius:4px';
    document.body.append(probe);
  });

  for (const mutation of mutations) {
    await page.evaluate(mutation.apply);
    const result = await audit(page);
    if (!result.some((violation) => violation[0] === mutation.expected)) {
      failures.push({
        viewport,
        route: 'mutation-self-test',
        state: mutation.name,
        violation: ['policy mutation was not detected', mutation.expected],
      });
    }
    await resetMutation(page);
  }
  await page.evaluate(() => {
    document.querySelector('[data-arcane-policy-probe]')?.remove();
  });
}

const browser = await chromium.launch({ headless: true });
const failures = [];

try {
  const routes = await loadPublishedRoutes();
  if (routes.length < 78) {
    failures.push({
      viewport: 'all',
      route: 'published-route-index',
      state: 'coverage',
      violation: ['published route count below expected floor', routes.length],
    });
  }

  for (const viewport of viewports) {
    const page = await browser.newPage({ viewport });
    page.setDefaultTimeout(5000);
    console.log(`Auditing ${routes.length} routes at ${viewport.width}px...`);
    for (const route of routes) {
      await page.goto(`${baseUrl}${route}`, { waitUntil: 'networkidle' });
      await waitForClient(page);
      const stylesheets = await availableStylesheets(page);
      for (const stylesheet of stylesheets) {
        for (const mode of themeModes) {
          await selectTheme(page, stylesheet, mode);
          await recordAudit(
            failures,
            page,
            viewport.name,
            route,
            'published-route',
            stylesheet,
            mode,
          );
        }
      }
    }

    for (const interaction of interactions) {
      await runInteraction(failures, page, viewport.name, interaction);
    }

    await page.goto(`${baseUrl}/docs/components/card/`, {
      waitUntil: 'networkidle',
    });
    await waitForClient(page);
    await selectTheme(page, 'neon', 'dark');
    await runMutationSelfTests(failures, page, viewport.name);
    await page.close();
    console.log(`Completed ${viewport.name} route and interaction coverage.`);
  }
} finally {
  await browser.close();
}

if (failures.length) {
  const grouped = new Map();
  for (const failure of failures) {
    const key = JSON.stringify([
      failure.stylesheet ?? '',
      failure.mode ?? '',
      failure.state,
      failure.violation,
    ]);
    const existing = grouped.get(key);
    if (existing) existing.count++;
    else grouped.set(key, { ...failure, count: 1 });
  }
  console.error(JSON.stringify([...grouped.values()], null, 2));
  process.exitCode = 1;
} else {
  console.log(
    'Arcane browser policy passed every published route and stylesheet/theme ' +
    'at 375px, 768px, and 1440px, including interactive states and mutations.',
  );
}
