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

export '../../core/props/toggle_switch_props.dart'
    show ComponentSize, ColorVariant;

import '../../core/decoration/arcane_decoration.dart';
import '../../core/theme_provider.dart';
import '../../util/style_types/arcane_style_data.dart';

/// A toggle switch component.
class ArcaneToggleSwitch extends StatelessWidget {
  final String? id;
  final bool value;
  final void Function(bool)? onChanged;
  final bool disabled;
  final ComponentSize size;
  final ColorVariant color;
  final String? label;
  final bool labelLeft;
  final String? group;
  final String? itemValue;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation intent + theme-specific
  /// fields honored-or-ignored per theme).
  final ArcaneDecoration? decoration;

  const ArcaneToggleSwitch({
    this.id,
    required this.value,
    this.onChanged,
    this.disabled = false,
    this.size = ComponentSize.md,
    this.color = ColorVariant.primary,
    this.label,
    this.labelLeft = false,
    this.group,
    this.itemValue,
    this.styles,
    this.decoration,
    super.key,
  });

  const ArcaneToggleSwitch.primary({
    this.id,
    required this.value,
    this.onChanged,
    this.disabled = false,
    this.size = ComponentSize.md,
    this.label,
    this.labelLeft = false,
    this.group,
    this.itemValue,
    this.styles,
    this.decoration,
    super.key,
  }) : color = ColorVariant.primary;

  const ArcaneToggleSwitch.success({
    this.id,
    required this.value,
    this.onChanged,
    this.disabled = false,
    this.size = ComponentSize.md,
    this.label,
    this.labelLeft = false,
    this.group,
    this.itemValue,
    this.styles,
    this.decoration,
    super.key,
  }) : color = ColorVariant.success;

  const ArcaneToggleSwitch.warning({
    this.id,
    required this.value,
    this.onChanged,
    this.disabled = false,
    this.size = ComponentSize.md,
    this.label,
    this.labelLeft = false,
    this.group,
    this.itemValue,
    this.styles,
    this.decoration,
    super.key,
  }) : color = ColorVariant.warning;

  const ArcaneToggleSwitch.destructive({
    this.id,
    required this.value,
    this.onChanged,
    this.disabled = false,
    this.size = ComponentSize.md,
    this.label,
    this.labelLeft = false,
    this.group,
    this.itemValue,
    this.styles,
    this.decoration,
    super.key,
  }) : color = ColorVariant.destructive;

  static int _autoCounter = 0;
  static String _autoId() {
    _autoCounter++;
    return 'arcane-toggle-switch-$_autoCounter';
  }

  @override
  Widget build(BuildContext context) {
    final String resolvedId = id ?? _autoId();
    return context.renderers.toggleSwitch(
      ToggleSwitchProps(
        id: resolvedId,
        value: value,
        onChanged: onChanged,
        disabled: disabled,
        size: size,
        color: color,
        label: label,
        labelLeft: labelLeft,
        group: group,
        itemValue: itemValue,
        styles: styles,
        decoration: decoration,
      ),
    );
  }
}

/// A toggle button group for switching between options.
class ArcaneToggleButtonGroup extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final void Function(int)? onChanged;
  final ComponentSize size;

  const ArcaneToggleButtonGroup({
    required this.options,
    required this.selectedIndex,
    this.onChanged,
    this.size = ComponentSize.md,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final (height, paddingH, paddingV, fontSize) = switch (size) {
      ComponentSize.sm => ('36px', '10px', '6px', '14px'),
      ComponentSize.md => ('40px', '12px', '6px', '14px'),
      ComponentSize.lg => ('44px', '20px', '8px', '14px'),
    };

    return dom.div(
      classes: 'arcane-toggle-button-group',
      styles: dom.Styles(
        raw: {
          'display': 'inline-flex',
          'align-items': 'center',
          'justify-content': 'center',
          'height': height,
          'padding': '4px',
          'background-color': 'var(--muted)',
          'border-radius': '0.375rem',
          'gap': '0',
        },
      ),
      [
        for (var i = 0; i < options.length; i++)
          dom.button(
            classes:
                'arcane-toggle-button ${i == selectedIndex ? 'active' : ''}',
            attributes: {'type': 'button'},
            styles: dom.Styles(
              raw: {
                'padding': '$paddingV $paddingH',
                'font-size': fontSize,
                'font-weight': '500',
                'border': 'none',
                'border-radius': '0.125rem',
                'background-color': i == selectedIndex
                    ? 'var(--background)'
                    : 'transparent',
                'color': i == selectedIndex
                    ? 'var(--foreground)'
                    : 'var(--muted-foreground)',
                'cursor': 'pointer',
                'transition': 'all 150ms ease',
                'white-space': 'nowrap',
                if (i == selectedIndex)
                  'box-shadow': '0 1px 2px 0 rgb(0 0 0 / 0.05)',
              },
            ),
            events: {
              'click': (event) {
                if (onChanged != null && i != selectedIndex) {
                  onChanged!(i);
                }
              },
            },
            [Component.text(options[i])],
          ),
      ],
    );
  }
}
