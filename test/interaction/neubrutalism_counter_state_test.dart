import 'package:arcane_jaspr/core/props/slot_counter_props.dart';
import 'package:arcane_jaspr_neubrutalism/src/renderers/slot_counter.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  testComponents('server rendering does not start counter timers', (
    ComponentTester tester,
  ) async {
    final List<int> values = <int>[];
    tester.pumpComponent(
      NeubrutalismSlotCounter(
        SlotCounterProps(
          minValue: 7,
          maxValue: 7,
          basePauseSeconds: 0,
          randomPauseSeconds: 0,
          spinDurationMs: 20,
          spinIntervalMs: 5,
          onValueChange: values.add,
        ),
      ),
    );
    await tester.pump();
    await Future<void>.delayed(const Duration(milliseconds: 80));
    expect(values, isEmpty);
    expect(find.text('7'), findsOneComponent);
  });

  testComponents('fixed counter follows parent value changes', (
    ComponentTester tester,
  ) async {
    int value = 12;
    late StateSetter update;
    tester.pumpComponent(
      StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          update = setState;
          return NeubrutalismSlotCounter(
            SlotCounterProps(fixedValue: value, minDigits: 3),
          );
        },
      ),
    );
    await tester.pump();
    expect(find.text('012'), findsOneComponent);
    update(() => value = 38);
    await tester.pump();
    expect(find.text('038'), findsOneComponent);
    expect(find.text('012'), findsNothing);
    update(() => value = 0);
    await tester.pump();
    expect(find.text('000'), findsOneComponent);
  });
}
