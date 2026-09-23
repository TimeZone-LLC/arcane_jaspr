import 'package:jaspr/jaspr.dart';

import 'package:arcane_jaspr/component/view/icon.dart';
import 'package:arcane_jaspr/core/props/alert_props.dart';
import 'package:arcane_jaspr/core/rendering/base/alert_render_base.dart';

/// ShadCN Alert renderer.
///
/// The default (subtle) alert is the v4 neutral card: `bg-card` with a hairline
/// border, status expressed by the icon colour only. Destructive alerts tint
/// the text instead of the fill. Solid, outline and accent remain explicit
/// opt-in emphasis styles with complete perimeters.
///
/// Reference: https://ui.shadcn.com/docs/components/alert
class ShadcnAlert extends AlertRenderBase {
  const ShadcnAlert(super.props, {super.key});

  bool get _destructive => props.color == ColorVariant.destructive;

  bool get _solid => props.variant == AlertStyle.solid;

  /// Status colour used for icons, emphasis borders and solid fills.
  String get _statusColor => switch (props.color) {
    ColorVariant.info => 'var(--info)',
    ColorVariant.success => 'var(--success)',
    ColorVariant.warning => 'var(--warning)',
    ColorVariant.destructive => 'var(--destructive)',
    ColorVariant.primary => 'var(--primary)',
    ColorVariant.secondary => 'var(--secondary)',
  };

  /// Readable foreground on a solid [_statusColor] fill.
  String get _solidForeground => switch (props.color) {
    ColorVariant.info => 'var(--info-foreground)',
    ColorVariant.success => 'var(--success-foreground)',
    ColorVariant.warning => 'var(--warning-foreground)',
    ColorVariant.destructive => 'var(--destructive-foreground)',
    ColorVariant.primary => 'var(--primary-foreground)',
    ColorVariant.secondary => 'var(--secondary-foreground)',
  };

  /// Icon colour on the neutral surfaces. Secondary has no readable text
  /// colour of its own, so it follows the alert text.
  String get _iconColor => switch (props.color) {
    ColorVariant.secondary => 'currentColor',
    _ => _statusColor,
  };

  /// Alert text colour for the non-solid variants.
  String get _textColor =>
      _destructive ? 'var(--destructive)' : 'var(--card-foreground)';

  String _mix(String color, int percent) =>
      'color-mix(in srgb, $color $percent%, transparent)';

  @override
  Component get defaultIcon => switch (props.color) {
    ColorVariant.info => ArcaneIcon.info(size: IconSize.sm),
    ColorVariant.success => ArcaneIcon.circleCheck(size: IconSize.sm),
    ColorVariant.warning => ArcaneIcon.triangleAlert(size: IconSize.sm),
    ColorVariant.destructive => ArcaneIcon.circleX(size: IconSize.sm),
    ColorVariant.primary => ArcaneIcon.info(size: IconSize.sm),
    ColorVariant.secondary => ArcaneIcon.info(size: IconSize.sm),
  };

  @override
  String get rootClass => 'arcane-alert';

  @override
  Map<String, String> get rootAttributes => const <String, String>{
    'role': 'alert',
  };

  // ShadCN Alert: relative grid w-full items-start gap-x-3 gap-y-0.5
  // rounded-lg border px-4 py-3 text-sm, with a leading icon column.
  @override
  Map<String, String> get rootLayoutStyles => <String, String>{
    'display': 'grid',
    'grid-template-columns': props.showIcon
        ? 'auto minmax(0, 1fr)'
        : 'minmax(0, 1fr)',
    'gap': '0.125rem 0.75rem',
    'padding': props.dismissible
        ? '0.75rem 2.5rem 0.75rem 1rem'
        : '0.75rem 1rem',
    'font-size': '0.875rem',
    'line-height': '1.25rem',
  };

  @override
  Map<String, String> get containerStyles => switch (props.variant) {
    AlertStyle.subtle => <String, String>{
      'background-color': 'var(--card)',
      'border': '1px solid var(--border)',
      'border-radius': 'var(--radius-md)',
      'color': _textColor,
    },
    AlertStyle.solid => <String, String>{
      'background-color': _statusColor,
      'border': '1px solid transparent',
      'border-radius': 'var(--radius-md)',
      'color': _solidForeground,
    },
    AlertStyle.outline => <String, String>{
      'background-color': 'var(--background)',
      'border': '1px solid ${_mix(_statusColor, 40)}',
      'border-radius': 'var(--radius-md)',
      'color': _textColor,
    },
    AlertStyle.accent => <String, String>{
      'background-color': _mix(_statusColor, 10),
      'border': '2px solid $_statusColor',
      'border-radius': 'var(--radius-md)',
      'color': _textColor,
    },
  };

  @override
  String get iconClass => 'arcane-alert-icon';

  // [&>svg]:size-4 [&>svg]:translate-y-0.5
  @override
  Map<String, String> get iconStyles => <String, String>{
    'flex-shrink': '0',
    'width': '1rem',
    'height': '1rem',
    'display': 'flex',
    'align-items': 'center',
    'justify-content': 'center',
    'color': _solid ? 'currentColor' : _iconColor,
    'margin-top': '0.125rem',
  };

  @override
  String get contentClass => 'arcane-alert-content';

  @override
  String get titleClass => 'arcane-alert-title';

  // col-start-2 min-h-4 font-medium tracking-tight
  @override
  Map<String, String> get titleStyles => <String, String>{
    'min-height': '1rem',
    'font-size': '0.875rem',
    'font-weight': '500',
    'line-height': '1.25rem',
    'letter-spacing': '-0.01em',
    'color': 'inherit',
    if (props.message != null || props.child != null)
      'margin-bottom': '0.125rem',
  };

  @override
  String get descriptionClass => 'arcane-alert-description';

  // text-muted-foreground text-sm; destructive: text-destructive/90
  @override
  Map<String, String> get descriptionStyles => <String, String>{
    'font-size': '0.875rem',
    'line-height': '1.25rem',
    'color': _solid
        ? 'inherit'
        : _destructive
        ? _mix('var(--destructive)', 90)
        : 'var(--muted-foreground)',
  };

  @override
  String get actionMarginTop => '0.75rem';

  @override
  String get dismissClass => 'arcane-alert-dismiss';

  @override
  Map<String, String> get dismissStyles => <String, String>{
    'position': 'absolute',
    'right': '0.5rem',
    'top': '0.5rem',
    'display': 'inline-flex',
    'align-items': 'center',
    'justify-content': 'center',
    'width': '1.5rem',
    'height': '1.5rem',
    'padding': '0',
    'border': 'none',
    'background': 'transparent',
    'color': _solid ? 'currentColor' : 'var(--muted-foreground)',
    'cursor': 'pointer',
    'border-radius': 'var(--radius-sm)',
    'opacity': 'var(--shadcn-alert-dismiss-opacity, 0.7)',
    'transition': 'opacity var(--transition)',
  };

  @override
  Component get dismissChild => ArcaneIcon.x(size: IconSize.sm);
}
