import 'package:arcane_jaspr/flutter.dart';
import '../../component/view/icon.dart';

import '../../util/style_types/arcane_style_data.dart';
import '../decoration/arcane_decoration.dart';

enum ToastVariant { info, success, warning, error, loading }

enum ToastPosition {
  topLeft,
  topCenter,
  topRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

/// Toast action button data.
class ToastAction {
  final String label;
  final void Function() onPressed;
  final bool destructive;

  const ToastAction({
    required this.label,
    required this.onPressed,
    this.destructive = false,
  });
}

/// Toast component properties.
class ToastProps {
  final String message;
  final String? title;
  final String? description;
  final ToastVariant variant;
  final ToastPosition position;
  final int duration;
  final bool dismissible;
  final ToastAction? action;
  final ArcaneGlyph? icon;
  final String? id;
  final bool isExiting;
  final bool isHovered;
  final void Function()? onMouseEnter;
  final void Function()? onMouseLeave;
  final void Function()? onDismiss;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation + theme-specific fields).
  final ArcaneDecoration? decoration;

  const ToastProps({
    required this.message,
    this.title,
    this.description,
    this.variant = ToastVariant.info,
    this.position = ToastPosition.bottomRight,
    this.duration = 4000,
    this.dismissible = true,
    this.action,
    this.icon,
    this.id,
    this.isExiting = false,
    this.isHovered = false,
    this.onMouseEnter,
    this.onMouseLeave,
    this.onDismiss,
    this.styles,
    this.decoration,
    this.passThrough = false,
  });

  /// Clicks pass through the toast's body; its buttons still take them.
  final bool passThrough;

  ToastProps copyWith({
    String? message,
    String? title,
    String? description,
    ToastVariant? variant,
    ToastPosition? position,
    int? duration,
    bool? dismissible,
    ToastAction? action,
    ArcaneGlyph? icon,
    String? id,
    bool? isExiting,
    bool? isHovered,
    void Function()? onMouseEnter,
    void Function()? onMouseLeave,
    void Function()? onDismiss,
    ArcaneStyleData? styles,
    ArcaneDecoration? decoration,
  }) {
    return ToastProps(
      message: message ?? this.message,
      title: title ?? this.title,
      description: description ?? this.description,
      variant: variant ?? this.variant,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      dismissible: dismissible ?? this.dismissible,
      action: action ?? this.action,
      icon: icon ?? this.icon,
      id: id ?? this.id,
      isExiting: isExiting ?? this.isExiting,
      isHovered: isHovered ?? this.isHovered,
      onMouseEnter: onMouseEnter ?? this.onMouseEnter,
      onMouseLeave: onMouseLeave ?? this.onMouseLeave,
      onDismiss: onDismiss ?? this.onDismiss,
      styles: styles ?? this.styles,
      decoration: decoration ?? this.decoration,
    );
  }
}

/// Toast container component properties.
class ToastContainerProps {
  final ToastPosition position;
  final int maxVisible;
  final double gap;
  final double offset;

  /// Distance from the top or bottom edge; null uses [offset].
  final double? edgeOffset;
  final List<ToastProps> toasts;

  /// The toaster's z-index; null keeps the theme's (shadcn: above sheets).
  final int? layer;

  /// Clicks pass through toast bodies; their buttons still take them.
  final bool passThrough;

  const ToastContainerProps({
    this.position = ToastPosition.bottomRight,
    this.maxVisible = 3,
    this.gap = 12,
    this.offset = 20,
    this.edgeOffset,
    this.toasts = const [],
    this.layer,
    this.passThrough = false,
  });

  /// The top or bottom distance in px.
  double get edge => edgeOffset ?? offset;
}

// ============================================================================
// RENDERER CONTRACT
// ============================================================================

/// Mixin defining the renderer methods for toast components.
mixin ToastRendererContract {
  Widget toast(ToastProps props);
  Widget toastContainer(ToastContainerProps props);
}
