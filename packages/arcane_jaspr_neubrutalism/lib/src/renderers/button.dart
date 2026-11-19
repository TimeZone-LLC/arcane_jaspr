import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/props/button_props.dart';
import 'package:arcane_jaspr/core/rendering/base/button_render_base.dart';

import 'package:arcane_jaspr_neubrutalism/src/renderers/decoration_styles.dart';

class NeubrutalismButton extends ButtonRenderBase {
  const NeubrutalismButton(super.props, {super.key});

  @override
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      neubrutalismDecorationStyles(decoration);

  @override
  String get cssClass => 'neubrutalism-button';

  @override
  Map<String, String> baseStyles(bool isDisabled) => <String, String>{
    'display': 'inline-flex',
    'align-items': 'center',
    'justify-content': 'center',
    'gap': '0.5rem',
    'white-space': 'nowrap',
    'border-radius': 'var(--nb-radius-soft, 0)',
    'font-family': 'var(--font-heading)',
    'font-size': '1rem',
    'font-weight': '700',
    'line-height': '1.7',
    'letter-spacing': '0',
    'text-transform': 'none',
    'outline': 'none',
    'cursor': isDisabled ? 'not-allowed' : 'pointer',
    'pointer-events': isDisabled ? 'none' : 'auto',
    'opacity': isDisabled ? '0.5' : '1',
    'user-select': 'none',
    '-webkit-user-select': 'none',
    'position': 'relative',
    'transition':
        'transform 120ms cubic-bezier(0.2, 0.8, 0.2, 1), box-shadow 120ms cubic-bezier(0.2, 0.8, 0.2, 1), background-color 120ms cubic-bezier(0.2, 0.8, 0.2, 1)',
  };

  @override
  Map<String, String> variantStyles(ButtonVariant variant) => switch (variant) {
    ButtonVariant.primary => <String, String>{
      'background-color': 'var(--nb-accent, var(--primary))',
      'color': 'var(--nb-on-accent, #000)',
    },
    ButtonVariant.destructive => <String, String>{
      'background-color': 'var(--destructive)',
      'color': 'var(--destructive-foreground, #000)',
    },
    ButtonVariant.outline => <String, String>{
      'background-color': 'var(--nb-paper, #fff)',
      'color': 'var(--foreground)',
    },
    ButtonVariant.secondary => <String, String>{
      'background-color': 'var(--nb-accent-cool, var(--secondary))',
      'color': 'var(--nb-on-accent-cool, #000)',
    },
    ButtonVariant.ghost => <String, String>{
      'background-color': 'transparent',
      'color': 'var(--foreground)',
      'border': 'none',
      'box-shadow': 'none',
    },
    ButtonVariant.link => <String, String>{
      'background-color': 'transparent',
      'color': 'var(--foreground)',
      'border': 'none',
      'box-shadow': 'none',
      'text-decoration': 'underline',
      'text-decoration-thickness': '2px',
      'text-underline-offset': '4px',
      'padding': '0',
      'height': 'auto',
    },
    ButtonVariant.success => <String, String>{
      'background-color': 'var(--success, #22c55e)',
      'color': 'var(--success-foreground, #000)',
    },
    ButtonVariant.warning => <String, String>{
      'background-color': 'var(--warning, #facc15)',
      'color': 'var(--warning-foreground, #000)',
    },
    ButtonVariant.info => <String, String>{
      'background-color': 'var(--info, #3b82f6)',
      'color': 'var(--info-foreground, #000)',
    },
  };

  @override
  Map<String, String> sizeStyles(ButtonSize size) => switch (size) {
    ButtonSize.sm => <String, String>{
      'min-height': '2.75rem',
      'padding': '0.5rem 1rem',
      'font-size': '0.875rem',
    },
    ButtonSize.md => <String, String>{
      'min-height': '2.75rem',
      'padding': '0.75rem 1.5rem',
    },
    ButtonSize.lg => <String, String>{
      'min-height': '3rem',
      'padding': '1rem 2rem',
      'font-size': '1.125rem',
    },
    ButtonSize.iconSm => <String, String>{
      'height': '2.25rem',
      'width': '2.25rem',
      'padding': '0',
    },
    ButtonSize.iconMd => <String, String>{
      'height': '2.75rem',
      'width': '2.75rem',
      'padding': '0',
    },
    ButtonSize.iconLg => <String, String>{
      'height': '3rem',
      'width': '3rem',
      'padding': '0',
    },
  };
}
