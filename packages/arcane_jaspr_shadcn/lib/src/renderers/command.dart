import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/command_props.dart';
import 'package:arcane_jaspr/core/rendering/base/command_render_base.dart';

/// ShadCN Command renderer.
///
/// Outputs the v4 CommandDialog: a `sm:max-w-lg` dialog with no padding, a
/// 3rem search row, a 300px list, `text-xs font-medium` group headings and
/// `rounded-sm px-2 py-1.5 text-sm` items whose background and foreground
/// route through `--shadcn-item-*` (the runtime marks the keyboard-active row
/// with `data-arcane-state="active"`).
///
/// Reference: https://ui.shadcn.com/docs/components/command
class ShadcnCommand extends CommandRenderBase {
  const ShadcnCommand(super.props, {super.key});

  static int _autoCounter = 0;

  @override
  String autoId() {
    _autoCounter++;
    return 'arcane-command-$_autoCounter';
  }

  @override
  String get overlayClasses => 'arcane-command-overlay arcane-overlay-scrim';

  @override
  Map<String, String> get overlayStyles => const <String, String>{
    'position': 'fixed',
    'inset': '0',
    'z-index': '50',
    'display': 'flex',
    'align-items': 'flex-start',
    'justify-content': 'center',
    'padding': '20vh 1rem 1rem',
    'background-color': 'var(--overlay)',
    'animation': 'arcane-fade-in var(--transition-slow)',
  };

  @override
  String get dialogClasses => 'arcane-command-dialog';

  @override
  Map<String, String> get dialogStyles => const <String, String>{
    'display': 'flex',
    'flex-direction': 'column',
    'width': '100%',
    'max-width': '32rem',
    'padding': '0',
    'background-color': 'var(--popover)',
    'color': 'var(--popover-foreground)',
    'border': '1px solid var(--border)',
    'border-radius': 'var(--radius-md)',
    'box-shadow': 'var(--shadow-lg)',
    'overflow': 'hidden',
    'animation': 'arcane-scale-in var(--transition-slow)',
  };

  /// The row is square (radius 0) inside the clipped dialog, so its bottom
  /// rule is a divider rather than an edge accent on a rounded box.
  @override
  Map<String, String> get searchRowStyles => const <String, String>{
    'display': 'flex',
    'align-items': 'center',
    'gap': '0.5rem',
    'height': '3rem',
    'padding': '0 0.75rem',
    'border-radius': '0',
    'border-bottom': '1px solid var(--border)',
  };

  @override
  Map<String, String> get searchIconStyles => const <String, String>{
    'display': 'flex',
    'align-items': 'center',
    'flex-shrink': '0',
    'opacity': '0.5',
  };

  @override
  String get inputClass => 'arcane-command-input';

  @override
  String get inputStyleSuffix =>
      'height:3rem;padding:0.75rem 0;font-size:0.875rem;'
      'color:var(--foreground);outline:none;';

  @override
  String get listClasses => 'arcane-command-list';

  @override
  Map<String, String> get listStyles => const <String, String>{
    'max-height': '300px',
    'overflow-x': 'hidden',
    'overflow-y': 'auto',
    'padding': '0.25rem',
  };

  @override
  String get groupHeadingClass => 'arcane-command-group-heading';

  @override
  Map<String, String> get groupHeadingStyles => const <String, String>{
    'padding': '0.375rem 0.5rem',
    'font-size': '0.75rem',
    'line-height': '1rem',
    'font-weight': '500',
    'color': 'var(--muted-foreground)',
  };

  /// A square divider row under the rounded dialog's clip, like the search
  /// row above the list.
  @override
  Map<String, String> get footerStyles => const <String, String>{
    'display': 'flex',
    'align-items': 'center',
    'gap': '1rem',
    'padding': '0.5rem 0.75rem',
    'border-radius': '0',
    'border-top': '1px solid var(--border)',
    'font-size': '0.75rem',
    'color': 'var(--muted-foreground)',
  };

  @override
  String get itemBaseClass => 'arcane-command-item';

  @override
  Map<String, String> itemStyles(CommandItemProps item) => <String, String>{
    'position': 'relative',
    'display': 'flex',
    'align-items': 'center',
    'gap': '0.5rem',
    'padding': '0.375rem 0.5rem',
    'border-radius': 'var(--shadcn-item-radius)',
    'font-size': '0.875rem',
    'line-height': '1.25rem',
    'background-color': 'var(--shadcn-item-background, transparent)',
    'color': 'var(--shadcn-item-foreground, inherit)',
    'cursor': 'default',
    'user-select': 'none',
    'outline': 'none',
    'transition': 'background-color var(--transition), color var(--transition)',
    if (item.disabled) 'pointer-events': 'none',
    if (item.disabled) 'opacity': '0.5',
  };

  /// v4 CommandShortcut: `ml-auto text-xs tracking-widest
  /// text-muted-foreground`.
  @override
  Component buildShortcut(String shortcut) => dom.span(
    classes: 'arcane-command-shortcut',
    styles: const dom.Styles(
      raw: <String, String>{
        'margin-left': 'auto',
        'font-size': '0.75rem',
        'letter-spacing': '0.1em',
        'color': 'var(--muted-foreground)',
      },
    ),
    <Component>[Component.text(shortcut)],
  );

  @override
  List<Component> buildKeyHints() => <Component>[
    _buildKeyHint('Enter', 'Select'),
    _buildKeyHint('Up/Down', 'Navigate'),
    _buildKeyHint('esc', 'Close'),
  ];

  Component _buildKeyHint(String key, String label) {
    return dom.div(
      styles: const dom.Styles(
        raw: <String, String>{
          'display': 'flex',
          'align-items': 'center',
          'gap': '0.25rem',
        },
      ),
      <Component>[
        dom.span(
          styles: const dom.Styles(
            raw: <String, String>{
              'padding': '0 0.25rem',
              'min-width': '1.25rem',
              'height': '1.25rem',
              'display': 'inline-flex',
              'align-items': 'center',
              'justify-content': 'center',
              'background-color': 'var(--muted)',
              'color': 'var(--muted-foreground)',
              'border-radius': 'var(--radius-xs)',
              'font-family': 'var(--font-mono)',
              'font-size': '0.75rem',
            },
          ),
          <Component>[Component.text(key)],
        ),
        dom.span(<Component>[Component.text(label)]),
      ],
    );
  }
}
