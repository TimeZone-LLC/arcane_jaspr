import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/props/tabs_props.dart';

/// v4 TabsList: `bg-muted text-muted-foreground inline-flex h-9 w-fit
/// items-center justify-center rounded-lg p-[3px]`.
Map<String, String> _listStyles({required bool fill}) => <String, String>{
  'display': 'inline-flex',
  'height': '2.25rem',
  'width': fill ? '100%' : 'fit-content',
  'align-items': 'center',
  'justify-content': 'center',
  'gap': '0.25rem',
  'padding': '3px',
  'border-radius': 'var(--radius-md)',
  'background-color': 'var(--muted)',
  'color': 'var(--muted-foreground)',
};

/// v4 TabsTrigger: `inline-flex h-[calc(100%-1px)] items-center
/// justify-center gap-1.5 rounded-md border border-transparent px-2 py-1
/// text-sm font-medium`. Background, foreground, border colour and shadow
/// route through variables so the surfaces stylesheet can paint the active,
/// hover and `:focus-visible` states.
Map<String, String> _triggerStyles({
  required bool fill,
  required bool disabled,
}) => <String, String>{
  'display': 'inline-flex',
  'align-items': 'center',
  'justify-content': 'center',
  'gap': '0.375rem',
  'height': 'calc(100% - 1px)',
  'white-space': 'nowrap',
  'padding': '0.25rem 0.5rem',
  'border': '1px solid var(--shadcn-control-border-color, transparent)',
  'border-radius': 'var(--radius-sm)',
  'font-size': '0.875rem',
  'line-height': '1.25rem',
  'font-weight': '500',
  'background-color': 'var(--shadcn-item-background, transparent)',
  'color': 'var(--shadcn-item-foreground, var(--foreground))',
  'box-shadow': 'var(--shadcn-control-shadow, none)',
  'outline': 'none',
  'cursor': 'pointer',
  'transition':
      'color var(--transition), background-color var(--transition), box-shadow var(--transition), border-color var(--transition)',
  if (disabled) 'pointer-events': 'none',
  if (disabled) 'opacity': '0.5',
  if (fill) 'flex': '1',
};

/// ShadCN Tabs renderer.
///
/// Reference: https://ui.shadcn.com/docs/components/tabs
class ShadcnTabs extends StatelessComponent {
  final TabsProps props;

  const ShadcnTabs(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'arcane-tabs',
      styles: const dom.Styles(
        raw: <String, String>{
          'display': 'flex',
          'flex-direction': 'column',
          'width': '100%',
        },
      ),
      <Component>[
        dom.div(
          classes: 'arcane-tabs-list',
          attributes: const <String, String>{'role': 'tablist'},
          styles: dom.Styles(
            raw: <String, String>{
              ..._listStyles(fill: props.fill),
              ...?props.decoration?.universalStyles(),
              ...?props.styles?.toMap(),
            },
          ),
          <Component>[
            for (int i = 0; i < props.tabs.length; i++)
              _buildTab(i, props.tabs[i]),
          ],
        ),
        // v4 Tabs: flex flex-col gap-2
        dom.div(
          classes: 'arcane-tabs-panel',
          attributes: const <String, String>{'role': 'tabpanel'},
          styles: const dom.Styles(
            raw: <String, String>{'margin-top': '0.5rem'},
          ),
          <Component>[
            if (props.selectedIndex < props.tabs.length)
              props.tabs[props.selectedIndex].content,
          ],
        ),
      ],
    );
  }

  Component _buildTab(int index, TabItemProps tab) {
    final bool isSelected = index == props.selectedIndex;
    final bool isDisabled = tab.disabled;

    return dom.button(
      classes:
          'arcane-tab${isSelected ? ' selected' : ''}${isDisabled ? ' disabled' : ''}',
      attributes: <String, String>{
        'type': 'button',
        'role': 'tab',
        'aria-selected': '$isSelected',
        if (isDisabled) 'aria-disabled': 'true',
        'data-state': isSelected ? 'active' : 'inactive',
        'data-disabled': '$isDisabled',
      },
      styles: dom.Styles(
        raw: _triggerStyles(fill: props.fill, disabled: isDisabled),
      ),
      events: <String, EventCallback>{
        'click': (event) {
          if (!isDisabled && props.onChanged != null) {
            props.onChanged!(index);
          }
        },
      },
      <Component>[
        if (tab.icon != null) tab.icon!,
        Component.text(tab.label),
        if (tab.badge != null)
          dom.span(
            classes: 'arcane-tab-badge',
            styles: const dom.Styles(
              raw: <String, String>{
                'background-color': 'var(--primary)',
                'color': 'var(--primary-foreground)',
                'font-size': '0.6875rem',
                'padding': '0 0.375rem',
                'border-radius': 'var(--radius-xs)',
                'font-weight': '500',
                'line-height': '1rem',
              },
            ),
            <Component>[Component.text(tab.badge!)],
          ),
      ],
    );
  }
}

/// ShadCN TabBar renderer (tabs only, no content panel).
class ShadcnTabBar extends StatelessComponent {
  final TabBarProps props;

  const ShadcnTabBar(this.props, {super.key});

  @override
  Component build(BuildContext context) {
    return dom.div(
      classes: 'arcane-tab-bar',
      attributes: const <String, String>{'role': 'tablist'},
      styles: dom.Styles(
        raw: <String, String>{
          ..._listStyles(fill: props.fill),
          ...?props.decoration?.universalStyles(),
          ...?props.styles?.toMap(),
        },
      ),
      <Component>[
        for (int i = 0; i < props.tabs.length; i++) _buildTab(i, props.tabs[i]),
      ],
    );
  }

  Component _buildTab(int index, TabBarItemProps tab) {
    final bool isSelected = index == props.selectedIndex;

    return dom.button(
      classes: 'arcane-tab-bar-item${isSelected ? ' selected' : ''}',
      attributes: <String, String>{
        'type': 'button',
        'role': 'tab',
        'aria-selected': '$isSelected',
        'data-state': isSelected ? 'active' : 'inactive',
      },
      styles: dom.Styles(
        raw: _triggerStyles(fill: props.fill, disabled: false),
      ),
      events: <String, EventCallback>{
        'click': (event) => props.onChanged(index),
      },
      <Component>[if (tab.icon != null) tab.icon!, Component.text(tab.label)],
    );
  }
}
