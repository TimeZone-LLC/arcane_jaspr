import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_ascii/arcane_jaspr_ascii.dart';
import 'package:arcane_neon_web/components/demo_registry.dart';
import 'package:arcane_neon_web/components/interactive_demo.dart';
import 'package:arcane_neon_web/components/interactive_demo_events_stub.dart'
    if (dart.library.js_interop) 'package:arcane_neon_web/components/interactive_demo_events_web.dart';
import 'package:arcane_neon_web/components/interactive_demo_stylesheet_stub.dart'
    if (dart.library.js_interop) 'package:arcane_neon_web/components/interactive_demo_stylesheet_web.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:jaspr/jaspr.dart' show client;

const Map<String, List<String>> asciiComponentFamilies = <String, List<String>>{
  'Controls': <String>[
    'button',
    'button-group',
    'checkbox',
    'switch',
    'radio-group',
    'slider',
    'toggle',
    'toggle-group',
  ],
  'Inputs': <String>[
    'input',
    'textarea',
    'select',
    'combobox',
    'input-group',
    'input-otp',
    'field',
    'calendar',
    'date-picker',
    'time-picker',
    'native-select',
  ],
  'Navigation': <String>[
    'tabs',
    'breadcrumb',
    'navigation-menu',
    'menubar',
    'pagination',
    'sidebar',
  ],
  'Data & layout': <String>[
    'card',
    'data-table',
    'table',
    'chart',
    'accordion',
    'collapsible',
    'carousel',
    'item',
    'avatar',
    'resizable',
    'scroll-area',
    'aspect-ratio',
    'direction',
    'separator',
    'slot-counter',
    'spec-row',
    'scroll-rail',
    'flexi-cards',
    'flow',
    'gutter',
    'gallery',
  ],
  'Cards': <String>[
    'cta-card',
    'feature-card',
    'pricing-card',
    'stat-card',
    'testimonial-card',
  ],
  'Overlays': <String>[
    'dialog',
    'alert-dialog',
    'sheet',
    'drawer',
    'popover',
    'dropdown-menu',
    'context-menu',
    'command',
    'tooltip',
    'hover-card',
  ],
  'Feedback': <String>[
    'alert',
    'badge',
    'progress',
    'spinner',
    'skeleton',
    'sonner',
    'empty',
    'promo',
    'check-list',
    'toast',
  ],
  'Foundations': <String>[
    'typography',
    'kbd',
    'styling',
    'tokens',
    'theming',
    'aliases',
    'borders',
    'colors',
    'display',
    'effects',
    'spacing',
    'typography-styles',
  ],
};

@client
class AsciiShowcase extends StatefulWidget {
  const AsciiShowcase({super.key});

  @override
  State<AsciiShowcase> createState() => _AsciiShowcaseState();
}

class _AsciiShowcaseState extends State<AsciiShowcase> {
  String _family = 'Controls';
  String _component = 'button';
  String _query = '';
  String _motionText = 'Precision, character by character.';
  int _replay = 0;
  int _duration = 1400;
  bool _motionEnabled = true;
  DemoStyleListenerDisposer? _styleListenerDisposer;

  @override
  void initState() {
    super.initState();
    _styleListenerDisposer = registerDemoStyleListener(_refreshTheme);
  }

  @override
  void dispose() {
    _styleListenerDisposer?.call();
    super.dispose();
  }

  void _refreshTheme() {
    if (mounted) {
      setState(() {});
    }
  }

  void _selectFamily(String family) {
    setState(() {
      _family = family;
      _query = '';
      _component = asciiComponentFamilies[family]!.first;
    });
  }

  void _selectComponent(String component) {
    setState(() {
      _component = component;
      for (MapEntry<String, List<String>> family
          in asciiComponentFamilies.entries) {
        if (family.value.contains(component)) {
          _family = family.key;
          break;
        }
      }
    });
  }

