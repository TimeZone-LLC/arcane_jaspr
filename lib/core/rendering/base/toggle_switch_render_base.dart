import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/interaction/interaction.dart';
import 'package:arcane_jaspr/core/interaction/interaction_attrs.dart';
import 'package:arcane_jaspr/core/props/toggle_switch_props.dart';

/// Shared structural base for themed toggle-switch renderers.
///
/// Like the checkbox, the switch's track/thumb and wrapper diverge
/// structurally per theme (different attribute sets, event wiring and thumb
/// markup), so this base only factors the parts that are genuinely identical
/// and error-prone: the external-group resolution, the group/item interaction
/// attribute wiring, the label-or-no-label control flow and the
/// label-left/right child ordering. The visual switch and wrapper are supplied
/// by the subclass through [buildSwitch] and [buildWrapper]; the label span is
/// structurally identical across themes, so only its class and styles are
/// abstract.
///
/// This base lives in core and depends only on core props and interaction
/// helpers; it must never depend on a theme package.
abstract class ToggleSwitchRenderBase extends StatelessComponent {
  const ToggleSwitchRenderBase(this.props, {super.key});

  final ToggleSwitchProps props;

  /// Builds the visual switch (track + thumb). [itemAttrs] are the resolved
  /// group-item/interaction attributes that must be placed on the control.
  Component buildSwitch(ToggleSwitchProps props, Map<String, String> itemAttrs);

  /// Class applied to the label text span.
  String get labelClasses;

  /// Inline styles for the label text span.
  Map<String, String> labelStyles(ToggleSwitchProps props);

  /// Builds the wrapper element that contains the switch and label.
  /// [rootAttrs] are the resolved group attributes (empty when in an external
  /// group); [children] are pre-ordered per `labelLeft`.
  Component buildWrapper(
    ToggleSwitchProps props,
    Map<String, String> rootAttrs,
    List<Component> children,
  );

  @override
  Component build(BuildContext context) {
    final bool inExternalGroup =
        props.group != null &&
        props.group!.isNotEmpty &&
        props.itemValue != null;
    final String groupId = inExternalGroup ? props.group! : props.id;
    final String optionValue = inExternalGroup ? props.itemValue! : 'on';
    final String groupMode = inExternalGroup ? 'multi' : 'single';
    final String currentGroupValue = props.value ? optionValue : '';

    final Map<String, String> rootAttrs = inExternalGroup
        ? const <String, String>{}
        : groupAttrs(
            groupId: groupId,
            mode: groupMode,
            value: currentGroupValue,
            disabled: props.disabled,
            changeAction: props.onChangeAction != null
                ? encodeArcaneAction(props.onChangeAction!)
                : null,
          );

    final Map<String, String> itemAttrs = mergeAttrs(<Map<String, String>>[
      <String, String>{
        if (props.label != null) 'aria-labelledby': '${props.id}-label',
      },
      groupItemAttrs(
        groupId: groupId,
        value: optionValue,
        selected: props.value,
        disabled: props.disabled,
      ),
      if (!props.disabled)
        interactionAttrs(ArcaneInteraction.toggleValue(groupId, optionValue)),
    ]);

    final Component switchWidget = buildSwitch(props, itemAttrs);

    if (props.label == null) {
      return buildWrapper(props, rootAttrs, <Component>[switchWidget]);
    }

    final Component labelWidget = dom.span(
      id: '${props.id}-label',
      classes: labelClasses,
      styles: dom.Styles(raw: labelStyles(props)),
      <Component>[Component.text(props.label!)],
    );

    final List<Component> children = props.labelLeft
        ? <Component>[labelWidget, switchWidget]
        : <Component>[switchWidget, labelWidget];

    return buildWrapper(props, rootAttrs, children);
  }
}
