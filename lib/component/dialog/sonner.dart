import 'package:arcane_jaspr/flutter.dart';
import '../view/icon.dart';

import 'toast.dart';

class ArcaneSonner extends StatelessWidget {
  final ToastPosition position;
  final int maxVisible;
  final double gap;
  final double offset;

  /// Distance from the top or bottom edge, to clear a bar there; null uses
  /// [offset].
  final double? edgeOffset;

  /// The toaster's z-index; null keeps the theme's.
  final int? layer;

  /// Clicks pass through toast bodies; their buttons still take them.
  final bool passThrough;

  const ArcaneSonner({
    this.position = ToastPosition.bottomRight,
    this.maxVisible = 3,
    this.gap = 12,
    this.offset = 20,
    this.edgeOffset,
    this.layer,
    this.passThrough = false,
    super.key,
  });

  static String info(
    String message, {
    String? title,
    String? description,
    int duration = 4000,
    ToastAction? action,
    ArcaneGlyph? icon,
    ToastPosition? position,
  }) {
    return toast.info(
      message,
      title: title,
      description: description,
      duration: duration,
      action: action,
      icon: icon,
      position: position,
    );
  }

  static String success(
    String message, {
    String? title,
    String? description,
    int duration = 4000,
    ToastAction? action,
    ArcaneGlyph? icon,
    ToastPosition? position,
  }) {
    return toast.success(
      message,
      title: title,
      description: description,
      duration: duration,
      action: action,
      icon: icon,
      position: position,
    );
  }

  static String warning(
    String message, {
    String? title,
    String? description,
    int duration = 5000,
    ToastAction? action,
    ArcaneGlyph? icon,
    ToastPosition? position,
  }) {
    return toast.warning(
      message,
      title: title,
      description: description,
      duration: duration,
      action: action,
      icon: icon,
      position: position,
    );
  }

  static String error(
    String message, {
    String? title,
    String? description,
    int duration = 6000,
    ToastAction? action,
    ArcaneGlyph? icon,
    ToastPosition? position,
  }) {
    return toast.error(
      message,
      title: title,
      description: description,
      duration: duration,
      action: action,
      icon: icon,
      position: position,
    );
  }

  static String loading(
    String message, {
    String? title,
    String? description,
    ToastPosition? position,
  }) {
    return toast.loading(
      message,
      title: title,
      description: description,
      position: position,
    );
  }

  static void dismiss(String id) {
    toast.dismiss(id);
  }

  static void dismissAll() {
    toast.dismissAll();
  }

  @override
  Widget build(BuildContext context) {
    return ArcaneToast.container(
      position: position,
      maxVisible: maxVisible,
      gap: gap,
      offset: offset,
      edgeOffset: edgeOffset,
      layer: layer,
      passThrough: passThrough,
    );
  }
}
