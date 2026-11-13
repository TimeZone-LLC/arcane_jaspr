@TestOn('browser')
library;

import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/util/interactivity/scripts/dialog/tooltip_scripts.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart' show EventCallback;
import 'package:jaspr_test/client_test.dart';
import 'package:web/web.dart' as web;

bool _bound = false;

/// The legacy pass a page runs 100 ms after load, once.
void _bindTooltips() {
  if (_bound) return;
  _bound = true;
  web.document.head!.appendChild(
    web.HTMLScriptElement()
      ..text = '(function() { ${TooltipScripts.code}\nbindTooltips(); })();',
  );
}

web.HTMLElement _element(String selector) =>
    web.document.querySelector(selector)! as web.HTMLElement;

web.HTMLElement? _tooltip() =>
    web.document.querySelector('.arcane-tooltip-shared') as web.HTMLElement?;

bool _tooltipShown() {
  final web.HTMLElement? tooltip = _tooltip();
  return tooltip != null && tooltip.style.visibility == 'visible';
}

void _pointer(String type, web.Element target, {web.Element? related}) {
  target.dispatchEvent(
    web.PointerEvent(
      type,
      web.PointerEventInit(
        bubbles: true,
        pointerType: 'mouse',
        relatedTarget: related,
      ),
    ),
  );
}

Future<void> _frames() async {
  await pumpEventQueue();
  await Future<void>.delayed(const Duration(milliseconds: 60));
}

/// A titled name that the app can retitle or remove, beside a counter that
/// shows the app still renders.
class _Names extends StatefulWidget {
  const _Names();

  @override
  State<_Names> createState() => _NamesState();
}

class _NamesState extends State<_Names> {
  bool _shown = true;
  String? _title = 'Baker of the market square';
  int _renders = 0;

  @override
  Widget build(BuildContext context) {
    _renders++;
    return dom.div(id: 'list', <Widget>[
      dom.div(id: 'row', <Widget>[
        if (_shown)
          dom.span(
            key: const ValueKey<String>('name'),
            id: 'name',
            attributes: <String, String>{'title': ?_title},
            const <Widget>[Text('Baker')],
          ),
        const dom.span(
          key: ValueKey<String>('native'),
          id: 'native',
          attributes: <String, String>{
            'title': 'Kept native',
            'data-no-tooltip': '',
          },
          <Widget>[Text('Native')],
        ),
      ]),
      dom.button(
        id: 'remove',
        events: <String, EventCallback>{
          'click': (_) => setState(() => _shown = false),
        },
        const <Widget>[Text('Remove')],
      ),
      dom.button(
        id: 'retitle',
        events: <String, EventCallback>{
          'click': (_) => setState(() => _title = 'Baker, retired'),
        },
        const <Widget>[Text('Retitle')],
      ),
      dom.button(
        id: 'untitle',
        events: <String, EventCallback>{
          'click': (_) => setState(() => _title = null),
        },
        const <Widget>[Text('Untitle')],
      ),
      dom.span(id: 'renders', <Widget>[Text('$_renders')]),
    ]);
  }
}

void main() {
  testClient('a titled node keeps its parent while its tooltip shows', (
    ClientTester tester,
  ) async {
    tester.pumpComponent(const _Names());
    await pumpEventQueue();
    _bindTooltips();
    await _frames();
    final web.HTMLElement name = _element('#name');
    final web.Element row = _element('#row');
    expect(identical(name.parentElement, row), isTrue);

    _pointer('pointerover', name);
    await _frames();
    expect(identical(name.parentElement, row), isTrue);
    expect(row.children.length, 2);
    expect(_tooltipShown(), isTrue);
    expect(_tooltip()!.textContent, 'Baker of the market square');
    expect(name.getAttribute('title'), isEmpty);

    _pointer('pointerout', name, related: _element('#list'));
    await _frames();
    expect(_tooltipShown(), isFalse);
    expect(name.getAttribute('title'), 'Baker of the market square');

    // The renderer still owns the node: it can remove it and keep going.
    _pointer('pointerover', name);
    await _frames();
    _element('#remove').click();
    await _frames();
    expect(web.document.querySelector('#name'), isNull);
    expect(_element('#renders').textContent, '2');
    expect(_tooltipShown(), isFalse);
  });

  testClient('a title the renderer writes again becomes the tooltip text', (
    ClientTester tester,
  ) async {
    tester.pumpComponent(const _Names());
    await pumpEventQueue();
    _bindTooltips();
    final web.HTMLElement name = _element('#name');
    _pointer('pointerover', name);
    await _frames();
    _element('#retitle').click();
    await _frames();
    expect(_tooltip()!.textContent, 'Baker, retired');
    expect(name.getAttribute('title'), isEmpty);
    _pointer('pointerout', name, related: _element('#list'));
    await _frames();
    expect(name.getAttribute('title'), 'Baker, retired');
  });

  testClient('a title the renderer drops closes the tooltip for good', (
    ClientTester tester,
  ) async {
    tester.pumpComponent(const _Names());
    await pumpEventQueue();
    _bindTooltips();
    final web.HTMLElement name = _element('#name');
    _pointer('pointerover', name);
    await _frames();
    _element('#untitle').click();
    await _frames();
    expect(_tooltipShown(), isFalse);
    _pointer('pointerout', name, related: _element('#list'));
    await _frames();
    expect(name.hasAttribute('title'), isFalse);
  });

  testClient('data-no-tooltip keeps the browser title', (
    ClientTester tester,
  ) async {
    tester.pumpComponent(const _Names());
    await pumpEventQueue();
    _bindTooltips();
    final web.HTMLElement native = _element('#native');
    _pointer('pointerover', native);
    await _frames();
    expect(_tooltipShown(), isFalse);
    expect(native.getAttribute('title'), 'Kept native');
  });
}
