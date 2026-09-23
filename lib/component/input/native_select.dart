import 'package:arcane_jaspr/flutter.dart';

import 'text_input.dart';
import '../../core/decoration/arcane_decoration.dart';
import '../../core/theme_provider.dart';
import '../../util/style_types/arcane_style_data.dart';

typedef ArcaneNativeSelectOption = ArcaneSelectOption;

class ArcaneNativeSelect extends StatelessWidget {
  final List<ArcaneSelectOption> options;
  final String? value;
  final String? placeholder;
  final ComponentSize size;
  final bool disabled;
  final bool required;
  final String? name;
  final String? id;
  final String? label;
  final String? error;
  final bool fullWidth;
  final void Function(String)? onChanged;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation + theme-specific fields).
  final ArcaneDecoration? decoration;

  const ArcaneNativeSelect({
    required this.options,
    this.value,
    this.placeholder,
    this.size = ComponentSize.md,
    this.disabled = false,
    this.required = false,
    this.name,
    this.id,
    this.label,
    this.error,
    this.fullWidth = false,
    this.onChanged,
    this.styles,
    this.decoration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<NativeSelectOptionProps> mappedOptions = options
        .map(
          (ArcaneSelectOption option) => NativeSelectOptionProps(
            label: option.label,
            value: option.value,
            disabled: option.disabled,
          ),
        )
        .toList();

    return context.renderers.nativeSelect(
      NativeSelectProps(
        options: mappedOptions,
        value: value,
        placeholder: placeholder,
        size: size,
        disabled: disabled,
        required: required,
        name: name,
        id: id,
        label: label,
        error: error,
        fullWidth: fullWidth,
        onChange: onChanged,
        styles: styles,
        decoration: decoration,
      ),
    );
  }
}
