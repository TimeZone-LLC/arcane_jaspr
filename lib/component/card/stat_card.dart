import 'package:arcane_jaspr/flutter.dart';

import '../../core/decoration/arcane_decoration.dart';
import '../../core/props/stat_card_props.dart';
import '../../core/theme_provider.dart';
import '../../util/style_types/arcane_style_data.dart';
import '../view/icon.dart';

/// A compact metric surface: an uppercase label, a large value, and optional
/// icon, trend, and description. Themed automatically by the active stylesheet.
class StatCard extends StatelessWidget {
  final String label;
  final String value;

  /// Optional unit beside the value at body size ("ms", "chunks"). Null
  /// renders the card as before.
  final String? unit;
  final ArcaneGlyph? icon;
  final String? trend;
  final bool trendPositive;
  final String? description;

  /// Optional content under the value and description (a sparkline, a
  /// progress bar). Null renders the card as before.
  final Widget? footer;

  /// Optional line limit for the label: longer labels end in an ellipsis
  /// and show in full as the label's title. Null lets the label wrap as
  /// before.
  final int? labelLines;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation + theme-specific fields).
  final ArcaneDecoration? decoration;

  const StatCard({
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
    super.key,
  });

  @override
  Widget build(BuildContext context) => context.renderers.statCard(
    StatCardProps(
      label: label,
      value: value,
      unit: unit,
      icon: icon,
      trend: trend,
      trendPositive: trendPositive,
      description: description,
      footer: footer,
      labelLines: labelLines,
      styles: styles,
      decoration: decoration,
    ),
  );
}

/// A responsive grid of [StatCard]s laid out in [columns] equal columns.
class StatCardRow extends StatelessWidget {
  final List<Widget> cards;
  final int columns;
  final String? gap;

  const StatCardRow({
    required this.cards,
    this.columns = 4,
    this.gap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => context.renderers.statCardRow(
    StatCardRowProps(cards: cards, columns: columns, gap: gap),
  );
}
