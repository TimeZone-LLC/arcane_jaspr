import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/separator_props.dart';
import 'package:arcane_jaspr/core/rendering/base/separator_render_base.dart';

/// ShadCN Separator renderer.
///
/// Unified separator component combining features from both Divider and Separator.
/// Supports variants, dashed lines, labels, icons, and custom colors.
///
/// Reference: https://ui.shadcn.com/docs/components/separator
class ShadcnSeparator extends SeparatorRenderBase {
  const ShadcnSeparator(super.props, {super.key});

  // ShadCN Separator: shrink-0 bg-border h-px w-full, no built-in margin.
  // Callers own spacing through the layout gap or an explicit margin.
  @override
  String get resolveMargin => props.margin == null ? '0' : '${props.margin}px';

  // The subtle variant draws a softened border line; `--muted` is a surface
  // fill and disappears against light backgrounds.
  @override
  Map<String, String> backgroundStyle(String color) => super.backgroundStyle(
    props.color == null && props.variant == SeparatorVariant.subtle
        ? 'var(--shadcn-subtle-line)'
        : color,
  );

  @override
  String get verticalClasses => 'arcane-separator arcane-separator-vertical';

  @override
  String get labeledClasses => 'arcane-separator arcane-separator-labeled';

  @override
  Map<String, String> get verticalStretchStyles => const <String, String>{
    'align-self': 'stretch',
    'min-height': '20px',
  };

  @override
  Map<String, String> labeledContainerStyles(String margin) => <String, String>{
    'display': 'flex',
    'align-items': 'center',
    'gap': 'var(--space-4)',
    'margin': '$margin 0',
  };

  @override
  Map<String, String> get labelSpanStyles => const <String, String>{
    'font-size': 'var(--font-size-sm)',
    'color': 'var(--muted-foreground)',
    'white-space': 'nowrap',
  };

  @override
  Map<String, String> get iconSpanStyles => const <String, String>{
    'color': 'var(--muted-foreground)',
  };

  @override
  Component buildSimpleHorizontal(
    String thickness,
    String color,
    String margin,
  ) {
    return dom.hr(
      classes: 'arcane-separator',
      attributes: horizontalAttrs(),
      styles: dom.Styles(
        raw: <String, String>{
          'margin': '$margin 0',
          'border': 'none',
          'flex-shrink': '0',
          'height': thickness,
          ...backgroundStyle(color),
          ...?props.decoration?.universalStyles(),
          ...?props.styles?.toMap(),
        },
      ),
    );
  }
}
