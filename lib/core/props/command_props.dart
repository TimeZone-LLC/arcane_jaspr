import 'package:arcane_jaspr/flutter.dart';
import '../../component/view/icon.dart';

import '../../util/style_types/arcane_style_data.dart';
import '../decoration/arcane_decoration.dart';

/// Command item data.
class CommandItemProps {
  final String label;
  final ArcaneGlyph? icon;
  final String? shortcut;
  final void Function()? onSelect;
  final bool disabled;
  final List<String>? keywords;

  /// Optional href for JavaScript-based navigation.
  /// When set, clicking the item will navigate to this URL.
  /// Use '_blank' target by setting [hrefTarget].
  final String? href;

  /// Target for href navigation (e.g., '_blank' for new tab).
  final String? hrefTarget;

  const CommandItemProps({
    required this.label,
    this.icon,
    this.shortcut,
    this.onSelect,
    this.disabled = false,
    this.keywords,
    this.href,
    this.hrefTarget,
  });
}

/// Command group data.
class CommandGroupProps {
  final String? heading;
  final List<CommandItemProps> items;

  const CommandGroupProps({this.heading, required this.items});
}

/// Command palette component properties.
class CommandProps {
  final String? id;
  final bool isOpen;
  final void Function()? onClose;
  final List<CommandGroupProps> groups;
  final String placeholder;
  final String emptyMessage;
  final String searchQuery;
  final List<CommandItemProps> filteredItems;
  final void Function(String)? onSearch;
  final void Function(CommandItemProps)? onSelectItem;
  final bool escapeCloses;
  final bool scrimCloses;
  final bool focusTrap;
  final bool restoreFocus;

  /// The caller filters [groups] itself (through [onSearch]); the runtime
  /// leaves the items as given.
  final bool externalFilter;

  /// The overlay fades and the dialog scales in as it opens; false shows
  /// them at once.
  final bool animate;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation intent + theme-specific
  /// fields honored-or-ignored per theme).
  final ArcaneDecoration? decoration;

  const CommandProps({
    required this.isOpen,
    required this.groups,
    this.id,
    this.onClose,
    this.placeholder = 'Type a command or search...',
    this.emptyMessage = 'No results found.',
    this.searchQuery = '',
    this.filteredItems = const [],
    this.onSearch,
    this.onSelectItem,
    this.escapeCloses = true,
    this.scrimCloses = true,
    this.focusTrap = true,
    this.restoreFocus = true,
    this.externalFilter = false,
    this.animate = true,
    this.styles,
    this.decoration,
  });

  CommandProps copyWith({
    String? id,
    bool? isOpen,
    void Function()? onClose,
    List<CommandGroupProps>? groups,
    String? placeholder,
    String? emptyMessage,
    String? searchQuery,
    List<CommandItemProps>? filteredItems,
    void Function(String)? onSearch,
    void Function(CommandItemProps)? onSelectItem,
    bool? escapeCloses,
    bool? scrimCloses,
    bool? focusTrap,
    bool? restoreFocus,
    ArcaneStyleData? styles,
    ArcaneDecoration? decoration,
  }) {
    return CommandProps(
      id: id ?? this.id,
      isOpen: isOpen ?? this.isOpen,
      onClose: onClose ?? this.onClose,
      groups: groups ?? this.groups,
      placeholder: placeholder ?? this.placeholder,
      emptyMessage: emptyMessage ?? this.emptyMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      filteredItems: filteredItems ?? this.filteredItems,
      onSearch: onSearch ?? this.onSearch,
      onSelectItem: onSelectItem ?? this.onSelectItem,
      escapeCloses: escapeCloses ?? this.escapeCloses,
      scrimCloses: scrimCloses ?? this.scrimCloses,
      focusTrap: focusTrap ?? this.focusTrap,
      restoreFocus: restoreFocus ?? this.restoreFocus,
      styles: styles ?? this.styles,
      decoration: decoration ?? this.decoration,
    );
  }
}

// ============================================================================
// RENDERER CONTRACT
// ============================================================================

/// Mixin defining the renderer methods for command palette components.
mixin CommandRendererContract {
  Widget command(CommandProps props);
}
