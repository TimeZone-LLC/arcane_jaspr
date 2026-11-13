import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/rendering/base/style_layering.dart';
import 'package:arcane_jaspr/core/theme_provider.dart';

/// Shared structural base for the neon/neubrutalism toast renderers.
///
/// These two themes render an identical toast tree — the root flex row with its
/// variant/exiting classes and hover events, the icon slot, the
/// title/message/description content block, the action button and the dismiss
/// button, plus the glyph fallback icon. They diverge only in the class prefix,
/// the loading accent, the root attributes, the per-theme root/action/dismiss
/// style maps. The loading state is routed through the active theme's canonical
/// loader renderer.
///
/// The ShadCN toast is structurally divergent (icon components, a progress bar,
/// `role`/`aria-live` attributes and a close-button gated on `onDismiss`) and is
/// left standalone.
///
/// This base lives in core and depends only on core props; it must never depend
/// on a theme package.
abstract class ToastRenderBase extends StatelessComponent {
  const ToastRenderBase(this.props, {super.key});

  final ToastProps props;

  /// Theme class prefix (e.g. `'neon'`, `'neubrutalism'`).
  String get classPrefix;

  /// Accent color for the loading variant.
  String get loadingAccent;

  /// Extra attributes for the root element (neon none; neubrutalism
  /// `data-variant`).
  Map<String, String> get rootAttributes;

  /// Theme-specific root styles (before the shared exiting overrides). Receives
  /// the resolved [accentVar].
  Map<String, String> rootBaseStyles(String accentVar);

  /// Inline styles for the action button.
  Map<String, String> actionStyles();

  /// Classes for the dismiss button.
  String get dismissClasses;

  /// Inline styles for the dismiss button.
  Map<String, String> get dismissStyles;

  /// Per-instance decoration overrides. Default: none. Themes translate an
  /// ArcaneDecoration into their own CSS; unimplemented fields are ignored.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  String _accent(ToastVariant variant) => switch (variant) {
    ToastVariant.info => 'var(--info)',
    ToastVariant.success => 'var(--success)',
    ToastVariant.warning => 'var(--warning)',
    ToastVariant.error => 'var(--destructive)',
    ToastVariant.loading => loadingAccent,
  };

  @override
  Component build(BuildContext context) {
    final String accentVar = _accent(props.variant);

    return dom.div(
      classes:
          '$classPrefix-toast ${props.variant.name} ${props.isExiting ? 'exiting' : ''}',
      attributes: <String, String>{
        ...rootAttributes,
        // Decorated toasts opt out of neubrutalism's variant-border !important
        // reset so their inline decoration/styles border actually renders.
        if (props.decoration != null || props.styles != null)
          'data-arcane-decorated': '',
      },
      styles: dom.Styles(
        raw: layerStyles(
          <String, String>{
            ...rootBaseStyles(accentVar),
            if (props.isExiting) 'opacity': '0',
            if (props.isExiting) 'transform': 'translateX(100%)',
          },
          <Map<String, String>?>[
            props.decoration?.universalStyles(),
            decorationStyles(props.decoration),
            props.styles?.toMap(),
          ],
        ),
      ),
      events: <String, EventCallback>{
        if (props.onMouseEnter != null)
          'mouseenter': (_) => props.onMouseEnter!(),
        if (props.onMouseLeave != null)
          'mouseleave': (_) => props.onMouseLeave!(),
      },
      <Component>[
        dom.div(
          classes: '$classPrefix-toast-icon',
          styles: dom.Styles(
            raw: <String, String>{'flex-shrink': '0', 'color': accentVar},
          ),
          <Component>[props.icon ?? _buildDefaultIcon(context)],
        ),

        dom.div(
          classes: '$classPrefix-toast-content',
          styles: const dom.Styles(
            raw: <String, String>{'flex': '1', 'min-width': '0'},
          ),
          <Component>[
            if (props.title != null)
              dom.div(
                classes: '$classPrefix-toast-title',
                styles: const dom.Styles(
                  raw: <String, String>{
                    'font-family': 'var(--font-heading)',
                    'font-size': 'var(--font-size-sm)',
                    'font-weight': '600',
                    'letter-spacing': '0.04em',
                    'color': 'var(--foreground)',
                    'margin-bottom': '0.25rem',
                  },
                ),
                <Component>[Component.text(props.title!)],
              ),
            dom.div(
              classes: '$classPrefix-toast-message',
              styles: const dom.Styles(
                raw: <String, String>{
                  'font-size': 'var(--font-size-sm)',
                  'color': 'var(--foreground)',
                },
              ),
              <Component>[Component.text(props.message)],
            ),
            if (props.description != null)
              dom.div(
                classes: '$classPrefix-toast-description',
                styles: const dom.Styles(
                  raw: <String, String>{
                    'font-size': 'var(--font-size-xs)',
                    'color': 'var(--muted-foreground)',
                    'margin-top': '0.375rem',
                  },
                ),
                <Component>[Component.text(props.description!)],
              ),
            if (props.action != null)
              dom.button(
                classes: '$classPrefix-toast-action',
                styles: dom.Styles(raw: actionStyles()),
                events: <String, EventCallback>{
                  'click': (_) => props.action!.onPressed(),
                },
                <Component>[Component.text(props.action!.label)],
              ),
          ],
        ),

        if (props.dismissible)
          dom.button(
            classes: dismissClasses,
            styles: dom.Styles(raw: dismissStyles),
            events: props.onDismiss == null
                ? null
                : <String, EventCallback>{'click': (_) => props.onDismiss!()},
            <Component>[const Component.text('\u2715')],
          ),
      ],
    );
  }

  Component _buildDefaultIcon(BuildContext context) {
    if (props.variant == ToastVariant.loading) {
      return context.renderers.loadingSpinner(
        const LoadingSpinnerProps(size: '20px'),
      );
    }

    final String icon = switch (props.variant) {
      ToastVariant.info => 'i',
      ToastVariant.success => '\u2713',
      ToastVariant.warning => '!',
      ToastVariant.error => '\u2717',
      ToastVariant.loading => '',
    };

    return dom.span(
      styles: const dom.Styles(
        raw: <String, String>{
          'display': 'inline-flex',
          'align-items': 'center',
          'justify-content': 'center',
          'width': '20px',
          'height': '20px',
          'font-size': 'var(--font-size-sm)',
          'font-weight': '700',
        },
      ),
      <Component>[Component.text(icon)],
    );
  }
}

