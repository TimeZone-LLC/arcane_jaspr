import 'package:arcane_jaspr/core/rendering/base/native_select_render_base.dart';
import 'package:arcane_jaspr/core/shared/shared.dart';
import 'package:arcane_jaspr_shadcn/src/renderers/field_styles.dart';

/// Native select with the same field geometry as ShadCN text inputs.
class ShadcnNativeSelect extends NativeSelectRenderBase {
  const ShadcnNativeSelect(super.props, {super.key});

  String get _height => switch (props.size) {
    ComponentSize.sm => '2rem',
    ComponentSize.md => '2.25rem',
    ComponentSize.lg => '2.5rem',
  };

  @override
  String get wrapperGap => 'var(--space-2)';

  @override
  Map<String, String> get labelStyles => shadcnFieldLabelStyles;

  @override
  Map<String, String> get selectStyles => <String, String>{
    ...super.selectStyles,
    'height': _height,
    'padding': '0.25rem 0.75rem',
    'text-overflow': 'ellipsis',
    'font-size': '0.875rem',
    'line-height': '1.25rem',
    'background-color': 'var(--shadcn-input-background, transparent)',
    'border': props.error != null
        ? '1px solid var(--shadcn-control-border-color, var(--destructive))'
        : '1px solid var(--shadcn-control-border-color, var(--shadcn-control-border))',
    'border-radius': 'var(--radius-md)',
    'box-shadow': 'var(--shadcn-control-shadow, var(--shadow-xs))',
  };
}
