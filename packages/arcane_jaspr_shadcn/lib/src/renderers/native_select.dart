import 'package:jaspr/jaspr.dart';

import 'package:arcane_jaspr/component/input/text_input.dart';
import 'package:arcane_jaspr/core/props/native_select_props.dart';
import 'package:arcane_jaspr/core/rendering/base/native_select_render_base.dart';
import 'package:arcane_jaspr/util/style_types/arcane_style_data.dart';
import 'package:arcane_jaspr/util/style_types/borders.dart';

/// ShadCN v4 native select: the shared [ArcaneSelect] control restyled to the
/// input recipe (`h-9 rounded-md border-input bg-transparent text-sm`).
///
/// The recipe is passed as the base literal style so per-instance `styles`
/// still win. The resting `shadow-xs` and the focus ring come from the theme
/// CSS because [ArcaneStyleData] has no free-form shadow field.
class ShadcnNativeSelect extends NativeSelectRenderBase {
  const ShadcnNativeSelect(super.props, {super.key});

  String get _height => switch (props.size) {
    ComponentSize.sm => '2rem',
    ComponentSize.md => '2.25rem',
    ComponentSize.lg => '2.5rem',
  };

  ArcaneStyleData get _recipe => ArcaneStyleData(
    heightCustom: _height,
    paddingStringCustom: '0.25rem 0.75rem',
    fontSizeCustom: '0.875rem',
    backgroundCustom: 'var(--shadcn-input-background, transparent)',
    borderCustom: props.error != null
        ? '1px solid var(--shadcn-control-border-color, var(--destructive))'
        : '1px solid var(--shadcn-control-border-color, var(--shadcn-control-border))',
    borderRadius: Radius.md,
  );

  @override
  Component build(BuildContext context) {
    return ArcaneSelect(
      options: props.options
          .map(
            (NativeSelectOptionProps option) => ArcaneSelectOption(
              label: option.label,
              value: option.value,
              disabled: option.disabled,
            ),
          )
          .toList(),
      value: props.value,
      placeholder: props.placeholder,
      size: props.size,
      disabled: props.disabled,
      required: props.required,
      name: props.name,
      id: props.id,
      label: props.label,
      error: props.error,
      fullWidth: props.fullWidth,
      onChanged: props.onChange,
      styles: _recipe.merge(props.styles),
      decoration: props.decoration,
    );
  }
}
