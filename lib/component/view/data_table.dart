import 'package:arcane_jaspr/flutter.dart';

import '../../core/theme_provider.dart';

export 'package:arcane_jaspr/core/props/data_table_props.dart'
    show DataTableTextAlign;

class DataColumn<T> {
  final String header;
  final Widget Function(T item) builder;
  final DataTableTextAlign align;
  final double? width;
  final bool sortable;

  const DataColumn({
    required this.header,
    required this.builder,
    this.align = DataTableTextAlign.left,
    this.width,
    this.sortable = false,
  });
}

class DataTable<T> extends StatefulWidget {
  final List<T> items;
  final List<DataColumn<T>> columns;
  final void Function(T item)? onRowTap;
  final bool selectable;
  final Set<T>? selectedItems;
  final void Function(Set<T> selected)? onSelectionChanged;
  final bool showDividers;
  final bool showHeader;
  final bool stickyHeader;
  final String emptyMessage;

  const DataTable({
    required this.items,
    required this.columns,
    this.onRowTap,
    this.selectable = false,
    this.selectedItems,
    this.onSelectionChanged,
    this.showDividers = true,
    this.showHeader = true,
    this.stickyHeader = false,
    this.emptyMessage = 'No data available',
    super.key,
  });

  @override
  State<DataTable<T>> createState() => _DataTableState<T>();
}

class _DataTableState<T> extends State<DataTable<T>> {
  late Set<T> _selectedItems;

  @override
  void initState() {
    super.initState();
    _selectedItems = widget.selectedItems ?? <T>{};
  }

  @override
  void didUpdateWidget(DataTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedItems != null) {
      _selectedItems = widget.selectedItems!;
    }
  }

  void _toggleSelection(T item) {
    setState(() {
      if (_selectedItems.contains(item)) {
        _selectedItems.remove(item);
      } else {
        _selectedItems.add(item);
      }
    });
    widget.onSelectionChanged?.call(Set<T>.from(_selectedItems));
  }

  void _toggleSelectAll() {
    setState(() {
      if (_selectedItems.length == widget.items.length) {
        _selectedItems.clear();
      } else {
        _selectedItems = Set<T>.from(widget.items);
      }
    });
    widget.onSelectionChanged?.call(Set<T>.from(_selectedItems));
  }

  @override
  Widget build(BuildContext context) {
    final List<DataColumnProps<T>> columnProps = widget.columns
        .map(
          (DataColumn<T> column) => DataColumnProps<T>(
            header: column.header,
            builder: column.builder,
            align: column.align,
            width: column.width,
            sortable: column.sortable,
          ),
        )
        .toList();

    return context.renderers.dataTable<T>(
      DataTableProps<T>(
        items: widget.items,
        columns: columnProps,
        onRowTap: widget.onRowTap,
        selectable: widget.selectable,
        selectedItems: _selectedItems,
        showDividers: widget.showDividers,
        showHeader: widget.showHeader,
        stickyHeader: widget.stickyHeader,
        emptyMessage: widget.emptyMessage,
        onToggleSelection: _toggleSelection,
        onToggleSelectAll: _toggleSelectAll,
      ),
    );
  }
}
