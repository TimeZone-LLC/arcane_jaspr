import 'package:arcane_jaspr_ascii/src/motion/ascii_motion_controller.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart';

/// Reveals content once on entering the viewport, with a visible server fallback.
class AsciiReveal extends StatefulComponent {
  final Component child;
  final bool animated;
  final Duration delay;
  final Duration duration;
  final String? classes;

  const AsciiReveal({
    required this.child,
    this.animated = true,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 700),
    this.classes,
    super.key,
  });

  @override
  State<AsciiReveal> createState() => _AsciiRevealState();
}

class _AsciiRevealState extends State<AsciiReveal> {
  AsciiMotionController? _motion;

  bool get _animated =>
      component.animated && component.duration > Duration.zero;

  @override
  void initState() {
    super.initState();
    context.binding.addPostFrameCallback(() {
      if (mounted) {
        _motion = AsciiMotionController(
          context,
          animated: _animated,
          reveal: true,
        );
      }
    });
  }

  @override
  void didUpdateComponent(covariant AsciiReveal oldComponent) {
    super.didUpdateComponent(oldComponent);
    _motion?.update(animated: _animated);
  }

  @override
  void dispose() {
    _motion?.dispose();
    super.dispose();
  }

  @override
  Component build(BuildContext context) => dom.div(
    <Component>[component.child],
    classes:
        'ascii-reveal${component.classes == null ? '' : ' ${component.classes}'}',
    attributes: <String, String>{
      'data-animated': '$_animated',
      ...?_motion?.attributes,
    },
    styles: dom.Styles(
      raw: <String, String>{
        '--ascii-reveal-delay':
            '${component.delay.inMilliseconds.clamp(0, 60000)}ms',
        '--ascii-reveal-duration':
            '${component.duration.inMilliseconds.clamp(1, 60000)}ms',
      },
    ),
  );
}
