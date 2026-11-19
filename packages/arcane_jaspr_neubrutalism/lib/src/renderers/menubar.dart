import 'package:arcane_jaspr/core/rendering/base/menubar_render_base.dart';

/// Neubrutalism menubar component.
class NeubrutalismMenubar extends MenubarRenderBase {
  const NeubrutalismMenubar(super.props, {super.key});

  @override
  String get themePrefix => 'neubrutalism';

  @override
  Map<String, String> get rootStyles => <String, String>{
    'display': 'flex',
    'height': '44px',
    'align-items': 'center',
    'gap': '4px',
    'border': 'var(--nb-border-thin, 2px) solid var(--nb-line, #000)',
    'background': 'transparent',
    'padding': '4px',
  };

  @override
  Map<String, String> triggerStyles(bool isOpen) => <String, String>{
    'display': 'flex',
    'cursor': 'default',
    'user-select': 'none',
    'align-items': 'center',
    'padding': '6px 14px',
    'font-family': 'var(--font-heading)',
    'font-size': 'var(--font-size-sm)',
    'font-weight': '700',
    'letter-spacing': '0.06em',
    'text-transform': 'uppercase',
    'outline': 'none',
    'border': 'none',
    'background': isOpen ? 'var(--nb-accent, var(--primary))' : 'transparent',
    'color': isOpen ? 'var(--nb-ink, #000)' : 'var(--nb-ink, var(--foreground))',
    'transition': 'background-color 120ms ease',
  };

  @override
  Map<String, String> get contentStyles => <String, String>{
    'position': 'absolute',
    'top': '100%',
    'left': '0',
    'z-index': '50',
    'min-width': '200px',
    'overflow': 'hidden',
    'padding': '6px',
    'margin-top': '8px',
    'background': 'var(--nb-paper, var(--card))',
    'border': 'var(--nb-border-thick, 3px) solid var(--nb-line, #000)',
    'border-radius': 'var(--nb-radius-soft, 0)',
    'box-shadow': 'var(--nb-shadow-md, 5px 5px 0 0 var(--nb-shadow-color, #000))',
    'color': 'var(--nb-ink, var(--popover-foreground))',
  };

  @override
  Map<String, String> get separatorStyles => <String, String>{
    'height': '2px',
    'margin': '6px -6px',
    'background': 'var(--nb-line, #000)',
  };

  @override
  String get itemBorderRadius => 'var(--nb-radius-soft, 4px)';

  @override
  String get itemTransition =>
      'background-color var(--nb-transition, 120ms ease), color var(--nb-transition, 120ms ease)';

  @override
  String get indicatorColor => 'var(--nb-accent, var(--primary))';
}
