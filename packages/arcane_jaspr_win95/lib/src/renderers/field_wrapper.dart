import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/field_wrapper_props.dart';
import 'package:arcane_jaspr/core/rendering/base/field_wrapper_render_base.dart';

/// Win95 FieldWrapper renderer.
class Win95FieldWrapper extends FieldWrapperRenderBase {
  const Win95FieldWrapper(super.props, {super.key});

  @override
  String get cssClass => 'win95-field-wrapper';

  @override
  Map<String, String> get wrapperStyles => const <String, String>{};

  @override
  Component? buildLabelRow(FieldWrapperProps props, bool hasError) {
    if (props.labelText == null) {
      return null;
    }
    return dom.label(<Component>[Component.text(props.labelText!)]);
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

/// Win95 FormSection renderer.
///
/// Renders a Win95 group box: the title is the fieldset's first-child
/// `<legend>`, so the browser seats it in the etched frame's top edge, and
/// only the description stays in the header block below it.
class Win95FormSection extends FormSectionRenderBase {
  const Win95FormSection(super.props, {super.key});

  @override
  String get headerClass => 'win95-form-section-header';

  @override
  Component build(BuildContext context) => buildRoot(<Component>[
    if (props.title != null) buildTitle(props),
    if (props.description != null)
      dom.div(
        classes: headerClass,
        styles: const dom.Styles(
          raw: <String, String>{'margin-bottom': '0.5rem'},
        ),
        <Component>[buildDescription(props)],
      ),
    ...props.children,
  ]);

  @override
  Component buildRoot(List<Component> children) =>
      dom.fieldset(classes: 'win95-form-section', children);

  @override
  Component buildTitle(FormSectionProps props) =>
      dom.legend(<Component>[Component.text(props.title!)]);

  @override
  Component buildDescription(FormSectionProps props) =>
      dom.p(<Component>[Component.text(props.description!)]);
}

/// Win95 InputGroup renderer.
class Win95InputGroup extends InputGroupRenderBase {
  const Win95InputGroup(super.props, {super.key});

  @override
  String get groupClass => 'win95-input-group';

  @override
  String get itemClass => 'win95-input-group-item';
}
