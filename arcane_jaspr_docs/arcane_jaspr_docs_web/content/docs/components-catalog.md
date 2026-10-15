---
title: Component Catalog
description: Generated Arcane Jaspr surface catalog for the Flutter-first primary import and advanced HTML escape hatch
layout: kb
---

# Component Catalog

This page combines the live demo registry with the current `package:arcane_jaspr/arcane_jaspr.dart` and `package:arcane_jaspr/html.dart` exports. Try every live example in the [Ascii component lab](/ascii#component-lab); examples outside the primary import include their module import.

## Snapshot

- Generated on `October 14, 2026`
- Live component demos: `83`
- Primary support component modules: `50`
- Main-surface foundation exports: `24`
- Total main-surface export modules: `138`
- Advanced HTML modules: `22`

Use `package:arcane_jaspr/arcane_jaspr.dart` for the Flutter-first surface. Use `package:arcane_jaspr/html.dart` and `package:arcane_jaspr/web.dart` only when you intentionally need lower-level HTML or raw Jaspr escape hatches.

## Live Components (83)

| Component | Symbol | Source |
|---|---|---|
| `accordion` | `ArcaneAccordion` | `lib/component/interactive/accordion.dart` |
| `alert` | `ArcaneAlert` | `lib/component/view/alert.dart` |
| `alert-dialog` | `ArcaneAlertDialog` | `lib/component/dialog/confirm.dart` |
| `aspect-ratio` | `ArcaneAspectRatio` | `lib/component/layout/aspect_ratio.dart` |
| `avatar` | `ArcaneAvatar` | `lib/component/view/avatar.dart` |
| `badge` | `ArcaneStatusBadge` | `lib/component/feedback/status_badge.dart` |
| `breadcrumb` | `ArcaneBreadcrumbs` | `lib/component/navigation/breadcrumbs.dart` |
| `button` | `Button` | `lib/component/input/button.dart` |
| `button-group` | `ButtonGroup` | `lib/component/layout/button_panel.dart` |
| `calendar` | `ArcaneCalendar` | `lib/component/input/calendar.dart` |
| `card` | `Card` | `lib/component/card/card.dart` |
| `carousel` | `CardCarousel` | `lib/component/collection/card_carousel.dart` |
| `chart` | `ArcaneChart` | `lib/component/data/chart.dart` |
| `checkbox` | `ArcaneCheckbox` | `lib/component/input/checkbox.dart` |
| `collapsible` | `ArcaneDisclosure` | `lib/component/interactive/disclosure.dart` |
| `combobox` | `ArcaneCombobox` | `lib/component/input/combobox.dart` |
| `command` | `ArcaneCommand` | `lib/component/dialog/command.dart` |
| `context-menu` | `ArcaneContextMenu` | `lib/component/menu/context_menu.dart` |
| `data-table` | `DataTable` | `lib/component/view/data_table.dart` |
| `date-picker` | `ArcaneDatePicker` | `lib/component/input/date_picker.dart` |
| `dialog` | `ArcaneDialog` | `lib/component/dialog/dialog.dart` |
| `direction` | `ArcaneDirection` | `lib/component/layout/direction.dart` |
| `drawer` | `ArcaneDrawer` | `lib/component/layout/drawer.dart` |
| `dropdown-menu` | `ArcaneDropdownMenu` | `lib/component/menu/dropdown_menu.dart` |
| `empty` | `ArcaneEmptyState` | `lib/component/view/empty_state.dart` |
| `field` | `ArcaneFieldWrapper` | `lib/component/form/field_wrapper.dart` |
| `hover-card` | `ArcaneHoverCard` | `lib/component/view/floating.dart` |
| `input` | `TextInput` | `lib/component/input/text_input.dart` |
| `input-group` | `ArcaneInputGroup` | `lib/component/form/field_wrapper.dart` |
| `input-otp` | `ArcaneOtpInput` | `lib/component/input/otp_input.dart` |
| `item` | `ArcaneItem` | `lib/component/view/item.dart` |
| `kbd` | `ArcaneKbd` | `lib/component/view/kbd.dart` |
| `menubar` | `ArcaneMenubar` | `lib/component/menu/menubar.dart` |
| `navigation-menu` | `ArcaneNavDropdown` | `lib/component/navigation/nav_dropdown.dart` |
| `pagination` | `ArcanePagination` | `lib/component/navigation/pagination.dart` |
| `popover` | `ArcanePopover` | `lib/component/dialog/popover.dart` |
| `progress` | `ArcaneProgressBar` | `lib/component/view/progress_bar.dart` |
| `radio-group` | `ArcaneRadioGroup` | `lib/component/input/radio_group.dart` |
| `resizable` | `ArcaneResizable` | `lib/component/layout/resizable.dart` |
| `scroll-area` | `ArcaneScrollArea` | `lib/component/layout/scroll_area.dart` |
| `select` | `ArcaneSelect` | `lib/component/input/text_input.dart` |
| `separator` | `ArcaneSeparator` | `lib/component/view/separator.dart` |
| `sheet` | `ArcaneSheet` | `lib/component/layout/sheet.dart` |
| `sidebar` | `ArcaneSidebar` | `lib/component/navigation/sidebar.dart` |
| `skeleton` | `ArcaneSkeleton` | `lib/component/view/skeleton.dart` |
| `slider` | `ArcaneSlider` | `lib/component/input/slider.dart` |
| `sonner` | `ArcaneSonner` | `lib/component/dialog/sonner.dart` |
| `spinner` | `ArcaneSpinner` | `lib/component/view/spinner.dart` |
| `switch` | `ArcaneToggleSwitch` | `lib/component/input/toggle_switch.dart` |
| `table` | `StaticTable` | `lib/component/view/static_table.dart` |
| `tabs` | `ArcaneTabs` | `lib/component/layout/tabs.dart` |
| `textarea` | `TextArea` | `lib/component/input/text_input.dart` |
| `toggle` | `ArcaneToggleButton` | `lib/component/input/cycle_button.dart` |
| `toggle-group` | `ArcaneToggleGroup` | `lib/component/input/toggle_group.dart` |
| `tooltip` | `ArcaneTooltip` | `lib/component/dialog/tooltip.dart` |
| `typography` | `Text` | `lib/component/typography/text.dart` |
| `styling` | `ArcaneStyleData` | `lib/util/style_types/arcane_style_data.dart` |
| `tokens` | `Background` | `lib/util/style_types/colors.dart` |
| `theming` | `ArcaneStyleData` | `lib/util/style_types/arcane_style_data.dart` |
| `aliases` | `ArcaneBox` | `lib/arcane_jaspr.dart` |
| `borders` | `BorderPreset` | `lib/util/style_types/borders.dart` |
| `colors` | `Background` | `lib/util/style_types/colors.dart` |
| `display` | `Display` | `lib/util/style_types/layout.dart` |
| `effects` | `Shadow` | `lib/util/style_types/effects.dart` |
| `spacing` | `Gap` | `lib/util/style_types/spacing.dart` |
| `typography-styles` | `Text` | `lib/component/typography/text.dart` |
| `slot-counter` | `ArcaneSlotCounter` | `lib/component/view/slot_counter.dart` |
| `spec-row` | `ArcaneSpecRow` | `lib/component/view/spec_row.dart` |
| `time-picker` | `ArcaneTimePicker` | `lib/component/input/time_picker.dart` |
| `scroll-rail` | `ArcaneScrollRail` | `lib/component/layout/scroll_rail.dart` |
| `promo` | `ArcaneInlineHeroBanner` | `lib/component/promo/promo.dart` |
| `cta-card` | `CtaCard` | `lib/component/card/cta_card.dart` |
| `feature-card` | `FeatureCard` | `lib/component/card/feature_card.dart` |
| `pricing-card` | `PricingCard` | `lib/component/card/pricing_card.dart` |
| `stat-card` | `StatCard` | `lib/component/card/stat_card.dart` |
| `testimonial-card` | `TestimonialCard` | `lib/component/card/testimonial_card.dart` |
| `flexi-cards` | `ArcaneFlexiCards` | `lib/component/card/flexi_cards.dart` |
| `flow` | `Wrap` | `lib/component/layout/flow.dart` |
| `gutter` | `Gutter` | `lib/component/layout/gutter.dart` |
| `gallery` | `ArcaneGallery` | `lib/component/collection/gallery.dart` |
| `native-select` | `ArcaneNativeSelect` | `lib/component/input/native_select.dart` |
| `check-list` | `ArcaneCheckList` | `lib/component/view/check_list.dart` |
| `toast` | `ArcaneToast` | `lib/component/dialog/toast.dart` |

## Primary Support Modules (50)

| Symbol | Source |
|---|---|
| `Collection` | `lib/component/collection/collection.dart` |
| `ArcaneInfiniteCarousel` | `lib/component/collection/infinite_carousel.dart` |
| `section` | `lib/component/collection/section.dart` |
| `ConfirmText` | `lib/component/dialog/confirm_text.dart` |
| `DialogDate` | `lib/component/dialog/date.dart` |
| `DialogDateMulti` | `lib/component/dialog/date_multi.dart` |
| `DialogDateRange` | `lib/component/dialog/date_range.dart` |
| `DialogEmail` | `lib/component/dialog/email.dart` |
| `DialogText` | `lib/component/dialog/text.dart` |
| `DialogTime` | `lib/component/dialog/time.dart` |
| `ArcaneFieldMetadata` | `lib/component/form/field.dart` |
| `ArcaneBoolField` | `lib/component/form/node/bool.dart` |
| `ArcaneColorField` | `lib/component/form/node/color.dart` |
| `ArcaneDateField` | `lib/component/form/node/date.dart` |
| `ArcaneEnumField` | `lib/component/form/node/enum.dart` |
| `ArcaneStringField` | `lib/component/form/node/string.dart` |
| `ArcaneTimeField` | `lib/component/form/node/time.dart` |
| `ArcaneFieldProvider` | `lib/component/form/provider.dart` |
| `FabSocket` | `lib/component/input/fab.dart` |
| `IconButton` | `lib/component/input/icon_button.dart` |
| `MutableText` | `lib/component/input/mutable_text.dart` |
| `PopupMenu` | `lib/component/input/popup_menu.dart` |
| `SearchResult` | `lib/component/input/search.dart` |
| `Selector` | `lib/component/input/selector.dart` |
| `Carpet` | `lib/component/layout/carpet.dart` |
| `FancyProgressBar` | `lib/component/layout/fancy_progress.dart` |
| `FormHeader` | `lib/component/layout/form_header.dart` |
| `ArcanePage` | `lib/component/layout/page.dart` |
| `RadioCards` | `lib/component/layout/radio_cards.dart` |
| `ArcaneScaffold` | `lib/component/layout/scaffold.dart` |
| `Section` | `lib/component/layout/section.dart` |
| `TocEntry` | `lib/component/navigation/toc.dart` |
| `Screen` | `lib/component/screen/abstract_screen.dart` |
| `FillScreen` | `lib/component/screen/fill_screen.dart` |
| `ArcaneNotFoundAction` | `lib/component/screen/not_found.dart` |
| `SliverScreen` | `lib/component/screen/sliver_screen.dart` |
| `ArcaneApp` | `lib/component/support/app.dart` |
| `DeleteIconButton` | `lib/component/support/delete_icon_button.dart` |
| `DeleteMenuButton` | `lib/component/support/delete_menu_button.dart` |
| `OnHover` | `lib/component/support/gesture.dart` |
| `Icon` | `lib/component/support/icons.dart` |
| `Bar` | `lib/component/view/bar.dart` |
| `CardSection` | `lib/component/view/card_section.dart` |
| `CenterBody` | `lib/component/view/center_body.dart` |
| `Expander` | `lib/component/view/expander.dart` |
| `ArcaneGlyph` | `lib/component/view/icon.dart` |
| `Image` | `lib/component/view/image.dart` |
| `Logo` | `lib/component/view/logo.dart` |
| `Markdown` | `lib/component/view/markdown.dart` |
| `Tile` | `lib/component/view/tile.dart` |

## Main-Surface Foundation Exports (24)

| Symbol | Source |
|---|---|
| `ArcaneDecoration` | `lib/core/decoration/arcane_decoration.dart` |
| `ArcaneInteraction` | `lib/core/interaction/interaction.dart` |
| `interaction_attrs` | `lib/core/interaction/interaction_attrs.dart` |
| `LayoutRenderers` | `lib/core/layout_renderers.dart` |
| `ButtonProps` | `lib/core/props/button_props.dart` |
| `ComponentRenderers` | `lib/core/renderers.dart` |
| `ArcaneThemeProvider` | `lib/core/theme_provider.dart` |
| `State` | `lib/flutter.dart` |
| `card` | `lib/mods/card.dart` |
| `auth_guard_export` | `lib/provider/auth_guard_export.dart` |
| `auth_provider_export` | `lib/provider/auth_provider_export.dart` |
| `auth_service_export` | `lib/service/auth_service_export.dart` |
| `AuthUser` | `lib/service/auth_state.dart` |
| `ArcaneStylesheet` | `lib/stylesheets/stylesheet.dart` |
| `index` | `lib/theme/index.dart` |
| `Color` | `lib/util/appearance/colors.dart` |
| `EdgeInsets` | `lib/util/arcane.dart` |
| `PasswordPolicy` | `lib/util/auth/password_policy.dart` |
| `classes` | `lib/util/classes.dart` |
| `prose_styles` | `lib/util/content/prose_styles.dart` |
| `ReadingTimeResult` | `lib/util/content/reading_time.dart` |
| `ArcaneColors` | `lib/util/design_tokens.dart` |
| `ArcaneScripts` | `lib/util/interactivity/arcane_scripts.dart` |
| `index` | `lib/util/style_types/index.dart` |

## Advanced HTML Modules (22)

| Symbol | Source |
|---|---|
| `ArcaneRawButton` | `lib/component/html/arcane_button.dart` |
| `ArcaneCatImage` | `lib/component/html/arcane_cat_image.dart` |
| `ArcaneImage` | `lib/component/html/arcane_image.dart` |
| `ArcaneRawInput` | `lib/component/html/arcane_input.dart` |
| `ArcaneLabel` | `lib/component/html/arcane_label.dart` |
| `ArcaneLink` | `lib/component/html/arcane_link.dart` |
| `ArcaneSpan` | `lib/component/html/arcane_span.dart` |
| `ArcaneText` | `lib/component/html/arcane_text.dart` |
| `ArcaneCodeBlock` | `lib/component/html/code_block.dart` |
| `ArcaneDiv` | `lib/component/html/div.dart` |
| `ArcaneHtmlFooter` | `lib/component/html/footer.dart` |
| `ArcaneHeader` | `lib/component/html/header.dart` |
| `ArcaneHeading` | `lib/component/html/heading.dart` |
| `ArcaneBulletList` | `lib/component/html/lists.dart` |
| `ArcaneMain` | `lib/component/html/main_element.dart` |
| `ArcaneNav` | `lib/component/html/nav.dart` |
| `ArcaneParagraph` | `lib/component/html/paragraph.dart` |
| `ArcaneQuote` | `lib/component/html/quote.dart` |
| `ArcaneHtmlSection` | `lib/component/html/section.dart` |
| `ArcaneSideContent` | `lib/component/html/side_content.dart` |
| `ArcaneSvg` | `lib/component/html/svg.dart` |
| `ArcaneTable` | `lib/component/html/table.dart` |

