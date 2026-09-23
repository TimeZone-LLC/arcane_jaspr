import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/interaction/interaction.dart';
import 'package:arcane_jaspr/core/interaction/interaction_attrs.dart';
import 'package:arcane_jaspr/core/props/checkbox_props.dart';
import 'package:arcane_jaspr/core/dom_value.dart';

/// Shared structural base for themed checkbox renderers.
///
/// Checkboxes diverge more than buttons or cards: the box element and the
/// checkmark differ structurally per theme. This base therefore factors the
/// parts that are genuinely identical and error-prone — the group/item
/// interaction attribute wiring, the wrapper element and click event, and the
/// label/description block scaffold — while leaving the visual box and the
/// theme-specific style values to abstract members the subclass supplies.
///
/// This base lives in core and depends only on core props and interaction
/// helpers; it must never depend on a theme package.
abstract class CheckboxRenderBase extends StatelessComponent {
  const CheckboxRenderBase(this.props, {super.key});

  final CheckboxProps props;

  /// Classes for the wrapper element (some themes append a disabled marker).
  String wrapperClasses(CheckboxProps props);

  /// Inline styles for the wrapper element.
  Map<String, String> wrapperStyles(CheckboxProps props);

  /// Extra wrapper attributes merged after `data-state`/`data-disabled`
  /// (e.g. `data-variant`/`data-size`); return an empty map for none.
  Map<String, String> extraWrapperAttrs(CheckboxProps props);

  /// Builds the visual checkbox box (and its checkmark). [itemAttrs] are the
  /// resolved group-item/interaction attributes that must be placed on the box.
  Component buildBox(CheckboxProps props, Map<String, String> itemAttrs);

  /// Inline styles for the label text span.
  Map<String, String> labelTextStyles(CheckboxProps props);

  /// Inline styles for the description text span.
  Map<String, String> descriptionTextStyles(CheckboxProps props);

  @override
  Component build(BuildContext context) {
    final bool inExternalGroup =
        props.group != null && props.group!.isNotEmpty && props.value != null;
    final String groupId = inExternalGroup ? props.group! : props.id;
    final String itemValue = inExternalGroup ? props.value! : 'on';
    final String currentGroupValue = props.checked ? itemValue : '';

    final Map<String, String> rootAttrs = inExternalGroup
        ? const <String, String>{}
        : groupAttrs(
            groupId: groupId,
            mode: 'multi',
            value: currentGroupValue,
            disabled: props.disabled,
          );

    final Map<String, String> itemAttrs = mergeAttrs(<Map<String, String>>[
      groupItemAttrs(
        groupId: groupId,
        value: itemValue,
        selected: props.checked,
        disabled: props.disabled,
      ),
      <String, String>{
        'role': 'checkbox',
        'aria-checked': '${props.checked}',
        'aria-disabled': '${props.disabled}',
        if (props.label != null) 'aria-labelledby': '${props.id}-label',
        if (props.description != null)
          'aria-describedby': '${props.id}-description',
        'tabindex': props.disabled ? '-1' : '0',
        'data-state': props.checked ? 'checked' : 'unchecked',
        'data-disabled': '${props.disabled}',
      },
      if (!props.disabled)
        interactionAttrs(ArcaneInteraction.toggleValue(groupId, itemValue)),
    ]);

    final Map<String, String> wrapperAttrs = mergeAttrs(<Map<String, String>>[
      rootAttrs,
      if (!props.disabled)
        interactionAttrs(ArcaneInteraction.toggleValue(groupId, itemValue)),
      <String, String>{
        'data-state': props.checked ? 'checked' : 'unchecked',
        'data-disabled': '${props.disabled}',
        ...extraWrapperAttrs(props),
      },
    ]);

    return dom.div(
      classes: wrapperClasses(props),
      attributes: wrapperAttrs,
      styles: dom.Styles(raw: wrapperStyles(props)),
      events: props.disabled || props.onChanged == null
          ? null
          : <String, EventCallback>{
              'click': (event) {
                domPreventDefault(event);
                props.onChanged!(!props.checked);
              },
              'keydown': (event) {
                final String key = domEventKey(event);
                if (key == ' ' || key == 'Enter') {
                  domPreventDefault(event);
                  props.onChanged!(!props.checked);
                }
              },
            },
      <Component>[
        buildBox(props, itemAttrs),
        if (props.label != null || props.description != null)
          dom.div(
            styles: const dom.Styles(raw: <String, String>{'flex': '1'}),
            <Component>[
              if (props.label != null)
                dom.span(
                  id: '${props.id}-label',
                  styles: dom.Styles(raw: labelTextStyles(props)),
                  <Component>[Component.text(props.label!)],
                ),
              if (props.description != null)
                dom.span(
                  id: '${props.id}-description',
                  styles: dom.Styles(raw: descriptionTextStyles(props)),
                  <Component>[Component.text(props.description!)],
                ),
            ],
          ),
      ],
    );
  }
}
