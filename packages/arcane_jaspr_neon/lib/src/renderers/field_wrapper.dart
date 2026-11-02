import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/field_wrapper_props.dart';
import 'package:arcane_jaspr/core/rendering/base/field_wrapper_render_base.dart';

/// Neon FieldWrapper renderer.
class NeonFieldWrapper extends FieldWrapperRenderBase {
  const NeonFieldWrapper(super.props, {super.key});

  @override
  String get cssClass => 'neon-field-wrapper';

  @override
  Map<String, String> get wrapperStyles => const <String, String>{};

  @override
  Component? buildLabelRow(FieldWrapperProps props, bool hasError) {
    if (props.labelText == null) {
      return null;
    }
    return dom.label(
      attributes: <String, String>{
        if (props.fieldId != null) 'for': props.fieldId!,
      },
      <Component>[Component.text(props.labelText!)],
    );
  }

  @override
  Component? buildDescription(FieldWrapperProps props) {
    if (props.description == null) {
      return null;
    }
    return dom.p(<Component>[Component.text(props.description!)]);
  }

  @override
  Component buildFieldContent(FieldWrapperProps props) => props.field;

  @override
  Component? buildError(FieldWrapperProps props, bool hasError) {
    if (!(hasError && props.showValidation)) {
      return null;
    }
    return dom.p(<Component>[Component.text(props.error!)]);
  }
}

/// Neon FormSection renderer.
class NeonFormSection extends FormSectionRenderBase {
  const NeonFormSection(super.props, {super.key});

  @override
  String get headerClass => 'neon-form-section-header';

  @override
  Component buildRoot(List<Component> children) =>
      dom.fieldset(classes: 'neon-form-section', children);

  @override
  Component buildTitle(FormSectionProps props) =>
      dom.legend(<Component>[Component.text(props.title!)]);

  @override
  Component buildDescription(FormSectionProps props) =>
      dom.p(<Component>[Component.text(props.description!)]);
}

/// Neon InputGroup renderer.
class NeonInputGroup extends InputGroupRenderBase {
  const NeonInputGroup(super.props, {super.key});

  @override
  String get groupClass => 'neon-input-group';

  @override
  String get itemClass => 'neon-input-group-item';
}
