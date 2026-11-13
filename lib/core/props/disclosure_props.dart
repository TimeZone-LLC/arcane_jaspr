import 'package:arcane_jaspr/flutter.dart';

import '../../util/style_types/arcane_style_data.dart';
import '../decoration/arcane_decoration.dart';

enum DisclosureVariant { default_, minimal, bordered, filled }

/// Disclosure component properties.
class DisclosureProps {
  final Widget summary;
  final Widget child;
  final bool open;
  final DisclosureVariant variant;
  final bool showChevron;
  final bool showTreeLines;
  final String? classes;

  /// Makes [open] controlled: a summary click asks for the new state here
  /// instead of toggling the element, and opens made outside it (find in
  /// page, script) are reported too.
  final void Function(bool open)? onOpenChange;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation + theme-specific fields).
  final ArcaneDecoration? decoration;

  const DisclosureProps({
    required this.summary,
    required this.child,
    this.open = false,
    this.variant = DisclosureVariant.default_,
    this.showChevron = true,
    this.showTreeLines = false,
    this.classes,
    this.onOpenChange,
    this.styles,
    this.decoration,
  });
}

/// Disclosure group component properties.
class DisclosureGroupProps {
  final List<DisclosureItemProps> items;
  final String gap;
  final DisclosureVariant variant;
  final int? initialOpenIndex;

  const DisclosureGroupProps({
    required this.items,
    this.gap = '0.5rem',
    this.variant = DisclosureVariant.default_,
    this.initialOpenIndex,
  });
}

/// Disclosure item data.
class DisclosureItemProps {
  final Widget summary;
  final Widget content;
  final bool showChevron;

  const DisclosureItemProps({
    required this.summary,
    required this.content,
    this.showChevron = true,
  });
}

// ============================================================================
// RENDERER CONTRACT
// ============================================================================

/// Mixin defining the renderer methods for disclosure components.
mixin DisclosureRendererContract {
  Widget disclosure(DisclosureProps props);
  Widget disclosureGroup(DisclosureGroupProps props);
}
