import 'package:arcane_jaspr/component/card/card.dart';
import 'package:arcane_jaspr/component/layout/flow.dart';
import 'package:arcane_jaspr/component/view/separator.dart';
import 'package:arcane_jaspr/flutter.dart';
import 'package:arcane_jaspr/component/typography/text.dart';
import 'package:arcane_jaspr/util/arcane.dart';

class Section extends StatelessWidget {
  final Widget? title;
  final Widget? subtitle;
  final String? titleText;
  final String? subtitleText;
  final Widget? trailing;
  final List<Widget> children;
  final bool card;
  final bool showDivider;
  final double gap;

  const Section({
    this.title,
    this.subtitle,
    this.titleText,
    this.subtitleText,
    this.trailing,
    this.children = const <Widget>[],
    this.card = false,
    this.showDivider = false,
    this.gap = 16,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Widget header = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: <Widget>[
              ?title,
              if (title == null && titleText != null) Text.heading2(titleText!),
              ?subtitle,
              if (subtitle == null && subtitleText != null)
                Text.body(subtitleText!),
            ],
          ),
        ),
        ?trailing,
      ],
    );

    final List<Widget> content = <Widget>[
      if (title != null ||
          titleText != null ||
          subtitle != null ||
          subtitleText != null ||
          trailing != null)
        header,
      if ((title != null ||
              titleText != null ||
              subtitle != null ||
              subtitleText != null ||
              trailing != null) &&
          showDivider &&
          children.isNotEmpty)
        const ArcaneSeparator.subtle(),
      ...children,
    ];

    final Widget body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: gap,
      children: content,
    );

    if (card) {
      return Card.outlined(fillWidth: true, child: body);
    }

    return body;
  }
}
