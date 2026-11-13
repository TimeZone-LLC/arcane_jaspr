import 'package:arcane_jaspr/flutter.dart';

import '../../util/style_types/arcane_style_data.dart';
import '../../component/view/icon.dart';
import '../decoration/arcane_decoration.dart';
import '../interaction/interaction.dart';

enum ButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
  destructive,
  link,
  success,
  warning,
  info,
}

/// Button size enum with icon variants.
/// Supports both abbreviated (sm/md/lg) and spelled-out (small/medium/large) styles.
enum ButtonSize {
  sm,
  md,
  lg,
  iconSm,
  iconMd,
  iconLg;

  static const ButtonSize small = sm;
  static const ButtonSize medium = md;
  static const ButtonSize large = lg;
  static const ButtonSize icon = iconMd;
  static const ButtonSize iconSmall = iconSm;
  static const ButtonSize iconMedium = iconMd;
  static const ButtonSize iconLarge = iconLg;
}

enum ButtonType {
  button('button'),
  submit('submit'),
  reset('reset');

  final String value;

  const ButtonType(this.value);
}

/// Placement for a button's single semantic icon.
enum ButtonIconPosition { leading, trailing }

/// Canonical button properties with one optional semantic icon slot.
class ButtonProps {
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
  final String? id;
  final Map<String, String>? attributes;
  final String? href;
  final ButtonType type;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation intent + theme-specific
  /// fields honored-or-ignored per theme).
  final ArcaneDecoration? decoration;

  const ButtonProps({
    this.label,
    this.icon,
    this.iconPosition = ButtonIconPosition.leading,
    this.onPressed,
    this.action,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.md,
    this.disabled = false,
    this.loading = false,
    this.fullWidth = false,
    this.truncate = false,
    this.id,
    this.attributes,
    this.href,
    this.type = ButtonType.button,
    this.styles,
    this.decoration,
  });

  ButtonProps copyWith({
    String? label,
    ArcaneGlyph? icon,
    ButtonIconPosition? iconPosition,
    void Function()? onPressed,
    ArcaneInteraction? action,
    ButtonVariant? variant,
    ButtonSize? size,
    bool? disabled,
    bool? loading,
    bool? fullWidth,
    bool? truncate,
    String? id,
    Map<String, String>? attributes,
    String? href,
    ButtonType? type,
    ArcaneStyleData? styles,
    ArcaneDecoration? decoration,
  }) {
    return ButtonProps(
      label: label ?? this.label,
      icon: icon ?? this.icon,
      iconPosition: iconPosition ?? this.iconPosition,
      onPressed: onPressed ?? this.onPressed,
      action: action ?? this.action,
      variant: variant ?? this.variant,
      size: size ?? this.size,
      disabled: disabled ?? this.disabled,
      loading: loading ?? this.loading,
      fullWidth: fullWidth ?? this.fullWidth,
      truncate: truncate ?? this.truncate,
      id: id ?? this.id,
      attributes: attributes ?? this.attributes,
      href: href ?? this.href,
      type: type ?? this.type,
      styles: styles ?? this.styles,
      decoration: decoration ?? this.decoration,
    );
  }
}

// ============================================================================
// RENDERER CONTRACT
// ============================================================================

/// Mixin defining the renderer method for button components.
mixin ButtonRendererContract {
  /// Render a button component.
  Widget button(ButtonProps props);
}
