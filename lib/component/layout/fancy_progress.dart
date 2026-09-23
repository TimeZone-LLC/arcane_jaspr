import 'package:arcane_jaspr/component/layout/flow.dart';
import 'package:arcane_jaspr/component/view/progress_bar.dart';
import 'package:arcane_jaspr/flutter.dart';
import 'package:arcane_jaspr/component/typography/text.dart';
import 'package:arcane_jaspr/util/arcane.dart';

class FancyProgressBar extends StatelessWidget {
  final double value;
  final String? label;
  final bool showValue;

  const FancyProgressBar({
    required this.value,
    this.label,
    this.showValue = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    spacing: 8,
    children: <Widget>[
      if (label != null || showValue)
        Row(
          children: <Widget>[
            if (label != null) Expanded(child: Text.label(label!)),
            if (showValue) Text.label('${(value * 100).round()}%'),
          ],
        ),
      ArcaneProgressBar(value: value, showValue: false),
    ],
  );
}
