import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/decoration/arcane_decoration.dart';
import 'package:arcane_jaspr/core/rendering/base/style_layering.dart';
import 'package:arcane_jaspr/core/props/tabs_props.dart';

/// Shared structural base for the neon/neubrutalism tabs renderers.
///
/// These two themes render an identical tab tree — the column wrapper, the
/// inline-flex tab list, the trigger buttons (with their role/state/disabled
/// attributes) and the content panel all match byte-for-byte. They diverge only
/// in the trigger typography (font weight / letter spacing / text transform),
/// the disabled opacity and the badge styling, which are exposed as abstract
/// members.
///
/// The ShadCN tabs are structurally divergent (a muted-background tab list and
/// a separate `role="tabpanel"` panel) and are left standalone.
///
/// This base lives in core and depends only on core props; it must never depend
/// on a theme package.
abstract class TabsRenderBase extends StatelessComponent {
  const TabsRenderBase(this.props, {super.key});

  final TabsProps props;

  /// Theme class prefix (e.g. `'neon'`, `'neubrutalism'`).
  String get classPrefix;

  /// `font-weight` for the trigger buttons.
  String get tabFontWeight;

  /// `letter-spacing` for the trigger buttons.
  String get tabLetterSpacing;

  /// `text-transform` for the trigger buttons.
  String get tabTextTransform;

  /// `opacity` applied to a disabled trigger.
  String get tabDisabledOpacity;

  /// Inline styles for the trigger badge span.
  Map<String, String> get badgeStyles;

  /// Per-instance decoration overrides. Default: none. A theme overrides this
  /// to translate an [ArcaneDecoration] elevation intent into its own CSS.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: '$classPrefix-tabs',
      styles: const dom.Styles(
        raw: <String, String>{
          'display': 'flex',
          'flex-direction': 'column',
          'gap': '1.25rem',
          'width': '100%',
        },
      ),
      <Component>[
        _buildTabList(),
        if (props.selectedIndex >= 0 && props.selectedIndex < props.tabs.length)
          dom.div(
            classes: '$classPrefix-tabs-content',
            styles: const dom.Styles(raw: <String, String>{'width': '100%'}),
            <Component>[props.tabs[props.selectedIndex].content],
          ),
      ],
    );
  }

  Component _buildTabList() {
    return dom.div(
      classes: '$classPrefix-tabs-list',
      attributes: const <String, String>{'role': 'tablist'},
      styles: dom.Styles(
        raw: <String, String>{
          'display': props.fill ? 'flex' : 'inline-flex',
          'align-items': 'stretch',
          'gap': '0.25rem',
          'padding': '0.25rem',
          if (props.fill) 'width': '100%',
          'align-self': props.fill ? 'stretch' : 'flex-start',
          ...?props.decoration?.universalStyles(),
          ...decorationStyles(props.decoration),
          ...?props.styles?.toMap(),
        },
      ),
      <Component>[
        for (int i = 0; i < props.tabs.length; i++)
          _buildTab(props.tabs[i], i),
      ],
    );
  }

  Component _buildTab(TabItemProps tab, int index) {
    final bool isSelected = index == props.selectedIndex;
    final bool isDisabled = tab.disabled;

    return dom.button(
      classes:
          '$classPrefix-tabs-trigger ${isSelected ? 'active' : ''} ${isDisabled ? 'disabled' : ''}',
      attributes: <String, String>{
        'type': 'button',
        'role': 'tab',
        'aria-selected': isSelected.toString(),
        'data-state': isSelected ? 'active' : 'inactive',
        'data-disabled': '$isDisabled',
        if (isDisabled) 'disabled': 'true',
      },
      styles: dom.Styles(
        raw: <String, String>{
          'position': 'relative',
          'display': 'inline-flex',
          'align-items': 'center',
          'justify-content': 'center',
          'gap': '0.5rem',
          'padding': '0.625rem 1.125rem',
          'font-size': 'var(--font-size-sm)',
          'font-weight': tabFontWeight,
          'letter-spacing': tabLetterSpacing,
          'text-transform': tabTextTransform,
          'cursor': isDisabled ? 'not-allowed' : 'pointer',
          'opacity': isDisabled ? tabDisabledOpacity : '1',
          'white-space': 'nowrap',
          'outline': 'none',
          if (props.fill) 'flex': '1',
        },
      ),
      events: isDisabled || props.onChanged == null
          ? null
          : <String, EventCallback>{
              'click': (dynamic _) => props.onChanged!(index),
            },
      <Component>[
        if (tab.icon != null) tab.icon!,
        Component.text(tab.label),
        if (tab.badge != null)
          dom.span(
            classes: '$classPrefix-tabs-badge',
            styles: dom.Styles(raw: badgeStyles),
            <Component>[Component.text(tab.badge!)],
          ),
      ],
    );
  }
}

