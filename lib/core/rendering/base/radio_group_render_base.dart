import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/rendering/base/style_layering.dart';
import 'package:arcane_jaspr/core/interaction/interaction.dart';
import 'package:arcane_jaspr/core/interaction/interaction_attrs.dart';
import 'package:arcane_jaspr/core/props/radio_group_props.dart';

/// Shared structural base for themed radio-group renderers.
///
/// Radio groups diverge substantially per theme: ShadCN, Neon and Windows95
/// use native radio inputs, while Neubrutalism attaches click handlers to
/// option containers. This base therefore factors only the parts
/// that are genuinely identical and error-prone — the group/item interaction
/// attribute wiring, the root container scaffold and the per-option variant
/// dispatch — and leaves the visual nodes (root classes/attrs/styles, the
/// label, the options container styling, the helper/error message and the four
/// variant bodies) to abstract members the subclass supplies.
///
/// This base lives in core and depends only on core props and interaction
/// helpers; it must never depend on a theme package.
abstract class RadioGroupRenderBase<T> extends StatelessComponent {
  const RadioGroupRenderBase(this.props, {super.key});

  final RadioGroupProps<T> props;

  /// Prefix used to derive a fallback group id when neither [RadioGroupProps.id]
  /// nor [RadioGroupProps.name] is provided (e.g. `'radio_'`, `'neon-radio-'`).
  String get groupIdPrefix;

  /// Classes for the root group element.
  String get rootClasses;

  /// Theme-specific data/aria attributes merged before the group root attrs.
  /// [groupName] is the resolved group name (used by themes that wire
  /// `aria-labelledby`).
  Map<String, String> rootDataAttrs(String groupName);

  /// Inline styles for the root group element.
  Map<String, String> get rootStyles;

  /// Per-instance decoration overrides. Default: none. A theme overrides this
  /// to translate an [ArcaneDecoration] (elevation intent, theme-specific
  /// fields) into its own CSS. Fields a theme does not implement are ignored.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  /// Builds the group label node (some themes use a `<label>`, others a `<div>`).
  /// Only called when [RadioGroupProps.label] is non-null. [groupName] is used
  /// by themes that set the label id for `aria-labelledby`.
  Component buildLabel(String groupName);

  /// Classes for the options container element.
  String get optionsClasses;

  /// Inline styles for the options container element.
  Map<String, String> get optionsStyles;

  /// Builds the trailing error/helper message (0 or 1 component).
  List<Component> buildMessage();

  /// Builds the `standard` variant option.
  Component buildStandardRadio(
    RadioOptionProps<T> option,
    String groupName,
    bool isSelected,
    bool isDisabled,
    bool hasError,
    Map<String, String> itemAttrs,
  );

  /// Builds the `cards` variant option.
  Component buildCardRadio(
    RadioOptionProps<T> option,
    String groupName,
    bool isSelected,
    bool isDisabled,
    bool hasError,
    Map<String, String> itemAttrs,
  );

  /// Builds the `buttons` variant option.
  Component buildButtonRadio(
    RadioOptionProps<T> option,
    String groupName,
    bool isSelected,
    bool isDisabled,
    bool hasError,
    Map<String, String> itemAttrs,
  );

  /// Resolves item interaction attributes and dispatches to the variant body.
  Component buildOption(
    RadioOptionProps<T> option,
    String groupName,
    String groupId,
    bool hasError,
  ) {
    final bool isSelected = props.value == option.value;
    final bool isDisabled = props.disabled || option.disabled;
    final String itemValue = option.value.toString();
    final Map<String, String> itemAttrs = mergeAttrs(<Map<String, String>>[
      groupItemAttrs(
        groupId: groupId,
        value: itemValue,
        selected: isSelected,
        disabled: isDisabled,
      ),
      if (!isDisabled)
        interactionAttrs(ArcaneInteraction.selectValue(groupId, itemValue)),
    ]);

    return switch (props.variant) {
      RadioGroupVariant.standard => buildStandardRadio(
        option,
        groupName,
        isSelected,
        isDisabled,
        hasError,
        itemAttrs,
      ),
      RadioGroupVariant.cards => buildCardRadio(
        option,
        groupName,
        isSelected,
        isDisabled,
        hasError,
        itemAttrs,
      ),
      RadioGroupVariant.buttons => buildButtonRadio(
        option,
        groupName,
        isSelected,
        isDisabled,
        hasError,
        itemAttrs,
      ),
    };
  }

  @override
  Component build(BuildContext context) {
    final bool hasError = props.error != null;
    final String groupName =
        props.name ?? props.id ?? '$groupIdPrefix${identityHashCode(this)}';
    final String groupId = props.id ?? groupName;
    final String? currentGroupValue = props.value?.toString();

    final Map<String, String> rootAttrs = groupAttrs(
      groupId: groupId,
      mode: 'single',
      value: currentGroupValue ?? '',
      required: props.required,
      disabled: props.disabled,
      changeAction: props.onChangeAction != null
          ? encodeArcaneAction(props.onChangeAction!)
          : null,
    );

    return dom.div(
      classes: rootClasses,
      attributes: mergeAttrs(<Map<String, String>>[
        rootDataAttrs(groupName),
        rootAttrs,
      ]),
      styles: dom.Styles(
        raw: layerStyles(
          <String, String>{...rootStyles},
          <Map<String, String>?>[
            props.decoration?.universalStyles(),
            decorationStyles(props.decoration),
            props.styles?.toMap(),
          ],
        ),
      ),
      <Component>[
        if (props.label != null) buildLabel(groupName),
        dom.div(
          classes: optionsClasses,
          styles: dom.Styles(raw: optionsStyles),
          <Component>[
            for (final RadioOptionProps<T> option in props.options)
              buildOption(option, groupName, groupId, hasError),
          ],
        ),
        ...buildMessage(),
      ],
    );
  }
}
