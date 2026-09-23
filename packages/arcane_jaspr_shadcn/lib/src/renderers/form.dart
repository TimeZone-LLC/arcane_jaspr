import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/button_props.dart';
import 'package:arcane_jaspr/core/props/field_wrapper_props.dart';

import 'package:arcane_jaspr_shadcn/src/renderers/button.dart';

/// ShadCN Form renderer (stateful for form handling).
///
/// The action row reuses [ShadcnButton] so cancel/submit share the button
/// sizing, hover and focus contract (outline + primary).
class ShadcnForm extends StatefulComponent {
  final FormProps props;

  const ShadcnForm(this.props, {super.key});

  @override
  State<ShadcnForm> createState() => _ShadcnFormState();
}

class _ShadcnFormState extends State<ShadcnForm> {
  @override
  Component build(BuildContext context) {
    final FormProps props = component.props;
    return dom.form(
      classes: 'arcane-form',
      styles: dom.Styles(
        raw: <String, String>{
          'display': 'flex',
          'flex-direction': 'column',
          'gap': '${props.spacing}px',
        },
      ),
      events: <String, EventCallback>{
        'submit': (event) {
          event.preventDefault();
          props.onSubmit?.call();
        },
      },
      <Component>[
        ...props.children,
        if (props.showActions)
          dom.div(
            classes: 'arcane-form-actions',
            styles: const dom.Styles(
              raw: <String, String>{
                'display': 'flex',
                'justify-content': 'flex-end',
                'gap': '0.5rem',
                'margin-top': '1.5rem',
                'padding-top': '1.5rem',
                'border-top': '1px solid var(--border)',
              },
            ),
            <Component>[
              if (props.onCancel != null)
                ShadcnButton(
                  ButtonProps(
                    label: props.cancelText,
                    variant: ButtonVariant.outline,
                    onPressed: props.onCancel,
                  ),
                ),
              ShadcnButton(
                ButtonProps(label: props.submitText, type: ButtonType.submit),
              ),
            ],
          ),
      ],
    );
  }
}
