library;

import 'package:arcane_jaspr/arcane_jaspr.dart';

typedef DemoPreviewBuilder = Widget Function(DemoStateController state);

class DemoStateController {
  final Map<String, bool> boolValues;
  final Map<String, String> stringValues;
  final Map<String, double> doubleValues;
  final Map<String, int> intValues;
  final VoidCallback notify;

  const DemoStateController({
    required this.boolValues,
    required this.stringValues,
    required this.doubleValues,
    required this.intValues,
    required this.notify,
  });

  bool boolValue(String key, {bool initial = false}) {
    if (!boolValues.containsKey(key)) {
      boolValues[key] = initial;
    }
    return boolValues[key] ?? initial;
  }

  void setBool(String key, bool value) {
    boolValues[key] = value;
    notify();
  }

  void toggleBool(String key, {bool initial = false}) {
    setBool(key, !boolValue(key, initial: initial));
  }

  String stringValue(String key, {String initial = ''}) {
    if (!stringValues.containsKey(key)) {
      stringValues[key] = initial;
    }
    return stringValues[key] ?? initial;
  }

  void setString(String key, String value) {
    stringValues[key] = value;
    notify();
  }

  double doubleValue(String key, {double initial = 0}) {
    if (!doubleValues.containsKey(key)) {
      doubleValues[key] = initial;
    }
    return doubleValues[key] ?? initial;
  }

  void setDouble(String key, double value) {
    doubleValues[key] = value;
    notify();
  }

  int intValue(String key, {int initial = 0}) {
    if (!intValues.containsKey(key)) {
      intValues[key] = initial;
    }
    return intValues[key] ?? initial;
  }

  void setInt(String key, int value) {
    intValues[key] = value;
    notify();
  }
}

extension _DemoDateState on DemoStateController {
  DateTime dateValue(String key, {required DateTime initial}) {
    String value = stringValue(key, initial: initial.toIso8601String());
    return DateTime.tryParse(value) ?? initial;
  }

  void setDate(String key, DateTime value) {
    setString(key, value.toIso8601String());
  }
}

class DemoDefinition {
  final String componentType;
  final String symbolName;
  final String sourcePath;
  final String code;
  final DemoPreviewBuilder previewBuilder;

  const DemoDefinition({
    required this.componentType,
    required this.symbolName,
    required this.sourcePath,
    required this.code,
    required this.previewBuilder,
  });
}

