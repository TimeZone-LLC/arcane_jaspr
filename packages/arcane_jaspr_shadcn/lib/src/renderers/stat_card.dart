import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/rendering/base/stat_card_render_base.dart';

import 'package:arcane_jaspr_shadcn/src/renderers/card.dart';

/// ShadCN stat-card renderer.
class ShadcnStatCard extends StatCardRenderBase {
  const ShadcnStatCard(super.props, {super.key});

  @override
  String get cssClass => 'arcane-stat-card';

  @override
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      shadcnCardSurfaceStyles(decoration, interactive: false);
}

/// ShadCN stat-card-row renderer.
class ShadcnStatCardRow extends StatCardRowRenderBase {
  const ShadcnStatCardRow(super.props, {super.key});

  @override
  String get cssClass => 'arcane-stat-card-row';
}
