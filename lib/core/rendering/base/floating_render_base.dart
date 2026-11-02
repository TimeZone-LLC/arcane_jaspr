import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/dom_value.dart';
import 'package:arcane_jaspr/core/interaction/interaction.dart';
import 'package:arcane_jaspr/core/interaction/interaction_attrs.dart';
import 'package:arcane_jaspr/core/props/floating_props.dart';

/// Shared structural base for themed floating renderers.
///
/// Floating is the unified tooltip/popover/hovercard component. Every theme
/// shares the exact same scaffolding: the `build()` dispatch between a CSS-only
/// text tooltip and a state-controlled panel, the trigger/anchor wiring, the
/// `surfaceAttrs` computation, the role logic, the arrow/content child
/// assembly, and the three position-math tables (which are byte-for-byte
/// identical across themes). This base factors all of that, leaving only the
/// theme-divergent CSS class strings and the four style maps (CSS tooltip,
/// floating content, arrow) plus the auto-id prefix to abstract members the
/// subclass supplies.
///
/// This base lives in core and depends only on core props and interaction
/// helpers; it must never depend on a theme package.
abstract class FloatingRenderBase extends StatelessComponent {
  const FloatingRenderBase(this.props, {super.key});

  final FloatingProps props;

  /// Class for the stateful floating container (e.g.
  /// `'arcane-floating-container'`).
  String get containerClass;

  /// Class string for the floating content surface, given whether it carries
  /// rich content (popover) versus plain text (tooltip).
  String floatingContentClasses(bool hasRichContent);

  /// Full style map for the floating content surface.
  Map<String, String> floatingContentStyles({
    required String positionProp,
    required String positionValue,
    required Map<String, String> alignment,
    required bool hasRichContent,
    required double? maxWidth,
  });

  /// Per-instance decoration overrides. Default: none. A theme overrides this
  /// to translate an [ArcaneDecoration] (elevation intent, theme-specific
  /// fields) into its own CSS. Fields a theme does not implement are ignored.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  /// Class for the floating arrow element.
  String get arrowClass;

  /// Full style map for the floating arrow. [arrowPositionStyles] are the
  /// resolved arrow offsets and must be spread last to match each theme.
  Map<String, String> arrowStyles(Map<String, String> arrowPositionStyles);

  /// Generates a theme-prefixed auto id when no explicit id is supplied. Each
  /// subclass owns its static counter so the generated sequence is unchanged.
  String generateAutoId();

  @override
  Component build(BuildContext context) {
    return _buildStatefulFloating();
  }

  /// Builds a state-controlled floating panel for rich content.
  Component _buildStatefulFloating() {
    final bool isOpen = props.isOpen ?? false;
    final bool useHoverEvents = props.triggerType == FloatingTrigger.hover;
    final bool useClickEvents = props.triggerType == FloatingTrigger.click;
    final String surfaceId = props.id ?? generateAutoId();
    final String anchorId = '$surfaceId-trigger';
    final String surfaceKind = useHoverEvents ? 'hovercard' : 'popover';

    final Map<String, String> triggerWrapperAttrs = <String, String>{
      'data-arcane-anchor-id': anchorId,
      if (useClickEvents)
        ...interactionAttrs(ArcaneInteraction.togglePopover(surfaceId)),
      if (useHoverEvents) ...<String, String>{
        'data-arcane-mouseenter': 'surface.hoverOpen:$surfaceId',
        'data-arcane-mouseleave': 'surface.hoverClose:$surfaceId',
      },
      if (useHoverEvents && props.openDelay > 0)
        'data-arcane-hover-open-delay': props.openDelay.toString(),
      if (useHoverEvents && props.closeDelay > 0)
        'data-arcane-hover-close-delay': props.closeDelay.toString(),
    };

    return dom.div(
      classes: containerClass,
      styles: const dom.Styles(
        raw: <String, String>{
          'position': 'relative',
          'display': 'inline-block',
        },
      ),
      events: <String, EventCallback>{
        if (useHoverEvents) 'mouseenter': (_) => props.onMouseEnter?.call(),
        if (useHoverEvents) 'mouseleave': (_) => props.onMouseLeave?.call(),
        if (useHoverEvents)
          'focusin': (event) {
            if (!domEventRelatedTargetIsInside(event)) props.onFocus?.call();
          },
        if (useHoverEvents)
          'focusout': (event) {
            if (!domEventRelatedTargetIsInside(event)) props.onBlur?.call();
          },
        if (useHoverEvents && isOpen && props.closeOnEscape)
          'keydown': (event) {
            if (domEventKey(event) == 'Escape') {
              event.preventDefault();
              event.stopPropagation();
              props.onOpenChange?.call(false);
            }
          },
      },
      <Component>[
        dom.div(
          attributes: triggerWrapperAttrs,
          styles: const dom.Styles(
            raw: <String, String>{'display': 'inline-block'},
          ),
          events: <String, EventCallback>{
            if (useClickEvents && props.onToggle != null)
              'click': (event) {
                event.stopPropagation();
                props.onToggle!.call();
              },
          },
          <Component>[props.trigger],
        ),
        _buildFloatingContent(
          surfaceId: surfaceId,
          anchorId: anchorId,
          surfaceKind: surfaceKind,
          initiallyOpen: isOpen,
        ),
      ],
    );
  }