List<DemoDefinition> demoDefinitions = <DemoDefinition>[
  DemoDefinition(
    componentType: 'accordion',
    symbolName: 'ArcaneAccordion',
    sourcePath: 'lib/component/interactive/accordion.dart',
    code: '''ArcaneAccordion(
  items: const [
    ArcaneAccordionItem(
      title: 'What is Arcane Jaspr?',
      content: 'A Flutter-like DX for Jaspr with semantic HTML output.',
      defaultOpen: true,
    ),
    ArcaneAccordionItem(
      title: 'Can I swap themes quickly?',
      content: 'Yes. Switch between Shadcn and Neon with one stylesheet.',
    ),
  ],
)''',
    previewBuilder: _buildAccordionDemo,
  ),
  DemoDefinition(
    componentType: 'alert',
    symbolName: 'ArcaneAlert',
    sourcePath: 'lib/component/view/alert.dart',
    code: '''const Column(
  children: [
    ArcaneAlert.info(
      title: 'Heads up',
      message: 'This is a live alert preview rendered by the current theme.',
    ),
    ArcaneAlert.success(
      title: 'Published',
      message: 'Accent alerts use a complete, uniform perimeter.',
      variant: AlertStyle.accent,
    ),
  ],
)''',
    previewBuilder: _buildAlertDemo,
  ),
  DemoDefinition(
    componentType: 'alert-dialog',
    symbolName: 'ArcaneAlertDialog',
    sourcePath: 'lib/component/dialog/confirm.dart',
    code: '''ArcaneBox(
  children: [
    Button.destructive(label: 'Delete project', onPressed: openDialog),
    if (dialogOpen)
      ArcaneAlertDialog(
        title: 'Delete Project?',
        message: 'This action cannot be undone.',
        buttonText: 'Understood',
        onDismiss: closeDialog,
      ),
  ],
)''',
    previewBuilder: _buildAlertDialogDemo,
  ),
  DemoDefinition(
    componentType: 'aspect-ratio',
    symbolName: 'ArcaneAspectRatio',
    sourcePath: 'lib/component/layout/aspect_ratio.dart',
    code: '''ArcaneAspectRatio.video(
  child: const Card(child: Text('16:9 container')),
)''',
    previewBuilder: _buildAspectRatioDemo,
  ),
  DemoDefinition(
    componentType: 'avatar',
    symbolName: 'ArcaneAvatar',
    sourcePath: 'lib/component/view/avatar.dart',
    code: '''ArcaneAvatarGroup.toRight(
  avatars: const [
    ArcaneAvatar(initials: 'AB'),
    ArcaneAvatar(initials: 'CD'),
    ArcaneAvatar(initials: 'EF'),
  ],
)''',
    previewBuilder: _buildAvatarDemo,
  ),
  DemoDefinition(
    componentType: 'badge',
    symbolName: 'ArcaneStatusBadge',
    sourcePath: 'lib/component/feedback/status_badge.dart',
    code: '''ArcaneBox(
  style: const ArcaneStyleData(
    display: Display.flex,
    gap: Gap.sm,
    flexWrap: FlexWrap.wrap,
  ),
  children: const [
    ArcaneStatusBadge.success('Online'),
    ArcaneStatusBadge.warning('Review'),
    ArcaneStatusBadge.info('Beta'),
  ],
)''',
    previewBuilder: _buildBadgeDemo,
  ),
  DemoDefinition(
    componentType: 'breadcrumb',
    symbolName: 'ArcaneBreadcrumbs',
    sourcePath: 'lib/component/navigation/breadcrumbs.dart',
    code: '''ArcaneBreadcrumbs(
  items: const [
    BreadcrumbItem(label: 'Docs', href: '/docs'),
    BreadcrumbItem(label: 'Components', href: '/docs/components-catalog'),
    BreadcrumbItem(label: 'Button'),
  ],
  separator: BreadcrumbSeparator.chevron,
)''',
    previewBuilder: _buildBreadcrumbDemo,
  ),
  DemoDefinition(
    componentType: 'button',
    symbolName: 'Button',
    sourcePath: 'lib/component/input/button.dart',
    code: '''int count = 0;

ArcaneBox(
  style: const ArcaneStyleData(
    display: Display.flex,
    gap: Gap.sm,
    flexWrap: FlexWrap.wrap,
  ),
  children: [
    Button.primary(label: 'Clicked \$count', onPressed: increment),
    Button.secondary(label: 'Secondary', onPressed: () {}),
    Button.outline(label: 'Outline', onPressed: () {}),
  ],
)''',
    previewBuilder: _buildButtonDemo,
  ),
  DemoDefinition(
    componentType: 'button-group',
    symbolName: 'ButtonGroup',
    sourcePath: 'lib/component/layout/button_panel.dart',
    code: '''ButtonGroup(
  children: [
    Button.secondary(label: 'Back', onPressed: () {}),
    Button.primary(label: 'Continue', onPressed: () {}),
  ],
)''',
    previewBuilder: _buildButtonGroupDemo,
  ),
  DemoDefinition(
    componentType: 'calendar',
    symbolName: 'ArcaneCalendar',
    sourcePath: 'lib/component/input/calendar.dart',
    code: '''DateTime selectedDate = DateTime(2026, 4, 24);

ArcaneCalendar(
  selected: selectedDate,
  onSelect: updateSelectedDate,
)''',
    previewBuilder: _buildCalendarDemo,
  ),
  DemoDefinition(
    componentType: 'card',
    symbolName: 'Card',
    sourcePath: 'lib/component/card/card.dart',
    code: '''const Card.elevated(
  children: [
    Text.heading3('Project Card'),
    Text.body('Cards group related content with theme-owned surfaces.'),
  ],
)''',
    previewBuilder: _buildCardDemo,
  ),
  DemoDefinition(
    componentType: 'carousel',
    symbolName: 'CardCarousel',
    sourcePath: 'lib/component/collection/card_carousel.dart',
    code: '''CardCarousel(
  gap: 12,
  children: const [
    Card(child: Text('Slide 1')),
    Card(child: Text('Slide 2')),
    Card(child: Text('Slide 3')),
  ],
)''',
    previewBuilder: _buildCarouselDemo,
  ),
  DemoDefinition(
    componentType: 'chart',
    symbolName: 'ArcaneChart',
    sourcePath: 'lib/component/data/chart.dart',
    code: '''ArcaneChart(
  title: 'Revenue',
  points: const [
    ArcaneChartPoint(label: 'Jan', value: 12),
    ArcaneChartPoint(label: 'Feb', value: 18),
    ArcaneChartPoint(label: 'Mar', value: 16),
    ArcaneChartPoint(label: 'Apr', value: 24),
  ],
)''',
    previewBuilder: _buildChartDemo,
  ),
  DemoDefinition(
    componentType: 'checkbox',
    symbolName: 'ArcaneCheckbox',
    sourcePath: 'lib/component/input/checkbox.dart',
    code: '''bool notificationsEnabled = true;

ArcaneCheckbox(
  checked: notificationsEnabled,
  label: 'Enable notifications',
  onChanged: setNotificationsEnabled,
)''',
    previewBuilder: _buildCheckboxDemo,
  ),
  DemoDefinition(
    componentType: 'collapsible',
    symbolName: 'ArcaneDisclosure',
    sourcePath: 'lib/component/interactive/disclosure.dart',
    code: '''const ArcaneDisclosure(
  summary: Text('Toggle content'),
  child: Text('This disclosure is rendered by the active theme.'),
  open: true,
)''',
    previewBuilder: _buildCollapsibleDemo,
  ),
  DemoDefinition(
    componentType: 'combobox',
    symbolName: 'ArcaneCombobox',
    sourcePath: 'lib/component/input/combobox.dart',
    code: '''String framework = 'jaspr';

ArcaneCombobox(
  label: 'Framework',
  value: framework,
  options: const [
    ComboboxOption(value: 'jaspr', label: 'Jaspr'),
    ComboboxOption(value: 'flutter', label: 'Flutter'),
    ComboboxOption(value: 'react', label: 'React'),
  ],
  onChanged: (String? value) {
    if (value != null) setFramework(value);
  },
)''',
    previewBuilder: _buildComboboxDemo,
  ),
  DemoDefinition(
    componentType: 'command',
    symbolName: 'ArcaneCommand',
    sourcePath: 'lib/component/dialog/command.dart',
    code: '''ArcaneBox(
  children: [
    Button.secondary(label: 'Open command', onPressed: openCommand),
    ArcaneCommand(
      isOpen: commandOpen,
      onClose: closeCommand,
      groups: [
        CommandGroup(
          heading: 'Navigation',
          items: [
            CommandItem(label: 'Go to Dashboard', onSelect: closeCommand),
            CommandItem(
              label: 'Open Settings',
              shortcut: 'Cmd+,',
              onSelect: closeCommand,
            ),
          ],
        ),
      ],
    ),
  ],
)''',
    previewBuilder: _buildCommandDemo,
  ),
  DemoDefinition(
    componentType: 'context-menu',
    symbolName: 'ArcaneContextMenu',
    sourcePath: 'lib/component/menu/context_menu.dart',
    code: '''ArcaneContextMenu(
  trigger: Button.secondary(label: 'Right-click me', onPressed: () {}),
  items: const [
    MenuItemAction(label: 'Copy'),
    MenuItemAction(label: 'Rename'),
    MenuItemSeparator(),
    MenuItemCheckbox(label: 'Pinned', checked: true),
  ],
)''',
    previewBuilder: _buildContextMenuDemo,
  ),
  DemoDefinition(
    componentType: 'data-table',
    symbolName: 'DataTable',
    sourcePath: 'lib/component/view/data_table.dart',
    code: '''DataTable(
  items: const [
    _DemoUser(name: 'Alex', role: 'Admin', status: 'Active'),
    _DemoUser(name: 'Sam', role: 'Editor', status: 'Pending'),
    _DemoUser(name: 'Rae', role: 'Viewer', status: 'Active'),
  ],
  columns: [
    DataColumn(header: 'Name', builder: (_DemoUser user) => Text(user.name)),
    DataColumn(header: 'Role', builder: (_DemoUser user) => Text(user.role)),
    DataColumn(header: 'Status', builder: (_DemoUser user) => Text(user.status)),
  ],
)''',
    previewBuilder: _buildDataTableDemo,
  ),
  DemoDefinition(
    componentType: 'date-picker',
    symbolName: 'ArcaneDatePicker',
    sourcePath: 'lib/component/input/date_picker.dart',
    code: '''DateTime startDate = DateTime(2026, 4, 24);

ArcaneDatePicker(
  value: startDate,
  label: 'Start date',
  onChanged: updateStartDate,
)''',
    previewBuilder: _buildDatePickerDemo,
  ),
  DemoDefinition(
    componentType: 'dialog',
    symbolName: 'ArcaneDialog',
    sourcePath: 'lib/component/dialog/dialog.dart',
    code: '''ArcaneBox(
  children: [
    Button.primary(label: 'Open dialog', onPressed: openDialog),
    if (dialogOpen)
      ArcaneDialog(
        isOpen: true,
        title: 'Confirm Settings',
        onClose: closeDialog,
        child: const Text('Apply changes to your current workspace?'),
        actions: [
          Button.secondary(label: 'Cancel', onPressed: closeDialog),
          Button.primary(label: 'Apply', onPressed: closeDialog),
        ],
      ),
  ],
)''',
    previewBuilder: _buildDialogDemo,
  ),
  DemoDefinition(
    componentType: 'direction',
    symbolName: 'ArcaneDirection',
    sourcePath: 'lib/component/layout/direction.dart',
    code: '''const ArcaneDirection(
  value: ArcaneDirectionValue.rtl,
  children: [Text('Right-to-left direction preview')],
)''',
    previewBuilder: _buildDirectionDemo,
  ),
  DemoDefinition(
    componentType: 'drawer',
    symbolName: 'ArcaneDrawer',
    sourcePath: 'lib/component/layout/drawer.dart',
    code: '''ArcaneBox(
  children: [
    Button.secondary(label: 'Open drawer', onPressed: openDrawer),
    ArcaneDrawer.left(
      isOpen: drawerOpen,
      onClose: closeDrawer,
      header: const Text('Navigation'),
      child: const Text('Drawer content'),
    ),
  ],
)''',
    previewBuilder: _buildDrawerDemo,
  ),
  DemoDefinition(
    componentType: 'dropdown-menu',
    symbolName: 'ArcaneDropdownMenu',
    sourcePath: 'lib/component/menu/dropdown_menu.dart',
    code: '''ArcaneDropdownMenu(
  trigger: Button.secondary(label: 'Open menu', onPressed: () {}),
  items: const [
    MenuItemAction(label: 'Profile'),
    MenuItemAction(label: 'Billing'),
    MenuItemSeparator(),
    MenuItemAction(label: 'Sign out', destructive: true),
  ],
)''',
    previewBuilder: _buildDropdownMenuDemo,
  ),
  DemoDefinition(
    componentType: 'empty',
    symbolName: 'ArcaneEmptyState',
    sourcePath: 'lib/component/view/empty_state.dart',
    code: '''ArcaneEmptyState.noResults(
  action: Button.primary(label: 'Create item', onPressed: () {}),
)''',
    previewBuilder: _buildEmptyDemo,
  ),
  DemoDefinition(
    componentType: 'field',
    symbolName: 'ArcaneFieldWrapper',
    sourcePath: 'lib/component/form/field_wrapper.dart',
    code: '''ArcaneFieldWrapper(
  labelText: 'Email',
  description: 'We only use this for account notices.',
  field: TextInput(
    placeholder: 'name@company.com',
    onChanged: (String value) {},
  ),
)''',
    previewBuilder: _buildFieldDemo,
  ),
  DemoDefinition(
    componentType: 'hover-card',
    symbolName: 'ArcaneHoverCard',
    sourcePath: 'lib/component/view/floating.dart',
    code: '''ArcaneHoverCard.hovercard(
  trigger: Button.secondary(label: 'Hover card', onPressed: () {}),
  content: const Text('A lightweight profile or preview.'),
)''',
    previewBuilder: _buildHoverCardDemo,
  ),
  DemoDefinition(
    componentType: 'input',
    symbolName: 'TextInput',
    sourcePath: 'lib/component/input/text_input.dart',
    code: '''String email = '';

TextInput(
  label: 'Email',
  placeholder: 'name@example.com',
  value: email,
  onChanged: setEmail,
)''',
    previewBuilder: _buildInputDemo,
  ),
  DemoDefinition(
    componentType: 'input-group',
    symbolName: 'ArcaneInputGroup',
    sourcePath: 'lib/component/form/field_wrapper.dart',
    code: '''String search = '';

ArcaneInputGroup(
  children: [
    TextInput(
      placeholder: 'Search',
      value: search,
      onChanged: setSearch,
    ),
    Button.primary(label: 'Go', onPressed: () {}),
  ],
)''',
    previewBuilder: _buildInputGroupDemo,
  ),
  DemoDefinition(
    componentType: 'input-otp',
    symbolName: 'ArcaneOtpInput',
    sourcePath: 'lib/component/input/otp_input.dart',
    code: '''String code = '123456';

ArcaneOtpInput.sixDigit(
  value: code,
  onChanged: setCode,
)''',
    previewBuilder: _buildInputOtpDemo,
  ),
  DemoDefinition(
    componentType: 'item',
    symbolName: 'ArcaneItem',
    sourcePath: 'lib/component/view/item.dart',
    code: '''const ArcaneItem(
  child: Text('Clickable item row'),
  href: '/docs',
)''',
    previewBuilder: _buildItemDemo,
  ),
  DemoDefinition(
    componentType: 'kbd',
    symbolName: 'ArcaneKbd',
    sourcePath: 'lib/component/view/kbd.dart',
    code: '''const ArcaneKbd.combo(['Cmd', 'K'])''',
    previewBuilder: _buildKbdDemo,
  ),
  DemoDefinition(
    componentType: 'menubar',
    symbolName: 'ArcaneMenubar',
    sourcePath: 'lib/component/menu/menubar.dart',
    code: '''ArcaneMenubar(
  menus: const [
    ArcaneMenubarMenu(
      label: 'File',
      items: [
        MenuItemAction(label: 'New'),
        MenuItemAction(label: 'Open'),
        MenuItemSeparator(),
        MenuItemAction(label: 'Exit'),
      ],
    ),
    ArcaneMenubarMenu(
      label: 'Edit',
      items: [
        MenuItemAction(label: 'Undo'),
        MenuItemAction(label: 'Redo'),
      ],
    ),
  ],
)''',
    previewBuilder: _buildMenubarDemo,
  ),
  DemoDefinition(
    componentType: 'navigation-menu',
    symbolName: 'ArcaneNavDropdown',
    sourcePath: 'lib/component/navigation/nav_dropdown.dart',
    code: '''ArcaneNavDropdown(
  label: 'Products',
  width: '280px',
  content: const ArcaneBox(
    style: ArcaneStyleData(
      padding: PaddingPreset.md,
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap.sm,
    ),
    children: [Text('Core UI'), Text('Documentation'), Text('Templates')],
  ),
)''',
    previewBuilder: _buildNavigationMenuDemo,
  ),
  DemoDefinition(
    componentType: 'pagination',
    symbolName: 'ArcanePagination',
    sourcePath: 'lib/component/navigation/pagination.dart',
    code: '''int page = 2;

ArcanePagination(
  currentPage: page,
  totalPages: 8,
  onPageChange: setPage,
)''',
    previewBuilder: _buildPaginationDemo,
  ),
  DemoDefinition(
    componentType: 'popover',
    symbolName: 'ArcanePopover',
    sourcePath: 'lib/component/dialog/popover.dart',
    code: '''ArcanePopover(
  isOpen: popoverOpen,
  onOpenChange: setPopoverOpen,
  trigger: Button.secondary(label: 'Open popover', onPressed: () {}),
  content: const Text('Popover content'),
)''',
    previewBuilder: _buildPopoverDemo,
  ),
  DemoDefinition(
    componentType: 'progress',
    symbolName: 'ArcaneProgressBar',
    sourcePath: 'lib/component/view/progress_bar.dart',
    code: '''ArcaneBox(
  style: const ArcaneStyleData(
    display: Display.flex,
    flexDirection: FlexDirection.column,
    gap: Gap.sm,
    width: Size.full,
  ),
  children: const [
    ArcaneProgressBar(value: 68, showValue: true),
    ArcaneProgressBar.success(value: 42),
  ],
)''',
    previewBuilder: _buildProgressDemo,
  ),
  DemoDefinition(
    componentType: 'radio-group',
    symbolName: 'ArcaneRadioGroup',
    sourcePath: 'lib/component/input/radio_group.dart',
    code: '''String plan = 'starter';

ArcaneRadioGroup(
  value: plan,
  options: const [
    RadioOption(value: 'starter', label: 'Starter'),
    RadioOption(value: 'pro', label: 'Pro'),
    RadioOption(value: 'enterprise', label: 'Enterprise'),
  ],
  onChanged: setPlan,
)''',
    previewBuilder: _buildRadioGroupDemo,
  ),
  DemoDefinition(
    componentType: 'resizable',
    symbolName: 'ArcaneResizable',
    sourcePath: 'lib/component/layout/resizable.dart',
    code: '''ArcaneResizable.sidebarLayout(
  sidebar: const Card(child: Text('Sidebar')),
  content: const Card(child: Text('Main content')),
)''',
    previewBuilder: _buildResizableDemo,
  ),
  DemoDefinition(
    componentType: 'scroll-area',
    symbolName: 'ArcaneScrollArea',
    sourcePath: 'lib/component/layout/scroll_area.dart',
    code: '''ArcaneScrollArea.vertical(
  height: '150px',
  child: ArcaneBox(
    style: const ArcaneStyleData(
      display: Display.flex,
      flexDirection: FlexDirection.column,
      gap: Gap.sm,
    ),
    children: const [
      Text('Row 1'),
      Text('Row 2'),
      Text('Row 3'),
      Text('Row 4'),
      Text('Row 5'),
      Text('Row 6'),
      Text('Row 7'),
    ],
  ),
)''',
    previewBuilder: _buildScrollAreaDemo,
  ),
  DemoDefinition(
    componentType: 'select',
    symbolName: 'ArcaneSelect',
    sourcePath: 'lib/component/input/text_input.dart',
    code: '''String plan = 'pro';

ArcaneSelect(
  label: 'Plan',
  value: plan,
  options: const [
    ArcaneSelectOption(label: 'Starter', value: 'starter'),
    ArcaneSelectOption(label: 'Pro', value: 'pro'),
    ArcaneSelectOption(label: 'Enterprise', value: 'enterprise'),
  ],
  onChanged: setPlan,
)''',
    previewBuilder: _buildSelectDemo,
  ),
  DemoDefinition(
    componentType: 'separator',
    symbolName: 'ArcaneSeparator',
    sourcePath: 'lib/component/view/separator.dart',
    code: '''const ArcaneSeparator.withLabel(label: 'OR')''',
    previewBuilder: _buildSeparatorDemo,
  ),
  DemoDefinition(
    componentType: 'sheet',
    symbolName: 'ArcaneSheet',
    sourcePath: 'lib/component/layout/sheet.dart',
    code: '''ArcaneBox(
  children: [
    Button.secondary(label: 'Open sheet', onPressed: openSheet),
    ArcaneSheet.bottom(
      isOpen: sheetOpen,
      onClose: closeSheet,
      child: const Text('Sheet content'),
    ),
  ],
)''',
    previewBuilder: _buildSheetDemo,
  ),
  DemoDefinition(
    componentType: 'sidebar',
    symbolName: 'ArcaneSidebar',
    sourcePath: 'lib/component/navigation/sidebar.dart',
    code: '''ArcaneSidebar(
  width: 240,
  showCollapseToggle: false,
  header: const Text('Workspace'),
  footer: const Text('v2.9'),
  children: const [
    ArcaneSidebarItem(label: 'Dashboard', selected: true),
    ArcaneSidebarItem(label: 'Projects'),
    ArcaneSidebarItem(label: 'Settings'),
  ],
)''',
    previewBuilder: _buildSidebarDemo,
  ),
  DemoDefinition(
    componentType: 'skeleton',
    symbolName: 'ArcaneSkeleton',
    sourcePath: 'lib/component/view/skeleton.dart',
    code: '''const ArcaneSkeletonCard()''',
    previewBuilder: _buildSkeletonDemo,
  ),
  DemoDefinition(
    componentType: 'slider',
    symbolName: 'ArcaneSlider',
    sourcePath: 'lib/component/input/slider.dart',
    code: '''double volume = 42;

ArcaneSlider(
  label: 'Volume',
  value: volume,
  onChanged: setVolume,
)''',
    previewBuilder: _buildSliderDemo,
  ),
  DemoDefinition(
    componentType: 'sonner',
    symbolName: 'ArcaneSonner',
    sourcePath: 'lib/component/dialog/sonner.dart',
    code: '''ArcaneBox(
  style: const ArcaneStyleData(
    display: Display.flex,
    flexDirection: FlexDirection.column,
    gap: Gap.sm,
  ),
  children: [
    const ArcaneSonner(position: ToastPosition.topRight),
    Button.secondary(
      label: 'Show toast',
      onPressed: () {
        ArcaneSonner.success(
          'Sonner-compatible toast stack',
          title: 'Notification',
        );
      },
    ),
  ],
)''',
    previewBuilder: _buildSonnerDemo,
  ),
  DemoDefinition(
    componentType: 'spinner',
    symbolName: 'ArcaneSpinner',
    sourcePath: 'lib/component/view/spinner.dart',
    code: '''ArcaneBox(
  style: const ArcaneStyleData(
    display: Display.flex,
    alignItems: AlignItems.center,
    gap: Gap.sm,
  ),
  children: const [
    ArcaneSpinner(),
    Text.body('Loading workspace'),
  ],
)''',
    previewBuilder: _buildSpinnerDemo,
  ),
  DemoDefinition(
    componentType: 'switch',
    symbolName: 'ArcaneToggleSwitch',
    sourcePath: 'lib/component/input/toggle_switch.dart',
    code: '''bool syncEnabled = true;

ArcaneToggleSwitch(
  value: syncEnabled,
  label: 'Enable sync',
  onChanged: setSyncEnabled,
)''',
    previewBuilder: _buildSwitchDemo,
  ),
  DemoDefinition(
    componentType: 'table',
    symbolName: 'StaticTable',
    sourcePath: 'lib/component/view/static_table.dart',
    code: '''StaticTable(
  headers: const ['Name', 'Role'],
  rows: const [
    [Text('Alex'), Text('Admin')],
    [Text('Sam'), Text('Editor')],
    [Text('Rae'), Text('Viewer')],
  ],
)''',
    previewBuilder: _buildTableDemo,
  ),
  DemoDefinition(
    componentType: 'tabs',
    symbolName: 'ArcaneTabs',
    sourcePath: 'lib/component/layout/tabs.dart',
    code: '''ArcaneTabs(
  tabs: const [
    ArcaneTabItem(label: 'Account', content: Text('Account tab content')),
    ArcaneTabItem(label: 'Billing', content: Text('Billing tab content')),
  ],
)''',
    previewBuilder: _buildTabsDemo,
  ),
  DemoDefinition(
    componentType: 'textarea',
    symbolName: 'TextArea',
    sourcePath: 'lib/component/input/text_input.dart',
    code: '''String message = '';

TextArea(
  label: 'Message',
  placeholder: 'Type your message',
  rows: 4,
  value: message,
  onChanged: setMessage,
)''',
    previewBuilder: _buildTextareaDemo,
  ),
  DemoDefinition(
    componentType: 'toggle',
    symbolName: 'ArcaneToggleButton',
    sourcePath: 'lib/component/input/cycle_button.dart',
    code: '''bool boldEnabled = true;

ArcaneToggleButton(
  value: boldEnabled,
  label: 'Bold',
  onChanged: setBoldEnabled,
)''',
    previewBuilder: _buildToggleDemo,
  ),
  DemoDefinition(
    componentType: 'toggle-group',
    symbolName: 'ArcaneToggleGroup',
    sourcePath: 'lib/component/input/toggle_group.dart',
    code: '''String alignment = 'left';

ArcaneToggleGroup(
  value: alignment,
  items: [
    ToggleGroupItem.text('left', label: 'Left'),
    ToggleGroupItem.text('center', label: 'Center'),
    ToggleGroupItem.text('right', label: 'Right'),
  ],
  onChanged: (String? value) {
    if (value != null) setAlignment(value);
  },
)''',
    previewBuilder: _buildToggleGroupDemo,
  ),
  DemoDefinition(
    componentType: 'tooltip',
    symbolName: 'ArcaneTooltip',
    sourcePath: 'lib/component/dialog/tooltip.dart',
    code: '''ArcaneTooltip(
  text: 'This is a tooltip',
  child: Button.secondary(label: 'Hover target', onPressed: () {}),
)''',
    previewBuilder: _buildTooltipDemo,
  ),
  DemoDefinition(
    componentType: 'typography',
    symbolName: 'Text',
    sourcePath: 'lib/component/typography/text.dart',
    code: '''ArcaneBox(
  style: const ArcaneStyleData(
    display: Display.flex,
    flexDirection: FlexDirection.column,
    gap: Gap.sm,
  ),
  children: const [
    Text.heading2('Typography Preview'),
    Text.body('Readable hierarchy and spacing.'),
  ],
)''',
    previewBuilder: _buildTypographyDemo,
  ),
  DemoDefinition(
    componentType: 'styling',
    symbolName: 'ArcaneStyleData',
    sourcePath: 'lib/util/style_types/arcane_style_data.dart',
    code: '''ArcaneBox(
  style: const ArcaneStyleData(
    padding: PaddingPreset.lg,
    display: Display.flex,
    flexDirection: FlexDirection.column,
    gap: Gap.md,
    background: Background.surface,
    border: BorderPreset.standard,
    borderRadius: Radius.md,
    shadow: Shadow.md,
  ),
  children: const [
    ArcaneStatusBadge.info('Live stylesheet'),
    Text.heading3('Renderer-owned styling'),
    Text.body('Swap stylesheet, palette, or theme without changing this widget.'),
  ],
)''',
    previewBuilder: _buildStylingDemo,
  ),
  DemoDefinition(
    componentType: 'tokens',
    symbolName: 'Background',
    sourcePath: 'lib/util/style_types/colors.dart',
    code: '''ArcaneBox(
  style: const ArcaneStyleData(
    padding: PaddingPreset.lg,
    background: Background.surface,
    border: BorderPreset.standard,
    borderRadius: Radius.md,
  ),
  children: const [
    ArcaneStatusBadge.primary('Primary'),
    ArcaneStatusBadge.success('Success'),
    ArcaneStatusBadge.warning('Warning'),
  ],
)''',
    previewBuilder: _buildTokensDemo,
  ),
  DemoDefinition(
    componentType: 'theming',
    symbolName: 'ArcaneStyleData',
    sourcePath: 'lib/util/style_types/arcane_style_data.dart',
    code: '''ArcaneBox(
  style: const ArcaneStyleData(
    padding: PaddingPreset.lg,
    background: Background.card,
    border: BorderPreset.accent,
    borderRadius: Radius.md,
  ),
  children: [
    Button.primary(label: 'Primary', onPressed: () {}),
    Button.secondary(label: 'Secondary', onPressed: () {}),
  ],
)''',
    previewBuilder: _buildThemingDemo,
  ),
  DemoDefinition(
    componentType: 'aliases',
    symbolName: 'ArcaneBox',
    sourcePath: 'lib/arcane_jaspr.dart',
    code: '''ArcaneBox(
  style: const ArcaneStyleData(
    display: Display.flex,
    gap: Gap.sm,
    alignItems: AlignItems.center,
  ),
  children: [
    Button.primary(label: 'Save', onPressed: () {}),
    Button.secondary(label: 'Cancel', onPressed: () {}),
  ],
)''',
    previewBuilder: _buildAliasesDemo,
  ),
  DemoDefinition(
    componentType: 'borders',
    symbolName: 'BorderPreset',
    sourcePath: 'lib/util/style_types/borders.dart',
    code: '''ArcaneBox(
  style: const ArcaneStyleData(
    padding: PaddingPreset.lg,
    border: BorderPreset.accentThick,
    borderRadius: Radius.md,
    background: Background.surface,
  ),
  children: const [Text.body('Theme-owned borders')],
)''',
    previewBuilder: _buildBordersDemo,
  ),
  DemoDefinition(
    componentType: 'colors',
    symbolName: 'Background',
    sourcePath: 'lib/util/style_types/colors.dart',
    code: '''ArcaneBox(
  style: const ArcaneStyleData(
    background: Background.accentContainer,
    padding: PaddingPreset.lg,
    borderRadius: Radius.md,
  ),
  children: const [Text.heading3('Palette aware')],
)''',
    previewBuilder: _buildColorsDemo,
  ),
  DemoDefinition(
    componentType: 'display',
    symbolName: 'Display',
    sourcePath: 'lib/util/style_types/layout.dart',
    code: '''ArcaneBox(
  style: const ArcaneStyleData(
    display: Display.flex,
    flexWrap: FlexWrap.wrap,
    gap: Gap.sm,
  ),
  children: const [
    ArcaneStatusBadge.secondary('One'),
    ArcaneStatusBadge.secondary('Two'),
    ArcaneStatusBadge.secondary('Three'),
  ],
)''',
    previewBuilder: _buildDisplayDemo,
  ),
  DemoDefinition(
    componentType: 'effects',
    symbolName: 'Shadow',
    sourcePath: 'lib/util/style_types/effects.dart',
    code: '''ArcaneBox(
  style: const ArcaneStyleData(
    padding: PaddingPreset.lg,
    background: Background.surface,
    border: BorderPreset.standard,
    borderRadius: Radius.md,
    shadow: Shadow.md,
  ),
  children: const [Text.body('Theme-specific effects')],
)''',
    previewBuilder: _buildEffectsDemo,
  ),
  DemoDefinition(
    componentType: 'spacing',
    symbolName: 'Gap',
    sourcePath: 'lib/util/style_types/spacing.dart',
    code: '''ArcaneBox(
  style: const ArcaneStyleData(
    display: Display.flex,
    flexDirection: FlexDirection.column,
    gap: Gap.md,
  ),
  children: [
    Button.primary(label: 'First', onPressed: () {}),
    Button.secondary(label: 'Second', onPressed: () {}),
  ],
)''',
    previewBuilder: _buildSpacingDemo,
  ),
  DemoDefinition(
    componentType: 'typography-styles',
    symbolName: 'Text',
    sourcePath: 'lib/component/typography/text.dart',
    code: '''ArcaneBox(
  style: const ArcaneStyleData(
    display: Display.flex,
    flexDirection: FlexDirection.column,
    gap: Gap.xs,
  ),
  children: const [
    Text.heading2('Heading'),
    Text.subheading('Subheading'),
    Text.body('Body copy adapts per stylesheet.'),
  ],
)''',
    previewBuilder: _buildTypographyStylesDemo,
  ),
];

