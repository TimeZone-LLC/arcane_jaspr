import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/renderers.dart';

// Win95-specific renderer imports
import 'accordion.dart';
import 'alert.dart';
import 'aspect_ratio.dart';
import 'avatar.dart';
import 'breadcrumbs.dart';
import 'button.dart';
import 'button_panel.dart';
import 'calendar.dart';
import 'card.dart';
import 'cta_card.dart';
import 'feature_card.dart';
import 'pricing_card.dart';
import 'gallery.dart';
import 'stat_card.dart';
import 'testimonial_card.dart';
import 'chart.dart';
import 'check_list.dart';
import 'checkbox.dart';
import 'command.dart';
import 'confirm_dialog.dart';
import 'context_menu.dart';
import 'cycle_button.dart';
import 'data_table.dart';
import 'date_picker.dart';
import 'direction.dart';
import 'dialog.dart';
import 'disclosure.dart';
import 'dropdown_menu.dart';
import 'drawer.dart';
import 'empty_state.dart';
import 'field_wrapper.dart';
import 'flexi_cards.dart';
import 'floating.dart';
import 'flow.dart';
import 'form.dart';
import 'gutter.dart';
import 'item.dart';
import 'kbd.dart';
import 'menubar.dart';
import 'native_select.dart';
import 'otp_input.dart';
import 'pagination.dart';
import 'progress.dart';
import 'radio_group.dart';
import 'resizable.dart';
import 'scroll_area.dart';
import 'scroll_rail.dart';
import 'select.dart';
import 'separator.dart';
import 'sidebar.dart';
import 'slider.dart';
import 'slot_counter.dart';
import 'spec_row.dart';
import 'static_table.dart';
import 'status_badge.dart';
import 'tabs.dart';
import 'text_area.dart';
import 'text_input.dart';
import 'time_picker.dart';
import 'toast.dart';
import 'toggle_group.dart';
import 'toggle_switch.dart';
import 'skeleton.dart';
import 'promo/promo.dart';

/// Win95 component renderers.
///
/// Implements all components according to the Windows 95 design language:
/// - Silver control faces with hard 1px layered bevels (raised, pressed,
///   sunken and window frame), never blurred shadows
/// - Square corners everywhere; the radio is a 12x12 bitmap circle
/// - Solid navy title bars and selection, drawn pixel-art glyphs and cursors
/// - No motion: every state change lands in a single repaint
/// - A dimmed "dark silver" scheme that re-points the same bevel tokens
///
/// Most renderers emit semantic `win95-*` classes with neutral inline styles
/// and leave the look to the Win95 stylesheet.
class Win95Renderers extends ComponentRenderers with TextAreaRendererContract {
  const Win95Renderers();

  @override
  Component button(ButtonProps props) => Win95Button(props);

  @override
  Component textInput(TextInputProps props) => Win95TextInput(props);

  @override
  Component textArea(TextAreaProps props) => Win95TextArea(props);

  @override
  Component card(CardProps props) => Win95Card(props);

  @override
  Component gallery(GalleryProps props) => Win95Gallery(props);

  @override
  Component statCard(StatCardProps props) => Win95StatCard(props);

  @override
  Component statCardRow(StatCardRowProps props) => Win95StatCardRow(props);

  @override
  Component featureCard(FeatureCardProps props) => Win95FeatureCard(props);

  @override
  Component iconCard(IconCardProps props) => Win95IconCard(props);

  @override
  Component ctaCard(CTACardProps props) => Win95CtaCard(props);

  @override
  Component testimonialCard(TestimonialCardProps props) =>
      Win95TestimonialCard(props);

  @override
  Component ratingStarsSimple(RatingStarsSimpleProps props) =>
      Win95RatingStarsSimple(props);

  @override
  Component pricingCard(PricingCardProps props) => Win95PricingCard(props);

  @override
  Component pricingGrid(PricingGridProps props) => Win95PricingGrid(props);

  @override
  Component chart(ChartProps props) => Win95Chart(props);

  @override
  Component alert(AlertProps props) => Win95Alert(props);

  @override
  Component avatar(AvatarProps props) => Win95Avatar(props);

