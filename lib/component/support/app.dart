import 'package:arcane_jaspr/flutter.dart';
import 'package:jaspr/jaspr.dart' as jaspr;
import 'package:jaspr/dom.dart' as dom;

import '../../core/interaction/runtime/runtime.dart';
import '../../core/theme_provider.dart';
import '../../util/interactivity/arcane_scripts.dart';

// Conditional import for Document handling - server vs client
import 'document_stub.dart'
    if (dart.library.io) 'document_server.dart'
    if (dart.library.js_interop) 'document_web.dart';

export '../../core/theme_provider.dart';
export '../../stylesheets/stylesheet.dart';

/// Root application component for Arcane Jaspr apps.
///
/// The [stylesheet] parameter is required - there is no default stylesheet.
/// Import a concrete renderer package and pass its stylesheet here.
class ArcaneApp extends StatefulWidget {
  final ArcaneStylesheet stylesheet;
  final Brightness brightness;
  final Widget home;
  final String? title;
  final String? description;
  final List<Widget>? head;
  final bool includeFallbackScripts;

  const ArcaneApp({
    required this.stylesheet,
    this.brightness = Brightness.dark,
    required this.home,
    this.title,
    this.description,
    this.head,
    this.includeFallbackScripts = true,
    super.key,
  });

  @override
  State<ArcaneApp> createState() => _ArcaneAppState();
}

class _ArcaneAppState extends State<ArcaneApp> {
  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.brightness == Brightness.dark;
    final ArcaneStylesheet stylesheet = widget.stylesheet;

    // Build head elements data for injection
    final List<HeadElementData> headElements = [];

    if (widget.title != null && widget.title!.isNotEmpty) {
      headElements.add(HeadElementData.title(widget.title!));
    }

    if (widget.description != null && widget.description!.isNotEmpty) {
      headElements.add(
        HeadElementData.meta(name: 'description', content: widget.description!),
      );
    }

    final String baseCss = stylesheet.baseCss;
    if (baseCss.isNotEmpty) {
      headElements.add(HeadElementData.style(baseCss));
    }

    if (widget.includeFallbackScripts) {
      headElements.add(HeadElementData.style(arcaneInteractivityRuntimeCss));
    }

    // Build CSS classes: brightness + any stylesheet-specific classes
    final String brightnessClass = isDark ? 'dark' : 'light';
    final String? stylesheetClass = stylesheet.bodyClass;
    final String rootClasses = [
      brightnessClass,
      stylesheet.themeClass,
      stylesheetClass,
    ].where((String? c) => c != null && c.isNotEmpty).join(' ');

    final Widget rootDiv = dom.div(
      id: 'arcane-root',
      classes: rootClasses,
      attributes: stylesheet.rootAttributes,
      styles: const dom.Styles(
        raw: {
          'min-height': '100vh',
          'background-color': 'var(--arcane-app-background, var(--background))',
          'color': 'var(--arcane-app-foreground, var(--foreground))',
          'font-family': 'var(--font-sans)',
          '-webkit-font-smoothing': 'antialiased',
          '-moz-osx-font-smoothing': 'grayscale',
        },
      ),
      [
        widget.home,
        if (widget.includeFallbackScripts) const ArcaneScriptsComponent(),
      ],
    );

    return ArcaneThemeProvider(
      stylesheet: stylesheet,
      brightness: widget.brightness,
      child: jaspr.Component.fragment([
        // Add brightness class to html element for CSS variable scoping
        DocumentHelper.html(attributes: {'class': brightnessClass}),
        // Inject styles into the actual document <head>
        DocumentHelper.head(elements: headElements),
        if (widget.head != null && widget.head!.isNotEmpty)
          jaspr.Document.head(children: widget.head!),
        rootDiv,
      ]),
    );
  }
}

/// Web wrapper for ArcaneApp with optional background styling.
///
/// The [stylesheet] parameter is required - there is no default stylesheet.
class ArcaneWindow extends StatelessWidget {
  final ArcaneStylesheet stylesheet;
  final Brightness brightness;
  final Widget home;

  const ArcaneWindow({
    required this.stylesheet,
    this.brightness = Brightness.dark,
    required this.home,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ArcaneApp(
      stylesheet: stylesheet,
      brightness: brightness,
      home: home,
    );
  }
}
