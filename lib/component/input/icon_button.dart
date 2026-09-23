import 'package:arcane_jaspr/component/input/button.dart';
import 'package:arcane_jaspr/component/view/icon.dart';
import 'package:arcane_jaspr/core/interaction/interaction.dart';
import 'package:arcane_jaspr/flutter.dart';

class IconButton extends StatelessWidget {
  final ArcaneGlyph icon;
  final void Function()? onPressed;
  final ArcaneInteraction? action;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool disabled;
  final bool loading;
  final String? href;
  final String? tooltip;
  final String? semanticLabel;

  const IconButton({
    required this.icon,
    this.onPressed,
    this.action,
    this.variant = ButtonVariant.ghost,
    this.size = ButtonSize.icon,
    this.disabled = false,
    this.loading = false,
    this.href,
    this.tooltip,
    this.semanticLabel,
    super.key,
  });

  const IconButton.primary({
    required this.icon,
    this.onPressed,
    this.action,
    this.size = ButtonSize.icon,
    this.disabled = false,
    this.loading = false,
    this.href,
    this.tooltip,
    this.semanticLabel,
    super.key,
  }) : variant = ButtonVariant.primary;

  const IconButton.secondary({
    required this.icon,
    this.onPressed,
    this.action,
    this.size = ButtonSize.icon,
    this.disabled = false,
    this.loading = false,
    this.href,
    this.tooltip,
    this.semanticLabel,
    super.key,
  }) : variant = ButtonVariant.secondary;

  const IconButton.outline({
    required this.icon,
    this.onPressed,
    this.action,
    this.size = ButtonSize.icon,
    this.disabled = false,
    this.loading = false,
    this.href,
    this.tooltip,
    this.semanticLabel,
    super.key,
  }) : variant = ButtonVariant.outline;

  const IconButton.ghost({
    required this.icon,
    this.onPressed,
    this.action,
    this.size = ButtonSize.icon,
    this.disabled = false,
    this.loading = false,
    this.href,
    this.tooltip,
    this.semanticLabel,
    super.key,
  }) : variant = ButtonVariant.ghost;

  const IconButton.destructive({
    required this.icon,
    this.onPressed,
    this.action,
    this.size = ButtonSize.icon,
    this.disabled = false,
    this.loading = false,
    this.href,
    this.tooltip,
    this.semanticLabel,
    super.key,
  }) : variant = ButtonVariant.destructive;

  @override
  Widget build(BuildContext context) => Button(
    onPressed: onPressed,
    action: action,
    variant: variant,
    size: size,
    disabled: disabled,
    loading: loading,
    href: href,
    icon: icon,
    attributes: <String, String>{
      'title': ?tooltip,
      if (semanticLabel ?? tooltip case final String label) 'aria-label': label,
    },
  );
}
