import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/props/button_props.dart';
import 'package:arcane_jaspr/core/rendering/base/button_render_base.dart';

import 'package:arcane_jaspr_shadcn/src/renderers/decoration_styles.dart';

/// Compact buttons with theme-owned color and interaction states.
class ShadcnButton extends ButtonRenderBase {
  const ShadcnButton(super.props, {super.key});

  @override
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      shadcnDecorationStyles(decoration);

  @override
  String get cssClass => 'arcane-button';

  @override
  Map<String, String> baseStyles(bool isDisabled) => <String, String>{
    'display': 'inline-flex',
    'align-items': 'center',
    'justify-content': 'center',
    'gap': 'var(--space-2)',
    'white-space': 'nowrap',
    'border-radius': 'var(--radius-sm)',
    'font-size': 'var(--font-size-sm)',
    'font-weight': 'var(--font-weight-medium)',
    'line-height': '1.25rem',
    'transition':
        'color var(--transition), background-color var(--transition), border-color var(--transition), box-shadow var(--transition)',
    'cursor': isDisabled ? 'not-allowed' : 'pointer',
    'pointer-events': isDisabled ? 'none' : 'auto',
    'opacity': isDisabled ? '0.5' : '1',
    'user-select': 'none',
    '-webkit-user-select': 'none',
  };

  @override
  Map<String, String> variantStyles(ButtonVariant variant) => <String, String>{
    'text-decoration': variant == ButtonVariant.link ? 'underline' : 'none',
  };

  @override
  Map<String, String> sizeStyles(ButtonSize size) => switch (size) {
    ButtonSize.sm => <String, String>{
      'height': '2.25rem',
      'padding': '0 0.75rem',
    },
    ButtonSize.md => <String, String>{
      'height': '2.5rem',
      'padding': '0.5rem 1rem',
    },
    ButtonSize.lg => <String, String>{'height': '2.75rem', 'padding': '0 2rem'},
    ButtonSize.iconSm => <String, String>{
      'height': '2.25rem',
      'width': '2.25rem',
      'padding': '0',
    },
    ButtonSize.iconMd => <String, String>{
      'height': '2.5rem',
      'width': '2.5rem',
      'padding': '0',
    },
    ButtonSize.iconLg => <String, String>{
      'height': '2.75rem',
      'width': '2.75rem',
      'padding': '0',
    },
  };
}
