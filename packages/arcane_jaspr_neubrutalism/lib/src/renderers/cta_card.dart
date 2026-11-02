import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/rendering/base/cta_card_render_base.dart';

import 'package:arcane_jaspr_neubrutalism/src/renderers/decoration_styles.dart';

/// Neubrutalism CTA-card renderer.
class NeubrutalismCtaCard extends CtaCardRenderBase {
  const NeubrutalismCtaCard(super.props, {super.key});

  @override
  String get cssClass => 'neubrutalism-cta-card';

  @override
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      neubrutalismDecorationStyles(decoration);
}