  List<String> get _visibleComponents {
    if (_query.trim().isEmpty) {
      return asciiComponentFamilies[_family]!;
    }
    String query = _query.trim().toLowerCase();
    return demoDefinitions
        .where(
          (DemoDefinition demo) =>
              demo.componentType.contains(query) ||
              demo.symbolName.toLowerCase().contains(query),
        )
        .map((DemoDefinition demo) => demo.componentType)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    ArcaneThemeProvider? parentTheme = ArcaneThemeProvider.of(context);
    ArcaneStylesheet stylesheet = resolveDemoStylesheet(
      parentTheme?.stylesheet,
      shadcnStylesheets: clientShadcnStylesheets,
      neonStylesheets: clientNeonStylesheets,
      neubrutalismStylesheets: clientNeubrutalismStylesheets,
      win95Stylesheets: clientWin95Stylesheets,
      asciiStylesheet: const AsciiStylesheet(),
      fallbackStylesheet: selectedClientStylesheet,
    );
    return ArcaneThemeProvider(
      stylesheet: stylesheet,
      brightness: resolveDemoBrightness(
        parentTheme?.brightness ?? Brightness.light,
      ),
      child: dom.div(
        <Widget>[_buildHero(), _buildMotion(), _buildComponents()],
        classes: 'ascii-workbench',
        attributes: <String, String>{
          'data-ascii-motion': _motionEnabled ? 'on' : 'off',
        },
      ),
    );
  }

  Widget _buildHero() {
    return dom.section(<Widget>[
      const AsciiDatum(label: 'ARCANE / THEME 05', value: 'ASCII'),
      dom.div(<Widget>[
        dom.div(<Widget>[
          dom.h1(const <Widget>[
            Text('Ascii.'),
          ], classes: 'ascii-showcase-title'),
          dom.p(const <Widget>[
            Text('A lighter kind of interface.'),
          ], classes: 'ascii-showcase-lede'),
          dom.p(const <Widget>[
            Text(
              'Warm paper. Fine lines. Motion with room to breathe. '
              'A complete Arcane theme, from a quiet reading surface to a moving composition.',
            ),
          ], classes: 'ascii-showcase-description'),
          dom.nav(
            <Widget>[
              const Button.primary(
                label: 'Explore components',
                href: '#component-lab',
              ),
              const Button.secondary(
                label: 'Use this theme',
                href: '#installation',
              ),
              Button.ghost(
                label: _motionEnabled ? 'Pause motion' : 'Resume motion',
                attributes: <String, String>{
                  'aria-pressed': (!_motionEnabled).toString(),
                },
                onPressed: () =>
                    setState(() => _motionEnabled = !_motionEnabled),
              ),
            ],
            classes: 'ascii-showcase-actions',
            attributes: const <String, String>{
              'aria-label': 'Ascii showcase sections',
            },
          ),
        ], classes: 'ascii-showcase-intro'),
        dom.div(<Widget>[
          AsciiOrbit(
            animated: _motionEnabled,
            classes: 'ascii-showcase-orbit',
            children: <Widget>[
              dom.span(const <Widget>[Text('Aa')], classes: 'ascii-orbit-type'),
              dom.span(const <Widget>[
                Text('+ / :'),
              ], classes: 'ascii-orbit-code'),
              dom.span(const <Widget>[
                Text('01'),
              ], classes: 'ascii-orbit-number'),
              dom.span(const <Widget>[Text('a')], classes: 'ascii-orbit-serif'),
            ],
          ),
          AsciiDatum(
            label: 'LIVE COMPONENTS',
            value: demoDefinitions.length.toString(),
          ),
          const AsciiDatum(label: 'COLOR MODES', value: 'PAPER / INK'),
          AsciiDatum(
            label: 'MOTION',
            value: _motionEnabled ? 'ORBIT / REVEAL' : 'PAUSED',
          ),
        ], classes: 'ascii-showcase-specimen'),
      ], classes: 'ascii-showcase-hero-grid'),
    ], classes: 'ascii-showcase-hero');
  }

