@TestOn('browser')
library;

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/core/interaction/runtime/runtime.dart';
import 'package:arcane_jaspr/util/interactivity/scripts/input/radio_scripts.dart';
import 'package:arcane_jaspr_neon/arcane_jaspr_neon.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:arcane_jaspr_win95/arcane_jaspr_win95.dart';
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

const List<(String, ArcaneStylesheet)> _themes = <(String, ArcaneStylesheet)>[
  ('shadcn', ShadcnStylesheet()),
  ('neon', NeonStylesheet()),
  ('neubrutalism', NeubrutalismStylesheet()),
  ('win95', Win95Stylesheet()),
];

class _Controls extends StatefulWidget {
  final ValueChanged<_ControlsState> onCreate;

  const _Controls({required this.onCreate});

  @override
  State<_Controls> createState() {
    final _ControlsState state = _ControlsState();
    onCreate(state);
    return state;
  }
}

class _ControlsState extends State<_Controls> {
  bool checked = true;
  bool enabled = true;
  String radio = 'first';
  final List<bool> checkboxChanges = <bool>[];
  final List<bool> switchChanges = <bool>[];
  final List<String> radioChanges = <String>[];
  final List<String> textChanges = <String>[];
  final List<String> submissions = <String>[];

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      ArcaneCheckbox(
        checked: checked,
        label: 'Accept terms',
        onChanged: (bool value) => setState(() {
          checked = value;
          checkboxChanges.add(value);
        }),
      ),
      ArcaneToggleSwitch(
        value: enabled,
        label: 'Enable previews',
        onChanged: (bool value) => setState(() {
          enabled = value;
          switchChanges.add(value);
        }),
      ),
      ArcaneRadioGroup<String>(
        name: 'choice',
        value: radio,
        options: const <RadioOption<String>>[
          RadioOption<String>(value: 'first', label: 'First'),
          RadioOption<String>(value: 'second', label: 'Second'),
        ],
        onChanged: (String value) => setState(() {
          radio = value;
          radioChanges.add(value);
        }),
      ),
      TextInput(
        label: 'Title',
        helperText: 'A title for your post',
        onChanged: textChanges.add,
        onSubmitted: submissions.add,
      ),
    ],
  );
}

web.HTMLElement _element(String selector) =>
    web.document.querySelector(selector)! as web.HTMLElement;

Future<void> _click(String selector) async {
  _element(selector).click();
  await pumpEventQueue();
}

void main() {
  setUpAll(() {
    final web.HTMLScriptElement runtime = web.HTMLScriptElement()
      ..text = arcaneInteractivityRuntimeJs;
    web.document.head!.appendChild(runtime);
  });

  for (final (String name, ArcaneStylesheet theme) in _themes) {
    testClient('$name controlled inputs agree with the delegated runtime', (
      ClientTester tester,
    ) async {
      late _ControlsState state;
      tester.pumpComponent(
        ArcaneThemeProvider(
          stylesheet: theme,
          child: _Controls(onCreate: (_ControlsState value) => state = value),
        ),
      );
      await pumpEventQueue();
      final web.HTMLScriptElement legacyRadio = web.HTMLScriptElement()
        ..text = '${RadioScripts.code}\nbindRadioButtons();';
      web.document.head!.appendChild(legacyRadio);
      final String fieldId = _element('input:not([type="radio"])').id;

      await _click('[role="checkbox"]');
      expect(state.checkboxChanges, <bool>[false]);
      expect(
        _element('[role="checkbox"]').getAttribute('aria-checked'),
        'false',
      );
      _element('[role="checkbox"]').dispatchEvent(
        web.KeyboardEvent(
          'keydown',
          web.KeyboardEventInit(key: ' ', bubbles: true, cancelable: true),
        ),
      );
      await pumpEventQueue();
      expect(state.checkboxChanges, <bool>[false, true]);
      expect(
        _element('[role="checkbox"]').getAttribute('aria-checked'),
        'true',
      );
      await _click(r'[id$="-label"]');
      expect(state.checkboxChanges, <bool>[false, true, false]);
      expect(
        _element('[role="checkbox"]').getAttribute('aria-checked'),
        'false',
      );

      await _click('[role="switch"]');
      expect(state.switchChanges, <bool>[false]);
      expect(_element('[role="switch"]').getAttribute('aria-checked'), 'false');
      final String switchLabel = _element(
        '[role="switch"]',
      ).getAttribute('aria-labelledby')!;
      await _click('[id="$switchLabel"]');
      expect(state.switchChanges, <bool>[false, true]);
      expect(_element('[role="switch"]').getAttribute('aria-checked'), 'true');

      if (name != 'neubrutalism') {
        final web.HTMLInputElement first =
            _element('input[type="radio"][value="first"]')
                as web.HTMLInputElement;
        expect(first.checked, isTrue);
        (_element('input[type="radio"][value="second"]').closest('label')!
                as web.HTMLElement)
            .click();
        await pumpEventQueue();
        expect(state.radioChanges, <String>['second']);
        expect(first.checked, isFalse);
        expect(
          (_element('input[type="radio"][value="second"]')
                  as web.HTMLInputElement)
              .checked,
          isTrue,
        );
        await _click('input[type="radio"][value="first"]');
        expect(state.radioChanges, <String>['second', 'first']);
        expect(first.checked, isTrue);
      }

      final web.HTMLInputElement input =
          _element('input:not([type="radio"])') as web.HTMLInputElement;
      expect(input.id, fieldId);
      expect(_element('label[for="$fieldId"]').textContent, 'Title');
      input.value = 'Draft';
      input.dispatchEvent(web.Event('input', web.EventInit(bubbles: true)));
      input.dispatchEvent(
        web.KeyboardEvent(
          'keydown',
          web.KeyboardEventInit(
            key: 'Enter',
            isComposing: true,
            bubbles: true,
            cancelable: true,
          ),
        ),
      );
      await pumpEventQueue();
      expect(state.textChanges, <String>['Draft']);
      expect(state.submissions, isEmpty);
      input.dispatchEvent(
        web.KeyboardEvent(
          'keydown',
          web.KeyboardEventInit(key: 'Enter', bubbles: true, cancelable: true),
        ),
      );
      await pumpEventQueue();
      expect(state.submissions, <String>['Draft']);
    });
  }
}
