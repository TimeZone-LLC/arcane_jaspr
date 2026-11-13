import 'package:arcane_jaspr/flutter.dart';

import '../../core/decoration/arcane_decoration.dart';
import '../../core/theme_provider.dart';
import '../../util/classes.dart';
import '../../util/style_types/arcane_style_data.dart';

export '../../core/props/disclosure_props.dart'
    show DisclosureVariant, DisclosureItemProps;

/// Disclosure widget using native HTML details/summary elements.
class ArcaneDisclosure extends StatelessWidget {
  final Widget summary;
  final Widget child;
  final bool open;
  final DisclosureVariant variant;
  final bool showChevron;
  final bool showTreeLines;
  final List<String>? classes;

  /// Makes [open] controlled: clicks on the summary call this with the
  /// requested state and the disclosure only changes when [open] does.
  final void Function(bool open)? onOpenChange;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation + theme-specific fields).
  final ArcaneDecoration? decoration;

  const ArcaneDisclosure({
    required this.summary,
    required this.child,
    this.open = false,
    this.variant = DisclosureVariant.default_,
    this.showChevron = true,
    this.showTreeLines = true,
    this.classes,
    this.onOpenChange,
    this.styles,
    this.decoration,
    super.key,
  });

  const ArcaneDisclosure.minimal({
    required this.summary,
    required this.child,
    this.open = false,
    this.showChevron = true,
    this.showTreeLines = true,
    this.classes,
    this.onOpenChange,
    this.styles,
    this.decoration,
    super.key,
  }) : variant = DisclosureVariant.minimal;

  const ArcaneDisclosure.bordered({
    required this.summary,
    required this.child,
    this.open = false,
    this.showChevron = true,
    this.showTreeLines = true,
    this.classes,
    this.onOpenChange,
    this.styles,
    this.decoration,
    super.key,
  }) : variant = DisclosureVariant.bordered;

  const ArcaneDisclosure.filled({
    required this.summary,
    required this.child,
    this.open = false,
    this.showChevron = true,
    this.showTreeLines = true,
    this.classes,
    this.onOpenChange,
    this.styles,
    this.decoration,
    super.key,
  }) : variant = DisclosureVariant.filled;

  @override
  Widget build(BuildContext context) {
    return context.renderers.disclosure(
      DisclosureProps(
        summary: summary,
        child: child,
        open: open,
        variant: variant,
        showChevron: showChevron,
        showTreeLines: showTreeLines,
        classes: classes == null ? null : cx(classes!),
        onOpenChange: onOpenChange,
        styles: styles,
        decoration: decoration,
      ),
    );
  }
}

/// Group of disclosure widgets.
class ArcaneDisclosureGroup extends StatelessWidget {
  final List<ArcaneDisclosureItem> items;
  final String gap;
  final DisclosureVariant variant;
  final int? initialOpenIndex;

  const ArcaneDisclosureGroup({
    required this.items,
    this.gap = '0.5rem',
    this.variant = DisclosureVariant.default_,
    this.initialOpenIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return context.renderers.disclosureGroup(
      DisclosureGroupProps(
        items: items
            .map(
              (item) => DisclosureItemProps(
                summary: item.summary,
                content: item.content,
                showChevron: item.showChevron,
              ),
            )
            .toList(),
        gap: gap,
        variant: variant,
        initialOpenIndex: initialOpenIndex,
      ),
    );
  }
}

/// Item in an ArcaneDisclosureGroup.
class ArcaneDisclosureItem {
  final Widget summary;
  final Widget content;
  final bool showChevron;

  const ArcaneDisclosureItem({
    required this.summary,
    required this.content,
    this.showChevron = true,
  });
}
