import 'package:arcane_jaspr/core/props/status_badge_props.dart';
import 'package:arcane_jaspr/core/rendering/base/status_badge_render_base.dart';

class NeubrutalismStatusBadge extends StatusBadgeRenderBase {
  const NeubrutalismStatusBadge(super.props, {super.key});

  @override
  String get classPrefix => 'neubrutalism';

  @override
  Map<String, String>? variantBadgeAttributes(StatusBadgeProps props) =>
      <String, String>{
        'data-variant': props.variant.name,
        'data-size': props.size.name,
      };

  @override
  Map<String, String>? statusBadgeAttributes(StatusBadgeProps props) =>
      <String, String>{
        'data-state': props.status.name,
        'data-size': props.size.name,
      };

  @override
  String indicatorSize(StatusBadgeProps props) => switch (props.size) {
    ComponentSize.sm => '8px',
    ComponentSize.md => '8px',
    ComponentSize.lg => '10px',
  };

  @override
  String statusFontSize(StatusBadgeProps props) => switch (props.size) {
    ComponentSize.sm => '0.6875rem',
    ComponentSize.md => '0.75rem',
    ComponentSize.lg => '0.875rem',
  };

  String _statusPadding(StatusBadgeProps props) => switch (props.size) {
    ComponentSize.sm => '0.25rem 0.625rem',
    ComponentSize.md => '0.25rem 0.75rem',
    ComponentSize.lg => '0.375rem 1rem',
  };

  Map<String, String> _statusContainerStyles(StatusBadgeProps props) {
    final String effectiveBackground =
        props.background ?? 'var(--nb-paper, var(--card))';
    final String effectiveBorder = props.borderColor ?? 'var(--nb-line, #000)';
    return <String, String>{
      'display': 'inline-flex',
      'align-items': 'center',
      'gap': '0.4375rem',
      'padding': _statusPadding(props),
      'background': effectiveBackground,
      'border': 'var(--nb-border-thin, 2px) solid $effectiveBorder',
      'border-radius': 'var(--nb-radius-soft, 0)',
      'box-shadow':
          'var(--nb-shadow-sm, 3px 3px 0 0 var(--nb-shadow-color, #000))',
    };
  }

  Map<String, String> _dotStyles(StatusBadgeProps props, String color) {
    final String size = indicatorSize(props);
    return <String, String>{
      'width': size,
      'height': size,
      'border-radius': '50%',
      'background': color,
      'border': 'var(--nb-border-thin, 2px) solid var(--nb-line, #000)',
      'flex-shrink': '0',
    };
  }

  @override
  Map<String, String> labelStyles(
    StatusBadgeProps props,
    String effectiveLabelColor,
  ) => <String, String>{
    'font-family': 'var(--font-mono)',
    'font-size': statusFontSize(props),
    'font-weight': '400',
    'color': effectiveLabelColor,
    'white-space': 'nowrap',
    'letter-spacing': '0.05em',
    'text-transform': 'uppercase',
  };

  @override
  String statusLabelColor(StatusBadgeProps props) =>
      props.labelColor ?? 'var(--foreground)';

  String _cardPadding(StatusBadgeProps props) => switch (props.size) {
    ComponentSize.sm => '0.25rem 0.625rem',
    ComponentSize.md => '0.25rem 0.75rem',
    ComponentSize.lg => '0.375rem 1rem',
  };

  String _cardFontSize(StatusBadgeProps props) => switch (props.size) {
    ComponentSize.sm => '0.6875rem',
    ComponentSize.md => '0.75rem',
    ComponentSize.lg => '0.875rem',
  };

  @override
  Map<String, String> cardBaseStyles(
    StatusBadgeProps props,
  ) => <String, String>{
    'display': 'inline-flex',
    'align-items': 'center',
    'gap': '0.375rem',
    'font-family': 'var(--font-mono)',
    'font-size': _cardFontSize(props),
    'font-weight': '400',
    'line-height': '1.7',
    'white-space': 'nowrap',
    'padding': _cardPadding(props),
    'letter-spacing': '0.05em',
    'text-transform': 'uppercase',
    'border': 'var(--nb-border-thin, 2px) solid var(--nb-line, #000)',
    'border-radius': 'var(--nb-radius-soft, 0)',
    'box-shadow':
        'var(--nb-shadow-sm, 3px 3px 0 0 var(--nb-shadow-color, #000))',
    'transition':
        'transform var(--nb-transition, 120ms ease), box-shadow var(--nb-transition, 120ms ease)',
  };

  (String bgColor, String fgColor) _cardColors(StatusBadgeProps props) {
    return switch (props.variant) {
      BadgeVariant.primary => (
        'var(--nb-accent, var(--primary))',
        'var(--nb-on-accent, #000)',
      ),
      BadgeVariant.successSolid => (
        'var(--success, #22c55e)',
        'var(--success-foreground, #000)',
      ),
      BadgeVariant.warningSolid => (
        'var(--warning, #f59e0b)',
        'var(--warning-foreground, #000)',
      ),
      BadgeVariant.errorSolid => (
        'var(--destructive)',
        'var(--destructive-foreground, #fff)',
      ),
      BadgeVariant.infoSolid => (
        'var(--info, #3b82f6)',
        'var(--info-foreground, #fff)',
      ),
      BadgeVariant.outline => ('transparent', 'var(--foreground)'),
      BadgeVariant.secondary => (
        'var(--nb-paper-soft, var(--card))',
        'var(--foreground)',
      ),
      BadgeVariant.status => (
        'var(--nb-paper-soft, var(--card))',
        'var(--foreground)',
      ),
    };
  }

  @override
  void applyCardColors(StatusBadgeProps props, Map<String, String> styles) {
    final (String bgColor, String fgColor) = _cardColors(props);

    if (props.background != null) {
      styles['background-color'] = props.background!;
    } else {
      styles['background-color'] = bgColor;
    }
    styles['color'] = fgColor;
  }

  @override
  Map<String, String> statusContainerStyles(StatusBadgeProps props) =>
      _statusContainerStyles(props);

  @override
  Map<String, String> statusDotStyles(StatusBadgeProps props) =>
      _dotStyles(props, statusColor(props));
}
