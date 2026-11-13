import 'package:arcane_jaspr/flutter.dart';

import '../../util/style_types/arcane_style_data.dart';
import '../../component/view/icon.dart';
import '../decoration/arcane_decoration.dart';

/// Stat card component properties.
class StatCardProps {
  final String label;
  final String value;

  /// Optional unit beside the value at body size.
  final String? unit;
  final ArcaneGlyph? icon;
  final String? trend;
  final bool trendPositive;
  final String? description;

  /// Optional content under the value and description.
  final Widget? footer;

  /// Optional line limit for the label (ellipsis, full text as title).
  final int? labelLines;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation + theme-specific fields).
  final ArcaneDecoration? decoration;

  const StatCardProps({
    required this.label,
    required this.value,
    this.unit,
    this.icon,
    this.trend,
    this.trendPositive = true,
    this.description,
    this.footer,
    this.labelLines,
    this.styles,
    this.decoration,
  });
}

/// Stat card row component properties.
class StatCardRowProps {
  final List<Widget> cards;
  final int columns;
  final String? gap;

  const StatCardRowProps({required this.cards, this.columns = 4, this.gap});
}

// ============================================================================
// RENDERER CONTRACT
// ============================================================================

/// Mixin defining the renderer methods for stat card components.
mixin StatCardRendererContract {
  Widget statCard(StatCardProps props);
  Widget statCardRow(StatCardRowProps props);
}
