import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/dropdown_menu_props.dart';
import 'package:arcane_jaspr/core/rendering/base/dropdown_menu_render_base.dart';

/// ShadCN DropdownMenu renderer.
///
/// Outputs the v4 dropdown-menu structure from ui.shadcn.com.
/// Reference: https://ui.shadcn.com/docs/components/dropdown-menu
///
/// ShadCN DropdownMenuContent:
/// - z-50 min-w-[8rem] overflow-hidden rounded-md border bg-popover p-1
///   text-popover-foreground shadow-md
///
/// ShadCN DropdownMenuItem:
/// - relative flex cursor-default select-none items-center gap-2 rounded-sm
///   px-2 py-1.5 text-sm outline-hidden
/// - focus:bg-accent focus:text-accent-foreground (flipped through
///   `--arcane-menu-item-*` by the surfaces stylesheet)
/// - data-[variant=destructive]:text-destructive
/// - data-[disabled]:pointer-events-none data-[disabled]:opacity-50
class ShadcnDropdownMenu extends DropdownMenuRenderBase {
  const ShadcnDropdownMenu(super.props, {super.key});

  @override
  String get rootClass => 'arcane-dropdown';

  @override
  String get triggerClass => 'arcane-dropdown-trigger';

  @override
  String get menuClass => 'arcane-dropdown-menu';

  @override
  String get itemClass => 'arcane-dropdown-item';

  @override
  String get submenuClass => 'arcane-dropdown-submenu';

  @override
  String get anchorOffset => '4';

  @override
  String get itemGap => '0.5rem';

  @override
  String get itemPadding => '0.375rem 0.5rem';

  @override
  String get itemColor => 'var(--popover-foreground)';

  @override
  String get itemBorderRadius => 'var(--shadcn-item-radius)';

  @override
  String get transitionToken => 'var(--transition)';

  @override
  String get shortcutLetterSpacing => '0.1em';

  @override
  String get selectablePaddingLeft => '2rem';

  @override
  String get indicatorLeft => '0.5rem';

  @override
  String get indicatorColor => 'currentColor';

  @override
  Map<String, String> menuStyles(DropdownMenuProps props) => <String, String>{
    'z-index': '50',
    if (props.width != null)
      'width': '${props.width}px'
    else
      'min-width': '8rem',
    'padding': '0.25rem',
    'background-color': 'var(--popover)',
    'border': '1px solid var(--border)',
    'border-radius': 'var(--radius-md)',
    'box-shadow': 'var(--shadcn-surface-shadow)',
    'overflow': 'hidden',
    'color': 'var(--popover-foreground)',
    'animation': 'arcane-dropdown-fade var(--transition)',
  };

  @override
  Map<String, String> get submenuMenuStyles => const <String, String>{
    'min-width': '8rem',
    'padding': '0.25rem',
    'background-color': 'var(--popover)',
    'color': 'var(--popover-foreground)',
    'border': '1px solid var(--border)',
    'border-radius': 'var(--radius-md)',
    'box-shadow': 'var(--shadcn-surface-shadow)',
    'z-index': '51',
  };

  @override
  Component buildSeparator() => const dom.div(
    classes: 'arcane-dropdown-divider',
    attributes: <String, String>{'role': 'separator'},
    styles: dom.Styles(
      raw: <String, String>{
        'height': '1px',
        'margin': '0.25rem -0.25rem',
        'background-color': 'var(--border)',
      },
    ),
    <Component>[],
  );

  @override
  Component buildLabel(String label) => dom.div(
    classes: 'arcane-dropdown-label',
    styles: const dom.Styles(
      raw: <String, String>{
        'padding': '0.375rem 0.5rem',
        'font-size': '0.875rem',
        'line-height': '1.25rem',
        'font-weight': '500',
        'color': 'inherit',
        'user-select': 'none',
      },
    ),
    <Component>[Component.text(label)],
  );
}
