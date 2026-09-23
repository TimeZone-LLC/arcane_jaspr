import 'package:arcane_jaspr/component/layout/flow.dart';
import 'package:arcane_jaspr/flutter.dart';
import 'package:arcane_jaspr/component/typography/text.dart';
import 'package:arcane_jaspr/util/arcane.dart';

class FormHeader extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final String? titleText;
  final String? subtitleText;
  final Widget? trailing;

  const FormHeader({
    this.title,
    this.subtitle,
    this.titleText,
    this.subtitleText,
    this.trailing,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 6,
          children: <Widget>[
            title ??
                (titleText != null
                    ? Text.sectionTitle(titleText!)
                    : const SizedBox.shrink()),
            subtitle ??
                (subtitleText != null
                    ? Text.body(subtitleText!)
                    : const SizedBox.shrink()),
          ],
        ),
      ),
      ?trailing,
    ],
  );
}
