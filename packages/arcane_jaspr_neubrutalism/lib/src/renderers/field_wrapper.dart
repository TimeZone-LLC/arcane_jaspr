import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/field_wrapper_props.dart';
import 'package:arcane_jaspr/core/rendering/base/field_wrapper_render_base.dart';

/// Neubrutalism FieldWrapper renderer.
class NeubrutalismFieldWrapper extends FieldWrapperRenderBase {
  const NeubrutalismFieldWrapper(super.props, {super.key});

  @override
  String get cssClass => 'neubrutalism-field-wrapper';

  @override
  Map<String, String> get wrapperStyles => const <String, String>{
    'display': 'flex',
    'flex-direction': 'column',
    'gap': 'var(--space-2)',
  };

  @override
  Component? buildLabelRow(FieldWrapperProps props, bool hasError) {
    if (props.labelText == null) {
      return null;
    }
    return dom.div(
      classes: 'neubrutalism-field-label-row',
      styles: const dom.Styles(
        raw: {
          'display': 'flex',
          'align-items': 'center',
          'gap': 'var(--space-2)',
        },
      ),
      [
        if (props.leading != null) props.leading!,
        dom.label(
          attributes: <String, String>{
            if (props.fieldId != null) 'for': props.fieldId!,
          },
          styles: const dom.Styles(
            raw: {
              'font-size': 'var(--font-size-sm)',
              'font-weight': 'var(--font-weight-medium)',
              'color': 'var(--foreground)',
            },
          ),
          [
            Component.text(props.labelText!),
            if (props.required)
              const dom.span(
                styles: dom.Styles(
                  raw: {
                    'color': 'var(--destructive)',
                    'margin-left': '0.25rem',
                  },
                ),
                [Component.text('*')],
              ),
          ],
        ),
        if (props.trailing != null) props.trailing!,
      ],
    );
  }

  @override
  Component? buildDescription(FieldWrapperProps props) {
    if (props.description == null) {
      return null;
    }
    return dom.p(
      classes: 'neubrutalism-field-description',
      styles: const dom.Styles(
        raw: {
          'font-size': '0.8125rem',
          'color': 'var(--muted-foreground)',
          'margin': '0',
        },
      ),
      [Component.text(props.description!)],
    );
  }

  @override
  Component buildFieldContent(FieldWrapperProps props) {
    return props.field;
  }

  @override
  Component? buildError(FieldWrapperProps props, bool hasError) {
    if (!(hasError && props.showValidation)) {
      return null;
    }
    return dom.p(
      classes: 'neubrutalism-field-error',
      styles: const dom.Styles(
        raw: {
          'font-size': '0.8125rem',
          'color': 'var(--destructive)',
          'margin': '0',
        },
      ),
      [Component.text(props.error!)],
    );
  }
}

/// Neubrutalism FormSection renderer.
class NeubrutalismFormSection extends FormSectionRenderBase {
  const NeubrutalismFormSection(super.props, {super.key});

  @override
  String get headerClass => 'neubrutalism-form-section-header';

  @override
  Component buildRoot(List<Component> children) {
    return dom.fieldset(
      classes: 'neubrutalism-form-section',
      styles: dom.Styles(
        raw: {
          'display': 'flex',
          'flex-direction': 'column',
          'gap': '${props.spacing}px',
          'border': 'none',
          'padding': '0',
          'margin': '0',
        },
      ),
      children,
    );
  }

  @override
  Component buildTitle(FormSectionProps props) {
    return dom.legend(
      styles: const dom.Styles(
        raw: {
          'font-size': 'var(--font-size-base)',
          'font-weight': 'var(--font-weight-semibold)',
          'color': 'var(--foreground)',
          'padding': '0',
        },
      ),
      [Component.text(props.title!)],
    );
  }

  @override
  Component buildDescription(FormSectionProps props) {
    return dom.p(
      styles: const dom.Styles(
        raw: {
          'font-size': 'var(--font-size-sm)',
          'color': 'var(--muted-foreground)',
          'margin': '0.25rem 0 0 0',
        },
      ),
      [Component.text(props.description!)],
    );
  }
}

/// Neubrutalism InputGroup renderer.
class NeubrutalismInputGroup extends InputGroupRenderBase {
  const NeubrutalismInputGroup(super.props, {super.key});

  @override
  String get groupClass => 'neubrutalism-input-group';

  @override
  String get itemClass => 'neubrutalism-input-group-item';
}
