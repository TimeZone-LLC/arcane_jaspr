import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/component/view/icon.dart';
import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/interaction/interaction.dart';
import 'package:arcane_jaspr/core/interaction/interaction_attrs.dart';
import 'package:arcane_jaspr/core/props/command_props.dart';

/// Shared structural base for themed command-palette renderers.
///
/// Every theme's command palette shares the same overlay/dialog scaffold, the
/// surface attribute wiring, the search-input markup, the group/item iteration
/// and the (byte-identical) empty state and item attribute block. The themes
/// diverge only in class strings, style maps, the keyboard-hint footer and the
/// trailing shortcut hint. This base factors the shared structure and exposes
/// the divergent nodes as abstract sub-builders and the divergent values as
/// abstract members.
///
/// This base lives in core and depends only on core props, interaction helpers
/// and the icon view; it must never depend on a theme package.
abstract class CommandRenderBase extends StatelessComponent {
  const CommandRenderBase(this.props, {super.key});

  final CommandProps props;

  /// Generates the auto surface id when [CommandProps.id] is null. Each theme
  /// keeps its own static counter and id prefix.
  String autoId();

  /// Class string for the root overlay/scrim element.
  String get overlayClasses;

  /// Inline styles for the root overlay/scrim element.
  Map<String, String> get overlayStyles;

  /// Class string for the dialog panel element.
  String get dialogClasses;

  /// Inline styles for the dialog panel element.
  Map<String, String> get dialogStyles;

  /// Per-instance decoration overrides. Default: none. A theme overrides this
  /// to translate an [ArcaneDecoration] elevation intent into its own CSS.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  /// Inline styles for the search-input row.
  Map<String, String> get searchRowStyles;

  /// Inline styles for the search icon span.
  Map<String, String> get searchIconStyles;

  /// CSS class applied to the raw `<input>` element.
  String get inputClass;

  /// Trailing portion of the `<input>` inline style (after the shared prefix
  /// `flex:1;background:transparent;border:none;`).
  String get inputStyleSuffix;

  /// Class string for the results list element.
  String get listClasses;

  /// Inline styles for the results list element.
  Map<String, String> get listStyles;

  /// CSS class applied to a group heading.
  String get groupHeadingClass;

  /// Inline styles for a group heading.
  Map<String, String> get groupHeadingStyles;

  /// Inline styles for the footer element.
  Map<String, String> get footerStyles;

  /// Base CSS class for an item row (the `disabled` marker is appended by the
  /// base when the item is disabled).
  String get itemBaseClass;

  /// Visual styles for a single command item row.
  Map<String, String> itemStyles(CommandItemProps item);

  /// The shortcut hint shown at the trailing end of an item.
  Component buildShortcut(String shortcut);

  /// The keyboard-hint components shown in the footer.
  List<Component> buildKeyHints();

