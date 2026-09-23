import 'package:arcane_jaspr/component/form/field.dart';
import 'package:arcane_jaspr/component/form/field_wrapper.dart';
import 'package:arcane_jaspr/component/form/provider.dart';
import 'package:arcane_jaspr/component/input/text_input.dart';
import 'package:arcane_jaspr/flutter.dart';

class ArcaneStringField extends StatelessWidget {
  final String? name;
  final String? description;
  final String? placeholder;
  final ArcaneFieldProvider<String> provider;
  final int maxLines;
  final int? minLines;
  final bool required;

  const ArcaneStringField({
    required this.provider,
    this.name,
    this.description,
    this.placeholder,
    this.maxLines = 1,
    this.minLines,
    this.required = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ArcaneField<String>(
    meta: ArcaneFieldMetadata(
      name: name,
      description: description,
      placeholder: placeholder,
    ),
    provider: provider,
    builder:
        (BuildContext context, String value, void Function(String) onChanged) =>
            ArcaneFieldWrapper(
              labelText: name,
              description: description,
              required: required,
              field: maxLines > 1
                  ? TextArea(
                      value: value,
                      rows: maxLines,
                      onChanged: onChanged,
                      placeholder: placeholder,
                    )
                  : TextInput(
                      value: value,
                      onChanged: onChanged,
                      placeholder: placeholder,
                    ),
            ),
  );
}
