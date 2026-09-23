import 'package:arcane_jaspr/core/props/skeleton_props.dart';
import 'package:arcane_jaspr/core/rendering/base/skeleton_render_base.dart';

/// ShadCN Skeleton renderer.
///
/// Reference: https://ui.shadcn.com/docs/components/skeleton
class ShadcnSkeleton extends SkeletonRenderBase {
  const ShadcnSkeleton(super.props, {super.key});

  @override
  String get cssClass => 'arcane-skeleton';

  @override
  (String, String, String?, String?) defaultGeometry(SkeletonShape shape) =>
      switch (shape) {
        SkeletonShape.circle => ('2.5rem', '2.5rem', null, '50%'),
        SkeletonShape.text => ('100%', '1rem', null, 'var(--radius-sm)'),
        SkeletonShape.rectangle => (
          '100%',
          '1.25rem',
          null,
          'var(--radius-sm)',
        ),
      };

  // ShadCN Skeleton: bg-accent animate-pulse rounded-md, on the base
  // stylesheet's `arcane-pulse` opacity keyframes.
  @override
  Map<String, String> surfaceStyles(SkeletonProps props) => <String, String>{
    'background-color': 'var(--accent)',
    if (props.animate)
      'animation': 'arcane-pulse 2s cubic-bezier(0.4, 0, 0.6, 1) infinite',
  };
}
