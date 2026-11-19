import 'package:arcane_jaspr/flutter.dart';

import '../../core/decoration/arcane_decoration.dart';
import '../../core/theme_provider.dart';
import '../../util/style_types/arcane_style_data.dart';

export '../../core/props/field_wrapper_props.dart';

/// Wrapper for form fields providing consistent styling and layout.
class ArcaneFieldWrapper extends StatelessWidget {
  final Widget field;
  final String? fieldId;
  final String? labelText;
  final String? description;
  final String? icon;
  final String? error;
  final bool required;
  final bool showValidation;
  final Widget? leading;
  final Widget? trailing;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation + theme-specific fields).
  final ArcaneDecoration? decoration;

  const ArcaneFieldWrapper({
    required this.field,
    this.fieldId,
    this.labelText,
    this.description,
    this.icon,
    this.error,
    this.required = false,
    this.showValidation = true,
    this.leading,
    this.trailing,
    this.styles,
    this.decoration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return context.renderers.fieldWrapper(
      FieldWrapperProps(
        field: field,
        fieldId: fieldId,
        labelText: labelText,
        description: description,
        icon: icon,
        error: error,
        required: required,
        showValidation: showValidation,
        leading: leading,
        trailing: trailing,
        styles: styles,
        decoration: decoration,
      ),
    );
  }
}

/// Form section that groups multiple fields together.
class ArcaneFormSection extends StatelessWidget {
  final String? title;
  final String? description;
  final List<Widget> children;
  final double spacing;

  const ArcaneFormSection({
    this.title,
    this.description,
    required this.children,
    this.spacing = 16,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return context.renderers.formSection(
      FormSectionProps(
        title: title,
        description: description,
        children: children,
        spacing: spacing,
      ),
    );
  }
}

/// Complete form component with built-in state management.
class ArcaneForm extends StatelessWidget {
  final List<Widget> children;
  final String? submitText;
  final String? cancelText;
  final void Function()? onSubmit;
  final void Function()? onCancel;
  final bool showActions;
  final double spacing;

  const ArcaneForm({
    required this.children,
    this.submitText = 'Submit',
    this.cancelText = 'Cancel',
    this.onSubmit,
    this.onCancel,
    this.showActions = true,
    this.spacing = 16,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return context.renderers.form(
      FormProps(
        children: children,
        submitText: submitText,
        cancelText: cancelText,
        onSubmit: onSubmit,
        onCancel: onCancel,
        showActions: showActions,
        spacing: spacing,
      ),
    );
  }
}

/// Input group that combines multiple inputs in a row.
class ArcaneInputGroup extends StatelessWidget {
  final List<Widget> children;
  final double gap;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation + theme-specific fields).
  final ArcaneDecoration? decoration;

  const ArcaneInputGroup({
    required this.children,
    this.gap = 8,
    this.styles,
    this.decoration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return context.renderers.inputGroup(
      InputGroupProps(
        children: children,
        gap: gap,
        styles: styles,
        decoration: decoration,
      ),
    );
  }
}
