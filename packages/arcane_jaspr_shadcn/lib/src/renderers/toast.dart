import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/component/view/icon.dart';
import 'package:arcane_jaspr/core/theme_provider.dart';

/// ShadCN Toast renderer.
///
/// Outputs the Sonner toast shadcn/ui v4 ships: a 356px popover surface with
/// `p-4 gap-1.5 rounded-md border shadow-lg` and 13px text, a 16px status
/// icon, a medium-weight title over a muted description, and a 20px framed
/// dismiss control. There is no progress strip.
///
/// Reference: https://ui.shadcn.com/docs/components/sonner
class ShadcnToast extends StatelessComponent {
  final ToastProps props;

  const ShadcnToast(this.props, {super.key});

  Component _buildIcon(BuildContext context) {
    if (props.icon != null) {
      return props.icon!;
    }

    final Component iconWidget = switch (props.variant) {
      ToastVariant.success => ArcaneIcon.circleCheck(size: IconSize.sm),
      ToastVariant.error => ArcaneIcon.circleX(size: IconSize.sm),
      ToastVariant.warning => ArcaneIcon.triangleAlert(size: IconSize.sm),
      ToastVariant.info => ArcaneIcon.info(size: IconSize.sm),
      ToastVariant.loading => context.renderers.loadingSpinner(
        const LoadingSpinnerProps(size: '16px'),
      ),
    };

    return dom.div(
      styles: dom.Styles(raw: <String, String>{'color': _getIconColor()}),
      <Component>[iconWidget],
    );
  }

  String _getIconColor() {
    return switch (props.variant) {
      ToastVariant.success => 'var(--success)',
      ToastVariant.error => 'var(--destructive)',
      ToastVariant.warning => 'var(--warning)',
      ToastVariant.info => 'var(--info)',
      ToastVariant.loading => 'var(--muted-foreground)',
    };
  }

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'arcane-toast arcane-toast-${props.variant.name}',
      id: props.id != null ? 'toast-${props.id}' : null,
      attributes: <String, String>{
        'role': 'alert',
        'aria-live': props.variant == ToastVariant.error
            ? 'assertive'
            : 'polite',
        'aria-atomic': 'true',
        'data-variant': props.variant.name,
        'data-duration': '${props.duration}',
        'data-dismissible': '${props.dismissible}',
        'data-position': props.position.name,
        'data-state': props.isExiting ? 'closed' : 'open',
      },
      styles: dom.Styles(
        raw: <String, String>{
          'position': 'relative',
          'display': 'flex',
          'align-items': 'flex-start',
          'gap': '0.375rem',
          'box-sizing': 'border-box',
          'width': '356px',
          'max-width': 'calc(100vw - 2rem)',
          'padding': '1rem',
          'background-color': 'var(--popover)',
          'color': 'var(--popover-foreground)',
          'border': '1px solid var(--border)',
          'border-radius': 'var(--radius-md)',
          'box-shadow': 'var(--shadow-lg)',
          'font-size': '0.8125rem',
          'line-height': '1.5',
          'pointer-events': 'auto',
          'transition': 'transform 400ms ease, opacity 400ms ease',
          'animation': props.isExiting
              ? 'arcane-toast-exit 200ms cubic-bezier(0.4, 0, 1, 1) forwards'
              : 'arcane-toast-enter 300ms cubic-bezier(0, 0, 0.2, 1) forwards',
        },
      ),
      events: <String, EventCallback>{
        if (props.onMouseEnter != null)
          'mouseenter': (_) => props.onMouseEnter!(),
        if (props.onMouseLeave != null)
          'mouseleave': (_) => props.onMouseLeave!(),
      },
      <Component>[
        dom.div(
          classes: 'arcane-toast-icon',
          styles: const dom.Styles(
            raw: <String, String>{
              'display': 'flex',
              'align-items': 'center',
              'justify-content': 'center',
              'width': '1rem',
              'height': '1rem',
              'flex-shrink': '0',
              'margin-top': '0.125rem',
              'margin-right': '0.25rem',
            },
          ),
          <Component>[_buildIcon(context)],
        ),
        dom.div(
          classes: 'arcane-toast-content',
          styles: const dom.Styles(
            raw: <String, String>{
              'flex': '1',
              'min-width': '0',
              'display': 'flex',
              'flex-direction': 'column',
              'gap': '0.125rem',
            },
          ),
          <Component>[
            if (props.title != null)
              dom.span(
                classes: 'arcane-toast-title',
                styles: const dom.Styles(
                  raw: <String, String>{
                    'font-weight': '500',
                    'color': 'inherit',
                  },
                ),
                <Component>[Component.text(props.title!)],
              ),
            dom.span(
              classes: 'arcane-toast-message',
              styles: dom.Styles(
                raw: <String, String>{
                  'color': props.title != null
                      ? 'var(--muted-foreground)'
                      : 'inherit',
                  if (props.title == null) 'font-weight': '500',
                },
              ),
              <Component>[Component.text(props.message)],
            ),
            if (props.description != null)
              dom.span(
                classes: 'arcane-toast-description',
                styles: const dom.Styles(
                  raw: <String, String>{
                    'color': 'var(--muted-foreground)',
                    'line-height': '1.4',
                  },
                ),
                <Component>[Component.text(props.description!)],
              ),
            if (props.action != null)
              dom.div(
                styles: const dom.Styles(
                  raw: <String, String>{'margin-top': '0.5rem'},
                ),
                <Component>[
                  dom.button(
                    classes: 'arcane-toast-action',
                    attributes: const <String, String>{'type': 'button'},
                    styles: dom.Styles(
                      raw: <String, String>{
                        'display': 'inline-flex',
                        'align-items': 'center',
                        'height': '1.5rem',
                        'padding': '0 0.5rem',
                        'font-size': '0.75rem',
                        'font-weight': '500',
                        'color': props.action!.destructive
                            ? 'var(--destructive-foreground)'
                            : 'var(--popover)',
                        'background-color': props.action!.destructive
                            ? 'var(--destructive)'
                            : 'var(--popover-foreground)',
                        'border': '0',
                        'border-radius': 'var(--radius-xs)',
                        'box-shadow': 'var(--shadcn-control-shadow, none)',
                        'cursor': 'pointer',
                        'outline': 'none',
                        'transition':
                            'opacity var(--transition), box-shadow var(--transition)',
                      },
                    ),
                    events: <String, EventCallback>{
                      'click': (_) => props.action!.onPressed(),
                    },
                    <Component>[Component.text(props.action!.label)],
                  ),
                ],
              ),
          ],
        ),
        if (props.dismissible && props.onDismiss != null)
          dom.button(
            classes: 'arcane-toast-close',
            attributes: <String, String>{
              'type': 'button',
              'aria-label': 'Dismiss',
              'data-state': props.isExiting ? 'closed' : 'open',
            },
            styles: const dom.Styles(
              raw: <String, String>{
                'display': 'flex',
                'align-items': 'center',
                'justify-content': 'center',
                'width': '20px',
                'height': '20px',
                'padding': '0',
                'flex-shrink': '0',
                'border': '1px solid var(--border)',
                'border-radius': 'var(--radius-sm)',
                'background-color':
                    'var(--shadcn-item-background, var(--popover))',
                'color':
                    'var(--shadcn-item-foreground, var(--popover-foreground))',
                'box-shadow': 'var(--shadcn-control-shadow, none)',
                'cursor': 'pointer',
                'outline': 'none',
                'transition':
                    'background-color var(--transition), color var(--transition), box-shadow var(--transition)',
              },
            ),
            events: <String, EventCallback>{'click': (_) => props.onDismiss!()},
            <Component>[ArcaneIcon.x(size: IconSize.xs)],
          ),
      ],
    );
  }
}

