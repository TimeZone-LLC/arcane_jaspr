import 'package:arcane_jaspr/component/view/icon.dart';
import 'package:arcane_jaspr/core/dom_value.dart';
import 'package:arcane_jaspr/core/interaction/interaction.dart';
import 'package:arcane_jaspr/core/interaction/interaction_attrs.dart';
import 'package:arcane_jaspr/core/props/native_select_props.dart';
import 'package:arcane_jaspr/core/props/select_props.dart';
import 'package:arcane_jaspr/core/rendering/field_identity.dart';
import 'package:arcane_jaspr/core/rendering/base/style_layering.dart';
import 'package:arcane_jaspr_neubrutalism/src/renderers/select.dart';
import 'package:arcane_jaspr_neubrutalism/src/renderers/decoration_styles.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart';

/// A themed listbox with a hidden native control for browser form semantics.
class NeubrutalismNativeSelect extends StatefulComponent {
  final NativeSelectProps props;

  const NeubrutalismNativeSelect(this.props, {super.key});

  @override
  State<NeubrutalismNativeSelect> createState() =>
      _NeubrutalismNativeSelectState();
}

class _NeubrutalismNativeSelectState extends State<NeubrutalismNativeSelect> {
  late String _value = _initialValue(component.props);
  late final String _defaultValue = _value;

  String _initialValue(NativeSelectProps props) {
    if (props.value != null) return props.value!;
    if (props.placeholder != null) return '';
    return props.options
            .where((NativeSelectOptionProps option) => !option.disabled)
            .firstOrNull
            ?.value ??
        '';
  }

  @override
  void didUpdateComponent(NeubrutalismNativeSelect oldComponent) {
    super.didUpdateComponent(oldComponent);
    if (oldComponent.props.value != component.props.value ||
        !component.props.options.any(
          (NativeSelectOptionProps option) => option.value == _value,
        )) {
      _value = _initialValue(component.props);
    }
  }

  void _select(Object? event, {bool notify = true}) {
    final String value = domEventTargetAttribute(
      event,
      'data-arcane-group-value',
    );
    setState(() => _value = value);
    if (notify) component.props.onChange?.call(value);
  }

  Map<String, String>? _explicitStyles(Map<String, String>? styles) =>
      styles?.map(
        (String property, String value) => MapEntry<String, String>(
          property,
          value.contains('!important') ? value : '$value !important',
        ),
      );

  @override
  Component build(BuildContext context) =>
      FieldIdentity(id: component.props.id, builder: _buildField);

