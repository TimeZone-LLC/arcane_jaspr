import 'package:arcane_jaspr/flutter.dart';
import '../../component/view/icon.dart';

import '../../util/style_types/arcane_style_data.dart';
import '../decoration/arcane_decoration.dart';
import '../interaction/interaction.dart';
import '../shared/shared.dart';

export '../shared/shared.dart' show ComponentSize;

enum SelectDropdownDirection { up, down }

/// Select option data.
class SelectOptionProps<T> {
  final T value;
  final String label;
  final String? subtitle;
  final String? description;
  final ArcaneGlyph? icon;
  final bool disabled;
  final List<String>? searchKeywords;

  /// A heading the option is listed under.
  final String? group;

  /// A picture before the label.
  final Widget? leading;

  const SelectOptionProps({
    required this.value,
    required this.label,
    this.subtitle,
    this.description,
    this.icon,
    this.disabled = false,
    this.searchKeywords,
    this.group,
    this.leading,
  });
}

/// Select component properties.
class SelectProps<T> {
  final List<SelectOptionProps<T>> options;
  final T? value;
  final List<T>? values;
  final String placeholder;
  final bool disabled;
  final bool clearable;
  final bool searchable;
  final bool multiSelect;
  final String? label;
  final String? helperText;
  final String? error;
  final ComponentSize size;
  final bool required;
  final String? maxDropdownHeight;
  final bool loading;
  final String loadingText;
  final String emptyMessage;
  final String searchPlaceholder;
  final SelectDropdownDirection dropdownDirection;
  final bool closeOnSelect;
  final bool showSelectedCount;
  final Widget? prefix;
  final int? maxSelections;
  final bool showCheckboxes;
  final bool isOpen;
  final String searchQuery;
  final List<SelectOptionProps<T>> filteredOptions;
  final void Function()? onToggle;
  final void Function(T value)? onSelect;
  final void Function()? onClear;
  final void Function(String query)? onSearchChange;
  final String? id;
  final String? group;
  final ArcaneInteraction? onSelectAction;

  /// Rows under the options (actions such as "New" or "Manage").
  final Widget? footer;

  /// The trigger button's id; defaults to `<id>-trigger`.
  final String? triggerId;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation intent + theme-specific
  /// fields honored-or-ignored per theme).
  final ArcaneDecoration? decoration;

  const SelectProps({
    required this.options,
    this.value,
    this.values,
    this.placeholder = 'Select...',
    this.disabled = false,
    this.clearable = false,
    this.searchable = false,
    this.multiSelect = false,
    this.label,
    this.helperText,
    this.error,
    this.size = ComponentSize.md,
    this.required = false,
    this.maxDropdownHeight,
    this.loading = false,
    this.loadingText = 'Loading...',
    this.emptyMessage = 'No options found',
    this.searchPlaceholder = 'Search...',
    this.dropdownDirection = SelectDropdownDirection.down,
    this.closeOnSelect = true,
    this.showSelectedCount = true,
    this.prefix,
    this.maxSelections,
    this.showCheckboxes = true,
    this.isOpen = false,
    this.searchQuery = '',
    this.filteredOptions = const [],
    this.onToggle,
    this.onSelect,
    this.onClear,
    this.onSearchChange,
    this.id,
    this.group,
    this.onSelectAction,
    this.footer,
    this.triggerId,
    this.styles,
    this.decoration,
  });
}

// ============================================================================
// RENDERER CONTRACT
// ============================================================================

/// Mixin defining the renderer methods for select components.
mixin SelectRendererContract {
  Widget select<T>(SelectProps<T> props);
}
