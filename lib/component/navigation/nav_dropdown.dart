import 'package:arcane_jaspr/flutter.dart';

import '../../core/dom_value.dart';
import '../../util/arcane.dart';
import '../../util/style_types/index.dart';
import '../html/arcane_link.dart';
import '../html/arcane_span.dart';
import '../html/div.dart';
import '../typography/text.dart';
import '../view/icon.dart';

/// Navigation dropdown for header menus.
///
/// Opens on hover, click, touch, or keyboard activation. An invisible bridge
/// maintains hover state when moving from the trigger to the content.
///
/// Example:
/// ```dart
/// ArcaneNavDropdown(
///   label: 'Products',
///   width: '300px',
///   content: Column([...]),
/// )
/// ```
class ArcaneNavDropdown extends StatefulWidget {
  /// The trigger label text.
  final String label;

  /// Width of the dropdown panel.
  final String width;

  /// Content to display in the dropdown panel.
  final Widget content;

  /// Whether to align the dropdown to the right side.
  final bool alignRight;

  const ArcaneNavDropdown({
    required this.label,
    required this.width,
    required this.content,
    this.alignRight = false,
    super.key,
  });

  @override
  State<ArcaneNavDropdown> createState() => _ArcaneNavDropdownState();
}

class _ArcaneNavDropdownState extends State<ArcaneNavDropdown> {
  static final Set<_ArcaneNavDropdownState> _openDropdowns =
      <_ArcaneNavDropdownState>{};

  bool _isOpen = false;
  bool _openedByHover = false;

  void _openFromHover() {
    if (_isOpen) return;
    _closeOpenPeers();
    setState(() {
      _isOpen = true;
      _openedByHover = true;
    });
    _openDropdowns.add(this);
  }

  void _closeFromHover() {
    if (!_openedByHover) return;
    _close();
  }

  void _toggleFromActivation() {
    if (_openedByHover) {
      setState(() {
        _openedByHover = false;
      });
      return;
    }

    if (_isOpen) {
      _close();
      return;
    }

    _closeOpenPeers();
    setState(() {
      _isOpen = true;
      _openedByHover = false;
    });
    _openDropdowns.add(this);
  }

  void _close() {
    _openDropdowns.remove(this);
    if (!_isOpen || !mounted) return;
    setState(() {
      _isOpen = false;
      _openedByHover = false;
    });
  }

  void _closeOpenPeers() {
    final List<_ArcaneNavDropdownState> peers =
        List<_ArcaneNavDropdownState>.of(_openDropdowns);
    for (final _ArcaneNavDropdownState peer in peers) {
      if (!identical(peer, this)) peer._close();
    }
  }

  @override
  void dispose() {
    _openDropdowns.remove(this);
    super.dispose();
  }

  void _handleTriggerKeyDown(dynamic event) {
    switch (domEventKey(event)) {
      case 'Enter':
      case ' ':
        domPreventDefault(event);
        _toggleFromActivation();
        return;
      case 'Escape':
        domPreventDefault(event);
        _close();
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ArcaneDiv(
      styles: const ArcaneStyleData(
        position: Position.relative,
        display: Display.inlineFlex,
      ),
      events: {
        'mouseenter': (_) => _openFromHover(),
        'mouseleave': (_) => _closeFromHover(),
      },
      children: [
        // Trigger button
        ArcaneDiv(
          styles: ArcaneStyleData(
            display: Display.flex,
            alignItems: AlignItems.center,
            justifyContent: widget.alignRight ? null : JustifyContent.center,
            gap: Gap.xs,
            padding: PaddingPreset.smMd,
            borderRadius: Radius.sm,
            cursor: Cursor.pointer,
            textColorCustom: _isOpen
                ? 'var(--foreground)'
                : 'var(--muted-foreground)',
            fontSize: FontSize.sm,
            fontWeight: FontWeight.w500,
            transition: Transition.allFast,
            backgroundCustom: _isOpen
                ? 'color-mix(in srgb, var(--foreground) 5%, transparent)'
                : 'transparent',
          ),
          attributes: {
            'role': 'button',
            'tabindex': '0',
            'aria-haspopup': 'menu',
            'aria-expanded': _isOpen ? 'true' : 'false',
          },
          events: {
            'click': (_) => _toggleFromActivation(),
            'keydown': _handleTriggerKeyDown,
          },
          children: [
            Text(widget.label),
            ArcaneDiv(
              styles: ArcaneStyleData(
                transition: Transition.allFast,
                transformCustom: _isOpen ? 'rotate(180deg)' : 'rotate(0deg)',
              ),
              children: [ArcaneIcon.chevronDown(size: IconSize.xs)],
            ),
          ],
        ),
        // Dropdown panel with bridge for hover continuity
        if (_isOpen) ...[
          // Invisible bridge to maintain hover when moving to dropdown
          const ArcaneDiv(
            styles: ArcaneStyleData(
              position: Position.absolute,
              top: '100%',
              left: '0',
              right: '0',
              heightCustom: '12px',
            ),
            children: [],
          ),
          ArcaneDiv(
            classes: const <String>['arcane-nav-dropdown-panel'],
            styles: ArcaneStyleData(
              position: Position.absolute,
              top: 'calc(100% + 8px)',
              left: widget.alignRight ? null : '0',
              right: widget.alignRight ? '0' : null,
              backgroundCustom:
                  'var(--arcane-nav-dropdown-background, var(--card))',
              borderCustom:
                  '1px solid color-mix(in srgb, var(--foreground) 10%, transparent)',
              borderRadius: Radius.sm,
              minWidth: widget.width,
              zIndex: ZIndex.popover,
              animation: AnimationPreset.dropdownFade,
              transformOrigin: widget.alignRight
                  ? TransformOrigin.topRight
                  : TransformOrigin.topLeft,
            ),
            children: [widget.content],
          ),
        ],
      ],
    );
  }
}

/// Section header for dropdown menus - compact uppercase label.
class ArcaneDropdownSectionHeader extends StatelessWidget {
  final String title;

