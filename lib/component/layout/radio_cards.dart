import 'package:arcane_jaspr/component/card/card.dart';
import 'package:arcane_jaspr/component/layout/carpet.dart';
import 'package:arcane_jaspr/component/layout/flow.dart';
import 'package:arcane_jaspr/flutter.dart';
import 'package:arcane_jaspr/component/typography/text.dart';
import 'package:arcane_jaspr/util/arcane.dart';
import 'package:arcane_jaspr/core/props/card_props.dart';

class RadioCards<T> extends StatelessWidget {
  final List<T> values;
  final T? value;
  final void Function(T)? onChanged;
  final String Function(T) labelBuilder;
  final String Function(T)? descriptionBuilder;

  const RadioCards({
    required this.values,
    required this.labelBuilder,
    this.value,
    this.onChanged,
    this.descriptionBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Carpet(
    children: values.map((T entry) {
      final bool selected = entry == value;
      return Card(
        variant: selected ? CardVariant.interactive : CardVariant.outlined,
        fillWidth: true,
        onTap: onChanged == null ? null : () => onChanged!(entry),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 6,
          children: <Widget>[
            Text.label(labelBuilder(entry)),
            if (descriptionBuilder != null)
              Text.bodySmall(descriptionBuilder!(entry)),
          ],
        ),
      );
    }).toList(),
  );
}
