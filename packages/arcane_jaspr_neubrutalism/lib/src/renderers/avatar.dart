import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/avatar_props.dart';
import 'package:arcane_jaspr/core/rendering/base/avatar_render_base.dart';

/// Neubrutalism Avatar renderer.
///
/// Implements the Neubrutalism design language:
/// - Larger sizes (1.25x)
/// - Accent-colored border option
/// - Complete status ring
class NeubrutalismAvatar extends AvatarRenderBase {
  const NeubrutalismAvatar(super.props, {super.key});

  @override
  String get rootClass => 'neubrutalism-avatar';

  @override
  String get statusClass => 'neubrutalism-avatar-status';

  String _sizeValue(AvatarSize size) => switch (size) {
    AvatarSize.xs => '28px',
    AvatarSize.sm => '40px',
    AvatarSize.md => '48px',
    AvatarSize.lg => '64px',
    AvatarSize.xl => '96px',
  };

  String _fontSize(AvatarSize size) => switch (size) {
    AvatarSize.xs => '10px',
    AvatarSize.sm => '14px',
    AvatarSize.md => '16px',
    AvatarSize.lg => '22px',
    AvatarSize.xl => '32px',
  };

  String _borderWidth(AvatarSize size) => switch (size) {
    AvatarSize.xs => '1px',
    AvatarSize.sm => '1px',
    AvatarSize.md => '1.5px',
    AvatarSize.lg => '2px',
    AvatarSize.xl => '2px',
  };

  String _statusSize(AvatarSize size) => switch (size) {
    AvatarSize.xs => '8px',
    AvatarSize.sm => '10px',
    AvatarSize.md => '12px',
    AvatarSize.lg => '14px',
    AvatarSize.xl => '16px',
  };

  @override
  Map<String, String> rootStyles(AvatarProps props) => <String, String>{
    'position': 'relative',
    'display': 'inline-block',
    'width': _sizeValue(props.size),
    'height': _sizeValue(props.size),
    'flex-shrink': '0',
    if (props.onTap != null) 'cursor': 'pointer',
  };

  @override
  Map<String, String> statusStyles(AvatarProps props) {
    final String statusSize = _statusSize(props.size);
    return <String, String>{
      'position': 'absolute',
      'bottom': '0',
      'right': '0',
      'width': statusSize,
      'height': statusSize,
      'border-radius': '50%',
      'background-color': props.statusColor ?? 'var(--success)',
      'border': '2px solid var(--nb-line, #000)',
      'box-shadow':
          'var(--nb-shadow-sm, 2px 2px 0 0 var(--nb-shadow-color, #000))',
    };
  }

  @override
  Component buildBody(AvatarProps props) {
    final String fontSize = _fontSize(props.size);
    final String borderWidth = _borderWidth(props.size);

    final bool isCircle = props.shape == AvatarShape.circle;
    final String borderRadius = switch (props.shape) {
      AvatarShape.circle => '50%',
      AvatarShape.rounded => 'var(--nb-radius-soft, 4px)',
      AvatarShape.square => '0',
    };

    final String? clipPath = isCircle ? null : 'none';

    return dom.div(
      classes: 'neubrutalism-avatar-inner${isCircle ? ' rounded-full' : ''}',
      styles: dom.Styles(
        raw: {
          'width': '100%',
          'height': '100%',
          'border-radius': borderRadius,
          'clip-path': ?clipPath,
          'overflow': 'hidden',
          'background': 'var(--nb-accent, var(--primary))',
          'display': 'flex',
          'align-items': 'center',
          'justify-content': 'center',
          'border': props.borderColor != null
              ? '$borderWidth solid ${props.borderColor}'
              : '$borderWidth solid var(--nb-line, #000)',
          'box-sizing': 'border-box',
          'transition': 'border-color 0.18s ease, box-shadow 0.18s ease',
        },
      ),
      [
        if (props.imageUrl != null)
          dom.img(
            src: props.imageUrl!,
            attributes: {'alt': props.initials ?? 'Avatar'},
            styles: const dom.Styles(
              raw: {'width': '100%', 'height': '100%', 'object-fit': 'cover'},
            ),
          )
        else if (props.initials != null)
          dom.span(
            styles: dom.Styles(
              raw: {
                'font-size': fontSize,
                'font-weight': '600',
                'color': 'var(--nb-on-accent, var(--primary-foreground))',
                'letter-spacing': '0.04em',
                'text-transform': 'uppercase',
                'user-select': 'none',
              },
            ),
            [Component.text(props.initials!)],
          )
        else
          dom.span(
            styles: dom.Styles(
              raw: {
                'font-size': fontSize,
                'color': 'var(--nb-on-accent, var(--primary-foreground))',
              },
            ),
            [const Component.text('?')],
          ),
      ],
    );
  }
}
