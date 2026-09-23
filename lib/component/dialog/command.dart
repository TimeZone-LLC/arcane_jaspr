import 'package:arcane_jaspr/flutter.dart';

import '../../core/decoration/arcane_decoration.dart';
import '../../core/theme_provider.dart';
import '../../util/style_types/arcane_style_data.dart';
import '../view/icon.dart';

export '../../core/props/command_props.dart'
    show CommandItemProps, CommandGroupProps;

/// Command palette for quick actions and navigation.
class ArcaneCommand extends StatefulWidget {
  final String? id;
  final bool isOpen;
  final void Function()? onClose;
  final List<CommandGroup> groups;
  final String placeholder;
  final String emptyMessage;
  final void Function(String)? onSearch;
  final bool Function(CommandItem, String)? filterFn;
  final bool escapeCloses;
  final bool scrimCloses;
  final bool focusTrap;
  final bool restoreFocus;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation + theme-specific fields).
  final ArcaneDecoration? decoration;

  const ArcaneCommand({
    required this.groups,
    this.id,
    this.isOpen = false,
    this.onClose,
    this.placeholder = 'Type a command or search...',
    this.emptyMessage = 'No results found.',
    this.onSearch,
    this.filterFn,
    this.escapeCloses = true,
    this.scrimCloses = true,
    this.focusTrap = true,
    this.restoreFocus = true,
    this.styles,
    this.decoration,
    super.key,
  });

  @override
  State<ArcaneCommand> createState() => _ArcaneCommandState();
}

class _ArcaneCommandState extends State<ArcaneCommand> {
  String _searchQuery = '';

  List<CommandItem> get _allItems {
    return widget.groups.expand((g) => g.items).toList();
  }

  List<CommandItem> get _filteredItems {
    if (_searchQuery.isEmpty) return _allItems;

    final query = _searchQuery.toLowerCase();
    return _allItems.where((item) {
      if (widget.filterFn != null) {
        return widget.filterFn!(item, _searchQuery);
      }
      return item.label.toLowerCase().contains(query) ||
          (item.keywords?.any((k) => k.toLowerCase().contains(query)) ?? false);
    }).toList();
  }

  void _handleSearch(String value) {
    setState(() {
      _searchQuery = value;
    });
    widget.onSearch?.call(value);
  }

  void _selectItem(CommandItemProps item) {
    item.onSelect?.call();
    widget.onClose?.call();
  }

  @override
  Widget build(BuildContext context) {
    final groupProps = widget.groups
        .map(
          (g) => CommandGroupProps(
            heading: g.heading,
            items: g.items
                .map(
                  (i) => CommandItemProps(
                    label: i.label,
                    icon: i.icon,
                    shortcut: i.shortcut,
                    onSelect: i.onSelect,
                    disabled: i.disabled,
                    keywords: i.keywords,
                    href: i.href,
                    hrefTarget: i.hrefTarget,
                  ),
                )
                .toList(),
          ),
        )
        .toList();

    final filteredItemProps = _filteredItems
        .map(
          (i) => CommandItemProps(
            label: i.label,
            icon: i.icon,
            shortcut: i.shortcut,
            onSelect: i.onSelect,
            disabled: i.disabled,
            keywords: i.keywords,
            href: i.href,
            hrefTarget: i.hrefTarget,
          ),
        )
        .toList();

    return context.renderers.command(
      CommandProps(
        id: widget.id,
        isOpen: widget.isOpen,
        onClose: widget.onClose,
        groups: groupProps,
        placeholder: widget.placeholder,
        emptyMessage: widget.emptyMessage,
        searchQuery: _searchQuery,
        filteredItems: filteredItemProps,
        onSearch: _handleSearch,
        onSelectItem: _selectItem,
        escapeCloses: widget.escapeCloses,
        scrimCloses: widget.scrimCloses,
        focusTrap: widget.focusTrap,
        restoreFocus: widget.restoreFocus,
        styles: widget.styles,
        decoration: widget.decoration,
      ),
    );
  }
}

/// A group of related commands.
class CommandGroup {
  final String? heading;
  final List<CommandItem> items;

  const CommandGroup({this.heading, required this.items});
}

/// A single command item.
class CommandItem {
  final String label;
  final ArcaneGlyph? icon;
  final String? shortcut;
  final void Function()? onSelect;
  final bool disabled;
  final List<String>? keywords;

  /// Optional href for JavaScript-based navigation.
  final String? href;

  /// Target for href navigation (e.g., '_blank' for new tab).
  final String? hrefTarget;

  const CommandItem({
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