  @override
  Component progress(ProgressProps props) => Win95Progress(props);

  @override
  Component circularProgress(CircularProgressProps props) =>
      Win95CircularProgress(props);

  @override
  Component loadingSpinner(LoadingSpinnerProps props) =>
      Win95LoadingSpinner(props);

  @override
  Component skeleton(SkeletonProps props) => Win95Skeleton(props);

  @override
  Component checkbox(CheckboxProps props) => Win95Checkbox(props);

  @override
  Component toggleSwitch(ToggleSwitchProps props) => Win95ToggleSwitch(props);

  @override
  Component slider(SliderProps props) => Win95Slider(props);

  @override
  Component tabs(TabsProps props) => Win95Tabs(props);

  @override
  Component tabBar(TabBarProps props) => Win95TabBar(props);

  @override
  Component breadcrumbs(BreadcrumbsProps props) => Win95Breadcrumbs(props);

  @override
  Component sidebar(SidebarProps props) => Win95Sidebar(props);

  @override
  Component sidebarItem(SidebarItemProps props) => Win95SidebarItem(props);

  @override
  Component sidebarGroup(SidebarGroupProps props) => Win95SidebarGroup(props);

  @override
  Component sidebarSubMenu(SidebarSubMenuProps props) =>
      Win95SidebarSubMenu(props);

  @override
  Component sidebarSection(SidebarSectionProps props) =>
      Win95SidebarSection(props);

  @override
  Component sidebarExpanded(List<Component> children) => dom.div(
    classes: 'win95-sidebar-expanded-only',
    styles: const dom.Styles(
      raw: <String, String>{
        'display': 'var(--sidebar-expanded-display, block)',
      },
    ),
    children,
  );

  @override
  Component sidebarCollapsed(List<Component> children) => dom.div(
    classes: 'win95-sidebar-collapsed-only',
    styles: const dom.Styles(
      raw: <String, String>{
        'display': 'var(--sidebar-collapsed-display, none)',
      },
    ),
    children,
  );

  @override
  Component sidebarSeparator() => const Win95SidebarSeparator();

  @override
  Component dialog(DialogProps props) => Win95Dialog(props);

  @override
  Component sheet(SheetProps props) => Win95Sheet(props);

  @override
  Component drawer(DrawerProps props) => Win95Drawer(props);

  @override
  Component toast(ToastProps props) => Win95Toast(props);

  @override
  Component toastContainer(ToastContainerProps props) =>
      Win95ToastContainer(props);

  @override
  Component floating(FloatingProps props) => Win95Floating(props);

  @override
  Component radioGroup<T>(RadioGroupProps<T> props) =>
      Win95RadioGroup<T>(props);

  @override
  Component select<T>(SelectProps<T> props) => Win95Select<T>(props);

  @override
  Component separator(SeparatorProps props) => Win95Separator(props);

  @override
  Component accordion(AccordionProps props) => Win95Accordion(props);

  @override
  Component pagination(PaginationProps props) => Win95Pagination(props);

  @override
  Component emptyState(EmptyStateProps props) => Win95EmptyState(props);

  @override
  Component statusBadge(StatusBadgeProps props) => Win95StatusBadge(props);

  @override
  Component row(RowProps props) => Win95Row(props);

  @override
  Component column(ColumnProps props) => Win95Column(props);

  @override
  Component center(CenterProps props) => Win95Center(props);

  @override
  Component spacer(SpacerProps props) => Win95Spacer(props);

  @override
  Component expanded(ExpandedProps props) => Win95Expanded(props);

  @override
  Component sizedBox(SizedBoxProps props) => Win95SizedBox(props);

  @override
  Component flow(FlowProps props) => Win95Flow(props);

  @override
  Component direction(DirectionProps props) => Win95Direction(props);

  @override
  Component gap(GapProps props) => Win95Gap(props);

  @override
  Component buttonPanel(ButtonPanelProps props) => Win95ButtonPanel(props);

  @override
  Component toolbar(ToolbarProps props) => Win95Toolbar(props);

  @override
  Component buttonGroup(ButtonGroupProps props) => Win95ButtonGroup(props);

  @override
  Component aspectRatio(AspectRatioProps props) => Win95AspectRatio(props);

