import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr/component/card/flexi_cards.dart';
import 'package:arcane_jaspr/component/input/time_picker.dart';
import 'package:arcane_jaspr/component/view/check_list.dart';
import 'package:arcane_jaspr/component/view/slot_counter.dart';
import 'package:arcane_jaspr/component/view/spec_row.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:neubrutalism_print_club/component_manifest.dart';
import 'package:web/web.dart' as web;

class ComponentGallery extends StatefulWidget {
  const ComponentGallery({super.key});

  @override
  State<ComponentGallery> createState() => _ComponentGalleryState();
}

class _ComponentGalleryState extends State<ComponentGallery> {
  bool _dark = false;
  bool _comic = false;
  bool _rounded = false;
  String _group = 'inputs';
  String _status = 'Ready to try a component.';
  String _paper = 'recycled';
  String _finish = 'matte';
  String _toggle = 'left';
  String _cycle = 'draft';
  String _name = 'Print study';
  String _runName = 'Autumn run';
  String _notes = 'Two inks. One sheet. Plenty of possibilities.';
  bool _checked = true;
  bool _switch = false;
  bool _pressed = false;
  bool _showTopAnnouncement = true;
  bool _showInlineAnnouncement = true;
  double _ink = 65;
  double _rangeStart = 20;
  double _rangeEnd = 80;
  double _rating = 4;
  int _tab = 0;
  int _page = 1;
  int _prints = 12;
  DateTime? _date = DateTime(2026, 10, 25);
  DateTime _month = DateTime(2026, 10);
  TimeOfDay? _time = const TimeOfDay(hour: 10, minute: 30);
  String _overlay = '';
  Set<String> _selectedRows = <String>{};

  @override
  void initState() {
    super.initState();
    final Map<String, String> query = Uri.base.queryParameters;
    _dark = query['theme'] == 'dark';
    _comic = query['variant'] == 'neucomic';
    _rounded = query['corners'] == 'rounded';
    _group = componentGroups.containsKey(query['group'])
        ? query['group']!
        : query['group'] == 'all'
        ? 'all'
        : 'inputs';
    _applyTheme();
  }

  void _applyTheme() => web.document.documentElement!.setAttribute(
    'class',
    _dark ? 'dark' : 'light',
  );

  String _url({String? group, String? view}) => Uri(
    path: '/',
    queryParameters: <String, String>{
      'view': view ?? 'components',
      'variant': _comic ? 'neucomic' : 'classic',
      'theme': _dark ? 'dark' : 'light',
      'corners': _rounded ? 'rounded' : 'square',
      if (view != 'workshops') 'group': group ?? _group,
    },
  ).toString();

  void _appearance({bool? dark, String? variant, String? corners}) {
    setState(() {
      _dark = dark ?? _dark;
      _comic = variant == null ? _comic : variant == 'neucomic';
      _rounded = corners == null ? _rounded : corners == 'rounded';
    });
    _applyTheme();
    web.window.history.replaceState(null, '', _url());
  }

  void _report(String message) => setState(() => _status = message);
  void _open(String overlay) => setState(() => _overlay = overlay);
  void _close() => setState(() => _overlay = '');

  Widget _row(List<Widget> children) => dom.div(classes: 'cg-row', children);

  Widget _stack(List<Widget> children) =>
      dom.div(classes: 'cg-stack', children);

  Widget _note(String text) => dom.p(classes: 'cg-note', <Widget>[Text(text)]);

  Widget _fixture(
    String id,
    String title,
    List<Widget> children, {
    bool wide = false,
  }) => dom.article(
    id: 'fixture-$id',
    classes: 'cg-fixture${wide ? ' cg-wide' : ''}',
    attributes: <String, String>{
      'data-fixture': id,
      'data-component': componentCoverage[id]!.join(' '),
      'aria-labelledby': 'title-$id',
    },
    <Widget>[
      dom.header(classes: 'cg-fixture-heading', <Widget>[
        dom.h2(id: 'title-$id', <Widget>[Text(title)]),
        dom.span(classes: 'cg-fixture-code', <Widget>[Text(id)]),
      ]),
      dom.div(classes: 'cg-fixture-body', children),
    ],
  );

