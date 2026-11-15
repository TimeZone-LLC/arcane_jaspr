import 'package:arcane_jaspr/core/layout_renderers.dart';
import 'package:arcane_jaspr/core/renderers.dart';
import 'package:arcane_jaspr/stylesheets/stylesheet_css.dart';
import 'package:arcane_jaspr/theme/index.dart';

export 'package:arcane_jaspr/core/layout_renderers.dart';
export 'package:arcane_jaspr/core/renderers.dart' hide SheetPosition;

abstract class ArcaneStylesheet {
  const ArcaneStylesheet();

  String get id;

  String get name;

  String get themeClass => 'arcane-theme-$id';

  ComponentRenderers get renderers;

  LayoutRenderers get layouts => const DefaultLayoutRenderers();

  ThemeSeed get lightSeed;

  ThemeSeed get darkSeed => lightSeed.toDark();

  FontConfig get fonts => const FontConfig();

  RadiusConfig get radius => const RadiusConfig();

  ControlConfig get controls => const ControlConfig();

  MotionConfig get motion => const MotionConfig();

  String get fontFaces => '';

  String get componentCss => '';

  String? get bodyClass => null;

  Map<String, String> get rootAttributes => <String, String>{
    'data-arcane-theme': id,
  };

  String get baseCss => ArcaneStylesheetCss.resolve(
    cacheKey: cacheKey,
    fontFaces: fontFaces,
    lightSeed: lightSeed,
    darkSeed: darkSeed,
    fonts: fonts,
    radius: radius,
    controls: controls,
    motion: motion,
    componentCss: () => componentCss,
  );

  Object get cacheKey => this;
}
