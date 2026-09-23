import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/interaction/interaction_attrs.dart';
import 'package:arcane_jaspr/core/props/dialog_props.dart';

/// Shared structural base for the Neon-family dialog renderers (Neon and
/// Neubrutalism).
///
/// Both share an identical DOM: an overlay wrapping a dialog surface that holds
/// an optional close button, an optional `h2` title, the content, and an
/// optional actions row. They differ only in the theme class prefix, the
/// overlay styles, the close button styles, and the auto-generated surface id
/// prefix.
///
/// The ShadCN dialog uses a different DOM (a header/body/footer structure with
/// the title inside the header) and therefore does not extend this base.
///
/// This base lives in core and depends only on core props and interaction
/// helpers; it must never depend on a theme package.
abstract class DialogRenderBase extends StatelessComponent {
  const DialogRenderBase(this.props, {super.key});

  final DialogProps props;

  /// CSS class prefix (e.g. `'neon'`, `'neubrutalism'`).
  String get themePrefix;

  /// Inline styles for the overlay element.
  Map<String, String> get overlayStyles;

  /// Inline styles for the close button.
  Map<String, String> get closeButtonStyles;

  /// Generates the fallback surface id when [DialogProps.id] is null. Each theme
  /// keeps its own static counter so the generated id sequence is preserved.
  String generateAutoId();

  /// Per-instance decoration overrides. Default: none. A theme overrides this
  /// to translate an [ArcaneDecoration] (elevation intent, theme-specific
  /// fields) into its own CSS. Fields a theme does not implement are ignored.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  @override
  Component build(BuildContext context) {
    final String surfaceId = props.id ?? generateAutoId();
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
      classes: '$themePrefix-dialog-overlay',
      attributes: <String, String>{...surfAttrs, 'data-arcane-scrim': ''},
      styles: dom.Styles(raw: overlayStyles),
      events: <String, EventCallback>{
        if (props.onClose != null)
          'arcane:close': (event) {
            if (event.target == event.currentTarget) props.onClose!();
          },
        if (props.barrierDismissible && props.onClose != null)
          'click': (event) {
            if (event.target == event.currentTarget) {
              props.onClose!();
            }
          },
      },
      <Component>[
        dom.div(
          classes: '$themePrefix-dialog',
          attributes: <String, String>{
            'role': 'dialog',
            'aria-modal': 'true',
            'tabindex': '-1',
            'data-arcane-autofocus': '',
            if (props.title != null)
              'aria-labelledby': '$themePrefix-dialog-title-$surfaceId',
          },
          styles: dom.Styles(
            raw: <String, String>{
              'position': 'relative',
              'max-width': '${props.maxWidth}px',
              'width': '100%',
              'padding': '2rem',
              'color': 'var(--foreground)',
              ...?props.decoration?.universalStyles(),
              ...decorationStyles(props.decoration),
              ...?props.styles?.toMap(),
            },
          ),
          events: <String, EventCallback>{
            'click': (event) => event.stopPropagation(),
          },
          <Component>[
            if (props.showCloseButton)
              dom.button(
                classes: '$themePrefix-dialog-close',
                attributes: <String, String>{
                  'type': 'button',
                  'aria-label': 'Close dialog',
                  ...dismissAttrs(),
                },
                styles: dom.Styles(raw: closeButtonStyles),
                events: <String, EventCallback>{
                  if (props.onClose != null) 'click': (_) => props.onClose!(),
                },
                const <Component>[Component.text('\u2715')],
              ),
            if (props.title != null)
              dom.h2(
                id: '$themePrefix-dialog-title-$surfaceId',
                classes: '$themePrefix-dialog-title',
                styles: const dom.Styles(
                  raw: <String, String>{
                    'font-family': 'var(--font-heading)',
                    'font-size': 'var(--font-size-xl)',
                    'font-weight': '600',
                    'letter-spacing': '0.04em',
                    'color': 'var(--foreground)',
                    'margin': '0 0 0.875rem 0',
                    'padding-right': '2rem',
                  },
                ),
                <Component>[Component.text(props.title!)],
              ),
            dom.div(
              classes: '$themePrefix-dialog-content',
              styles: const dom.Styles(
                raw: <String, String>{'color': 'var(--foreground)'},
              ),
              props.content,
            ),
            if (props.actions != null && props.actions!.isNotEmpty)
              dom.div(
                classes: '$themePrefix-dialog-actions',
                styles: const dom.Styles(
                  raw: <String, String>{
                    'display': 'flex',
                    'justify-content': 'flex-end',
                    'gap': '0.625rem',
                    'margin-top': '1.5rem',
                  },
                ),
                props.actions!,
              ),
          ],
        ),
      ],
    );
  }
}

