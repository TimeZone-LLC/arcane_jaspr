import 'package:arcane_jaspr/core/rendering/base/static_table_render_base.dart';

/// Neubrutalism Static Table renderer.
class NeubrutalismStaticTable extends StaticTableRenderBase {
  const NeubrutalismStaticTable(super.props, {super.key});

  @override
  String get classPrefix => 'neubrutalism';

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
  Map<String, String> headerCellStyles(String textAlign) => <String, String>{
    'padding': '1rem 1.5rem',
    'text-align': textAlign,
    'font-family': 'var(--font-sans)',
    'font-size': '0.8125rem',
    'font-weight': '700',
    'letter-spacing': '0.04em',
    'text-transform': 'uppercase',
    'color': 'inherit',
    'white-space': 'nowrap',
  };

  @override
  Map<String, String> rowStyles(int rowIndex) => <String, String>{
    'background': props.striped && rowIndex.isOdd
        ? 'var(--nb-paper-soft, var(--card))'
        : 'transparent',
    if (props.showDividers && rowIndex < props.rows.length - 1)
      'border-bottom': 'var(--nb-border-thin, 2px) solid var(--nb-line, #000)',
  };
}

/// Neubrutalism Key-Value Table renderer.
class NeubrutalismKeyValueTable extends KeyValueTableRenderBase {
  const NeubrutalismKeyValueTable(super.props, {super.key});

  @override
  String get classPrefix => 'neubrutalism';

  @override
  Map<String, String> get containerStyles => const <String, String>{
    'border': 'var(--nb-border-thin, 2px) solid var(--nb-line, #000)',
    'background': 'var(--nb-paper, var(--card))',
    'box-shadow':
        'var(--nb-shadow-md, 5px 5px 0 0 var(--nb-shadow-color, #000))',
    'overflow': 'hidden',
  };

  @override
  String get dividerBorder =>
      'var(--nb-border-thin, 2px) solid var(--nb-line, #000)';

  @override
  Map<String, String> get keyLeadingStyles => const <String, String>{
    'padding': '1rem 1.5rem',
    'background': 'transparent',
    'font-family': 'var(--font-heading)',
    'font-size': 'var(--font-size-xs)',
    'font-weight': 'var(--font-weight-semibold)',
    'letter-spacing': '0.08em',
    'text-transform': 'uppercase',
    'color': 'var(--muted-foreground)',
  };

  @override
  Map<String, String> get valueStyles => const <String, String>{
    'flex': '1',
    'padding': '1rem 1.5rem',
    'background': 'transparent',
    'color': 'var(--foreground)',
    'font-size': 'var(--font-size-sm)',
  };
}
