import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/check_list_props.dart';
import 'package:arcane_jaspr/core/rendering/base/check_list_render_base.dart';

/// Neubrutalism CheckItem renderer.
class NeubrutalismCheckItem extends CheckItemRenderBase {
  const NeubrutalismCheckItem(super.props, {super.key});

  @override
  String get themePrefix => 'neubrutalism';

  @override
  String get defaultIconColor => 'var(--nb-accent, var(--primary))';
}

/// Neubrutalism CheckList renderer.
class NeubrutalismCheckList extends CheckListRenderBase {
  const NeubrutalismCheckList(super.props, {super.key});

  @override
  String get themePrefix => 'neubrutalism';

  @override
  Component buildCheckItem(CheckItemProps itemProps) =>
      NeubrutalismCheckItem(itemProps);
}

/// Neubrutalism FeatureRow renderer.
///
/// Displays a feature with check/x indicator for included/excluded states.
/// Supports circular icon containers, strikethrough, and tooltips.
class NeubrutalismFeatureRow extends FeatureRowRenderBase {
  const NeubrutalismFeatureRow(super.props, {super.key});

  @override
  String get themePrefix => 'neubrutalism';

  @override
  String get defaultIncludedColor => 'var(--nb-accent, var(--primary))';

  @override
  Component buildCircularIcon(
    Component iconWidget,
    String iconColor,
    String iconSize,
  ) => dom.div(
    classes: 'neubrutalism-feature-row-icon',
    styles: dom.Styles(
      raw: <String, String>{
        'display': 'flex',
        'align-items': 'center',
        'justify-content': 'center',
        'width': iconSize,
        'height': iconSize,
        'border': 'var(--nb-border-thin, 2px) solid var(--nb-line, #000)',
        'border-radius': 'var(--nb-radius-tight, 0)',
        'flex-shrink': '0',
        'background-color': props.included
            ? 'var(--nb-accent, var(--primary))'
            : 'var(--nb-paper-soft, var(--muted))',
        'color': props.included ? 'var(--nb-ink, #000)' : 'var(--muted-foreground)',
      },
    ),
    <Component>[iconWidget],
  );
}
