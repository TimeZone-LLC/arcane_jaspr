library;

const String runtimeGroupsJs = r'''
function groupRoot(groupId) {
  return document.querySelector('[data-arcane-group="' + cssEscape(groupId) +
    '"][data-arcane-group-mode]');
}

function groupValues(groupId) {
  const root = groupRoot(groupId);
  if (!root) return [];
  const raw = root.getAttribute('data-arcane-group-value') || '';
  if (!raw) return [];
  return raw.split('\u001f').filter(Boolean);
}

function groupMode(groupId) {
  const root = groupRoot(groupId);
  if (!root) return 'single';
  return root.getAttribute('data-arcane-group-mode') || 'single';
}

function setGroupRawValues(groupId, values) {
  const root = groupRoot(groupId);
  if (!root) return;
  root.setAttribute('data-arcane-group-value', values.join('\u001f'));
  syncGroupItems(groupId, values);
  fireEvent(root, 'arcane:change', { groupId: groupId, value: values });
  const changeAction = root.getAttribute('data-arcane-group-change');
  if (changeAction) {
    runActions(changeAction, { trigger: root, groupId: groupId, value: values });
  }
}

function syncGroupItems(groupId, values) {
  const root = groupRoot(groupId);
  if (!root) return;
  const items = document.querySelectorAll(
    '[data-arcane-group="' + cssEscape(groupId) + '"][data-arcane-value]'
  );
  for (let i = 0; i < items.length; i++) {
    const item = items[i];
    if (item === root) continue;
    const v = item.getAttribute('data-arcane-value');
    const selected = values.indexOf(v) >= 0;
    item.setAttribute('data-arcane-state', selected ? 'selected' : 'unselected');
    const role = item.getAttribute('role');
    if (role === 'option' || role === 'tab') {
      item.setAttribute('aria-selected', selected ? 'true' : 'false');
    }
    if (role === 'checkbox' || role === 'switch' || role === 'radio' ||
        role === 'menuitemcheckbox' || role === 'menuitemradio') {
      item.setAttribute('aria-checked', selected ? 'true' : 'false');
      item.setAttribute('data-state', selected ? 'checked' : 'unchecked');
    }
    if (item.tagName === 'INPUT' && (item.type === 'checkbox' || item.type === 'radio')) {
      item.checked = selected;
    }
  }
}

function setGroupValue(groupId, value) {
  const mode = groupMode(groupId);
  if (mode === 'multi') {
    setGroupRawValues(groupId, value ? [value] : []);
  } else {
    setGroupRawValues(groupId, value ? [value] : []);
  }
}

function toggleGroupValue(groupId, value) {
  const mode = groupMode(groupId);
  const cur = groupValues(groupId);
  if (mode === 'multi') {
    const idx = cur.indexOf(value);
    let next;
    if (idx >= 0) {
      next = cur.slice();
      next.splice(idx, 1);
    } else {
      const root = groupRoot(groupId);
      const max = root ? parseInt(root.getAttribute('data-arcane-group-max') || '0', 10) : 0;
      if (max > 0 && cur.length >= max) {
        next = cur.slice(1);
        next.push(value);
      } else {
        next = cur.concat([value]);
      }
    }
    setGroupRawValues(groupId, next);
  } else {
    if (cur.length === 1 && cur[0] === value) {
      const root = groupRoot(groupId);
      if (root && root.getAttribute('data-arcane-group-required') === 'true') return;
      setGroupRawValues(groupId, []);
    } else {
      setGroupRawValues(groupId, [value]);
    }
  }
}

function clearGroup(groupId) {
  setGroupRawValues(groupId, []);
}

ARCANE.groups.values = groupValues;
ARCANE.groups.mode = groupMode;
ARCANE.groups.set = setGroupValue;
ARCANE.groups.toggle = toggleGroupValue;
ARCANE.groups.clear = clearGroup;
''';

