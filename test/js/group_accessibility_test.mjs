import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { test } from 'node:test';
import vm from 'node:vm';

const source = readFileSync(new URL('../../lib/core/interaction/runtime/runtime_state_js.dart', import.meta.url), 'utf8');
const script = source.match(/const String runtimeGroupsJs = r'''([\s\S]*?)''';/)[1];

function item(role) {
  const attributes = new Map([['role', role], ['data-arcane-value', 'enabled']]);
  return {
    tagName: 'BUTTON',
    getAttribute: name => attributes.get(name) ?? null,
    setAttribute: (name, value) => attributes.set(name, value),
  };
}

test('group selection and deselection update the correct accessible state', () => {
  const root = {};
  const controls = ['checkbox', 'switch', 'radio', 'menuitemcheckbox', 'menuitemradio', 'option', 'tab'].map(item);
  const context = vm.createContext({
    ARCANE: { groups: {} },
    cssEscape: value => value,
    document: { querySelector: () => root, querySelectorAll: () => controls },
  });
  vm.runInContext(script, context);
  for (const selected of [true, false]) {
    context.syncGroupItems('preferences', selected ? ['enabled'] : []);
    for (const control of controls) {
      const selectable = ['option', 'tab'].includes(control.getAttribute('role'));
      assert.equal(control.getAttribute(selectable ? 'aria-selected' : 'aria-checked'), String(selected));
      assert.equal(control.getAttribute(selectable ? 'aria-checked' : 'aria-selected'), null);
      if (!selectable) assert.equal(control.getAttribute('data-state'), selected ? 'checked' : 'unchecked');
    }
  }
});
