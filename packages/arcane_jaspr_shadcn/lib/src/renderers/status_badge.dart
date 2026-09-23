import 'package:arcane_jaspr/core/props/status_badge_props.dart';
import 'package:arcane_jaspr/core/rendering/base/status_badge_render_base.dart';

/// ShadCN Status Badge renderer.
///
/// Unified renderer for status indicators and rectangular labels.
class ShadcnStatusBadge extends StatusBadgeRenderBase {
  const ShadcnStatusBadge(super.props, {super.key});

  @override
  String get classPrefix => 'shadcn';

  @override
  Map<String, String>? variantBadgeAttributes(StatusBadgeProps props) => null;

  @override
  Map<String, String>? statusBadgeAttributes(StatusBadgeProps props) => null;

  @override
  String indicatorSize(StatusBadgeProps props) => switch (props.size) {
    ComponentSize.sm => '6px',
    ComponentSize.md => '6px',
    ComponentSize.lg => '8px',
  };

  // ShadCN Badge: rounded-md px-2 py-0.5 text-xs font-medium (radius capped
  // to the 6px tier by the design-language policy).
  String _badgePadding(StatusBadgeProps props) => switch (props.size) {
    ComponentSize.sm => '0 0.375rem',
    ComponentSize.md => '0.125rem 0.5rem',
    ComponentSize.lg => '0.25rem 0.625rem',
  };

  String _badgeFontSize(StatusBadgeProps props) => switch (props.size) {
    ComponentSize.sm => '0.6875rem',
    ComponentSize.md => '0.75rem',
    ComponentSize.lg => '0.875rem',
  };

  String _badgeLineHeight(StatusBadgeProps props) => switch (props.size) {
    ComponentSize.sm => '1rem',
    ComponentSize.md => '1rem',
    ComponentSize.lg => '1.25rem',
  };

  @override
  Map<String, String> labelStyles(
    StatusBadgeProps props,
    String effectiveLabelColor,
  ) => <String, String>{
    'font-size': _badgeFontSize(props),
    'font-weight': '500',
    'line-height': _badgeLineHeight(props),
    'color': effectiveLabelColor,
    'white-space': 'nowrap',
  };

  @override
  String statusLabelColor(StatusBadgeProps props) =>
      props.labelColor ?? statusColor(props);

  @override
  Map<String, String> cardBaseStyles(StatusBadgeProps props) =>
      <String, String>{
        'display': 'inline-flex',
        'align-items': 'center',
        'justify-content': 'center',
        'gap': '0.25rem',
        'width': 'fit-content',
        'flex-shrink': '0',
        'overflow': 'hidden',
        'border-radius': 'var(--radius-sm)',
        'font-size': _badgeFontSize(props),
        'font-weight': '500',
        'line-height': _badgeLineHeight(props),
        'white-space': 'nowrap',
        'transition':
            'color var(--transition), background-color var(--transition), '
            'border-color var(--transition), box-shadow var(--transition)',
        'padding': _badgePadding(props),
      };

  (String bgColor, String fgColor, String? border) _cardColors(
    StatusBadgeProps props,
  ) {
    return switch (props.variant) {
      BadgeVariant.primary => (
        'var(--primary)',
        'var(--primary-foreground)',
        null,
      ),
      BadgeVariant.successSolid => (
        'var(--success, #22c55e)',
        'var(--success-foreground, #ffffff)',
        null,
      ),
      BadgeVariant.warningSolid => (
        'var(--warning, #f59e0b)',
        'var(--warning-foreground, #000000)',
        null,
      ),
      BadgeVariant.errorSolid => (
        'var(--destructive)',
        'var(--destructive-foreground)',
        null,
      ),
      BadgeVariant.infoSolid => (
        'var(--info, #3b82f6)',
        'var(--info-foreground, #ffffff)',
        null,
      ),
      BadgeVariant.outline => (
        'transparent',
        'var(--foreground)',
        '1px solid var(--border)',
      ),
      BadgeVariant.secondary => (
        'var(--secondary)',
        'var(--secondary-foreground)',
        null,
      ),
      BadgeVariant.status => (
        'var(--secondary)',
        'var(--secondary-foreground)',
        null,
      ),
    };
  }

  @override
  void applyCardColors(StatusBadgeProps props, Map<String, String> styles) {
    // Get colors based on variant
    final (String bgColor, String fgColor, String? borderStyle) = _cardColors(
      props,
    );

    if (props.background != null) {
      styles['background-color'] = props.background!;
      styles['color'] = fgColor;
      styles['border'] = borderStyle ?? '1px solid transparent';
    } else {
      styles['background-color'] = bgColor;
      styles['color'] = fgColor;
      styles['border'] = borderStyle ?? '1px solid transparent';
    }
  }

  @override
  Map<String, String> statusContainerStyles(StatusBadgeProps props) {
    final String color = statusColor(props);
    // Use color-mix for consistent appearance
    final String effectiveBackground =
        props.background ?? 'color-mix(in srgb, $color 10%, transparent)';
    final String effectiveBorder =
        props.borderColor ?? 'color-mix(in srgb, $color 25%, transparent)';
    return <String, String>{
      'display': 'inline-flex',
      'align-items': 'center',
      'gap': '0.375rem',
      'width': 'fit-content',
      'flex-shrink': '0',
      'padding': _badgePadding(props),
      'background': effectiveBackground,
      'border': '1px solid $effectiveBorder',
      'border-radius': 'var(--radius-sm)',
      'white-space': 'nowrap',
    };
  }

  @override
  Map<String, String> statusDotStyles(StatusBadgeProps props) {
    final String color = statusColor(props);
    final String size = indicatorSize(props);
    return <String, String>{
      'width': size,
      'height': size,
      'border-radius': '50%',
      'background': color,
      'flex-shrink': '0',
    };
  }
}
