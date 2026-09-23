import 'package:arcane_jaspr/component/input/button.dart';
import 'package:arcane_jaspr/component/layout/flow.dart';
import 'package:arcane_jaspr/component/support/icons.dart';
import 'package:arcane_jaspr/flutter.dart';
import 'package:arcane_jaspr/component/typography/text.dart';
import 'package:arcane_jaspr/util/arcane.dart';

class CenterBody extends StatelessWidget {
  final ArcaneGlyph? icon;
  final IconData? iconData;
  final String? message;
  final String? actionText;
  final void Function()? onActionPressed;
  final Widget? child;

  const CenterBody({
    this.icon,
    this.iconData,
    this.message,
    this.actionText,
    this.onActionPressed,
    this.child,
    super.key,
  }) : assert(
         icon != null || iconData != null || message != null || child != null,
       );

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 16,
      children: <Widget>[
        ?icon,
        if (icon == null && iconData != null)
          Icon(iconData!, size: IconSize.xl2),
        if (message != null)
          Text.bodyLarge(message!, textAlign: TextAlign.center),
        ?child,
        if (actionText != null)
          Button.secondary(onPressed: onActionPressed, label: actionText!),
      ],
    ),
  );
}
