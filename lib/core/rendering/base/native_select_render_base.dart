import 'package:jaspr/jaspr.dart';

import 'package:arcane_jaspr/component/input/text_input.dart';
import 'package:arcane_jaspr/core/props/native_select_props.dart';

/// Shared structural base for themed native-select renderers.
///
/// Every theme's native select is identical: it maps the prop options onto
/// [ArcaneSelectOption] values and delegates the entire visual treatment to the
/// shared [ArcaneSelect] component. There is therefore no theme-specific value
/// to vary, and concrete theme renderers are empty subclasses that exist only
/// to preserve their public class names for the renderer registries.
///
/// This base lives in core and depends only on core props and the shared select
/// component; it must never depend on a theme package.
abstract class NativeSelectRenderBase extends StatelessComponent {
  const NativeSelectRenderBase(this.props, {super.key});

  final NativeSelectProps props;

  @override
  Component build(BuildContext context) {
    final List<ArcaneSelectOption> options = props.options
        .map(
          (NativeSelectOptionProps option) => ArcaneSelectOption(
            label: option.label,
            value: option.value,
            disabled: option.disabled,
          ),
        )
        .toList();

    return ArcaneSelect(
      options: options,
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
      styles: props.styles,
      decoration: props.decoration,
    );
  }
}