  @override
  Widget build(BuildContext context) => ArcaneApp(
    stylesheet: NeubrutalismStylesheet(
      rounded: _rounded,
      variant: _comic
          ? NeubrutalismVariant.neuComic
          : NeubrutalismVariant.classic,
    ),
    brightness: _dark ? Brightness.dark : Brightness.light,
    title: 'Print Club component workshop',
    home: dom.div(
      classes: 'component-gallery',
      attributes: <String, String>{
        'data-gallery-variant': _comic ? 'neucomic' : 'classic',
        'data-gallery-theme': _dark ? 'dark' : 'light',
        'data-gallery-corners': _rounded ? 'rounded' : 'square',
        'data-gallery-group': _group,
        'data-renderer-count':
            '${componentCoverage.values.expand((List<String> slots) => slots).toSet().length}',
      },
      <Widget>[
        const dom.a(href: '#gallery-main', classes: 'cg-skip', <Widget>[
          Text('Skip to components'),
        ]),
        dom.header(classes: 'cg-header', <Widget>[
          dom.div(classes: 'cg-heading', <Widget>[
            dom.a(href: _url(view: 'workshops'), classes: 'cg-back', <Widget>[
              const Text('PRINT CLUB / WORKSHOP'),
            ]),
            const dom.h1(<Widget>[Text('The component press.')]),
            const dom.p(<Widget>[
              Text(
                'Real Arcane components. Fictional studio content. Every control is here to try.',
              ),
            ]),
          ]),
          dom.div(classes: 'cg-appearance', <Widget>[
            ArcaneCombobox<String>(
              id: 'gallery-style',
              label: 'Visual style',
              searchable: false,
              value: _comic ? 'neucomic' : 'classic',
              options: const <ComboboxOption<String>>[
                ComboboxOption<String>(value: 'classic', label: 'Classic'),
                ComboboxOption<String>(value: 'neucomic', label: 'NeuComic'),
              ],
              onChanged: (String? value) => _appearance(variant: value),
            ),
            ArcaneSelect(
              id: 'gallery-corners',
              label: 'Corners',
              value: _rounded ? 'rounded' : 'square',
              options: const <ArcaneSelectOption>[
                ArcaneSelectOption(value: 'square', label: 'Square'),
                ArcaneSelectOption(value: 'rounded', label: 'Rounded'),
              ],
              onChanged: (String value) => _appearance(corners: value),
              fullWidth: true,
            ),
            ArcaneToggleSwitch(
              id: 'gallery-dark',
              value: _dark,
              label: 'Dark mode',
              onChanged: (bool value) => _appearance(dark: value),
            ),
          ]),
        ]),
        dom.nav(
          classes: 'cg-nav',
          attributes: const <String, String>{
            'aria-label': 'Component categories',
          },
          <Widget>[
            for (final MapEntry<String, String> group
                in componentGroups.entries)
              dom.a(
                href: _url(group: group.key),
                attributes: <String, String>{
                  if (_group == group.key) 'aria-current': 'page',
                },
                <Widget>[Text(group.value)],
              ),
            dom.a(
              href: _url(group: 'all'),
              attributes: <String, String>{
                if (_group == 'all') 'aria-current': 'page',
              },
              const <Widget>[Text('All components')],
            ),
          ],
        ),
        dom.div(
          classes: 'cg-status',
          attributes: const <String, String>{
            'role': 'status',
            'aria-live': 'polite',
          },
          <Widget>[Text(_status)],
        ),
        dom.main_(id: 'gallery-main', classes: 'cg-main', <Widget>[
          if (_group == 'inputs' || _group == 'all')
            _section('inputs', _inputs()),
          if (_group == 'navigation' || _group == 'all')
            _section('navigation', _navigation()),
          if (_group == 'overlays' || _group == 'all')
            _section('overlays', _overlays()),
          if (_group == 'feedback' || _group == 'all')
            _section('feedback', _feedback()),
          if (_group == 'cards' || _group == 'all') _section('cards', _cards()),
          if (_group == 'layout' || _group == 'all')
            _section('layout', _layout()),
        ]),
        ..._overlayWidgets(),
        ArcaneToast.container(),
        dom.footer(classes: 'cg-footer', <Widget>[
          const Text(
            '104 renderer slots / 37 review fixtures / 2 visual editions',
          ),
          dom.a(href: _url(view: 'workshops'), const <Widget>[
            Text('Back to Print Club'),
          ]),
        ]),
      ],
    ),
  );

  Widget _section(String group, List<Widget> children) => dom.section(
    classes: 'cg-section',
    attributes: <String, String>{'data-group': group},
    <Widget>[
      dom.div(classes: 'cg-section-heading', <Widget>[
        dom.h2(<Widget>[Text(componentGroups[group]!)]),
        Text('${children.length} fixtures'),
      ]),
      dom.div(classes: 'cg-grid', children),
    ],
  );

