import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/command_props.dart';
import 'package:arcane_jaspr/core/rendering/base/command_render_base.dart';

/// Neubrutalism Command renderer.
class NeubrutalismCommand extends CommandRenderBase {
  const NeubrutalismCommand(super.props, {super.key});

  static int _autoCounter = 0;

  @override
  String autoId() {
    _autoCounter++;
    return 'neubrutalism-command-$_autoCounter';
  }

  @override
  String get overlayClasses =>
      'neubrutalism-command-overlay arcane-overlay-scrim';

  @override
  Map<String, String> get overlayStyles => const <String, String>{
    'position': 'fixed',
    'inset': '0',
    'z-index': '50',
    'display': 'flex',
    'align-items': 'flex-start',
    'justify-content': 'center',
    'padding-top': '20vh',
    'padding-inline': '12px',
    'padding-bottom': '12px',
    'box-sizing': 'border-box',
    'background': 'rgba(0, 0, 0, 0.55)',
  };

  @override
  String get dialogClasses => 'neubrutalism-command-dialog neubrutalism-panel';

  @override
  Map<String, String> get dialogStyles => const <String, String>{
    'width': '100%',
    'max-width': '640px',
    'max-height': '100%',
    'min-width': '0',
    'min-height': '0',
    'display': 'flex',
    'flex-direction': 'column',
    'box-sizing': 'border-box',
    'color': 'var(--foreground)',
    'overflow': 'hidden',
  };

  @override
  Map<String, String> get searchRowStyles => const <String, String>{
    'display': 'flex',
    'flex-shrink': '0',
    'min-width': '0',
    'align-items': 'center',
    'gap': '12px',
    'padding': '14px 18px',
    'border-bottom': 'var(--nb-border-thin, 2px) solid var(--nb-line, #000)',
  };

  @override
  Map<String, String> get searchIconStyles => const <String, String>{
    'color': 'var(--nb-accent, var(--primary))',
    'display': 'flex',
    'align-items': 'center',
  };

  @override
  String get inputClass => 'neubrutalism-command-input';

  @override
  String get inputStyleSuffix =>
      'font-size:0.9375rem;color:var(--foreground);outline:none;letter-spacing:0.01em;';

  @override
  String get listClasses => 'neubrutalism-command-list';

  @override
  Map<String, String> get listStyles => const <String, String>{
    'max-height': '400px',
    'min-height': '0',
    'overflow-y': 'auto',
    'padding': '10px',
  };

  @override
  String get groupHeadingClass => 'neubrutalism-command-group-heading';

  @override
  Map<String, String> get groupHeadingStyles => const <String, String>{
    'padding': '10px 14px 4px',
    'font-family': 'var(--font-heading)',
    'font-size': '0.6875rem',
    'font-weight': '600',
    'color': 'var(--muted-foreground)',
    'text-transform': 'uppercase',
    'letter-spacing': '0.12em',
  };

  @override
  Map<String, String> get footerStyles => const <String, String>{
    'display': 'flex',
    'flex-wrap': 'wrap',
    'flex-shrink': '0',
    'align-items': 'center',
    'gap': '8px 16px',
    'padding': '10px 16px',
    'border-top': 'var(--nb-border-thin, 2px) solid var(--nb-line, #000)',
    'font-size': 'var(--font-size-xs)',
    'color': 'var(--muted-foreground)',
  };

  @override
  String get itemBaseClass => 'neubrutalism-command-item';

  @override
  Map<String, String> itemStyles(CommandItemProps item) => <String, String>{
    'display': 'flex',
    'align-items': 'center',
    'gap': '10px',
    'padding': '10px 14px',
    'cursor': item.disabled ? 'not-allowed' : 'pointer',
    'transition': 'background-color var(--nb-transition, 120ms ease)',
    if (item.disabled) 'opacity': '0.5',
  };

  @override
  Component buildShortcut(String shortcut) => dom.span(
    classes: 'neubrutalism-kbd',
    styles: const dom.Styles(
      raw: <String, String>{
        'font-size': 'var(--font-size-xs)',
        'padding': '3px 8px',
      },
    ),
    [Component.text(shortcut)],
  );

  @override
  List<Component> buildKeyHints() => <Component>[
    _buildKeyHint('\u{21B5}', 'Select'),
    _buildKeyHint('\u{2191}\u{2193}', 'Navigate'),
    _buildKeyHint('esc', 'Close'),
  ];

  Component _buildKeyHint(String key, String label) {
    return dom.div(
      styles: const dom.Styles(
        raw: <String, String>{
          'display': 'flex',
          'align-items': 'center',
          'gap': '6px',
        },
      ),
      [
        dom.span(
          classes: 'neubrutalism-kbd',
          styles: const dom.Styles(raw: <String, String>{'padding': '3px 8px'}),
          [Component.text(key)],
        ),
        dom.span([Component.text(label)]),
      ],
    );
  }
}
