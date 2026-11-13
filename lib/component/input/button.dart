import 'package:arcane_jaspr/flutter.dart';

import '../../core/decoration/arcane_decoration.dart';
import '../../core/interaction/interaction.dart';
import '../../core/theme_provider.dart';
import '../../util/style_types/arcane_style_data.dart';
import '../view/icon.dart';

export '../../core/props/button_props.dart'
    show ButtonIconPosition, ButtonVariant, ButtonSize, ButtonType;

/// A styled button component.
///
/// Can render as either a `<button>` or `<a>` element depending on whether
/// [href] is provided. Use [href] for CTA buttons that navigate to other pages.
/// [icon] is the only semantic icon slot and [iconPosition] places that one
/// icon before or after the label.
class Button extends StatelessWidget {
  final String? label;
  final ArcaneGlyph? icon;
  final ButtonIconPosition iconPosition;
  final void Function()? onPressed;
  final ArcaneInteraction? action;
  final ButtonVariant variant;
  final ButtonSize size;
  final bool disabled;
  final bool loading;
  final bool fullWidth;

  /// Cuts a label too long for the button with an ellipsis; the full label
  /// shows on hover.
  final bool truncate;
  final Map<String, String>? attributes;
  final String? id;

  /// Native `<button type>` used when this renders as a button.
  /// Ignored when [href] renders the control as an anchor.
  final ButtonType type;

  /// If provided, renders the button as an anchor tag (`<a>`) instead of `<button>`.
  /// Useful for CTA buttons that navigate to other pages.
  final String? href;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration.
  final ArcaneDecoration? decoration;

  const Button({
    this.label,
    this.icon,
    this.iconPosition = ButtonIconPosition.leading,
    this.onPressed,
    this.action,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.disabled = false,
    this.loading = false,
    this.fullWidth = false,
    this.truncate = false,
    this.attributes,
    this.id,
    this.type = ButtonType.button,
    this.href,
    this.styles,
    this.decoration,
    super.key,
  });

  const Button.primary({
    this.label,
    this.icon,
    this.iconPosition = ButtonIconPosition.leading,
    this.onPressed,
    this.action,
    this.size = ButtonSize.medium,
    this.disabled = false,
    this.loading = false,
    this.fullWidth = false,
    this.truncate = false,
    this.attributes,
    this.id,
    this.type = ButtonType.button,
    this.href,
    this.styles,
    this.decoration,
    super.key,
  }) : variant = ButtonVariant.primary;

  const Button.secondary({
    this.label,
    this.icon,
    this.iconPosition = ButtonIconPosition.leading,
    this.onPressed,
    this.action,
    this.size = ButtonSize.medium,
    this.disabled = false,
    this.loading = false,
    this.fullWidth = false,
    this.truncate = false,
    this.attributes,
    this.id,
    this.type = ButtonType.button,
    this.href,
    this.styles,
    this.decoration,
    super.key,
  }) : variant = ButtonVariant.secondary;

  const Button.outline({
    this.label,
    this.icon,
    this.iconPosition = ButtonIconPosition.leading,
    this.onPressed,
    this.action,
    this.size = ButtonSize.medium,
    this.disabled = false,
    this.loading = false,
    this.fullWidth = false,
    this.truncate = false,
    this.attributes,
    this.id,
    this.type = ButtonType.button,
    this.href,
    this.styles,
    this.decoration,
    super.key,
  }) : variant = ButtonVariant.outline;

  const Button.ghost({
    this.label,
    this.icon,
    this.iconPosition = ButtonIconPosition.leading,
    this.onPressed,
    this.action,
    this.size = ButtonSize.medium,
    this.disabled = false,
    this.loading = false,
    this.fullWidth = false,
    this.truncate = false,
    this.attributes,
    this.id,
    this.type = ButtonType.button,
    this.href,
    this.styles,
    this.decoration,
    super.key,
  }) : variant = ButtonVariant.ghost;

  const Button.destructive({
    this.label,
    this.icon,
    this.iconPosition = ButtonIconPosition.leading,
    this.onPressed,
    this.action,
    this.size = ButtonSize.medium,
    this.disabled = false,
    this.loading = false,
    this.fullWidth = false,
    this.truncate = false,
    this.attributes,
    this.id,
    this.type = ButtonType.button,
    this.href,
    this.styles,
    this.decoration,
    super.key,
  }) : variant = ButtonVariant.destructive;

  const Button.warning({
    this.label,
    this.icon,
    this.iconPosition = ButtonIconPosition.leading,
    this.onPressed,
    this.action,
    this.size = ButtonSize.medium,
    this.disabled = false,
    this.loading = false,
    this.fullWidth = false,
    this.truncate = false,
    this.attributes,
    this.id,
    this.type = ButtonType.button,
    this.href,
    this.styles,
    this.decoration,
    super.key,
  }) : variant = ButtonVariant.warning;

  const Button.success({
    this.label,
    this.icon,
    this.iconPosition = ButtonIconPosition.leading,
    this.onPressed,
    this.action,
    this.size = ButtonSize.medium,
    this.disabled = false,
    this.loading = false,
    this.fullWidth = false,
    this.truncate = false,
    this.attributes,
    this.id,
    this.type = ButtonType.button,
    this.href,
    this.styles,
    this.decoration,
    super.key,
  }) : variant = ButtonVariant.success;

  const Button.link({
    this.label,
    this.icon,
    this.iconPosition = ButtonIconPosition.leading,
    this.onPressed,
    this.action,
    this.size = ButtonSize.medium,
    this.disabled = false,
    this.loading = false,
    this.fullWidth = false,
    this.truncate = false,
    this.attributes,
    this.id,
    this.type = ButtonType.button,
    this.href,
    this.styles,
    this.decoration,
    super.key,
  }) : variant = ButtonVariant.link;

  const Button.info({
    this.label,
    this.icon,
    this.iconPosition = ButtonIconPosition.leading,
    this.onPressed,
    this.action,
    this.size = ButtonSize.medium,
    this.disabled = false,
    this.loading = false,
    this.fullWidth = false,
    this.truncate = false,
    this.attributes,
    this.id,
    this.type = ButtonType.button,
    this.href,
    this.styles,
    this.decoration,
    super.key,
  }) : variant = ButtonVariant.info;

  @override
  Widget build(BuildContext context) {
    return context.renderers.button(
      ButtonProps(
        label: label,
        icon: icon,
        iconPosition: iconPosition,
        onPressed: onPressed,
        action: action,
        variant: variant,
        size: size,
        disabled: disabled,
        loading: loading,
        fullWidth: fullWidth,
        truncate: truncate,
        id: id,
        attributes: attributes,
        href: href,
        type: type,
        styles: styles,
        decoration: decoration,
      ),
    );
  }
}
