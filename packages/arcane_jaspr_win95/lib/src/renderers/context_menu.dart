import 'package:arcane_jaspr/core/rendering/base/context_menu_render_base.dart';

/// Win95-style context menu renderer (neutralized skeleton).
class Win95ContextMenu extends ContextMenuRenderBase {
  const Win95ContextMenu(super.props, {super.key});

  @override
  String get themePrefix => 'win95';

  @override
  String get popoverSuffix => ' win95-popover';

  @override
  Map<String, String> get menuStyles => const <String, String>{};

  @override
  Map<String, String> get separatorStyles => const <String, String>{};

  @override
  Map<String, String> get labelStyles => const <String, String>{};

  @override
  Map<String, String> actionStyles(bool disabled) => const <String, String>{};

  @override
  Map<String, String> selectableStyles(bool disabled) =>
      const <String, String>{};

  @override
  Map<String, String> submenuTriggerStyles(bool disabled) =>
      const <String, String>{};

  @override
  Map<String, String> get submenuStyles => const <String, String>{};

  @override
  String get labelTextColor => 'var(--foreground)';

  @override
  String get indicatorColor => 'currentColor';

  /// The check and bullet sit centred in the 24px gutter win95_css reserves.
  @override
  String get indicatorLeft => '6px';

  @override
  String get shortcutLetterSpacing => '0';
}
