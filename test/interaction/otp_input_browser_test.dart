@TestOn('browser')
library;

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/core/interaction/runtime/runtime.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart' show StatefulBuilder, StateSetter;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

const List<(String, ArcaneStylesheet, int)> _cases =
    <(String, ArcaneStylesheet, int)>[
      ('classic', NeubrutalismStylesheet(), 4),
      (
        'neuComic',
        NeubrutalismStylesheet(variant: NeubrutalismVariant.neuComic),
        4,
      ),
      ('shadcn', ShadcnStylesheet(), 6),
    ];

web.HTMLInputElement _digit(String container, int index) =>
    web.document.querySelector('#$container [data-otp-index="$index"]')!
        as web.HTMLInputElement;

List<String> _values(String container, int length) => <String>[
  for (int index = 0; index < length; index++) _digit(container, index).value,
];

Future<void> _settle() async {
  await pumpEventQueue();
  await Future<void>.delayed(const Duration(milliseconds: 40));
}

Future<void> _type(String container, int index, String value) async {
  final web.HTMLInputElement input = _digit(container, index);
  input.focus();
  input.value = value;
  input.dispatchEvent(
    web.InputEvent(
      'input',
      web.InputEventInit(data: value, inputType: 'insertText', bubbles: true),
    ),
  );
  await _settle();
}

Future<void> _key(String container, int index, String key) async {
  final web.HTMLInputElement input = _digit(container, index);
  input.focus();
  final web.KeyboardEvent event = web.KeyboardEvent(
    'keydown',
    web.KeyboardEventInit(key: key, bubbles: true, cancelable: true),
  );
  input.dispatchEvent(event);
  if (key == 'Backspace' && !event.defaultPrevented && input.value.isNotEmpty) {
    // Synthetic key events do not perform the browser's default text edit.
    input.value = '';
    input.dispatchEvent(
      web.InputEvent(
        'input',
        web.InputEventInit(inputType: 'deleteContentBackward', bubbles: true),
      ),
    );
  }
  await _settle();
}

Future<void> _paste(String container, int index, String text) async {
  final web.HTMLInputElement input = _digit(container, index);
  input.focus();
  final web.DataTransfer clipboard = web.DataTransfer();
  clipboard.setData('text/plain', text);
  input.dispatchEvent(
    web.ClipboardEvent(
      'paste',
      web.ClipboardEventInit(
        clipboardData: clipboard,
        bubbles: true,
        cancelable: true,
      ),
    ),
  );
  await _settle();
}

void _installRuntime() {
  web.document.head!.appendChild(
    web.HTMLScriptElement()..text = arcaneInteractivityRuntimeJs,
  );
}

class _FallbackOtp extends StatelessWidget {
  const _FallbackOtp();

  @override
  Widget build(BuildContext context) =>
      context.renderers.otpInput(const OtpInputProps(length: 4));
}

