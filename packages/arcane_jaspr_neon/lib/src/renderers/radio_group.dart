import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart';

import 'package:arcane_jaspr/core/props/radio_group_props.dart';
import 'package:arcane_jaspr/core/rendering/base/radio_group_render_base.dart';

/// Native radio controls with standard, card, and button presentations.
class NeonRadioGroup<T> extends RadioGroupRenderBase<T> {
  const NeonRadioGroup(super.props, {super.key});

  String get _messageId =>
      '${props.id ?? props.name ?? '$groupIdPrefix${identityHashCode(this)}'}-message';

  @override
  String get groupIdPrefix => 'neon-radio-';

  @override
  String get rootClasses => 'neon-radio-group';

  @override
  Map<String, String> rootDataAttrs(String groupName) => <String, String>{
    'role': 'radiogroup',
    if (props.label != null) 'aria-labelledby': '$groupName-label',
    if (props.error != null || props.helperText != null)
      'aria-describedby': _messageId,
    if (props.error != null) 'aria-invalid': 'true',
    if (props.required) 'aria-required': 'true',
    'data-disabled': '${props.disabled}',
    'data-layout': props.layout.name,
    'data-variant': props.variant.name,
  };

  @override
  Map<String, String> get rootStyles => const <String, String>{};

  @override
  Component buildLabel(String groupName) => dom.div(
    id: '$groupName-label',
    classes: 'neon-radio-group-label',
    <Component>[Component.text(props.label!)],
  );

  @override
  String get optionsClasses => 'neon-radio-group-options';

  @override
  Map<String, String> get optionsStyles => <String, String>{
    'display': props.layout == RadioGroupLayout.grid ? 'grid' : 'flex',
    'flex-direction': props.layout == RadioGroupLayout.horizontal
        ? 'row'
        : 'column',
    'flex-wrap': 'wrap',
    'gap': props.gap,
    if (props.layout == RadioGroupLayout.grid)
      'grid-template-columns': 'repeat(${props.gridColumns}, minmax(0, 1fr))',
  };

  @override
  List<Component> buildMessage() {
    final String? message = props.error ?? props.helperText;
    return <Component>[
      if (message != null)
        dom.div(
          id: _messageId,
          classes: props.error != null
              ? 'neon-radio-group-error'
              : 'neon-radio-group-helper',
          <Component>[Component.text(message)],
        ),
    ];
  }

  @override
  Component buildStandardRadio(
    RadioOptionProps<T> option,
    String groupName,
    bool isSelected,
    bool isDisabled,
    bool hasError,
    Map<String, String> itemAttrs,
  ) => _buildOption(
    option,
    groupName,
    isSelected,
    isDisabled,
    hasError,
    itemAttrs,
    'neon-radio-option',
  );

  @override
  Component buildCardRadio(
    RadioOptionProps<T> option,
    String groupName,
    bool isSelected,
    bool isDisabled,
    bool hasError,
    Map<String, String> itemAttrs,
  ) => _buildOption(
    option,
    groupName,
    isSelected,
    isDisabled,
    hasError,
    itemAttrs,
    'neon-radio-card',
  );

  @override
  Component buildButtonRadio(
    RadioOptionProps<T> option,
    String groupName,
    bool isSelected,
    bool isDisabled,
    bool hasError,
    Map<String, String> itemAttrs,
  ) => _buildOption(
    option,
    groupName,
    isSelected,
    isDisabled,
    hasError,
    itemAttrs,
    'neon-radio-button',
  );

  Component _buildOption(
    RadioOptionProps<T> option,
    String groupName,
    bool isSelected,
    bool isDisabled,
    bool hasError,
    Map<String, String> itemAttrs,
    String className,
  ) {
    final String optionId =
        option.id ?? '$groupName-option-${props.options.indexOf(option)}';
    return dom.label(
      classes: className,
      attributes: <String, String>{'data-disabled': '$isDisabled'},
      <Component>[
        dom.input(
          id: optionId,
          type: dom.InputType.radio,
          name: groupName,
          value: option.value.toString(),
          checked: isSelected,
          disabled: isDisabled,
          classes: 'neon-radio-input',
          attributes: <String, String>{
            // Native change events update the group once, including arrow keys.
            for (final MapEntry<String, String> attribute in itemAttrs.entries)
              if (attribute.key != 'data-arcane-action')
                attribute.key: attribute.value,
            'aria-labelledby': '$optionId-label',
            if (option.description != null ||
                props.error != null ||
                props.helperText != null)
              'aria-describedby': <String>[
                if (option.description != null) '$optionId-description',
                if (props.error != null || props.helperText != null) _messageId,
              ].join(' '),
            if (props.required) 'required': '',
            if (hasError) 'aria-invalid': 'true',
          },
          events: <String, EventCallback>{
            if (!isDisabled && props.onChanged != null)
              'change': (_) => props.onChanged!(option.value),
          },
        ),
        const dom.span(
          classes: 'neon-radio-circle',
          attributes: <String, String>{
            'aria-hidden': 'true',
            'data-arcane-intrinsic-shape': 'radio',
          },
          <Component>[],
        ),
        if (option.icon != null) option.icon!,
        dom.span(classes: 'neon-radio-content', <Component>[
          dom.span(
            id: '$optionId-label',
            classes: 'neon-radio-label',
            <Component>[Component.text(option.label)],
          ),
          if (option.description != null)
            dom.span(
              id: '$optionId-description',
              classes: 'neon-radio-description',
              <Component>[Component.text(option.description!)],
            ),
        ]),
      ],
    );
  }
}
