import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/component/view/icon.dart';
import 'package:arcane_jaspr/core/props/check_list_props.dart';

/// Shared structural bases for the Neon-family check-list renderers.
///
/// The Neon and Neubrutalism check item / check list / feature row renderers
/// share identical structure and differ only in the CSS class prefix, a couple
/// of default colors and the feature row's circular-icon container. These bases
/// factor the shared markup, leaving those values to the concrete renderers.
///
/// The ShadCN equivalents use a different structure (unicode glyph icons,
/// class-less spans, a `div`-based list) and therefore do not extend these
/// bases.
///
/// These bases live in core and depend only on core props; they must never
/// depend on a theme package.

/// Shared base for themed check-item renderers.
abstract class CheckItemRenderBase extends StatelessComponent {
  const CheckItemRenderBase(this.props, {super.key});

  final CheckItemProps props;

  /// CSS class prefix (e.g. `'neon'`, `'neubrutalism'`).
  String get themePrefix;

  /// Icon color used when no explicit icon color is provided.
  String get defaultIconColor;

  @override
  Component build(BuildContext context) {
    final Component icon = switch (props.icon) {
      CheckStyle.check => ArcaneIcon.check(size: IconSize.sm),
      CheckStyle.bullet => const Component.text('-'),
      CheckStyle.arrow => const Component.text('->'),
      CheckStyle.plus => const Component.text('+'),
      CheckStyle.star => const Component.text('*'),
    };

    return dom.div(
      classes: '$themePrefix-check-item',
      styles: dom.Styles(
        raw: <String, String>{
          'display': 'flex',
          'align-items': 'flex-start',
          'gap': props.gap ?? '0.75rem',
        },
      ),
      <Component>[
        dom.span(
          classes: '$themePrefix-check-item-icon',
          attributes: const <String, String>{'aria-hidden': 'true'},
          styles: dom.Styles(
            raw: <String, String>{
              'color': props.iconColor ?? defaultIconColor,
              'font-size': props.fontSize ?? '0.9375rem',
              'flex-shrink': '0',
            },
          ),
          <Component>[icon],
        ),
        dom.span(
          classes: '$themePrefix-check-item-text',
          styles: dom.Styles(
            raw: <String, String>{
              'color': props.textColor ?? 'var(--foreground)',
              'font-size': props.fontSize ?? '0.9375rem',
              'line-height': '1.5',
            },
          ),
          <Component>[Component.text(props.text)],
        ),
      ],
    );
  }
}

/// Shared base for themed check-list renderers.
abstract class CheckListRenderBase extends StatelessComponent {
  const CheckListRenderBase(this.props, {super.key});

  final CheckListProps props;

  /// CSS class prefix (e.g. `'neon'`, `'neubrutalism'`).
  String get themePrefix;

  /// Builds the theme's check item for [itemProps].
  Component buildCheckItem(CheckItemProps itemProps);

  @override
  Component build(BuildContext context) {
    return dom.ul(
      classes: '$themePrefix-check-list',
      styles: dom.Styles(
        raw: <String, String>{
          'list-style': 'none',
          'padding': '0',
          'margin': '0',
          'display': 'flex',
          'flex-direction': 'column',
          'gap': props.listGap ?? '0.75rem',
          if (props.alignItems != null) 'align-items': props.alignItems!,
        },
      ),
      <Component>[
        for (final String item in props.items)
          dom.li(<Component>[
            buildCheckItem(
              CheckItemProps(
                text: item,
                icon: props.icon,
                iconColor: props.iconColor,
                textColor: props.textColor,
                fontSize: props.fontSize,
                gap: props.itemGap,
              ),
            ),
          ]),
      ],
    );
  }
}

/// Shared base for themed feature-row renderers.
abstract class FeatureRowRenderBase extends StatelessComponent {
  const FeatureRowRenderBase(this.props, {super.key});

  final FeatureRowProps props;

  /// CSS class prefix (e.g. `'neon'`, `'neubrutalism'`).
  String get themePrefix;

  /// Icon color used for an included feature when no explicit color is given.
  String get defaultIncludedColor;

  /// Builds the circular icon container variant. [iconWidget] is the resolved
  /// check/x glyph; [iconColor] and [iconSize] are the resolved values.
  Component buildCircularIcon(
    Component iconWidget,
    String iconColor,
    String iconSize,
  );

  @override
  Component build(BuildContext context) {
    final String iconColor = props.included
        ? (props.includedColor ?? defaultIncludedColor)
        : (props.excludedColor ?? 'var(--muted-foreground)');

    final String iconSize = props.iconSize ?? '18px';
    final bool showCircular = props.circularIcon;
    final bool showStrikethrough = props.strikethrough && !props.included;

    final Component iconWidget = props.included
        ? const dom.span(
            styles: dom.Styles(
              raw: <String, String>{
                'font-size': '0.625rem',
                'font-weight': '600',
              },
            ),
            <Component>[Component.text('✓')],
          )
        : const dom.span(
            styles: dom.Styles(
              raw: <String, String>{
                'font-size': '0.625rem',
                'font-weight': '600',
              },
            ),
            <Component>[Component.text('✕')],
          );

    final Component iconContainer = showCircular
        ? buildCircularIcon(iconWidget, iconColor, iconSize)
        : dom.span(
            classes: '$themePrefix-feature-row-icon',
            styles: dom.Styles(
              raw: <String, String>{
                'color': iconColor,
                'font-size': 'var(--font-size-sm)',
                'flex-shrink': '0',
              },
            ),
            <Component>[iconWidget],
          );

    final Map<String, String> textStyles = <String, String>{
      'color': props.included ? 'var(--foreground)' : 'var(--muted-foreground)',
      'font-size': 'var(--font-size-sm)',
      if (showStrikethrough) 'text-decoration': 'line-through',
    };

    return dom.div(
      classes:
          '$themePrefix-feature-row ${props.included ? 'included' : 'excluded'}',
      styles: const dom.Styles(
        raw: <String, String>{
          'display': 'flex',
          'align-items': 'center',
          'gap': '0.5rem',
        },
      ),
      attributes: props.tooltip != null
          ? <String, String>{'title': props.tooltip!}
          : null,
      <Component>[
        iconContainer,
        dom.span(
          classes: '$themePrefix-feature-row-text',
          styles: dom.Styles(raw: textStyles),
          <Component>[Component.text(props.feature)],
        ),
      ],
    );
  }
}
