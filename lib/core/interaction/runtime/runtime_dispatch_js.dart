library;

const String runtimeDispatchJs = r'''
function runAction(action, ctx) {
  if (!action) return;
  const verb = action.verb;
  const args = action.args;
  ctx = ctx || {};

  switch (verb) {
    case 'noop':
      return;
    case 'surface.open':
      openSurface(args[0], args[1], { trigger: ctx.trigger });
      return;
    case 'surface.close':
      closeSurface(args[0], args[1]);
      return;
    case 'surface.toggle':
      toggleSurface(args[0], args[1], { trigger: ctx.trigger });
      return;
    case 'surface.dismiss': {
      const surface = withinSurface(ctx.trigger);
      if (surface) {
        closeSurface(surfaceType(surface), surfaceId(surface));
      } else {
        dismissTopSurface();
      }
      return;
    }
    case 'value.set':
      setGroupValue(args[0], args[1] || '');
      return;
    case 'value.toggle':
      toggleGroupValue(args[0], args[1] || '');
      return;
    case 'value.clear':
      clearGroup(args[0]);
      return;
    case 'tab.activate':
      activateTab(args[0], args[1]);
      return;
    case 'panel.expand':
      expandPanel(args[0], args[1]);
      return;
    case 'panel.collapse':
      collapsePanel(args[0], args[1]);
      return;
    case 'panel.toggle':
      togglePanel(args[0], args[1]);
      return;
    case 'step.go':
      goToStep(args[0], args[1]);
      return;
    case 'page.go':
      goToPage(args[0], args[1]);
      return;
    case 'carousel.go':
      goToSlide(args[0], args[1]);
      return;
    case 'slider.set':
      setSliderValue(args[0], args[1] || '0', args[2]);
      return;
    case 'cycle.next':
      cycleStep(args[0], 1);
      return;
    case 'cycle.prev':
      cycleStep(args[0], -1);
      return;
    case 'calendar.prev':
      calendarPrev(args[0]);
      return;
    case 'calendar.next':
      calendarNext(args[0]);
      return;
    case 'calendar.today':
      calendarToday(args[0]);
      return;
    case 'calendar.select':
      calendarSelect(args[0], (ctx.trigger && ctx.trigger.getAttribute) ? ctx.trigger.getAttribute('data-arcane-value') : args[1]);
      return;
    case 'command.filter': {
      const inp = ctx.trigger;
      const q = inp && inp.value !== undefined ? inp.value : (args[1] || '');
      filterCommand(args[0], q);
      return;
    }
    case 'command.selectFirst':
      commandSelectFirst(args[0]);
      return;
    case 'form.submit':
      submitForm(args[0]);
      return;
    case 'form.reset':
      resetForm(args[0]);
      return;
    case 'form.validate':
      validateForm(args[0]);
      return;
    case 'field.set':
      setFieldValue(args[0], args[1], args[2] || '');
      return;
    case 'copy':
      copyText(args[0] || '', args[1]);
      return;
    case 'nav.go':
      navGo(args[0]);
      return;
    case 'nav.external':
      navExternal(args[0]);
      return;
    case 'nav.back':
      navBack();
      return;
    case 'theme.mode.set':
      setThemeMode(args[0]);
      return;
    case 'theme.mode.toggle':
      toggleThemeMode();
      return;
    case 'theme.stylesheet.set':
      setStylesheet(args[0]);
      return;
    case 'theme.palette.set': {
      const parts = (args[0] || '').split('/');
      setPalette(parts[0] || '', parts[1] || '');
      return;
    }
    case 'toast.show': {
      const payload = readJson(args[0], { message: args[0] || '' });
      showToast(payload);
      return;
    }
    case 'event.dispatch': {
      const detail = args[1] ? readJson(args[1], {}) : {};
      fireEvent(document, args[0], detail);
      return;
    }
    case 'script.run': {
      const fn = ARCANE.scripts[args[0]];
      if (typeof fn === 'function') {
        fn.apply(null, args.slice(1));
      }
      return;
    }
    default:
      if (verb && verb.indexOf(':') > 0) {
        fireEvent(document, verb, { args: args, ctx: ctx });
        return;
      }
      console.warn('[arcane] unknown action:', verb);
  }
}

function runActions(str, ctx) {
  if (!str) return;
  const list = parseActions(str);
  for (let i = 0; i < list.length; i++) {
    runAction(list[i], ctx);
  }
}

ARCANE.run = runActions;
ARCANE.runOne = runAction;
''';