  List<Widget> _inputs() => <Widget>[
    _fixture('buttons', 'Press, hold, repeat', <Widget>[
      _row(<Widget>[
        for (final ButtonVariant variant in ButtonVariant.values)
          Button(
            label: variant.name,
            variant: variant,
            onPressed: () => _report('${variant.name} button pressed.'),
          ),
        const Button(label: 'Unavailable', disabled: true),
        const Button(label: 'Printing', loading: true),
        IconButton(
          icon: ArcaneIcon.plus(),
          semanticLabel: 'Add a print',
          onPressed: () => _report('One print added.'),
        ),
      ]),
      _row(<Widget>[
        Button(
          label: 'Small',
          size: ButtonSize.small,
          onPressed: () => _report('Small button pressed.'),
        ),
        Button(
          label: 'Medium',
          onPressed: () => _report('Medium button pressed.'),
        ),
        Button(
          label: 'Large',
          size: ButtonSize.large,
          onPressed: () => _report('Large button pressed.'),
        ),
      ]),
    ], wide: true),
    _fixture('text-fields', 'Words on paper', <Widget>[
      TextInput(
        id: 'gallery-title',
        label: 'Print title',
        value: _name,
        helperText: 'Give this edition a name.',
        onChanged: (String value) => setState(() => _name = value),
        fullWidth: true,
      ),
      const TextInput(
        id: 'gallery-error',
        label: 'Edition code',
        value: 'INK',
        error: 'Use at least four characters.',
        fullWidth: true,
      ),
      const TextInput(
        id: 'gallery-disabled',
        label: 'Archive code',
        value: 'PC-2026',
        disabled: true,
        fullWidth: true,
      ),
      TextArea(
        id: 'gallery-notes',
        label: 'Studio notes',
        value: _notes,
        rows: 3,
        onChanged: (String value) => setState(() => _notes = value),
      ),
    ]),
    _fixture('selects', 'Choose your stock', <Widget>[
      ArcaneSelect(
        id: 'gallery-paper',
        label: 'Paper stock',
        value: _paper,
        fullWidth: true,
        options: const <ArcaneSelectOption>[
          ArcaneSelectOption(
            value: 'recycled',
            label: 'Recycled cream / 170 gsm',
          ),
          ArcaneSelectOption(value: 'white', label: 'Bright white / 200 gsm'),
          ArcaneSelectOption(value: 'kraft', label: 'Kraft / 250 gsm'),
          ArcaneSelectOption(
            value: 'soldout',
            label: 'Cotton rag / unavailable',
            disabled: true,
          ),
        ],
        onChanged: (String value) => setState(() => _paper = value),
      ),
      ArcaneCombobox<String>(
        id: 'gallery-search-stock',
        label: 'Search paper stock',
        value: _paper,
        options: const <ComboboxOption<String>>[
          ComboboxOption<String>(
            value: 'recycled',
            label: 'Recycled cream',
            description: 'Warm white, visible texture',
          ),
          ComboboxOption<String>(
            value: 'white',
            label: 'Bright white',
            description: 'Clean, smooth surface',
          ),
          ComboboxOption<String>(
            value: 'kraft',
            label: 'Kraft',
            description: 'Brown, uncoated stock',
          ),
        ],
        onChanged: (String? value) {
          if (value != null) setState(() => _paper = value);
        },
      ),
      const ArcaneSelect(
        id: 'gallery-select-disabled',
        label: 'Unavailable stock',
        disabled: true,
        fullWidth: true,
        options: <ArcaneSelectOption>[
          ArcaneSelectOption(value: 'cotton', label: 'Cotton rag'),
        ],
      ),
      const ArcaneSelect(
        id: 'gallery-select-error',
        label: 'Required finish',
        error: 'Choose a finish before printing.',
        fullWidth: true,
        options: <ArcaneSelectOption>[
          ArcaneSelectOption(value: 'matte', label: 'Matte'),
          ArcaneSelectOption(value: 'gloss', label: 'Gloss'),
        ],
      ),
      _note(
        'The simple select and searchable combobox both use themed option panels.',
      ),
    ]),
    _fixture('choices', 'Small decisions', <Widget>[
      ArcaneCheckbox(
        id: 'gallery-checkbox',
        checked: _checked,
        label: 'Include a proof print',
        description: 'Check the colors before the full run.',
        onChanged: (bool value) => setState(() => _checked = value),
      ),
      const ArcaneCheckbox(
        checked: false,
        disabled: true,
        label: 'Foil finish unavailable',
      ),
      ArcaneToggleSwitch(
        id: 'gallery-switch',
        value: _switch,
        label: 'Mirror the artwork',
        onChanged: (bool value) => setState(() => _switch = value),
      ),
      ArcaneRadioGroup<String>(
        id: 'gallery-finish',
        name: 'gallery-finish',
        label: 'Finish',
        value: _finish,
        options: const <RadioOption<String>>[
          RadioOption<String>(
            value: 'matte',
            label: 'Matte',
            description: 'Soft, uncoated surface',
          ),
          RadioOption<String>(
            value: 'gloss',
            label: 'Gloss',
            description: 'Bright, coated surface',
          ),
          RadioOption<String>(value: 'foil', label: 'Foil', disabled: true),
        ],
        onChanged: (String value) => setState(() => _finish = value),
      ),
    ]),
    _fixture('sliders', 'Set the ink', <Widget>[
      ArcaneSlider(
        id: 'gallery-ink',
        value: _ink,
        label: 'Ink coverage',
        valueSuffix: '%',
        step: 5,
        onChanged: (double value) => setState(() => _ink = value),
      ),
      ArcaneSlider.range(
        id: 'gallery-range',
        minValue: _rangeStart,
        maxValue: _rangeEnd,
        label: 'Print range',
        onRangeChanged: (double start, double end) => setState(() {
          _rangeStart = start;
          _rangeEnd = end;
        }),
      ),
      const ArcaneSlider(
        id: 'gallery-ink-disabled',
        value: 35,
        label: 'Locked proof',
        disabled: true,
      ),
    ]),
    _fixture('toggles', 'Make a mark', <Widget>[
      ArcaneToggleGroup(
        id: 'gallery-alignment',
        value: _toggle,
        items: const <ToggleGroupItem>[
          ToggleGroupItem(value: 'left', child: Text('Left')),
          ToggleGroupItem(value: 'center', child: Text('Center')),
          ToggleGroupItem(value: 'right', child: Text('Right')),
        ],
        onChanged: (String? value) {
          if (value != null) setState(() => _toggle = value);
        },
      ),
      _row(<Widget>[
        ArcaneToggleButton(
          id: 'gallery-bold',
          value: _pressed,
          label: 'Bold print',
          onChanged: (bool value) => setState(() => _pressed = value),
        ),
        ArcaneCycleButton<String>(
          id: 'gallery-cycle',
          value: _cycle,
          options: const <CycleOption<String>>[
            CycleOption<String>(value: 'draft', label: 'Draft'),
            CycleOption<String>(value: 'proof', label: 'Proof'),
            CycleOption<String>(value: 'ready', label: 'Ready'),
          ],
          onChanged: (String value) => setState(() => _cycle = value),
        ),
      ]),
      _note('Alignment: $_toggle. Edition state: $_cycle.'),
    ]),
    _fixture('dates', 'A date at the press', <Widget>[
      ArcaneDatePicker(
        id: 'gallery-date',
        label: 'Workshop date',
        value: _date,
        onChanged: (DateTime? value) => setState(() => _date = value),
      ),
      ArcaneTimePicker(
        id: 'gallery-time',
        label: 'Start time',
        value: _time,
        minuteInterval: 15,
        onChanged: (TimeOfDay? value) => setState(() => _time = value),
      ),
      ArcaneCalendar(
        id: 'gallery-calendar',
        month: _month,
        selected: _date,
        onSelect: (DateTime value) => setState(() => _date = value),
        onMonthChange: (DateTime value) => setState(() => _month = value),
      ),
    ]),
    _fixture('otp', 'Four-digit edition', <Widget>[
      ArcaneOtpInput.fourDigit(
        label: 'Edition access code',
        onComplete: (String value) => _report('Demo code $value entered.'),
      ),
      const ArcaneOtpInput.fourDigit(
        label: 'Invalid code',
        value: '1234',
        error: 'This demo code has expired.',
      ),
      const ArcaneOtpInput.fourDigit(
        label: 'Locked code',
        value: '0000',
        disabled: true,
      ),
    ]),
    _fixture('forms', 'A complete field group', <Widget>[
      ArcaneForm(
        submitText: 'Save edition',
        cancelText: 'Reset title',
        onSubmit: () => _report('Edition saved: $_name.'),
        onCancel: () => setState(() => _name = 'Print study'),
        children: <Widget>[
          ArcaneFormSection(
            title: 'Edition details',
            description: 'These values stay in this demo.',
            children: <Widget>[
              ArcaneFieldWrapper(
                fieldId: 'gallery-wrapped',
                labelText: 'Edition title',
                required: true,
                description: 'Printed on the back of the sheet.',
                field: TextInput(
                  id: 'gallery-wrapped',
                  value: _name,
                  fullWidth: true,
                  onChanged: (String value) => setState(() => _name = value),
                ),
              ),
              ArcaneInputGroup(
                children: <Widget>[
                  Expanded(
                    child: TextInput(
                      id: 'gallery-group-input',
                      label: 'Run name',
                      value: _runName,
                      fullWidth: true,
                      onChanged: (String value) =>
                          setState(() => _runName = value),
                    ),
                  ),
                  Button(
                    label: 'Check',
                    onPressed: () =>
                        _report('The run name is available in this demo.'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ]),
  ];

  List<ArcaneMenuItem> get _menuItems => <ArcaneMenuItem>[
    MenuItemAction(
      label: 'Duplicate edition',
      icon: ArcaneIcon.copy(),
      onSelect: () => _report('Edition duplicated.'),
    ),
    MenuItemAction(
      label: 'Save a proof',
      icon: ArcaneIcon.download(),
      onSelect: () => _report('Proof saved in this demo.'),
    ),
    const MenuItemSeparator(),
    MenuItemAction(
      label: 'Archive edition',
      onSelect: () => _report('Edition archived in this demo.'),
    ),
  ];

  List<Widget> _navigation() => <Widget>[
    _fixture('tabs', 'From sketch to print', <Widget>[
      const ArcaneTabs(
        tabs: <ArcaneTabItem>[
          ArcaneTabItem(
            label: 'Sketch',
            content: Text('Start with a line drawing and two colors.'),
          ),
          ArcaneTabItem(
            label: 'Proof',
            content: Text('Check registration before the full run.'),
          ),
          ArcaneTabItem(
            label: 'Edition',
            content: Text('Number each print after the ink dries.'),
          ),
        ],
      ),
      ArcaneTabBar(
        tabs: const <ArcaneTabBarItem>[
          ArcaneTabBarItem(label: 'Front'),
          ArcaneTabBarItem(label: 'Back'),
        ],
        selectedIndex: _tab,
        onChanged: (int value) => setState(() => _tab = value),
      ),
      _note(
        _tab == 0
            ? 'Front: the artwork.'
            : 'Back: signature and edition number.',
      ),
    ]),
    _fixture('navigation', 'Find your place', <Widget>[
      ArcaneBreadcrumbs(
        items: <BreadcrumbItem>[
          BreadcrumbItem(
            label: 'Workshop',
            href: _url(view: 'workshops'),
          ),
          BreadcrumbItem(
            label: 'Components',
            href: _url(group: 'all'),
          ),
          const BreadcrumbItem(label: 'Navigation'),
        ],
      ),
      ArcanePagination(
        currentPage: _page,
        totalPages: 8,
        onPageChange: (int value) => setState(() => _page = value),
      ),
      _note('Showing edition page $_page of 8.'),
      _row(const <Widget>[
        Text('Command shortcut'),
        ArcaneKbd('Ctrl'),
        ArcaneKbd('K'),
      ]),
    ]),
    _fixture('menus', 'Tools for the edition', <Widget>[
      ArcaneMenubar(
        menus: <ArcaneMenubarMenu>[
          ArcaneMenubarMenu(label: 'Edition', items: _menuItems),
          ArcaneMenubarMenu(
            label: 'View',
            items: <ArcaneMenuItem>[
              MenuItemAction(
                label: 'Show cards',
                onSelect: () =>
                    web.window.location.assign(_url(group: 'cards')),
              ),
              MenuItemAction(
                label: 'Show inputs',
                onSelect: () =>
                    web.window.location.assign(_url(group: 'inputs')),
              ),
            ],
          ),
        ],
      ),
      _row(<Widget>[
        ArcaneDropdownMenu(
          trigger: const Button.outline(label: 'Edition actions'),
          items: _menuItems,
        ),
        ArcaneMegaMenu(
          label: 'Studio tools',
          sections: <ArcaneMegaMenuSection>[
            ArcaneMegaMenuSection(title: 'Edition', items: _menuItems),
          ],
        ),
      ]),
      ArcaneContextMenu(
        trigger: const Card.outlined(
          child: Text('Right-click this proof to open its tools.'),
        ),
        items: _menuItems,
      ),
      _note(
        'The same actions are available from the Edition actions button on touch screens.',
      ),
    ]),
    _fixture('sidebar', 'A studio sidebar', <Widget>[
      dom.div(classes: 'cg-sidebar-preview', <Widget>[
        ArcaneSidebar(
          width: 240,
          header: const Text('PRINT DESK'),
          footer: const Text('Sample workspace'),
          children: <Widget>[
            const ArcaneSidebarExpanded(
              children: <Widget>[Text('Edition workspace')],
            ),
            const ArcaneSidebarCollapsed(children: <Widget>[Text('PC')]),
            ArcaneSidebarGroup(
              label: 'Workspace',
              children: <Widget>[
                ArcaneSidebarItem(
                  label: 'Editions',
                  icon: ArcaneIcon.layers(),
                  selected: true,
                  onTap: () => _report('Editions selected.'),
                ),
                ArcaneSidebarItem(
                  label: 'Schedule',
                  icon: ArcaneIcon.calendar(),
                  onTap: () => _report('Schedule selected.'),
                ),
              ],
            ),
            const ArcaneSidebarSeparator(),
            ArcaneSidebarSubMenu(
              label: 'Archive',
              defaultOpen: true,
              children: <Widget>[
                ArcaneSidebarItem(
                  label: 'Autumn 2026',
                  onTap: () => _report('Autumn archive selected.'),
                ),
              ],
            ),
            ArcaneSidebarSection(
              label: 'Supplies',
              children: <Widget>[
                ArcaneSidebarItem(
                  label: 'Paper stock',
                  onTap: () => _report('Paper stock selected.'),
                ),
              ],
            ),
          ],
        ),
      ]),
    ]),
    _fixture('disclosures', 'Open the details', <Widget>[
      const ArcaneAccordion(
        bordered: true,
        items: <ArcaneAccordionItem>[
          ArcaneAccordionItem(
            title: 'What is a proof print?',
            content:
                'A single test sheet used to check color and registration.',
            defaultOpen: true,
          ),
          ArcaneAccordionItem(
            title: 'When should I number prints?',
            content: 'Once the ink is dry and the final run is checked.',
          ),
        ],
      ),
      const ArcaneDisclosure(
        summary: Text('Paper care'),
        child: Text('Keep uncoated paper flat and dry.'),
      ),
      const ArcaneDisclosureGroup(
        items: <ArcaneDisclosureItem>[
          ArcaneDisclosureItem(
            summary: Text('Ink cleanup'),
            content: Text(
              'Use the cleaning materials recommended for your ink.',
            ),
          ),
          ArcaneDisclosureItem(
            summary: Text('Drying rack'),
            content: Text('Leave space between wet prints.'),
          ),
        ],
      ),
    ], wide: true),
  ];

  List<Widget> _overlays() => <Widget>[
    _fixture('dialogs', 'A moment to decide', <Widget>[
      _row(<Widget>[
        Button(label: 'Open dialog', onPressed: () => _open('dialog')),
        Button.outline(
          label: 'Confirm archive',
          onPressed: () => _open('confirm'),
        ),
        Button.outline(label: 'Show alert', onPressed: () => _open('alert')),
        Button.outline(
          label: 'Open commands',
          onPressed: () => _open('command'),
        ),
      ]),
      _note(
        'Dialogs support Escape, a close button, and focus return to their trigger.',
      ),
    ], wide: true),
    _fixture('sheets', 'Keep the workspace close', <Widget>[
      _row(<Widget>[
        Button(label: 'Open sheet', onPressed: () => _open('sheet')),
        Button.outline(label: 'Open drawer', onPressed: () => _open('drawer')),
        Button.outline(
          label: 'Open action sheet',
          onPressed: () => _open('actions'),
        ),
      ]),
      _note('Bottom sheets, side drawers, and compact action lists.'),
    ]),
    _fixture('floating', 'A little context', <Widget>[
      _row(<Widget>[
        ArcanePopover(
          trigger: const Button.outline(label: 'Paper details'),
          content: _stack(const <Widget>[
            Text('Recycled cream'),
            Text('170 gsm. Uncoated. Warm white.'),
          ]),
        ),
        ArcaneTooltip(
          text: 'A test sheet before the full print run.',
          child: Button.outline(
            label: 'What is a proof?',
            onPressed: () =>
                _report('A proof is a test sheet before the full print run.'),
          ),
        ),
        ArcaneHoverCard(
          trigger: Button.outline(
            label: 'Print desk',
            onPressed: () => _report(
              'A fictional studio workspace used to review components.',
            ),
          ),
          textContent:
              'A fictional studio workspace used to review components.',
        ),
      ]),
    ]),
    _fixture('toasts', 'Let the studio know', <Widget>[
      _row(<Widget>[
        Button.success(
          label: 'Success toast',
          onPressed: () => toast.success('Your edition has been saved.'),
        ),
        Button.info(
          label: 'Info toast',
          onPressed: () => toast.info('The proof is ready to review.'),
        ),
        Button.warning(
          label: 'Warning toast',
          onPressed: () => toast.warning('There are only three sheets left.'),
        ),
        Button.destructive(
          label: 'Error toast',
          onPressed: () => toast.error('The sample print could not be saved.'),
        ),
      ]),
      _note('Toasts are dismissible and appear at the edge of the viewport.'),
    ], wide: true),
  ];

  List<Widget> _overlayWidgets() => <Widget>[
    ArcaneDialog(
      id: 'gallery-dialog',
      isOpen: _overlay == 'dialog',
      title: 'Edition proof',
      onClose: _close,
      child: _stack(<Widget>[
        const Text(
          'Check your title and paper before sending this sample to the press.',
        ),
        Text('$_name / $_paper'),
      ]),
      actions: <Widget>[
        Button.outline(label: 'Close proof', onPressed: _close),
        Button(
          label: 'Approve proof',
          onPressed: () {
            _close();
            _report('Proof approved.');
          },
        ),
      ],
    ),
    if (_overlay == 'confirm')
      ArcaneConfirmDialog(
        title: 'Archive this edition?',
        message: 'This is a reversible action inside the demo.',
        confirmText: 'Archive edition',
        onCancel: _close,
        onConfirm: () {
          _close();
          _report('Edition archived.');
        },
      ),
    if (_overlay == 'alert')
      ArcaneAlertDialog(
        title: 'The ink needs to dry',
        message: 'Leave the sample on the rack before stacking it.',
        buttonText: 'Understood',
        onDismiss: _close,
      ),
    ArcaneCommand(
      id: 'gallery-command',
      isOpen: _overlay == 'command',
      onClose: _close,
      groups: <CommandGroup>[
        CommandGroup(
          heading: 'Edition',
          items: <CommandItem>[
            CommandItem(
              label: 'Create a proof',
              icon: ArcaneIcon.plus(),
              onSelect: () {
                _close();
                _report('Proof created from the command menu.');
              },
            ),
            CommandItem(
              label: 'Save the edition',
              icon: ArcaneIcon.check(),
              onSelect: () {
                _close();
                _report('Edition saved from the command menu.');
              },
            ),
          ],
        ),
      ],
    ),
    ArcaneSheet(
      id: 'gallery-sheet',
      isOpen: _overlay == 'sheet',
      title: 'Paper stock',
      onClose: _close,
      child: _stack(<Widget>[
        const Text('Choose from the paper samples at the studio desk.'),
        Button(
          label: 'Keep recycled cream',
          onPressed: () {
            _close();
            _report('Recycled cream selected.');
          },
        ),
      ]),
    ),
    ArcaneDrawer(
      id: 'gallery-drawer',
      isOpen: _overlay == 'drawer',
      onClose: _close,
      header: const Text('Edition details'),
      child: _stack(<Widget>[
        Text(_name),
        const Text('Two-color print. Recycled cream stock. Autumn edition.'),
        Button(
          label: 'Save details',
          onPressed: () {
            _close();
            _report('Edition details saved.');
          },
        ),
      ]),
    ),
    ArcaneActionSheet(
      isOpen: _overlay == 'actions',
      title: 'Proof actions',
      onClose: _close,
      actions: <ActionSheetItem>[
        ActionSheetItem(
          label: 'Duplicate proof',
          onTap: () {
            _close();
            _report('Proof duplicated.');
          },
        ),
        ActionSheetItem(
          label: 'Archive proof',
          destructive: true,
          onTap: () {
            _close();
            _report('Proof archived.');
          },
        ),
      ],
    ),
  ];

  List<Widget> _feedback() => <Widget>[
    _fixture('alerts', 'Say it clearly', <Widget>[
      const ArcaneAlert.info(
        title: 'Proof ready',
        message: 'Your sample is waiting at the print desk.',
      ),
      const ArcaneAlert.success(
        title: 'Edition saved',
        message: 'All twelve prints are accounted for.',
      ),
      const ArcaneAlert.warning(
        title: 'Low paper stock',
        message: 'Choose a shorter run or another stock.',
      ),
      const ArcaneAlert.error(
        title: 'Print interrupted',
        message: 'The demo press needs another sheet.',
      ),
      _row(<Widget>[
        for (final StatusType status in StatusType.values)
          ArcaneStatusBadge(label: status.name, status: status),
      ]),
      ArcaneEmptyState(
        title: 'No archived prints',
        description: 'Archive a sample when you are finished with it.',
        action: Button.outline(
          label: 'Add a sample',
          onPressed: () => _report('A sample was added to the archive.'),
        ),
      ),
    ], wide: true),
    _fixture('progress', 'Watch the run', <Widget>[
      ArcaneProgressBar(value: _ink / 100),
      _row(<Widget>[
        ArcaneCircularProgress(value: _ink / 100),
        const ArcaneLoadingSpinner(),
        const ArcaneSpinner(),
      ]),
      ArcaneSlider(
        id: 'gallery-progress-control',
        value: _ink,
        label: 'Progress preview',
        valueSuffix: '%',
        onChanged: (double value) => setState(() => _ink = value),
      ),
      const FancyProgressBar(value: 0.6),
    ]),
    _fixture('skeletons', 'While the proof loads', <Widget>[
      const ArcaneSkeletonCard(lines: 2),
      const ArcaneSkeletonText(lines: 2),
      const ArcaneSkeleton(height: '40px'),
    ]),
    _fixture('avatars', 'At the print desk', <Widget>[
      _row(const <Widget>[
        ArcaneAvatar(initials: 'PC'),
        ArcaneAvatar.rounded(initials: 'RS'),
        ArcaneAvatar.square(initials: 'ZN'),
        ArcaneAvatar(imageUrl: '/prints/riso.svg', initials: 'RS'),
      ]),
      const ArcaneAvatarGroup(
        avatars: <ArcaneAvatar>[
          ArcaneAvatar(initials: 'PC'),
          ArcaneAvatar(initials: 'RS'),
          ArcaneAvatar(initials: 'ZN'),
        ],
      ),
      _note('Initials and artwork are fictional demo identities.'),
    ]),
    _fixture('tables', 'The edition ledger', <Widget>[
      DataTable<String>(
        items: const <String>['Riso study', 'Folded zine', 'Type poster'],
        selectable: true,
        selectedItems: _selectedRows,
        onSelectionChanged: (Set<String> values) => setState(() {
          _selectedRows = values;
          _status = '${values.length} ledger rows selected.';
        }),
        columns: <DataColumn<String>>[
          DataColumn<String>(
            header: 'Edition',
            builder: (String value) => Text(value),
          ),
          DataColumn<String>(
            header: 'Status',
            builder: (String value) => const ArcaneStatusBadge(label: 'Proof'),
          ),
        ],
      ),
      const StaticTable(
        headers: <String>['Ink', 'Sheets', 'Format'],
        rows: <List<Widget>>[
          <Widget>[Text('Blue'), Text('12'), Text('A4')],
          <Widget>[Text('Red'), Text('8'), Text('A5')],
        ],
      ),
      const KeyValueTable(
        rows: <KeyValueRow>[
          KeyValueRow(key: 'Stock', value: Text('Recycled cream')),
          KeyValueRow(key: 'Weight', value: Text('170 gsm')),
        ],
      ),
    ], wide: true),
    _fixture('charts', 'A sample print run', <Widget>[
      const ArcaneChart(
        title: 'Sheets per session',
        description: 'Illustrative studio data.',
        points: <ArcaneChartPoint>[
          ArcaneChartPoint(label: 'Mon', value: 8),
          ArcaneChartPoint(label: 'Tue', value: 12),
          ArcaneChartPoint(label: 'Wed', value: 6),
          ArcaneChartPoint(label: 'Thu', value: 18),
          ArcaneChartPoint(label: 'Fri', value: 14),
        ],
      ),
    ]),
    _fixture('counters', 'Count each sheet', <Widget>[
      ArcaneSlotCounter(
        fixedValue: _prints,
        autoStart: false,
        label: 'Current edition',
      ),
      ArcaneSlotCounterRow(
        counters: <SlotCounterProps>[
          SlotCounterProps(
            fixedValue: _prints,
            autoStart: false,
            label: 'Sample prints',
          ),
          const SlotCounterProps(
            fixedValue: 2,
            autoStart: false,
            label: 'Ink colors',
          ),
        ],
      ),
      const ArcaneSlotCounterCard(
        showBorder: true,
        counter: SlotCounterProps(
          fixedValue: 24,
          autoStart: false,
          label: 'Sheets on the rack',
        ),
      ),
      Button.outline(
        label: 'Print one more',
        onPressed: () => setState(() => _prints++),
      ),
    ]),
  ];

  List<Widget> _cards() => <Widget>[
    _fixture('cards', 'A good frame', <Widget>[
      dom.div(classes: 'cg-card-grid', <Widget>[
        const Card(
          child: Text('A raised card for a proof that needs attention.'),
        ),
        const Card.outlined(
          child: Text('An outlined card for supporting notes.'),
        ),
        ArcaneStructuredCard(
          header: const Text('Edition 01'),
          body: const Text('Two inks on recycled cream.'),
          footer: Button.outline(
            label: 'Review edition',
            onPressed: () => _report('Edition 01 selected.'),
          ),
        ),
        FeatureCard(
          title: 'Risograph printing',
          description: 'Layer two spot colors to create a third.',
          icon: ArcaneIcon.layers(),
          showCta: true,
          ctaText: 'Choose riso',
          onTap: () => _report('Risograph selected.'),
        ),
        IconCard(
          title: 'Studio schedule',
          subtitle: 'Choose your session',
          icon: ArcaneIcon.calendar(),
          onTap: () => _report('Studio schedule selected.'),
        ),
        CtaCard(
          title: 'Make a proof',
          description: 'Try the colors before the full run.',
          ctaText: 'Create sample',
          height: '260px',
          onTap: () => _report('A sample proof was created.'),
        ),
      ]),
    ], wide: true),
    _fixture('statistics', 'The sample run', <Widget>[
      StatCardRow(
        columns: 2,
        cards: <StatCard>[
          StatCard(
            label: 'Sample prints',
            value: '$_prints',
            description: 'Illustrative count',
          ),
          const StatCard(
            label: 'Ink colors',
            value: '2',
            description: 'Blue and red',
          ),
        ],
      ),
    ]),
    _fixture('quotes', 'A quote, clearly labeled', <Widget>[
      const TestimonialCard(
        quote: 'Try another color. Keep the happy accidents.',
        authorName: 'Example studio note',
        authorTitle: 'Fictional quotation for component review',
        rating: 4,
      ),
      RatingStars(
        rating: _rating,
        interactive: true,
        onRatingChanged: (int value) =>
            setState(() => _rating = value.toDouble()),
      ),
      _note('Sample rating: ${_rating.toStringAsFixed(0)} of 5.'),
    ]),
    _fixture('pricing', 'Two sample workshop plans', <Widget>[
      const PricingCard.compact(
        title: 'Single proof',
        subtitle: 'Illustrative pricing',
        price: r'$8',
        period: '/sample',
        features: <String>['One proof sheet', 'Two ink colors'],
        buttonText: 'View sample',
        buttonLink: '#fixture-gallery',
      ),
      PricingGrid(
        columns: 2,
        tiers: const <PricingTier>[
          PricingTier(
            name: 'Print session',
            price: 24,
            period: 'session',
            description: 'Fictional demo plan',
            features: <String>['Twelve sheets', 'Shared press'],
            ctaText: 'Choose session',
          ),
          PricingTier(
            name: 'Zine session',
            price: 18,
            period: 'session',
            description: 'Fictional demo plan',
            features: <String>['Eight sheets', 'Folding tools'],
            ctaText: 'Choose zine',
          ),
        ],
        onTierSelected: (PricingTier tier) =>
            _report('${tier.name} selected. No purchase is made.'),
      ),
    ], wide: true),
    _fixture('gallery', 'Fresh from the press', <Widget>[
      ArcaneGallery(
        id: 'gallery-artwork',
        ariaLabel: 'Sample Print Club artwork',
        minColumnWidth: 160,
        layout: ArcaneGalleryLayout.grid,
        tiles: <ArcaneGalleryTile>[
          for (final String print in <String>['riso', 'zine', 'poster'])
            ArcaneGalleryTile(
              title: '$print print',
              media: ArcaneGalleryMedia(
                aspectRatio: 1.25,
                src: '/prints/$print${_comic ? '-comic' : ''}.svg',
                alt: '$print sample print artwork',
              ),
              onTap: () => _report('$print artwork selected.'),
            ),
        ],
      ),
    ], wide: true),
    _fixture('flexi-cards', 'Space for a little detail', <Widget>[
      ArcaneFlexiCards(minCardWidth: '160px', items: _flexiItems),
      ArcaneFlexiCardsSimple(items: _flexiItems),
    ], wide: true),
  ];

  List<FlexiCardItem> get _flexiItems => <FlexiCardItem>[
    FlexiCardItem(
      icon: ArcaneIcon.layers(),
      shortText: 'Layer',
      longText: 'Build color one pass at a time.',
      onTap: () => _report('Layer technique selected.'),
    ),
    FlexiCardItem(
      icon: ArcaneIcon.bookOpen(),
      shortText: 'Fold',
      longText: 'Turn one sheet into a small story.',
      onTap: () => _report('Fold technique selected.'),
    ),
  ];

  List<Widget> _layout() => <Widget>[
    _fixture('lists', 'Everything on the desk', <Widget>[
      ArcaneItem(
        href: _url(group: 'cards'),
        child: const Text('Browse the printed samples'),
      ),
      const ArcaneCheckItem(text: 'Paper cut to size'),
      const ArcaneCheckList(
        items: <String>[
          'Ink mixed',
          'Registration checked',
          'Drying rack cleared',
        ],
      ),
      const ArcaneFeatureRow(feature: 'Two-color printing'),
      const ArcaneFeatureRow(feature: 'Foil finishing', included: false),
      const ArcaneSpecRow(label: 'Paper weight', value: '170 gsm'),
    ]),
    _fixture('layout', 'Room to work', <Widget>[
      const Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(children: <Widget>[Text('Edition'), Spacer(), Text('01')]),
            ArcaneGap(12),
            Row(
              children: <Widget>[
                Expanded(child: Text('Flexible notes')),
                SizedBox(width: 64, child: Text('A4')),
              ],
            ),
            Gutter.small(),
            Center(child: Text('Centered registration mark')),
            ArcaneSeparator(),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                ArcaneStatusBadge(label: 'Paper'),
                ArcaneStatusBadge(label: 'Ink'),
                ArcaneStatusBadge(label: 'Press'),
              ],
            ),
            ArcaneDirection(
              children: <Widget>[Text('Reading order follows the document.')],
            ),
            ArcaneAspectRatio(
              ratio: 2,
              child: Card.flat(child: Center(child: Text('2:1 proof area'))),
            ),
          ],
        ),
      ),
    ]),
    _fixture('toolbars', 'Tools within reach', <Widget>[
      ArcaneToolbar(
        children: <Widget>[
          Button.outline(
            label: 'Undo',
            onPressed: () => _report('Last sample action undone.'),
          ),
          Button.outline(
            label: 'Redo',
            onPressed: () => _report('Sample action restored.'),
          ),
        ],
      ),
      ButtonGroup(
        children: <Widget>[
          Button.outline(
            label: 'Front',
            onPressed: () => _report('Front side selected.'),
          ),
          Button.outline(
            label: 'Back',
            onPressed: () => _report('Back side selected.'),
          ),
        ],
      ),
      ButtonPanel(
        children: <Widget>[
          Button.ghost(
            label: 'Cancel',
            onPressed: () => _report('Print cancelled.'),
          ),
          Button(
            label: 'Print proof',
            onPressed: () => _report('Proof sent to the demo press.'),
          ),
        ],
      ),
    ]),
    _fixture('scrolling', 'A longer edition', <Widget>[
      ArcaneScrollArea(
        height: '150px',
        child: _stack(<Widget>[
          for (int sheet = 1; sheet <= 12; sheet++)
            Text('Sheet $sheet / numbered and ready'),
        ]),
      ),
      ArcaneVirtualScroll<String>(
        items: List<String>.generate(
          50,
          (int index) => 'Archive sheet ${index + 1}',
        ),
        itemHeight: 36,
        height: '144px',
        itemBuilder: (BuildContext context, String item, int index) =>
            Text(item),
      ),
      const dom.div(classes: 'cg-rail-preview', <Widget>[
        ArcaneScrollRailLayout(
          railWidth: '120px',
          rail: Text('Edition index'),
          child: Text(
            'The proof workspace remains beside the scrollable rail.',
          ),
        ),
        ArcaneScrollRail(
          width: '100%',
          showBorder: false,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: <Widget>[
                Text('A separate scroll rail'),
                Text('Paper'),
                Text('Ink'),
                Text('Press'),
              ],
            ),
          ],
        ),
      ]),
    ]),
    _fixture('resizable', 'Make space for the proof', <Widget>[
      const dom.div(classes: 'cg-resizable-preview', <Widget>[
        ArcaneResizable(
          panels: <ResizablePanelData>[
            ResizablePanelData(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text('Notes / drag the divider'),
              ),
            ),
            ResizablePanelData(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Text('Artwork preview'),
              ),
            ),
          ],
        ),
      ]),
    ]),
    _fixture('announcements', 'News from the press', <Widget>[
      if (_showTopAnnouncement)
        ArcaneTopAnnouncementBar(
          message: 'The autumn print samples are ready.',
          ctaText: 'View samples',
          ctaHref: _url(group: 'cards'),
          onDismiss: () => setState(() => _showTopAnnouncement = false),
        ),
      if (_showInlineAnnouncement)
        ArcaneInlineHeroBanner(
          message: 'Try a second color on your next proof.',
          ctaText: 'Choose ink',
          ctaHref: _url(group: 'inputs'),
          onDismiss: () => setState(() => _showInlineAnnouncement = false),
        ),
      Button.outline(
        label: 'Restore announcements',
        onPressed: () => setState(() {
          _showTopAnnouncement = true;
          _showInlineAnnouncement = true;
        }),
      ),
    ], wide: true),
  ];
}
