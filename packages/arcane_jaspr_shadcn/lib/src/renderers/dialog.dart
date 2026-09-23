import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/component/view/icon.dart';
import 'package:arcane_jaspr/core/interaction/interaction_attrs.dart';
import 'package:arcane_jaspr/core/props/dialog_props.dart';

/// Inline chrome for the dialog, sheet and drawer close control (v4
/// `absolute top-4 right-4 rounded-xs opacity-70`). Opacity and the focus
/// ring route through variables so the surfaces stylesheet can flip them on
/// hover and `:focus-visible`.
const Map<String, String> shadcnOverlayCloseStyles = <String, String>{
  'position': 'absolute',
  'top': '1rem',
  'right': '1rem',
  'display': 'inline-flex',
  'align-items': 'center',
  'justify-content': 'center',
  'width': '1rem',
  'height': '1rem',
  'padding': '0',
  'border': 'none',
  'border-radius': 'var(--radius-xs)',
  'background': 'transparent',
  'color': 'var(--foreground)',
  'opacity': 'var(--shadcn-dialog-close-opacity, 0.7)',
  'box-shadow': 'var(--shadcn-control-shadow, none)',
  'cursor': 'pointer',
  'transition': 'opacity var(--transition), box-shadow var(--transition)',
};

class ShadcnDialog extends StatelessComponent {
  final DialogProps props;

