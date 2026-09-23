import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/rendering/base/testimonial_card_render_base.dart';

import 'package:arcane_jaspr_shadcn/src/renderers/card.dart';

/// ShadCN testimonial-card renderer.
class ShadcnTestimonialCard extends TestimonialCardRenderBase {
  const ShadcnTestimonialCard(super.props, {super.key});

  @override
  String get cssClass => 'arcane-testimonial-card';

  @override
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      shadcnCardSurfaceStyles(decoration, interactive: false);
}

/// ShadCN simple rating-stars renderer.
class ShadcnRatingStarsSimple extends RatingStarsSimpleRenderBase {
  const ShadcnRatingStarsSimple(super.props, {super.key});

  @override
  String get cssClass => 'arcane-rating-stars';
}
