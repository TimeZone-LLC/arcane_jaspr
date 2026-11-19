import 'package:arcane_jaspr/core/rendering/base/context_menu_render_base.dart';

/// Neubrutalism-style context menu component with pattern matching on sealed ArcaneMenuItem types.
class NeubrutalismContextMenu extends ContextMenuRenderBase {
  const NeubrutalismContextMenu(super.props, {super.key});

  @override
  String get themePrefix => 'neubrutalism';

  @override
  String get popoverSuffix => ' neubrutalism-popover';

  @override
  Map<String, String> get menuStyles => const <String, String>{
    'z-index': '50',
    'box-sizing': 'border-box',
    'min-width': 'min(180px, calc(100vw - 8px))',
    'max-width': 'calc(100vw - 8px)',
    'max-height': 'calc(100vh - 8px)',
    'overflow': 'auto',
    'overflow-wrap': 'anywhere',
    'padding': '6px',
    'background': 'var(--nb-paper, var(--card))',
    'border': 'var(--nb-border-thick, 3px) solid var(--nb-line, #000)',
    'border-radius': 'var(--nb-radius-soft, 0)',
    'box-shadow':
        'var(--nb-shadow-md, 5px 5px 0 0 var(--nb-shadow-color, #000))',
    'color': 'var(--nb-ink, var(--popover-foreground))',
  };

  @override
  Map<String, String> get separatorStyles => const <String, String>{
    'height': '2px',
    'margin': '6px -6px',
    'background': 'var(--nb-line, #000)',
  };

  @override
  Map<String, String> get labelStyles => const <String, String>{
    'padding': '8px 10px 4px',
    'font-family': 'var(--font-heading)',
    'font-size': '0.6875rem',
    'font-weight': '600',
    'letter-spacing': '0.12em',
    'text-transform': 'uppercase',
    'color': 'var(--muted-foreground)',
    'user-select': 'none',
  };

  @override
  Map<String, String> actionStyles(bool disabled) => <String, String>{
    'position': 'relative',
    'display': 'flex',
    'align-items': 'center',
    'gap': '10px',
    'padding': '8px 12px',
    'border-radius': 'var(--nb-radius-soft, 4px)',
    'cursor': disabled ? 'not-allowed' : 'pointer',
    'transition':
        'color var(--nb-transition, 120ms ease), background-color var(--nb-transition, 120ms ease)',
    'font-size': 'var(--font-size-sm)',
    'user-select': 'none',
    'outline': 'none',
    if (disabled) 'pointer-events': 'none',
    if (disabled) 'opacity': '0.5',
  };

  @override
  Map<String, String> selectableStyles(bool disabled) => <String, String>{
    'position': 'relative',
    'display': 'flex',
    'align-items': 'center',
    'gap': '10px',
    'padding': '8px 12px',
    'padding-left': '36px',
    'font-size': 'var(--font-size-sm)',
    'border-radius': 'var(--nb-radius-soft, 4px)',
    'cursor': disabled ? 'not-allowed' : 'pointer',
    'transition':
        'background-color var(--nb-transition, 120ms ease), color var(--nb-transition, 120ms ease)',
    'user-select': 'none',
    'outline': 'none',
    if (disabled) 'pointer-events': 'none',
    if (disabled) 'opacity': '0.5',
  };

  @override
  Map<String, String> submenuTriggerStyles(bool disabled) => <String, String>{
    'position': 'relative',
    'display': 'flex',
    'align-items': 'center',
    'gap': '10px',
    'padding': '8px 12px',
    'border-radius': 'var(--nb-radius-soft, 4px)',
    'cursor': disabled ? 'not-allowed' : 'default',
    'transition':
        'color var(--nb-transition, 120ms ease), background-color var(--nb-transition, 120ms ease)',
    'font-size': 'var(--font-size-sm)',
    'user-select': 'none',
    'outline': 'none',
    if (disabled) 'pointer-events': 'none',
    if (disabled) 'opacity': '0.5',
  };

  @override
  Map<String, String> get submenuStyles => const <String, String>{
    'min-width': '160px',
    'padding': '6px',
    'background': 'var(--nb-paper, var(--card))',
    'border': 'var(--nb-border-thick, 3px) solid var(--nb-line, #000)',
    'box-shadow':
        'var(--nb-shadow-md, 5px 5px 0 0 var(--nb-shadow-color, #000))',
    'z-index': '101',
  };

  @override
  String get labelTextColor => 'var(--foreground)';

  @override
  String get indicatorColor => 'var(--nb-accent, var(--primary))';

  @override
  String get indicatorLeft => '12px';

  @override
  String get shortcutLetterSpacing => '0';
}
