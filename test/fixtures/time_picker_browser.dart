import 'package:arcane_jaspr/arcane_jaspr.dart' hide runApp;
import 'package:arcane_jaspr/component/input/time_picker.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:jaspr/client.dart' show runApp;
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart' show EventCallback;
import 'package:web/web.dart' as web;

void main() => runApp(const _TimeFixture());

class _TimeFixture extends StatefulWidget {
  const _TimeFixture();

  @override
  State<_TimeFixture> createState() => _TimeFixtureState();
}

class _TimeFixtureState extends State<_TimeFixture> {
  int _changes = 0;
  int _submissions = 0;
  String _lastValue = 'unchanged';

  @override
  Widget build(BuildContext context) => ArcaneApp(
    stylesheet: NeubrutalismStylesheet(
      variant: web.window.location.search.contains('neucomic')
          ? NeubrutalismVariant.neuComic
          : NeubrutalismVariant.classic,
    ),
    home: dom.form(
      styles: const dom.Styles(
        raw: <String, String>{'margin': '24px', 'width': '268px'},
      ),
      events: <String, EventCallback>{
        'submit': (event) {
          event.preventDefault();
          setState(() => _submissions++);
        },
      },
      <Widget>[
        const dom.button(id: 'before', type: dom.ButtonType.button, <Widget>[
          Text('Before'),
        ]),
        dom.div(id: 'interactive', <Widget>[
          ArcaneTimePicker(
            id: 'time',
            label: 'Start time',
            value: const TimeOfDay(hour: 23, minute: 55),
            onChanged: (TimeOfDay? value) => setState(() {
              _changes++;
              _lastValue = '$value';
            }),
          ),
        ]),
        const dom.div(id: 'disabled', <Widget>[
          ArcaneTimePicker(
            id: 'disabled-time',
            value: TimeOfDay(hour: 12, minute: 0),
            disabled: true,
          ),
        ]),
        const dom.button(id: 'after', type: dom.ButtonType.button, <Widget>[
          Text('After'),
        ]),
        dom.p(id: 'changes', <Widget>[Text('$_changes')]),
        dom.p(id: 'value', <Widget>[Text(_lastValue)]),
        dom.p(id: 'submissions', <Widget>[Text('$_submissions')]),
      ],
    ),
  );
}
