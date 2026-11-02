import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/props/card_props.dart';
import 'package:arcane_jaspr/core/rendering/base/card_render_base.dart';

import 'package:arcane_jaspr_neubrutalism/src/renderers/decoration_styles.dart';

class NeubrutalismCard extends CardRenderBase {
  const NeubrutalismCard(super.props, {super.key});

  @override
  String get cssClass => 'neubrutalism-card';

  @override
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      neubrutalismDecorationStyles(decoration);

  @override
  Map<String, String> baseStyles(CardProps props) => <String, String>{
    'border-radius': props.borderRadius?.css ?? 'var(--nb-radius-soft, 0)',
    'color': 'var(--card-foreground)',
    if (props.padding != null)
      'padding': props.padding!.padding
    else
      'padding': '2rem',
    if (props.fillWidth) 'width': '100%',
    if (props.onTap != null) 'cursor': 'pointer',
    'position': 'relative',
    'transition':
        'transform 120ms cubic-bezier(0.2, 0.8, 0.2, 1), box-shadow 120ms cubic-bezier(0.2, 0.8, 0.2, 1)',
  };

  @override
  Map<String, String> variantStyles(CardProps props) => switch (props.variant) {
    CardVariant.elevated => <String, String>{
      'background-color':
          props.backgroundColor ?? 'var(--nb-paper, var(--card))',
      'border': 'var(--nb-border-base, 3px) solid var(--nb-line, #000)',
      'box-shadow':
          'var(--nb-shadow-md, 5px 5px 0 0 var(--nb-shadow-color, #000))',
    },
    CardVariant.flat => <String, String>{
      'background-color':
          props.backgroundColor ?? 'var(--nb-paper, var(--card))',
      'border': 'var(--nb-border-base, 3px) solid var(--nb-line, #000)',
      'box-shadow': 'none',
    },
    CardVariant.outlined => <String, String>{
      'background-color': props.backgroundColor ?? 'transparent',
      'border': 'var(--nb-border-base, 3px) solid var(--nb-line, #000)',
      'box-shadow': 'none',
    },
    CardVariant.ghost => <String, String>{
      'background-color': 'transparent',
      'border': 'none',
      'box-shadow': 'none',
    },
    CardVariant.interactive => <String, String>{
      'background-color':
          props.backgroundColor ?? 'var(--nb-paper, var(--card))',
      'border': 'var(--nb-border-base, 3px) solid var(--nb-line, #000)',
      'box-shadow':
          'var(--nb-shadow-md, 5px 5px 0 0 var(--nb-shadow-color, #000))',
    },
  };
}