/// Shared structural base for the neon/neubrutalism/win95 tab-bar renderers.
///
/// Same alignment as [TabsRenderBase] for the content-less tab bar: the list
/// wrapper and item buttons are identical; only the item typography differs.
/// The bar and items carry the shared `arcane-tab-bar` and
/// `arcane-tab-bar-item` classes beside the theme prefix, and the current item
/// takes `selected`, matching the ShadCN tab bar.
abstract class TabBarRenderBase extends StatelessComponent {
  const TabBarRenderBase(this.props, {super.key});

  final TabBarProps props;

  /// Theme class prefix (e.g. `'neon'`, `'neubrutalism'`).
  String get classPrefix;

  /// `font-weight` for the item buttons.
  String get tabFontWeight;

  /// `letter-spacing` for the item buttons.
  String get tabLetterSpacing;

  /// `text-transform` for the item buttons.
  String get tabTextTransform;

  /// Per-instance decoration overrides. Default: none. A theme overrides this
  /// to translate an [ArcaneDecoration] elevation intent into its own CSS.
  Map<String, String> decorationStyles(ArcaneDecoration? decoration) =>
      const <String, String>{};

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'arcane-tab-bar $classPrefix-tab-bar',
      attributes: const <String, String>{'role': 'tablist'},
      styles: dom.Styles(
        raw: layerStyles(
          <String, String>{
            'display': props.fill ? 'flex' : 'inline-flex',
            'align-items': 'stretch',
            'gap': '0.25rem',
            'padding': '0.25rem',
            if (props.fill) 'width': '100%',
          },
          <Map<String, String>?>[
            props.decoration?.universalStyles(),
            decorationStyles(props.decoration),
            props.styles?.toMap(),
          ],
        ),
      ),
      <Component>[
        for (int i = 0; i < props.tabs.length; i++)
          _buildTab(props.tabs[i], i),
      ],
    );
  }

  Component _buildTab(TabBarItemProps tab, int index) {
    final bool isSelected = index == props.selectedIndex;

    return dom.button(
      classes:
          'arcane-tab-bar-item $classPrefix-tab-bar-item${isSelected ? ' selected' : ''}',
      attributes: <String, String>{
        'type': 'button',
        'role': 'tab',
        'aria-selected': isSelected.toString(),
        'data-state': isSelected ? 'active' : 'inactive',
      },
      styles: dom.Styles(
        raw: <String, String>{
          'position': 'relative',
          'display': 'inline-flex',
          'align-items': 'center',
          'justify-content': 'center',
          'gap': '0.5rem',
          'padding': '0.625rem 1.125rem',
          'font-size': 'var(--font-size-sm)',
          'font-weight': tabFontWeight,
          'letter-spacing': tabLetterSpacing,
          'text-transform': tabTextTransform,
          'cursor': 'pointer',
          'white-space': 'nowrap',
          'outline': 'none',
          if (props.fill) 'flex': '1',
        },
      ),
      events: <String, EventCallback>{
        'click': (dynamic _) => props.onChanged(index),
      },
      <Component>[
        if (tab.icon != null) tab.icon!,
        Component.text(tab.label),
      ],
    );
  }
}
