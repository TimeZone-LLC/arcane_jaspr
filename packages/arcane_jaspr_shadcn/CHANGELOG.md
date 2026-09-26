# Changelog

## x.x.x

### Fixed

- Disabled check boxes dim once, at the wrapper, instead of twice.
- A one-line check box centres its box on the label.
- Multi-select option boxes use the 3:1 `--shadcn-control-border`.
- The select label points at its trigger, the trigger reports its open state,
  and the list names itself and its multi-select mode.
- Homepage and documentation links point to the live docs at
  https://timezone-llc.github.io/arcane_jaspr/ instead of the retired
  ArcaneArts Pages address.

## 5.0.0 - 2026-09-23

### Added

- Shared v4 CSS-variable contract on `#arcane-root.arcane-theme-shadcn`:
  `--shadcn-focus-ring`, `--shadcn-focus-border`, `--shadcn-surface-shadow`,
  `--shadcn-item-radius`, `--shadcn-invalid-ring` and
  `--shadcn-input-background`. Renderers reference `--shadcn-control-shadow`,
  `--shadcn-control-border-color`, `--shadcn-item-background` and
  `--shadcn-item-foreground` inline so focus, hover, selected, open and invalid
  states flip variables instead of losing to inline styles.
- Overlay and navigation state rules (`shadcnSurfacesCss`), display and data
  state rules (`shadcnDisplayCss`), the v4 sidebar token family (`--sidebar`,
  `--sidebar-foreground`, `--sidebar-border`, `--sidebar-accent`,
  `--sidebar-accent-foreground`), and the previously referenced but undefined
  keyframes `arcane-slide-left/right/up/down`, `arcane-toast-enter/exit` and
  `arcane-progress-indeterminate`, with reduced-motion opt-outs.
- Invalid controls (`aria-invalid="true"` or `data-error="true"`) switch border
  and focus ring to the destructive pair. Menubar submenus open on hover,
  keyboard focus or `aria-expanded="true"`. Runtime toasts get the Sonner
  surface.

### Changed

- Deepened light accent palettes and refreshed semantic colors so primary,
  success, warning, information, and error text meet 4.5:1 contrast on generated
  page and card surfaces in both color modes.
- Moved button colors and hover states into theme CSS while retaining literal
  instance style overrides, consistent control borders, and underlined links.
- Scoped midnight palette overrides to the ShadCN root and added visible radio
  card focus and a forced-colors focus fallback.
- Neutral palettes (midnight, charcoal, cream, slate) follow shadcn's neutral,
  zinc, stone and slate surface ladders in light mode and the v4 neutral scale
  with translucent borders in dark mode; muted foregrounds stay at or above
  4.5:1. Pastel palettes keep their explicit values.
- Buttons use v4 sizing (32/36/40px, icon 32/36/40px), `--radius-md`,
  `shadow-xs` (none on ghost and link), and one hover fill; the base
  brightness filter no longer stacks on it. Outline buttons use `--input`.
- Text inputs, textareas, select triggers, native selects and OTP slots use the
  v4 input recipe: 36px, `0.25rem 0.75rem` padding, 0.875rem text, a
  `--shadcn-control-border` border (v4 `--input` mixed toward the foreground
  to at least 3:1), transparent background (`input`/30 in dark), 8px radius
  and `shadow-xs`. Checkbox and radio borders use the same token. Select content uses the popover surface, `--shadcn-surface-shadow`
  and `--shadcn-item-radius` options; the trigger icon is ChevronDown at 50%.
- Checkbox is 16px with a 4px radius and 14px check; radio is 16px with an 8px
  dot, the segmented variant rounds only its outer corners, and the card
  variant uses a 1px border; switch is a 32x18 track with a 16px thumb and no
  thumb shadow. Toggle group, toggle button and cycle button share the button
  sizes and take their hover and "on" fills from `data-arcane-state`; field,
  form, select and radio labels are 0.875rem at weight 500.
- Dialog, alert dialog and confirm dialog follow v4: 50% `--overlay` scrim,
  `p-6 gap-4` panel with a 1rem gutter, `text-lg` title, right-aligned footer
  and a `top-4 right-4` close control that brightens on hover. Sheets and
  drawers are square panels with a complete 1px frame, `shadow-lg` and slide
  animations; bottom drawers keep rounded top corners.
