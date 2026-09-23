import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart';

import 'package:arcane_jaspr/core/props/radio_group_props.dart';
import 'package:arcane_jaspr/core/rendering/base/radio_group_render_base.dart';

/// Native radio groups with standard, panel, and push-button appearances.
class Win95RadioGroup<T> extends RadioGroupRenderBase<T> {
  const Win95RadioGroup(super.props, {super.key});

  @override
  String get groupIdPrefix => 'win95-radio-';

  @override
  String get rootClasses => 'win95-radio-group';

  @override
  Map<String, String> rootDataAttrs(String groupName) => <String, String>{
    'role': 'radiogroup',
    'data-disabled': '${props.disabled}',
    'data-layout': props.layout.name,
    'data-variant': props.variant.name,
    'aria-disabled': '${props.disabled}',
    'aria-required': '${props.required}',
    'aria-invalid': '${props.error != null}',
    if (props.label != null) 'aria-labelledby': '$groupName-label',
  };

  @override
  Map<String, String> get rootStyles => const <String, String>{};

  @override
  Component buildLabel(String groupName) => dom.div(
    classes: 'win95-radio-group-label',
    attributes: <String, String>{'id': '$groupName-label'},
    <Component>[Component.text(props.label!)],
  );

  @override
  String get optionsClasses => 'win95-radio-group-options';

  @override
  Map<String, String> get optionsStyles => <String, String>{
    'gap': props.gap,
    if (props.layout == RadioGroupLayout.grid)
      'grid-template-columns':
          'repeat(${props.gridColumns > 0 ? props.gridColumns : 1}, minmax(0, 1fr))',
  };

  @override
  List<Component> buildMessage() => <Component>[
    if (props.error != null)
      dom.div(
        classes: 'win95-radio-group-error',
        attributes: const <String, String>{'role': 'alert'},
        <Component>[Component.text(props.error!)],
      )
    else if (props.helperText != null)
      dom.div(classes: 'win95-radio-group-helper', <Component>[
        Component.text(props.helperText!),
      ]),
  ];

  Component _buildRadio(
    RadioOptionProps<T> option,
    String groupName,
    bool isSelected,
    bool isDisabled,
    bool hasError,
    Map<String, String> itemAttrs,
    String classes,
  ) {
    final String optionId =
        option.id ?? '$groupName-${props.options.indexOf(option)}';
    return dom.label(
      classes: classes,
      attributes: <String, String>{
        'for': optionId,
        'data-disabled': '$isDisabled',
      },
      <Component>[
        dom.input(
          id: optionId,
          type: dom.InputType.radio,
          name: groupName,
          value: option.value.toString(),
          checked: isSelected,
          disabled: isDisabled,
          classes: 'win95-radio-control',
          attributes: <String, String>{
            ...itemAttrs,
            'aria-invalid': '$hasError',
            if (option.description != null)
              'aria-describedby': '$optionId-description',
            if (props.required) 'required': 'true',
          },
          events: isDisabled || props.onChanged == null
              ? null
              : <String, EventCallback>{
                  'change': (_) => props.onChanged!(option.value),
                },
        ),
        if (option.icon != null)
          dom.span(
            classes: 'win95-radio-icon',
            attributes: const <String, String>{'aria-hidden': 'true'},
            <Component>[option.icon!],
          ),
        dom.span(classes: 'win95-radio-caption', <Component>[
          dom.span(classes: 'win95-radio-label', <Component>[
            Component.text(option.label),
          ]),
          if (option.description != null)
            dom.span(
              classes: 'win95-radio-description',
              attributes: <String, String>{'id': '$optionId-description'},
              <Component>[Component.text(option.description!)],
            ),
        ]),
      ],
    );
  }

  @override
  Component buildStandardRadio(
    RadioOptionProps<T> option,
    String groupName,
    bool isSelected,
    bool isDisabled,
    bool hasError,
    Map<String, String> itemAttrs,
  ) => _buildRadio(
    option,
    groupName,
    isSelected,
    isDisabled,
    hasError,
    itemAttrs,
    'win95-radio-option',
  );

  @override
  Component buildCardRadio(
    RadioOptionProps<T> option,
    String groupName,
    bool isSelected,
    bool isDisabled,
    bool hasError,
    Map<String, String> itemAttrs,
  ) => _buildRadio(
    option,
    groupName,
    isSelected,
    isDisabled,
    hasError,
    itemAttrs,
    'win95-radio-card',
  );

  @override
  Component buildButtonRadio(
    RadioOptionProps<T> option,
    String groupName,
    bool isSelected,
    bool isDisabled,
    bool hasError,
    Map<String, String> itemAttrs,
  ) => _buildRadio(
    option,
    groupName,
    isSelected,
    isDisabled,
    hasError,
    itemAttrs,
    'win95-radio-button',
  );
}
