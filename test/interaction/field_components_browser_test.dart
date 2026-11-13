@TestOn('browser')
library;

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neon/arcane_jaspr_neon.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:arcane_jaspr_win95/arcane_jaspr_win95.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart' show Component;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

const List<(String, ArcaneStylesheet)> _themes = <(String, ArcaneStylesheet)>[
  ('shadcn', ShadcnStylesheet()),
  ('neon', NeonStylesheet()),
  ('neubrutalism', NeubrutalismStylesheet()),
  ('win95', Win95Stylesheet()),
];

Widget _app(Widget home, {ArcaneStylesheet sheet = const ShadcnStylesheet()}) {
  _useStyles(sheet);
  return ArcaneApp(
    stylesheet: sheet,
    brightness: Brightness.light,
    includeFallbackScripts: false,
    home: home,
  );
}

/// ArcaneApp injects the first stylesheet it sees once per page, so every
/// test installs its own theme's rules in place of the earlier ones.
void _useStyles(ArcaneStylesheet sheet) {
  final web.NodeList styles = web.document.head!.querySelectorAll('style');
  for (int index = styles.length - 1; index >= 0; index--) {
    (styles.item(index)! as web.Element).remove();
  }
  final web.HTMLStyleElement style =
      web.document.createElement('style') as web.HTMLStyleElement;
  style.textContent = sheet.baseCss;
  web.document.head!.appendChild(style);
}

web.HTMLElement _element(String selector) =>
    web.document.querySelector(selector)! as web.HTMLElement;

web.DOMRect _rect(String selector) =>
    _element(selector).getBoundingClientRect();

web.CSSStyleDeclaration _style(String selector) =>
    web.window.getComputedStyle(_element(selector));

class _ControlledDisclosure extends StatefulWidget {
  final bool follow;
  final List<bool> requests;

  const _ControlledDisclosure({required this.follow, required this.requests});

  @override
  State<_ControlledDisclosure> createState() => _ControlledDisclosureState();
}

class _ControlledDisclosureState extends State<_ControlledDisclosure> {
  bool open = false;

  @override
  Widget build(BuildContext context) => ArcaneDisclosure(
    open: open,
    classes: const <String>['probe-disclosure'],
    onOpenChange: (bool next) {
      widget.requests.add(next);
      if (widget.follow) setState(() => open = next);
    },
    summary: dom.span(<Widget>[
      const Text('Spawn rules'),
      dom.button(id: 'inside', type: dom.ButtonType.button, <Widget>[
        const Text('Reset'),
      ]),
    ]),
    child: const Text('Only at night.'),
  );
}

