import 'package:jaspr/jaspr.dart';

import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/props/pricing_card_props.dart';
import 'package:arcane_jaspr/core/rendering/base/pricing_card_render_base.dart';

import 'package:arcane_jaspr_shadcn/src/renderers/card.dart';

/// ShadCN pricing-card renderer.
class ShadcnPricingCard extends PricingCardRenderBase {
  const ShadcnPricingCard(super.props, {super.key});

  @override
  String get cssClass => 'arcane-pricing-card';

  @override
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      shadcnCardSurfaceStyles(decoration, interactive: false);
}

/// ShadCN pricing-grid renderer.
class ShadcnPricingGrid extends PricingGridRenderBase {
  const ShadcnPricingGrid(super.props, {super.key});

  @override
  String get cssClass => 'arcane-pricing-grid';

  @override
  Component tierCard(PricingCardProps props) => ShadcnPricingCard(props);
}
