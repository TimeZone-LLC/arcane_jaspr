import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/rendering/base/cta_card_render_base.dart';

import 'package:arcane_jaspr_shadcn/src/renderers/card.dart';

/// ShadCN CTA-card renderer.
class ShadcnCtaCard extends CtaCardRenderBase {
  const ShadcnCtaCard(super.props, {super.key});

  @override
  String get cssClass => 'arcane-cta-card';

  @override
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      shadcnCardSurfaceStyles(decoration, interactive: false);
}
