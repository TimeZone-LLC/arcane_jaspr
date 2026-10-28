import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart' as dom;

import 'package:arcane_jaspr/core/renderers.dart';
import 'package:arcane_jaspr_neubrutalism/src/neubrutalism_variant.dart';

// Neubrutalism-specific renderer imports
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

/// Square outlines, hard shadows, and paper surfaces for Classic and NeuComic.
class NeubrutalismRenderers extends ComponentRenderers
    with TextAreaRendererContract {
  final NeubrutalismVariant variant;

  const NeubrutalismRenderers({this.variant = NeubrutalismVariant.classic});

  @override
  Component button(ButtonProps props) => NeubrutalismButton(props);

  @override
  Component textInput(TextInputProps props) => NeubrutalismTextInput(props);

  @override
  Component textArea(TextAreaProps props) => NeubrutalismTextArea(props);

  @override
  Component card(CardProps props) => NeubrutalismCard(props);

  @override
  Component gallery(GalleryProps props) =>
      NeubrutalismGallery(props, variant: variant);

  @override
  Component statCard(StatCardProps props) => NeubrutalismStatCard(props);

  @override
  Component statCardRow(StatCardRowProps props) =>
      NeubrutalismStatCardRow(props);

  @override
  Component featureCard(FeatureCardProps props) =>
      NeubrutalismFeatureCard(props);

  @override
  Component iconCard(IconCardProps props) => NeubrutalismIconCard(props);

  @override
  Component ctaCard(CTACardProps props) => NeubrutalismCtaCard(props);

  @override
  Component testimonialCard(TestimonialCardProps props) =>
      NeubrutalismTestimonialCard(props);

  @override
  Component ratingStarsSimple(RatingStarsSimpleProps props) =>
      NeubrutalismRatingStarsSimple(props);

  @override
  Component pricingCard(PricingCardProps props) =>
      NeubrutalismPricingCard(props);

  @override
  Component pricingGrid(PricingGridProps props) =>
      NeubrutalismPricingGrid(props);

  @override
  Component chart(ChartProps props) => NeubrutalismChart(props);

  @override
  Component alert(AlertProps props) => NeubrutalismAlert(props);

  @override
  Component avatar(AvatarProps props) => NeubrutalismAvatar(props);

  @override
  Component progress(ProgressProps props) => NeubrutalismProgress(props);

  @override
  Component circularProgress(CircularProgressProps props) =>
      NeubrutalismCircularProgress(props);

  @override
  Component loadingSpinner(LoadingSpinnerProps props) =>
      NeubrutalismLoadingSpinner(props);

  @override
  Component skeleton(SkeletonProps props) => NeubrutalismSkeleton(props);

  @override
  Component checkbox(CheckboxProps props) => NeubrutalismCheckbox(props);

  @override
  Component toggleSwitch(ToggleSwitchProps props) =>
      NeubrutalismToggleSwitch(props);

  @override
  Component slider(SliderProps props) => NeubrutalismSlider(props);

  @override
  Component tabs(TabsProps props) => NeubrutalismTabs(props);

  @override
  Component tabBar(TabBarProps props) => NeubrutalismTabBar(props);

  @override
  Component breadcrumbs(BreadcrumbsProps props) =>
      NeubrutalismBreadcrumbs(props);

  @override
  Component sidebar(SidebarProps props) => NeubrutalismSidebar(props);

  @override
  Component sidebarItem(SidebarItemProps props) =>
      NeubrutalismSidebarItem(props);

  @override
  Component sidebarGroup(SidebarGroupProps props) =>
      NeubrutalismSidebarGroup(props);

  @override
  Component sidebarSubMenu(SidebarSubMenuProps props) =>
      NeubrutalismSidebarSubMenu(props);

  @override
  Component sidebarSection(SidebarSectionProps props) =>
      NeubrutalismSidebarSection(props);

  @override
  Component sidebarExpanded(List<Component> children) => dom.div(
    classes: 'neubrutalism-sidebar-expanded-only',
    styles: const dom.Styles(
      raw: <String, String>{
        'display': 'var(--sidebar-expanded-display, block)',
      },
    ),
    children,
  );

  @override
  Component sidebarCollapsed(List<Component> children) => dom.div(
    classes: 'neubrutalism-sidebar-collapsed-only',
    styles: const dom.Styles(
      raw: <String, String>{
        'display': 'var(--sidebar-collapsed-display, none)',
      },
    ),
    children,
  );

  @override
  Component sidebarSeparator() => const NeubrutalismSidebarSeparator();

  @override
  Component dialog(DialogProps props) => NeubrutalismDialog(props);

  @override
  Component sheet(SheetProps props) => NeubrutalismSheet(props);

  @override
  Component drawer(DrawerProps props) => NeubrutalismDrawer(props);

  @override
  Component toast(ToastProps props) => NeubrutalismToast(props);

  @override
  Component toastContainer(ToastContainerProps props) =>
      NeubrutalismToastContainer(props);

  @override
  Component floating(FloatingProps props) => NeubrutalismFloating(props);

  @override
  Component radioGroup<T>(RadioGroupProps<T> props) =>
      NeubrutalismRadioGroup<T>(props);

  @override
  Component select<T>(SelectProps<T> props) => NeubrutalismSelect<T>(props);

  @override
  Component separator(SeparatorProps props) => NeubrutalismSeparator(props);

  @override
  Component accordion(AccordionProps props) => NeubrutalismAccordion(props);

  @override
  Component pagination(PaginationProps props) => NeubrutalismPagination(props);

  @override
  Component emptyState(EmptyStateProps props) => NeubrutalismEmptyState(props);

  @override
  Component statusBadge(StatusBadgeProps props) =>
      NeubrutalismStatusBadge(props);

  @override
  Component row(RowProps props) => NeubrutalismRow(props);

  @override
  Component column(ColumnProps props) => NeubrutalismColumn(props);

  @override
  Component center(CenterProps props) => NeubrutalismCenter(props);

  @override
  Component spacer(SpacerProps props) => NeubrutalismSpacer(props);

  @override
  Component expanded(ExpandedProps props) => NeubrutalismExpanded(props);

  @override
  Component sizedBox(SizedBoxProps props) => NeubrutalismSizedBox(props);

  @override
  Component flow(FlowProps props) => NeubrutalismFlow(props);

  @override
  Component direction(DirectionProps props) => NeubrutalismDirection(props);

  @override
  Component gap(GapProps props) => NeubrutalismGap(props);

  @override
  Component buttonPanel(ButtonPanelProps props) =>
      NeubrutalismButtonPanel(props);

  @override
  Component toolbar(ToolbarProps props) => NeubrutalismToolbar(props);

  @override
  Component buttonGroup(ButtonGroupProps props) =>
      NeubrutalismButtonGroup(props);

  @override
  Component aspectRatio(AspectRatioProps props) =>
      NeubrutalismAspectRatio(props);

  @override
  Component gutter(GutterProps props) => NeubrutalismGutter(props);

  @override
  Component paddingWrapper(PaddingWrapperProps props) =>
      NeubrutalismPaddingWrapper(props);

  @override
  Component fieldWrapper(FieldWrapperProps props) =>
      NeubrutalismFieldWrapper(props);

  @override
  Component formSection(FormSectionProps props) =>
      NeubrutalismFormSection(props);

  @override
  Component form(FormProps props) => NeubrutalismForm(props);

  @override
  Component inputGroup(InputGroupProps props) => NeubrutalismInputGroup(props);

  @override
  Component resizable(ResizableProps props) => NeubrutalismResizable(props);

  @override
  Component item(ItemProps props) => NeubrutalismItem(props);

  @override
  Component flexiCards(FlexiCardsProps props) => NeubrutalismFlexiCards(props);

  @override
  Component flexiCardsSimple(FlexiCardsSimpleProps props) =>
      NeubrutalismFlexiCardsSimple(props);

  @override
  Component checkItem(CheckItemProps props) => NeubrutalismCheckItem(props);

  @override
  Component checkList(CheckListProps props) => NeubrutalismCheckList(props);

  @override
  Component featureRow(FeatureRowProps props) => NeubrutalismFeatureRow(props);

  @override
  Component specRow(SpecRowProps props) => NeubrutalismSpecRow(props);

  @override
  Component calendar(CalendarProps props) => NeubrutalismCalendar(props);

  @override
  Component command(CommandProps props) => NeubrutalismCommand(props);

  @override
  Component confirmDialog(ConfirmDialogProps props) =>
      NeubrutalismConfirmDialog(props);

  @override
  Component alertDialog(AlertDialogProps props) =>
      NeubrutalismAlertDialog(props);

  @override
  Component contextMenu(ContextMenuProps props) =>
      NeubrutalismContextMenu(props);

  @override
  Component cycleButton<T>(CycleButtonProps<T> props) =>
      NeubrutalismCycleButton<T>(props);

  @override
  Component toggleButton(ToggleButtonProps props) =>
      NeubrutalismToggleButton(props);

  @override
  Component dataTable<T>(DataTableProps<T> props) =>
      NeubrutalismDataTable<T>(props);

  @override
  Component datePicker(DatePickerProps props) => NeubrutalismDatePicker(props);

  @override
  Component disclosure(DisclosureProps props) => NeubrutalismDisclosure(props);

  @override
  Component disclosureGroup(DisclosureGroupProps props) =>
      NeubrutalismDisclosureGroup(props);

  @override
  Component dropdownMenu(DropdownMenuProps props) =>
      NeubrutalismDropdownMenu(props);

  @override
  Component kbd(KbdProps props) => NeubrutalismKbd(props);

  @override
  Component menubar(MenubarProps props) => NeubrutalismMenubar(props);

  @override
  Component nativeSelect(NativeSelectProps props) =>
      NeubrutalismNativeSelect(props);

  @override
  Component otpInput(OtpInputProps props) => NeubrutalismOtpInput(props);

  @override
  Component scrollArea(ScrollAreaProps props) => NeubrutalismScrollArea(props);

  @override
  Component scrollRail(ScrollRailProps props) => NeubrutalismScrollRail(props);

  @override
  Component scrollRailLayout(ScrollRailLayoutProps props) =>
      NeubrutalismScrollRailLayout(props);

  @override
  Component virtualScroll<T>(VirtualScrollProps<T> props) =>
      NeubrutalismVirtualScroll<T>(props);

  @override
  Component slotCounter(SlotCounterProps props) =>
      NeubrutalismSlotCounter(props);

  @override
  Component slotCounterRow(SlotCounterRowProps props) =>
      NeubrutalismSlotCounterRow(props);

  @override
  Component slotCounterCard(SlotCounterCardProps props) =>
      NeubrutalismSlotCounterCard(props);

  @override
  Component staticTable(StaticTableProps props) =>
      NeubrutalismStaticTable(props);

  @override
  Component keyValueTable(KeyValueTableProps props) =>
      NeubrutalismKeyValueTable(props);

  @override
  Component timePicker(TimePickerProps props) => NeubrutalismTimePicker(props);

  @override
  Component toggleGroup(ToggleGroupProps props) =>
      NeubrutalismToggleGroup(props);

  @override
  Component topAnnouncementBar(TopAnnouncementBarProps props) =>
      NeubrutalismTopAnnouncementBar(props);

  @override
  Component inlineHeroBanner(InlineHeroBannerProps props) =>
      NeubrutalismInlineHeroBanner(props);
}
