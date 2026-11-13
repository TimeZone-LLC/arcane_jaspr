import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/rendering/base/style_layering.dart';
import 'package:arcane_jaspr/core/interaction/interaction.dart';
import 'package:arcane_jaspr/core/interaction/interaction_attrs.dart';
import 'package:arcane_jaspr/core/props/toggle_group_props.dart';

/// Shared structural base for themed toggle group renderers.
///
/// Every theme's toggle group emits the same skeleton: a `role="group"`
/// container whose group interaction attributes are derived identically from
/// the selection type/value, plus a loop of `<button>` items each carrying the
/// same group-item/interaction wiring (`groupItemAttrs`, `interactionAttrs`,
/// `type`, `aria-pressed`, `disabled`) and the same single/multi click
/// behaviour. This base factors that error-prone interaction plumbing and the
/// element structure, leaving only the theme-specific values — root/item CSS
/// classes, the container/item style maps, and the extra root/item data
/// attributes — to the abstract members below.
///
/// This base lives in core and depends only on core props and interaction
/// helpers; it must never depend on a theme package.
abstract class ToggleGroupRenderBase extends StatelessComponent {
  const ToggleGroupRenderBase(this.props, {super.key});

  final ToggleGroupProps props;

  /// CSS class applied to the container element.
  String get cssClass;

  /// CSS class applied to each item button (before the `selected`/`disabled`
  /// state classes are appended).
  String get itemBaseClass;

  /// Inline styles for the container element.
  Map<String, String> get containerStyles;

  /// Per-instance decoration overrides. Default: none. Themes translate an
  /// ArcaneDecoration into their own CSS; unimplemented fields are ignored.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  /// Extra container attributes merged after `role="group"` (e.g.
  /// `data-disabled`/`data-variant`/`data-size`); return an empty map for none.
  Map<String, String> extraRootAttrs();

  /// Extra item-button attributes merged after `aria-pressed` and before the
  /// `disabled` flag (e.g. `data-state`/`data-disabled`); return an empty map
  /// for none.
  Map<String, String> extraItemAttrs(bool isSelected, bool isDisabled);

  /// Full inline style map for an item button (theme base styles merged with
  /// the variant/selection styles, exactly as the theme assembles them).
  Map<String, String> itemStyles(bool isSelected, bool isDisabled);

  /// Styles for the item at [index] of [count], merged after [itemStyles]
  /// (a joined group squares its inner corners). Default: none.
  Map<String, String> itemPositionStyles(int index, int count) =>
      const <String, String>{};

  @override
  Component build(BuildContext context) {
    final String groupId = props.id ?? 'toggle-${identityHashCode(props)}';
    final bool multi = props.type == ToggleGroupSelectionType.multiple;
    final String mode = multi ? 'multi' : 'single';
    final String? value = multi ? props.values?.join(',') : props.value;

    final Map<String, String> rootAttrs = <String, String>{
      ...groupAttrs(
        groupId: groupId,
        mode: mode,
        value: value,
        disabled: props.disabled,
        changeAction: props.onChangeAction == null
            ? null
            : encodeArcaneAction(props.onChangeAction!),
      ),
      'role': 'group',
      ...extraRootAttrs(),
    };

    return dom.div(
      classes: cssClass,
      attributes: rootAttrs,
      styles: dom.Styles(
        raw: layerStyles(
          <String, String>{
            ...containerStyles,
          },
          <Map<String, String>?>[
            props.decoration?.universalStyles(),
            decorationStyles(props.decoration),
            props.styles?.toMap(),
          ],
        ),
      ),
      <Component>[
        for (final ToggleGroupItemProps item in props.items)
          buildItem(groupId, item),
      ],
    );
  }

  /// Builds a single toggle item button. Structure is identical across themes;
  /// only the style map and extra attributes vary (via the abstract members).
  Component buildItem(String groupId, ToggleGroupItemProps item) {
    final bool isSelected = props.type == ToggleGroupSelectionType.single
        ? props.value == item.value
        : (props.values?.contains(item.value) ?? false);
    final bool isDisabled = props.disabled || item.disabled;

    final ArcaneInteraction action =
        props.type == ToggleGroupSelectionType.single
        ? ArcaneInteraction.selectValue(groupId, item.value)
        : ArcaneInteraction.toggleValue(groupId, item.value);

    final Map<String, String> attrs = <String, String>{
      ...groupItemAttrs(
        groupId: groupId,
        value: item.value,
        selected: isSelected,
        disabled: isDisabled,
      ),
      ...interactionAttrs(action),
      'type': 'button',
      'aria-pressed': '$isSelected',
      ...extraItemAttrs(isSelected, isDisabled),
      if (isDisabled) 'disabled': 'true',
    };

    return dom.button(
      classes:
          '$itemBaseClass ${isSelected ? 'selected' : ''} ${isDisabled ? 'disabled' : ''}',
      attributes: attrs,
      styles: dom.Styles(
        raw: <String, String>{
          ...itemStyles(isSelected, isDisabled),
          ...itemPositionStyles(props.items.indexOf(item), props.items.length),
        },
      ),
      events: isDisabled
          ? null
          : <String, EventCallback>{
              'click': (_) {
                if (props.type == ToggleGroupSelectionType.single) {
                  props.onChanged?.call(isSelected ? null : item.value);
                  return;
                }
                final Set<String> next = Set<String>.from(
                  props.values ?? <String>{},
                );
                if (isSelected) {
                  next.remove(item.value);
                } else {
                  next.add(item.value);
                }
                props.onMultiChanged?.call(next);
              },
            },
      <Component>[item.child],
    );
  }
}