  Widget _buildMotion() {
    Duration duration = Duration(milliseconds: _duration);
    return dom.section(
      <Widget>[
        const AsciiDatum(label: '01 / MOTION STUDIES', value: 'REPLAYABLE'),
        dom.div(<Widget>[
          dom.h2(const <Widget>[Text('Set the pace.')]),
          dom.p(const <Widget>[
            Text(
              'Slow orbits give a composition depth. Reveals introduce a section. '
              'Short character transitions add texture to labels.',
            ),
          ]),
        ], classes: 'ascii-showcase-section-heading'),
        dom.div(<Widget>[
          TextInput(
            label: 'Specimen text',
            value: _motionText,
            fullWidth: true,
            onChanged: (String text) => setState(() => _motionText = text),
          ),
          ArcaneSelect(
            label: 'Duration',
            fullWidth: true,
            value: _duration.toString(),
            options: const <ArcaneSelectOption>[
              ArcaneSelectOption(value: '700', label: 'Quick / 700 ms'),
              ArcaneSelectOption(value: '1400', label: 'Measured / 1.4 s'),
              ArcaneSelectOption(value: '2400', label: 'Slow / 2.4 s'),
            ],
            onChanged: (String value) => setState(() {
              _duration = int.parse(value);
              _replay++;
            }),
          ),
          dom.div(<Widget>[
            Button.secondary(
              label: _motionEnabled ? 'Pause specimens' : 'Enable motion',
              attributes: <String, String>{
                'aria-pressed': (!_motionEnabled).toString(),
              },
              onPressed: () => setState(() {
                _motionEnabled = !_motionEnabled;
                _replay++;
              }),
            ),
            Button.primary(
              label: 'Replay motion',
              disabled: !_motionEnabled,
              onPressed: () => setState(() => _replay++),
            ),
          ], classes: 'ascii-showcase-motion-actions'),
        ], classes: 'ascii-showcase-motion-controls'),
        dom.div(
          <Widget>[
            dom.div(<Widget>[
              dom.span(const <Widget>[
                Text('A / DECODE'),
              ], classes: 'ascii-showcase-label'),
              AsciiText(
                _motionText,
                motion: _motionEnabled
                    ? AsciiTextMotion.decode
                    : AsciiTextMotion.none,
                duration: duration,
              ),
            ], classes: 'ascii-showcase-motion-sample'),
            dom.div(<Widget>[
              dom.span(const <Widget>[
                Text('B / TYPEWRITER'),
              ], classes: 'ascii-showcase-label'),
              AsciiText(
                _motionText,
                motion: _motionEnabled
                    ? AsciiTextMotion.typewriter
                    : AsciiTextMotion.none,
                duration: duration,
                cursor: _motionEnabled,
              ),
            ], classes: 'ascii-showcase-motion-sample'),
            dom.div(<Widget>[
              dom.span(const <Widget>[
                Text('C / DATUM'),
              ], classes: 'ascii-showcase-label'),
              AsciiDatum(
                label: 'TYPEFACE',
                value: 'MONOSPACE',
                animated: _motionEnabled,
              ),
              AsciiDatum(
                label: 'PALETTE',
                value: 'PAPER / INK',
                animated: _motionEnabled,
              ),
            ], classes: 'ascii-showcase-motion-sample'),
            dom.div(<Widget>[
              dom.span(const <Widget>[
                Text('D / REVEAL'),
              ], classes: 'ascii-showcase-label'),
              for (int index = 0; index < 3; index++)
                AsciiReveal(
                  animated: _motionEnabled,
                  duration: duration,
                  delay: Duration(milliseconds: index * 120),
                  child: dom.div(<Widget>[
                    Text(
                      const <String>[
                        'A fine line.',
                        'A measured entrance.',
                        'Room to read.',
                      ][index],
                    ),
                  ], classes: 'ascii-showcase-reveal-line'),
                ),
            ], classes: 'ascii-showcase-motion-sample'),
          ],
          classes: 'ascii-showcase-motion-samples',
          key: ValueKey<int>(_replay),
        ),
        dom.p(const <Widget>[
          Text(
            'Your system’s reduced-motion preference takes priority. Text remains readable and controls remain usable when motion is disabled.',
          ),
        ], classes: 'ascii-showcase-footnote'),
      ],
      id: 'motion-studies',
      classes: 'ascii-showcase-section',
    );
  }

