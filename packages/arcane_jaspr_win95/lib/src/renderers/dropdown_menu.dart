import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/dropdown_menu_props.dart';
import 'package:arcane_jaspr/core/rendering/base/dropdown_menu_render_base.dart';

/// Win95 DropdownMenu renderer.
class Win95DropdownMenu extends DropdownMenuRenderBase {
  const Win95DropdownMenu(super.props, {super.key});

  @override
  String get rootClass => 'win95-dropdown';

  @override
  String get triggerClass => 'win95-dropdown-trigger';

  @override
  String get menuClass => 'win95-dropdown-menu win95-popover';

  @override
  String get itemClass => 'win95-dropdown-item';

  @override
  String get submenuClass => 'win95-dropdown-submenu win95-popover';

  /// Win95 menus open flush against their button.
  @override
  String get anchorOffset => '0';

  @override
  String get itemGap => '10px';

  @override
  String get itemPadding => '8px 12px';

  @override
  String get itemColor => 'var(--foreground)';

  @override
  String get itemBorderRadius => 'var(--radius)';

  /// Interpolated into a property list ("color $token, background-color
  /// $token"), so this is a duration rather than the `none` keyword — a Win95
  /// menu item highlighted in a single repaint.
  @override
  String get transitionToken => '0s';

  @override
  String get shortcutLetterSpacing => '0';

  @override
  String get selectablePaddingLeft => '36px';

  /// The check and bullet sit centred in the 24px gutter win95_css reserves.
  @override
  String get indicatorLeft => '6px';

  @override
  String get indicatorColor => 'var(--foreground)';

  @override
  Map<String, String> menuStyles(DropdownMenuProps props) =>
      const <String, String>{};

  @override
  Map<String, String> get submenuMenuStyles => const <String, String>{};

  @override
  Component buildSeparator() => const dom.div(
    classes: 'win95-dropdown-divider',
    <Component>[],
  );

  @override
  Component buildLabel(String label) => dom.div(
    classes: 'win95-dropdown-label',
    <Component>[Component.text(label)],
  );
}
