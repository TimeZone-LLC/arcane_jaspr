import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/button_props.dart';
import 'package:arcane_jaspr/core/props/dialog_props.dart';
import 'package:arcane_jaspr/core/rendering/base/confirm_dialog_render_base.dart';
import 'button.dart';
import 'dialog.dart';

/// Neubrutalism Confirm Dialog renderer.
class NeubrutalismConfirmDialog extends ConfirmDialogRenderBase {
  const NeubrutalismConfirmDialog(super.props, {super.key});

  @override
  Component buildDialog(DialogProps props) => NeubrutalismDialog(props);

  @override
  Component buildButton(ButtonProps props) => NeubrutalismButton(props);

  @override
  double get maxWidth => 420;

  @override
  String get contentClass => 'neubrutalism-confirm-dialog-content';

  @override
  String get contentGap => '1.25rem';

  @override
  String get messageFontSize => '0.9375rem';

  @override
  Component buildIcon(Component icon, bool destructive) {
    final String accent = destructive
        ? 'var(--destructive)'
        : 'var(--nb-accent, var(--primary))';
    return dom.div(
      classes: 'neubrutalism-confirm-dialog-icon',
      styles: dom.Styles(
        raw: {
          'display': 'inline-flex',
          'align-items': 'center',
          'justify-content': 'center',
          'width': '3rem',
          'height': '3rem',
          'font-size': '1.5rem',
          'color': accent,
          'background': accent,
          'border': 'var(--nb-border-thin, 2px) solid var(--nb-line, #000)',
          'border-radius': 'var(--nb-radius-soft, 4px)',
          'box-shadow':
              'var(--nb-shadow-md, 5px 5px 0 0 var(--nb-shadow-color, #000))',
        },
      ),
      [icon],
    );
  }
}

/// Neubrutalism Alert Dialog renderer.
class NeubrutalismAlertDialog extends AlertDialogRenderBase {
  const NeubrutalismAlertDialog(super.props, {super.key});

  @override
  Component buildDialog(DialogProps props) => NeubrutalismDialog(props);

  @override
  Component buildButton(ButtonProps props) => NeubrutalismButton(props);

  @override
  double get maxWidth => 420;

  @override
  String get contentGap => '1.25rem';

  @override
  String get messageFontSize => '0.9375rem';

  @override
  Component buildIcon(Component icon) => dom.div(
    classes: 'neubrutalism-confirm-dialog-icon',
    styles: const dom.Styles(
      raw: {
        'display': 'inline-flex',
        'align-items': 'center',
        'justify-content': 'center',
        'width': '3rem',
        'height': '3rem',
        'font-size': '1.5rem',
        'color': 'var(--nb-ink, #000)',
        'background': 'var(--nb-accent, var(--primary))',
        'border': 'var(--nb-border-thick, 3px) solid var(--nb-line, #000)',
        'border-radius': 'var(--nb-radius-tight, 0)',
        'box-shadow':
            'var(--nb-shadow-md, 5px 5px 0 0 var(--nb-shadow-color, #000))',
      },
    ),
    [icon],
  );
}