  const ShadcnDialog(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    final String surfaceId = props.id ?? _autoId();
    final Map<String, String> surfAttrs = surfaceAttrs(
      surface: 'dialog',
      id: surfaceId,
      initiallyOpen: props.isOpen,
      dismissible: props.barrierDismissible,
      escapeCloses: props.escapeCloses,
      focusTrap: props.focusTrap,
      scrimCloses: props.barrierDismissible,
      restoreFocus: props.restoreFocus,
    );

    return dom.div(
      classes: 'arcane-dialog-overlay',
      attributes: <String, String>{...surfAttrs, 'data-arcane-scrim': ''},
      styles: const dom.Styles(
        raw: <String, String>{
          'position': 'fixed',
          'inset': '0',
          'z-index': '50',
          'display': 'flex',
          'align-items': 'center',
          'justify-content': 'center',
          // Leaves the v4 `max-w-[calc(100%-2rem)]` gutter around the panel.
          'padding': '1rem',
          'background-color': 'var(--overlay)',
          'animation': 'arcane-fade-in var(--transition-slow)',
        },
      ),
      events: <String, EventCallback>{
        if (props.onClose != null)
          'arcane:close': (event) {
            if (event.target == event.currentTarget) props.onClose!();
          },
        if (props.onClose != null && props.barrierDismissible)
          'click': (event) {
            if (event.target == event.currentTarget) {
              props.onClose!();
            }
          },
      },
      <Component>[
        dom.div(
          classes: 'arcane-dialog',
          attributes: <String, String>{
            'role': 'dialog',
            'aria-modal': 'true',
            'tabindex': '-1',
            if (props.title != null)
              'aria-labelledby': 'dialog-title-$surfaceId',
            'data-arcane-autofocus': '',
          },
          styles: dom.Styles(
            raw: <String, String>{
              'position': 'relative',
              'display': 'flex',
              'flex-direction': 'column',
              'gap': '1rem',
              'width': '100%',
              'max-width': '${props.maxWidth}px',
              'max-height': 'calc(100vh - 2rem)',
              'padding': '1.5rem',
              'background-color': 'var(--background)',
              'color': 'var(--foreground)',
              'border-radius': 'var(--radius-md)',
              'border': '1px solid var(--border)',
              'box-shadow': 'var(--shadow-lg)',
              'overflow': 'hidden',
              // The runtime focuses the panel itself; it is not a control.
              'outline': 'none',
              'animation': 'arcane-scale-in var(--transition-slow)',
              ...?props.decoration?.universalStyles(),
              ...?props.styles?.toMap(),
            },
          ),
          events: <String, EventCallback>{
            'click': (event) => event.stopPropagation(),
          },
          <Component>[
            if (props.title != null)
              dom.div(
                classes: 'arcane-dialog-header',
                styles: dom.Styles(
                  raw: <String, String>{
                    'display': 'flex',
                    'flex-direction': 'column',
                    'gap': '0.5rem',
                    'text-align': 'left',
                    'flex-shrink': '0',
                    if (props.showCloseButton) 'padding-right': '1.5rem',
                  },
                ),
                <Component>[
                  dom.span(
                    id: 'dialog-title-$surfaceId',
                    classes: 'arcane-dialog-title',
                    styles: const dom.Styles(
                      raw: <String, String>{
                        'font-size': '1.125rem',
                        'line-height': '1',
                        'font-weight': '600',
                        'color': 'var(--foreground)',
                      },
                    ),
                    <Component>[Component.text(props.title!)],
                  ),
                ],
              ),
            dom.div(
              classes: 'arcane-dialog-body',
              styles: const dom.Styles(
                raw: <String, String>{
                  'flex': '1',
                  'min-height': '0',
                  'overflow-y': 'auto',
                  // Room for child focus rings inside the scroll clip.
                  'padding': '0.25rem',
                  'margin': '-0.25rem',
                },
              ),
              props.content,
            ),
            if (props.actions != null && props.actions!.isNotEmpty)
              dom.div(
                classes: 'arcane-dialog-footer',
                styles: const dom.Styles(
                  raw: <String, String>{
                    'display': 'flex',
                    'flex-direction': 'row',
                    'flex-wrap': 'wrap',
                    'justify-content': 'flex-end',
                    'gap': '0.5rem',
                    'flex-shrink': '0',
                  },
                ),
                props.actions!,
              ),
            if (props.showCloseButton)
              dom.button(
                classes: 'arcane-dialog-close',
                attributes: <String, String>{
                  'type': 'button',
                  'aria-label': 'Close dialog',
                  ...dismissAttrs(),
                },
                styles: const dom.Styles(raw: shadcnOverlayCloseStyles),
                events: <String, EventCallback>{
                  if (props.onClose != null)
                    'click': (event) => props.onClose!(),
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
    return 'arcane-dialog-$_autoCounter';
  }
}

class ShadcnSheet extends StatelessComponent {
  final SheetProps props;

  const ShadcnSheet(this.props, {super.key});

  bool get _isVertical =>
      props.position == SheetPosition.bottom ||
      props.position == SheetPosition.top;

  String? get _sizeValue {
    if (props.size == SheetSizeVariant.auto) return null;
    if (_isVertical) {
      return switch (props.size) {
        SheetSizeVariant.auto => null,
        SheetSizeVariant.sm => '30vh',
        SheetSizeVariant.md => '50vh',
        SheetSizeVariant.lg => '70vh',
        SheetSizeVariant.xl => '90vh',
        SheetSizeVariant.full => '100vh',
      };
    } else {
      return switch (props.size) {
        SheetSizeVariant.auto => null,
        SheetSizeVariant.sm => '280px',
        SheetSizeVariant.md => '400px',
        SheetSizeVariant.lg => '540px',
        SheetSizeVariant.xl => '720px',
        SheetSizeVariant.full => '100vw',
      };
    }
  }

  @override
  Component build(BuildContext context) {
    final String surfaceId = props.id ?? _autoId();
    final String? sizeVal = _sizeValue;

    // v4 SheetContent: a square panel with a complete 1px frame. The side a
    // sheet docks to is clipped by the viewport, so no edge is emphasised.
    final Map<String, String> sheetStyles = <String, String>{
      'position': 'fixed',
      'z-index': '50',
      'display': 'flex',
      'flex-direction': 'column',
      'gap': '1rem',
      'padding': '1.5rem',
      'background-color': 'var(--background)',
      'color': 'var(--foreground)',
      'border': '1px solid var(--border)',
      'border-radius': '0',
      'box-shadow': 'var(--shadow-lg)',
      'overflow': 'hidden',
      'outline': 'none',
      'transition': 'transform 300ms cubic-bezier(0.32, 0.72, 0, 1)',
    };

    switch (props.position) {
      case SheetPosition.right:
        sheetStyles.addAll(<String, String>{
          'top': '0',
          'right': '0',
          'bottom': '0',
          'height': '100%',
          'width': sizeVal ?? '75%',
          'max-width': sizeVal == null ? '24rem' : '100vw',
          'animation': 'arcane-slide-left var(--transition-slower)',
        });
        break;
      case SheetPosition.left:
        sheetStyles.addAll(<String, String>{
          'top': '0',
          'left': '0',
          'bottom': '0',
          'height': '100%',
          'width': sizeVal ?? '75%',
          'max-width': sizeVal == null ? '24rem' : '100vw',
          'animation': 'arcane-slide-right var(--transition-slower)',
        });
        break;
      case SheetPosition.bottom:
        sheetStyles.addAll(<String, String>{
          'left': props.maxWidth != null ? '50%' : '0',
          'right': props.maxWidth != null ? 'auto' : '0',
          'bottom': '0',
          // `translate` composes with the slide keyframes' `transform`.
          if (props.maxWidth != null) 'translate': '-50% 0',
          'height': ?sizeVal,
          'max-height': '90vh',
          'width': props.maxWidth ?? '100%',
          'animation': 'arcane-slide-up var(--transition-slower)',
        });
        break;
      case SheetPosition.top:
        sheetStyles.addAll(<String, String>{
          'left': '0',
          'right': '0',
          'top': '0',
          'height': ?sizeVal,
          'max-height': '90vh',
          'animation': 'arcane-slide-down var(--transition-slower)',
        });
        break;
    }

    sheetStyles.addAll(<String, String>{
      ...?props.decoration?.universalStyles(),
      ...?props.styles?.toMap(),
    });

    final Map<String, String> surfAttrs = surfaceAttrs(
      surface: 'sheet',
      id: surfaceId,
      initiallyOpen: props.isOpen,
      dismissible: props.closeOnBackdropClick,
      escapeCloses: props.escapeCloses,
      focusTrap: props.focusTrap,
      scrimCloses: props.closeOnBackdropClick,
      restoreFocus: props.restoreFocus,
    );

    return dom.div(
      classes: 'arcane-sheet',
      attributes: <String, String>{
        ...surfAttrs,
        'data-position': props.position.name,
      },
      styles: const dom.Styles(
        raw: <String, String>{
          'position': 'fixed',
          'inset': '0',
          'z-index': '1100',
          'pointer-events': 'auto',
        },
      ),
      <Component>[
        if (props.showBackdrop)
          dom.div(
            classes: 'arcane-sheet-backdrop',
            attributes: <String, String>{'data-arcane-scrim': ''},
            styles: const dom.Styles(
              raw: <String, String>{
                'position': 'absolute',
                'inset': '0',
                'background-color': 'var(--overlay)',
                'animation': 'arcane-fade-in var(--transition-slow)',
              },
            ),
            events: <String, EventCallback>{
              if (props.closeOnBackdropClick && props.onClose != null)
                'click': (_) => props.onClose!(),
            },
            <Component>[],
          ),
        dom.div(
          classes: 'arcane-sheet-panel arcane-sheet-${props.position.name}',
          attributes: const <String, String>{
            'role': 'dialog',
            'aria-modal': 'true',
            'data-arcane-autofocus': '',
          },
          styles: dom.Styles(raw: sheetStyles),
          events: <String, EventCallback>{
            'click': (event) => event.stopPropagation(),
          },
          <Component>[
            if (props.showDragHandle && _isVertical)
              const dom.div(
                classes: 'arcane-sheet-drag-handle',
                styles: dom.Styles(
                  raw: <String, String>{
                    'display': 'flex',
                    'justify-content': 'center',
                    'flex-shrink': '0',
                  },
                ),
                <Component>[
                  dom.div(
                    styles: dom.Styles(
                      raw: <String, String>{
                        'width': '100px',
                        'height': '0.5rem',
                        'background-color': 'var(--muted)',
                        'border-radius': 'var(--radius-xs)',
                      },
                    ),
                    <Component>[],
                  ),
                ],
              ),
            if (props.header != null || props.title != null)
              dom.div(
                classes: 'arcane-sheet-header',
                styles: dom.Styles(
                  raw: <String, String>{
                    'display': 'flex',
                    'flex-direction': 'column',
                    'gap': '0.375rem',
                    'flex-shrink': '0',
                    if (props.showCloseButton) 'padding-right': '1.5rem',
                  },
                ),
                <Component>[
                  if (props.header != null)
                    props.header!
                  else ...<Component>[
                    dom.span(
                      classes: 'arcane-sheet-title',
                      styles: const dom.Styles(
                        raw: <String, String>{
                          'font-size': '1rem',
                          'font-weight': '600',
                          'line-height': '1.5rem',
                          'color': 'var(--foreground)',
                        },
                      ),
                      <Component>[Component.text(props.title!)],
                    ),
                    if (props.description != null)
                      dom.span(
                        classes: 'arcane-sheet-description',
                        styles: const dom.Styles(
                          raw: <String, String>{
                            'font-size': '0.875rem',
                            'color': 'var(--muted-foreground)',
                          },
                        ),
                        <Component>[Component.text(props.description!)],
                      ),
                  ],
                ],
              ),
            dom.div(
              classes: 'arcane-sheet-content',
              styles: const dom.Styles(
                raw: <String, String>{
                  'flex': '1',
                  'min-height': '0',
                  'overflow': 'auto',
                  // Room for child focus rings inside the scroll clip.
                  'padding': '0.25rem',
                  'margin': '-0.25rem',
                },
              ),
              <Component>[props.child],
            ),
            if (props.footer != null)
              dom.div(
                classes: 'arcane-sheet-footer',
                styles: const dom.Styles(
                  raw: <String, String>{
                    'display': 'flex',
                    'flex-direction': 'column',
                    'gap': '0.5rem',
                    'margin-top': 'auto',
                    'flex-shrink': '0',
                  },
                ),
                <Component>[props.footer!],
              ),
            if (props.showCloseButton)
              dom.button(
                classes: 'arcane-sheet-close',
                attributes: <String, String>{
                  'type': 'button',
                  'aria-label': 'Close sheet',
                  ...dismissAttrs(),
                },
                styles: const dom.Styles(raw: shadcnOverlayCloseStyles),
                events: <String, EventCallback>{
                  if (props.onClose != null) 'click': (_) => props.onClose!(),
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
    return 'arcane-sheet-$_autoCounter';
  }
}
