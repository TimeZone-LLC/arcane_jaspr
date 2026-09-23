import 'package:arcane_jaspr/component/layout/flow.dart';
import 'package:arcane_jaspr/component/view/item.dart';
import 'package:arcane_jaspr/flutter.dart';
import 'package:arcane_jaspr/component/typography/text.dart';
import 'package:arcane_jaspr/util/arcane.dart';

class Logo extends StatelessWidget {
  /// Brand artwork may be a composed logo, wordmark, or image rather than one
  /// semantic UI glyph. This is intentionally the only public `Widget` icon
  /// slot in the curated component surface.
  final Widget? icon;
  final String title;
  final String? subtitle;
  final String? href;

  const Logo({
    required this.title,
    this.icon,
    this.subtitle,
    this.href,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 12,
      children: <Widget>[
        ?icon,
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 2,
          children: <Widget>[
            Text.label(title),
            if (subtitle != null) Text.bodySmall(subtitle!),
          ],
        ),
      ],
    );

    if (href == null) {
      return content;
    }

    return ArcaneItem(href: href, child: content);
  }
}
