import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/component/view/icon.dart';
import 'package:arcane_jaspr/core/props/checkbox_props.dart';
import 'package:arcane_jaspr/core/rendering/base/checkbox_render_base.dart';

/// ShadCN Checkbox renderer.
///
/// Outputs the exact HTML structure and CSS from ui.shadcn.com.
/// Reference: https://ui.shadcn.com/docs/components/checkbox
class ShadcnCheckbox extends CheckboxRenderBase {
  const ShadcnCheckbox(super.props, {super.key});

  @override
  String wrapperClasses(CheckboxProps props) => 'arcane-checkbox-wrapper';

  @override
  Map<String, String> extraWrapperAttrs(CheckboxProps props) =>
      const <String, String>{};

  /// A one-line label centres on the box; a description pins the box to the
  /// label line so the text block grows downward.
  @override
  Map<String, String> wrapperStyles(CheckboxProps props) => <String, String>{
    'display': 'flex',
    'align-items': props.description == null ? 'center' : 'flex-start',
    'gap': 'var(--space-2)', // gap-2
    'cursor': props.disabled ? 'not-allowed' : 'pointer',
    // ShadCN: disabled:opacity-50 disabled:cursor-not-allowed. The wrapper is
    // the only dimmed layer so the box and label fade together, once.
    'opacity': props.disabled ? '0.5' : '1',
    'pointer-events': props.disabled ? 'none' : 'auto',
  };

  @override
  Map<String, String> labelTextStyles(CheckboxProps props) => <String, String>{
    // ShadCN: text-sm font-medium leading-none
    'font-size': 'var(--font-size-sm)', // 14px
    'font-weight': 'var(--font-weight-medium)',
    'color': 'var(--foreground)',
    'display': 'block',
    'line-height': '1',
  };

  @override
  Map<String, String> descriptionTextStyles(CheckboxProps props) =>
      <String, String>{
        // ShadCN: text-sm text-muted-foreground
        'font-size': 'var(--font-size-sm)', // 14px
        'color': 'var(--muted-foreground)',
        'display': 'block',
        'margin-top': '0.25rem', // 4px
      };

  @override
  Component buildBox(CheckboxProps props, Map<String, String> itemAttrs) {
    // ShadCN v4: size-4 rounded-[4px] shadow-xs, check glyph size-3.5. The
    // border is the 3:1 `--shadcn-control-border`, not bare `border-input`.
    final (String boxSize, String glyphSize) = switch (props.size) {
      ComponentSize.sm => ('14px', '12px'),
      ComponentSize.md => ('16px', '14px'),
      ComponentSize.lg => ('20px', '16px'),
    };

    // Checked fill and border share the colour variant.
    final String checkedFill = switch (props.color) {
      ColorVariant.primary => 'var(--primary)',
      ColorVariant.secondary => 'var(--secondary)',
      ColorVariant.destructive => 'var(--destructive)',
      ColorVariant.success => 'var(--success, #22c55e)',
      ColorVariant.warning => 'var(--warning, #f59e0b)',
      ColorVariant.info => 'var(--info, #3b82f6)',
    };

    // Checkmark foreground color.
    final String checkColor = switch (props.color) {
      ColorVariant.primary => 'var(--primary-foreground)',
      ColorVariant.secondary => 'var(--secondary-foreground)',
      ColorVariant.destructive => 'var(--destructive-foreground)',
      ColorVariant.success => 'var(--success-foreground, #ffffff)',
      ColorVariant.warning => 'var(--warning-foreground, #000000)',
      ColorVariant.info => 'var(--info-foreground, #ffffff)',
    };

    return dom.div(
      classes: 'arcane-checkbox',
      attributes: itemAttrs,
      styles: dom.Styles(
        raw: <String, String>{
          'width': boxSize,
          'height': boxSize,
          'box-sizing': 'border-box',
          'border-radius': 'var(--radius-xs)',
          // data-[state=checked]:bg-primary border-primary, set by the
          // theme CSS from the runtime-maintained data-arcane-state.
          '--shadcn-checkbox-fill': checkedFill,
          'background-color':
              'var(--shadcn-checkbox-background, var(--shadcn-input-background, transparent))',
          'border':
              '1px solid var(--shadcn-control-border-color, var(--shadcn-checkbox-border, var(--shadcn-control-border)))',
          'box-shadow': 'var(--shadcn-control-shadow, var(--shadow-xs))',
          'outline': 'none',
          'display': 'flex',
          'align-items': 'center',
          'justify-content': 'center',
          'flex-shrink': '0',
          'transition':
              'box-shadow var(--transition), '
              'background-color var(--transition), border-color var(--transition)',
          ...?props.decoration?.universalStyles(),
          ...?props.styles?.toMap(),
        },
      ),
      <Component>[
        dom.span(
          classes: 'arcane-checkbox-indicator',
          attributes: const <String, String>{'aria-hidden': 'true'},
          styles: dom.Styles(
            raw: <String, String>{
              'color': checkColor,
              'display': 'var(--shadcn-checkbox-indicator, none)',
              'align-items': 'center',
              'justify-content': 'center',
              'line-height': '1',
              '--shadcn-checkbox-glyph': glyphSize,
            },
          ),
          <Component>[ArcaneIcon.check(size: IconSize.xs)],
        ),
      ],
    );
  }
}