  Component _buildFloatingContent({
    required String surfaceId,
    required String anchorId,
    required String surfaceKind,
    required bool initiallyOpen,
  }) {
    final (
      String positionProp,
      String positionValue,
      Map<String, String> alignment,
    ) = _getPositionStylesForPanel();
    final bool hasRichContent = props.content != null;
    final double? maxWidth = props.maxWidth;
    final Map<String, String> overrideStyles = <String, String>{
      ...?props.decoration?.universalStyles(),
      ...decorationStyles(props.decoration),
      ...?props.styles?.toMap(),
    };

    final Map<String, String> surfAttrs = surfaceAttrs(
      surface: surfaceKind,
      id: surfaceId,
      initiallyOpen: initiallyOpen,
      dismissible: props.closeOnOutsideClick,
      escapeCloses: props.closeOnEscape,
      focusTrap: false,
      scrimCloses: props.closeOnOutsideClick,
      restoreFocus: surfaceKind != 'hovercard',
      anchorId: anchorId,
      anchorPlacement: _anchorPlacement,
      anchorAlign: _anchorAlign,
      anchorOffset: props.offset.toString(),
    );

    return dom.div(
      classes: floatingContentClasses(hasRichContent),
      attributes: <String, String>{
        'role': surfaceKind == 'hovercard' ? 'tooltip' : 'dialog',
        ...surfAttrs,
        if (alignment.containsKey('transform') &&
            !overrideStyles.containsKey('transform'))
          'data-arcane-anchor-transform': alignment['transform']!,
      },
      events: <String, EventCallback>{
        'arcane:close': (_) => props.onOpenChange?.call(false),
      },
      styles: dom.Styles(
        raw: <String, String>{
          ...floatingContentStyles(
            positionProp: positionProp,
            positionValue: positionValue,
            alignment: alignment,
            hasRichContent: hasRichContent,
            maxWidth: maxWidth,
          ),
          ...overrideStyles,
        },
      ),
      <Component>[
        if (props.showArrow) _buildArrow(),
        if (props.content != null)
          props.content!
        else if (props.textContent != null)
          Component.text(props.textContent!),
      ],
    );
  }

  String get _anchorPlacement => switch (props.position) {
    FloatingPosition.top ||
    FloatingPosition.topStart ||
    FloatingPosition.topEnd => 'top',
    FloatingPosition.bottom ||
    FloatingPosition.bottomStart ||
    FloatingPosition.bottomEnd => 'bottom',
    FloatingPosition.left => 'left',
    FloatingPosition.right => 'right',
  };

  String get _anchorAlign => switch (props.position) {
    FloatingPosition.topStart || FloatingPosition.bottomStart => 'start',
    FloatingPosition.topEnd || FloatingPosition.bottomEnd => 'end',
    FloatingPosition.top ||
    FloatingPosition.bottom ||
    FloatingPosition.left ||
    FloatingPosition.right => 'center',
  };

  Component _buildArrow() {
    return dom.div(
      classes: arrowClass,
      styles: dom.Styles(raw: arrowStyles(_getArrowStyles())),
      const <Component>[],
    );
  }

  (String, String, Map<String, String>) _getPositionStylesForPanel() {
    final String offsetPx = '${props.offset}px';

    return switch (props.position) {
      FloatingPosition.top => (
        'bottom',
        'calc(100% + $offsetPx)',
        const <String, String>{'left': '50%', 'transform': 'translateX(-50%)'},
      ),
      FloatingPosition.bottom => (
        'top',
        'calc(100% + $offsetPx)',
        const <String, String>{'left': '50%', 'transform': 'translateX(-50%)'},
      ),
      FloatingPosition.left => (
        'right',
        'calc(100% + $offsetPx)',
        const <String, String>{'top': '50%', 'transform': 'translateY(-50%)'},
      ),
      FloatingPosition.right => (
        'left',
        'calc(100% + $offsetPx)',
        const <String, String>{'top': '50%', 'transform': 'translateY(-50%)'},
      ),
      FloatingPosition.topStart => (
        'bottom',
        'calc(100% + $offsetPx)',
        const <String, String>{'left': '0'},
      ),
      FloatingPosition.topEnd => (
        'bottom',
        'calc(100% + $offsetPx)',
        const <String, String>{'right': '0'},
      ),
      FloatingPosition.bottomStart => (
        'top',
        'calc(100% + $offsetPx)',
        const <String, String>{'left': '0'},
      ),
      FloatingPosition.bottomEnd => (
        'top',
        'calc(100% + $offsetPx)',
        const <String, String>{'right': '0'},
      ),
    };
  }

  Map<String, String> _getArrowStyles() {
    return switch (props.position) {
      FloatingPosition.top ||
      FloatingPosition.topStart ||
      FloatingPosition.topEnd => const <String, String>{
        'bottom': '-6px',
        'left': '50%',
        'transform': 'translateX(-50%) rotate(225deg)',
      },
      FloatingPosition.bottom ||
      FloatingPosition.bottomStart ||
      FloatingPosition.bottomEnd => const <String, String>{
        'top': '-6px',
        'left': '50%',
        'transform': 'translateX(-50%) rotate(45deg)',
      },
      FloatingPosition.left => const <String, String>{
        'right': '-6px',
        'top': '50%',
        'transform': 'translateY(-50%) rotate(135deg)',
      },
      FloatingPosition.right => const <String, String>{
        'left': '-6px',
        'top': '50%',
        'transform': 'translateY(-50%) rotate(-45deg)',
      },
    };
  }
}