/// ShadCN Toast Container renderer.
class ShadcnToastContainer extends StatelessComponent {
  final ToastContainerProps props;

  const ShadcnToastContainer(this.props, {super.key});

  Map<String, String> _getPositionStyles() {
    final offset = '${props.offset}px';

    return switch (props.position) {
      ToastPosition.topLeft => {
        'top': offset,
        'left': offset,
        'align-items': 'flex-start',
        'flex-direction': 'column',
      },
      ToastPosition.topCenter => {
        'top': offset,
        'left': '50%',
        'transform': 'translateX(-50%)',
        'align-items': 'center',
        'flex-direction': 'column',
      },
      ToastPosition.topRight => {
        'top': offset,
        'right': offset,
        'align-items': 'flex-end',
        'flex-direction': 'column',
      },
      ToastPosition.bottomLeft => {
        'bottom': offset,
        'left': offset,
        'align-items': 'flex-start',
        'flex-direction': 'column-reverse',
      },
      ToastPosition.bottomCenter => {
        'bottom': offset,
        'left': '50%',
        'transform': 'translateX(-50%)',
        'align-items': 'center',
        'flex-direction': 'column-reverse',
      },
      ToastPosition.bottomRight => {
        'bottom': offset,
        'right': offset,
        'align-items': 'flex-end',
        'flex-direction': 'column-reverse',
      },
    };
  }

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'arcane-toaster',
      attributes: {
        'role': 'region',
        'aria-label': 'Notifications',
        'data-position': props.position.name,
      },
      styles: dom.Styles(
        raw: {
          'position': 'fixed',
          // Above sheets (1100) so feedback stays visible over overlays.
          'z-index': '1200',
          'display': 'flex',
          'gap': '${props.gap}px',
          'pointer-events': 'none',
          'max-height': 'calc(100vh - 40px)',
          'overflow': 'visible',
          ..._getPositionStyles(),
        },
      ),
      [
        for (final toastProps in props.toasts.take(props.maxVisible))
          ShadcnToast(toastProps, key: ValueKey(toastProps.id)),
      ],
    );
  }
}
