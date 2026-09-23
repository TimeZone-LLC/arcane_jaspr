import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neon/arcane_jaspr_neon.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:arcane_jaspr_shadcn/arcane_jaspr_shadcn.dart';
import 'package:arcane_jaspr_win95/arcane_jaspr_win95.dart';
import 'package:arcane_neon_web/components/demo_registry.dart';
import 'package:arcane_neon_web/components/interactive_demo_events_stub.dart'
    if (dart.library.js_interop) 'package:arcane_neon_web/components/interactive_demo_events_web.dart';
import 'package:arcane_neon_web/components/interactive_demo_stylesheet_stub.dart'
    if (dart.library.js_interop) 'package:arcane_neon_web/components/interactive_demo_stylesheet_web.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart' as jaspr;
import 'package:jaspr/jaspr.dart' show client;

const Map<String, ArcaneStylesheet> clientShadcnStylesheets =
    <String, ArcaneStylesheet>{
      'midnight': ShadcnStylesheet(theme: ShadcnTheme.midnight),
      'charcoal': ShadcnStylesheet(theme: ShadcnTheme.charcoal),
      'cream': ShadcnStylesheet(theme: ShadcnTheme.cream),
      'slate': ShadcnStylesheet(theme: ShadcnTheme.slate),
      'rose': ShadcnStylesheet(theme: ShadcnTheme.rose),
      'lavender': ShadcnStylesheet(theme: ShadcnTheme.lavender),
      'mint': ShadcnStylesheet(theme: ShadcnTheme.mint),
      'sky': ShadcnStylesheet(theme: ShadcnTheme.sky),
      'peach': ShadcnStylesheet(theme: ShadcnTheme.peach),
      'teal': ShadcnStylesheet(theme: ShadcnTheme.teal),
    };
const Map<String, ArcaneStylesheet> clientNeonStylesheets =
    <String, ArcaneStylesheet>{'green': NeonStylesheet(theme: NeonTheme.green)};
const Map<String, ArcaneStylesheet> clientNeubrutalismStylesheets =
    <String, ArcaneStylesheet>{
      'yellow': NeubrutalismStylesheet(theme: NeubrutalismTheme.yellow),
      'pink': NeubrutalismStylesheet(theme: NeubrutalismTheme.pink),
      'mint': NeubrutalismStylesheet(theme: NeubrutalismTheme.mint),
      'orange': NeubrutalismStylesheet(theme: NeubrutalismTheme.orange),
      'sky': NeubrutalismStylesheet(theme: NeubrutalismTheme.sky),
      'lavender': NeubrutalismStylesheet(theme: NeubrutalismTheme.lavender),
      'lime': NeubrutalismStylesheet(theme: NeubrutalismTheme.lime),
      'red': NeubrutalismStylesheet(theme: NeubrutalismTheme.red),
      'greyscale': NeubrutalismStylesheet(theme: NeubrutalismTheme.greyscale),
    };
const Map<String, ArcaneStylesheet> clientWin95Stylesheets =
    <String, ArcaneStylesheet>{
      'standard': Win95Stylesheet(theme: Win95Theme.standard),
      'rainyDay': Win95Stylesheet(theme: Win95Theme.rainyDay),
      'eggplant': Win95Stylesheet(theme: Win95Theme.eggplant),
      'desert': Win95Stylesheet(theme: Win95Theme.desert),
      'rose': Win95Stylesheet(theme: Win95Theme.rose),
    };
const ArcaneStylesheet selectedClientStylesheet = ShadcnStylesheet(
  theme: ShadcnTheme.midnight,
);

@client
class InteractiveDemo extends StatefulWidget {
  final String componentType;

  const InteractiveDemo({required this.componentType, super.key});

  @override
  State<InteractiveDemo> createState() => _InteractiveDemoState();
}

class _InteractiveDemoState extends State<InteractiveDemo> {
  final Map<String, bool> _boolValues = <String, bool>{};
  final Map<String, String> _stringValues = <String, String>{};
  final Map<String, double> _doubleValues = <String, double>{};
  final Map<String, int> _intValues = <String, int>{};
  DemoStyleListenerDisposer? _styleListenerDisposer;

