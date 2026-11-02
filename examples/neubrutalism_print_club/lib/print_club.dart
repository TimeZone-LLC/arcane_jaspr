import 'package:arcane_jaspr/arcane_jaspr.dart';
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:jaspr/dom.dart' as dom;
import 'package:neubrutalism_print_club/workshops.dart';
import 'package:web/web.dart' as web;

class PrintClub extends StatefulWidget {
  const PrintClub({super.key});

  @override
  State<PrintClub> createState() => _PrintClubState();
}

class _PrintClubState extends State<PrintClub> {
  bool _dark = false;
  bool _rounded = false;
  NeubrutalismVariant _variant = NeubrutalismVariant.classic;
  int _category = 0;
  String _query = '';
  String _workshopId = 'riso';
  String _name = '';
  String _company = 'solo';
  bool _apron = true;
  bool _dialogOpen = false;
  bool _nameError = false;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _dark = Uri.base.queryParameters['theme'] == 'dark';
    _rounded = Uri.base.queryParameters['corners'] == 'rounded';
    _variant = Uri.base.queryParameters['variant'] == 'neucomic'
        ? NeubrutalismVariant.neuComic
        : NeubrutalismVariant.classic;
    web.document.documentElement!.setAttribute(
      'class',
      _dark ? 'dark' : 'light',
    );
  }

  Workshop get _workshop =>
      workshops.firstWhere((Workshop workshop) => workshop.id == _workshopId);

  bool get _comic => _variant == NeubrutalismVariant.neuComic;

  String _artworkSource(String name) {
    const String revision = String.fromEnvironment(
      'PRINT_ARTWORK_REVISION',
      defaultValue: 'local',
    );
    final String suffix = _comic ? '-comic' : '';
    return '/prints/$name$suffix.svg?v=$revision';
  }

  void _scrollTo(String id) =>
      web.document.getElementById(id)?.scrollIntoView();

  void _setDark(bool value) {
    web.document.documentElement!.setAttribute(
      'class',
      value ? 'dark' : 'light',
    );
    setState(() => _dark = value);
    _updateAppearanceUrl();
  }

  void _setVariant(String value) {
    setState(() {
      _variant = value == 'neucomic'
          ? NeubrutalismVariant.neuComic
          : NeubrutalismVariant.classic;
    });
    _updateAppearanceUrl();
  }

  void _setCorners(String value) {
    setState(() => _rounded = value == 'rounded');
    _updateAppearanceUrl();
  }

  void _updateAppearanceUrl() {
    final Uri current = Uri.parse(web.window.location.href);
    final Map<String, List<String>> parameters = <String, List<String>>{
      ...current.queryParametersAll,
      'theme': <String>[_dark ? 'dark' : 'light'],
      'variant': <String>[_comic ? 'neucomic' : 'classic'],
      'corners': <String>[_rounded ? 'rounded' : 'square'],
    };
    web.window.history.replaceState(
      null,
      '',
      current.replace(queryParameters: parameters).toString(),
    );
  }

  void _reviewPlan() {
    setState(() => _nameError = _name.trim().isEmpty);
    if (_nameError) {
      (web.document.getElementById('visitor-name') as web.HTMLInputElement?)
          ?.focus();
      return;
    }
    setState(() => _dialogOpen = true);
  }

  void _savePlan() {
    setState(() {
      _dialogOpen = false;
      _saved = true;
    });
    toast.success('Your workshop is on the plan. Bring your curiosity.');
  }

  @override
  Widget build(BuildContext context) => ArcaneApp(
    stylesheet: NeubrutalismStylesheet(variant: _variant, rounded: _rounded),
    brightness: _dark ? Brightness.dark : Brightness.light,
    title: 'Print Club — Make a little mess.',
    home: dom.div(classes: 'print-club', <Widget>[
      const dom.a(href: '#main', classes: 'pc-skip', <Widget>[
        Text('Skip to content'),
      ]),
      _header(),
      dom.main_(id: 'main', <Widget>[
        _hero(),
        dom.div(classes: 'pc-edition-band', <Widget>[
          dom.span(<Widget>[
            Text(
              _comic
                  ? 'PULL A PRINT. START A STORY.'
                  : 'INK ON YOUR HANDS. IDEAS ON PAPER.',
            ),
          ]),
          dom.span(classes: 'pc-mono', <Widget>[
            Text(_comic ? 'THE COMIC ISSUE / 2026' : 'AUTUMN EDITION / 2026'),
          ]),
        ]),
        _catalog(),
        _studio(),
        _plan(),
      ]),
      dom.footer(classes: 'pc-footer pc-shell', <Widget>[
        const dom.a(href: '#', classes: 'pc-brand', <Widget>[
          Text('PRINT CLUB'),
        ]),
        const dom.p(<Widget>[
          Text(
            'A fictional studio. A working theme study. Built with Arcane Jaspr.',
          ),
        ]),
        dom.a(
          href: Uri(
            path: '/',
            queryParameters: <String, String>{
              'view': 'components',
              'variant': _comic ? 'neucomic' : 'classic',
              'theme': _dark ? 'dark' : 'light',
              'corners': _rounded ? 'rounded' : 'square',
            },
          ).toString(),
          const <Widget>[Text('Component workshop')],
        ),
        const dom.a(
          href: 'https://neubrutalism.com/',
          target: dom.Target.blank,
          attributes: <String, String>{'rel': 'noopener noreferrer'},
          <Widget>[Text('Design reference')],
        ),
      ]),
      _confirmation(),
      ArcaneToast.container(),
    ]),
  );

  Widget _header() => dom.header(classes: 'pc-header', <Widget>[
    const dom.div(classes: 'pc-topline pc-shell pc-mono', <Widget>[
      dom.span(<Widget>[Text('GOOD PAPER. GOOD COMPANY.')]),
      dom.span(<Widget>[Text('A FICTIONAL STUDIO / LIVE DEMO')]),
    ]),
    dom.div(classes: 'pc-navigation pc-shell', <Widget>[
      const dom.a(
        href: '#',
        classes: 'pc-brand',
        attributes: <String, String>{'aria-label': 'Print Club home'},
        <Widget>[
          dom.span(
            classes: 'pc-brand-symbol',
            attributes: <String, String>{'aria-hidden': 'true'},
            <Widget>[Text('P')],
          ),
          Text('PRINT CLUB'),
        ],
      ),
      dom.nav(
        attributes: const <String, String>{'aria-label': 'Main navigation'},
        <Widget>[
          const dom.a(href: '#workshops', <Widget>[Text('Workshops')]),
          const dom.a(href: '#studio', <Widget>[Text('The studio')]),
          dom.a(href: '#plan', <Widget>[
            Text(_saved ? 'Your plan (1)' : 'Your plan'),
          ]),
        ],
      ),
      dom.div(classes: 'pc-appearance', <Widget>[
        dom.div(classes: 'pc-variant-control', <Widget>[
          ArcaneSelect(
            id: 'visual-style',
            label: 'Visual style',
            value: _comic ? 'neucomic' : 'classic',
            options: const <ArcaneSelectOption>[
              ArcaneSelectOption(value: 'classic', label: 'Classic'),
              ArcaneSelectOption(value: 'neucomic', label: 'NeuComic'),
            ],
            onChanged: _setVariant,
            fullWidth: true,
          ),
        ]),
        dom.div(classes: 'pc-corners-control', <Widget>[
          ArcaneSelect(
            id: 'visual-corners',
            label: 'Corners',
            value: _rounded ? 'rounded' : 'square',
            options: const <ArcaneSelectOption>[
              ArcaneSelectOption(value: 'square', label: 'Square'),
              ArcaneSelectOption(value: 'rounded', label: 'Rounded'),
            ],
            onChanged: _setCorners,
            fullWidth: true,
          ),
        ]),
        ArcaneToggleSwitch(
          id: 'dark-mode',
          value: _dark,
          label: 'Dark mode',
          onChanged: _setDark,
        ),
      ]),
    ]),
  ]);

  Widget _hero() => dom.section(classes: 'pc-hero pc-shell', <Widget>[
    dom.div(classes: 'pc-hero-copy', <Widget>[
      dom.p(classes: 'pc-eyebrow', <Widget>[
        Text(
          _comic ? 'THE PRINT CLUB COMIC ISSUE' : 'A CLUB FOR MAKING THINGS',
        ),
      ]),
      const dom.h1(classes: 'neubrutalism-display', <Widget>[
        Text('Make a'),
        dom.br(),
        Text('little '),
        dom.span(classes: 'pc-highlight', <Widget>[Text('mess.')]),
      ]),
      const dom.p(classes: 'pc-intro', <Widget>[
        Text(
          'Step away from the screen. Pick up some ink. Make something you can actually hold.',
        ),
      ]),
      dom.div(classes: 'pc-actions', <Widget>[
        Button(
          label: 'Find your workshop',
          onPressed: () => _scrollTo('workshops'),
        ),
        Button.outline(
          label: 'Meet the studio',
          onPressed: () => _scrollTo('studio'),
        ),
      ]),
      const dom.p(classes: 'pc-hero-note pc-mono', <Widget>[
        Text('NO EXPERIENCE NEEDED. ALL MATERIALS INCLUDED.'),
      ]),
    ]),
    dom.figure(classes: 'pc-feature-art', <Widget>[
      dom.img(
        src: _artworkSource('hero'),
        alt: _comic
            ? 'Three inked comic panels: a roller lays down ink, a hand pulls a screenprint, and a fresh print shouts FRESH INK.'
            : 'A bold yellow and coral print reading INK, PAPER, PLAY, with overlapping geometric forms.',
      ),
      dom.figcaption(<Widget>[
        dom.span(classes: 'pc-mono', <Widget>[
          Text(_comic ? 'PRINT CLUB / COMIC 001' : 'PRINT CLUB / EDITION 001'),
        ]),
        dom.span(<Widget>[
          Text(
            _comic
                ? 'Every print has a story.'
                : 'A little off-register. Just right.',
          ),
        ]),
      ]),
    ]),
  ]);

  Widget _catalog() {
    final List<Workshop> visible = workshops.where((Workshop workshop) {
      final bool categoryMatch =
          _category == 0 ||
          (_category == 1 && workshop.category != 'Zines') ||
          (_category == 2 && workshop.category == 'Zines');
      return categoryMatch &&
          '${workshop.title} ${workshop.category}'.toLowerCase().contains(
            _query.toLowerCase().trim(),
          );
    }).toList();
    return dom.section(id: 'workshops', classes: 'pc-catalog pc-shell', <
      Widget
    >[
      const dom.div(classes: 'pc-section-heading', <Widget>[
        dom.div(<Widget>[
          dom.p(classes: 'pc-eyebrow', <Widget>[
            Text('01 / GET YOUR HANDS INTO IT'),
          ]),
          dom.h2(<Widget>[Text('Your next good Saturday.')]),
        ]),
        dom.p(<Widget>[
          Text('Small groups. Real tools. Something to take home.'),
        ]),
      ]),
      dom.div(classes: 'pc-catalog-tools', <Widget>[
        ArcaneTabBar(
          tabs: const <ArcaneTabBarItem>[
            ArcaneTabBarItem(label: 'All workshops'),
            ArcaneTabBarItem(label: 'Printmaking'),
            ArcaneTabBarItem(label: 'Zines'),
          ],
          selectedIndex: _category,
          onChanged: (int value) => setState(() => _category = value),
        ),
        dom.div(classes: 'pc-search', <Widget>[
          TextInput(
            id: 'workshop-search',
            placeholder: 'Find a workshop…',
            value: _query,
            attributes: const <String, String>{'aria-label': 'Find a workshop'},
            onChanged: (String value) => setState(() => _query = value),
            fullWidth: true,
          ),
        ]),
      ]),
      if (visible.isEmpty)
        Card.flat(
          classes: 'pc-empty',
          children: <Widget>[
            const dom.h3(<Widget>[Text('No ink here just yet.')]),
            const dom.p(<Widget>[
              Text(
                'Nothing matches that search. Try another word or see the whole lineup.',
              ),
            ]),
            Button.outline(
              label: 'Show all workshops',
              onPressed: () => setState(() {
                _query = '';
                _category = 0;
              }),
            ),
          ],
        )
      else
        dom.div(classes: 'pc-workshops', <Widget>[
          for (final Workshop workshop in visible) _workshopCard(workshop),
        ]),
    ]);
  }

  Widget _workshopCard(Workshop workshop) => Card(
    classes: 'pc-workshop',
    padding: EdgeInsets.zero,
    children: <Widget>[
      dom.div(classes: 'pc-workshop-art', <Widget>[
        dom.img(
          src: _artworkSource(workshop.artwork),
          alt: _comic
              ? '${workshop.category} comic print with inked outlines and halftone shading'
              : '${workshop.category} sample artwork',
        ),
        dom.span(classes: 'pc-category-label pc-mono', <Widget>[
          Text(workshop.category),
        ]),
      ]),
      dom.div(classes: 'pc-workshop-body', <Widget>[
        dom.p(classes: 'pc-workshop-date pc-mono', <Widget>[
          Text('${workshop.date} / ${workshop.time}'),
        ]),
        dom.h3(<Widget>[Text(workshop.title)]),
        dom.p(classes: 'pc-workshop-description', <Widget>[
          Text(workshop.description),
        ]),
        dom.div(classes: 'pc-workshop-footer', <Widget>[
          dom.span(classes: 'pc-price', <Widget>[
            Text('\$${workshop.price}'),
            const dom.small(<Widget>[Text(' / person')]),
          ]),
          Button.outline(
            label: 'Pick workshop',
            onPressed: () {
              setState(() {
                _workshopId = workshop.id;
                _saved = false;
              });
              _scrollTo('plan');
            },
          ),
        ]),
      ]),
    ],
  );

  Widget _studio() => dom.section(id: 'studio', classes: 'pc-studio', <Widget>[
    dom.div(classes: 'pc-shell pc-studio-grid', <Widget>[
      const dom.div(<Widget>[
        dom.p(classes: 'pc-eyebrow', <Widget>[Text('02 / THIS IS THE PLACE')]),
        dom.h2(<Widget>[
          Text('Less scrolling.'),
          dom.br(),
          Text('More making.'),
        ]),
        dom.p(classes: 'pc-studio-copy', <Widget>[
          Text(
            'A shared table, a stack of paper, and room to try something new. We like happy accidents, ink-stained aprons, and the first print as much as the fiftieth.',
          ),
        ]),
        ArcaneStatusBadge.success('Beginners belong here'),
      ]),
      dom.div(classes: 'pc-studio-notes', <Widget>[
        _studioNote(
          '01',
          'Come as you are.',
          'No portfolio. No fancy kit. Just an idea, or the curiosity to find one.',
        ),
        _studioNote(
          '02',
          'We bring the good stuff.',
          'Paper, ink, tools, and an apron are included in every session.',
        ),
        _studioNote(
          '03',
          'Leave with something yours.',
          'Your prints go home with you. So do the skills to keep making.',
        ),
      ]),
    ]),
  ]);

  Widget _studioNote(String number, String heading, String description) =>
      dom.div(classes: 'pc-studio-note', <Widget>[
        dom.span(classes: 'pc-note-number pc-mono', <Widget>[Text(number)]),
        dom.div(<Widget>[
          dom.h3(<Widget>[Text(heading)]),
          dom.p(<Widget>[Text(description)]),
        ]),
      ]);

  Widget
  _plan() => dom.section(id: 'plan', classes: 'pc-plan pc-shell', <Widget>[
    dom.div(classes: 'pc-plan-intro', <Widget>[
      const dom.p(classes: 'pc-eyebrow', <Widget>[
        Text('03 / PUT IT ON PAPER'),
      ]),
      const dom.h2(<Widget>[Text('Make room'), dom.br(), Text('for making.')]),
      const dom.p(<Widget>[
        Text(
          'Pick a workshop. Bring a friend, or find one at the table. Your next good idea starts here.',
        ),
      ]),
      Card.flat(
        classes: 'pc-plan-summary',
        children: <Widget>[
          if (_saved)
            const ArcaneStatusBadge.success('On your plan')
          else
            const ArcaneStatusBadge(
              label: 'Your pick',
              variant: BadgeVariant.primary,
            ),
          dom.h3(<Widget>[Text(_workshop.category)]),
          dom.p(classes: 'pc-mono', <Widget>[
            Text('${_workshop.date} / ${_workshop.time}'),
          ]),
          dom.div(classes: 'pc-total', <Widget>[
            dom.span(<Widget>[
              Text(_company == 'friend' ? '2 people' : '1 person'),
            ]),
            dom.strong(<Widget>[
              Text('\$${_workshop.price * (_company == 'friend' ? 2 : 1)}'),
            ]),
          ]),
          const dom.p(classes: 'pc-small', <Widget>[
            Text(
              'Example prices. This demo does not take payments or reserve real places.',
            ),
          ]),
        ],
      ),
    ]),
    Card(
      classes: 'pc-booking',
      children: <Widget>[
        const dom.h3(<Widget>[Text('Your workshop plan')]),
        const dom.p(classes: 'pc-booking-lead', <Widget>[
          Text('A little commitment to doing something different.'),
        ]),
        dom.div(classes: 'pc-form-fields', <Widget>[
          TextInput(
            id: 'visitor-name',
            label: 'What should we call you?',
            placeholder: 'Your name',
            value: _name,
            error: _nameError
                ? 'Add your name before reviewing the plan.'
                : null,
            onChanged: (String value) => setState(() {
              _name = value;
              _saved = false;
              if (value.trim().isNotEmpty) _nameError = false;
            }),
            fullWidth: true,
          ),
          ArcaneSelect(
            id: 'workshop-choice',
            label: 'Choose your workshop',
            value: _workshopId,
            options: <ArcaneSelectOption>[
              for (final Workshop workshop in workshops)
                ArcaneSelectOption(
                  value: workshop.id,
                  label: '${workshop.category} / ${workshop.date}',
                ),
            ],
            onChanged: (String value) => setState(() {
              _workshopId = value;
              _saved = false;
            }),
            fullWidth: true,
          ),
          ArcaneRadioGroup<String>(
            id: 'company',
            name: 'company',
            label: 'Who is coming?',
            value: _company,
            variant: RadioGroupVariant.cards,
            layout: RadioGroupLayout.grid,
            gridColumns: 2,
            options: const <RadioOption<String>>[
              RadioOption<String>(
                value: 'solo',
                label: 'Just me',
                description: 'One seat at the table',
              ),
              RadioOption<String>(
                value: 'friend',
                label: 'Me + a friend',
                description: 'Make something together',
              ),
            ],
            onChanged: (String value) => setState(() {
              _company = value;
              _saved = false;
            }),
          ),
          ArcaneCheckbox(
            id: 'borrow-apron',
            checked: _apron,
            label: 'Save me an apron',
            description: 'Ink has a way of getting everywhere.',
            onChanged: (bool value) => setState(() {
              _apron = value;
              _saved = false;
            }),
          ),
          Button(
            label: 'Review my plan',
            fullWidth: true,
            onPressed: _reviewPlan,
          ),
        ]),
        const dom.p(classes: 'pc-small pc-booking-footnote', <Widget>[
          Text('Try it out. Your plan stays in this page for this visit.'),
        ]),
      ],
    ),
  ]);

  Widget _confirmation() => ArcaneDialog(
    id: 'plan-confirmation',
    isOpen: _dialogOpen,
    title: 'A good plan, ${_name.trim()}.',
    maxWidth: 540,
    onClose: () => setState(() => _dialogOpen = false),
    children: <Widget>[
      const dom.p(<Widget>[
        Text(
          'Here is what you have lined up. Nothing is charged or reserved in this demo.',
        ),
      ]),
      dom.dl(classes: 'pc-confirmation-list', <Widget>[
        const dom.dt(<Widget>[Text('Workshop')]),
        dom.dd(<Widget>[Text(_workshop.category)]),
        const dom.dt(<Widget>[Text('When')]),
        dom.dd(<Widget>[Text('${_workshop.date}, ${_workshop.time}')]),
        const dom.dt(<Widget>[Text('At the table')]),
        dom.dd(<Widget>[
          Text(_company == 'friend' ? 'You + a friend' : 'Just you'),
        ]),
        const dom.dt(<Widget>[Text('Apron')]),
        dom.dd(<Widget>[
          Text(_apron ? 'One ready for you' : 'Bringing your own'),
        ]),
      ]),
    ],
    actions: <Widget>[
      Button.ghost(
        label: 'Keep editing',
        onPressed: () => setState(() => _dialogOpen = false),
      ),
      Button(label: 'Add to my plan', onPressed: _savePlan),
    ],
  );
}
