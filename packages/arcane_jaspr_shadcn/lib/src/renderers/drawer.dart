import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/component/view/icon.dart';
import 'package:arcane_jaspr/core/interaction/interaction_attrs.dart';
import 'package:arcane_jaspr/core/props/drawer_props.dart';
import 'package:arcane_jaspr_shadcn/src/renderers/dialog.dart'
    show shadcnOverlayCloseStyles;

/// ShadCN Drawer renderer.
///
/// Outputs drawer HTML matching the ShadCN/ui v4 sheet: a complete 1px frame,
/// `shadow-lg`, and the 50% `--overlay` scrim.
/// Reference: https://ui.shadcn.com/docs/components/sheet
class ShadcnDrawer extends StatelessComponent {
  final DrawerProps props;

  const ShadcnDrawer(this.props, {super.key});

  bool get _isHorizontal =>
      props.position == DrawerPosition.left ||
      props.position == DrawerPosition.right;

  String get _sizeValue {
    if (_isHorizontal) {
      return props.width ??
          switch (props.size) {
            DrawerSize.sm => '280px',
            DrawerSize.md => '360px',
            DrawerSize.lg => '480px',
            DrawerSize.xl => '640px',
            DrawerSize.full => '100%',
          };
    } else {
      return props.height ??
          switch (props.size) {
            DrawerSize.sm => '30vh',
            DrawerSize.md => '50vh',
            DrawerSize.lg => '70vh',
            DrawerSize.xl => '90vh',
            DrawerSize.full => '100%',
          };
    }
  }

  Map<String, String> get _positionStyles => switch (props.position) {
    DrawerPosition.left => <String, String>{
      'left': '0',
      'top': '0',
      'bottom': '0',
      'width': _sizeValue,
      'max-width': '100%',
      'animation': 'arcane-slide-right var(--transition-slower)',
    },
    DrawerPosition.right => <String, String>{
      'right': '0',
      'top': '0',
      'bottom': '0',
      'width': _sizeValue,
      'max-width': '100%',
      'animation': 'arcane-slide-left var(--transition-slower)',
    },
    DrawerPosition.top => <String, String>{
      'top': '0',
      'left': '0',
      'right': '0',
      'height': _sizeValue,
      'animation': 'arcane-slide-down var(--transition-slower)',
    },
    DrawerPosition.bottom => <String, String>{
      'bottom': '0',
      'left': '0',
      'right': '0',
      'height': _sizeValue,
      'animation': 'arcane-slide-up var(--transition-slower)',
    },
  };

  /// Side and top drawers are square; only a bottom drawer lifts its top
  /// corners, and it keeps a complete 1px frame so no edge is emphasised.
  String get _borderRadius =>
      props.position == DrawerPosition.bottom && props.size != DrawerSize.full
      ? 'var(--radius-md) var(--radius-md) 0 0'
      : '0';

  @override
  Component build(BuildContext context) {
    final String surfaceId = props.id ?? _autoId();
    final Map<String, String> surfAttrs = surfaceAttrs(
      surface: 'drawer',
      id: surfaceId,
      initiallyOpen: props.isOpen,
      dismissible: props.closeOnBackdropClick,
      escapeCloses: props.escapeCloses,
      focusTrap: props.focusTrap,
      scrimCloses: props.closeOnBackdropClick,
      restoreFocus: props.restoreFocus,
    );

    return dom.div(
      classes: 'arcane-drawer-container',
      attributes: <String, String>{
        ...surfAttrs,
        'data-position': props.position.name,
      },
      styles: dom.Styles(
        raw: <String, String>{
          'position': 'fixed',
          'top': '0',
          'left': '0',
          'right': '0',
          'bottom': '0',
          'z-index': '50',
          'pointer-events': props.isOpen ? 'auto' : 'none',
        },
      ),
      <Component>[
        if (props.showBackdrop)
          dom.div(
            classes: 'arcane-drawer-backdrop',
            attributes: const <String, String>{'data-arcane-scrim': ''},
            styles: const dom.Styles(
              raw: <String, String>{
                'position': 'absolute',
                'top': '0',
                'left': '0',
                'right': '0',
                'bottom': '0',
                'background-color': 'var(--overlay)',
                'animation': 'arcane-fade-in var(--transition-slow)',
              },
            ),
            events: props.closeOnBackdropClick
                ? <String, EventCallback>{'click': (_) => props.onClose?.call()}
                : null,
            <Component>[],
          ),
        dom.div(
          classes: 'arcane-drawer arcane-drawer-${props.position.name}',
          attributes: const <String, String>{
            'role': 'dialog',
            'aria-modal': 'true',
            'data-arcane-autofocus': '',
          },
          styles: dom.Styles(
            raw: <String, String>{
              'position': 'absolute',
              'display': 'flex',
              'flex-direction': 'column',
              'background-color': 'var(--background)',
              'color': 'var(--foreground)',
              'border': '1px solid var(--border)',
              'border-radius': _borderRadius,
              'box-shadow': 'var(--shadow-lg)',
              'outline': 'none',
              'transition': 'transform var(--transition-slower)',
              ..._positionStyles,
              ...?props.decoration?.universalStyles(),
              ...?props.styles?.toMap(),
            },
          ),
          <Component>[
            if (props.header != null)
              dom.div(
                classes: 'arcane-drawer-header',
                styles: dom.Styles(
                  raw: <String, String>{
                    'display': 'flex',
                    'flex-direction': 'column',
                    'gap': '0.375rem',
                    'padding': '1.5rem 1.5rem 0',
                    if (props.showCloseButton) 'padding-right': '3rem',
                    'flex-shrink': '0',
                  },
                ),
                <Component>[props.header!],
              ),
            dom.div(
              classes: 'arcane-drawer-content',
              styles: dom.Styles(
                raw: <String, String>{
                  'flex': '1',
                  'min-height': '0',
                  'overflow': 'auto',
                  'padding': '1.5rem',
                  // Clear the absolute close control when no header row does.
                  if (props.header == null && props.showCloseButton)
                    'padding-top': '3rem',
                },
              ),
              <Component>[props.child],
            ),
            if (props.footer != null)
              dom.div(
                classes: 'arcane-drawer-footer',
                styles: const dom.Styles(
                  raw: <String, String>{
                    'display': 'flex',
                    'flex-direction': 'column',
                    'gap': '0.5rem',
                    'padding': '0 1.5rem 1.5rem',
                    'flex-shrink': '0',
                  },
                ),
                <Component>[props.footer!],
              ),
            if (props.showCloseButton)
              dom.button(
                classes: 'arcane-drawer-close',
                attributes: <String, String>{
                  'type': 'button',
                  'aria-label': 'Close drawer',
                  ...dismissAttrs(),
                },
                styles: const dom.Styles(raw: shadcnOverlayCloseStyles),
                events: <String, EventCallback>{
                  'click': (_) => props.onClose?.call(),
                },
                <Component>[ArcaneIcon.x(size: IconSize.sm)],
              ),
          ],
        ),
      ],
    );
  }

  static int _autoCounter = 0;
  static String _autoId() {
    _autoCounter++;
    return 'arcane-drawer-$_autoCounter';
  }
}