  Component _buildField(String fieldId) {
    final NativeSelectProps props = component.props;
    final String surfaceId = '$fieldId-listbox';
    final String groupId = '$fieldId-group';
    final bool hasError = props.error != null;
    final NativeSelectOptionProps? selected = props.options
        .where((NativeSelectOptionProps option) => option.value == _value)
        .firstOrNull;
    final String display = selected?.label ?? props.placeholder ?? 'Select...';
    final NeubrutalismSelect<String> theme = NeubrutalismSelect<String>(
      SelectProps<String>(
        options: const <SelectOptionProps<String>>[],
        disabled: props.disabled,
      ),
    );
    final (
      String height,
      String padding,
      String fontSize,
    ) = switch (props.size) {
      ComponentSize.sm => ('36px', '0 12px', '0.875rem'),
      ComponentSize.md => ('40px', '0 14px', '1rem'),
      ComponentSize.lg => ('44px', '0 16px', '1rem'),
    };
    return dom.div(
      classes: 'neubrutalism-select neubrutalism-form-select',
      attributes: <String, String>{
        'data-size': props.size.name,
        'data-disabled': '${props.disabled}',
        'data-full-width': '${props.fullWidth}',
      },
      styles: dom.Styles(
        raw: <String, String>{
          'position': 'relative',
          'min-width': '0',
          'max-width': '100%',
          'width': props.fullWidth ? '100%' : 'fit-content',
        },
      ),
      <Component>[
        if (props.label != null)
          dom.label(
            htmlFor: fieldId,
            classes: 'neubrutalism-select-label',
            <Component>[
              Component.text(props.label!),
              if (props.required)
                const dom.span(
                  attributes: <String, String>{'aria-hidden': 'true'},
                  <Component>[Component.text(' *')],
                ),
            ],
          ),
        dom.button(
          id: fieldId,
          type: dom.ButtonType.button,
          classes: 'neubrutalism-select-trigger arcane-select',
          attributes: <String, String>{
            'role': 'combobox',
            'aria-haspopup': 'listbox',
            'aria-controls': surfaceId,
            'aria-expanded': 'false',
            'aria-required': '${props.required}',
            'data-arcane-field-control': 'true',
            'data-size': props.size.name,
            'data-disabled': '${props.disabled}',
            if (props.disabled) 'disabled': 'true',
            if (hasError) 'aria-invalid': 'true',
            if (hasError) 'aria-describedby': '$fieldId-error',
            ...anchorAttrs(fieldId),
            if (!props.disabled)
              ...interactionAttrs(ArcaneInteraction.togglePopover(surfaceId)),
          },
          styles: dom.Styles(
            raw: layerStyles(
              <String, String>{
                ...theme.triggerStyles(
                  height,
                  padding,
                  fontSize,
                  selected == null
                      ? 'var(--muted-foreground)'
                      : 'var(--foreground)',
                  hasError ? 'var(--destructive)' : theme.controlBorderColor,
                ),
                'gap': '0.75rem',
                'min-width': '0',
              },
              <Map<String, String>?>[
                _explicitStyles(props.decoration?.universalStyles()),
                _explicitStyles(neubrutalismDecorationStyles(props.decoration)),
                _explicitStyles(props.styles?.toMap()),
              ],
            ),
          ),
          <Component>[
            dom.span(
              attributes: const <String, String>{
                'data-arcane-select-label': '',
              },
              styles: const dom.Styles(
                raw: <String, String>{
                  'min-width': '0',
                  'overflow': 'hidden',
                  'text-overflow': 'ellipsis',
                  'white-space': 'nowrap',
                },
              ),
              <Component>[Component.text(display)],
            ),
            dom.span(
              attributes: const <String, String>{'aria-hidden': 'true'},
              classes: 'neubrutalism-select-chevron',
              <Component>[ArcaneIcon.chevronDown(size: IconSize.sm)],
            ),
          ],
        ),
        Component.element(
          tag: 'select',
          attributes: <String, String>{
            'hidden': '',
            'aria-hidden': 'true',
            'tabindex': '-1',
            'data-arcane-select-backing': fieldId,
            'data-arcane-select-default': _defaultValue,
            'data-arcane-select-has-error': '$hasError',
            'data-arcane-group': groupId,
            'name': ?props.name,
            if (props.required) 'required': 'true',
            if (props.disabled) 'disabled': 'true',
          },
          children: <Component>[
            if (props.placeholder != null || selected == null)
              Component.element(
                tag: 'option',
                attributes: <String, String>{
                  'value': '',
                  'disabled': 'true',
                  if (selected == null) 'selected': 'true',
                },
                children: <Component>[Component.text(props.placeholder ?? '')],
              ),
            for (final NativeSelectOptionProps option in props.options)
              Component.element(
                tag: 'option',
                attributes: <String, String>{
                  'value': option.value,
                  if (option.disabled) 'disabled': 'true',
                  if (option.value == _value) 'selected': 'true',
                },
                children: <Component>[Component.text(option.label)],
              ),
          ],
        ),
        dom.div(
          id: surfaceId,
          classes: 'neubrutalism-select-dropdown neubrutalism-select-content',
          attributes: <String, String>{
            'role': 'listbox',
            'aria-label': props.label ?? props.placeholder ?? 'Options',
            'data-arcane-select-trigger': fieldId,
            'data-arcane-select-placeholder': props.placeholder ?? 'Select...',
            ...surfaceAttrs(
              surface: 'popover',
              id: surfaceId,
              focusTrap: false,
              anchorId: fieldId,
              anchorPlacement: 'bottom',
              anchorAlign: 'start',
              anchorOffset: '8',
            ),
            ...groupAttrs(
              groupId: groupId,
              mode: 'single',
              value: _value,
              required: props.required,
              disabled: props.disabled,
            ),
          },
          styles: dom.Styles(
            raw: <String, String>{
              ...theme.dropdownStyles('320px'),
              'width': '100%',
              'min-width': 'min(12rem, calc(100vw - 16px))',
              'max-width': 'calc(100vw - 16px)',
              'padding': '0.375rem',
            },
          ),
          events: <String, void Function(dynamic)>{
            'arcane:change': _select,
            'arcane:reset': (Object? event) => _select(event, notify: false),
          },
          <Component>[
            for (final NativeSelectOptionProps option in props.options)
              dom.button(
                type: dom.ButtonType.button,
                classes: 'neubrutalism-select-option',
                attributes: <String, String>{
                  'role': 'option',
                  'aria-selected': '${option.value == _value}',
                  'aria-disabled': '${option.disabled}',
                  'data-disabled': '${option.disabled}',
                  'tabindex': '-1',
                  'data-label': option.label,
                  if (option.disabled) 'disabled': 'true',
                  if (option.value == _value && !option.disabled)
                    'data-arcane-autofocus': 'true',
                  ...groupItemAttrs(
                    groupId: groupId,
                    value: option.value,
                    selected: option.value == _value,
                    disabled: option.disabled,
                  ),
                  if (!option.disabled)
                    ...interactionAttrs(
                      ArcaneInteraction.compose(<ArcaneInteraction>[
                        ArcaneInteraction.selectValue(groupId, option.value),
                        ArcaneInteraction.closePopover(surfaceId),
                      ]),
                    ),
                },
                styles: dom.Styles(
                  raw: theme.optionStyles(
                    option.value == _value,
                    option.disabled,
                  ),
                ),
                <Component>[Component.text(option.label)],
              ),
            if (props.options.isEmpty)
              const dom.div(classes: 'neubrutalism-select-empty', <Component>[
                Component.text('No options available'),
              ]),
          ],
        ),
        dom.div(
          id: '$fieldId-error',
          classes: 'neubrutalism-select-error',
          attributes: <String, String>{if (!hasError) 'hidden': ''},
          <Component>[Component.text(props.error ?? '')],
        ),
      ],
    );
  }
}