- Text tooltips are flat v4 chips (`--primary` fill, `text-xs`, filled arrow);
  rich popovers keep the popover surface.
- Dropdown, context-menu and menubar content use `min-w-[8rem]`,
  `--radius-md`, `--shadcn-surface-shadow`, `p-1` and `z-50`; items are
  `px-2 py-1.5 text-sm` with `--shadcn-item-radius`; separators use
  `--border`; disabled rows only dim; checked rows show only the indicator;
  destructive rows tint on hover. Every menubar menu renders its content
  (closed menus carry `hidden`).
- Command palette, tabs, accordion, disclosure, toast (Sonner), pagination,
  breadcrumbs and sidebar follow their v4 recipes: `sm:max-w-lg` palette with
  a 3rem search row; `h-9 p-[3px]` tab list with a lifted active trigger; square
  accordion rows with a rotating Lucide ChevronDown; 356px popover toasts above
  sheets; `size-9` ghost pagination items with Lucide chevrons and ellipsis;
  `gap-1.5` breadcrumbs with ChevronRight separators and a House home icon;
  sidebar painted with the `--sidebar*` tokens and sentence-case labels.
- Cards use `--radius-md` and `--shadow-sm`; interactive and linked cards lift
  to `--shadow-md` on hover. Badges, alerts, separators, skeletons, progress,
  sliders, tables, kbd, avatars, chart panels and date/time pickers follow v4
  metrics and tokens (see the display contract test).

### Fixed

- Runtime dialog dismissal invokes `onClose`, keeping hydrated application state
  in sync when users press Escape.
- Checkbox indicators and switch colors and thumbs now follow runtime selection
  changes without requiring a client rebuild.
- Hydrated switches update once per click or keyboard activation.
- All radio variants follow native selection without a client rebuild, retain
  native required state, and keep a stable card perimeter when selection changes.
- SizedBox preserves finite dimensions beside expanded dimensions; Row and
  Column consistently honor mainAxisSize, and Wrap supports vertical flow.
- Hover, focus, open and selected states on dropdown, context-menu, menubar,
  command, pagination, tab, select and table rows were blocked by inline
  literals, and tabs had no keyboard focus indicator.
- Dead state selectors (`.arcane-select[data-open='true']`,
  `[data-state='checked']`) are replaced by `[aria-expanded='true']`,
  `[aria-selected='true']` and `[data-arcane-state='active']`; checked menu
  items no longer keep a persistent accent fill.
- Focus-visible uses the v4 ring instead of the v3 offset double ring.
- Dialog, sheet and drawer panels no longer show the browser focus outline when
  the runtime focuses the panel.
- The accordion divider was invisible in light mode; the avatar status dot was
  clipped; the slider thumb jumped by half its width after the first runtime
  drag; indeterminate progress never animated; confirm and alert dialog icons,
  simple pagination and the slot counter painted text with surface tokens.

### Removed

- The toast progress strip, the default separator margin, and one-sided borders
  on sheets, drawers, the sheet footer and the floating arrow.

## 4.0.0 - 2026-08-31

### Changed

- Card-like renderers now use the bounded `md` radius and identify nested
  surfaces for automatic frame flattening.
- Button rendering now consumes core's single typed semantic icon slot; the
  obsolete automatic-arrow transition hook was removed.
- Accent alerts now use one uniform colored perimeter instead of a thick left
  edge on a rounded container.
- Replaced Google-hosted Inter with the committed product font assets and
  removed remote stylesheet loading.

### Removed

- Removed the floating, modal, ticker, progress, sidebar, takeover, and toast
  promo renderers; the retained top and inline announcements are flat links.

## 3.3.0

- Align package version and Arcane Jaspr dependency with the 3.3.0 core release.
- Require the current Jaspr 0.23.1 dependency line.
- Export `ShadcnKnowledgeBaseRenderers` (moved here from `arcane_lexicon`). The
  package now depends on `arcane_lexicon` and owns its docs-chrome renderers, so a
  lexicon site selects this theme's chrome via
  `knowledgeBaseRenderers: const ShadcnKnowledgeBaseRenderers()`.

## 3.1.0

- Initial standalone Shadcn renderer package for Arcane Jaspr.
- Adds Shadcn component and adaptive layout renderers.
