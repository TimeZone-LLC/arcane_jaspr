import 'package:arcane_jaspr/core/rendering/base/context_menu_render_base.dart';

/// ShadCN-style context menu component.
///
/// Matches the v4 ContextMenuContent (`min-w-[8rem] rounded-md border
/// bg-popover p-1 shadow-md`) and ContextMenuItem (`rounded-sm px-2 py-1.5
/// text-sm gap-2`). Item background and foreground route through
/// `--shadcn-item-*` so the surfaces stylesheet can paint hover, focus and
/// open states.
///
/// Reference: https://ui.shadcn.com/docs/components/context-menu
class ShadcnContextMenu extends ContextMenuRenderBase {
  const ShadcnContextMenu(super.props, {super.key});

  @override
  String get themePrefix => 'arcane';

  @override
  String get popoverSuffix => '';

  static const Map<String, String> _surfaceStyles = <String, String>{
    'min-width': '8rem',
    'padding': '0.25rem',
    'background-color': 'var(--popover)',
    'color': 'var(--popover-foreground)',
    'border': '1px solid var(--border)',
    'border-radius': 'var(--radius-md)',
    'box-shadow': 'var(--shadcn-surface-shadow)',
  };

  @override
  Map<String, String> get menuStyles => const <String, String>{
    'z-index': '50',
    'overflow': 'hidden',
    ..._surfaceStyles,
  };

  @override
  Map<String, String> get separatorStyles => const <String, String>{
    'height': '1px',
    'margin': '0.25rem -0.25rem',
    'background-color': 'var(--border)',
  };

  @override
  Map<String, String> get labelStyles => const <String, String>{
    'padding': '0.375rem 0.5rem',
    'font-size': '0.875rem',
    'line-height': '1.25rem',
    'font-weight': '500',
    'color': 'inherit',
    'user-select': 'none',
  };

  Map<String, String> _itemStyles(
    bool disabled, {
    String? paddingLeft,
  }) => <String, String>{
    'position': 'relative',
    'display': 'flex',
    'align-items': 'center',
    'gap': '0.5rem',
    'padding': '0.375rem 0.5rem',
    'padding-left': ?paddingLeft,
    'border-radius': 'var(--shadcn-item-radius)',
    'font-size': '0.875rem',
    'line-height': '1.25rem',
    'background-color': 'var(--shadcn-item-background, transparent)',
    'color': 'var(--shadcn-item-foreground, inherit)',
    'cursor': 'default',
    'transition': 'color var(--transition), background-color var(--transition)',
    'user-select': 'none',
    'outline': 'none',
    if (disabled) 'pointer-events': 'none',
    if (disabled) 'opacity': '0.5',
  };

  @override
  Map<String, String> actionStyles(bool disabled) => _itemStyles(disabled);

  @override
  Map<String, String> selectableStyles(bool disabled) =>
      _itemStyles(disabled, paddingLeft: '2rem');

  @override
  Map<String, String> submenuTriggerStyles(bool disabled) =>
      _itemStyles(disabled);

  @override
  Map<String, String> get submenuStyles => const <String, String>{
    'z-index': '51',
    ..._surfaceStyles,
  };

  @override
  String get labelTextColor => 'inherit';

  @override
  String get indicatorColor => 'currentColor';

  @override
  String get indicatorLeft => '0.5rem';

  @override
  String get shortcutLetterSpacing => '0.1em';
}