  const ArcaneDropdownSectionHeader({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return ArcaneDiv(
      styles: const ArcaneStyleData(
        padding: PaddingPreset.xs,
        margin: MarginPreset.bottomXs,
      ),
      children: [
        ArcaneSpan(
          styles: const ArcaneStyleData(
            fontSize: FontSize.xxs,
            fontWeight: FontWeight.w600,
            textColor: TextColor.muted,
            textTransform: TextTransform.uppercase,
            letterSpacing: LetterSpacing.wide,
          ),
          child: Text(title),
        ),
      ],
    );
  }
}

/// Divider for dropdown menus - subtle horizontal line.
class ArcaneDropdownDivider extends StatelessWidget {
  const ArcaneDropdownDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const ArcaneDiv(
      styles: ArcaneStyleData(
        heightCustom: '1px',
        backgroundCustom:
            'color-mix(in srgb, var(--foreground) 8%, transparent)',
        marginStringCustom: '6px 0',
      ),
      children: [],
    );
  }
}

/// Style variants for dropdown items
enum ArcaneDropdownItemStyle {
  /// Simple icon + label with subtle background - for resource links
  simple,

  /// Minimal padding and spacing - for compact lists
  compact,
}

/// Dropdown item component with multiple style variants.
///
/// Supports simple inline icons and a compact style for dense lists.
class ArcaneDropdownItem extends StatefulWidget {
  final String label;
  final String? description;
  final String href;
  final ArcaneGlyph icon;
  final bool isExternal;
  final ArcaneDropdownItemStyle variant;

  const ArcaneDropdownItem({
    required this.label,
    required this.href,
    required this.icon,
    this.description,
    this.isExternal = false,
    this.variant = ArcaneDropdownItemStyle.simple,
    super.key,
  });

  @override
  State<ArcaneDropdownItem> createState() => _ArcaneDropdownItemState();
}

class _ArcaneDropdownItemState extends State<ArcaneDropdownItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return switch (widget.variant) {
      ArcaneDropdownItemStyle.simple => _buildSimpleStyle(),
      ArcaneDropdownItemStyle.compact => _buildCompactStyle(),
    };
  }

  /// Simple style - compact minimal design with icon
  Widget _buildSimpleStyle() {
    return ArcaneLink.children(
      href: widget.href,
      target: widget.isExternal ? '_blank' : null,
      rel: widget.isExternal ? 'noopener noreferrer' : null,
      styles: ArcaneStyleData(
        display: Display.flex,
        alignItems: AlignItems.center,
        gap: Gap.sm,
        padding: PaddingPreset.sm,
        borderRadius: Radius.sm,
        textDecoration: TextDecoration.none,
        fontSize: FontSize.sm,
        transition: Transition.allFast,
        textColorCustom: _isHovered
            ? 'var(--foreground)'
            : 'var(--muted-foreground)',
        backgroundCustom: _isHovered
            ? 'color-mix(in srgb, var(--foreground) 5%, transparent)'
            : 'transparent',
      ),
      events: {
        'mouseenter': (_) => setState(() => _isHovered = true),
        'mouseleave': (_) => setState(() => _isHovered = false),
      },
      children: [
        // Icon
        ArcaneDiv(
          styles: ArcaneStyleData(
            textColorCustom: _isHovered
                ? 'var(--foreground)'
                : 'var(--muted-foreground)',
            transition: Transition.allFast,
          ),
          children: [widget.icon],
        ),
        // Label
        ArcaneSpan(
          styles: const ArcaneStyleData(flexGrow: 1),
          child: Text(widget.label),
        ),
      ],
    );
  }

  /// Compact style - minimal padding and spacing
  Widget _buildCompactStyle() {
    return ArcaneLink.children(
      href: widget.href,
      target: widget.isExternal ? '_blank' : null,
      rel: widget.isExternal ? 'noopener noreferrer' : null,
      styles: ArcaneStyleData(
        display: Display.flex,
        alignItems: AlignItems.center,
        gap: Gap.sm,
        padding: PaddingPreset.sm,
        borderRadius: Radius.sm,
        textDecoration: TextDecoration.none,
        fontSize: FontSize.sm,
        transition: Transition.allFast,
        textColorCustom: _isHovered
            ? 'var(--foreground)'
            : 'var(--muted-foreground)',
        backgroundCustom: _isHovered
            ? 'color-mix(in srgb, var(--foreground) 5%, transparent)'
            : 'transparent',
      ),
      events: {
        'mouseenter': (_) => setState(() => _isHovered = true),
        'mouseleave': (_) => setState(() => _isHovered = false),
      },
      children: [
        ArcaneDiv(
          styles: ArcaneStyleData(
            textColorCustom: _isHovered
                ? 'var(--foreground)'
                : 'var(--muted-foreground)',
            transition: Transition.allFast,
          ),
          children: [widget.icon],
        ),
        Text(widget.label),
      ],
    );
  }
}
