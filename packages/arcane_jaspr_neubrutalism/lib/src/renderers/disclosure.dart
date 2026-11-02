import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/disclosure_props.dart';
import 'package:arcane_jaspr/component/view/icon.dart';
import 'package:arcane_jaspr/core/rendering/base/disclosure_render_base.dart';

/// Neubrutalism Disclosure renderer.
class NeubrutalismDisclosure extends DisclosureRenderBase {
  const NeubrutalismDisclosure(super.props, {super.key});

  @override
  String get classPrefix => 'neubrutalism';

  @override
  Map<String, String> containerStyles(DisclosureVariant variant) =>
      const <String, String>{};

  @override
  Map<String, String> summaryStyles(DisclosureVariant variant) =>
      const <String, String>{};

  @override
  Component buildChevron() => dom.span(
    classes: 'neubrutalism-disclosure-chevron',
    attributes: const <String, String>{'aria-hidden': 'true'},
    <Component>[ArcaneIcon.chevronDown(size: IconSize.sm)],
  );

  @override
  (String padding, String border) contentVariant(DisclosureVariant variant) =>
      switch (variant) {
        DisclosureVariant.minimal => ('0.25rem 0 0', 'none'),
        _ => ('0 1.125rem 1.125rem', 'none'),
      };
}

/// Neubrutalism Disclosure Group renderer.
class NeubrutalismDisclosureGroup extends DisclosureGroupRenderBase {
  const NeubrutalismDisclosureGroup(super.props, {super.key});

  @override
  String get classPrefix => 'neubrutalism';

  @override
  Component buildDisclosure(DisclosureProps itemProps) =>
      NeubrutalismDisclosure(itemProps);
}
