import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/dropdown_menu_props.dart';
import 'package:arcane_jaspr/core/rendering/base/dropdown_menu_render_base.dart';

/// Neubrutalism DropdownMenu renderer.
class NeubrutalismDropdownMenu extends DropdownMenuRenderBase {
  const NeubrutalismDropdownMenu(super.props, {super.key});

  @override
  String get rootClass => 'neubrutalism-dropdown';

  @override
  String get triggerClass => 'neubrutalism-dropdown-trigger';

  @override
  String get menuClass => 'neubrutalism-dropdown-menu neubrutalism-popover';

  @override
  String get itemClass => 'neubrutalism-dropdown-item';

  @override
  String get submenuClass =>
      'neubrutalism-dropdown-submenu neubrutalism-popover';

  @override
  String get anchorOffset => '8';

  @override
  String get itemGap => '10px';

  @override
  String get itemPadding => '8px 12px';

  @override
  String get itemColor => 'var(--foreground)';

  @override
  String get itemBorderRadius => 'var(--nb-radius-soft, 4px)';

  @override
  String get transitionToken => 'var(--nb-transition, 120ms ease)';

  @override
  String get shortcutLetterSpacing => '0';

  @override
  String get selectablePaddingLeft => '36px';

  @override
  String get indicatorLeft => '12px';

  @override
  String get indicatorColor =>
      'var(--nb-selection-mark, var(--nb-accent, var(--primary)))';

  @override
  Map<String, String> menuStyles(DropdownMenuProps props) => <String, String>{
    'z-index': '100',
    if (props.width != null)
      'width': '${props.width}px'
    else
      'min-width': '180px',
    'padding': '6px',
    'overflow': 'hidden',
    'background': 'var(--nb-paper, var(--card))',
    'border': 'var(--nb-border-thick, 3px) solid var(--nb-line, #000)',
    'border-radius': 'var(--nb-radius-soft, 0)',
    'box-shadow':
        'var(--nb-shadow-md, 5px 5px 0 0 var(--nb-shadow-color, #000))',
    'color': 'var(--foreground)',
  };

  @override
  Map<String, String> get submenuMenuStyles => const <String, String>{
    'min-width': '180px',
    'padding': '6px',
    'background': 'var(--nb-paper, var(--card))',
    'border': 'var(--nb-border-thick, 3px) solid var(--nb-line, #000)',
    'box-shadow':
        'var(--nb-shadow-md, 5px 5px 0 0 var(--nb-shadow-color, #000))',
    'z-index': '101',
  };

  @override
  Component buildSeparator() => const dom.div(
    classes: 'neubrutalism-dropdown-separator',
    styles: dom.Styles(
      raw: <String, String>{
        'height': '2px',
        'margin': '6px -6px',
        'background': 'var(--nb-line, #000)',
      },
    ),
    <Component>[],
  );

  @override
  Component buildLabel(String label) => dom.div(
    classes: 'neubrutalism-dropdown-label',
    styles: const dom.Styles(
      raw: <String, String>{
        'padding': '8px 10px 4px',
        'font-family': 'var(--font-heading)',
        'font-size': '0.6875rem',
        'font-weight': '600',
        'letter-spacing': '0.12em',
        'text-transform': 'uppercase',
        'color': 'var(--muted-foreground)',
        'user-select': 'none',
      },
    ),
    <Component>[Component.text(label)],
  );
}
