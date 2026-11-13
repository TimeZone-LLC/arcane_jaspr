import 'package:arcane_jaspr/flutter.dart';

import '../../util/style_types/arcane_style_data.dart';
import '../decoration/arcane_decoration.dart';

/// Floating content trigger mode.
enum FloatingTrigger {
  /// Show on hover (for tooltips and hovercards)
  hover,

  /// Show on click (for popovers)
  click,

  /// Manually controlled via isOpen
  manual,
}

/// Position of floating content relative to trigger.
enum FloatingPosition {
  top,
  bottom,
  left,
  right,
  topStart,
  topEnd,
  bottomStart,
  bottomEnd,
}

/// Unified floating component properties.
///
/// Combines features from Tooltip, Popover, and Hovercard into a single
/// flexible component that can render floating content in various ways.
class FloatingProps {
  final String? id;

  /// The trigger element that activates the floating content.
  final Widget trigger;

  /// The floating content to display. Use for rich content.
  final Widget? content;

  /// Simple text content (for tooltip mode). Mutually exclusive with [content].
  final String? textContent;

  /// Current open state. Null for internal state management.
  final bool? isOpen;

  /// How to trigger the floating content.
  final FloatingTrigger triggerType;

  /// Position relative to trigger.
  final FloatingPosition position;

  /// Callback when open state changes.
  final void Function(bool isOpen)? onOpenChange;

  /// Called when toggle is triggered (for click mode).
  final void Function()? onToggle;

  /// Called when mouse enters (for hover mode).
  final void Function()? onMouseEnter;

  /// Called when mouse leaves (for hover mode).
  final void Function()? onMouseLeave;
  final void Function()? onFocus;
  final void Function()? onBlur;

  /// Called when a pointer presses the trigger (for hover mode).
  final void Function()? onPress;

  /// Whether to show an arrow pointing to trigger.
  final bool showArrow;

  /// Distance from trigger in pixels.
  final int offset;

  /// Delay before showing (in milliseconds). 0 for immediate.
  final int openDelay;

  /// Delay before hiding (in milliseconds). 0 for immediate.
  final int closeDelay;

  /// Maximum width for content (especially for text tooltips).
  final double? maxWidth;

  /// Whether clicking outside should close the floating content.
  final bool closeOnOutsideClick;

  /// Whether pressing Escape should close the floating content.
  final bool closeOnEscape;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation intent + theme-specific
  /// fields honored-or-ignored per theme).
  final ArcaneDecoration? decoration;

  const FloatingProps({
    this.id,
    required this.trigger,
    this.content,
    this.textContent,
    this.isOpen,
    this.triggerType = FloatingTrigger.hover,
    this.position = FloatingPosition.top,
    this.onOpenChange,
    this.onToggle,
    this.onMouseEnter,
    this.onMouseLeave,
    this.onFocus,
    this.onBlur,
    this.onPress,
    this.showArrow = true,
    this.offset = 8,
    this.openDelay = 0,
    this.closeDelay = 0,
    this.maxWidth,
    this.closeOnOutsideClick = true,
    this.closeOnEscape = true,
    this.styles,
    this.decoration,
  });

  /// Whether this is a simple text tooltip (no component content).
  bool get isTextTooltip => textContent != null && content == null;

  FloatingProps copyWith({
    String? id,
    Widget? trigger,
    Widget? content,
    String? textContent,
    bool? isOpen,
    FloatingTrigger? triggerType,
    FloatingPosition? position,
    void Function(bool isOpen)? onOpenChange,
    void Function()? onToggle,
    void Function()? onMouseEnter,
    void Function()? onMouseLeave,
    void Function()? onFocus,
    void Function()? onBlur,
    void Function()? onPress,
    bool? showArrow,
    int? offset,
    int? openDelay,
    int? closeDelay,
    double? maxWidth,
    bool? closeOnOutsideClick,
    bool? closeOnEscape,
    ArcaneStyleData? styles,
    ArcaneDecoration? decoration,
  }) {
    return FloatingProps(
      id: id ?? this.id,
      trigger: trigger ?? this.trigger,
      content: content ?? this.content,
      textContent: textContent ?? this.textContent,
      isOpen: isOpen ?? this.isOpen,
      triggerType: triggerType ?? this.triggerType,
      position: position ?? this.position,
      onOpenChange: onOpenChange ?? this.onOpenChange,
      onToggle: onToggle ?? this.onToggle,
      onMouseEnter: onMouseEnter ?? this.onMouseEnter,
      onMouseLeave: onMouseLeave ?? this.onMouseLeave,
      onFocus: onFocus ?? this.onFocus,
      onBlur: onBlur ?? this.onBlur,
      onPress: onPress ?? this.onPress,
      showArrow: showArrow ?? this.showArrow,
      offset: offset ?? this.offset,
      openDelay: openDelay ?? this.openDelay,
      closeDelay: closeDelay ?? this.closeDelay,
      maxWidth: maxWidth ?? this.maxWidth,
      closeOnOutsideClick: closeOnOutsideClick ?? this.closeOnOutsideClick,
      closeOnEscape: closeOnEscape ?? this.closeOnEscape,
      styles: styles ?? this.styles,
      decoration: decoration ?? this.decoration,
    );
  }
}

// ============================================================================
// RENDERER CONTRACT
// ============================================================================

/// Mixin defining the renderer methods for floating components.
mixin FloatingRendererContract {
  Widget floating(FloatingProps props);
}