Map<String, DemoDefinition> demoRegistry =
    Map<String, DemoDefinition>.unmodifiable(<String, DemoDefinition>{
      for (DemoDefinition demo in demoDefinitions) demo.componentType: demo,
    });

Widget _buildAccordionDemo(DemoStateController state) {
  return _surface(
    ArcaneAccordion(
      items: const [
        ArcaneAccordionItem(
          title: 'What is Arcane Jaspr?',
          content: 'A Flutter-like DX for Jaspr with semantic HTML output.',
          defaultOpen: true,
        ),
        ArcaneAccordionItem(
          title: 'Can I swap themes quickly?',
          content: 'Yes. Switch between Shadcn and Neon with one stylesheet.',
        ),
      ],
    ),
  );
}

Widget _buildAlertDemo(DemoStateController state) {
  return _surface(
    const ArcaneBox(
      style: ArcaneStyleData(
        width: Size.full,
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.md,
      ),
      children: <Widget>[
        ArcaneAlert.info(
          title: 'Heads up',
          message:
              'This is a live alert preview rendered by the current theme.',
        ),
        ArcaneAlert.success(
          title: 'Published',
          message: 'Accent alerts use a complete, uniform perimeter.',
          variant: AlertStyle.accent,
        ),
      ],
    ),
  );
}