  @override
  void initState() {
    super.initState();
    _styleListenerDisposer = registerDemoStyleListener(_handleStyleChanged);
  }

  @override
  void dispose() {
    _styleListenerDisposer?.call();
    super.dispose();
  }

  void _handleStyleChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    DemoStateController demoState = DemoStateController(
      boolValues: _boolValues,
      stringValues: _stringValues,
      doubleValues: _doubleValues,
      intValues: _intValues,
      notify: () => setState(() {}),
    );
    DemoDefinition? demo = demoRegistry[widget.componentType];
    String exampleCode = demo?.code ?? 'ArcaneComponent(/* configure props */)';
    Widget preview =
        demo?.previewBuilder(demoState) ??
        _buildMissingPreview(widget.componentType);
    ArcaneThemeProvider? parentTheme = ArcaneThemeProvider.of(context);
    ArcaneStylesheet stylesheet = resolveDemoStylesheet(
      parentTheme?.stylesheet,
      shadcnStylesheets: clientShadcnStylesheets,
      neonStylesheets: clientNeonStylesheets,
      neubrutalismStylesheets: clientNeubrutalismStylesheets,
      win95Stylesheets: clientWin95Stylesheets,
      fallbackStylesheet: selectedClientStylesheet,
    );
    Brightness brightness = resolveDemoBrightness(
      parentTheme?.brightness ?? Brightness.dark,
    );

    return ArcaneThemeProvider(
      stylesheet: stylesheet,
      brightness: brightness,
      child: dom.div(<Widget>[
        jaspr.Component.element(
          tag: 'style',
          children: const <jaspr.Component>[dom.RawText(_previewScopeCss)],
        ),
        dom.div(const <Widget>[
          Text('Live Demo'),
        ], classes: 'arcane-demo-kicker'),
        dom.div(<Widget>[
          dom.span(<Widget>[
            Text('Component: ${widget.componentType}'),
          ], classes: 'arcane-demo-widget-meta'),
        ], classes: 'arcane-demo-meta'),
        dom.div(const <Widget>[
          Text('Preview + Code'),
        ], classes: 'arcane-demo-section-title'),
        dom.div(<Widget>[preview], classes: 'arcane-demo-preview-scope'),
        dom.div(const <Widget>[
          Text('Code'),
        ], classes: 'arcane-demo-code-label'),
        dom.pre(
          <jaspr.Component>[
            dom.code(
              <jaspr.Component>[jaspr.Component.text(exampleCode)],
              classes: 'language-dart',
              styles: const dom.Styles(
                raw: <String, String>{'display': 'block'},
              ),
            ),
          ],
          classes: 'arcane-demo-code',
          styles: const dom.Styles(
            raw: <String, String>{
              'margin': '0',
              'padding': '16px',
              'background': 'transparent',
              'border': '0',
              'border-top': '1px solid var(--border)',
              'border-radius': '0',
              'overflow-x': 'auto',
            },
          ),
        ),
      ], classes: 'arcane-demo-panel'),
    );
  }

  Widget _buildMissingPreview(String componentType) {
    return dom.div(
      <Widget>[
        dom.div(const <Widget>[Text('!')], classes: 'arcane-demo-missing-icon'),
        dom.div(<Widget>[
          dom.div(const <Widget>[
            Text('No Demo Found'),
          ], classes: 'arcane-demo-missing-title'),
          dom.div(<Widget>[
            Text('No live preview is registered for "$componentType".'),
          ], classes: 'arcane-demo-missing-body'),
        ], classes: 'arcane-demo-missing-copy'),
      ],
      classes: 'arcane-demo-missing',
      attributes: const <String, String>{'role': 'status'},
    );
  }
}

