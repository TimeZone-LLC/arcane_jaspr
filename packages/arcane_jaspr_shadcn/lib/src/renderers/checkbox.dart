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

  @override
  Map<String, String> wrapperStyles(CheckboxProps props) => <String, String>{
    'display': 'flex',
    'align-items': 'flex-start',
    'gap': 'var(--space-2)', // gap-2
    'cursor': props.disabled ? 'not-allowed' : 'pointer',
    // ShadCN: disabled:opacity-50 disabled:cursor-not-allowed
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
    // ShadCN size dimensions: default h-4 w-4 (16px), rounded-sm (4px)
    final String boxSize = switch (props.size) {
      ComponentSize.sm => '14px', // h-3.5
      ComponentSize.md => '16px', // h-4 (shadcn default)
      ComponentSize.lg => '20px', // h-5
    };

    // Color variant: border is always the color value (like radio).
    final (String checkedBg, String borderColor) = switch (props.color) {
      ColorVariant.primary => ('var(--primary)', 'var(--primary)'),
      ColorVariant.secondary => ('var(--secondary)', 'var(--secondary)'),
      ColorVariant.destructive => ('var(--destructive)', 'var(--destructive)'),
      ColorVariant.success => (
        'var(--success, #22c55e)',
        'var(--success, #22c55e)',
      ),
      ColorVariant.warning => (
        'var(--warning, #f59e0b)',
        'var(--warning, #f59e0b)',
      ),
      ColorVariant.info => ('var(--info, #3b82f6)', 'var(--info, #3b82f6)'),
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
          // ShadCN: rounded-sm (4px / 0.125rem)
          'border-radius': '0.125rem',
          // ShadCN: data-[state=checked]:bg-primary
          '--shadcn-checkbox-fill': checkedBg,
          'background-color': 'var(--shadcn-checkbox-background, transparent)',
          // ShadCN: border border-primary
          'border': '1px solid $borderColor',
          'display': 'flex',
          'align-items': 'center',
          'justify-content': 'center',
          'flex-shrink': '0',
          // ShadCN: transition-colors
          'transition':
              'color var(--transition), background-color var(--transition), border-color var(--transition)',
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
              // ShadCN: text-primary-foreground when checked
              'color': checkColor,
              'display': 'var(--shadcn-checkbox-indicator, none)',
              'line-height': '1',
            },
          ),
          <Component>[ArcaneIcon.check(size: IconSize.xs)],
        ),
      ],
    );
  }
}