Widget _buildAlertDialogDemo(DemoStateController state) {
  bool dialogOpen = state.boolValue('alert-dialog-open');
  return _surface(
    ArcaneBox(
      style: const ArcaneStyleData(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.center,
        gap: Gap.sm,
      ),
      children: [
        Button.destructive(
          label: 'Delete project',
          onPressed: () => state.setBool('alert-dialog-open', true),
        ),
        if (dialogOpen)
          ArcaneAlertDialog(
            title: 'Delete Project?',
            message: 'This action cannot be undone.',
            buttonText: 'Understood',
            onDismiss: () => state.setBool('alert-dialog-open', false),
          ),
      ],
    ),
    minHeight: '220px',
  );
}

Widget _buildAspectRatioDemo(DemoStateController state) {
  return _surface(
    ArcaneAspectRatio.video(child: const Card(child: Text('16:9 container'))),
  );
}

Widget _buildAvatarDemo(DemoStateController state) {
  return _surface(
    ArcaneAvatarGroup.toRight(
      avatars: const [
        ArcaneAvatar(initials: 'AB'),
        ArcaneAvatar(initials: 'CD'),
        ArcaneAvatar(initials: 'EF'),
      ],
    ),
  );
}

Widget _buildBadgeDemo(DemoStateController state) {
  return _surface(
    _demoRow(
      const ArcaneStatusBadge.success('Online'),
      const ArcaneStatusBadge.warning('Review'),
      const ArcaneStatusBadge.info('Beta'),
    ),
  );
}

