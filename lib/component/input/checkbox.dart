import 'package:arcane_jaspr/flutter.dart';
import 'package:jaspr/jaspr.dart'
    hide
        BuildContext,
        InheritedComponent,
        Key,
        State,
        StatefulComponent,
        StatelessComponent,
        UniqueKey,
        ValueKey,
        runApp;
import 'package:jaspr/dom.dart' as dom;

export '../../core/props/checkbox_props.dart' show ComponentSize, ColorVariant;

import '../../core/decoration/arcane_decoration.dart';
import '../../core/theme_provider.dart';
import '../../util/style_types/arcane_style_data.dart';

/// Checkbox input component.
class ArcaneCheckbox extends StatelessWidget {
  final String? id;
  final bool checked;
  final String? label;
  final String? description;
  final ComponentSize size;
  final ColorVariant color;
  final bool disabled;
  final String? group;
  final String? value;
  final void Function(bool)? onChanged;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation + theme-specific fields).
  final ArcaneDecoration? decoration;

  const ArcaneCheckbox({
    this.id,
    required this.checked,
    this.label,
    this.description,
    this.size = ComponentSize.md,
    this.color = ColorVariant.primary,
    this.disabled = false,
    this.group,
    this.value,
    this.onChanged,
    this.styles,
    this.decoration,
    super.key,
  });

  const ArcaneCheckbox.primary({
    this.id,
    required this.checked,
    this.label,
    this.description,
    this.size = ComponentSize.md,
    this.disabled = false,
    this.group,
    this.value,
    this.onChanged,
    this.styles,
    this.decoration,
    super.key,
  }) : color = ColorVariant.primary;

  const ArcaneCheckbox.success({
    this.id,
    required this.checked,
    this.label,
    this.description,
    this.size = ComponentSize.md,
    this.disabled = false,
    this.group,
    this.value,
    this.onChanged,
    this.styles,
    this.decoration,
    super.key,
  }) : color = ColorVariant.success;

  const ArcaneCheckbox.warning({
    this.id,
    required this.checked,
    this.label,
    this.description,
    this.size = ComponentSize.md,
    this.disabled = false,
    this.group,
    this.value,
    this.onChanged,
    this.styles,
    this.decoration,
    super.key,
  }) : color = ColorVariant.warning;

  const ArcaneCheckbox.destructive({
    this.id,
    required this.checked,
    this.label,
    this.description,
    this.size = ComponentSize.md,
    this.disabled = false,
    this.group,
    this.value,
    this.onChanged,
    this.styles,
    this.decoration,
    super.key,
  }) : color = ColorVariant.destructive;

  static int _autoCounter = 0;
  static String _autoId() {
    _autoCounter++;
    return 'arcane-checkbox-$_autoCounter';
  }

  @override
  Widget build(BuildContext context) {
    final String resolvedId = id ?? _autoId();
    return context.renderers.checkbox(
      CheckboxProps(
        id: resolvedId,
        checked: checked,
        label: label,
        description: description,
        size: size,
        color: color,
        disabled: disabled,
        onChanged: onChanged,
        group: group,
        value: value,
        styles: styles,
        decoration: decoration,
      ),
    );
  }
}

/// Radio button component.
class ArcaneRadio extends StatelessWidget {
  final bool selected;
  final String? label;
  final String? description;
  final ComponentSize size;
  final ColorVariant color;
  final bool disabled;
  final void Function()? _onSelected;

  const ArcaneRadio({
    required this.selected,
    this.label,
    this.description,
    this.size = ComponentSize.md,
    this.color = ColorVariant.primary,
    this.disabled = false,
    void Function()? onSelected,
    void Function()? onTap,
    super.key,
  }) : _onSelected = onSelected ?? onTap;

  @override
  Widget build(BuildContext context) {
    final radioSize = switch (size) {
      ComponentSize.sm => '14px',
      ComponentSize.md => '16px',
      ComponentSize.lg => '20px',
    };

    final dotSize = switch (size) {
      ComponentSize.sm => '8px',
      ComponentSize.md => '10px',
      ComponentSize.lg => '12px',
    };

    final (borderColor, dotColor) = switch (color) {
      ColorVariant.primary => ('var(--primary)', 'var(--primary)'),
      ColorVariant.secondary => ('var(--secondary)', 'var(--secondary)'),
      ColorVariant.success => ('var(--success)', 'var(--success)'),
      ColorVariant.warning => ('var(--warning)', 'var(--warning)'),
      ColorVariant.destructive => ('var(--destructive)', 'var(--destructive)'),
      ColorVariant.info => ('var(--info)', 'var(--info)'),
    };

    return dom.div(
      classes: 'arcane-radio-wrapper',
      styles: dom.Styles(
        raw: {
          'display': 'flex',
          'align-items': 'flex-start',
          'gap': '0.5rem',
          'cursor': disabled ? 'not-allowed' : 'pointer',
          'opacity': disabled ? '0.5' : '1',
          'pointer-events': disabled ? 'none' : 'auto',
        },
      ),
      events: disabled || _onSelected == null
          ? null
          : {'click': (event) => _onSelected()},
      [
        dom.div(
          classes: 'arcane-radio',
          attributes: const <String, String>{
            'data-arcane-intrinsic-shape': 'radio',
          },
          styles: dom.Styles(
            raw: {
              'width': radioSize,
              'height': radioSize,
              'border-radius': '50%',
              'background': 'transparent',
              'border': '1px solid $borderColor',
              'display': 'flex',
              'align-items': 'center',
              'justify-content': 'center',
              'flex-shrink': '0',
              'transition':
                  'color 150ms ease, background-color 150ms ease, border-color 150ms ease',
            },
          ),
          [
            if (selected)
              dom.div(
                attributes: const <String, String>{
                  'data-arcane-intrinsic-shape': 'radio-dot',
                },
                styles: dom.Styles(
                  raw: {
                    'width': dotSize,
                    'height': dotSize,
                    'border-radius': '50%',
                    'background': dotColor,
                  },
                ),
                [],
              ),
          ],
        ),
        if (label != null || description != null)
          dom.div(styles: const dom.Styles(raw: {'flex': '1'}), [
            if (label != null)
              dom.span(
                styles: const dom.Styles(
                  raw: {
                    'font-size': '14px',
                    'font-weight': '500',
                    'color': 'var(--foreground)',
                    'display': 'block',
                    'line-height': '1',
                  },
                ),
                [Component.text(label!)],
              ),
            if (description != null)
              dom.span(
                styles: const dom.Styles(
                  raw: {
                    'font-size': '14px',
                    'color': 'var(--muted-foreground)',
                    'display': 'block',
                    'margin-top': '4px',
                  },
                ),
                [Component.text(description!)],
              ),
          ]),
      ],
    );
  }
}
