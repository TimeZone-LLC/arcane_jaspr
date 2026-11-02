import 'package:arcane_jaspr/core/props/data_table_props.dart';
import 'package:arcane_jaspr/core/rendering/base/data_table_render_base.dart';

/// Neubrutalism DataTable renderer.
class NeubrutalismDataTable<T> extends DataTableRenderBase<T> {
  const NeubrutalismDataTable(super.props, {super.key});

  @override
  String get classPrefix => 'neubrutalism';

  @override
  String get emptyPadding => '60px 30px';

  @override
  Map<String, String> get containerStyles => const <String, String>{
    'overflow-x': 'auto',
    'border': 'var(--nb-border-thin, 2px) solid var(--nb-line, #000)',
    'background': 'var(--nb-paper, var(--card))',
    'box-shadow':
        'var(--nb-shadow-md, 5px 5px 0 0 var(--nb-shadow-color, #000))',
  };

  @override
  Map<String, String> get tableStyles => const <String, String>{
    'width': '100%',
    'border-collapse': 'collapse',
    'font-size': 'var(--font-size-sm)',
    'font-variant-numeric': 'tabular-nums',
  };

  @override
  Map<String, String> theadBaseStyles() => const <String, String>{
    'background': 'transparent',
    'border-bottom': 'var(--nb-border-thin, 2px) solid var(--nb-line, #000)',
  };

  @override
  String get cellPadding => '14px 20px';

  @override
  String get selectAllWidth => '56px';

  @override
  Map<String, String>? get checkboxStyles => const <String, String>{
    'accent-color': 'var(--nb-accent, var(--primary))',
  };

  @override
  Map<String, String> headerCellStyles(DataColumnProps<T> column) =>
      <String, String>{
        'padding': '14px 20px',
        'text-align': column.align.css,
        'font-family': 'var(--font-sans)',
        'font-size': '0.8125rem',
        'font-weight': '700',
        'letter-spacing': '0.04em',
        'text-transform': 'uppercase',
        'color': 'inherit',
        'white-space': 'nowrap',
        if (column.width != null) 'width': '${column.width}px',
      };

  @override
  Map<String, String> rowStyles(
    bool isSelected,
    bool isClickable,
  ) => <String, String>{
    'background': isSelected
        ? 'var(--nb-accent, var(--primary))'
        : 'transparent',
    'color': isSelected
        ? 'var(--nb-on-accent, var(--primary-foreground))'
        : 'var(--foreground)',
    if (props.showDividers)
      'border-bottom': 'var(--nb-border-thin, 2px) solid var(--nb-line, #000)',
    if (isClickable) 'cursor': 'pointer',
    'transition': 'background-color 140ms ease',
  };

  @override
  Map<String, String>? get bodyStyles => null;
}
