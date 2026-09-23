import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import test from 'node:test';
import vm from 'node:vm';

const source = readFileSync(new URL('../../lib/util/interactivity/scripts/input/radio_scripts.dart', import.meta.url), 'utf8');
const script = source.match(/static const String code = r'''([\s\S]*?)''';/)[1];

test('legacy radio binder leaves runtime groups and their native styling alone', () => {
  const runtimeGroup = {
    dataset: {},
    hasAttribute: name => name === 'data-arcane-group',
    querySelectorAll: () => assert.fail('Runtime groups must keep their native handlers'),
  };
  let bindings = 0;
  const legacyGroup = {
    dataset: {},
    hasAttribute: () => false,
    querySelectorAll: () => [{
      querySelector: () => ({ disabled: false }),
      addEventListener: event => {
        assert.equal(event, 'click');
        bindings += 1;
      },
    }],
  };
  const context = vm.createContext({
    document: { querySelectorAll: () => [runtimeGroup, legacyGroup] },
  });
  vm.runInContext(`${script}\nbindRadioButtons(); bindRadioButtons();`, context);
  assert.deepEqual(runtimeGroup.dataset, {});
  assert.equal(legacyGroup.dataset.arcaneInteractive, 'true');
  assert.equal(bindings, 1);
});