const String runtimeTabsJs = r'''
function activateTab(groupId, tabId) {
  const triggers = document.querySelectorAll(
    '[data-arcane-tabs-group="' + cssEscape(groupId) +
    '"][data-arcane-tab]'
  );
  for (let i = 0; i < triggers.length; i++) {
    const t = triggers[i];
    const id = t.getAttribute('data-arcane-tab');
    const active = id === tabId;
    t.setAttribute('data-arcane-state', active ? 'active' : 'inactive');
    if (t.getAttribute('role') === 'tab') {
      t.setAttribute('aria-selected', active ? 'true' : 'false');
      t.setAttribute('tabindex', active ? '0' : '-1');
    }
  }
  const panels = document.querySelectorAll(
    '[data-arcane-tabs-group="' + cssEscape(groupId) +
    '"][data-arcane-tab-panel]'
  );
  for (let i = 0; i < panels.length; i++) {
    const p = panels[i];
    const id = p.getAttribute('data-arcane-tab-panel');
    const active = id === tabId;
    p.setAttribute('data-arcane-state', active ? 'active' : 'inactive');
    if (active) p.removeAttribute('hidden');
    else p.setAttribute('hidden', '');
  }
  const containers = document.querySelectorAll(
    '[data-arcane-tabs-group="' + cssEscape(groupId) +
    '"]:not([data-arcane-tab]):not([data-arcane-tab-panel])'
  );
  for (let i = 0; i < containers.length; i++) {
    containers[i].setAttribute('data-arcane-tabs-active', tabId);
    fireEvent(containers[i], 'arcane:tabs-change', {
      groupId: groupId, tabId: tabId
    });
  }
}

ARCANE.tabs.activate = activateTab;
''';

const String runtimePanelsJs = r'''
function setPanelState(groupId, panelId, expanded) {
  const trigger = document.querySelector(
    '[data-arcane-panel-group="' + cssEscape(groupId) +
    '"][data-arcane-panel="' + cssEscape(panelId) + '"]'
  );
  const content = document.querySelector(
    '[data-arcane-panel-group="' + cssEscape(groupId) +
    '"][data-arcane-panel-content="' + cssEscape(panelId) + '"]'
  );
  if (trigger) {
    trigger.setAttribute('data-arcane-state', expanded ? 'expanded' : 'collapsed');
    trigger.setAttribute('aria-expanded', expanded ? 'true' : 'false');
  }
  if (content) {
    content.setAttribute('data-arcane-state', expanded ? 'expanded' : 'collapsed');
    if (expanded) content.removeAttribute('hidden');
    else content.setAttribute('hidden', '');
  }
}

function expandPanel(groupId, panelId) {
  const trigger = document.querySelector(
    '[data-arcane-panel-group="' + cssEscape(groupId) +
    '"][data-arcane-panel="' + cssEscape(panelId) + '"]'
  );
  if (trigger && trigger.getAttribute('data-arcane-panel-exclusive') === 'true') {
    const all = document.querySelectorAll(
      '[data-arcane-panel-group="' + cssEscape(groupId) +
      '"][data-arcane-panel][data-arcane-state="expanded"]'
    );
    for (let i = 0; i < all.length; i++) {
      const id = all[i].getAttribute('data-arcane-panel');
      if (id !== panelId) setPanelState(groupId, id, false);
    }
  }
  setPanelState(groupId, panelId, true);
  fireEvent(document, 'arcane:panel-change', {
    groupId: groupId, panelId: panelId, expanded: true
  });
}

function collapsePanel(groupId, panelId) {
  setPanelState(groupId, panelId, false);
  fireEvent(document, 'arcane:panel-change', {
    groupId: groupId, panelId: panelId, expanded: false
  });
}

function togglePanel(groupId, panelId) {
  const trigger = document.querySelector(
    '[data-arcane-panel-group="' + cssEscape(groupId) +
    '"][data-arcane-panel="' + cssEscape(panelId) + '"]'
  );
  if (!trigger) return;
  const expanded = trigger.getAttribute('data-arcane-state') === 'expanded';
  if (expanded) collapsePanel(groupId, panelId);
  else expandPanel(groupId, panelId);
}

ARCANE.panels.expand = expandPanel;
ARCANE.panels.collapse = collapsePanel;
ARCANE.panels.toggle = togglePanel;
''';

const String runtimeStepperJs = r'''
function stepperRoot(groupId) {
  return document.querySelector('[data-arcane-stepper="' + cssEscape(groupId) +
    '"][data-arcane-step-active]');
}

function goToStep(groupId, target) {
  const root = stepperRoot(groupId);
  if (!root) return;
  const cur = parseInt(root.getAttribute('data-arcane-step-active') || '0', 10);
  const count = parseInt(root.getAttribute('data-arcane-step-count') || '1', 10);
  let next = cur;
  if (target === 'next') next = Math.min(cur + 1, count - 1);
  else if (target === 'prev') next = Math.max(cur - 1, 0);
  else {
    const n = parseInt(target, 10);
    if (!isNaN(n)) next = Math.max(0, Math.min(n, count - 1));
  }
  if (next === cur) return;
  root.setAttribute('data-arcane-step-active', next.toString());
  const steps = document.querySelectorAll(
    '[data-arcane-stepper="' + cssEscape(groupId) + '"][data-arcane-step]'
  );
  for (let i = 0; i < steps.length; i++) {
    const stepEl = steps[i];
    const idx = parseInt(stepEl.getAttribute('data-arcane-step') || '0', 10);
    let state = 'pending';
    if (idx < next) state = 'completed';
    else if (idx === next) state = 'active';
    stepEl.setAttribute('data-arcane-state', state);
  }
  fireEvent(root, 'arcane:step-change', { groupId: groupId, step: next });
}

ARCANE.stepper = {
  go: goToStep
};
''';