/// Shared structural base for the Neon-family sheet renderers (Neon and
/// Neubrutalism).
///
/// Both share an identical DOM: an overlay wrapping a fixed panel that holds an
/// optional drag handle, an optional header (with a title/description block and
/// a close button, or a custom header), the content, and an optional footer.
/// They differ only in the theme class prefix, the overlay backdrop styles, the
/// drag handle color, the panel border, the close button styles, and the
/// auto-generated surface id prefix.
///
/// The ShadCN sheet computes its panel placement and animations differently and
/// therefore does not extend this base.
abstract class SheetRenderBase extends StatelessComponent {
  const SheetRenderBase(this.props, {super.key});

  final SheetProps props;

  /// CSS class prefix (e.g. `'neon'`, `'neubrutalism'`).
  String get themePrefix;

  /// Inline styles appended to the overlay when [SheetProps.showBackdrop] is
  /// true (the backdrop color and any blur).
  Map<String, String> get overlayBackdropStyles;

  /// Background color of the drag handle.
  String get dragHandleColor;

  /// Border applied to the header bottom and the footer top.
  String get panelBorder;

  /// Inline styles for the close button.
  Map<String, String> get sheetCloseButtonStyles;

  /// Generates the fallback surface id when [SheetProps.id] is null. Each theme
  /// keeps its own static counter so the generated id sequence is preserved.
  String generateAutoId();

  /// Per-instance decoration overrides. Default: none. A theme overrides this
  /// to translate an [ArcaneDecoration] elevation intent into its own CSS.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  bool get _isHorizontal =>
      props.position == SheetPosition.left ||
      props.position == SheetPosition.right;

  @override
  Component build(BuildContext context) {
    final String surfaceId = props.id ?? generateAutoId();

    final String sizeValue = switch (props.size) {
      SheetSizeVariant.auto => 'auto',
      SheetSizeVariant.sm => _isHorizontal ? '320px' : '30vh',
      SheetSizeVariant.md => _isHorizontal ? '440px' : '50vh',
      SheetSizeVariant.lg => _isHorizontal ? '600px' : '70vh',
      SheetSizeVariant.xl => _isHorizontal ? '800px' : '90vh',
      SheetSizeVariant.full => '100%',
    };

    final Map<String, String> positionStyles = switch (props.position) {
      SheetPosition.left => <String, String>{
        'left': '0',
        'top': '0',
        'bottom': '0',
        'width': props.maxWidth ?? sizeValue,
        'max-width': '100vw',
      },
      SheetPosition.right => <String, String>{
        'right': '0',
        'top': '0',
        'bottom': '0',
        'width': props.maxWidth ?? sizeValue,
        'max-width': '100vw',
      },
      SheetPosition.top => <String, String>{
        'left': '0',
        'right': '0',
        'top': '0',
        'height': sizeValue,
        'max-height': '100vh',
      },
      SheetPosition.bottom => <String, String>{
        'left': '0',
        'right': '0',
        'bottom': '0',
        'height': sizeValue,
        'max-height': '100vh',
      },
    };

    return dom.div(
      classes: '$themePrefix-sheet-overlay',
      attributes: <String, String>{
        ...surfaceAttrs(
          surface: 'sheet',
          id: surfaceId,
          initiallyOpen: props.isOpen,
          dismissible: props.closeOnBackdropClick,
          escapeCloses: props.escapeCloses,
          focusTrap: props.focusTrap,
          scrimCloses: props.closeOnBackdropClick,
          restoreFocus: props.restoreFocus,
        ),
        'data-arcane-scrim': '',
        'data-position': props.position.name,
      },
      styles: dom.Styles(
        raw: <String, String>{
          'position': 'fixed',
          'inset': '0',
          'z-index': '50',
          if (props.showBackdrop) ...overlayBackdropStyles,
        },
      ),
      events: <String, EventCallback>{
        if (props.closeOnBackdropClick && props.onClose != null)
          'click': (event) {
            if (event.target == event.currentTarget) {
              props.onClose!();
            }
          },
      },
      <Component>[
        dom.div(
          classes: '$themePrefix-sheet',
          attributes: const <String, String>{
            'role': 'dialog',
            'aria-modal': 'true',
            'data-arcane-autofocus': '',
          },
          styles: dom.Styles(
            raw: <String, String>{
              'position': 'fixed',
              ...positionStyles,
              'display': 'flex',
              'flex-direction': 'column',
              ...?props.decoration?.universalStyles(),
              ...decorationStyles(props.decoration),
              ...?props.styles?.toMap(),
            },
          ),
          events: <String, EventCallback>{
            'click': (event) => event.stopPropagation(),
          },
          <Component>[
            if (props.showDragHandle && !_isHorizontal)
              dom.div(
                classes: '$themePrefix-sheet-drag-handle',
                styles: const dom.Styles(
                  raw: <String, String>{
                    'display': 'flex',
                    'justify-content': 'center',
                    'padding': '0.625rem 0 0.375rem',
                  },
                ),
                <Component>[
                  dom.div(
                    styles: dom.Styles(
                      raw: <String, String>{
                        'width': '40px',
                        'height': '3px',
                        'background': dragHandleColor,
                        'border-radius': 'var(--radius-xs)',
                        'opacity': '0.7',
                      },
                    ),
                    const <Component>[],
                  ),
                ],
              ),
            if (props.header != null ||
                props.title != null ||
                props.showCloseButton)
              _buildHeader(),
            dom.div(
              classes: '$themePrefix-sheet-content',
              styles: const dom.Styles(
                raw: <String, String>{
                  'flex': '1',
                  'overflow-y': 'auto',
                  'padding': '1.5rem',
                },
              ),
              <Component>[props.child],
            ),
            if (props.footer != null)
              dom.div(
                classes: '$themePrefix-sheet-footer',
                styles: dom.Styles(
                  raw: <String, String>{
                    'flex-shrink': '0',
                    'padding': '1rem 1.5rem',
                    'border-top': panelBorder,
                  },
                ),
                <Component>[props.footer!],
              ),
          ],
        ),
      ],
    );
  }