Widget _formFrame(double width) => dom.div(
  id: 'frame',
  styles: dom.Styles(raw: <String, String>{'width': '${width}px'}),
  <Widget>[
    const ArcaneFieldGroup(
      children: <Widget>[
        ArcaneFormField(
          controlId: 'name',
          orientation: FieldOrientation.responsive,
          labelWidth: '11.25rem',
          children: <Widget>[
            ArcaneFieldLabel('Name'),
            ArcaneFieldContent(
              children: <Widget>[
                TextInput(),
                ArcaneFieldDescription('Shown above the head.'),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

void main() {
  group('controlled disclosure', () {
    testClient('a summary click asks the owner and follows open', (
      ClientTester tester,
    ) async {
      final List<bool> requests = <bool>[];
      tester.pumpComponent(
        _app(_ControlledDisclosure(follow: true, requests: requests)),
      );
      await pumpEventQueue();
      final web.HTMLDetailsElement details =
          _element('.probe-disclosure') as web.HTMLDetailsElement;
      expect(details.open, isFalse);

      _element('.probe-disclosure > summary').click();
      await pumpEventQueue();
      expect(requests, <bool>[true]);
      expect(details.open, isTrue);

      _element('.probe-disclosure > summary').click();
      await pumpEventQueue();
      expect(requests, <bool>[true, false]);
      expect(details.open, isFalse);

      _element('#inside').click();
      await pumpEventQueue();
      expect(requests, <bool>[true, false]);
      expect(details.open, isFalse);
    });

    testClient('stays as the owner left it when the owner ignores a click', (
      ClientTester tester,
    ) async {
      final List<bool> requests = <bool>[];
      tester.pumpComponent(
        _app(_ControlledDisclosure(follow: false, requests: requests)),
      );
      await pumpEventQueue();
      _element('.probe-disclosure > summary').click();
      await pumpEventQueue();
      expect(requests, <bool>[true]);
      expect(
        (_element('.probe-disclosure') as web.HTMLDetailsElement).open,
        isFalse,
      );
    });

    testClient('reports an open made outside it', (ClientTester tester) async {
      final List<bool> requests = <bool>[];
      tester.pumpComponent(
        _app(_ControlledDisclosure(follow: true, requests: requests)),
      );
      await pumpEventQueue();
      (_element('.probe-disclosure') as web.HTMLDetailsElement).open = true;
      await Future<void>.delayed(const Duration(milliseconds: 50));
      await pumpEventQueue();
      expect(requests, <bool>[true]);
    });
  });

  group('responsive field', () {
    for (final (String name, ArcaneStylesheet sheet) in _themes) {
      testClient('$name puts the label beside the control in a wide group', (
        ClientTester tester,
      ) async {
        tester.pumpComponent(_app(_formFrame(640), sheet: sheet));
        await pumpEventQueue();
        final web.DOMRect label = _rect('[data-slot="field-label"]');
        final web.DOMRect input = _rect('#name');
        expect(label.width, closeTo(180, 1));
        expect(label.right, lessThanOrEqualTo(input.left));
        expect(label.top, closeTo(input.top, 1));
        expect(label.height, closeTo(input.height, 1));
        expect(input.right, closeTo(_rect('#frame').right, 1));
      });
    }

    testClient('stacks the label above the control in a narrow group', (
      ClientTester tester,
    ) async {
      tester.pumpComponent(_app(_formFrame(320)));
      await pumpEventQueue();
      final web.DOMRect label = _rect('[data-slot="field-label"]');
      final web.DOMRect input = _rect('#name');
      expect(label.bottom, lessThanOrEqualTo(input.top));
      expect(input.width, closeTo(320, 1));
    });

    testClient('dims a disabled field label', (ClientTester tester) async {
      tester.pumpComponent(
        _app(
          const ArcaneFormField(
            disabled: true,
            children: <Widget>[ArcaneFieldLabel('Locked'), TextInput()],
          ),
        ),
      );
      await pumpEventQueue();
      expect(_style('[data-slot="field-label"]').opacity, '0.5');
    });
  });

  group('resting text controls', () {
    testClient('a bare shadcn input sits on the 36px control scale', (
      ClientTester tester,
    ) async {
      tester.pumpComponent(
        _app(
          dom.div(<Widget>[
            const dom.input(
              id: 'bare',
              classes: 'arcane-text-input',
              attributes: <String, String>{'placeholder': 'Steve'},
            ),
            const dom.input(
              id: 'bad',
              classes: 'arcane-text-input',
              attributes: <String, String>{'aria-invalid': 'true'},
            ),
            const dom.input(
              id: 'off',
              classes: 'arcane-text-input',
              attributes: <String, String>{'disabled': ''},
            ),
            Component.element(
              tag: 'textarea',
              id: 'notes',
              classes: 'arcane-textarea',
            ),
            const dom.span(
              id: 'muted',
              styles: dom.Styles(
                raw: <String, String>{'color': 'var(--muted-foreground)'},
              ),
              <Widget>[Text('m')],
            ),
            const dom.span(
              id: 'danger',
              styles: dom.Styles(
                raw: <String, String>{'color': 'var(--destructive)'},
              ),
              <Widget>[Text('d')],
            ),
          ]),
        ),
      );
      await pumpEventQueue();
      final web.CSSStyleDeclaration bare = _style('#bare');
      expect(bare.height, '36px');
      expect(bare.borderTopWidth, '1px');
      expect(bare.borderTopLeftRadius, isNot('0px'));
      expect(bare.paddingLeft, '12px');
      expect(bare.fontSize, '14px');
      expect(
        web.window.getComputedStyle(_element('#bare'), '::placeholder').color,
        _style('#muted').color,
      );
      expect(_style('#bad').borderTopColor, _style('#danger').color);
      expect(_style('#off').opacity, '0.5');
      expect(_style('#notes').minHeight, '64px');
      expect(_style('#notes').borderTopWidth, '1px');

      final String resting = _style('#bare').boxShadow;
      _element('#bare').focus();
      await pumpEventQueue();
      final String focused = _style('#bare').boxShadow;
      expect(focused, isNot(resting));
      expect(focused.split('px,').length, 2, reason: 'shadow plus ring');
    });

    for (final (String name, ArcaneStylesheet sheet) in _themes) {
      testClient('$name bare inputs match the library controls at rest', (
        ClientTester tester,
      ) async {
        tester.pumpComponent(
          _app(
            sheet: sheet,
            dom.div(
              styles: const dom.Styles(raw: <String, String>{'width': '320px'}),
              <Widget>[
                const TextInput(id: 'library', fullWidth: true),
                const dom.input(id: 'bare', classes: 'arcane-text-input'),
                const TextArea(id: 'library-area'),
                Component.element(
                  tag: 'textarea',
                  id: 'bare-area',
                  classes: 'arcane-textarea',
                  attributes: const <String, String>{'rows': '4'},
                ),
              ],
            ),
          ),
        );
        await pumpEventQueue();
        for (final (String library, String bare) in <(String, String)>[
          ('#library', '#bare'),
          ('#library-area', '#bare-area'),
        ]) {
          final web.CSSStyleDeclaration own = _style(library);
          final web.CSSStyleDeclaration raw = _style(bare);
          final Map<String, String> ownValues = <String, String>{
            'width': own.width,
            'border-top-width': own.borderTopWidth,
            'border-top-style': own.borderTopStyle,
            'border-top-color': own.borderTopColor,
            'border-radius': own.borderTopLeftRadius,
            'padding-left': own.paddingLeft,
            'padding-top': own.paddingTop,
            'background-color': own.backgroundColor,
            'color': own.color,
            'box-shadow': own.boxShadow,
          };
          final Map<String, String> rawValues = <String, String>{
            'width': raw.width,
            'border-top-width': raw.borderTopWidth,
            'border-top-style': raw.borderTopStyle,
            'border-top-color': raw.borderTopColor,
            'border-radius': raw.borderTopLeftRadius,
            'padding-left': raw.paddingLeft,
            'padding-top': raw.paddingTop,
            'background-color': raw.backgroundColor,
            'color': raw.color,
            'box-shadow': raw.boxShadow,
          };
          if (library == '#library') {
            ownValues['height'] = own.height;
            rawValues['height'] = raw.height;
          }
          expect(rawValues, ownValues, reason: '$name $bare');
        }
      });
    }
  });
}
