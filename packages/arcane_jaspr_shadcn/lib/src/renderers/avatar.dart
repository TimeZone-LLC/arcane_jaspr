import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/avatar_props.dart';
import 'package:arcane_jaspr/core/rendering/base/avatar_render_base.dart';

/// ShadCN Avatar renderer.
///
/// The root does not clip: the image and fallback carry the root radius
/// themselves (`border-radius: inherit`) so the status dot can sit on the
/// corner without being cut off.
/// Reference: https://ui.shadcn.com/docs/components/avatar
class ShadcnAvatar extends AvatarRenderBase {
  const ShadcnAvatar(super.props, {super.key});

  @override
  String get rootClass => 'arcane-avatar';

  @override
  String get statusClass => 'arcane-avatar-status';

  // ShadCN v4 Avatar sizes (default size-8 = 32px):
  // (dimension, fontSize, statusSize)
  (String, String, String) _sizes(AvatarSize size) => switch (size) {
    AvatarSize.xs => ('20px', '0.625rem', '6px'),
    AvatarSize.sm => ('24px', '0.75rem', '8px'),
    AvatarSize.md => ('32px', '0.875rem', '10px'),
    AvatarSize.lg => ('40px', '1rem', '12px'),
    AvatarSize.xl => ('48px', '1.125rem', '14px'),
  };

  // Shape-specific border radius
  String _borderRadius(AvatarShape shape) => switch (shape) {
    AvatarShape.circle => '50%',
    AvatarShape.rounded => 'var(--radius-md)',
    AvatarShape.square => '0',
  };

  // ShadCN: relative flex size-8 shrink-0 rounded-full. Clipping moves to the
  // image/fallback so the status dot stays whole.
  @override
  Map<String, String> rootStyles(AvatarProps props) {
    final (String dimension, _, _) = _sizes(props.size);
    final String borderRadius = _borderRadius(props.shape);
    return <String, String>{
      'position': 'relative',
      'display': 'inline-flex',
      'align-items': 'center',
      'justify-content': 'center',
      'flex-shrink': '0',
      'width': dimension,
      'height': dimension,
      'border-radius': borderRadius,
      if (props.borderColor != null) 'border': '2px solid ${props.borderColor}',
      if (props.onTap != null) 'cursor': 'pointer',
    };
  }

  @override
  Map<String, String> statusStyles(AvatarProps props) {
    final (_, _, String statusSize) = _sizes(props.size);
    return <String, String>{
      'position': 'absolute',
      'bottom': '0',
      'right': '0',
      'width': statusSize,
      'height': statusSize,
      'box-sizing': 'content-box',
      'border-radius': '50%',
      'background-color': props.statusColor ?? 'var(--success)',
      'border': '2px solid var(--background)',
    };
  }

  @override
  Component buildBody(AvatarProps props) {
    final (_, String fontSize, _) = _sizes(props.size);

    // Image or fallback
    if (props.imageUrl != null) {
      // ShadCN AvatarImage: aspect-square size-full, clipped to the root
      // radius.
      return dom.img(
        classes: 'arcane-avatar-image',
        src: props.imageUrl!,
        alt: props.initials ?? 'Avatar',
        styles: const dom.Styles(
          raw: <String, String>{
            'aspect-ratio': '1',
            'height': '100%',
            'width': '100%',
            'object-fit': 'cover',
            'border-radius': 'inherit',
          },
        ),
      );
    }

    // ShadCN AvatarFallback: flex size-full items-center justify-center
    // rounded-full bg-muted
    return dom.div(
      classes: 'arcane-avatar-fallback',
      styles: dom.Styles(
        raw: <String, String>{
          'display': 'flex',
          'height': '100%',
          'width': '100%',
          'align-items': 'center',
          'justify-content': 'center',
          'overflow': 'hidden',
          'border-radius': 'inherit',
          'background-color': 'var(--muted)',
          'color': 'var(--muted-foreground)',
          'font-weight': 'var(--font-weight-medium)',
          'font-size': fontSize,
          'text-transform': 'uppercase',
        },
      ),
      [if (props.initials != null) Component.text(props.initials!)],
    );
  }
}
