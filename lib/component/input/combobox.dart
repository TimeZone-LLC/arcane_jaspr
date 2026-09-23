import 'package:arcane_jaspr/flutter.dart';

import '../../core/decoration/arcane_decoration.dart';
import '../../core/interaction/interaction.dart';
import '../../core/theme_provider.dart';
import '../../util/style_types/arcane_style_data.dart';
import '../view/icon.dart';

export '../../core/props/select_props.dart'
    show ComponentSize, SelectProps, SelectOptionProps;

/// An autocomplete combobox with search filtering.
class ArcaneCombobox<T> extends StatefulWidget {
  final List<ComboboxOption<T>> options;
  final T? value;
  final void Function(T?)? onChanged;
  final String? placeholder;
  final String? searchPlaceholder;
  final bool searchable;
  final String Function(T)? displayValue;
  final bool Function(ComboboxOption<T>, String)? filterFn;
  final String emptyMessage;
  final bool disabled;
  final String? error;
  final String? label;
  final ComboboxSize size;
  final String? id;
  final String? group;
  final ArcaneInteraction? onChangedAction;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation intent + theme-specific
  /// fields honored-or-ignored per theme).
  final ArcaneDecoration? decoration;

  const ArcaneCombobox({
    required this.options,
    this.value,
    this.onChanged,
    this.placeholder,
    this.searchPlaceholder,
    this.searchable = true,
    this.displayValue,
    this.filterFn,
    this.emptyMessage = 'No results found',
    this.disabled = false,
    this.error,
    this.label,
    this.size = ComboboxSize.md,
    this.id,
    this.group,
    this.onChangedAction,
    this.styles,
    this.decoration,
    super.key,
  });

  @override
  State<ArcaneCombobox<T>> createState() => _ArcaneComboboxState<T>();
}

class _ArcaneComboboxState<T> extends State<ArcaneCombobox<T>> {
  bool _isOpen = false;
  String _searchQuery = '';

  List<ComboboxOption<T>> get _filteredOptions {
    if (_searchQuery.isEmpty) return widget.options;

    final query = _searchQuery.toLowerCase();
    return widget.options.where((option) {
      if (widget.filterFn != null) {
        return widget.filterFn!(option, _searchQuery);
      }
      return option.label.toLowerCase().contains(query) ||
          (option.keywords?.any((k) => k.toLowerCase().contains(query)) ??
              false);
    }).toList();
  }

  void _toggleOpen() {
    if (widget.disabled) return;
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        _searchQuery = '';
      }
    });
  }

  void _selectOption(T value) {
    widget.onChanged?.call(value);
    setState(() {
      _isOpen = false;
      _searchQuery = '';
    });
  }

  void _handleSearch(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  ComponentSize get _propsSize => switch (widget.size) {
    ComboboxSize.sm => ComponentSize.sm,
    ComboboxSize.md => ComponentSize.md,
    ComboboxSize.lg => ComponentSize.lg,
  };

  @override
  Widget build(BuildContext context) {
    final selectOptions = widget.options
        .map(
          (opt) => SelectOptionProps<T>(
            value: opt.value,
            label: opt.label,
            description: opt.description,
            icon: opt.icon,
            disabled: opt.disabled,
            searchKeywords: opt.keywords,
          ),
        )
        .toList();

    final filteredSelectOptions = _filteredOptions
        .map(
          (opt) => SelectOptionProps<T>(
            value: opt.value,
            label: opt.label,
            description: opt.description,
            icon: opt.icon,
            disabled: opt.disabled,
            searchKeywords: opt.keywords,
          ),
        )
        .toList();

    return context.renderers.select<T>(
      SelectProps<T>(
        options: selectOptions,
        value: widget.value,
        placeholder: widget.placeholder ?? 'Select...',
        disabled: widget.disabled,
        searchable: widget.searchable,
        label: widget.label,
        error: widget.error,
        size: _propsSize,
        emptyMessage: widget.emptyMessage,
        searchPlaceholder: widget.searchPlaceholder ?? 'Search...',
        isOpen: _isOpen,
        searchQuery: _searchQuery,
        filteredOptions: filteredSelectOptions,
        onToggle: _toggleOpen,
        onSelect: _selectOption,
        onSearchChange: _handleSearch,
        id: widget.id,
        group: widget.group,
        onSelectAction: widget.onChangedAction,
        styles: widget.styles,
        decoration: widget.decoration,
      ),
    );
  }
}

/// A combobox option.
class ComboboxOption<T> {
  final T value;
  final String label;
  final String? description;
  final ArcaneGlyph? icon;
  final bool disabled;
  final List<String>? keywords;

  const ComboboxOption({
    required this.value,
    required this.label,
    this.description,
    this.icon,
    this.disabled = false,
    this.keywords,
  });
}

/// Size variants for combobox.
enum ComboboxSize { sm, md, lg }