Widget _buildBreadcrumbDemo(DemoStateController state) {
  return _surface(
    ArcaneBreadcrumbs(
      items: const [
        BreadcrumbItem(label: 'Docs', href: '/docs'),
        BreadcrumbItem(label: 'Components', href: '/docs/components-catalog'),
        BreadcrumbItem(label: 'Button'),
      ],
      separator: BreadcrumbSeparator.chevron,
    ),
  );
}

Widget _buildButtonDemo(DemoStateController state) {
  int count = state.intValue('button-count');
  return _surface(
    _demoRow(
      Button.primary(
        label: 'Clicked $count',
        onPressed: () => state.setInt('button-count', count + 1),
      ),
      Button.secondary(label: 'Secondary', onPressed: () {}),
      Button.outline(label: 'Outline', onPressed: () {}),
    ),
  );
}

Widget _buildButtonGroupDemo(DemoStateController state) {
  return _surface(
    ButtonGroup(
      children: [
        Button.secondary(label: 'Back', onPressed: () {}),
        Button.primary(label: 'Continue', onPressed: () {}),
      ],
    ),
  );
}

Widget _buildCalendarDemo(DemoStateController state) {
  DateTime selectedDate = state.dateValue(
    'calendar-date',
    initial: DateTime(2026, 4, 24),
  );
  return _surface(
    ArcaneCalendar(
      selected: selectedDate,
      onSelect: (value) => state.setDate('calendar-date', value),
    ),
  );
}

Widget _buildCardDemo(DemoStateController state) {
  return _surface(
    const Card.elevated(
      children: [
        Text.heading3('Project Card'),
        Text.body('Cards group related content with theme-owned surfaces.'),
      ],
    ),
  );
}

Widget _buildCarouselDemo(DemoStateController state) {
  return _surface(
    CardCarousel(
      gap: 12,
      children: const [
        Card(child: Text('Slide 1')),
        Card(child: Text('Slide 2')),
        Card(child: Text('Slide 3')),
      ],
    ),
  );
}

Widget _buildChartDemo(DemoStateController state) {
  return _surface(
    ArcaneChart(
      title: 'Revenue',
      points: const [
        ArcaneChartPoint(label: 'Jan', value: 12),
        ArcaneChartPoint(label: 'Feb', value: 18),
        ArcaneChartPoint(label: 'Mar', value: 16),
        ArcaneChartPoint(label: 'Apr', value: 24),
      ],
    ),
  );
}

Widget _buildCheckboxDemo(DemoStateController state) {
  bool checked = state.boolValue('checkbox-notifications', initial: true);
  return _surface(
    ArcaneCheckbox(
      checked: checked,
      label: 'Enable notifications',
      onChanged: (value) => state.setBool('checkbox-notifications', value),
    ),
  );
}

Widget _buildCollapsibleDemo(DemoStateController state) {
  return _surface(
    const ArcaneDisclosure(
      summary: Text('Toggle content'),
      child: Text('This disclosure is rendered by the active theme.'),
      open: true,
    ),
  );
}

Widget _buildComboboxDemo(DemoStateController state) {
  String framework = state.stringValue('combobox-framework', initial: 'jaspr');
  return _surface(
    ArcaneCombobox(
      value: framework,
      options: const [
        ComboboxOption(value: 'jaspr', label: 'Jaspr'),
        ComboboxOption(value: 'flutter', label: 'Flutter'),
        ComboboxOption(value: 'react', label: 'React'),
      ],
      onChanged: (value) {
        if (value != null) {
          state.setString('combobox-framework', value);
        }
      },
      label: 'Framework',
    ),
  );
}