/// Shared structural base for the neon/neubrutalism toast-container renderers.
///
/// The fixed positioning, per-position offsets and the per-toast wrapper are
/// identical; only the class prefix and the concrete toast component differ.
abstract class ToastContainerRenderBase extends StatelessComponent {
  const ToastContainerRenderBase(this.props, {super.key});

  final ToastContainerProps props;

  /// Theme class prefix (e.g. `'neon'`, `'neubrutalism'`).
  String get classPrefix;

  /// Builds the theme's concrete toast for a queued [toast].
  Component buildToast(ToastProps toast);

  @override
  Component build(BuildContext context) {
    final Map<String, String> positionStyles = switch (props.position) {
      ToastPosition.topLeft => <String, String>{
        'top': '${props.edge}px',
        'left': '${props.offset}px',
        'align-items': 'flex-start',
      },
      ToastPosition.topCenter => <String, String>{
        'top': '${props.edge}px',
        'left': '50%',
        'transform': 'translateX(-50%)',
        'align-items': 'center',
      },
      ToastPosition.topRight => <String, String>{
        'top': '${props.edge}px',
        'right': '${props.offset}px',
        'align-items': 'flex-end',
      },
      ToastPosition.bottomLeft => <String, String>{
        'bottom': '${props.edge}px',
        'left': '${props.offset}px',
        'align-items': 'flex-start',
      },
      ToastPosition.bottomCenter => <String, String>{
        'bottom': '${props.edge}px',
        'left': '50%',
        'transform': 'translateX(-50%)',
        'align-items': 'center',
      },
      ToastPosition.bottomRight => <String, String>{
        'bottom': '${props.edge}px',
        'right': '${props.offset}px',
        'align-items': 'flex-end',
      },
    };

    return dom.div(
      classes: '$classPrefix-toast-container',
      styles: dom.Styles(
        raw: <String, String>{
          'position': 'fixed',
          'z-index': '100',
          'display': 'flex',
          'flex-direction': 'column',
          'gap': '${props.gap}px',
          'pointer-events': 'none',
          ...positionStyles,
        },
      ),
      <Component>[
        for (final ToastProps toast in props.toasts.take(props.maxVisible))
          dom.div(
            styles: const dom.Styles(
              raw: <String, String>{'pointer-events': 'auto'},
            ),
            <Component>[buildToast(toast)],
          ),
      ],
    );
  }
}