const String runtimePaginationJs = r'''
function paginationRoot(groupId) {
  return document.querySelector('[data-arcane-pagination="' + cssEscape(groupId) +
    '"][data-arcane-page-active]');
}

function goToPage(groupId, target) {
  const root = paginationRoot(groupId);
  if (!root) return;
  const cur = parseInt(root.getAttribute('data-arcane-page-active') || '1', 10);
  const count = parseInt(root.getAttribute('data-arcane-page-count') || '1', 10);
  let next = cur;
  if (target === 'next') next = Math.min(cur + 1, count);
  else if (target === 'prev') next = Math.max(cur - 1, 1);
  else if (target === 'first') next = 1;
  else if (target === 'last') next = count;
  else {
    const n = parseInt(target, 10);
    if (!isNaN(n)) next = Math.max(1, Math.min(n, count));
  }
  if (next === cur) return;
  root.setAttribute('data-arcane-page-active', next.toString());
  fireEvent(root, 'arcane:page-change', { groupId: groupId, page: next });
}

ARCANE.pagination = {
  go: goToPage
};
''';

const String runtimeCarouselJs = r'''
function carouselRoot(groupId) {
  return document.querySelector('[data-arcane-carousel="' + cssEscape(groupId) +
    '"][data-arcane-carousel-active]');
}

function setCarouselSlide(groupId, idx) {
  const root = carouselRoot(groupId);
  if (!root) return;
  const count = parseInt(root.getAttribute('data-arcane-carousel-count') || '1', 10);
  const loop = root.getAttribute('data-arcane-carousel-loop') === 'true';
  let next = idx;
  if (loop) {
    if (next < 0) next = count - 1;
    if (next >= count) next = 0;
  } else {
    if (next < 0) next = 0;
    if (next >= count) next = count - 1;
  }
  root.setAttribute('data-arcane-carousel-active', next.toString());
  const slides = document.querySelectorAll(
    '[data-arcane-carousel="' + cssEscape(groupId) +
    '"][data-arcane-carousel-slide]'
  );
  for (let i = 0; i < slides.length; i++) {
    const s = slides[i];
    const sIdx = parseInt(s.getAttribute('data-arcane-carousel-slide') || '0', 10);
    s.setAttribute('data-arcane-state', sIdx === next ? 'active' : 'inactive');
  }
  fireEvent(root, 'arcane:carousel-change', { groupId: groupId, index: next });
}

function goToSlide(groupId, target) {
  const root = carouselRoot(groupId);
  if (!root) return;
  const cur = parseInt(root.getAttribute('data-arcane-carousel-active') || '0', 10);
  let next = cur;
  if (target === 'next') next = cur + 1;
  else if (target === 'prev') next = cur - 1;
  else {
    const n = parseInt(target, 10);
    if (!isNaN(n)) next = n;
  }
  setCarouselSlide(groupId, next);
}

function startCarouselAutoplay(root) {
  const ms = parseInt(root.getAttribute('data-arcane-carousel-autoplay') || '0', 10);
  if (!ms || ms <= 0) return;
  const groupId = root.getAttribute('data-arcane-carousel');
  if (root._arcaneCarouselTimer) clearInterval(root._arcaneCarouselTimer);
  root._arcaneCarouselTimer = setInterval(function() {
    goToSlide(groupId, 'next');
  }, ms);
  root.addEventListener('mouseenter', function() {
    if (root._arcaneCarouselTimer) clearInterval(root._arcaneCarouselTimer);
  });
  root.addEventListener('mouseleave', function() {
    startCarouselAutoplay(root);
  });
}

ARCANE.carousel = {
  go: goToSlide,
  set: setCarouselSlide,
  startAutoplay: startCarouselAutoplay
};
''';
