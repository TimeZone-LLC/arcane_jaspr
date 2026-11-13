import 'package:arcane_jaspr/flutter.dart';

import '../../util/style_types/arcane_style_data.dart';
import '../decoration/arcane_decoration.dart';

/// Dialog component properties.
class DialogProps {
  final String? id;
  final bool isOpen;
  final String? title;
  final List<Widget> content;
  final List<Widget>? actions;
  final bool showCloseButton;
  final void Function()? onClose;
  final double maxWidth;
  final bool barrierDismissible;
  final bool escapeCloses;
  final bool focusTrap;
  final bool restoreFocus;

  /// A question that needs an answer (a confirmation): `role="alertdialog"`.
  final bool alert;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation intent + theme-specific
  /// fields honored-or-ignored per theme).
  final ArcaneDecoration? decoration;

  const DialogProps({
    this.id,
    this.isOpen = false,
    this.title,
    required this.content,
    this.actions,
    this.showCloseButton = true,
    this.onClose,
    this.maxWidth = 500,
    this.barrierDismissible = true,
    this.escapeCloses = true,
    this.focusTrap = true,
    this.restoreFocus = true,
    this.alert = false,
    this.styles,
    this.decoration,
  });

  DialogProps copyWith({
    String? id,
    bool? isOpen,
    String? title,
    List<Widget>? content,
    List<Widget>? actions,
    bool? showCloseButton,
    void Function()? onClose,
    double? maxWidth,
    bool? barrierDismissible,
    bool? escapeCloses,
    bool? focusTrap,
    bool? restoreFocus,
    bool? alert,
    ArcaneStyleData? styles,
    ArcaneDecoration? decoration,
  }) {
    return DialogProps(
      id: id ?? this.id,
      isOpen: isOpen ?? this.isOpen,
      title: title ?? this.title,
      content: content ?? this.content,
      actions: actions ?? this.actions,
      showCloseButton: showCloseButton ?? this.showCloseButton,
      onClose: onClose ?? this.onClose,
      maxWidth: maxWidth ?? this.maxWidth,
      barrierDismissible: barrierDismissible ?? this.barrierDismissible,
      escapeCloses: escapeCloses ?? this.escapeCloses,
      focusTrap: focusTrap ?? this.focusTrap,
      restoreFocus: restoreFocus ?? this.restoreFocus,
      alert: alert ?? this.alert,
      styles: styles ?? this.styles,
      decoration: decoration ?? this.decoration,
    );
  }
}

enum SheetPosition { left, right, top, bottom }

enum SheetSizeVariant { auto, sm, md, lg, xl, full }

/// Sheet/drawer component properties.
class SheetProps {
  final String? id;
  final bool isOpen;
  final Widget child;
  final SheetPosition position;
  final SheetSizeVariant size;
  final void Function()? onClose;
  final bool showCloseButton;
  final String? title;
  final String? description;
  final Widget? header;
  final Widget? footer;
  final bool showBackdrop;
  final bool closeOnBackdropClick;
  final bool showDragHandle;
  final String? maxWidth;
  final bool escapeCloses;
  final bool focusTrap;
  final bool restoreFocus;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation intent + theme-specific
  /// fields honored-or-ignored per theme).
  final ArcaneDecoration? decoration;

  const SheetProps({
    this.id,
    required this.isOpen,
    required this.child,
    this.position = SheetPosition.right,
    this.size = SheetSizeVariant.auto,
    this.onClose,
    this.showCloseButton = true,
    this.title,
    this.description,
    this.header,
    this.footer,
    this.showBackdrop = true,
    this.closeOnBackdropClick = true,
    this.showDragHandle = true,
    this.maxWidth,
    this.escapeCloses = true,
    this.focusTrap = true,
    this.restoreFocus = true,
    this.styles,
    this.decoration,
  });

  SheetProps copyWith({
    String? id,
    bool? isOpen,
    Widget? child,
    SheetPosition? position,
    SheetSizeVariant? size,
    void Function()? onClose,
    bool? showCloseButton,
    String? title,
    String? description,
    Widget? header,
    Widget? footer,
    bool? showBackdrop,
    bool? closeOnBackdropClick,
    bool? showDragHandle,
    String? maxWidth,
    bool? escapeCloses,
    bool? focusTrap,
    bool? restoreFocus,
    ArcaneStyleData? styles,
    ArcaneDecoration? decoration,
  }) {
    return SheetProps(
      id: id ?? this.id,
      isOpen: isOpen ?? this.isOpen,
      child: child ?? this.child,
      position: position ?? this.position,
      size: size ?? this.size,
      onClose: onClose ?? this.onClose,
      showCloseButton: showCloseButton ?? this.showCloseButton,
      title: title ?? this.title,
      description: description ?? this.description,
      header: header ?? this.header,
      footer: footer ?? this.footer,
      showBackdrop: showBackdrop ?? this.showBackdrop,
      closeOnBackdropClick: closeOnBackdropClick ?? this.closeOnBackdropClick,
      showDragHandle: showDragHandle ?? this.showDragHandle,
      maxWidth: maxWidth ?? this.maxWidth,
      escapeCloses: escapeCloses ?? this.escapeCloses,
      focusTrap: focusTrap ?? this.focusTrap,
      restoreFocus: restoreFocus ?? this.restoreFocus,
      styles: styles ?? this.styles,
      decoration: decoration ?? this.decoration,
    );
  }
}

// ============================================================================
// RENDERER CONTRACT
// ============================================================================

/// Mixin defining the renderer methods for dialog components.
mixin DialogRendererContract {
  Widget dialog(DialogProps props);
  Widget sheet(SheetProps props);
}