  @override
  Component gutter(GutterProps props) => Win95Gutter(props);

  @override
  Component paddingWrapper(PaddingWrapperProps props) =>
      Win95PaddingWrapper(props);

  @override
  Component fieldWrapper(FieldWrapperProps props) => Win95FieldWrapper(props);

  @override
  Component formSection(FormSectionProps props) => Win95FormSection(props);

  @override
  Component form(FormProps props) => Win95Form(props);

  @override
  Component inputGroup(InputGroupProps props) => Win95InputGroup(props);

  @override
  Component resizable(ResizableProps props) => Win95Resizable(props);

  @override
  Component item(ItemProps props) => Win95Item(props);

  @override
  Component flexiCards(FlexiCardsProps props) => Win95FlexiCards(props);

  @override
  Component flexiCardsSimple(FlexiCardsSimpleProps props) =>
      Win95FlexiCardsSimple(props);

  @override
  Component checkItem(CheckItemProps props) => Win95CheckItem(props);

  @override
  Component checkList(CheckListProps props) => Win95CheckList(props);

  @override
  Component featureRow(FeatureRowProps props) => Win95FeatureRow(props);

  @override
  Component specRow(SpecRowProps props) => Win95SpecRow(props);

  @override
  Component calendar(CalendarProps props) => Win95Calendar(props);

  @override
  Component command(CommandProps props) => Win95Command(props);

  @override
  Component confirmDialog(ConfirmDialogProps props) =>
      Win95ConfirmDialog(props);

  @override
  Component alertDialog(AlertDialogProps props) => Win95AlertDialog(props);

  @override
  Component contextMenu(ContextMenuProps props) => Win95ContextMenu(props);

  @override
  Component cycleButton<T>(CycleButtonProps<T> props) =>
      Win95CycleButton<T>(props);

  @override
  Component toggleButton(ToggleButtonProps props) => Win95ToggleButton(props);

  @override
  Component dataTable<T>(DataTableProps<T> props) => Win95DataTable<T>(props);

  @override
  Component datePicker(DatePickerProps props) => Win95DatePicker(props);

  @override
  Component disclosure(DisclosureProps props) => Win95Disclosure(props);

  @override
  Component disclosureGroup(DisclosureGroupProps props) =>
      Win95DisclosureGroup(props);

  @override
  Component dropdownMenu(DropdownMenuProps props) => Win95DropdownMenu(props);

  @override
  Component kbd(KbdProps props) => Win95Kbd(props);

  @override
  Component menubar(MenubarProps props) => Win95Menubar(props);

  @override
  Component nativeSelect(NativeSelectProps props) => Win95NativeSelect(props);

  @override
  Component otpInput(OtpInputProps props) => Win95OtpInput(props);

  @override
  Component scrollArea(ScrollAreaProps props) => Win95ScrollArea(props);

  @override
  Component scrollRail(ScrollRailProps props) => Win95ScrollRail(props);

  @override
  Component scrollRailLayout(ScrollRailLayoutProps props) =>
      Win95ScrollRailLayout(props);

  @override
  Component virtualScroll<T>(VirtualScrollProps<T> props) =>
      Win95VirtualScroll<T>(props);

  @override
  Component slotCounter(SlotCounterProps props) => Win95SlotCounter(props);

  @override
  Component slotCounterRow(SlotCounterRowProps props) =>
      Win95SlotCounterRow(props);

  @override
  Component slotCounterCard(SlotCounterCardProps props) =>
      Win95SlotCounterCard(props);

  @override
  Component staticTable(StaticTableProps props) => Win95StaticTable(props);

  @override
  Component keyValueTable(KeyValueTableProps props) =>
      Win95KeyValueTable(props);

  @override
  Component timePicker(TimePickerProps props) => Win95TimePicker(props);

  @override
  Component toggleGroup(ToggleGroupProps props) => Win95ToggleGroup(props);

  @override
  Component topAnnouncementBar(TopAnnouncementBarProps props) =>
      Win95TopAnnouncementBar(props);

  @override
  Component inlineHeroBanner(InlineHeroBannerProps props) =>
      Win95InlineHeroBanner(props);
}