  Component _buildHeader() {
    if (props.header != null) {
      return dom.div(
        classes: '$themePrefix-sheet-header',
        styles: dom.Styles(
          raw: <String, String>{
            'flex-shrink': '0',
            'padding': '1rem 1.5rem',
            'border-bottom': panelBorder,
          },
        ),
        <Component>[props.header!],
      );
    }

    return dom.div(
      classes: '$themePrefix-sheet-header',
      styles: dom.Styles(
        raw: <String, String>{
          'display': 'flex',
          'align-items': 'flex-start',
          'justify-content': 'space-between',
          'flex-shrink': '0',
          'padding': '1rem 1.5rem',
          'border-bottom': panelBorder,
        },
      ),
      <Component>[
        dom.div(
          styles: const dom.Styles(raw: <String, String>{'flex': '1'}),
          <Component>[
            if (props.title != null)
              dom.h2(
                styles: const dom.Styles(
                  raw: <String, String>{
                    'font-family': 'var(--font-heading)',
                    'font-size': 'var(--font-size-lg)',
                    'font-weight': '600',
                    'letter-spacing': '0.04em',
                    'color': 'var(--foreground)',
                    'margin': '0',
                  },
                ),
                <Component>[Component.text(props.title!)],
              ),
            if (props.description != null)
              dom.p(
                styles: const dom.Styles(
                  raw: <String, String>{
                    'font-size': 'var(--font-size-sm)',
                    'color': 'var(--muted-foreground)',
                    'margin': '0.375rem 0 0 0',
                  },
                ),
                <Component>[Component.text(props.description!)],
              ),
          ],
        ),
        if (props.showCloseButton)
          dom.button(
            classes: '$themePrefix-sheet-close',
            attributes: <String, String>{
              'type': 'button',
              'aria-label': 'Close sheet',
              ...dismissAttrs(),
            },
            styles: dom.Styles(raw: sheetCloseButtonStyles),
            events: <String, EventCallback>{
              if (props.onClose != null) 'click': (_) => props.onClose!(),
            },
            const <Component>[Component.text('\u2715')],
          ),
      ],
    );
  }
}
