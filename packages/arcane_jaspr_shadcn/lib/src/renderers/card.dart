import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/props/card_props.dart';
import 'package:arcane_jaspr/core/rendering/base/card_render_base.dart';

import 'package:arcane_jaspr_shadcn/src/renderers/decoration_styles.dart';

/// Inline background for interactive ShadCN card surfaces. The display CSS
/// flips `--shadcn-card-background` on hover so the inline declaration stays
/// authoritative while the state still paints.
const String shadcnInteractiveCardBackground =
    'var(--shadcn-card-background, var(--card))';

/// Inline shadow for interactive ShadCN card surfaces; hover raises
/// `--shadcn-card-shadow` to `--shadow-md`.
const String shadcnInteractiveCardShadow =
    'var(--shadcn-card-shadow, var(--shadow-sm))';

/// ShadCN surface defaults for card-family renderers whose shared core base
/// hardcodes a literal radius and no shadow.
///
/// Returned through the base `decorationStyles` hook, which layers after the
/// base styles and after [ArcaneDecoration.universalStyles], so every key a
/// decoration sets literally (radius, background) is left to the decoration.
/// Elevation intent still resolves last, and `styles:` still wins.
Map<String, String> shadcnCardSurfaceStyles(
  ArcaneDecoration? decoration, {
  required bool interactive,
}) {
  final Map<String, String> universal =
      decoration?.universalStyles() ?? const <String, String>{};
  final bool customBackground =
      universal.containsKey('background') ||
      universal.containsKey('background-color');
  return <String, String>{
    if (!universal.containsKey('border-radius'))
      'border-radius': 'var(--radius-md)',
    if (interactive && !customBackground)
      'background-color': shadcnInteractiveCardBackground,
    'box-shadow': interactive
        ? shadcnInteractiveCardShadow
        : 'var(--shadow-sm)',
    ...shadcnDecorationStyles(decoration),
  };
}

/// ShadCN Card renderer.
///
/// Reference: https://ui.shadcn.com/docs/components/card
class ShadcnCard extends CardRenderBase {
  const ShadcnCard(super.props, {super.key});

  @override
  String get cssClass => 'arcane-card';

  @override
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      shadcnDecorationStyles(decoration);

  bool get _interactive =>
      props.href != null ||
      props.onTap != null ||
      props.variant == CardVariant.interactive;

  // ShadCN Card: rounded-xl (capped at 8px) border bg-card
  // text-card-foreground shadow-sm
  @override
  Map<String, String> baseStyles(CardProps props) => <String, String>{
    'border-radius': props.borderRadius?.css ?? 'var(--radius-md)',
    'color': 'var(--card-foreground)',
    if (props.padding != null)
      'padding': props.padding!.padding
    else
      'padding': '1.5rem', // p-6
    if (props.fillWidth) 'width': '100%',
    if (props.onTap != null) 'cursor': 'pointer',
  };

  @override
  Map<String, String> variantStyles(CardProps props) {
    final String surface =
        props.backgroundColor ??
        (_interactive ? shadcnInteractiveCardBackground : 'var(--card)');
    // Flat surfaces stay flat on hover (the display CSS scopes the lift to the
    // elevated variants) but still take the focus ring through the hook.
    final String flatShadow = _interactive
        ? 'var(--shadcn-card-shadow, none)'
        : 'none';
    final Map<String, String> transition = _interactive
        ? const <String, String>{
            'transition':
                'background-color var(--transition), box-shadow var(--transition)',
          }
        : const <String, String>{};
    return switch (props.variant) {
      CardVariant.elevated || CardVariant.interactive => <String, String>{
        'background-color': surface,
        'border': '1px solid var(--border)',
        'box-shadow': _interactive
            ? shadcnInteractiveCardShadow
            : 'var(--shadow-sm)',
        ...transition,
      },
      CardVariant.flat => <String, String>{
        'background-color': surface,
        'border': '1px solid var(--border)',
        'box-shadow': flatShadow,
        ...transition,
      },
      CardVariant.outlined => <String, String>{
        'background-color':
            props.backgroundColor ??
            (_interactive
                ? 'var(--shadcn-card-background, var(--background))'
                : 'var(--background)'),
        'border': '1px solid var(--border)',
        'box-shadow': flatShadow,
        ...transition,
      },
      CardVariant.ghost => <String, String>{
        'background-color': 'transparent',
        'border': 'none',
        'box-shadow': flatShadow,
        ...transition,
      },
    };
  }
}
