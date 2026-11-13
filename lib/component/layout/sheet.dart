import 'package:arcane_jaspr/flutter.dart';
import 'package:jaspr/jaspr.dart'
    hide
        BuildContext,
        InheritedComponent,
        Key,
        State,
        StatefulComponent,
        StatelessComponent,
        UniqueKey,
        ValueKey,
        runApp;
import 'package:jaspr/dom.dart' as dom;

import '../../core/decoration/arcane_decoration.dart';
import '../../core/theme_provider.dart';
import '../../core/props/dialog_props.dart' as props;
import '../../util/style_types/arcane_style_data.dart';
import 'sheet_types.dart';

export 'sheet_types.dart';

export '../../core/props/dialog_props.dart' show SheetSizeVariant, SheetProps;

/// A modal sheet that slides in from screen edges.
class ArcaneSheet extends StatelessWidget {
  final String? id;
  final bool isOpen;
  final VoidCallback? onClose;
  final SheetPosition position;
  final SheetSize size;
  final Widget child;
  final String? title;
  final String? description;
  final Widget? header;

  /// Optional widget on the title's line, after the title (an info
  /// button). Null renders the header as before.
  final Widget? titleTrailing;
  final Widget? footer;
  final bool showBackdrop;
  final bool closeOnBackdropClick;
  final bool showCloseButton;
  final bool showDragHandle;
  final String? maxWidth;
  final bool escapeCloses;
  final bool focusTrap;
  final bool restoreFocus;

  /// Literal, theme-permeable style override (always applied, wins over theme).
  final ArcaneStyleData? styles;

  /// Semantic, theme-interpreted decoration (elevation + theme-specific fields).
  final ArcaneDecoration? decoration;

  const ArcaneSheet({
    this.id,
    required this.isOpen,
    required this.child,
    this.onClose,
    this.position = SheetPosition.bottom,
    this.size = SheetSize.auto,
    this.title,
    this.description,
    this.header,
    this.titleTrailing,
    this.footer,
    this.showBackdrop = true,
    this.closeOnBackdropClick = true,
    this.showCloseButton = true,
    this.showDragHandle = true,
    this.maxWidth,
    this.escapeCloses = true,
    this.focusTrap = true,
    this.restoreFocus = true,
    this.styles,
    this.decoration,
    super.key,
  });

  const ArcaneSheet.bottom({
    this.id,
    required this.isOpen,
    required this.child,
    this.onClose,
    this.size = SheetSize.auto,
    this.title,
    this.description,
    this.header,
    this.titleTrailing,
    this.footer,
    this.showBackdrop = true,
    this.closeOnBackdropClick = true,
    this.showCloseButton = false,
    this.showDragHandle = true,
    this.maxWidth,
    this.escapeCloses = true,
    this.focusTrap = true,
    this.restoreFocus = true,
    this.styles,
    this.decoration,
    super.key,
  }) : position = SheetPosition.bottom;

  const ArcaneSheet.top({
    this.id,
    required this.isOpen,
    required this.child,
    this.onClose,
    this.size = SheetSize.auto,
    this.title,
    this.description,
    this.header,
    this.titleTrailing,
    this.footer,
    this.showBackdrop = true,
    this.closeOnBackdropClick = true,
    this.showCloseButton = true,
    this.showDragHandle = false,
    this.maxWidth,
    this.escapeCloses = true,
    this.focusTrap = true,
    this.restoreFocus = true,
    this.styles,
    this.decoration,
    super.key,
  }) : position = SheetPosition.top;

  const ArcaneSheet.end({
    this.id,
    required this.isOpen,
    required this.child,
    this.onClose,
    this.size = SheetSize.md,
    this.title,
    this.description,
    this.header,
    this.titleTrailing,
    this.footer,
    this.showBackdrop = true,
    this.closeOnBackdropClick = true,
    this.showCloseButton = true,
    this.showDragHandle = false,
    this.maxWidth,
    this.escapeCloses = true,
    this.focusTrap = true,
    this.restoreFocus = true,
    this.styles,
    this.decoration,
    super.key,
  }) : position = SheetPosition.end;

  props.SheetPosition get _propsPosition => switch (position) {
    SheetPosition.bottom => props.SheetPosition.bottom,
    SheetPosition.top => props.SheetPosition.top,
    SheetPosition.end => props.SheetPosition.right,
    SheetPosition.start => props.SheetPosition.left,
  };

  props.SheetSizeVariant get _propsSize => switch (size) {
    SheetSize.auto => props.SheetSizeVariant.auto,
    SheetSize.sm => props.SheetSizeVariant.sm,
    SheetSize.md => props.SheetSizeVariant.md,
    SheetSize.lg => props.SheetSizeVariant.lg,
    SheetSize.xl => props.SheetSizeVariant.xl,
    SheetSize.full => props.SheetSizeVariant.full,
  };

