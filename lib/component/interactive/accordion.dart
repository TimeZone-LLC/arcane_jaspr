import 'package:arcane_jaspr/flutter.dart';

import '../../core/decoration/arcane_decoration.dart';
import '../../core/theme_provider.dart';
import '../../util/style_types/arcane_style_data.dart';

/// Accordion item data model.
class ArcaneAccordionItem {
  final String title;
  final String content;
  final Widget? customContent;

  /// Optional trigger row content shown in place of [title] (a badge and a
  /// time before the title). [title] stays the plain-text fallback.
  final Widget? customTitle;
  final bool defaultOpen;

  /// Optional category label (displayed as badge in FAQ variant).
  final String? category;

  /// Optional accent color for category badge and chevron (CSS color value).
  final String? accentColor;

  const ArcaneAccordionItem({
    required this.title,
    this.content = '',
    this.customContent,
    this.customTitle,
    this.defaultOpen = false,
    this.category,
    this.accentColor,
  });
}

/// Collapsible accordion component.
///
/// This is a StatelessComponent that delegates state management to the renderer,
/// ensuring proper event handling in SSR environments.
class ArcaneAccordion extends StatelessWidget {
  final List<ArcaneAccordionItem> items;
  final bool allowMultiple;
  final bool bordered;

  /// Visual variant of the accordion.
  final AccordionVariant variant;

  /// Default accent color for items without a specific accentColor.
  final String? defaultAccentColor;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation + theme-specific fields).
  final ArcaneDecoration? decoration;

  const ArcaneAccordion({
    required this.items,
    this.allowMultiple = false,
    this.bordered = false,
    this.variant = AccordionVariant.standard,
    this.defaultAccentColor,
    this.styles,
    this.decoration,
    super.key,
  });

  /// Creates an FAQ-style accordion with category badges and accent colors.
  const ArcaneAccordion.faq({
    required this.items,
    this.allowMultiple = true,
    this.bordered = false,
    this.defaultAccentColor,
    this.styles,
    this.decoration,
    super.key,
  }) : variant = AccordionVariant.faq;

  @override
  Widget build(BuildContext context) {
    // Determine which items should be open by default
    final Set<int> defaultOpenItems = {};
    for (int i = 0; i < items.length; i++) {
      if (items[i].defaultOpen) {
        defaultOpenItems.add(i);
      }
    }

    final List<AccordionItemProps> itemProps = items
        .map(
          (ArcaneAccordionItem item) => AccordionItemProps(
            title: item.title,
            content: item.content,
            customContent: item.customContent,
            customTitle: item.customTitle,
            category: item.category,
            accentColor: item.accentColor,
          ),
        )
        .toList();

    return context.renderers.accordion(
      AccordionProps(
        items: itemProps,
        openItems: defaultOpenItems,
        allowMultiple: allowMultiple,
        bordered: bordered,
        variant: variant,
        defaultAccentColor: defaultAccentColor,
        styles: styles,
        decoration: decoration,
      ),
    );
  }
}

/// FAQ accordion with question/answer pairs.
///
/// Simple wrapper for basic FAQ lists without categories.
/// For FAQ lists with categories and colors, use [ArcaneAccordion.faq].
class ArcaneFaqAccordion extends StatelessWidget {
  final List<({String question, String answer})> faqs;

  const ArcaneFaqAccordion({required this.faqs, super.key});

  @override
  Widget build(BuildContext context) {
    return ArcaneAccordion(
      items: faqs
          .map(
            (faq) =>
                ArcaneAccordionItem(title: faq.question, content: faq.answer),
          )
          .toList(),
      allowMultiple: true,
    );
  }
}
