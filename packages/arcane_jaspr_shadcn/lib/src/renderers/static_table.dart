import 'package:arcane_jaspr/core/rendering/base/static_table_render_base.dart';

/// ShadCN Static Table renderer.
///
/// Mirrors the ShadCN Table: no header fill, 40px header row, hairline row
/// dividers and a muted/50 row hover driven by `--shadcn-item-background`.
/// Body cell padding is fixed inline by the shared core base, so the display
/// CSS narrows it to `p-2`.
/// Reference: https://ui.shadcn.com/docs/components/table
class ShadcnStaticTable extends StaticTableRenderBase {
  const ShadcnStaticTable(super.props, {super.key});

  @override
  String get classPrefix => 'arcane';

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

  @override
  Map<String, String> theadBaseStyles() => <String, String>{
    if (props.stickyHeader) 'background-color': 'var(--background)',
  };

  // TableHead: h-10 px-2 text-left align-middle font-medium text-foreground
  @override
  Map<String, String> headerCellStyles(String textAlign) => <String, String>{
    'height': '2.5rem',
    'padding': '0 0.5rem',
    'text-align': textAlign,
    'vertical-align': 'middle',
    'font-weight': '500',
    'color': 'var(--foreground)',
    'white-space': 'nowrap',
  };

  // TableRow: border-b hover:bg-muted/50. Striped rows rest on a lighter
  // muted wash so hover still reads.
  @override
  Map<String, String> rowStyles(int rowIndex) => <String, String>{
    'background-color': props.striped && rowIndex.isOdd
        ? 'var(--shadcn-item-background, color-mix(in srgb, var(--muted) 30%, transparent))'
        : 'var(--shadcn-item-background, transparent)',
    if (props.showDividers && rowIndex < props.rows.length - 1)
      'border-bottom': '1px solid var(--border)',
    'transition': 'background-color var(--transition)',
  };
}

/// ShadCN Key-Value Table renderer.
class ShadcnKeyValueTable extends KeyValueTableRenderBase {
  const ShadcnKeyValueTable(super.props, {super.key});

  @override
  String get classPrefix => 'arcane';

  @override
  Map<String, String> get containerStyles => const <String, String>{
    'border': '1px solid var(--border)',
    'border-radius': 'var(--radius-md)',
    'overflow': 'hidden',
  };

  @override
  String get dividerBorder => '1px solid var(--border)';

  // Keys read as quiet labels (no header-style fill), matching the
  // header-less ShadCN table idiom.
  @override
  Map<String, String> get keyLeadingStyles => const <String, String>{
    'padding': '1rem 1.5rem',
    'background-color': 'transparent',
    'font-weight': 'var(--font-weight-medium)',
    'color': 'var(--muted-foreground)',
    'font-size': 'var(--font-size-sm)',
  };

  @override
  Map<String, String> get valueStyles => const <String, String>{
    'flex': '1',
    'padding': '1rem 1.5rem',
    'background-color': 'transparent',
    'color': 'var(--foreground)',
    'font-size': 'var(--font-size-sm)',
  };
}
