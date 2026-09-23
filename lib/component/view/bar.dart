import 'package:arcane_jaspr/component/input/icon_button.dart';
import 'package:arcane_jaspr/component/layout/flow.dart';
import 'package:arcane_jaspr/component/support/icons.dart';
import 'package:arcane_jaspr/flutter.dart';
import 'package:arcane_jaspr/component/typography/text.dart';
import 'package:arcane_jaspr/util/arcane.dart';
import 'package:arcane_jaspr/core/props/bar_props.dart';

export 'package:arcane_jaspr/core/props/bar_props.dart' show BarBackButtonMode;

class Bar extends StatelessWidget {
  final List<Widget> trailing;
  final List<Widget> leading;
  final Widget? child;
  final Widget? title;
  final Widget? barHeader;
  final Widget? barFooter;
  final String? titleText;
  final String? headerText;
  final String? subtitleText;
  final Widget? header;
  final Widget? subtitle;
  final bool trailingExpanded;
  final bool centerTitle;
  final BarBackButtonMode backButton;
  final void Function()? onBack;

  const Bar({
    this.trailing = const <Widget>[],
    this.leading = const <Widget>[],
    this.child,
    this.title,
    this.barHeader,
    this.barFooter,
    this.titleText,
    this.headerText,
    this.subtitleText,
    this.header,
    this.subtitle,
    this.trailingExpanded = false,
    this.centerTitle = false,
    this.backButton = BarBackButtonMode.never,
    this.onBack,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> resolvedLeading = <Widget>[
      if (backButton != BarBackButtonMode.never && onBack != null)
        IconButton(icon: Icons.chevronLeft(), onPressed: onBack),
      ...leading,
    ];

    final Widget titleBlock =
        child ??
        Column(
          crossAxisAlignment: centerTitle
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          spacing: 4,
          children: <Widget>[
            ?header,
            if (header == null && headerText != null) Text.label(headerText!),
            ?title,
            if (title == null && titleText != null) Text.heading3(titleText!),
            ?subtitle,
            if (subtitle == null && subtitleText != null)
              Text.bodySmall(subtitleText!),
          ],
        );

    final Widget body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: <Widget>[
        ?barHeader,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ...resolvedLeading,
            if (resolvedLeading.isNotEmpty) const SizedBox(width: 8),
            Expanded(child: titleBlock),
            if (trailing.isNotEmpty) const SizedBox(width: 8),
            ...trailing,
          ],
        ),
        ?barFooter,
      ],
    );

    return body;
  }
}
