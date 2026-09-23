// Shared component instantiation surface for the render test suites.
//
// Every exported widget is constructed here with a minimal valid instance so
// that both the breadth smoke suite (render_components_test.dart) and the golden
// snapshot suite (golden_render_test.dart) render the exact same component set.
// Keeping a single source of truth guarantees the two suites never drift apart.

import 'package:arcane_jaspr/arcane_jaspr.dart';

Widget get _child => const Text('content');
List<Widget> get _children => const <Widget>[Text('a'), Text('b')];
ArcaneGlyph get _icon => ArcaneIcon.house();
List<ArcaneMenuItem> get _menuItems => const <ArcaneMenuItem>[
  MenuItemAction(label: 'Item'),
  MenuItemSeparator(),
];

/// A minimal concrete field provider for exercising the form node widgets.
ArcaneFieldProvider<T> _provider<T>(T value) => ArcaneFieldDirectProvider<T>(
  defaultValue: value,
  getter: (String _) async => value,
  setter: (String _, T _) async {},
);

/// Builds the full list of (name, widget) cases lazily so a construction error
/// in one entry does not prevent the others from loading.
List<(String, Widget)> componentCases() => <(String, Widget)>[
  // ---- Typography ------------------------------------------------------
  ('Text', const Text('hello')),
  ('RichText', const RichText(children: <Widget>[TextSpan('span')])),
  ('TextSpan', const TextSpan('span')),

  // ---- Layout ----------------------------------------------------------
  ('Wrap', Wrap(spacing: 8, runSpacing: 8, children: _children)),
  ('Row', Row(children: _children)),
  (
    'Column',
    Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: _children),
  ),
  ('Spacer', const Spacer()),
  ('Center', Center(child: _child)),
  ('Expanded', Expanded(child: _child)),
  ('Padding', Padding(padding: const EdgeInsets.all(8), child: _child)),
  ('SizedBox', SizedBox(child: _child)),
  ('Container', Container(child: _child)),
  ('Gutter', const Gutter()),
  ('ArcaneGap', const ArcaneGap(8)),
  ('ArcaneBox', ArcaneBox(child: _child)),
  ('Stack', Stack(children: _children)),
  ('Positioned', Positioned(child: _child)),
  ('ArcaneDirection', ArcaneDirection(children: _children)),
  ('ButtonPanel', ButtonPanel(children: _children)),
  ('ArcaneToolbar', ArcaneToolbar(children: _children)),
  ('ButtonGroup', ButtonGroup(children: _children)),
  ('Carpet', Carpet(children: _children)),
  ('FancyProgressBar', const FancyProgressBar(value: 0.5)),
  ('FormHeader', const FormHeader()),
  (
    'RadioCards',
    RadioCards<String>(
      values: const <String>['a', 'b'],
      labelBuilder: (String v) => v,
    ),
  ),
  ('Section', const Section()),
  (
    'ArcaneTabs',
    const ArcaneTabs(
      tabs: <ArcaneTabItem>[ArcaneTabItem(label: 'One', content: Text('one'))],
    ),
  ),
  (
    'ArcaneTabBar',
    ArcaneTabBar(
      tabs: const <ArcaneTabBarItem>[ArcaneTabBarItem(label: 'One')],
      selectedIndex: 0,
      onChanged: (int _) {},
    ),
  ),
  ('ArcaneSheet', ArcaneSheet(isOpen: false, child: _child)),
  (
    'ArcaneActionSheet',
    const ArcaneActionSheet(
      isOpen: false,
      actions: <ActionSheetItem>[ActionSheetItem(label: 'Do')],
    ),
  ),
  ('ArcaneDrawer', ArcaneDrawer(isOpen: false, child: _child)),
  ('ArcaneScrollArea', ArcaneScrollArea(child: _child)),
  ('ArcaneScrollRail', ArcaneScrollRail(children: _children)),
  (
    'ArcaneScrollRailLayout',
    ArcaneScrollRailLayout(rail: _child, child: _child),
  ),
  ('ArcaneAspectRatio', ArcaneAspectRatio(ratio: 1.5, child: _child)),
  (
    'ArcaneResizable',
    ArcaneResizable(
      panels: <ResizablePanelData>[ResizablePanelData(child: _child)],
    ),
  ),
  ('ArcaneScaffold', ArcaneScaffold(body: _child)),

  // ---- Input -----------------------------------------------------------
  (
    'Button',
    Button(
      label: 'Press',
      icon: ArcaneIcon.arrowRight(size: IconSize.sm),
      iconPosition: ButtonIconPosition.trailing,
    ),
  ),
  ('FabSocket', FabSocket(child: _child)),
  ('Fab', Fab(icon: _icon)),
  ('IconButton', IconButton(icon: _icon)),
  ('MutableText', const MutableText('editable')),
  ('PopupMenu', PopupMenu(child: _child, items: _menuItems)),
  ('IconButtonMenu', IconButtonMenu(icon: Icons.calendar, items: _menuItems)),
  ('TextButtonMenu', TextButtonMenu(child: _child, items: _menuItems)),
  ('OutlineButtonMenu', OutlineButtonMenu(label: 'Open', items: _menuItems)),
  ('Search', const Search()),
  (
    'Selector',
    Selector<String>(
      id: 'selector-1',
      values: const <String>['a', 'b'],
      labelBuilder: (String v) => v,
    ),
  ),
  ('TextInput', const TextInput()),
  ('TextArea', const TextArea()),
  (
    'ArcaneSelect',
    const ArcaneSelect(
      options: <ArcaneSelectOption>[ArcaneSelectOption(value: 'a', label: 'A')],
    ),
  ),
  ('ArcaneCheckbox', const ArcaneCheckbox(checked: false)),
  ('ArcaneRadio', const ArcaneRadio(selected: false)),
  (
    'ArcaneCombobox',
    const ArcaneCombobox<String>(
      id: 'combobox-1',
      options: <ComboboxOption<String>>[
        ComboboxOption<String>(value: 'a', label: 'A'),
      ],
    ),
  ),
  (
    'ArcaneDatePicker',
    ArcaneDatePicker(id: 'date-picker-1', value: DateTime(2020, 1, 15)),
  ),
  (
    'ArcaneRadioGroup',
    const ArcaneRadioGroup<String>(
      id: 'radio-group-1',
      name: 'radio-group-1',
      options: <RadioOption<String>>[
        RadioOption<String>(value: 'a', label: 'A'),
      ],
    ),
  ),
  ('ArcaneSlider', const ArcaneSlider(id: 'slider-1', value: 0.5)),
  ('ArcaneRangeSlider', const ArcaneRangeSlider(minValue: 10, maxValue: 80)),
  ('ArcaneToggleSwitch', const ArcaneToggleSwitch(value: false)),
  (
    'ArcaneToggleButtonGroup',
    const ArcaneToggleButtonGroup(
      options: <String>['a', 'b'],
      selectedIndex: 0,
    ),
  ),
  (
    'ArcaneToggleGroup',
    const ArcaneToggleGroup(
      id: 'toggle-group-1',
      items: <ToggleGroupItem>[ToggleGroupItem(value: 'a', child: Text('A'))],
    ),
  ),
  ('ArcaneOtpInput', const ArcaneOtpInput()),
  (
    'ArcaneCalendar',
    ArcaneCalendar(id: 'calendar-1', month: DateTime(2020, 1, 15)),
  ),
  (
    'ArcaneToggleButton',
    const ArcaneToggleButton(id: 'toggle-button-1', value: false),
  ),
  (
    'ArcaneCycleButton',
    const ArcaneCycleButton<String>(
      id: 'cycle-button-1',
      options: <CycleOption<String>>[CycleOption<String>(value: 'a')],
      value: 'a',
    ),
  ),

  // ---- View ------------------------------------------------------------
  ('ArcaneAlert', const ArcaneAlert.info(title: 'Note')),
  ('ArcaneAvatar', const ArcaneAvatar(initials: 'AB')),
  (
    'ArcaneAvatarGroup',
    const ArcaneAvatarGroup(
      avatars: <ArcaneAvatar>[ArcaneAvatar(initials: 'A')],
    ),
  ),
  ('ArcaneAvatarBadge', const ArcaneAvatarBadge.online()),
  ('Bar', const Bar()),
  ('CardSection', const CardSection()),
  ('CenterBody', const CenterBody(message: 'Nothing here')),
  ('ArcaneEmptyState', const ArcaneEmptyState(title: 'Empty')),
  ('Expander', Expander(header: _child, child: _child)),
  ('Image', const Image(src: 'x.png', alt: 'x')),
  ('ArcaneKbd', const ArcaneKbd('Ctrl')),
  ('Logo', const Logo(title: 'Arcane')),
  ('Markdown', const Markdown('# Heading')),
  ('ArcaneTableMd', const ArcaneTableMd('| a |\n| - |\n| 1 |')),
  ('ArcaneSeparator', const ArcaneSeparator()),
  ('ArcaneProgressBar', const ArcaneProgressBar(value: 0.5)),
  ('ArcaneCircularProgress', const ArcaneCircularProgress(value: 0.5)),
  ('ArcaneLoadingSpinner', const ArcaneLoadingSpinner()),
  ('ArcaneSkeleton', const ArcaneSkeleton()),
  ('ArcaneSkeletonCard', const ArcaneSkeletonCard()),
  ('ArcaneSkeletonText', const ArcaneSkeletonText()),
  ('ArcaneSpinner', const ArcaneSpinner()),
  ('ArcaneHoverCard', ArcaneHoverCard(trigger: _child, textContent: 'tip')),
  ('ArcaneItem', ArcaneItem(child: _child)),
  ('Icon', Icon(Icons.calendar)),
  ('Tile', const Tile()),

  // ---- Card / data -----------------------------------------------------
  ('Card', Card(child: _child)),
  ('ArcaneStructuredCard', ArcaneStructuredCard(body: _child)),
  ('ArcaneImageCard', const ArcaneImageCard(imageUrl: 'x.png')),
  (
    'ArcaneChart',
    const ArcaneChart(
      points: <ArcaneChartPoint>[ArcaneChartPoint(label: 'a', value: 1)],
    ),
  ),
  (
    'StaticTable',
    const StaticTable(
      headers: <String>['Key'],
      rows: <List<Widget>>[
        <Widget>[Text('v')],
      ],
    ),
  ),
  (
    'KeyValueTable',
    KeyValueTable(
      rows: <KeyValueRow>[KeyValueRow(key: 'k', value: _child)],
    ),
  ),

  // ---- Menu ------------------------------------------------------------
  (
    'ArcaneDropdownMenu',
    ArcaneDropdownMenu(trigger: _child, items: _menuItems),
  ),
  (
    'ArcaneMegaMenu',
    const ArcaneMegaMenu(
      label: 'Menu',
      sections: <ArcaneMegaMenuSection>[
        ArcaneMegaMenuSection(
          items: <ArcaneMenuItem>[MenuItemAction(label: 'Item')],
        ),
      ],
    ),
  ),
  ('ArcaneContextMenu', ArcaneContextMenu(trigger: _child, items: _menuItems)),
  (
    'ArcaneMenubar',
    const ArcaneMenubar(
      menus: <ArcaneMenubarMenu>[
        ArcaneMenubarMenu(
          label: 'File',
          items: <ArcaneMenuItem>[MenuItemAction(label: 'New')],
        ),
      ],
    ),
  ),

  // ---- Navigation ------------------------------------------------------
  (
    'ArcaneBreadcrumbs',
    const ArcaneBreadcrumbs(
      items: <BreadcrumbItem>[BreadcrumbItem(label: 'Home')],
    ),
  ),
  ('ArcanePagination', const ArcanePagination(currentPage: 1, totalPages: 5)),
  ('ArcaneSidebar', ArcaneSidebar(children: _children)),
  ('ArcaneSidebarGroup', ArcaneSidebarGroup(children: _children)),
  ('ArcaneSidebarItem', const ArcaneSidebarItem(label: 'Item')),
  ('ArcaneSidebarExpanded', ArcaneSidebarExpanded(children: _children)),
  ('ArcaneSidebarCollapsed', ArcaneSidebarCollapsed(children: _children)),
  ('ArcaneSidebarSeparator', const ArcaneSidebarSeparator()),
  (
    'ArcaneSidebarSubMenu',
    ArcaneSidebarSubMenu(label: 'Sub', children: _children),
  ),
  (
    'ArcaneSidebarSection',
    ArcaneSidebarSection(label: 'Sec', children: _children),
  ),
  (
    'ArcaneNavDropdown',
    ArcaneNavDropdown(label: 'Nav', width: '200px', content: _child),
  ),
  (
    'ArcaneDropdownSectionHeader',
    const ArcaneDropdownSectionHeader(title: 'Header'),
  ),
  ('ArcaneDropdownDivider', const ArcaneDropdownDivider()),
  (
    'ArcaneDropdownItem',
    ArcaneDropdownItem(label: 'Item', href: '#', icon: _icon),
  ),
  (
    'ArcaneToc',
    const ArcaneToc(
      entries: <TocEntry>[TocEntry(id: 'a', text: 'A', depth: 1)],
    ),
  ),

  // ---- Dialog ----------------------------------------------------------
  ('ArcaneDialog', ArcaneDialog(child: _child)),
  (
    'ArcaneConfirmDialog',
    const ArcaneConfirmDialog(title: 'Confirm', message: 'Sure?'),
  ),
  (
    'ArcaneAlertDialog',
    const ArcaneAlertDialog(title: 'Alert', message: 'Heads up'),
  ),
  ('ConfirmText', const ConfirmText(title: 'Delete', confirmPhrase: 'DELETE')),
  (
    'ArcaneCommand',
    const ArcaneCommand(
      groups: <CommandGroup>[
        CommandGroup(items: <CommandItem>[CommandItem(label: 'Run')]),
      ],
    ),
  ),
  ('DialogDate', DialogDate(title: 'Pick', onConfirm: (DateTime? _) {})),
  (
    'DialogDateMulti',
    DialogDateMulti(title: 'Pick', onConfirm: (List<DateTime> _) {}),
  ),
  (
    'DialogDateRange',
    DialogDateRange(title: 'Pick', onConfirm: (DateRange? _) {}),
  ),
  ('DialogEmail', DialogEmail(title: 'Email', onConfirm: (String _) {})),
  ('DialogText', DialogText(title: 'Text', onConfirm: (String _) {})),
  ('DialogTime', DialogTime(title: 'Time', onConfirm: (TimeOfDay? _) {})),
  ('ArcanePopover', ArcanePopover(trigger: _child, content: _child)),
  ('ArcaneToast', const ArcaneToast(message: 'Saved')),
  ('ArcaneTooltip', ArcaneTooltip(text: 'tip', child: _child)),
  ('ArcaneSonner', const ArcaneSonner()),

  // ---- Form (container widgets; the node fields are SSR-unsupported,
  //      see formFieldCases below) ----------------------------------------
  ('ArcaneFieldWrapper', ArcaneFieldWrapper(field: _child)),
  ('ArcaneFormSection', ArcaneFormSection(children: _children)),
  ('ArcaneForm', ArcaneForm(children: _children)),
  ('ArcaneInputGroup', ArcaneInputGroup(children: _children)),

  // ---- Feedback --------------------------------------------------------
  ('ArcaneStatusBadge', const ArcaneStatusBadge(label: 'Live')),

  // ---- Interactive -----------------------------------------------------
  (
    'ArcaneAccordion',
    const ArcaneAccordion(
      items: <ArcaneAccordionItem>[ArcaneAccordionItem(title: 'Q')],
    ),
  ),
  (
    'ArcaneFaqAccordion',
    const ArcaneFaqAccordion(
      faqs: <({String answer, String question})>[(question: 'Q', answer: 'A')],
    ),
  ),
  ('ArcaneDisclosure', ArcaneDisclosure(summary: _child, child: _child)),
  (
    'ArcaneDisclosureGroup',
    ArcaneDisclosureGroup(
      items: <ArcaneDisclosureItem>[
        ArcaneDisclosureItem(summary: _child, content: _child),
      ],
    ),
  ),

  // ---- Collection ------------------------------------------------------
  ('CardCarousel', CardCarousel(children: _children)),
  ('ArcaneNavigableCarousel', ArcaneNavigableCarousel(children: _children)),
  ('ArcaneHeroCarousel', ArcaneHeroCarousel(children: _children)),
  ('Collection', Collection(children: _children)),
  ('ArcaneInfiniteCarousel', ArcaneInfiniteCarousel(children: _children)),
  (
    'ArcaneCarouselSection',
    ArcaneCarouselSection(
      title: 'Featured',
      carousel: ArcaneInfiniteCarousel(children: _children),
    ),
  ),

  // ---- Screen ----------------------------------------------------------
  ('Screen', Screen(child: _child)),

  // ---- Promo -----------------------------------------------------------
  ('ArcaneTopAnnouncementBar', const ArcaneTopAnnouncementBar(message: 'News')),
  ('ArcaneInlineHeroBanner', const ArcaneInlineHeroBanner(message: 'Hi')),

  // ---- Support ---------------------------------------------------------
  ('DeleteIconButton', const DeleteIconButton()),
  ('DeleteMenuButton', const DeleteMenuButton()),
  ('OnHover', OnHover(action: (bool _) {}, child: _child)),
  (
    'OnGesture',
    OnGesture(type: GestureType.press, action: () {}, child: _child),
  ),
];

/// Form-field widgets that delegate to ArcaneField.
///
/// ArcaneField loads its value asynchronously. On the server the async
/// `setState` would fire during the build phase, so ArcaneField guards
/// `_loadValue()` with `kIsWeb` (lib/component/form/field.dart) and renders the
/// loading placeholder during SSR. These cases assert that server render no
/// longer throws.
List<(String, Widget)> formFieldCases() => <(String, Widget)>[
  ('ArcaneStringField', ArcaneStringField(provider: _provider<String>(''))),
  ('ArcaneBoolField', ArcaneBoolField(provider: _provider<bool>(false))),
  (
    'ArcaneColorField',
    ArcaneColorField(provider: _provider<Color>(const Color(0xFF000000))),
  ),
  (
    'ArcaneDateField',
    ArcaneDateField(provider: _provider<DateTime>(DateTime(2026, 1, 1))),
  ),
  (
    'ArcaneTimeField',
    ArcaneTimeField(
      provider: _provider<TimeOfDay>(const TimeOfDay(hour: 9, minute: 0)),
    ),
  ),
  (
    'ArcaneEnumField',
    ArcaneEnumField<String>(
      provider: _provider<String>('a'),
      options: const <String>['a', 'b'],
    ),
  ),
];