  @override
  Component build(BuildContext context) {
    final String surfaceId = props.id ?? autoId();

    final Map<String, String> surfAttrs = surfaceAttrs(
      surface: 'command',
      id: surfaceId,
      initiallyOpen: props.isOpen,
      dismissible: true,
      escapeCloses: props.escapeCloses,
      focusTrap: props.focusTrap,
      scrimCloses: props.scrimCloses,
      restoreFocus: props.restoreFocus,
    );

    return dom.div(
      classes: overlayClasses,
      attributes: <String, String>{
        ...surfAttrs,
        'data-arcane-command': surfaceId,
      },
      styles: dom.Styles(raw: overlayStyles),
      [
        dom.div(
          classes: dialogClasses,
          attributes: const <String, String>{
            'role': 'dialog',
            'aria-modal': 'true',
            'aria-label': 'Command palette',
          },
          styles: dom.Styles(
            raw: <String, String>{
              ...dialogStyles,
              ...?props.decoration?.universalStyles(),
              ...decorationStyles(props.decoration),
              ...?props.styles?.toMap(),
            },
          ),
          [
            dom.div(styles: dom.Styles(raw: searchRowStyles), [
              dom.span(styles: dom.Styles(raw: searchIconStyles), [
                ArcaneIcon.search(size: IconSize.md),
              ]),
              dom.RawText(
                '<input class="$inputClass" type="text" '
                'aria-label="Search commands" '
                'placeholder="${props.placeholder}" '
                'autofocus autocomplete="off" spellcheck="false" '
                'data-arcane-command-input="$surfaceId" '
                'data-arcane-input="command.filter:$surfaceId" '
                'value="${props.searchQuery}" '
                'style="flex:1;background:transparent;border:none;'
                '$inputStyleSuffix">',
              ),
            ]),
            dom.div(
              classes: listClasses,
              attributes: const <String, String>{'role': 'listbox'},
              styles: dom.Styles(raw: listStyles),
              [
                dom.div(
                  attributes: <String, String>{
                    'data-arcane-command-empty': 'true',
                    if (props.filteredItems.isNotEmpty) 'hidden': '',
                  },
                  styles: const dom.Styles(
                    raw: <String, String>{
                      'padding': '24px',
                      'text-align': 'center',
                      'color': 'var(--muted-foreground)',
                      'font-size': 'var(--font-size-sm)',
                    },
                  ),
                  [Component.text(props.emptyMessage)],
                ),
                for (final CommandGroupProps group in props.groups)
                  _buildGroup(group, surfaceId),
              ],
            ),
            dom.div(styles: dom.Styles(raw: footerStyles), buildKeyHints()),
          ],
        ),
      ],
    );
  }

  Component _buildGroup(CommandGroupProps group, String surfaceId) {
    final String groupId = (group.heading ?? 'group').toLowerCase().replaceAll(
      RegExp(r'[^a-z0-9]+'),
      '-',
    );
    return dom.div(
      attributes: <String, String>{'data-arcane-command-group': groupId},
      [
        if (group.heading != null)
          dom.div(
            classes: groupHeadingClass,
            styles: dom.Styles(raw: groupHeadingStyles),
            [Component.text(group.heading!)],
          ),
        for (final CommandItemProps item in group.items)
          _buildItem(item, group.heading, surfaceId, groupId),
      ],
    );
  }

  Component _buildItem(
    CommandItemProps item,
    String? groupName,
    String surfaceId,
    String groupId,
  ) {
    final String? href = item.href;
    final String action = encodeArcaneActions(<ArcaneInteraction>[
      if (href != null && href.isNotEmpty)
        ArcaneInteraction.navigate(href, external: item.hrefTarget == '_blank'),
      ArcaneInteraction.closeCommand(surfaceId),
    ]);

    return dom.div(
      classes: '$itemBaseClass ${item.disabled ? 'disabled' : ''}',
      attributes: <String, String>{
        'role': 'option',
        'aria-selected': 'false',
        if (item.disabled) 'aria-disabled': 'true',
        'data-arcane-command-item': 'true',
        'data-arcane-command-group-id': groupId,
        if (item.href != null) 'data-href': item.href!,
        if (item.hrefTarget != null) 'data-target': item.hrefTarget!,
        if (item.keywords != null && item.keywords!.isNotEmpty)
          'data-keywords': item.keywords!.join(','),
        'data-label': item.label,
        'data-group': ?groupName,
        if (item.disabled) 'data-arcane-disabled': 'true',
        if (!item.disabled) 'data-arcane-action': action,
        'tabindex': item.disabled ? '-1' : '0',
      },
      styles: dom.Styles(raw: itemStyles(item)),
      [
        ?item.icon,
        dom.span(
          styles: const dom.Styles(
            raw: <String, String>{
              'flex': '1',
              'font-size': 'var(--font-size-sm)',
              'color': 'var(--foreground)',
            },
          ),
          [Component.text(item.label)],
        ),
        if (item.shortcut != null) buildShortcut(item.shortcut!),
      ],
    );
  }
}