  @override
  Widget build(BuildContext context) {
    return context.renderers.sheet(
      props.SheetProps(
        id: id,
        isOpen: isOpen,
        child: child,
        position: _propsPosition,
        size: _propsSize,
        onClose: onClose,
        showCloseButton: showCloseButton,
        title: title,
        description: description,
        header: header,
        titleTrailing: titleTrailing,
        footer: footer,
        showBackdrop: showBackdrop,
        closeOnBackdropClick: closeOnBackdropClick,
        showDragHandle: showDragHandle,
        maxWidth: maxWidth,
        escapeCloses: escapeCloses,
        focusTrap: focusTrap,
        restoreFocus: restoreFocus,
        styles: styles,
        decoration: decoration,
      ),
    );
  }
}

/// Action sheet with a list of actions (mobile-style).
class ArcaneActionSheet extends StatelessWidget {
  final bool isOpen;
  final VoidCallback? onClose;
  final String? title;
  final String? message;
  final List<ActionSheetItem> actions;
  final bool showCancel;
  final String cancelLabel;

  const ArcaneActionSheet({
    required this.isOpen,
    required this.actions,
    this.onClose,
    this.title,
    this.message,
    this.showCancel = true,
    this.cancelLabel = 'Cancel',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ArcaneSheet.bottom(
      isOpen: isOpen,
      onClose: onClose,
      showCloseButton: false,
      showDragHandle: true,
      child: dom.div(
        styles: const dom.Styles(
          raw: {'display': 'flex', 'flex-direction': 'column', 'gap': '4px'},
        ),
        [
          if (title != null || message != null)
            dom.div(
              styles: const dom.Styles(
                raw: {
                  'text-align': 'center',
                  'padding-bottom': '16px',
                  'margin-bottom': '8px',
                  'border-bottom': '1px solid var(--border)',
                },
              ),
              [
                if (title != null)
                  dom.div(
                    styles: const dom.Styles(
                      raw: {
                        'font-size': '1rem',
                        'font-weight': '600',
                        'color': 'var(--foreground)',
                        'margin-bottom': '4px',
                      },
                    ),
                    [Component.text(title!)],
                  ),
                if (message != null)
                  dom.div(
                    styles: const dom.Styles(
                      raw: {
                        'font-size': '0.875rem',
                        'color': 'var(--muted-foreground)',
                      },
                    ),
                    [Component.text(message!)],
                  ),
              ],
            ),
          for (final action in actions) _buildActionItem(action),
          if (showCancel) ...[
            const dom.div(styles: dom.Styles(raw: {'height': '8px'}), []),
            dom.button(
              styles: const dom.Styles(
                raw: {
                  'width': '100%',
                  'padding': '16px',
                  'border': 'none',
                  'background': 'var(--secondary)',
                  'color': 'var(--foreground)',
                  'font-size': '1rem',
                  'font-weight': '500',
                  'border-radius': '8px',
                  'cursor': 'pointer',
                  'transition': 'background 150ms ease',
                },
              ),
              events: {'click': (_) => onClose?.call()},
              [Component.text(cancelLabel)],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionItem(ActionSheetItem action) {
    return dom.button(
      classes:
          'arcane-action-sheet-item ${action.destructive ? 'destructive' : ''}',
      styles: dom.Styles(
        raw: {
          'width': '100%',
          'display': 'flex',
          'align-items': 'center',
          'gap': '16px',
          'padding': '16px',
          'border': 'none',
          'background': 'transparent',
          'color': action.destructive
              ? 'var(--destructive)'
              : 'var(--foreground)',
          'font-size': '1rem',
          'border-radius': '6px',
          'cursor': action.disabled ? 'not-allowed' : 'pointer',
          'opacity': action.disabled ? '0.5' : '1',
          'transition': 'background 150ms ease',
        },
      ),
      events: action.disabled
          ? null
          : {
              'click': (_) {
                action.onTap?.call();
                if (action.closeOnTap) onClose?.call();
              },
            },
      [
        if (action.icon != null)
          dom.span(styles: const dom.Styles(raw: {'font-size': '1.125rem'}), [
            Component.text(action.icon!),
          ]),
        dom.span(
          styles: const dom.Styles(raw: {'flex': '1', 'text-align': 'left'}),
          [Component.text(action.label)],
        ),
        if (action.trailing != null) action.trailing!,
      ],
    );
  }
}

/// An action item for ArcaneActionSheet.
class ActionSheetItem {
  final String label;
  final String? icon;
  final bool destructive;
  final bool disabled;
  final VoidCallback? onTap;
  final bool closeOnTap;
  final Widget? trailing;

  const ActionSheetItem({
    required this.label,
    this.icon,
    this.destructive = false,
    this.disabled = false,
    this.onTap,
    this.closeOnTap = true,
    this.trailing,
  });
}