const String _previewScopeCss = '''
.arcane-demo-panel {
  width: 100%;
  margin: 0 0 1.5rem;
  box-sizing: border-box;
}

.arcane-demo-kicker,
.arcane-demo-section-title,
.arcane-demo-code-label,
.arcane-demo-component-meta,
.arcane-demo-missing-title,
.arcane-demo-missing-body {
  box-sizing: border-box;
}

.arcane-demo-kicker {
  margin: 0 0 0.75rem;
  font-size: 0.8125rem;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--muted-foreground);
}

.arcane-demo-meta {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin: 0 0 1rem;
}

.arcane-demo-component-meta {
  display: inline-flex;
  align-items: center;
  padding: 0;
  border-radius: 0;
  background: transparent;
  color: var(--muted-foreground);
  font-size: 0.875rem;
  line-height: 1.25rem;
}

.arcane-demo-section-title {
  margin: 0 0 0.5rem;
  color: var(--foreground);
  font-size: 0.875rem;
  font-weight: 700;
}

.arcane-demo-preview-scope {
  position: relative;
  overflow: hidden;
  isolation: isolate;
  min-height: 180px;
  border-radius: var(--radius);
  clip-path: none;
  border: 1px solid var(--border);
  background: var(--card);
  box-shadow: none;
}

.arcane-demo-preview-scope::before,
.arcane-demo-preview-scope::after {
  content: none;
  display: none;
}

.arcane-demo-preview-scope > .arcane-box {
  position: relative;
  z-index: 2;
  width: 100%;
  min-height: inherit !important;
  border: 0 !important;
  border-radius: 0 !important;
  background: transparent !important;
  box-shadow: none !important;
}

.arcane-demo-preview-scope .arcane-dialog-overlay,
.arcane-demo-preview-scope .arcane-command-overlay,
.arcane-demo-preview-scope .arcane-sheet,
.arcane-demo-preview-scope .arcane-drawer-container,
.arcane-demo-preview-scope .arcane-dropdown-backdrop {
  position: absolute !important;
  inset: 0 !important;
  z-index: 25 !important;
  border-radius: inherit;
  overflow: hidden;
}

.arcane-demo-preview-scope .arcane-dialog-overlay {
  padding: 1rem !important;
}

.arcane-demo-preview-scope .arcane-command-overlay {
  padding: 1rem !important;
  padding-top: 1rem !important;
}

.arcane-demo-preview-scope .arcane-sheet-panel,
.arcane-demo-preview-scope .arcane-drawer {
  position: absolute !important;
  max-width: 100% !important;
  max-height: 100% !important;
}

.arcane-demo-preview-scope .arcane-command-dialog {
  max-width: min(640px, calc(100% - 2rem)) !important;
  max-height: calc(100% - 2rem) !important;
}

.arcane-demo-preview-scope .arcane-context-menu {
  position: absolute !important;
}

.arcane-demo-code {
  position: relative;
  margin-top: 1rem !important;
  clip-path: none;
  border-color: var(--border) !important;
  border-radius: var(--radius);
  background: var(--card) !important;
  box-shadow: none;
}

.arcane-demo-code code {
  color: var(--foreground);
  font-size: 0.8125rem;
  line-height: 1.65;
}

.arcane-demo-code-label {
  margin: 1rem 0 0.75rem;
  color: var(--muted-foreground);
  font-size: 0.875rem;
  font-weight: 700;
}

.arcane-demo-missing {
  display: flex;
  align-items: flex-start;
  gap: 0.875rem;
  width: min(100%, 44rem);
  margin: 0 auto;
  padding: 1rem;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  background: var(--card);
  color: var(--foreground);
}

.arcane-demo-missing-icon {
  display: grid;
  place-items: center;
  flex: 0 0 auto;
  width: 1.625rem;
  height: 1.625rem;
  font-weight: 900;
  line-height: 1;
}

.arcane-demo-missing-title {
  font-weight: 800;
  line-height: 1.35;
}

.arcane-demo-missing-body {
  margin-top: 0.125rem;
  color: var(--muted-foreground);
  line-height: 1.45;
}
''';
