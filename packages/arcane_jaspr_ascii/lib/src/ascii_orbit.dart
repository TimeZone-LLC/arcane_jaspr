import 'package:arcane_jaspr_ascii/src/motion/ascii_motion_controller.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart';

/// Slow orbital tracks with upright, semantic content. Hover or focus pauses motion.
class AsciiOrbit extends StatefulComponent {
  final List<Component> children;
  final bool animated;
  final Duration duration;
  final String? classes;

  const AsciiOrbit({
    this.children = const <Component>[],
    this.animated = true,
    this.duration = const Duration(seconds: 120),
    this.classes,
    super.key,
  });

  @override
  State<AsciiOrbit> createState() => _AsciiOrbitState();
}

class _AsciiOrbitState extends State<AsciiOrbit> {
  AsciiMotionController? _motion;

  bool get _animated =>
      component.animated && component.duration > Duration.zero;

  @override
  void initState() {
    super.initState();
    context.binding.addPostFrameCallback(() {
      if (mounted) {
        _motion = AsciiMotionController(context, animated: _animated);
      }
    });
  }

  @override
  void didUpdateComponent(covariant AsciiOrbit oldComponent) {
    super.didUpdateComponent(oldComponent);
    _motion?.update(animated: _animated);
  }

  @override
  void dispose() {
    _motion?.dispose();
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    final bool decorative = component.children.isEmpty;
    final int count = decorative ? 4 : component.children.length;
    return dom.div(
      <Component>[
        const dom.div(
          <Component>[
            dom.div(<Component>[], classes: 'ascii-orbit-ring'),
            dom.div(<Component>[], classes: 'ascii-orbit-ring'),
            dom.div(<Component>[], classes: 'ascii-orbit-ring'),
            dom.span(<Component>[
              Component.text('+'),
            ], classes: 'ascii-orbit-origin'),
          ],
          classes: 'ascii-orbit-guides',
          attributes: <String, String>{'aria-hidden': 'true'},
        ),
        for (int index = 0; index < count; index++)
          dom.div(
            <Component>[
              dom.div(<Component>[
                dom.div(<Component>[
                  if (decorative)
                    const dom.span(<Component>[
                      Component.text('+'),
                    ], classes: 'ascii-orbit-mark')
                  else
                    component.children[index],
                ], classes: 'ascii-orbit-counterturn'),
              ], classes: 'ascii-orbit-point'),
            ],
            classes: 'ascii-orbit-track',
            attributes: decorative
                ? const <String, String>{'aria-hidden': 'true'}
                : null,
            styles: dom.Styles(
              raw: <String, String>{
                '--ascii-orbit-inset': '${18 + (index % 3) * 11}%',
                '--ascii-orbit-phase':
                    '${(index * 360 / count + 35).toStringAsFixed(2)}deg',
                '--ascii-orbit-counterphase':
                    '${(-index * 360 / count - 35).toStringAsFixed(2)}deg',
                '--ascii-orbit-duration':
                    '${(component.duration.inMilliseconds.clamp(1, 86400000) * (1 + index % 3 * 0.2)).toStringAsFixed(0)}ms',
              },
            ),
          ),
      ],
      classes:
          'ascii-orbit${component.classes == null ? '' : ' ${component.classes}'}',
      attributes: <String, String>{
        'data-animated': '$_animated',
        ...?_motion?.attributes,
      },
    );
  }
}
