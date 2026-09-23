import 'package:arcane_jaspr/core/rendering/base/chart_render_base.dart';

class ShadcnChart extends ChartRenderBase {
  const ShadcnChart(super.props, {super.key});

  @override
  String get cssClass => 'arcane-chart';

  @override
  Map<String, String> get rootStyles => const <String, String>{
    'display': 'flex',
    'flex-direction': 'column',
    'gap': '0.75rem',
    'padding': '1rem',
    'border': '1px solid var(--border)',
    'border-radius': 'var(--radius-md)',
    'background': 'var(--card)',
    'color': 'var(--card-foreground)',
    'box-shadow': 'var(--shadow-sm)',
  };

  @override
  Map<String, String> get titleStyles => const <String, String>{
    'font-size': '1rem',
    'font-weight': '600',
    'color': 'var(--card-foreground)',
  };

  @override
  Map<String, String> get descriptionStyles => const <String, String>{
    'font-size': '0.875rem',
    'color': 'var(--muted-foreground)',
  };

  @override
  Map<String, String> get pointRowStyles => const <String, String>{
    'display': 'flex',
    'align-items': 'center',
    'gap': '0.5rem',
  };

  @override
  Map<String, String> get pointLabelStyles => const <String, String>{
    'width': '5rem',
    'font-size': '0.75rem',
    'color': 'var(--muted-foreground)',
  };

  @override
  Map<String, String> get trackStyles => const <String, String>{
    'height': '0.5rem',
    'flex': '1',
    'border-radius': 'var(--radius-md)',
    'background': 'var(--muted)',
    'overflow': 'hidden',
  };

  @override
  Map<String, String> fillStyles(String width) => <String, String>{
    'height': '100%',
    'width': width,
    'background': props.color,
    'border-radius': 'inherit',
  };

  @override
  Map<String, String> get pointValueStyles => const <String, String>{
    'font-size': '0.75rem',
    'font-weight': '500',
    'color': 'var(--foreground)',
  };
}