const String runtimeDelegationJs = r'''
function findActionTarget(el, attr) {
  let cur = el;
  while (cur && cur !== document) {
    if (cur.nodeType === 1 && cur.hasAttribute(attr)) return cur;
    cur = cur.parentNode;
  }
  return null;
}

function shouldHandleClick(el) {
  if (!el) return false;
  if (el.hasAttribute('data-arcane-disabled')) return false;
  if (el.hasAttribute('disabled')) return false;
  return true;
}

function autoDismissAfterAction(trigger) {
  if (!trigger) return;
  if (trigger.getAttribute('data-arcane-keep-open') === 'true') return;
  const surf = withinSurface(trigger);
  if (!surf) return;
  const stype = surfaceType(surf);
  if (stype !== 'menu' && stype !== 'context-menu' && stype !== 'popover') return;
  if (surf.getAttribute('data-arcane-keep-open-on-action') === 'true') return;
  const sid = surfaceId(surf);
  setTimeout(function() { closeSurface(stype, sid); }, 0);
}

function onDocumentClick(e) {
  if (e.defaultPrevented) return;

  const trigger = findActionTarget(e.target, 'data-arcane-action');
  if (trigger && shouldHandleClick(trigger)) {
    if (trigger.tagName === 'A' && trigger.getAttribute('href')) {
      const href = trigger.getAttribute('href');
      if (href.indexOf('#') !== 0 && trigger.target !== '_blank') {
        e.preventDefault();
      }
    }
    if (trigger.tagName === 'BUTTON' || trigger.getAttribute('role') === 'button') {
      e.preventDefault();
    }
    runActions(trigger.getAttribute('data-arcane-action'), { trigger: trigger, event: e });
    autoDismissAfterAction(trigger);
    return;
  }

  if (ARCANE.stack.length > 0) {
    const top = ARCANE.stack[ARCANE.stack.length - 1];
    const surfaceEl = top.el;
    if (surfaceEl && !surfaceEl.contains(e.target)) {
      const scrimCloses = surfaceEl.getAttribute('data-arcane-scrim-closes') !== 'false';
      const dismissible = surfaceEl.getAttribute('data-arcane-dismissible') !== 'false';
      if (scrimCloses && dismissible) {
        if ((top.type === 'popover' || top.type === 'menu' || top.type === 'context-menu' || top.type === 'tooltip') ||
            e.target.classList.contains('arcane-overlay-scrim') ||
            e.target.hasAttribute('data-arcane-scrim') ||
            (top.type === 'dialog' || top.type === 'sheet' || top.type === 'drawer')) {
          if (top.type === 'dialog' || top.type === 'sheet' || top.type === 'drawer') {
            if (e.target.classList.contains('arcane-overlay-scrim') ||
                e.target.hasAttribute('data-arcane-scrim') ||
                e.target === surfaceEl.parentElement) {
              closeSurface(top.type, top.id);
            }
          } else {
            closeSurface(top.type, top.id);
          }
        }
      }
    }
  }
}

function onDocumentChange(e) {
  const target = findActionTarget(e.target, 'data-arcane-change');
  if (target) {
    runActions(target.getAttribute('data-arcane-change'), { trigger: target, event: e });
  }
  if (e.target.matches && e.target.matches('[data-arcane-form] [data-arcane-field]')) {
    const formEl = findClosest(e.target, '[data-arcane-form]');
    if (formEl) {
      const fid = formEl.getAttribute('data-arcane-form');
      const fname = e.target.getAttribute('data-arcane-field');
      if (fid && fname) validateField(fid, fname);
    }
  }
}

function onDocumentInput(e) {
  const target = findActionTarget(e.target, 'data-arcane-input');
  if (target) {
    runActions(target.getAttribute('data-arcane-input'), { trigger: target, event: e });
  }
}

function onDocumentSubmit(e) {
  const formEl = findActionTarget(e.target, 'data-arcane-form');
  if (formEl) {
    e.preventDefault();
    const fid = formEl.getAttribute('data-arcane-form');
    if (fid) submitForm(fid);
  }
  const target = findActionTarget(e.target, 'data-arcane-submit');
  if (target) {
    runActions(target.getAttribute('data-arcane-submit'), { trigger: target, event: e });
  }
}

function onDocumentDblClick(e) {
  const target = findActionTarget(e.target, 'data-arcane-dblclick');
  if (target) {
    runActions(target.getAttribute('data-arcane-dblclick'), { trigger: target, event: e });
  }
}

function onDocumentContextMenu(e) {
  const target = findActionTarget(e.target, 'data-arcane-contextmenu');
  if (target) {
    e.preventDefault();
    runActions(target.getAttribute('data-arcane-contextmenu'), { trigger: target, event: e });
  }
}

function onDocumentKeyDown(e) {
  if (e.defaultPrevented) return;
  if (e.key === 'Escape') {
    if (ARCANE.stack.length > 0) {
      const top = ARCANE.stack[ARCANE.stack.length - 1];
      const surfaceEl = top.el;
      if (surfaceEl && surfaceEl.getAttribute('data-arcane-escape-closes') !== 'false') {
        closeSurface(top.type, top.id);
        e.preventDefault();
        e.stopPropagation();
        return;
      }
    }
  }
  if (e.key === 'Tab' && ARCANE.stack.length > 0) {
    const top = ARCANE.stack[ARCANE.stack.length - 1];
    const surfaceEl = top.el;
    if (surfaceEl && (top.type === 'dialog' || top.type === 'sheet' ||
        surfaceEl.getAttribute('data-arcane-focus-trap') === 'true')) {
      trapFocus(surfaceEl, e);
    }
  }
  if (e.key === 'Enter' || e.key === ' ') {
    const target = e.target;
    if (target && target.matches && target.matches('[data-arcane-action]') &&
        target.tagName !== 'BUTTON' && target.tagName !== 'A' &&
        target.tagName !== 'INPUT' && target.tagName !== 'TEXTAREA' &&
        target.tagName !== 'SELECT') {
      e.preventDefault();
      runActions(target.getAttribute('data-arcane-action'), { trigger: target, event: e });
    }
  }
  if (e.key === 'ArrowLeft' || e.key === 'ArrowRight' ||
      e.key === 'ArrowUp' || e.key === 'ArrowDown') {
    handleArrowKey(e);
  }

  const keyTarget = findActionTarget(e.target, 'data-arcane-keydown');
  if (keyTarget) {
    runActions(keyTarget.getAttribute('data-arcane-keydown'), { trigger: keyTarget, event: e });
  }
}

function handleArrowKey(e) {
  const tab = findClosest(e.target, '[role="tab"][data-arcane-tab]');
  if (tab) {
    const groupId = tab.getAttribute('data-arcane-tabs-group');
    const orientation = (findClosest(tab, '[data-arcane-tabs-orientation]') || {}).getAttribute &&
      findClosest(tab, '[data-arcane-tabs-orientation]').getAttribute('data-arcane-tabs-orientation') || 'horizontal';
    const isHorizontal = orientation === 'horizontal';
    const forward = isHorizontal ? e.key === 'ArrowRight' : e.key === 'ArrowDown';
    const backward = isHorizontal ? e.key === 'ArrowLeft' : e.key === 'ArrowUp';
    if (forward || backward) {
      e.preventDefault();
      const triggers = Array.prototype.slice.call(document.querySelectorAll(
        '[data-arcane-tabs-group="' + cssEscape(groupId) + '"][data-arcane-tab]'
      ));
      const idx = triggers.indexOf(tab);
      let next = forward ? idx + 1 : idx - 1;
      if (next < 0) next = triggers.length - 1;
      if (next >= triggers.length) next = 0;
      const nextTab = triggers[next];
      if (nextTab) {
        activateTab(groupId, nextTab.getAttribute('data-arcane-tab'));
        nextTab.focus();
      }
      return;
    }
  }

  const opt = findClosest(e.target, '[data-arcane-group][data-arcane-value]');
  if (opt) {
    const surf = withinSurface(opt);
    if (surf && (surfaceType(surf) === 'menu' || surfaceType(surf) === 'context-menu' ||
        surfaceType(surf) === 'popover' || surfaceType(surf) === 'command')) {
      const forward = e.key === 'ArrowDown';
      const backward = e.key === 'ArrowUp';
      if (forward || backward) {
        e.preventDefault();
        const groupId = opt.getAttribute('data-arcane-group');
        const items = Array.prototype.slice.call(surf.querySelectorAll(
          '[data-arcane-group="' + cssEscape(groupId) + '"][data-arcane-value]:not([data-arcane-disabled="true"])'
        ));
        const idx = items.indexOf(opt);
        let next = forward ? idx + 1 : idx - 1;
        if (next < 0) next = items.length - 1;
        if (next >= items.length) next = 0;
        if (items[next]) items[next].focus();
        return;
      }
    }
  }
}

function onPointerOver(e) {
  const trigger = findActionTarget(e.target, 'data-arcane-mouseenter');
  if (trigger) {
    runActions(trigger.getAttribute('data-arcane-mouseenter'), { trigger: trigger, event: e });
  }
  const hoverTrigger = findActionTarget(e.target, 'data-arcane-hover-target');
  if (hoverTrigger) {
    const targetId = hoverTrigger.getAttribute('data-arcane-hover-target');
    const surfaceType = hoverTrigger.getAttribute('data-arcane-hover-surface') || 'tooltip';
    const delay = parseInt(hoverTrigger.getAttribute('data-arcane-hover-delay') || '120', 10);
    if (hoverTrigger._arcaneHoverTimer) clearTimeout(hoverTrigger._arcaneHoverTimer);
    hoverTrigger._arcaneHoverTimer = setTimeout(function() {
      openSurface(surfaceType, targetId, { trigger: hoverTrigger });
    }, delay);
  }
}

function onPointerOut(e) {
  const trigger = findActionTarget(e.target, 'data-arcane-mouseleave');
  if (trigger && !trigger.contains(e.relatedTarget)) {
    runActions(trigger.getAttribute('data-arcane-mouseleave'), { trigger: trigger, event: e });
  }
  const hoverTrigger = findActionTarget(e.target, 'data-arcane-hover-target');
  if (hoverTrigger && !hoverTrigger.contains(e.relatedTarget)) {
    if (hoverTrigger._arcaneHoverTimer) clearTimeout(hoverTrigger._arcaneHoverTimer);
    const targetId = hoverTrigger.getAttribute('data-arcane-hover-target');
    const surfaceType = hoverTrigger.getAttribute('data-arcane-hover-surface') || 'tooltip';
    const delay = parseInt(hoverTrigger.getAttribute('data-arcane-hover-close-delay') || '60', 10);
    hoverTrigger._arcaneHoverTimer = setTimeout(function() {
      const surf = querySurface(surfaceType, targetId);
      if (surf && !surf.matches(':hover')) {
        closeSurface(surfaceType, targetId);
      }
    }, delay);
  }
}

function onFocusIn(e) {
  const trigger = findActionTarget(e.target, 'data-arcane-focus');
  if (trigger) {
    runActions(trigger.getAttribute('data-arcane-focus'), { trigger: trigger, event: e });
  }
}

function onFocusOut(e) {
  const trigger = findActionTarget(e.target, 'data-arcane-blur');
  if (trigger) {
    runActions(trigger.getAttribute('data-arcane-blur'), { trigger: trigger, event: e });
  }
}

ARCANE.delegation = {
  click: onDocumentClick,
  change: onDocumentChange,
  input: onDocumentInput,
  submit: onDocumentSubmit,
  dblclick: onDocumentDblClick,
  contextmenu: onDocumentContextMenu,
  keydown: onDocumentKeyDown,
  pointerover: onPointerOver,
  pointerout: onPointerOut,
  focusin: onFocusIn,
  focusout: onFocusOut
};
''';

