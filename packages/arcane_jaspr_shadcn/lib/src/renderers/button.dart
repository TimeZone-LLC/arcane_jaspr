import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/props/button_props.dart';
import 'package:arcane_jaspr/core/rendering/base/button_render_base.dart';

import 'package:arcane_jaspr_shadcn/src/renderers/decoration_styles.dart';

/// ShadCN v4 buttons: 36px default height, `rounded-md`, `shadow-xs`.
///
/// Colours, borders and hover fills live in the theme CSS so hover and
/// instance overrides can win; the inline box-shadow reads
/// `--shadcn-control-shadow` so the focus-visible ring can replace it.
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
    'gap': '0.5rem',
    'white-space': 'nowrap',
    'border-radius': 'var(--radius-md)',
    'font-size': '0.875rem',
    'font-weight': '500',
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
    'box-shadow': switch (variant) {
      ButtonVariant.ghost ||
      ButtonVariant.link => 'var(--shadcn-control-shadow, none)',
      _ => 'var(--shadcn-control-shadow, var(--shadow-xs))',
    },
  };

  @override
  Map<String, String> sizeStyles(ButtonSize size) => switch (size) {
    ButtonSize.sm => <String, String>{
      'height': '2rem',
      'padding': '0 0.75rem',
      'gap': '0.375rem',
    },
    ButtonSize.md => <String, String>{
      'height': '2.25rem',
      'padding': '0.5rem 1rem',
    },
    ButtonSize.lg => <String, String>{
      'height': '2.5rem',
      'padding': '0 1.5rem',
    },
    ButtonSize.iconSm => <String, String>{
      'height': '2rem',
      'width': '2rem',
      'padding': '0',
    },
    ButtonSize.iconMd => <String, String>{
      'height': '2.25rem',
      'width': '2.25rem',
      'padding': '0',
    },
    ButtonSize.iconLg => <String, String>{
      'height': '2.5rem',
      'width': '2.5rem',
      'padding': '0',
    },
  };
}