Widget _buildCommandDemo(DemoStateController state) {
  bool commandOpen = state.boolValue('command-open');
  return _surface(
    ArcaneBox(
      style: const ArcaneStyleData(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.center,
        gap: Gap.sm,
      ),
      children: [
        Button.secondary(
          label: 'Open command',
          onPressed: () => state.setBool('command-open', true),
        ),
        ArcaneCommand(
          isOpen: commandOpen,
          onClose: () => state.setBool('command-open', false),
          groups: [
            CommandGroup(
              heading: 'Navigation',
              items: [
                CommandItem(
                  label: 'Go to Dashboard',
                  onSelect: () => state.setBool('command-open', false),
                ),
                CommandItem(
                  label: 'Open Settings',
                  shortcut: 'Cmd+,',
                  onSelect: () => state.setBool('command-open', false),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    minHeight: '220px',
  );
}

Widget _buildContextMenuDemo(DemoStateController state) {
  return _surface(
    ArcaneContextMenu(
      trigger: Button.secondary(label: 'Right-click me', onPressed: () {}),
      items: const [
        MenuItemAction(label: 'Copy'),
        MenuItemAction(label: 'Rename'),
        MenuItemSeparator(),
        MenuItemCheckbox(label: 'Pinned', checked: true),
      ],
    ),
  );
}

Widget _buildDataTableDemo(DemoStateController state) {
  return _surface(
    DataTable(
      items: const [
        _DemoUser(name: 'Alex', role: 'Admin', status: 'Active'),
        _DemoUser(name: 'Sam', role: 'Editor', status: 'Pending'),
        _DemoUser(name: 'Rae', role: 'Viewer', status: 'Active'),
      ],
      columns: [
        DataColumn(
          header: 'Name',
          builder: (_DemoUser user) => Text(user.name),
        ),
        DataColumn(
          header: 'Role',
          builder: (_DemoUser user) => Text(user.role),
        ),
        DataColumn(
          header: 'Status',
          builder: (_DemoUser user) => Text(user.status),
        ),
      ],
    ),
    minHeight: '220px',
  );
}

Widget _buildDatePickerDemo(DemoStateController state) {
  DateTime startDate = state.dateValue(
    'date-picker-start',
    initial: DateTime(2026, 4, 24),
  );
  return _surface(
    ArcaneBox(
      style: const ArcaneStyleData(width: Size.full, maxWidthCustom: '20rem'),
      children: [
        ArcaneDatePicker(
          value: startDate,
          label: 'Start date',
          onChanged: (value) {
            if (value != null) {
              state.setDate('date-picker-start', value);
            }
          },
        ),
      ],
    ),
  );
}

Widget _buildDialogDemo(DemoStateController state) {
  bool dialogOpen = state.boolValue('dialog-open');
  return _surface(
    ArcaneBox(
      style: const ArcaneStyleData(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.center,
        gap: Gap.sm,
      ),
      children: [
        Button.primary(
          label: 'Open dialog',
          onPressed: () => state.setBool('dialog-open', true),
        ),
        if (dialogOpen)
          ArcaneDialog(
            isOpen: true,
            title: 'Confirm Settings',
            onClose: () => state.setBool('dialog-open', false),
            child: const Text('Apply changes to your current workspace?'),
            actions: [
              Button.secondary(
                label: 'Cancel',
                onPressed: () => state.setBool('dialog-open', false),
              ),
              Button.primary(
                label: 'Apply',
                onPressed: () => state.setBool('dialog-open', false),
              ),
            ],
          ),
      ],
    ),
    minHeight: '220px',
  );
}

Widget _buildDirectionDemo(DemoStateController state) {
  return _surface(
    const ArcaneDirection(
      value: ArcaneDirectionValue.rtl,
      children: [Text('Right-to-left direction preview')],
    ),
  );
}

Widget _buildDrawerDemo(DemoStateController state) {
  bool drawerOpen = state.boolValue('drawer-open');
  return _surface(
    ArcaneBox(
      style: const ArcaneStyleData(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.center,
        gap: Gap.sm,
      ),
      children: [
        Button.secondary(
          label: 'Open drawer',
          onPressed: () => state.setBool('drawer-open', true),
        ),
        ArcaneDrawer.left(
          isOpen: drawerOpen,
          onClose: () => state.setBool('drawer-open', false),
          header: const Text('Navigation'),
          child: const Text('Drawer content'),
        ),
      ],
    ),
    minHeight: '220px',
  );
}

Widget _buildDropdownMenuDemo(DemoStateController state) {
  return _surface(
    ArcaneDropdownMenu(
      trigger: Button.secondary(label: 'Open menu', onPressed: () {}),
      items: const [
        MenuItemAction(label: 'Profile'),
        MenuItemAction(label: 'Billing'),
        MenuItemSeparator(),
        MenuItemAction(label: 'Sign out', destructive: true),
      ],
    ),
  );
}

Widget _buildEmptyDemo(DemoStateController state) {
  return _surface(
    ArcaneEmptyState.noResults(
      action: Button.primary(label: 'Create item', onPressed: () {}),
    ),
  );
}

Widget _buildFieldDemo(DemoStateController state) {
  return _surface(
    ArcaneFieldWrapper(
      labelText: 'Email',
      description: 'We only use this for account notices.',
      field: TextInput(
        placeholder: 'name@company.com',
        onChanged: (String value) {},
      ),
    ),
  );
}

Widget _buildHoverCardDemo(DemoStateController state) {
  return _surface(
    ArcaneHoverCard.hovercard(
      trigger: Button.secondary(label: 'Hover card', onPressed: () {}),
      content: const Text('A lightweight profile or preview.'),
    ),
    minHeight: '180px',
  );
}

Widget _buildInputDemo(DemoStateController state) {
  String email = state.stringValue('input-email');
  return _surface(
    TextInput(
      label: 'Email',
      placeholder: 'name@example.com',
      value: email,
      onChanged: (value) => state.setString('input-email', value),
    ),
  );
}

Widget _buildInputGroupDemo(DemoStateController state) {
  String search = state.stringValue('input-group-search');
  return _surface(
    ArcaneInputGroup(
      children: [
        TextInput(
          placeholder: 'Search',
          value: search,
          onChanged: (value) => state.setString('input-group-search', value),
        ),
        Button.primary(label: 'Go', onPressed: () {}),
      ],
    ),
  );
}

Widget _buildInputOtpDemo(DemoStateController state) {
  String otp = state.stringValue('input-otp', initial: '123456');
  return _surface(
    ArcaneOtpInput.sixDigit(
      value: otp,
      onChanged: (value) => state.setString('input-otp', value),
    ),
  );
}

Widget _buildItemDemo(DemoStateController state) {
  return _surface(
    const ArcaneItem(child: Text('Clickable item row'), href: '/docs'),
  );
}

Widget _buildKbdDemo(DemoStateController state) {
  return _surface(const ArcaneKbd.combo(['Cmd', 'K']));
}

Widget _buildMenubarDemo(DemoStateController state) {
  return _surface(
    ArcaneMenubar(
      menus: const [
        ArcaneMenubarMenu(
          label: 'File',
          items: [
            MenuItemAction(label: 'New'),
            MenuItemAction(label: 'Open'),
            MenuItemSeparator(),
            MenuItemAction(label: 'Exit'),
          ],
        ),
        ArcaneMenubarMenu(
          label: 'Edit',
          items: [
            MenuItemAction(label: 'Undo'),
            MenuItemAction(label: 'Redo'),
          ],
        ),
      ],
    ),
  );
}

Widget _buildNavigationMenuDemo(DemoStateController state) {
  return _surface(
    ArcaneNavDropdown(
      label: 'Products',
      width: '280px',
      content: const ArcaneBox(
        style: ArcaneStyleData(
          padding: PaddingPreset.md,
          display: Display.flex,
          flexDirection: FlexDirection.column,
          gap: Gap.sm,
        ),
        children: [Text('Core UI'), Text('Documentation'), Text('Templates')],
      ),
    ),
  );
}

Widget _buildPaginationDemo(DemoStateController state) {
  int page = state.intValue('pagination-page', initial: 2);
  return _surface(
    ArcanePagination(
      currentPage: page,
      totalPages: 8,
      onPageChange: (value) => state.setInt('pagination-page', value),
    ),
  );
}

Widget _buildPopoverDemo(DemoStateController state) {
  bool popoverOpen = state.boolValue('popover-open');
  return _surface(
    ArcanePopover(
      isOpen: popoverOpen,
      onOpenChange: (value) => state.setBool('popover-open', value),
      trigger: Button.secondary(label: 'Open popover', onPressed: () {}),
      content: const Text('Popover content'),
    ),
    minHeight: '180px',
  );
}

Widget _buildProgressDemo(DemoStateController state) {
  return _surface(
    _demoColumn(
      const ArcaneProgressBar(value: 68, showValue: true),
      const ArcaneProgressBar.success(value: 42),
    ),
  );
}

Widget _buildRadioGroupDemo(DemoStateController state) {
  String plan = state.stringValue('radio-plan', initial: 'starter');
  return _surface(
    ArcaneRadioGroup(
      value: plan,
      options: const [
        RadioOption(value: 'starter', label: 'Starter'),
        RadioOption(value: 'pro', label: 'Pro'),
        RadioOption(value: 'enterprise', label: 'Enterprise'),
      ],
      onChanged: (value) => state.setString('radio-plan', value),
    ),
  );
}

Widget _buildResizableDemo(DemoStateController state) {
  return _surface(
    ArcaneResizable.sidebarLayout(
      sidebar: const Card(child: Text('Sidebar')),
      content: const Card(child: Text('Main content')),
    ),
    minHeight: '220px',
  );
}

Widget _buildScrollAreaDemo(DemoStateController state) {
  return _surface(
    ArcaneScrollArea.vertical(
      height: '150px',
      child: ArcaneBox(
        style: const ArcaneStyleData(
          display: Display.flex,
          flexDirection: FlexDirection.column,
          gap: Gap.sm,
        ),
        children: const [
          Text('Row 1'),
          Text('Row 2'),
          Text('Row 3'),
          Text('Row 4'),
          Text('Row 5'),
          Text('Row 6'),
          Text('Row 7'),
        ],
      ),
    ),
  );
}

Widget _buildSelectDemo(DemoStateController state) {
  String plan = state.stringValue('select-plan', initial: 'pro');
  return _surface(
    ArcaneSelect(
      label: 'Plan',
      value: plan,
      options: const [
        ArcaneSelectOption(label: 'Starter', value: 'starter'),
        ArcaneSelectOption(label: 'Pro', value: 'pro'),
        ArcaneSelectOption(label: 'Enterprise', value: 'enterprise'),
      ],
      onChanged: (value) => state.setString('select-plan', value),
    ),
  );
}

Widget _buildSeparatorDemo(DemoStateController state) {
  return _surface(const ArcaneSeparator.withLabel(label: 'OR'));
}

Widget _buildSheetDemo(DemoStateController state) {
  bool sheetOpen = state.boolValue('sheet-open');
  return _surface(
    ArcaneBox(
      style: const ArcaneStyleData(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        alignItems: AlignItems.center,
        gap: Gap.sm,
      ),
      children: [
        Button.secondary(
          label: 'Open sheet',
          onPressed: () => state.setBool('sheet-open', true),
        ),
        ArcaneSheet.bottom(
          isOpen: sheetOpen,
          onClose: () => state.setBool('sheet-open', false),
          child: const Text('Sheet content'),
        ),
      ],
    ),
    minHeight: '220px',
  );
}

Widget _buildSidebarDemo(DemoStateController state) {
  return _surface(
    ArcaneSidebar(
      width: 240,
      showCollapseToggle: false,
      header: const Text('Workspace'),
      footer: const Text('v2.9'),
      children: const [
        ArcaneSidebarItem(label: 'Dashboard', selected: true),
        ArcaneSidebarItem(label: 'Projects'),
        ArcaneSidebarItem(label: 'Settings'),
      ],
    ),
    minHeight: '260px',
  );
}

Widget _buildSkeletonDemo(DemoStateController state) {
  return _surface(const ArcaneSkeletonCard());
}

Widget _buildSliderDemo(DemoStateController state) {
  double volume = state.doubleValue('slider-volume', initial: 42);
  return _surface(
    ArcaneSlider(
      label: 'Volume',
      value: volume,
      onChanged: (value) => state.setDouble('slider-volume', value),
    ),
  );
}

Widget _buildSonnerDemo(DemoStateController state) {
  return _surface(
    ArcaneBox(
      style: const ArcaneStyleData(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.sm,
      ),
      children: [
        const ArcaneSonner(position: ToastPosition.topRight),
        Button.secondary(
          label: 'Show toast',
          onPressed: () {
            ArcaneSonner.success(
              'Sonner-compatible toast stack',
              title: 'Notification',
            );
          },
        ),
      ],
    ),
    minHeight: '180px',
  );
}

Widget _buildSpinnerDemo(DemoStateController state) {
  return _surface(
    _demoRow(const ArcaneSpinner(), const Text.body('Loading workspace')),
  );
}

Widget _buildSwitchDemo(DemoStateController state) {
  bool syncEnabled = state.boolValue('switch-sync', initial: true);
  return _surface(
    ArcaneToggleSwitch(
      value: syncEnabled,
      label: 'Enable sync',
      onChanged: (value) => state.setBool('switch-sync', value),
    ),
  );
}

Widget _buildTableDemo(DemoStateController state) {
  return _surface(
    StaticTable(
      headers: const ['Name', 'Role'],
      rows: const [
        [Text('Alex'), Text('Admin')],
        [Text('Sam'), Text('Editor')],
        [Text('Rae'), Text('Viewer')],
      ],
    ),
    minHeight: '220px',
  );
}

Widget _buildTabsDemo(DemoStateController state) {
  return _surface(
    ArcaneTabs(
      tabs: const [
        ArcaneTabItem(label: 'Account', content: Text('Account tab content')),
        ArcaneTabItem(label: 'Billing', content: Text('Billing tab content')),
      ],
    ),
  );
}

Widget _buildTextareaDemo(DemoStateController state) {
  String message = state.stringValue('textarea-message');
  return _surface(
    TextArea(
      label: 'Message',
      placeholder: 'Type your message',
      rows: 4,
      value: message,
      onChanged: (value) => state.setString('textarea-message', value),
    ),
  );
}

Widget _buildToggleDemo(DemoStateController state) {
  bool boldEnabled = state.boolValue('toggle-bold', initial: true);
  return _surface(
    ArcaneToggleButton(
      value: boldEnabled,
      label: 'Bold',
      onChanged: (value) => state.setBool('toggle-bold', value),
    ),
  );
}

Widget _buildToggleGroupDemo(DemoStateController state) {
  String alignment = state.stringValue('toggle-alignment', initial: 'left');
  return _surface(
    ArcaneToggleGroup(
      value: alignment,
      items: [
        ToggleGroupItem.text('left', label: 'Left'),
        ToggleGroupItem.text('center', label: 'Center'),
        ToggleGroupItem.text('right', label: 'Right'),
      ],
      onChanged: (value) {
        if (value != null) {
          state.setString('toggle-alignment', value);
        }
      },
    ),
  );
}

Widget _buildTooltipDemo(DemoStateController state) {
  return _surface(
    ArcaneTooltip(
      text: 'This is a tooltip',
      child: Button.secondary(label: 'Hover target', onPressed: () {}),
    ),
  );
}

Widget _buildTypographyDemo(DemoStateController state) {
  return _surface(
    ArcaneBox(
      style: const ArcaneStyleData(
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.sm,
      ),
      children: [
        const Text.heading2('Typography Preview'),
        const Text.body('Readable hierarchy and spacing.'),
      ],
    ),
  );
}

Widget _buildStylingDemo(DemoStateController state) {
  bool elevated = state.boolValue('styling-elevated', initial: true);
  return _surface(
    ArcaneBox(
      style: ArcaneStyleData(
        width: Size.full,
        maxWidthCustom: '520px',
        padding: PaddingPreset.lg,
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.md,
        background: Background.surface,
        border: BorderPreset.standard,
        borderRadius: Radius.md,
        shadow: elevated ? Shadow.md : Shadow.none,
      ),
      children: [
        const ArcaneStatusBadge.info('Live stylesheet'),
        const Text.heading3('Renderer-owned styling'),
        const Text.body(
          'Swap stylesheet, palette, or theme without changing this widget.',
        ),
        _demoRow(
          Button.primary(label: 'Primary action', onPressed: () {}),
          Button.secondary(
            label: elevated ? 'Flatten' : 'Raise',
            onPressed: () =>
                state.toggleBool('styling-elevated', initial: true),
          ),
        ),
      ],
    ),
    minHeight: '300px',
  );
}

Widget _buildTokensDemo(DemoStateController state) {
  return _surface(
    ArcaneBox(
      style: const ArcaneStyleData(
        width: Size.full,
        maxWidthCustom: '520px',
        padding: PaddingPreset.lg,
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.md,
        background: Background.surface,
        border: BorderPreset.standard,
        borderRadius: Radius.md,
      ),
      children: [
        const Text.heading3('Token-driven surface'),
        const Text.body(
          'The same tokens resolve through the active stylesheet and palette.',
        ),
        _demoRow(
          const ArcaneStatusBadge.primary('Primary'),
          const ArcaneStatusBadge.success('Success'),
          const ArcaneStatusBadge.warning('Warning'),
        ),
        _demoRow(
          Button.primary(label: 'Confirm', onPressed: () {}),
          Button.secondary(label: 'Cancel', onPressed: () {}),
        ),
      ],
    ),
    minHeight: '300px',
  );
}

Widget _buildThemingDemo(DemoStateController state) {
  return _surface(
    ArcaneBox(
      style: const ArcaneStyleData(
        width: Size.full,
        maxWidthCustom: '500px',
        padding: PaddingPreset.lg,
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.md,
        background: Background.card,
        border: BorderPreset.accent,
        borderRadius: Radius.md,
        shadow: Shadow.sm,
      ),
      children: [
        const Text.heading3('Theme-owned controls'),
        const Text.body(
          'Buttons, badges, and surfaces inherit the active renderer.',
        ),
        _demoRow(
          Button.primary(label: 'Primary', onPressed: () {}),
          Button.secondary(label: 'Secondary', onPressed: () {}),
        ),
      ],
    ),
    minHeight: '280px',
  );
}

Widget _buildAliasesDemo(DemoStateController state) {
  return _surface(
    ArcaneBox(
      style: const ArcaneStyleData(
        width: Size.full,
        maxWidthCustom: '460px',
        padding: PaddingPreset.lg,
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.sm,
        background: Background.backgroundSecondary,
        border: BorderPreset.subtle,
        borderRadius: Radius.md,
      ),
      children: [
        const Text.heading3('Widget aliases'),
        const Text.body('Compose layout with the same surface primitives.'),
        _demoRow(
          Button.primary(label: 'Save', onPressed: () {}),
          Button.secondary(label: 'Cancel', onPressed: () {}),
        ),
      ],
    ),
    minHeight: '260px',
  );
}

Widget _buildBordersDemo(DemoStateController state) {
  return _surface(
    _demoRow(
      _styleTile('Subtle', BorderPreset.subtle, Radius.sm, Shadow.none),
      _styleTile('Accent', BorderPreset.accentThick, Radius.md, Shadow.sm),
      _styleTile(
        'Dashed',
        BorderPreset.dashedStandard,
        Radius.none,
        Shadow.none,
      ),
    ),
    minHeight: '240px',
  );
}

Widget _buildColorsDemo(DemoStateController state) {
  return _surface(
    _demoRow(
      _colorTile('Surface', Background.surface),
      _colorTile('Primary', Background.primary),
      _colorTile('Info', Background.info),
    ),
    minHeight: '240px',
  );
}

Widget _buildDisplayDemo(DemoStateController state) {
  return _surface(
    ArcaneBox(
      style: const ArcaneStyleData(
        width: Size.full,
        maxWidthCustom: '520px',
        padding: PaddingPreset.lg,
        display: Display.flex,
        flexWrap: FlexWrap.wrap,
        alignItems: AlignItems.center,
        justifyContent: JustifyContent.center,
        gap: Gap.sm,
        background: Background.surface,
        border: BorderPreset.standard,
        borderRadius: Radius.md,
      ),
      children: const [
        ArcaneStatusBadge.secondary('Wrap'),
        ArcaneStatusBadge.secondary('Align'),
        ArcaneStatusBadge.secondary('Justify'),
        ArcaneStatusBadge.secondary('Gap'),
      ],
    ),
    minHeight: '220px',
  );
}

Widget _buildEffectsDemo(DemoStateController state) {
  bool elevated = state.boolValue('effects-elevated', initial: true);
  return _surface(
    ArcaneBox(
      style: ArcaneStyleData(
        width: Size.full,
        maxWidthCustom: '460px',
        padding: PaddingPreset.lg,
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.md,
        background: Background.surface,
        border: BorderPreset.standard,
        borderRadius: Radius.md,
        shadow: elevated ? Shadow.lg : Shadow.md,
      ),
      children: [
        const Text.heading3('Theme effects'),
        const Text.body('Effects remain tied to the active stylesheet.'),
        Button.secondary(
          label: elevated ? 'Reduce elevation' : 'Increase elevation',
          onPressed: () => state.toggleBool('effects-elevated', initial: true),
        ),
      ],
    ),
    minHeight: '300px',
  );
}

Widget _buildSpacingDemo(DemoStateController state) {
  return _surface(
    ArcaneBox(
      style: const ArcaneStyleData(
        width: Size.full,
        maxWidthCustom: '420px',
        padding: PaddingPreset.lg,
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.md,
        background: Background.surface,
        border: BorderPreset.standard,
        borderRadius: Radius.md,
      ),
      children: [
        Button.primary(label: 'First action', onPressed: () {}),
        Button.secondary(label: 'Second action', onPressed: () {}),
        Button.ghost(label: 'Quiet action', onPressed: () {}),
      ],
    ),
    minHeight: '300px',
  );
}

Widget _buildTypographyStylesDemo(DemoStateController state) {
  return _surface(
    ArcaneBox(
      style: const ArcaneStyleData(
        width: Size.full,
        maxWidthCustom: '500px',
        padding: PaddingPreset.lg,
        display: Display.flex,
        flexDirection: FlexDirection.column,
        gap: Gap.sm,
        background: Background.surface,
        border: BorderPreset.standard,
        borderRadius: Radius.md,
      ),
      children: const [
        Text.heading2('Heading'),
        Text.subheading('Subheading'),
        Text.body('Body copy adapts per stylesheet without page-specific CSS.'),
        Text.bodySmall('Small copy and captions keep their hierarchy.'),
      ],
    ),
    minHeight: '300px',
  );
}

Widget _styleTile(
  String label,
  BorderPreset border,
  Radius radius,
  Shadow shadow,
) {
  return ArcaneBox(
    style: ArcaneStyleData(
      minWidth: '120px',
      padding: PaddingPreset.lg,
      display: Display.flex,
      alignItems: AlignItems.center,
      justifyContent: JustifyContent.center,
      background: Background.surface,
      border: border,
      borderRadius: radius,
      shadow: shadow,
    ),
    children: [Text.body(label)],
  );
}

Widget _colorTile(String label, Background background) {
  return ArcaneBox(
    style: ArcaneStyleData(
      minWidth: '120px',
      padding: PaddingPreset.lg,
      display: Display.flex,
      alignItems: AlignItems.center,
      justifyContent: JustifyContent.center,
      background: background,
      border: BorderPreset.standard,
      borderRadius: Radius.md,
    ),
    children: [Text.body(label, color: TextColor.primary)],
  );
}

Widget _demoRow(Widget first, [Widget? second, Widget? third]) => ArcaneBox(
  style: const ArcaneStyleData(
    display: Display.flex,
    alignItems: AlignItems.center,
    justifyContent: JustifyContent.center,
    flexWrap: FlexWrap.wrap,
    gap: Gap.sm,
  ),
  children: [first, ?second, ?third],
);

Widget _demoColumn(Widget first, [Widget? second, Widget? third]) => ArcaneBox(
  style: const ArcaneStyleData(
    display: Display.flex,
    flexDirection: FlexDirection.column,
    gap: Gap.sm,
    width: Size.full,
    maxWidthCustom: '420px',
  ),
  children: [first, ?second, ?third],
);

Widget _surface(Widget child, {String minHeight = '140px'}) {
  return ArcaneBox(
    style: ArcaneStyleData(
      padding: PaddingPreset.lg,
      border: BorderPreset.subtle,
      borderRadius: Radius.md,
      background: Background.backgroundSecondary,
      minHeight: minHeight,
      display: Display.flex,
      alignItems: AlignItems.center,
      justifyContent: JustifyContent.center,
    ),
    children: [child],
  );
}

class _DemoUser {
  final String name;
  final String role;
  final String status;

  const _DemoUser({
    required this.name,
    required this.role,
    required this.status,
  });
}
