import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/rendering/base/feature_card_render_base.dart';

import 'package:arcane_jaspr_shadcn/src/renderers/card.dart';

/// ShadCN feature-card renderer.
class ShadcnFeatureCard extends FeatureCardRenderBase {
  const ShadcnFeatureCard(super.props, {super.key});

  @override
  String get cssClass => 'arcane-feature-card';

  @override
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      shadcnCardSurfaceStyles(
        decoration,
        interactive: props.href != null || props.onTap != null,
      );
}

/// ShadCN icon-card renderer.
class ShadcnIconCard extends IconCardRenderBase {
  const ShadcnIconCard(super.props, {super.key});

  @override
  String get cssClass => 'arcane-icon-card';
}