void main() {
  for (final (String name, ArcaneStylesheet stylesheet, int length) in _cases) {
    testClient('$name $length-digit OTP advances, edits and pastes once', (
      ClientTester tester,
    ) async {
      final List<String> changes = <String>[];
      final List<String> completions = <String>[];
      final List<String> disabledChanges = <String>[];
      String controlledValue = '1';
      late StateSetter updateParent;
      tester.pumpComponent(
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            updateParent = setState;
            return ArcaneApp(
              stylesheet: stylesheet,
              includeFallbackScripts: false,
              home: dom.div(<Widget>[
                dom.div(id: 'pin', <Widget>[
                  ArcaneOtpInput(
                    length: length,
                    value: controlledValue,
                    label: 'Verification code',
                    onChanged: (String value) {
                      changes.add(value);
                      updateParent(() => controlledValue = value);
                    },
                    onComplete: completions.add,
                  ),
                ]),
                dom.div(id: 'disabled-pin', <Widget>[
                  ArcaneOtpInput.fourDigit(
                    disabled: true,
                    onChanged: disabledChanges.add,
                  ),
                ]),
              ]),
            );
          },
        ),
      );
      _installRuntime();
      await _settle();
      expect(_values('pin', length), <String>[
        '1',
        for (int index = 1; index < length; index++) '',
      ]);
      expect(changes, isEmpty);
      final String code = length == 4 ? '4567' : '456789';
      for (int index = 0; index < length; index++) {
        await _type('pin', index, code[index]);
        expect(
          web.document.activeElement,
          _digit('pin', index + 1 < length ? index + 1 : index),
          reason: 'Typing a digit advances exactly one slot.',
        );
      }
      expect(_values('pin', length).join(), code);
      expect(changes, <String>[
        for (int count = 1; count <= length; count++) code.substring(0, count),
      ]);
      expect(completions, <String>[code]);
      await _type('pin', length - 1, code[length - 1]);
      expect(
        changes,
        hasLength(length),
        reason: 'No callback for the same digit.',
      );
      expect(completions, hasLength(1));

      await _key('pin', length - 1, 'ArrowLeft');
      expect(web.document.activeElement, _digit('pin', length - 2));
      expect(_digit('pin', length - 2).selectionStart, 0);
      expect(_digit('pin', length - 2).selectionEnd, 1);
      await _key('pin', length - 2, 'ArrowRight');
      expect(web.document.activeElement, _digit('pin', length - 1));
      await _key('pin', length - 1, 'Backspace');
      expect(_digit('pin', length - 1).value, '');
      expect(web.document.activeElement, _digit('pin', length - 1));
      expect(changes, hasLength(length + 1));
      expect(changes.last, code.substring(0, length - 1));
      await _key('pin', length - 1, 'Backspace');
      expect(web.document.activeElement, _digit('pin', length - 2));
      expect(changes, hasLength(length + 1));
      await _type('pin', length - 2, '0');
      expect(
        _digit('pin', length - 1).value,
        '',
        reason: 'A rebuild must not restore the deleted digit.',
      );
      await _type('pin', length - 1, 'x');
      expect(_digit('pin', length - 1).value, '');
      expect(web.document.activeElement, _digit('pin', length - 1));
      expect(changes, hasLength(length + 2));
      await _type('pin', length - 1, '9');
      expect(completions, <String>[code, '${code.substring(0, length - 2)}09']);

      await _paste('pin', 1, 'ignore this');
      expect(changes, hasLength(length + 3));
      expect(web.document.activeElement, _digit('pin', 1));
      await _paste('pin', 1, '9 8-7 6 5 4 3 2');
      final String pasted = length == 4 ? '9876' : '987654';
      expect(_values('pin', length).join(), pasted);
      expect(web.document.activeElement, _digit('pin', length - 1));
      expect(changes, hasLength(length + 4), reason: 'Paste is a single edit.');
      expect(completions, hasLength(3));
      expect(completions.last, pasted);
      await _paste('pin', 1, '5-4');
      expect(_values('pin', length), <String>[
        '9',
        '5',
        '4',
        for (int index = 3; index < length; index++) '',
      ]);
      expect(web.document.activeElement, _digit('pin', 3));
      expect(changes, hasLength(length + 5));
      expect(changes.last, '954');
      expect(
        completions,
        hasLength(3),
        reason: 'Partial paste clears the stale tail.',
      );
      await _key('pin', 1, 'Backspace');
      expect(_values('pin', length), <String>[
        '9',
        '',
        '4',
        for (int index = 3; index < length; index++) '',
      ], reason: 'Echoing onChanged preserves an empty slot between digits.');
      expect(changes, hasLength(length + 6));
      expect(changes.last, '94');

      updateParent(() => controlledValue = '09');
      await _settle();
      expect(_values('pin', length), <String>[
        '0',
        '9',
        for (int index = 2; index < length; index++) '',
      ]);
      expect(changes, hasLength(length + 6));
      updateParent(() => controlledValue = '');
      await _settle();
      expect(_values('pin', length), everyElement(isEmpty));
      expect(completions, hasLength(3));
      _digit('pin', 0).focus();
      expect(_digit('disabled-pin', 0).disabled, isTrue);
      await _paste('disabled-pin', 0, '1234');
      expect(disabledChanges, isEmpty);
      expect(_values('disabled-pin', 4), everyElement(isEmpty));
      expect(web.document.activeElement, _digit('pin', 0));
    });
  }

  testClient('OTP renderer without callbacks uses the same focus behavior', (
    ClientTester tester,
  ) async {
    tester.pumpComponent(
      const ArcaneApp(
        stylesheet: NeubrutalismStylesheet(),
        includeFallbackScripts: false,
        home: dom.div(id: 'fallback-pin', <Widget>[_FallbackOtp()]),
      ),
    );
    _installRuntime();
    await _settle();
    await _type('fallback-pin', 0, '3');
    expect(web.document.activeElement, _digit('fallback-pin', 1));
    await _paste('fallback-pin', 0, '1 2 3 4');
    expect(_values('fallback-pin', 4), <String>['1', '2', '3', '4']);
    expect(web.document.activeElement, _digit('fallback-pin', 3));
    await _key('fallback-pin', 3, 'Backspace');
    expect(_values('fallback-pin', 4), <String>['1', '2', '3', '']);
    expect(web.document.activeElement, _digit('fallback-pin', 3));
    await _key('fallback-pin', 3, 'Backspace');
    expect(web.document.activeElement, _digit('fallback-pin', 2));
  });
}
