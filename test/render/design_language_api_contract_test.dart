import 'dart:io';

import 'package:jaspr_test/jaspr_test.dart';

String _source(String path) => File(path).readAsStringSync();

void main() {
  test('semantic icon slots are structurally limited to one glyph', () {
    final List<File> files = <File>[
      ...Directory('lib/component').listSync(recursive: true).whereType<File>(),
      ...Directory(
        'lib/core/props',
      ).listSync(recursive: true).whereType<File>(),
    ]..removeWhere((File file) => !file.path.endsWith('.dart'));
    final RegExp arbitraryIconSlot = RegExp(
      r'Widget\??\s+(?:this\.)?icon\b|Widget\s+Function\([^)]*\)\s+(?:this\.)?\w*[Ii]con\b',
    );
    final List<String> escapes = <String>[];

    for (final File file in files) {
      if (file.path.endsWith('/component/view/logo.dart')) continue;
      if (arbitraryIconSlot.hasMatch(file.readAsStringSync())) {
        escapes.add(file.path);
      }
    }

    expect(escapes, isEmpty);
    expect(
      _source('lib/component/view/logo.dart'),
      contains('Brand artwork may be a composed logo'),
    );
  });

  test('curated APIs do not expose rejected visual-language shortcuts', () {
    final String exports = _source('lib/arcane_jaspr.dart');
    final String cards = _source('lib/core/props/card_props.dart');
    final String boxes = _source('lib/component/layout/gutter.dart');
    final String radios = _source('lib/core/props/radio_group_props.dart');
    final String promos = _source('lib/core/props/promo_props.dart');
    final String badges = _source('lib/core/props/status_badge_props.dart');
    final String badgeWidget = _source(
      'lib/component/feedback/status_badge.dart',
    );
    final String buttons = _source('lib/component/input/button.dart');
    final String buttonProps = _source('lib/core/props/button_props.dart');
    final String buttonRenderer = _source(
      'lib/core/rendering/base/button_render_base.dart',
    );
    final String featureCards = _source('lib/component/card/feature_card.dart');
    final String featureCardProps = _source(
      'lib/core/props/feature_card_props.dart',
    );
    final String featureCardRenderer = _source(
      'lib/core/rendering/base/feature_card_render_base.dart',
    );
    final String pricing = _source('lib/core/props/pricing_card_props.dart');
    final String pricingWidget = _source(
      'lib/component/card/pricing_card.dart',
    );
    final String pricingRenderer = _source(
      'lib/core/rendering/base/pricing_card_render_base.dart',
    );
    final String ctaCards = _source('lib/component/card/cta_card.dart');
    final String ctaCardProps = _source('lib/core/props/cta_card_props.dart');
    final String ctaCardRenderer = _source(
      'lib/core/rendering/base/cta_card_render_base.dart',
    );
    final String flexiCards = _source('lib/component/card/flexi_cards.dart');
    final String flexiCardProps = _source(
      'lib/core/props/flexi_cards_props.dart',
    );
    final String carousel = _source(
      'lib/component/collection/infinite_carousel.dart',
    );
    final String cardCarousel = _source(
      'lib/component/collection/card_carousel.dart',
    );
    final String scrollArea = _source('lib/core/props/scroll_area_props.dart');
    final String navDropdown = _source(
      'lib/component/navigation/nav_dropdown.dart',
    );
    final String cardWidgets = _source('lib/component/card/card.dart');
    final String baseCss = _source('lib/stylesheets/base_css.dart');
    final String colors = _source('lib/util/style_types/arcane_color.dart');
    final String spacing = _source('lib/util/style_types/spacing.dart');
    final String themeSeed = _source('lib/theme/color_seed.dart');
    final String decoration = _source(
      'lib/core/decoration/arcane_decoration.dart',
    );
    final String effects = _source('lib/util/style_types/effects.dart');
    final String designTokens = _source('lib/util/design_tokens.dart');
    final String mapStyle = _source('lib/component/view/map/map_style.dart');
    final String map = _source('lib/component/view/map/arcane_map.dart');
    final String icons = _source('lib/component/view/icon.dart');
    final String iconButton = _source('lib/component/input/icon_button.dart');
    final String fab = _source('lib/component/input/fab.dart');
    final String tile = _source('lib/component/view/tile.dart');
    final String socialProvider = _source(
      'lib/component/button/social_provider.dart',
    );
    final String socialIcons = _source(
      'lib/component/button/social_icons.dart',
    );
    final String statCard = _source('lib/component/card/stat_card.dart');
    final String statCardProps = _source('lib/core/props/stat_card_props.dart');
    final String iconGenerator = _source('tool/generate_icons.dart');
    final String styleData = _source(
      'lib/util/style_types/arcane_style_data.dart',
    );
    final String radii = _source('lib/util/style_types/borders.dart');
    final String radiusConfig = _source('lib/theme/radius_config.dart');
    final String cssGenerator = _source('lib/theme/css_generator.dart');
    final String palette = _source('lib/theme/palette.dart');
    final String neonCss = _source(
      'packages/arcane_jaspr_neon/lib/src/neon_css.dart',
    );

    expect(exports, isNot(contains("component/view/glass.dart")));
    expect(exports, isNot(contains("component/view/icon_badge.dart")));
    expect(cards, isNot(contains('glass')));
    expect(boxes, isNot(contains('ArcaneBox.glass')));
    expect(radios, isNot(contains('chips')));
    expect(promos, isNot(contains('pill')));
    expect(promos, isNot(contains('badge')));
    expect(badges, isNot(contains('showGlow')));
    expect(badges, isNot(contains('showPulse')));
    expect(badges, isNot(contains('showDefaultIcon')));
    expect(badges, isNot(contains('gradient')));
    expect(badges, isNot(contains('BadgePosition')));
    expect(badges, isNot(contains('popular')));
    expect(badges, isNot(contains('recommended')));
    expect(badgeWidget, isNot(contains('ArcaneStatusBadge.popular')));
    expect(badgeWidget, isNot(contains('ArcaneStatusBadge.recommended')));
    expect(badgeWidget, isNot(contains('ArcaneStatusBadge.isNew')));
    expect(buttons, isNot(contains('Button.accent')));
    expect(buttons, isNot(contains('final Widget? child')));
    expect(buttons, isNot(contains('Widget? trailing')));
    expect(buttons, isNot(contains('showArrow')));
    expect(buttons, contains('final ArcaneGlyph? icon'));
    expect(buttons, isNot(contains('final Widget? icon')));
    expect(buttonProps, isNot(contains('accent')));
    expect(buttonProps, isNot(contains('final Widget? child')));
    expect(buttonProps, contains('enum ButtonIconPosition'));
    expect(buttonProps, isNot(contains('Widget? trailing')));
    expect(buttonProps, isNot(contains('showArrow')));
    expect(buttonProps, contains('final ArcaneGlyph? icon'));
    expect(buttonProps, isNot(contains('final Widget? icon')));
    expect(iconButton, contains('final ArcaneGlyph icon'));
    expect(fab, contains('final ArcaneGlyph icon'));
    expect(tile, contains('final ArcaneGlyph? leading'));
    expect(socialProvider, contains('final ArcaneGlyph Function() buildIcon'));
    expect(socialProvider, isNot(contains('Widget Function() buildIcon')));
    expect(socialIcons, isNot(contains('static Component ')));
    expect(socialIcons, isNot(contains('static Widget ')));
    expect(buttonRenderer, isNot(contains('arrowTransition')));
    expect(buttonRenderer, isNot(contains('props.child')));
    expect(buttonRenderer, isNot(contains('ArcaneIcon.arrowRight')));
    expect(featureCards, isNot(contains('showArrow')));
    expect(featureCardProps, isNot(contains('showArrow')));
    expect(featureCardRenderer, isNot(contains("Component.text('→')")));
    expect(featureCards, isNot(contains('final Widget? icon')));
    expect(featureCards, isNot(contains('final Widget icon')));
    expect(featureCardProps, isNot(contains('final Widget? icon')));
    expect(featureCardProps, isNot(contains('final Widget icon')));
    expect(statCard, contains('final ArcaneGlyph? icon'));
    expect(statCardProps, contains('final ArcaneGlyph? icon'));
    expect(pricing, contains('final ArcaneGlyph? icon'));
    expect(pricingWidget, contains('final ArcaneGlyph? icon'));
    expect(ctaCards, contains('final ArcaneGlyph? icon'));
    expect(ctaCardProps, contains('final ArcaneGlyph? icon'));
    expect(flexiCardProps, contains('final ArcaneGlyph icon'));
    expect(badges, contains('final ArcaneGlyph? icon'));
    expect(badgeWidget, contains('final ArcaneGlyph? icon'));
    expect(pricing, isNot(contains('PricingBadgeVariant')));
    expect(pricing, isNot(contains('isPopular')));
    expect(pricing, isNot(contains('isHighlighted')));
    expect(pricing, isNot(contains('highlighted')));
    expect(pricing, isNot(contains('accentColor')));
    expect(pricing, isNot(contains('PricingCardVariant.hero')));
    expect(pricing, isNot(contains('originalPrice')));
    expect(pricingWidget, isNot(contains('PricingCard.hero')));
    expect(pricingWidget, isNot(contains('highlighted')));
    expect(pricingWidget, isNot(contains('originalPrice')));
    expect(pricingRenderer, isNot(contains('highlighted')));
    expect(pricingRenderer, isNot(contains('accentColor')));
    expect(pricingRenderer, isNot(contains('originalPrice')));
    expect(ctaCards, isNot(contains('animationDelayMs')));
    expect(ctaCardProps, isNot(contains('animationDelayMs')));
    expect(ctaCardRenderer, isNot(contains("'opacity': '0'")));
    expect(flexiCards, isNot(contains('expandLongTextOnHover')));
    expect(flexiCardProps, isNot(contains('expandLongTextOnHover')));
    expect(carousel, isNot(contains('showFadeEdges')));
    expect(carousel, isNot(contains('fadeWidth')));
    expect(carousel, isNot(contains('linear-gradient')));
    expect(cardCarousel, isNot(contains('linear-gradient')));
    expect(cardCarousel, isNot(contains('feather')));
    expect(cardCarousel, isNot(contains('sharpness')));
    expect(scrollArea, isNot(contains('showScrollShadows')));
    expect(File('lib/component/view/fade_edge.dart').existsSync(), isFalse);
    expect(File('lib/core/props/fade_edge_props.dart').existsSync(), isFalse);
    expect(navDropdown, isNot(contains('shadowCustom')));
    expect(navDropdown, isNot(contains('ArcaneIcon.externalLink')));
    expect(navDropdown, contains("target: widget.isExternal ? '_blank'"));
    expect(
      navDropdown,
      contains("rel: widget.isExternal ? 'noopener noreferrer'"),
    );
    expect(cardWidgets, isNot(contains('linear-gradient')));
    expect(cardWidgets, isNot(contains('final int elevation')));
    expect(baseCss, isNot(contains('cdn.jsdelivr.net')));
    expect(baseCss, isNot(contains('fonts.googleapis.com')));
    expect(colors, isNot(contains('GradientBuilder')));
    expect(colors, isNot(contains('toGradient')));
    expect(spacing, isNot(contains('PaddingPreset.chip')));
    expect(themeSeed, isNot(contains('accentGlow')));
    expect(themeSeed, isNot(contains('glowColor')));
    expect(decoration, isNot(contains('BackdropFilter')));
    expect(decoration, isNot(contains('gradient')));
    expect(decoration, isNot(contains('shadowColor')));
    expect(effects, isNot(contains('glow')));
    expect(effects, isNot(contains('hoverLift')));
    expect(effects, isNot(contains('hoverScale')));
    expect(effects, isNot(contains('BackdropFilter')));
    expect(styleData, isNot(contains('backdropFilter')));
    expect(styleData, isNot(contains('borderRadiusCustom')));
    expect(styleData, isNot(contains('borderRadiusClass')));
    expect(styleData, isNot(contains('borderTop')));
    expect(styleData, isNot(contains('borderRight')));
    expect(styleData, isNot(contains('borderBottom')));
    expect(styleData, isNot(contains('borderLeft')));
    expect(styleData, isNot(contains('shadowCustom')));
    expect(styleData, isNot(contains('filterCustom')));
    expect(styleData, isNot(contains('animationCustom')));
    expect(styleData, isNot(contains('Map<String, String>? raw')));
    expect(styleData, contains("contains('gradient(')"));
    expect(radii, isNot(contains('full')));
    expect(radii, isNot(contains('circle')));
    expect(radiusConfig, isNot(contains('full')));
    expect(radiusConfig, isNot(contains('final String lg')));
    expect(radiusConfig, isNot(contains('final String xl')));
    expect(radiusConfig, isNot(contains('final String xxl')));
    expect(radiusConfig, isNot(contains('copyWith')));
    expect(radiusConfig, isNot(contains('this.md')));
    expect(cssGenerator, isNot(contains('radius-full')));
    expect(cssGenerator, isNot(contains('radius-lg')));
    expect(cssGenerator, isNot(contains('radius-xl')));
    expect(cssGenerator, isNot(contains('radius-2xl')));
    expect(palette, isNot(contains('required this.shadow')));
    expect(palette, isNot(contains('final String shadow')));
    expect(palette, contains('String get shadowXs'));
    expect(palette, contains('rgba(0, 0, 0'));
    expect(neonCss, isNot(contains('border-bottom-width')));
    expect(designTokens, isNot(contains('fullStatic')));
    expect(designTokens, isNot(contains('ArcaneRadius.circle')));
    expect(designTokens, isNot(contains('glow')));
    expect(designTokens, isNot(contains('backdropBlur')));
    expect(designTokens, isNot(contains('hoverLift')));
    expect(designTokens, isNot(contains('hoverScale')));
    expect(mapStyle, isNot(contains('pinGlow')));
    expect(map, isNot(contains('box-shadow')));
    expect(icons, isNot(contains(' Widget sparkle(')));
    expect(icons, isNot(contains(' Widget sparkles(')));
    expect(icons, isNot(contains(' Widget wandSparkles(')));
    expect(icons, contains('sealed class ArcaneGlyph'));
    expect(icons, contains('static ArcaneGlyph customSvg'));
    expect(icons, isNot(contains('static Widget ')));
    expect(iconGenerator, contains("'sparkle'"));
    expect(iconGenerator, contains("'sparkles'"));
    expect(iconGenerator, contains("'wand-sparkles'"));
  });

  test('intrusive promo families and their hidden render paths are absent', () {
    const List<String> removed = <String>[
      'BottomFloatingBanner',
      'CornerPromoToast',
      'ExpandingFabPromo',
      'FullscreenTakeover',
      'MarqueeTickerBar',
      'MinimizablePromo',
      'ProgressClaimBanner',
      'PromoModal',
      'SlidingSidebarBanner',
    ];

    final StringBuffer publicSource = StringBuffer()
      ..writeln(_source('lib/component/promo/promo.dart'))
      ..writeln(_source('lib/core/props/promo_props.dart'));
    for (final Directory directory in <Directory>[
      Directory('lib/component/promo'),
      Directory('packages/arcane_jaspr_neon/lib/src/renderers/promo'),
      Directory('packages/arcane_jaspr_shadcn/lib/src/renderers/promo'),
      Directory('packages/arcane_jaspr_neubrutalism/lib/src/renderers/promo'),
      Directory('packages/arcane_jaspr_win95/lib/src/renderers/promo'),
    ]) {
      for (final FileSystemEntity entity in directory.listSync()) {
        if (entity is File && entity.path.endsWith('.dart')) {
          publicSource.writeln(entity.readAsStringSync());
        }
      }
    }

    for (final String name in removed) {
      expect(publicSource.toString(), isNot(contains(name)), reason: name);
    }

    final String neubrutalismCss = _source(
      'packages/arcane_jaspr_neubrutalism/lib/src/neubrutalism_css.dart',
    );
    for (final String selector in <String>[
      'neubrutalism-promo-badge',
      'neubrutalism-badge-popular',
      'neubrutalism-badge-recommended',
      'neubrutalism-badge-isNew',
      'neubrutalism-promo-bar',
      'neubrutalism-bottom-floating-banner',
      'neubrutalism-corner-promo-toast',
      'neubrutalism-promo-modal',
      'neubrutalism-sliding-sidebar-banner',
      'neubrutalism-marquee-ticker-bar',
      'neubrutalism-progress-claim-banner',
      'neubrutalism-minimizable-promo',
      'neubrutalism-fullscreen-takeover',
      'neubrutalism-expanding-fab-promo',
    ]) {
      expect(neubrutalismCss, isNot(contains(selector)), reason: selector);
    }

    for (final String forbidden in <String>[
      'linear-gradient',
      'radial-gradient',
      'backdrop-filter',
      'box-shadow',
      'promoCode',
      'showCopyButton',
      "'border-radius': 'var(--radius",
    ]) {
      expect(
        publicSource.toString(),
        isNot(contains(forbidden)),
        reason: forbidden,
      );
    }
  });

  test('shared marketing surfaces have no glass, glow, or gradient chrome', () {
    const List<String> surfaceFiles = <String>[
      'lib/core/rendering/base/feature_card_render_base.dart',
      'lib/core/rendering/base/cta_card_render_base.dart',
      'lib/core/rendering/base/pricing_card_render_base.dart',
      'lib/core/rendering/base/stat_card_render_base.dart',
    ];

    for (final String path in surfaceFiles) {
      final String source = _source(path);
      expect(source, isNot(contains('linear-gradient')), reason: path);
      expect(source, isNot(contains('backdrop-filter')), reason: path);
      expect(source, isNot(contains('box-shadow')), reason: path);
      expect(source, isNot(contains('9999px')), reason: path);
      expect(source, isNot(contains('999px')), reason: path);
    }
  });

  test('every theme package rejects decorative surface effects', () {
    final String shadcn = _source(
      'packages/arcane_jaspr_shadcn/lib/src/shadcn_css.dart',
    );
    final String neubrutalism = _source(
      'packages/arcane_jaspr_neubrutalism/lib/src/neubrutalism_css.dart',
    );
    final String win95 = _source(
      'packages/arcane_jaspr_win95/lib/src/win95_css.dart',
    );
    final String win95Stylesheet = _source(
      'packages/arcane_jaspr_win95/lib/src/win95_stylesheet.dart',
    );

    for (final String theme in <String>[
      'neon',
      'neubrutalism',
      'shadcn',
      'win95',
    ]) {
      final String flexiCards = _source(
        'packages/arcane_jaspr_$theme/lib/src/renderers/flexi_cards.dart',
      );
      expect(flexiCards, isNot(contains("'0fr'")), reason: theme);
      expect(flexiCards, isNot(contains('showLongText')), reason: theme);
    }

    expect(shadcn, isNot(contains('linear-gradient')));
    expect(shadcn, isNot(contains('backdrop-filter: blur')));
    expect(neubrutalism, isNot(contains('linear-gradient')));
    expect(neubrutalism, isNot(contains('radial-gradient')));
    expect(neubrutalism, isNot(contains('--nb-stripe-bg')));
    expect(neubrutalism, isNot(contains('arcane-chip')));
    expect(neubrutalism, isNot(contains('component-chip')));
    expect(neubrutalism, isNot(contains('--nb-shadow-in')));
    expect(shadcn, isNot(contains('component-chip')));
    expect(win95, isNot(contains('component-chip')));
    expect(win95Stylesheet, isNot(contains('everything')));
    expect(win95, isNot(contains('win95-chrome-everything')));
    expect(win95, isNot(contains('.win95-card::before')));
    expect(win95, isNot(contains('.win95-card::after')));
    expect(win95, isNot(contains('--w95-ctl-row')));
  });
}
