import 'package:arcane_jaspr/core/props/data_table_props.dart';
import 'package:arcane_jaspr/core/rendering/base/data_table_render_base.dart';

/// ShadCN DataTable renderer.
///
/// Outputs data table HTML matching the ShadCN/ui design language: no header
/// fill, 40px header row, hairline row dividers and a muted/50 row hover that
/// the display CSS drives through `--shadcn-item-background`.
/// Reference: https://ui.shadcn.com/docs/components/data-table
class ShadcnDataTable<T> extends DataTableRenderBase<T> {
  const ShadcnDataTable(super.props, {super.key});

  @override
  String get classPrefix => 'arcane';

  @override
  String get emptyPadding => '48px 24px';

  // The data-table demo wraps Table in `overflow-hidden rounded-md border`.
  @override
  Map<String, String> get containerStyles => const <String, String>{
    'position': 'relative',
    'width': '100%',
    'overflow-x': 'auto',
    'border': '1px solid var(--border)',
    'border-radius': 'var(--radius-md)',
  };

  @override
  Map<String, String> get tableStyles => const <String, String>{
    'width': '100%',
    'border-collapse': 'collapse',
    'caption-side': 'bottom',
    'font-size': '0.875rem',
  };

  // TableHeader has no fill. A sticky header needs an opaque band so rows do
  // not scroll through it.
  @override
  Map<String, String> theadBaseStyles() => <String, String>{
    if (props.stickyHeader) 'background-color': 'var(--background)',
  };

  @override
  String get cellPadding => '0.5rem';

  @override
  String get selectAllWidth => '2.5rem';

  @override
  Map<String, String>? get checkboxStyles => null;

  // TableHead: h-10 px-2 text-left align-middle font-medium text-foreground
  // whitespace-nowrap
  @override
  Map<String, String> headerCellStyles(DataColumnProps<T> column) =>
      <String, String>{
        'height': '2.5rem',
        'padding': '0 0.5rem',
        'text-align': column.align.css,
        'vertical-align': 'middle',
        'font-weight': '500',
        'color': 'var(--foreground)',
        'white-space': 'nowrap',
        if (column.width != null) 'width': '${column.width}px',
      };

  // TableRow: border-b transition-colors hover:bg-muted/50
  // data-[state=selected]:bg-muted. The last-row divider is dropped in CSS
  // through `--shadcn-table-row-border` so it never doubles the frame.
  @override
  Map<String, String> rowStyles(bool isSelected, bool isClickable) =>
      <String, String>{
        'background-color': isSelected
            ? 'var(--shadcn-item-background, var(--muted))'
            : 'var(--shadcn-item-background, transparent)',
        if (props.showDividers)
          'border-bottom':
              'var(--shadcn-table-row-border, 1px solid var(--border))',
        if (isClickable) 'cursor': 'pointer',
        'transition': 'background-color var(--transition)',
      };

  @override
  Map<String, String>? get bodyStyles => const <String, String>{};
}
