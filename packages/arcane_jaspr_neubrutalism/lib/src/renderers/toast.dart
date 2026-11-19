import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/toast_props.dart';
import 'package:arcane_jaspr/core/rendering/base/toast_render_base.dart';

/// Neubrutalism Toast renderer.
///
/// Implements the Neubrutalism design language:
/// - Flat high-contrast surface
/// - Complete accent perimeter for semantic variants
/// - Compact radius with a neutral hard shadow
class NeubrutalismToast extends ToastRenderBase {
  const NeubrutalismToast(super.props, {super.key});

  @override
  String get classPrefix => 'neubrutalism';

  @override
  String get loadingAccent => 'var(--nb-accent, var(--primary))';

  @override
  Map<String, String> get rootAttributes => <String, String>{
    'data-variant': props.variant.name,
  };

  @override
  Map<String, String> rootBaseStyles(String accentVar) => <String, String>{
    'display': 'flex',
    'align-items': 'flex-start',
    'gap': '0.75rem',
    'width': '360px',
    'max-width': '100%',
    'box-sizing': 'border-box',
    'overflow-wrap': 'anywhere',
    'padding': '1rem 1.25rem',
    'background': 'var(--nb-paper, var(--card))',
    'border': 'var(--nb-border-thick, 4px) solid $accentVar',
    'border-radius': 'var(--nb-radius-soft, 4px)',
    'box-shadow':
        'var(--nb-shadow-md, 5px 5px 0 0 var(--nb-shadow-color, #000))',
    'transition':
        'opacity var(--nb-transition, 120ms ease), transform var(--nb-transition, 120ms ease), box-shadow var(--nb-transition, 120ms ease)',
  };

  @override
  Map<String, String> actionStyles() => <String, String>{
    'max-width': '100%',
    'min-height': '44px',
    'box-sizing': 'border-box',
    'white-space': 'normal',
    'margin-top': '0.5rem',
    'padding': '0.5rem 0.875rem',
    'font-family': 'var(--font-heading)',
    'font-size': 'var(--font-size-xs)',
    'font-weight': '800',
    'letter-spacing': '0.04em',
    'text-transform': 'uppercase',
    'background': props.action!.destructive
        ? 'var(--destructive)'
        : 'var(--nb-accent, var(--primary))',
    'color': props.action!.destructive
        ? 'var(--destructive-foreground, #fff)'
        : 'var(--nb-on-accent, #000)',
    'border': 'var(--nb-border-thin, 2px) solid var(--nb-line, #000)',
    'border-radius': 'var(--nb-radius-soft, 4px)',
    'box-shadow':
        'var(--nb-shadow-xs, 2px 2px 0 0 var(--nb-shadow-color, #000))',
    'cursor': 'pointer',
    'transition':
        'transform var(--nb-transition, 120ms ease), box-shadow var(--nb-transition, 120ms ease)',
  };

  @override
  String get dismissClasses =>
      'neubrutalism-toast-dismiss neubrutalism-toast-close';

  @override
  Map<String, String> get dismissStyles => const <String, String>{
    'flex-shrink': '0',
    'width': '44px',
    'height': '44px',
    'display': 'flex',
    'align-items': 'center',
    'justify-content': 'center',
    'background': 'transparent',
    'border': 'var(--nb-border-thin, 2px) solid transparent',
    'border-radius': 'var(--nb-radius-soft, 4px)',
    'color': 'var(--foreground)',
    'cursor': 'pointer',
    'font-weight': '900',
    'transition':
        'background-color var(--nb-transition, 120ms ease), border-color var(--nb-transition, 120ms ease)',
  };
}

/// Neubrutalism Toast Container renderer.
class NeubrutalismToastContainer extends ToastContainerRenderBase {
  const NeubrutalismToastContainer(super.props, {super.key});

  @override
  String get classPrefix => 'neubrutalism';

  @override
  Component build(BuildContext context) => dom.div(
    styles: dom.Styles(
      raw: <String, String>{
        'display': 'contents',
        '--nb-toast-offset': '${props.offset}px',
      },
    ),
    <Component>[super.build(context)],
  );

  @override
  Component buildToast(ToastProps toast) => NeubrutalismToast(toast);
}
