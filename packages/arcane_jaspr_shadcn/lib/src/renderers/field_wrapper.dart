import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/field_wrapper_props.dart';
import 'package:arcane_jaspr/core/rendering/base/field_wrapper_render_base.dart';

/// ShadCN Field Wrapper renderer (FormItem: `grid gap-2`; FormLabel
/// `text-sm font-medium leading-none`; FormDescription and FormMessage
/// `text-sm`).
class ShadcnFieldWrapper extends FieldWrapperRenderBase {
  const ShadcnFieldWrapper(super.props, {super.key});

  @override
  String get cssClass => 'arcane-field-wrapper';

  @override
  Map<String, String> get wrapperStyles => const <String, String>{
    'display': 'flex',
    'flex-direction': 'column',
    'gap': '0.5rem',
    'width': '100%',
    'min-width': '0',
  };

  @override
  Component? buildLabelRow(FieldWrapperProps props, bool hasError) {
    if (props.labelText == null && props.icon == null && !props.required) {
      return null;
    }
    return dom.div(
      classes: 'arcane-field-label-row',
      styles: const dom.Styles(
        raw: {
          'display': 'flex',
          'align-items': 'center',
          'gap': 'var(--space-2)',
        },
      ),
      [
        if (props.leading != null) props.leading!,
        if (props.icon != null)
          dom.span(
            styles: dom.Styles(
              raw: {
                'color': hasError
                    ? 'var(--destructive)'
                    : 'var(--muted-foreground)',
                'font-size': 'var(--font-size-base)',
              },
            ),
            [Component.text(props.icon!)],
          ),
        if (props.labelText != null)
          dom.label(
            classes: 'arcane-field-label',
            styles: dom.Styles(
              raw: {
                'font-size': '0.875rem',
                'font-weight': '500',
                'line-height': '1',
                'color': hasError ? 'var(--destructive)' : 'var(--foreground)',
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
    return dom.div(
      classes: 'arcane-field-description',
      styles: const dom.Styles(
        raw: {
          'font-size': '0.875rem',
          'color': 'var(--muted-foreground)',
          'line-height': '1.25rem',
        },
      ),
      [Component.text(props.description!)],
    );
  }

  @override
  Component buildFieldContent(FieldWrapperProps props) {
    return dom.div(
      classes: 'arcane-field-content',
      styles: const dom.Styles(
        raw: <String, String>{'width': '100%', 'min-width': '0'},
      ),
      [props.field],
    );
  }

  @override
  Component? buildError(FieldWrapperProps props, bool hasError) {
    if (!(hasError && props.showValidation)) {
      return null;
    }
    return dom.div(
      classes: 'arcane-field-error',
      styles: const dom.Styles(
        raw: {
          'display': 'flex',
          'align-items': 'center',
          'gap': 'var(--space-1)',
          'font-size': '0.875rem',
          'line-height': '1.25rem',
          'color': 'var(--destructive)',
        },
      ),
      [
        const dom.span([Component.text('!')]),
        Component.text(props.error!),
      ],
    );
  }
}

/// ShadCN Form Section renderer.
class ShadcnFormSection extends FormSectionRenderBase {
  const ShadcnFormSection(super.props, {super.key});

  @override
  String get headerClass => 'arcane-form-section-header';

  @override
  Component buildRoot(List<Component> children) {
    return dom.div(
      classes: 'arcane-form-section',
      styles: dom.Styles(
        raw: {
          'display': 'flex',
          'flex-direction': 'column',
          'gap': '${props.spacing}px',
        },
      ),
      children,
    );
  }

  @override
  Component buildTitle(FormSectionProps props) {
    return dom.div(
      styles: dom.Styles(
        raw: {
          'font-size': 'var(--font-size-base)',
          'font-weight': 'var(--font-weight-semibold)',
          'color': 'var(--foreground)',
          'margin-bottom': props.description != null ? '0.25rem' : '0',
        },
      ),
      [Component.text(props.title!)],
    );
  }

  @override
  Component buildDescription(FormSectionProps props) {
    return dom.div(
      styles: const dom.Styles(
        raw: {
          'font-size': 'var(--font-size-sm)',
          'color': 'var(--muted-foreground)',
          'line-height': '1.625',
        },
      ),
      [Component.text(props.description!)],
    );
  }
}

/// ShadCN Input Group renderer.
class ShadcnInputGroup extends InputGroupRenderBase {
  const ShadcnInputGroup(super.props, {super.key});

  @override
  String get groupClass => 'arcane-input-group';

  @override
  String get itemClass => 'arcane-input-group-item';
}
