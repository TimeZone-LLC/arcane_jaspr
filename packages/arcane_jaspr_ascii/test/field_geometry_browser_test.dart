@TestOn('browser')
library;

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/component/input/native_select.dart';
import 'package:arcane_jaspr/component/input/time_picker.dart';
import 'package:arcane_jaspr_ascii/arcane_jaspr_ascii.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

const List<ArcaneSelectOption> _options = <ArcaneSelectOption>[
  ArcaneSelectOption(value: 'measured', label: 'Measured / 1.4 s'),
];

Widget _cell(String id, Widget child) => dom.div(
  <Widget>[child],
  id: id,
  styles: const dom.Styles(raw: <String, String>{'min-width': '0'}),
);

Widget _fields(Brightness brightness, ComponentSize size, int width) =>
    ArcaneApp(
      stylesheet: const AsciiStylesheet(),
      brightness: brightness,
      includeFallbackScripts: false,
      home: dom.div(
        <Widget>[
          _cell(
            'plain',
            TextInput(
              label: 'Field label',
              value: 'Measured',
              size: size,
              fullWidth: true,
            ),
          ),
          _cell(
            'native',
            ArcaneSelect(
              label: 'Field label',
              options: _options,
              value: 'measured',
              size: size,
              fullWidth: true,
            ),
          ),
          _cell(
            'affix',
            TextInput(
              label: 'Field label',
              value: 'Measured',
              size: size,
              fullWidth: true,
              prefix: const Text('@'),
              suffix: const Text('kg'),
            ),
          ),
          _cell(
            'native-alias',
            ArcaneNativeSelect(
              label: 'Field label',
              options: _options,
              value: 'measured',
              size: size,
              fullWidth: true,
            ),
          ),
          _cell(
            'combo',
            ArcaneCombobox<String>(
              label: 'Field label',
              value: 'measured',
              size: ComboboxSize.values[size.index],
              options: const <ComboboxOption<String>>[
                ComboboxOption<String>(value: 'measured', label: 'Measured'),
              ],
            ),
          ),
          _cell(
            'date',
            ArcaneDatePicker(
              label: 'Field label',
              placeholder: 'Measured',
              size: DatePickerSize.values[size.index],
            ),
          ),
          _cell(
            'time',
            ArcaneTimePicker(
              label: 'Field label',
              placeholder: 'Measured',
              size: size,
            ),
          ),
          _cell(
            'wrapped',
            ArcaneFieldWrapper(
              labelText: 'Field label',
              field: TextInput(value: 'Measured', size: size, fullWidth: true),
            ),
          ),
          _cell(
            'textarea',
            const TextArea(label: 'Field label', value: 'Measured', rows: 2),
          ),
          _cell(
            'button',
            Button(label: 'Measured', size: ButtonSize.values[size.index]),
          ),
        ],
        id: 'geometry-grid',
        classes: 'kb-prose',
        styles: dom.Styles(
          raw: <String, String>{
            'display': 'grid',
            'grid-template-columns': 'repeat(2, minmax(0, 1fr))',
            'gap': '16px',
            'width': '${width}px',
            'font-size': '16px',
            'line-height': '1.75',
          },
        ),
      ),
    );

web.HTMLElement _element(String selector) =>
    web.document.querySelector(selector)! as web.HTMLElement;

