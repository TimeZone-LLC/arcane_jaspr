import 'dart:async';

import 'package:arcane_jaspr/flutter.dart';

import '../../core/decoration/arcane_decoration.dart';
import '../../core/theme_provider.dart';
import '../../util/style_types/arcane_style_data.dart';
import '../view/icon.dart';
import 'toast_manager.dart';

export '../../core/props/toast_props.dart'
    show ToastVariant, ToastPosition, ToastAction;
export 'toast_manager.dart';

/// Toast notification component with auto-dismiss and global API support.
class ArcaneToast extends StatefulWidget {
  final String message;
  final String? title;
  final String? description;
  final ToastVariant variant;
  final ToastPosition position;
  final int duration;
  final bool dismissible;
  final ToastAction? action;
  final ArcaneGlyph? icon;
  final void Function()? onClose;
  final String? id;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation + theme-specific fields).
  final ArcaneDecoration? decoration;

  const ArcaneToast({
    required this.message,
    this.title,
    this.description,
    this.variant = ToastVariant.info,
    this.position = ToastPosition.bottomRight,
    this.duration = 4000,
    this.dismissible = true,
    this.action,
    this.icon,
    this.onClose,
    this.id,
    this.styles,
    this.decoration,
    super.key,
  });

  static Widget container({
    ToastPosition position = ToastPosition.bottomRight,
    int maxVisible = 3,
    double gap = 12,
    double offset = 20,
    Key? key,
  }) {
    return _ToastContainer(
      position: position,
      maxVisible: maxVisible,
      gap: gap,
      offset: offset,
      key: key,
    );
  }

  @override
  State<ArcaneToast> createState() => _ArcaneToastState();
}

class _ArcaneToastState extends State<ArcaneToast> {
  bool _isExiting = false;
  bool _isHovered = false;
  Timer? _dismissTimer;
  Timer? _exitTimer;

  @override
  void initState() {
    super.initState();
    _scheduleDismissTimer();
  }

  @override
  void dispose() {
    _cancelTimers();
    super.dispose();
  }

  void _cancelTimers() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _exitTimer?.cancel();
    _exitTimer = null;
  }

  void _scheduleDismissTimer() {
    _dismissTimer?.cancel();
    if (widget.duration > 0 && !_isHovered) {
      _dismissTimer = Timer(Duration(milliseconds: widget.duration), () {
        if (mounted && !_isHovered) {
          _startExitAnimation();
        }
      });
    }
  }

  void _startExitAnimation() {
    if (_isExiting) return;
    setState(() => _isExiting = true);

    _exitTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) {
        widget.onClose?.call();
      }
    });
  }

  void _onMouseEnter() {
    setState(() => _isHovered = true);
    _dismissTimer?.cancel();
    _dismissTimer = null;
  }

  void _onMouseLeave() {
    setState(() => _isHovered = false);
    _scheduleDismissTimer();
  }

  void _onDismissClick() {
    _startExitAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return context.renderers.toast(
      ToastProps(
        message: widget.message,
        title: widget.title,
        description: widget.description,
        variant: widget.variant,
        position: widget.position,
        duration: widget.duration,
        dismissible: widget.dismissible,
        action: widget.action,
        icon: widget.icon,
        id: widget.id,
        isExiting: _isExiting,
        isHovered: _isHovered,
        onMouseEnter: _onMouseEnter,
        onMouseLeave: _onMouseLeave,
        onDismiss: _onDismissClick,
        styles: widget.styles,
        decoration: widget.decoration,
      ),
    );
  }
}

/// Toast container component that renders all active toasts.
class _ToastContainer extends StatefulWidget {
  final ToastPosition position;
  final int maxVisible;
  final double gap;
  final double offset;

  const _ToastContainer({
    this.position = ToastPosition.bottomRight,
    this.maxVisible = 3,
    this.gap = 12,
    this.offset = 20,
    super.key,
  });

  @override
  State<_ToastContainer> createState() => _ToastContainerState();
}

class _ToastContainerState extends State<_ToastContainer> {
  @override
  void initState() {
    super.initState();
    ToastManager.instance.setDefaultPosition(widget.position);
    ToastManager.instance.addListener(_onToastsChanged);
  }

  @override
  void dispose() {
    ToastManager.instance.removeListener(_onToastsChanged);
    super.dispose();
  }

  void _onToastsChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final toasts = ToastManager.instance.toasts.take(widget.maxVisible);

    final toastPropsList = toasts
        .map(
          (data) => ToastProps(
            message: data.message,
            title: data.title,
            description: data.description,
            variant: data.variant,
            position: data.position,
            duration: data.duration,
            dismissible: data.dismissible,
            action: data.action,
            icon: data.icon,
            id: data.id,
            onDismiss: () => ToastManager.instance.dismiss(data.id),
          ),
        )
        .toList();

    return context.renderers.toastContainer(
      ToastContainerProps(
        position: widget.position,
        maxVisible: widget.maxVisible,
        gap: widget.gap,
        offset: widget.offset,
        toasts: toastPropsList,
      ),
    );
  }
}

typedef AToast = ArcaneToast;
