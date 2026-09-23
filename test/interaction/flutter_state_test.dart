import 'package:arcane_jaspr/flutter.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr_test/jaspr_test.dart';

class _Host extends StatefulWidget {
  final Widget child;
  final ValueChanged<_HostState> onCreate;

  const _Host({required this.child, required this.onCreate});

  @override
  State<_Host> createState() {
    final _HostState state = _HostState();
    onCreate(state);
    return state;
  }
}

class _HostState extends State<_Host> {
  late Widget child;

  @override
  void initState() {
    super.initState();
    child = widget.child;
  }

  void replace(Widget replacement) => setState(() => child = replacement);

  @override
  Widget build(BuildContext context) => child;
}

class _Counter extends StatefulWidget {
  final int initialValue;
  final List<String> events;
  final ValueChanged<_CounterState> onCreate;

  const _Counter({
    required this.initialValue,
    required this.events,
    required this.onCreate,
    super.key,
  });

  @override
  State<_Counter> createState() {
    final _CounterState state = _CounterState();
    onCreate(state);
    return state;
  }
}

class _CounterState extends State<_Counter> {
  late int value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
    widget.events.add('init:$value:$mounted');
  }

  @override
  void didUpdateWidget(covariant _Counter oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.events.add(
      'update:${oldWidget.initialValue}:${widget.initialValue}',
    );
    if (oldWidget.initialValue != widget.initialValue) {
      value = widget.initialValue;
    }
  }

  void increment() => setState(() => value += 1);

  @override
  Widget build(BuildContext context) {
    widget.events.add('build:$value');
    return dom.span(<Widget>[Widget.text('$value')]);
  }

  @override
  void dispose() {
    widget.events.add('dispose');
    super.dispose();
  }
}

void main() {
  testComponents('Flutter state lifecycle retains state and updates widget', (
    ComponentTester tester,
  ) async {
    final List<String> events = <String>[];
    final List<_CounterState> states = <_CounterState>[];
    final _Counter initial = _Counter(
      key: const ValueKey<String>('counter'),
      initialValue: 2,
      events: events,
      onCreate: states.add,
    );

    late _HostState host;
    tester.pumpComponent(
      _Host(child: initial, onCreate: (_HostState state) => host = state),
    );
    await tester.pump();
    expect(states, hasLength(1));
    final _CounterState state = states.single;
    expect(state.widget, same(initial));
    expect(events, <String>['init:2:true', 'build:2']);

    state.increment();
    await tester.pump();
    expect(find.text('3'), findsOneComponent);
    expect(events.last, 'build:3');

    final _Counter replacement = _Counter(
      key: const ValueKey<String>('counter'),
      initialValue: 7,
      events: events,
      onCreate: states.add,
    );
    host.replace(replacement);
    await tester.pump();
    expect(states, hasLength(1));
    expect(state.widget, same(replacement));
    expect(events.sublist(events.length - 2), <String>[
      'update:2:7',
      'build:7',
    ]);
    expect(find.text('7'), findsOneComponent);

    host.replace(const dom.span(<Widget>[]));
    await tester.pump();
    expect(events.last, 'dispose');
    expect(state.mounted, isFalse);
  });

  testComponents('changing a key replaces Flutter state', (
    ComponentTester tester,
  ) async {
    final List<String> events = <String>[];
    final List<_CounterState> states = <_CounterState>[];
    late _HostState host;
    tester.pumpComponent(
      _Host(
        child: const dom.span(<Widget>[]),
        onCreate: (_HostState state) => host = state,
      ),
    );
    for (final int key in <int>[1, 2]) {
      host.replace(
        _Counter(
          key: ValueKey<int>(key),
          initialValue: key,
          events: events,
          onCreate: states.add,
        ),
      );
      await tester.pump();
    }

    expect(states, hasLength(2));
    expect(states.first.mounted, isFalse);
    expect(states.last.mounted, isTrue);
    expect(
      events.where((String event) => event.startsWith('update:')),
      isEmpty,
    );
    expect(find.text('2'), findsOneComponent);
  });
}