  Widget _buildComponents() {
    List<String> visibleComponents = _visibleComponents;
    return dom.section(
      <Widget>[
        AsciiDatum(
          label: '02 / COMPONENT LAB',
          value: '${demoDefinitions.length} LIVE EXAMPLES',
        ),
        dom.div(<Widget>[
          dom.h2(const <Widget>[Text('The whole system, in your hands.')]),
          dom.p(const <Widget>[
            Text(
              'Pick a family, then interact with a component. Hover, focus, select, expand, and open. '
              'The header switches the entire documentation site between light, dark, and other Arcane themes.',
            ),
          ]),
        ], classes: 'ascii-showcase-section-heading'),
        dom.nav(
          <Widget>[
            for (String family in asciiComponentFamilies.keys)
              Button(
                label: family,
                variant: _family == family
                    ? ButtonVariant.primary
                    : ButtonVariant.ghost,
                attributes: <String, String>{
                  'aria-pressed': (_family == family).toString(),
                  'data-ascii-family': family,
                },
                onPressed: () => _selectFamily(family),
              ),
          ],
          classes: 'ascii-showcase-family-tabs',
          attributes: const <String, String>{
            'aria-label': 'Component families',
          },
        ),
        dom.div(<Widget>[
          TextInput(
            label: 'Find a component',
            placeholder: 'Search all ${demoDefinitions.length} examples…',
            value: _query,
            fullWidth: true,
            onChanged: (String query) => setState(() => _query = query),
          ),
          if (visibleComponents.isNotEmpty)
            ArcaneSelect(
              label: _query.isEmpty ? _family : 'Search results',
              value: visibleComponents.contains(_component) ? _component : null,
              placeholder: 'Choose a component',
              fullWidth: true,
              options: <ArcaneSelectOption>[
                for (String component in visibleComponents)
                  ArcaneSelectOption(
                    value: component,
                    label: _componentLabel(component),
                  ),
              ],
              onChanged: _selectComponent,
            )
          else
            dom.p(
              <Widget>[
                Text(
                  'No components match “$_query”. Try a name such as button, chart, or dialog.',
                ),
              ],
              attributes: const <String, String>{'role': 'status'},
            ),
        ], classes: 'ascii-showcase-component-controls'),
        dom.div(
          <Widget>[
            dom.span(<Widget>[
              Text('$_family / ${_componentLabel(_component)}'),
            ]),
            Button.ghost(
              label: 'Reset example',
              onPressed: () => setState(() => _replay++),
            ),
          ],
          classes: 'ascii-showcase-current',
          attributes: const <String, String>{'aria-live': 'polite'},
        ),
        InteractiveDemo(
          componentType: _component,
          key: ValueKey<String>('$_component-$_replay'),
        ),
        dom.details(<Widget>[
          dom.summary(<Widget>[
            Text('Browse all ${demoDefinitions.length} examples'),
          ]),
          dom.div(<Widget>[
            for (MapEntry<String, List<String>> family
                in asciiComponentFamilies.entries)
              dom.div(<Widget>[
                dom.h3(<Widget>[Text(family.key)]),
                dom.div(<Widget>[
                  for (String component in family.value)
                    Button.ghost(
                      label: _componentLabel(component),
                      onPressed: () => _selectComponent(component),
                    ),
                ], classes: 'ascii-showcase-index-links'),
              ]),
          ], classes: 'ascii-showcase-index'),
        ], classes: 'ascii-showcase-all-components'),
      ],
      id: 'component-lab',
      classes: 'ascii-showcase-section',
    );
  }

  String _componentLabel(String component) => component
      .split('-')
      .map((String word) => '${word[0].toUpperCase()}${word.substring(1)}')
      .join(' ');
}