void main() {
  for (final Brightness brightness in Brightness.values) {
    for (final int width in <int>[600, 280]) {
      testClient('${brightness.name} fields share geometry at ${width}px', (
        ClientTester tester,
      ) async {
        for (final ComponentSize size in ComponentSize.values) {
          tester.pumpComponent(_fields(brightness, size, width));
          await pumpEventQueue();
          final double expectedHeight = <double>[32, 36, 40][size.index];
          for (final MapEntry<String, String> entry in <String, String>{
            'plain': 'input',
            'native': 'select',
            'affix': '.arcane-text-input-container',
            'native-alias': 'select',
            'combo': '.arcane-select',
            'date': '.arcane-date-picker-trigger',
            'time': '.arcane-time-picker-trigger',
            'wrapped': 'input',
          }.entries) {
            final web.HTMLElement cell = _element('#${entry.key}');
            final web.HTMLElement control = _element(
              '#${entry.key} ${entry.value}',
            );
            final web.DOMRect cellRect = cell.getBoundingClientRect();
            final web.DOMRect controlRect = control.getBoundingClientRect();
            final String reason = '${size.name} ${entry.key} at ${width}px';
            expect(
              controlRect.height,
              closeTo(expectedHeight, 0.1),
              reason: reason,
            );
            expect(
              controlRect.top - cellRect.top,
              closeTo(28, 0.1),
              reason: '$reason label and gap',
            );
            expect(
              controlRect.left,
              closeTo(cellRect.left, 0.1),
              reason: '$reason left edge',
            );
            expect(
              controlRect.width,
              closeTo(cellRect.width, 0.1),
              reason: '$reason width',
            );
            final web.HTMLElement textControl = entry.key == 'affix'
                ? _element('#affix input')
                : control;
            final web.CSSStyleDeclaration style = web.window.getComputedStyle(
              textControl,
            );
            expect(style.fontSize, '14px', reason: reason);
            expect(style.lineHeight, '20px', reason: reason);
            expect(style.fontFamily, contains('monospace'), reason: reason);
            expect(
              style.paddingLeft,
              entry.key == 'affix' ? '8px' : '12px',
              reason: reason,
            );
          }
          final web.HTMLElement textarea = _element('#textarea textarea');
          expect(
            textarea.getBoundingClientRect().top -
                _element('#textarea').getBoundingClientRect().top,
            closeTo(28, 0.1),
          );
          expect(
            web.window.getComputedStyle(textarea).fontFamily,
            contains('monospace'),
          );
          expect(
            _element('#button button').getBoundingClientRect().height,
            closeTo(expectedHeight, 0.1),
          );
          expect(
            _element('#geometry-grid').scrollWidth,
            lessThanOrEqualTo(width),
          );
        }
      });
    }
  }

  for (final Brightness brightness in Brightness.values) {
    testClient('${brightness.name} command focus frames the full search row', (
      ClientTester tester,
    ) async {
      tester.pumpComponent(
        ArcaneApp(
          stylesheet: const AsciiStylesheet(),
          brightness: brightness,
          includeFallbackScripts: false,
          home: const Column(
            children: <Widget>[
              dom.button(id: 'outside-command', <Widget>[Text('Outside')]),
              ArcaneCommand(
                isOpen: true,
                groups: <CommandGroup>[
                  CommandGroup(
                    items: <CommandItem>[CommandItem(label: 'Open')],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      await pumpEventQueue();
      final web.HTMLElement input = _element('.arcane-command-input');
      input.focus();
      await pumpEventQueue();
      expect(input.matches(':focus-visible'), isTrue);
      expect(web.window.getComputedStyle(input).outlineStyle, 'none');
      final web.HTMLElement row = _element('.arcane-command-search-row');
      final web.CSSStyleDeclaration focus = web.window.getComputedStyle(row);
      expect(focus.outlineStyle, 'solid');
      expect(focus.outlineWidth, '2px');
      expect(focus.outlineOffset, '-2px');
      final web.DOMRect bounds = _element(
        '.arcane-command-dialog',
      ).getBoundingClientRect();
      final web.DOMRect rowRect = row.getBoundingClientRect();
      expect(rowRect.left, greaterThanOrEqualTo(bounds.left));
      expect(rowRect.right, lessThanOrEqualTo(bounds.right));
      expect(rowRect.top, greaterThanOrEqualTo(bounds.top));
      expect(rowRect.bottom, lessThanOrEqualTo(bounds.bottom));
      final web.DOMRect icon = row.firstElementChild!.getBoundingClientRect();
      expect(icon.left, greaterThanOrEqualTo(rowRect.left));
      expect(icon.right, lessThan(input.getBoundingClientRect().left));
      _element('#outside-command').focus();
      await pumpEventQueue();
      expect(web.window.getComputedStyle(row).outlineStyle, 'none');
    });
  }

  testClient('input groups shrink fields without squeezing actions', (
    ClientTester tester,
  ) async {
    tester.pumpComponent(
      const ArcaneApp(
        stylesheet: AsciiStylesheet(),
        includeFallbackScripts: false,
        home: dom.div(
          <Widget>[
            ArcaneInputGroup(
              children: <Widget>[
                TextInput(placeholder: 'Search', fullWidth: true),
                Button(label: 'Search'),
              ],
            ),
          ],
          id: 'narrow-group',
          styles: dom.Styles(raw: <String, String>{'width': '220px'}),
        ),
      ),
    );
    await pumpEventQueue();
    final web.DOMRect field = _element(
      '#narrow-group input',
    ).getBoundingClientRect();
    final web.DOMRect action = _element(
      '#narrow-group button',
    ).getBoundingClientRect();
    expect(field.top, closeTo(action.top, 0.1));
    expect(field.height, closeTo(action.height, 0.1));
    expect(action.left - field.right, closeTo(8, 0.1));
    expect(_element('#narrow-group').scrollWidth, lessThanOrEqualTo(220));
  });

  testClient('wrapping labels retain their gap above the field', (
    ClientTester tester,
  ) async {
    const String label = 'A descriptive field label that wraps';
    tester.pumpComponent(
      const ArcaneApp(
        stylesheet: AsciiStylesheet(),
        includeFallbackScripts: false,
        home: dom.div(
          <Widget>[
            TextInput(label: label, fullWidth: true),
            ArcaneSelect(label: label, options: _options, fullWidth: true),
          ],
          id: 'wrapped-labels',
          styles: dom.Styles(
            raw: <String, String>{
              'display': 'grid',
              'grid-template-columns': 'repeat(2, minmax(0, 1fr))',
              'gap': '16px',
              'width': '280px',
              'line-height': '1.75',
            },
          ),
        ),
      ),
    );
    await pumpEventQueue();
    final web.NodeList labels = _element(
      '#wrapped-labels',
    ).querySelectorAll('label');
    for (int index = 0; index < labels.length; index++) {
      final web.Element label = labels.item(index)! as web.Element;
      final web.DOMRect labelRect = label.getBoundingClientRect();
      final String id = label.getAttribute('for')!;
      final web.DOMRect field = _element('#$id').getBoundingClientRect();
      expect(labelRect.height, greaterThan(20));
      expect(field.top - labelRect.bottom, closeTo(8, 0.1));
    }
    expect(_element('#wrapped-labels').scrollWidth, lessThanOrEqualTo(280));
  });

  testClient('literal field sizing remains available', (
    ClientTester tester,
  ) async {
    const ArcaneStyleData override = ArcaneStyleData(
      heightCustom: '56px',
      fontSizeCustom: '18px',
    );
    tester.pumpComponent(
      const ArcaneApp(
        stylesheet: AsciiStylesheet(),
        includeFallbackScripts: false,
        home: Column(
          children: <Widget>[
            TextInput(id: 'custom-input', styles: override),
            ArcaneSelect(
              id: 'custom-native',
              options: _options,
              styles: override,
            ),
            ArcaneNativeSelect(
              id: 'custom-native-alias',
              options: _options,
              styles: override,
            ),
          ],
        ),
      ),
    );
    await pumpEventQueue();
    for (final String id in <String>[
      'custom-input',
      'custom-native',
      'custom-native-alias',
    ]) {
      final web.HTMLElement control = _element('#$id');
      expect(control.getBoundingClientRect().height, 56);
      expect(web.window.getComputedStyle(control).fontSize, '18px');
    }
  });
}