const String runtimeBootstrapJs = r'''
function bindGroupItemClicks() {
  document.addEventListener('click', function(e) {
    const item = findClosest(e.target, '[data-arcane-group][data-arcane-value]');
    if (!item) return;
    if (item.hasAttribute('data-arcane-action')) return;
    if (item.tagName === 'INPUT') return;
    const groupId = item.getAttribute('data-arcane-group');
    const root = groupRoot(groupId);
    if (!root || root === item) return;
    const value = item.getAttribute('data-arcane-value');
    const mode = root.getAttribute('data-arcane-group-mode') || 'single';
    if (item.getAttribute('data-arcane-disabled') === 'true') return;
    if (mode === 'multi') toggleGroupValue(groupId, value);
    else setGroupValue(groupId, value);
    if (root.getAttribute('data-arcane-group-close-surface') === 'true') {
      const surf = withinSurface(item);
      if (surf) closeSurface(surfaceType(surf), surfaceId(surf));
    }
  }, true);
}

function bindNativeInputs() {
  document.addEventListener('change', function(e) {
    const inp = e.target;
    if (!inp || !inp.matches) return;
    if (inp.matches('input[data-arcane-group][data-arcane-value]')) {
      const groupId = inp.getAttribute('data-arcane-group');
      const value = inp.getAttribute('data-arcane-value');
      const mode = groupMode(groupId);
      if (mode === 'multi') {
        if (inp.checked) {
          const cur = groupValues(groupId);
          if (cur.indexOf(value) < 0) setGroupRawValues(groupId, cur.concat([value]));
        } else {
          const cur = groupValues(groupId);
          const idx = cur.indexOf(value);
          if (idx >= 0) {
            const next = cur.slice();
            next.splice(idx, 1);
            setGroupRawValues(groupId, next);
          }
        }
      } else if (inp.checked) {
        setGroupValue(groupId, value);
      }
    }
    if (inp.matches('select[data-arcane-group]')) {
      const groupId = inp.getAttribute('data-arcane-group');
      const mode = groupMode(groupId);
      if (mode === 'multi') {
        const values = [];
        for (let i = 0; i < inp.options.length; i++) {
          if (inp.options[i].selected) values.push(inp.options[i].value);
        }
        setGroupRawValues(groupId, values);
      } else {
        setGroupValue(groupId, inp.value);
      }
    }
  }, true);
}

function bindOutsideTabs() {
  document.addEventListener('click', function(e) {
    const tab = findClosest(e.target, '[data-arcane-tab][data-arcane-tabs-group]');
    if (!tab) return;
    if (tab.hasAttribute('data-arcane-action')) return;
    if (tab.getAttribute('data-arcane-disabled') === 'true') return;
    const groupId = tab.getAttribute('data-arcane-tabs-group');
    const tabId = tab.getAttribute('data-arcane-tab');
    activateTab(groupId, tabId);
  }, true);
}

function bindAccordions() {
  document.addEventListener('click', function(e) {
    const trigger = findClosest(e.target, '[data-arcane-panel-group][data-arcane-panel]');
    if (!trigger) return;
    if (trigger.hasAttribute('data-arcane-action')) return;
    if (trigger.getAttribute('data-arcane-disabled') === 'true') return;
    const groupId = trigger.getAttribute('data-arcane-panel-group');
    const panelId = trigger.getAttribute('data-arcane-panel');
    togglePanel(groupId, panelId);
  }, true);
}

function bindCarousels() {
  const carousels = document.querySelectorAll('[data-arcane-carousel][data-arcane-carousel-autoplay]');
  for (let i = 0; i < carousels.length; i++) {
    startCarouselAutoplay(carousels[i]);
  }
}

function bindContextMenus() {
  document.addEventListener('contextmenu', function(e) {
    const trigger = findActionTarget(e.target, 'data-arcane-context-trigger');
    if (!trigger) return;
    e.preventDefault();
    const targetId = trigger.getAttribute('data-arcane-context-trigger');
    const surface = querySurface('context-menu', targetId);
    if (!surface) return;
    surface._arcaneContextX = e.clientX;
    surface._arcaneContextY = e.clientY;
    surface.style.position = 'fixed';
    surface.style.top = e.clientY + 'px';
    surface.style.left = e.clientX + 'px';
    openSurface('context-menu', targetId, { trigger: trigger, skipAnchorListener: true });
  }, true);
}

function hydrateInitialState() {
  hydrateThemeFromStorage();
  const surfaces = document.querySelectorAll('[data-arcane-surface][data-arcane-state="closed"]');
  for (let i = 0; i < surfaces.length; i++) {
    surfaces[i].setAttribute('hidden', '');
    surfaces[i].setAttribute('aria-hidden', 'true');
  }
  const opens = document.querySelectorAll('[data-arcane-surface][data-arcane-state="open"]');
  for (let i = 0; i < opens.length; i++) {
    const el = opens[i];
    el.removeAttribute('hidden');
    el.setAttribute('aria-hidden', 'false');
    ARCANE.stack.push({
      type: el.getAttribute('data-arcane-surface'),
      id: el.getAttribute('data-arcane-id'),
      el: el
    });
  }
}

function arcaneInit() {
  if (ARCANE._initialized) return;
  ARCANE._initialized = true;

  document.addEventListener('click', onDocumentClick, false);
  document.addEventListener('change', onDocumentChange, false);
  document.addEventListener('input', onDocumentInput, false);
  document.addEventListener('submit', onDocumentSubmit, false);
  document.addEventListener('dblclick', onDocumentDblClick, false);
  document.addEventListener('contextmenu', onDocumentContextMenu, false);
  document.addEventListener('keydown', onDocumentKeyDown, false);
  document.addEventListener('pointerover', onPointerOver, false);
  document.addEventListener('pointerout', onPointerOut, false);
  document.addEventListener('focusin', onFocusIn, false);
  document.addEventListener('focusout', onFocusOut, false);

  bindGroupItemClicks();
  bindNativeInputs();
  bindOutsideTabs();
  bindAccordions();
  bindContextMenus();
  bindCarousels();
  bindSliders();
  bindCommandKeyboard();
  bindCalendars();
  bindTimePickers();
  hydrateInitialState();

  fireEvent(document, 'arcane:ready', {});
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', arcaneInit);
} else {
  arcaneInit();
}

ARCANE.init = arcaneInit;
''';
