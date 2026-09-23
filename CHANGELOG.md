# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [5.0.0] - 2026-09-23

### Added

- Flutter-style `State.widget` and `didUpdateWidget`, with tests for updates,
  keyed replacement, `setState`, and disposal.
- `Flex`, `Flexible`, `FlexFit`, numeric `Positioned` constraints, and optional
  children for empty layouts and `SizedBox.expand`/`SizedBox.shrink`.
- `TextStyle`, `Text.data`, `textAlign`, and `softWrap` for typed text authoring.
- `IconButton.tooltip` and `semanticLabel` provide native titles and accessible names.
- [Flutter authoring guide](doc/flutter_authoring.md) and
  [upgrade notes](doc/upgrade_notes.md) describe supported conventions and direct replacements.

### Changed

- **Breaking:** `Row` and `Column` use `spacing`. `Column` centers its cross axis
  by default. Existing package and documentation layouts now specify their intended alignment.
- **Breaking:** `Wrap` uses `alignment`, `runAlignment`, `spacing`, `runSpacing`,
  and `WrapCrossAlignment`, with zero spacing by default and support for both axes.
- **Breaking:** `Text.style` accepts `TextStyle`. Literal CSS uses `cssStyle`;
  `align` becomes `textAlign`, and the text value is available as `data`.
- **Breaking:** Text fields, text areas, native selects, and OTP controls use
  `onChanged`. Text input submission uses `onSubmitted`.
- ShadCN, Neon, and Windows95 now have consistent control sizing, readable state
  colors, complete radio variants, and state styles that respond to runtime changes.
- `DropdownMenuRenderBase` action items route their background and text colour
  through `--arcane-menu-item-background` / `--arcane-menu-item-foreground`
  and mark destructive items with `data-variant="destructive"`, so every
  theme's stylesheet can style item states.
- Windows 95 restores bevelled caption buttons on gallery windows and the
  command palette, adds the window-frame bevel and etched group boxes, and
  draws radios, scroll arrows, the slider thumb and the close glyph as pixel
  bitmaps. ShadCN follows the shadcn/ui v4 recipes for controls, overlays,
  navigation and display components within the 8px radius policy.

### Fixed

- Dialogs mounted after page startup trap keyboard focus, close with Escape,
  and restore focus when removed. Runtime dismissal calls the dialog's `onClose`.
- Closed command palettes no longer intercept keyboard events intended for
  runtime-managed dialogs.
- Generated field IDs link labels and help/error text across renderer packages.
  Prefix and suffix inputs use the same attribute and event path as plain inputs.
- Disabled button links no longer navigate or dispatch runtime actions.
- Checkbox captions toggle in static pages, and unlabeled switches retain their
  runtime group. Checked states update their accessible attributes.
- Controlled checkboxes and switches update once per activation after hydration;
  checkbox keyboard activation also invokes `onChanged`.
- Legacy radio scripts leave native runtime groups and their selected styles intact.
- Native selects mark only the current option selected, and text submission
  waits until input-method composition finishes.
- All renderers preserve finite dimensions beside an expanding `SizedBox` axis.
  Flex main-axis sizing now has the same behavior across themes.
- The legacy menubar script targeted class names the renderer never emitted; it
  now binds the emitted classes, toggles `hidden`, mirrors
  `data-state`/`aria-expanded`, switches menus on hover while open, toggles
  submenus from click and keyboard, and closes on outside click and Escape.

### Removed

- Competing text-input `onChange`/`onInput` callbacks, select `onSelect` aliases,
  and checkbox/switch `onToggle` aliases. Update callers directly.

## [4.0.0] - 2026-08-31

### Added

- **Win95: the stock bitmap cursor set, as CSS tokens.** `tool/bundle_win95_cursors.dart` authors the classic cursors as ASCII pixel maps and encodes them into `packages/arcane_jaspr_win95/lib/src/win95_cursor_assets.dart` as 1x RGBA PNG data URIs; the theme exposes them with their original hotspots and keyword fallbacks as `--w95-cursor-arrow` (0,0), `--w95-cursor-wait`, `--w95-cursor-ibeam`, `--w95-cursor-crosshair` (IDC_CROSS), `--w95-cursor-no` (IDC_NO, the circle-slash), `--w95-cursor-move` (SIZEALL), and `--w95-cursor-ns` / `-ew` / `-nwse` / `-nesw`. Windows 95 had no hand/pointer and no open/closed "grab" hand at all — those are IE and NeXT idioms — so every drag surface the theme owns (gallery captions, drag handles, the dragging state, the carousel track, the slider thumb) now resolves to the pixel-art arrow, edit wells take the I-beam, splitter grips take the matching double-arrow, and `[aria-busy="true"]` takes the hourglass. Host apps reference the same tokens instead of naming a modern keyword.
- **Win95: the arrow is now the whole shell's ground state.** `#arcane-root.arcane-theme-win95` sets `cursor: var(--w95-cursor-arrow)`, so the desktop, the maximized window, its caption and its entire client area inherit the bitmap arrow in one declaration — no universal selector, so the genuine exceptions still override it. The exceptions are the I-beam over every edit control (including read-only ones, whose text stayed selectable), the hourglass over `[aria-busy]`, `.arcane-loading`, and a new `#arcane-root[data-busy="true"]` app-wide hook, the resize double-arrows over splitter grips, and IDC_CROSS over `.arcane-map-picking`. Buttons, labels, `<summary>`, and the non-text inputs name the arrow explicitly, because the browser's own stylesheet sets `cursor: default` on them and that outranks inheritance.
- **Win95: `--w95-cursor-hand`, the one non-shell cursor.** Internet Explorer's link hand, drawn as pixel art to match the rest of the set and scoped to actual hypertext — unadorned `a[href]`, prose/doc links, and `a.win95-breadcrumb-link[href]`. Anchors dressed as buttons, cards, tiles, or navigation chrome keep the arrow, as does the breadcrumb's sibling `<button>`.
- **Win95: outline (wireframe) window drag.** Galleries rendered under the Windows 95 theme now drag the way Win95 did by default: on threshold-cross a single hard-edged rectangle (`.arcane-gallery-drag-outline`, `mix-blend-mode: difference` over a 4px white frame — the XOR look at SM_CXFRAME thickness) tracks the pointer while the tile itself stays put, and the move commits in one repaint on release. Escape or a cancelled pointer simply discards the wireframe. The threshold drops to Win95's SM_CXDRAG/SM_CYDRAG (4px, compared per axis instead of as a radius). There is one outline at a time, it is not animated, and it leaves no trail.
- **Win95: caption activation state.** Pressing a gallery tile marks it active and its siblings inactive (`data-w95-active`), and the theme paints inactive captions in the Windows Standard scheme's `COLOR_INACTIVECAPTION` / `COLOR_INACTIVECAPTIONTEXT` pair (solid `#808080` face, `#c0c0c0` text). Tiles with no attribute stay active, so an untouched gallery is unchanged.
- **Win95: HiDPI hourglass frames.** `tool/bundle_win95_loaders.dart` now bundles the 2x and 3x sheets alongside the 1x for all three palettes (`win95Loader<Palette>DataUri2x` / `3x`), and `.arcane-loader` selects between them with `image-set()` so a retina display gets the sheet drawn at its own device resolution instead of a bilinear upscale of the 26x26 art. The `image-set()` is written with literal URLs rather than through `--w95-loader-image`, so an engine without it simply keeps the 1x declaration above; `--w95-loader-image` itself is unchanged and still resolves to the 1x URI for host apps.
- **Win95: a blanket zero-motion reset, matching the corner reset.** The theme scope already killed every `border-radius` in one rule; it now does the same for motion — `#arcane-root.arcane-theme-win95 *, *::before, *::after { transition: none !important; animation: none !important; }`. Windows 95 interpolated nothing, and the ~32 scattered per-component `transition: none` declarations could never reach the dozens of inline `transition`/`animation` styles written by core render bases and the interactivity scripts, because an inline declaration outranks any stylesheet rule that is not `!important`. Sidebar width slides, select and accordion hovers, prose and TOC easing, the mega-menu fade, the CTA-card entrance, the modal scale, the avatar pulse and the carousel marquee are all resolved by that single rule. Two things survive it deliberately: the hourglass is an animated `background-image`, not a CSS animation, and `transform` is untouched because tooltips and popovers use it for positioning. Anything a keyframe was making visible is pinned opaque alongside — `.win95-cta-card` emits `opacity: 0` inline and is now pinned to `1`.
- **Win95: `--w95-check`, the checkbox tick as drawn geometry.** The 7x7 Win95 mark — a two-pixel stroke descending right to the vertex, a second climbing right to the tip — authored one pixel per path run and painted through a mask so it follows `--w95-field-text`. It replaces `content: '✔'` (U+2714), which rendered at a different weight and vertical position in every font in the fallback stack; the Win95 checkbox renderer no longer emits its literal `x` text child either, so the box holds exactly one mark.

### Changed

- **Themeable navigation dropdown panels.** `ArcaneNavDropdown` now exposes the
  stable `arcane-nav-dropdown-panel` class and a scoped background token so
  themes can style its transient panel without changing content surfaces.
- **Select popover contract.** Shared select options now expose listbox option
  semantics and selected state, while triggers report their current expanded
  state instead of a fixed value.
- **Bounded theme geometry and elevation.** Radius authoring now ends at the
  8px `md` tier, renderer references use that tier directly, and palette
  shadows are fixed neutral structural presets rather than injectable strings.
- **Runtime DOM safety.** Calendar templates no longer expose literal control
  markup in the global script, and carousel clones recursively neutralize
  focusable descendants, remove duplicate IDs, and remain inert.
- **Accessible infinite carousel.** The repeated track copy is now inert and
  hidden from assistive technology; auto-scroll pauses for keyboard focus and
  is disabled when reduced motion is requested. Command search inputs also
  expose an accessible name.
- **Bounded style overrides.** `ArcaneStyleData.backgroundCustom` now accepts
  flat colors and tokens and rejects literal gradient functions. Nested semantic
  surfaces flatten through a shared `data-arcane-surface` contract across card
  families instead of relying on theme-specific class pairs.
- **Visible-content hard break.** CTA cards no longer delay or begin hidden,
  and FlexiCards no longer hide long text until hover.
- **Single-icon control hard break.** `Button` now exposes one semantic `icon`
  slot with a typed `ButtonIconPosition`; the arbitrary `child`, independent
  `trailing`, and manufactured `showArrow` paths were removed. `FeatureCard`
  likewise keeps one optional semantic icon and no longer manufactures a CTA
  arrow.
- **Typed semantic-glyph hard break.** Buttons, badges, cards, menus,
  navigation, selectors, dialogs, alerts, and other one-icon component slots
  now accept only the sealed `ArcaneGlyph` type. `ArcaneIcon.customSvg` keeps
  multi-path brand artwork inside one SVG glyph without reopening a `Widget`
  composition escape.
- **Executable design-language policy.** The documentation browser audit now
  exercises static and interactive states at 375px, 768px, and 1440px and
  mutation-tests every banned family. Source and render contracts reject
  visible nested semantic surfaces and reader-facing AI citation or tracking
  leaks.
- **Local-font hard break.** `ArcaneStylesheet.externalCssUrls` and ArcaneApp's
  remote stylesheet injection were removed. Core, ShadCN, Neon, and
  Neubrutalism now name only the committed Akzidenz Grotesk Pro, ITC Avant
  Garde, and Hack site assets.
- **Design-language hard break.** Core marketing surfaces now use flat, restrained geometry; the purpose-built glass, icon-backplate, chip/tag scripts, chip-radio, compact promo/card/pricing badges, `FancyIcon`, accent-button alias, text-glow, promo-pill, glow-theme, gradient-decoration, pin-glow, hover-lift, backdrop-blur, and animated/default-icon badge APIs were removed, with contract tests preventing their return.
- **Win95: the timing tokens are zeroed at their source.** The theme root now declares `--transition-fast/-/-slow/-slower: 0s` and the four `--arcane-transition-*` aliases alongside `--radius: 0`. The aliases have to be named explicitly: a custom property substitutes `var()` on the element it is declared on, so `--arcane-transition: var(--transition)` had already resolved to `150ms ease` at `:root` and inherits that computed value regardless of what the theme scope does to `--transition`. The theme's button arrow, menubar item, dropdown item, form buttons, slot counter, and flexi-cards now emit no interpolation, and `Win95FlexiCards` ignores `transitionDuration` while keeping the CSS-Grid expansion as a layout mechanism.
- **Win95: the scripted tooltip is the classic info box.** `TooltipScripts` builds `.arcane-tooltip` — a different element from the `.win95-tooltip` the theme already styled — with an inline 8px radius, a blurred shadow, a dark surface colour and a 150ms cross-fade, plus an 8x8 box rotated 45 degrees as a callout tail. Under the theme it is now `#ffffe1` with a 1px flat black border, no shadow, no radius and no fade, and `.arcane-tooltip-arrow` is hidden: a Win95 tooltip was a plain rectangle with no tail. Its inline `transform: translateX(-50%)` is centring, not motion, and is left alone.
- **Win95: caption buttons are drawn geometry at the right size.** The live close buttons on dialogs, drawers and sheets were 18x18 (22x18 for dialogs) with a thin bevel and the render base's U+2715 rendered as a font character, while the decorative captions elsewhere in the sheet already did it correctly. All three are now 16x14 raised control faces carrying the `--w95-ctl-close` mask, pressed to `--w95-pressed` with a 1px down-right glyph nudge. `font-size: 0` collapses the text node no theme can remove, so the mark can no longer change weight or baseline with the font fallback.
- **Win95: the engraved disabled label, everywhere.** `DrawState`/`DSS_DISABLED` drew every greyed caption twice — the text in `COLOR_GRAYTEXT` over a `COLOR_BTNHILIGHT` copy offset one pixel down-right. Only buttons, cycle buttons and toggle buttons had it; calendar days, date/time triggers, select options, pagination, menu, dropdown and menubar items, disabled selects and textareas set flat grey. They now share one `color: var(--w95-shadow); text-shadow: 1px 1px 0 var(--w95-hilite)` recipe, tokenized so the dark scheme inverts it.
- **Win95: focus rectangles land on the caption.** The checkbox render base puts the tabindex on the 15px check well, so the single global `outline-offset: -3px` rule drew a ~9px dotted square inside the well itself. The well's own rect is now suppressed when there is a caption block to move it to (and only then, so an unlabelled checkbox keeps a focus mark), and the rect is drawn around the caption instead. Standard radios get the rect around the whole `<label>` rather than inset through their circle, and tabs pin the inset explicitly so the active tab's asymmetric bevel cannot clip it.
- **Win95: elevation is a bevel, not a glow.** `win95DecorationStyles` mapped `Elevation.md` and up onto `0 0 18px`/`0 0 36px` coloured halos — the neon theme's idiom, pasted in — so any component with `ArcaneDecoration(elevation: …)` wore a soft neon glow on a silver panel. The scale now resolves to `--w95-raised-thin` (xs/sm) and `--w95-raised` (md and up), and `shadowColor` is ignored because Win95 had no shadow to tint.
- **Win95: one inactive-caption colour, not two.** `--w95-title-inactive-b` existed only so a gradient could be built across the pair, which is the same Windows 98 assumption the caption gradient was; it is deleted, and the surviving pair is `--w95-title-inactive-a` plus a new `--w95-title-inactive-text` (`COLOR_INACTIVECAPTION` / `COLOR_INACTIVECAPTIONTEXT`), which the inactive gallery caption now reads instead of a literal.

- **Win95 title bars are solid, not gradients.** `--w95-title-bar` now resolves to `var(--w95-title-a)` alone — the navy-to-cyan caption gradient is a Windows 98 feature — and every caption in the theme (gallery tiles, dialogs, drawers, sheets, the knowledge-base topbar and landing mock) draws from that one token. `--w95-title-a-in` / `--w95-title-b-in` still re-tint captions at runtime, and a host that wants the 98 look redeclares `--w95-title-bar` as a gradient across the two.
- **Core drag cursors resolve through a theme seam.** The gallery drag runtime, `InfiniteCarousel`'s track, and the carousel dragging state now emit `cursor: var(--arcane-drag-cursor, grab)` / `var(--arcane-drag-cursor-active, grabbing)` instead of the bare keywords, so a theme can re-point them wholesale. Unset — which is every theme but Win95 — they resolve to the same grab/grabbing pair as before.
- **Win95 no longer shows the modern hand, circle-slash, or grab cursors.** All 44 `cursor: pointer` / `not-allowed` / `default` keywords in the theme sheet were replaced with `var(--w95-cursor-arrow)`: buttons, cards, menu and command items, tabs, the Start button, calendar cells, date/time pickers, combobox triggers, disclosure summaries, breadcrumbs, drawer and sheet closes, toasts, and every disabled state. A greyed Win95 control showed the plain arrow — its engraved label was the affordance — and IDC_NO was reserved for a refused drag-drop, which is what `--w95-cursor-no` is now exposed for. The theme also reclaims the three unscoped core rules that hard-code the hand (`.code-copy-button`, `.sidebar-theme-toggle`, `.sidebar-summary`).
- **Win95 renderers no longer decide cursors inline.** Inline pointer cursors across form and flexi-card renderers were removed so the theme sheet is the single place a cursor is chosen; the splitter handle emits `var(--w95-cursor-ew)` / `-ns` instead of `col-resize` / `row-resize`.
- **Two more core inline-cursor seams are themeable.** The number-input spinner script writes `var(--arcane-step-cursor[-disabled], …)` instead of hard-coding `pointer`/`not-allowed`, and the resizable splitter resolves `--arcane-resize-cursor-ew` / `-ns` from the dragged container before parking the value on `<body>` (which sits outside the themed root, so `var()` cannot reach it there). The map coordinate-picking script toggles an `.arcane-map-picking` class rather than writing an inline `crosshair`. Every seam falls back to the previous keyword when a theme leaves it unset, so shadcn, neon, and neubrutalism are unchanged.
- **Win95 progress meters read the Win95 way.** The trough is now the silver control face (`--w95-face`) inside its sunken bevel rather than the white edit-field colour, so the gutters between the navy blocks read `#c0c0c0` the way every Win95 copy/install dialog did. The blocks themselves changed from a phase-drifting `repeating-linear-gradient` (10px block, 2px gap, gaps punched to `transparent`) to a fixed 16px block on an 18px stride anchored to the left inner edge, so the segment pitch no longer shifts with the control's width.
- **Win95 has no marquee progress mode.** An indeterminate `ArcaneProgressBar` under the theme now renders the hourglass where the meter would be and drops the trough entirely, instead of the static, permanently-full navy bar it used to paint. Win95 had no indeterminate meter at all — that arrived with the XP-era common controls — and its answer for work of unknown length was the hourglass.
- **Win95 circular progress shows its value.** `Win95CircularProgress.ringStyles` now emits the swept angle as `--w95-gauge-pct`, and the theme draws the ring as a hard-stop conic gauge (navy on the silver face, masked into a chunky ring so the numeric readout stays legible in the hole) inside the existing sunken frame, with no easing. Win95 shipped no circular control, so this is the closest period-plausible reading of one; previously the ring was a static bezel and 5% and 95% rendered identically.
- **Win95 loaders snap to the pixel grid.** The hourglass is a 26x26 bitmap and callers ask for 16px, 20px, 24px and 40px — every one a fractional scale that shears rows out of the art rather than crisping it. Under the theme `--arcane-loader-size` is now snapped DOWN to the nearest whole multiple of 26 with 26px as the floor (`max(26px, round(down, …, 26px))`, with a plain `26px` pair ahead of it for engines without `round()`), so loading buttons, toasts, selects and auth guards all draw integer-scaled frames. `image-rendering: pixelated` is now `!important` like every other declaration in the block, preceded by `-moz-crisp-edges` / `crisp-edges` for older engines.
- **Win95 skeletons are dithered wells, not grey paint.** `.win95-skeleton` swapped its flat `#a0a0a0` fill for the classic 2x2 checkerboard of white and silver — the same 50% dither the scrollbar track uses — on a sunken well, and `Win95Skeleton.defaultGeometry` no longer authors a `9999px` radius for the circle shape (the theme's blanket corner reset was the only thing hiding it). Win95 had no skeleton-placeholder concept; the empty dithered well is its stand-in for a region with nothing in it yet.
- **Win95 busy states take the hourglass, not the circle-slash.** A control in `data-state="loading"` is marked disabled by the shared button base, which previously handed it the "unavailable" cursor — a mark that meant a drop would be refused, not that work was in progress. `[data-state="loading"]` (and its subtree) and `.arcane-loader` now join `[data-busy]`, `[aria-busy]` and `.arcane-loading` on the `--w95-cursor-wait` rule.

### Removed

- Removed one-sided border fields and presets, large-radius CSS aliases,
  per-decoration shadow colors, and generated sparkle icon shortcuts so public
  APIs cannot reconstruct accent crescents, oversized cards, colored bloom, or
  decorative multi-icon badges.
- Removed the public `ArcaneStyleData.raw`, `shadowCustom`, `filterCustom`, and
  `animationCustom` escape hatches that could recreate gradients, colored
  glows, filters, or arbitrary hidden-state effects.
- Removed public full/circle/custom-radius shortcuts, `FadeEdge`, scroll-area
  shadow fades, and carousel feather-gradient configuration. Intrinsically
  round controls now own their internal geometry instead of exposing pill
  radii to product surfaces.
- Removed the legacy imperative toast injector and its `ToastScripts` surface.
- Removed carousel fade-edge configuration and generated gradient overlays.
- Removed the floating, modal, ticker, progress, sidebar, takeover, and toast promo families; only the flat top announcement and inline hero announcement remain.
- Removed `GradientBuilder`, `ArcaneColorGradient.toGradient`, and the pill-shaped `ArcaneStylePresets.statusBadge` shortcut.
- Removed pricing-tier promotion APIs: hero pricing variants, highlighted/popular tier state, per-card accent overrides, and highlighted spec rows. Pricing comparisons now render every tier with equal neutral hierarchy.
- Removed pricing-card sale framing: the original-price/strikethrough API and renderer path no longer exist.

### Fixed

- **Stable interactive select surfaces.** Renderer-owned select callbacks no
  longer compete with delegated surface actions, and anchored surfaces restore
  their authored fallback geometry and trigger expanded state after closing.
- **Exclusive navigation dropdowns.** Opening a navigation dropdown now closes
  any open peer so compact and mobile header menus cannot overlap.
- **Balanced native controls.** `ArcaneSelect` now renders a real sibling
  chevron with a 14px end inset and a 40px value reserve instead of embedding
  SVG artwork in `background-image`; shared prefix/suffix field shells own the
  only visible focus perimeter while their inner inputs remain borderless.
- **Bundled documentation typography.** The generated `jaspr_content` root
  rules can no longer restore Open Sans or JetBrains Mono after the Arcane
  stylesheet loads; documents and code now inherit only the committed
  Akzidenz Grotesk Pro and Hack families.
- **Uniform custom-border enforcement.** `borderCustom` rejects declaration
  boundaries and directional border fragments, including semicolon injection
  through a CSS variable fallback, so it cannot reconstruct a one-sided accent.
- Legacy accordion binding now targets only explicit Arcane expander and
  accordion headers instead of capturing every `button[aria-expanded]` on the
  page.
- **Win95 progress bars were permanently full.** `Win95Progress.indicatorStyles` returned an empty map, so the block-level indicator's `width` resolved to `auto` — 100% of the track — and every meter rendered at 100% regardless of `props.value`. It now emits the clamped percentage inline with `transition: none`, so the fill snaps in whole segments the way a Win95 meter did. A 20% meter now measures 20% of its trough.
- **Win95: the default push button's black ring never rendered.** `.win95-button[data-variant="primary"]` drew it as `inset 0 0 0 1px var(--w95-dark)` behind `var(--w95-raised)` — but box-shadows paint first-listed on top and `--w95-raised` already covers a full 1px ring on every side, so the ring was 100% occluded. It is now a real `border: 1px solid var(--w95-dark)` with the bevel inside it, keeping the outer footprint identical via `box-sizing: border-box` so button rows stay aligned. The destructive variant's equally invisible maroon ring got the same treatment.
- **Win95: scrollbars were 17px and defined twice.** Two complete `::-webkit-scrollbar` blocks disagreed about the track dither; the earlier 16px one was entirely dead (the later block wins on source order and carries `!important` on every declaration) and has been deleted. `SM_CXVSCROLL`/`SM_CYHSCROLL` is 16 in Windows 95 and every part of the control is measured off that module, so the surviving definition — and the page-level `html:has()` copy — moved from 17px to 16px and the 16x16 arrow art lands on the pixel grid again. The in-app track and thumb also stopped hard-coding `#ffffff`/`#c0c0c0` and resolve through `--w95-field`/`--w95-face`, so the dark scheme re-points the dither instead of glaring white.
- **Win95: no blurred or alpha-composited shadow survives.** Drawer and sheet panels carried `3px 0 10px rgba(0, 0, 0, 0.4)` in all eight directional variants — a 10px gaussian, the most modern artifact in the sheet — and eight popup surfaces (dropdown, popover, select, combobox, date and time pickers, command dialog, dialog, menubar content, search results) added `2px 2px 0 rgba(0, 0, 0, 0.35)`. Windows 95 had no alpha compositing at all, and stock Win95 menus and dialogs cast no shadow whatsoever, so every shadow layer beyond `var(--w95-raised)` is gone; the 45%-black scrim already separates drawers and sheets from the page. The core mega-menu panel's inline 25px/10px blurred double shadow is overridden in theme scope for the same reason.
- **Win95: the modal scale artifact.** `ModalScripts` writes `transform: scale(0.95)` on close and `scale(1)` on open; with the transition dead that meant the window snapped to 95% and sat there for the 150ms before the overlay was hidden. `.win95-dialog` now pins `transform: none`, because a Win95 dialog appeared and vanished at full size.

## [3.4.0] - 2026-08-18

### Fixed

- **CI render-golden suite is green again.** The 42 goldens for buttons and
  dialogs were regenerated for jaspr 0.23.2, which moved the `type` attribute
  after the `data-*` attributes in rendered `<button>` markup. Attribute
  reorder only — the rendered DOM is semantically unchanged.

### Added

- **`ArcaneGallery` area controls.** Packed galleries can now set
  `minimumTileArea` and `targetTileArea` in grid cells (`columnSpan × rowSpan`).
  The packer excludes undersized candidate spans when the floor is attainable
  and uses one ratio-independent target area for every item. Galleries that
  omit both controls retain the existing aspect-derived sizing behavior.
- **Nested cards flatten by default (all four themes).** An arcane `Card` rendered inside another arcane `Card` now drops its own frame — background, border, and shadow — so stacked panels no longer read as a "card-in-card" border-in-border, most visibly under Shadcn and Neubrutalism. The inner card re-asserts a distinct frame by opting out with `decoration:`/`styles:` (which set the `data-arcane-decorated` attribute the flatten rule excludes). Implemented as pure per-theme CSS (`#arcane-root.arcane-theme-* .<theme>-card .<theme>-card:not([data-arcane-decorated])`), scoped and `!important` so it beats both inline variant styles (shadcn/neubrutalism) and the theme's own `!important` surface rules (neubrutalism); golden-neutral (the render snapshot suite excludes theme CSS by design). Note: a layout container that a host app styles as a card via its own CSS is outside the library's reach — only real nested arcane Cards flatten.
- **Web-safe theme packages + new `arcane_jaspr_kb`.** Split each theme's
  `*_kb_renderers` (which import `arcane_lexicon`, a server-side `dart:io`/`jaspr_content`
  docs package) out of the theme packages into a new opt-in `arcane_jaspr_kb` package. The
  theme packages (`arcane_jaspr_shadcn`/`_neubrutalism`/`_neon`/`_win95`) no longer depend on
  `arcane_lexicon`, so importing them in a Jaspr **client** app no longer drags `dart:io` into
  the client entry (which silently dropped `main.client.dart` and shipped a blank app). Docs
  sites now depend on `arcane_jaspr_kb` for the knowledge-base chrome renderers.
- **Theme-permeable styling (M0 foundations).** New `ArcaneDecoration` (`core/decoration/arcane_decoration.dart`) — a Flutter-`BoxDecoration`-shaped, theme-permeable surface with universal fields (color, gradient, borderRadius, border, padding, backdropFilter) plus an `Elevation` *intent* every theme maps to its own idiom (shadcn ambient blur, neubrutalism hard offset, neon glow) and a theme-specific `shadowColor` honored-or-ignored per theme. `Button` and `Card` now accept `decoration:` (semantic) and `styles: ArcaneStyleData?` (literal escape hatch that always wins). Render bases expose a concrete-default `decorationStyles(ArcaneDecoration?)` hook (returns `{}`) so themes opt in without a breaking change; the merge seam layers `theme base -> variant -> size -> decoration -> literal styles`.
- `ArcaneColorOps` extension on `String` — `.opacity(double)` and `.on(base, double)` emit `color-mix()` for any CSS color (hex, `var(--x)`, `ArcaneColor.*.css`, runtime accents), replacing raw `color-mix` strings and the fragile `${color}30` hex-alpha hack (which produces invalid CSS for `var()` colors).
- `ArcaneStyleData` gained the typed fields that previously forced `raw:` maps: single-side padding (`paddingTop`/`Right`/`Bottom`/`Left`), per-side custom border strings (`borderTopCustom`/…, which can carry a runtime color or `none`), `boxSizing` (`BoxSizing` enum), `backgroundClip` (emits standard + `-webkit-`), and `backdropFilterCustom`.
- **M1: the `styles:`/`decoration:` surface now covers all ~60 wired themed-visual components** — every actionable component across buttons, cards, feedback (Alert/Avatar/StatusBadge/Toast/Kbd/Breadcrumbs/Progress/CircularProgress/Skeleton/LoadingSpinner/EmptyState), interactive (Accordion/Disclosure/Cycle/Toggle/ToggleGroup/ToggleSwitch/Checkbox/RadioGroup/Slider/Separator), overlays (Dialog/Sheet/Drawer/Command/Floating/ContextMenu/DropdownMenu/Menubar/Toolbar), inputs (TextInput/Select/NativeSelect/OtpInput/TimePicker/DatePicker/Calendar/FieldWrapper/InputGroup), tabs/pagination, and the promo chrome (TopAnnouncementBar/PromoModal/…/SlotCounter). For overlay components the override routes to the visible panel, never the scrim; for standalone theme renderers that don't extend the shared base the merge is applied directly; components with no core render base use the 2-spread form. Calendar's per-theme style member was migrated from `dom.Styles` to `Map<String,String>` to host the seam. Every addition is golden-neutral (rendered output unchanged when the new fields are unset).
- **M2: shipped the orphaned card family + `IconBadge`.** The card props + renderer-contracts that existed as dead code (`StatCardProps`, `FeatureCardProps`, `CTACardProps`, `TestimonialCardProps`, `PricingCardProps`) now have public widgets and per-theme renderers wired into all three themes: `StatCard`/`StatCardRow`, `FeatureCard`/`IconCard`, `CtaCard`, `TestimonialCard`/`RatingStars`, and `PricingCard`/`PricingGrid`. Each renders from theme CSS variables (adapts to any palette), is permeable (`styles:`/`decoration:`), and composes via a shared render base + thin theme subclasses. New `IconBadge` component makes the ubiquitous colored-icon-circle idiom first-class.
- **M3: Flutter-parity ergonomics.** `cx(List<String?>)` class-join helper (`util/classes.dart`, exported) collapses the `_joinClasses` idiom copy-pasted across sites; `Container` gained a semantic `tag:` (`'nav'`/`'section'`/`'header'`/…) so structural markup no longer drops to raw `dom.*` — the default `div` path is byte-identical.
- **M4: card-family surface completed against a real consumer.** `CtaCard` gained `accentColor` (tints the icon chip + CTA) and `isExternal` (opens in a new tab with `rel="noopener noreferrer"` and a `↗` affordance); `PricingCard` gained `highlighted` (an accent wash + a solid, row-outranking CTA) and per-row `SpecEntry.highlight`. These are what let QualityNode's marketing pages migrate onto the library cards with zero visual change.
- **M3 breaking type cleanups (Flutter-parity, no back-compat).** `Card.padding`/`Card.borderRadius` are now typed `EdgeInsets?`/`BorderRadius?` (were raw-CSS `String?`), aligning `Card` with `ArcaneStructuredCard`. The `classes:` parameter on the arcane wrapper widgets (`ArcaneDiv`/`ArcaneSpan`/`ArcaneSection`/`ArcaneParagraph`/`ArcaneHeading`/`ArcaneLink`/`ArcaneNav`/… and the layout/HTML wrappers) now takes `List<String>?` (was `String?`), joined internally via `cx` — conditional class lists (`['card', if (active) 'is-active']`) no longer need a manual join. `ArcaneStyleData.backgroundClip` is now a typed `BackgroundClip` enum (`borderBox`/`paddingBox`/`contentBox`/`text`) instead of a raw `String?`.
- **`ArcaneGallery` — themeable media masonry.** New `component/collection/gallery.dart` + `core/props/gallery_props.dart` + shared `core/rendering/base/gallery_render_base.dart`, wired into `ComponentRenderers` via `GalleryRendererContract`, with a per-theme renderer in every theme package (`packages/*/lib/src/renderers/gallery.dart`). Each theme renders the SAME `ArcaneGalleryTile{media(aspectRatio,src?),mediaChild?,title,meta,href/onTap,overlay,footer}` list natively: win95 = titled windows on the teal desktop, shadcn = clean cards, neubrutalism = hard-shadow blocks, neon = glow. The CSS-grid base uses coarse rows (`grid-auto-rows: minColumnWidth/2`) + aspect-driven COLUMN spans (`galleryColumnSpan`: wide→2, panorama→3) + `grid-auto-flow: dense` for a variable-width mosaic, refined by an opt-in packing script (`util/interactivity/scripts/gallery/gallery_scripts.dart`, emitted via `includeFallbackScripts`). Media covers its cell (`object-fit: cover`).
- **Win95 theme: runtime accent override.** The Windows 95 theme's desktop backdrop, title-bar gradient and selection color now read `var(--w95-desktop-in, …)` / `--w95-title-a-in` / `--w95-title-b-in` / `--w95-selection-in` (plus `--primary`/`--accent`/`--ring`), falling back to the active [Win95Theme] scheme when unset. A host app can inject those `--w95-*-in` variables (scoped to `#arcane-root.arcane-theme-win95`) to re-tint the desktop + title bars from a runtime account accent live, without a rebuild — while the silver `#c0c0c0` control face and 3D bevels stay fixed across every accent.

### Fixed

- **Rounded emphasis surfaces no longer render orphaned edge accents.** Accent alerts, feature cards, testimonial cards, Neon cards, prose/knowledge-base callouts, and active rounded navigation now use a complete perimeter, fill, icon, or symmetric ring instead of a one-sided border or clipped stripe. The component docs teach the same invariant, the alert showcase exercises the accent variant, and a render/CSS contract prevents the crescent treatment from returning.
- **Confirm and alert dialogs are visible when rendered.** Their shared
  renderer now opens the underlying dialog surface instead of emitting it with
  the default closed state and `hidden` attribute.
- **`ArcaneGallery` packed tiles can no longer overlap around fragmented
  gaps.** Placement now searches through the complete occupied board and always
  includes the first wholly empty row. Its defensive fallback also appends
  below occupied cells instead of forcing a multi-cell tile into the first
  undersized gap.
- **Owner-sized `ArcaneGallery` packing no longer strands interior cells.**
  Each source-ordered tile anchors at the earliest unfilled cell while retaining
  its independent ratio-scored row and column spans. Normal masonry gutters and
  a ragged terminal edge remain unchanged; later tiles cannot skip an interior
  cell, overlap earlier art, or fall below the configured minimum.
- **Shadcn: the dropdown *panel* no longer claims the open-trigger accent fill.** `.arcane-dropdown-menu[data-state='open']` sat in the shared "open/active trigger" selector list that paints `background-color: var(--accent); color: var(--accent-foreground)`, so the popover surface was told to drop off the `--popover`/`--popover-foreground` pair every other floating surface uses. It was masked in practice by the renderer's inline `background-color: var(--popover)`, but any consumer that overrode the panel's inline styles (`styles:`/`decoration:`) inherited an accent-tinted panel instead of a popover one. Only the trigger selectors remain in the list.

- **`ArcaneGallery` tile caption is now theme-opt-in.** The render base only emits the title/meta header block when the theme opts in via `showsTileHeader` (win95 renders it as the window title bar). The card-style themes (shadcn/neubrutalism/neon) previously rendered the caption after the media, where a rounded tile clipped its bottom corners into a stray "caption strip"; they now render clean media-only tiles and expose the title to assistive tech via the tile's `aria-label`.

- **Permeability internals hardening.** Rolled the `layerStyles` "literal-wins" helper out to 20 more single-root render bases (avatar, breadcrumbs, alert, skeleton, accordion, disclosure, toggle-group, kbd, menubar, toast, slider, radio-group, sidebar, field-wrapper/input-group, separator, time-picker, cycle-button, tab-bar, spinner, calendar) — byte-identical output, so a `decoration` shorthand can no longer out-emit a literal `styles:` longhand anywhere. Removed a dead `decorationStyles` spread from the checkbox/toggle-switch renderers (no theme mapped it; universal `decoration:` fields + literal `styles:` still apply). Renamed the Calendar renderer base's abstract `styles` getter to `rootStyles` to disambiguate it from the permeable `props.styles`. Neubrutalism decorated toasts opt out of the variant-border `!important` reset via `data-arcane-decorated`, matching the card opt-out.
- **Permeability precedence hardening (quality pass).** The seam now guarantees literal `styles:` wins the cascade via a `layerStyles` helper (`lib/core/rendering/base/style_layering.dart`) that remove-then-reinserts override keys, so "later layer" == "later in the emitted CSS" — closing a Dart map key-position pitfall where a `decoration` shorthand (`background`) could beat a literal `styles:` longhand (`background-color`). Also fixed: trailing button-resets on tappable `Card`/anchor `Button` that clobbered `styles:`; StatusBadge applying its position/card-color mutations after the permeability merge; `ArcaneStyleData.merge()` silently dropping `alignItems`/`justifyContent`; `ArcaneNativeSelect`/`TextArea`/`SlotCounter` factory constructors not threading the new fields; and `ArcaneColorOps.opacity` quantizing to whole percent. Neubrutalism per-instance shadow recolor now bakes the color into the `box-shadow` (CSS custom properties resolve at the theme root, so the prior `var(--nb-shadow-color)` override never inherited), and decorated cards opt out of the theme's `!important` surface reset via a `data-arcane-decorated` attribute.
- Form controls no longer throw on every interaction under dart2js (Dart 3.11). Event handlers read DOM properties via `dynamic` member access (`(event.target as dynamic).value`, `.checked`, `.selectedIndex`, `.key`, `.stopPropagation()`), which throws `TypeError: <name> is not a function` on `package:web` extension types — silently breaking every text input, textarea, OTP input, select search, and clear button (values never reached the callbacks). Added `core/dom_value.dart` (conditional web/stub helpers using explicit `getProperty`/`callMethod` interop) and routed `text_input`/`field`/`text_input_render_base`/`otp_input_render_base`/`select_render_base` through it. The helper is conditionally imported so styled components keep compiling during off-web style extraction (where `dart:js_interop` is unavailable).
- `ArcaneApp.head` is now actually rendered. The `head: List<Widget>?` parameter was declared but never injected into the document; `ArcaneApp` now emits the supplied widgets through jaspr's cross-platform `Document.head`, so app-level `<link>`/`<script>`/`<meta>` widgets reach `<head>` during both SSR and client hydration. No change when `head` is null/empty.
- Server-side rendering crash in the form-field widgets (`ArcaneStringField`, `ArcaneBoolField`, `ArcaneColorField`, `ArcaneDateField`, `ArcaneTimeField`, `ArcaneEnumField`). `ArcaneField` now guards its asynchronous value load to the client (`kIsWeb`), so SSR renders the loading placeholder instead of throwing a build-phase `setState` assertion. Client behavior is unchanged.
- shadcn knowledge-base sidebar: pinned directly below the sticky top bar (was offset ~56px too low, leaving a gap above the nav) and made independently scrollable (`max-height` + `overflow-y: auto`) instead of requiring the whole page to scroll.
- shadcn top bar: restored `position: sticky` (it was `static`, so it scrolled off-screen) with a solid background and bottom hairline, so it stays pinned while scrolling.
- shadcn docs content layout: the content area now centers (capped at `--container-2xl` with auto margins instead of stretching edge-to-edge), and the right-hand table-of-contents column is only reserved when a TOC is actually present — TOC-less pages (e.g. component docs) now center the article instead of leaving an empty reserved column.
- shadcn docs sidebar: nested nav items (sub-folder contents) now have vertical spacing — `.sidebar-tree` was missing a `gap`, so deeply nested items packed together; added `gap: 0.25rem` so they match the top-level spacing.
- Neon docs sidebar: pinned directly below the sticky top bar (was offset by a doubled top, leaving a gap above the nav) and given its own scroll rail (`max-height` + `overflow-y: auto`) instead of scrolling with the page. The shadcn layout port had keyed this on the `.shadcn-kb-sidebar` class; the rule now targets `.neon-kb-sidebar` so it actually matches the Neon DOM.
- Theme CSS is no longer re-materialized on stylesheet cache hits. `ArcaneStylesheetCss.resolve` now takes the component CSS as a thunk (`String Function()`) invoked only on a cache miss, so the large per-theme CSS string (e.g. the Win95 theme's ~5,600 lines) is built once and skipped entirely when the Expando cache is warm. Output is byte-identical.
- Removed the last two `dynamic` public-API fields (strong-typing): `TreeNodeData.data` is now `Object?`, and the four `FileUploadProps` drag/input handlers are typed `void Function(web.Event)?` (the concrete type jaspr's events layer delivers) instead of `void Function(dynamic)?`.

### Removed

- Deleted ~1,300 lines of unreachable scaffolding that could not be distinguished from the live contract surface: the 514-line `style_presets.dart` catalog (8 preset classes, zero references — the live preset vocabulary is the `ArcaneStyleData` statics) and 11 orphan `*_props.dart` files whose widgets already ship without them (`tile`, `card_section`, `center_body`, `expander`, `glass`, `section`, `radio_cards`, `fab`, `icon_button`, `header`, plus the dead `SearchProps`/`BarProps` classes). Live symbols trapped in dead files (the `BarBackButtonMode` enum, `SearchResult`) were preserved. Verified: every deleted symbol had zero references across `lib`/`packages`/`test`/`tool`/`bin`/docs, `dart analyze` stays 0-error, and the suite holds at 42 pre-existing golden failures.
- Added a direct unit test for the `layerStyles` cascade helper (`test/unit/layer_styles_test.dart`) — the core "literal `styles:` always wins" guarantee was only exercised indirectly through Card SSR cases; 7 tests now assert later-override-wins, key-moved-to-last, null-skip, and left-to-right multi-override behavior.
- Removed 47 more orphan `*_props.dart` files (`lib/core/props/` went from 114 files to 67) — every `Props` class + `RendererContract` with zero references to any widget, render base, theme renderer, or dispatch aggregator (`ComponentRenderers`/`LayoutRenderers`). These were scaffolding for components that were never built. Verified by a per-symbol zero-reference scan (`file_upload`, `tree_view`, `timeline`, `stepper`, `tracker`, `meter`, `hero_section`, `game_tile`, `carpet`, `marquee`, `switcher`, and ~36 others, plus a `footer_props`/`footer_column_props` dead cluster). `status_indicator_props.dart` was stripped to just its live `StatusType` enum; live symbols trapped in otherwise-dead files were preserved. `dart analyze` stays 0-error and the suite holds at its 42 pre-existing golden failures.

### Changed

- **Loaders now have one theme-renderer source of truth.** Standalone spinners,
  loading buttons, authentication guards, loading toasts (including the
  JavaScript fallback), and Shadcn loading selects all resolve through
  `ComponentRenderers.loadingSpinner`, so a theme's loader updates every
  loading surface.
- **Preset `style` field renamed to `variant` (breaking, no back-compat).** The 8 components that exposed a preset-enum selector as `style:` (`ArcaneAlert`, `ArcaneKbd`, `ArcaneEmptyState`, `ArcanePagination`, `InlineHeroBanner`, `CodeBlock`, `MutableText`, `ArcaneDropdownItem`) now expose it as `variant:` — matching `Card`/`PricingCard` which already used `variant`, and eliminating the one-letter collision with the permeable `styles:` escape hatch (a typo between `style:` and `styles:` previously compiled and did the opposite thing). Enum *type* names (`AlertStyle`, `KbdStyle`, …) are unchanged; only the field/param. Rendered output is byte-identical (identifier-only change).
- **`StatCard.icon` is now `Widget?` (was `String?`, breaking).** It matches `FeatureCard`/`CtaCard`/`PricingCard` — icons are Widgets, as in Flutter. The shared `StatCardRenderBase` now places the widget directly in the icon badge instead of emitting the string as text.
- **Dropped the `onClick` alias on the `Card` family (breaking).** All nine `Card`/`ArcaneStructuredCard`/`ArcaneImageCard` constructors kept both `onTap` and `onClick` (`_onTap = onTap ?? onClick`); `onClick` is removed, leaving `onTap` (Flutter parity, no-alias rule). No call sites passed `onClick` to a card.

- Internal: deduplicated the `arcane_jaspr_shadcn`, `arcane_jaspr_neon`, and `arcane_jaspr_neubrutalism` renderer implementations into shared base classes under `lib/core/rendering/base/`. Public renderer class names and rendered HTML output are unchanged (verified byte-identical across all three themes via golden snapshots). Removed the per-package `control_styles.dart`.
- **`PricingCard` layout tuned to match real plan/hosting cards.** The spec table now renders *above* the feature list inside a bordered, rounded box (was plain rows below the features); a non-highlighted card's CTA is a neutral outline (foreground label, `--border` edge) so a `highlighted` card's solid accent CTA visibly outranks its row; and the badge pill is no longer force-uppercased — it renders the label exactly as passed.
- Neon theme: `PricingCard` and `TestimonialCard` now lift on hover (whole-card `translateY` + shadow), matching the neon card feel. Delivered from the theme layer (`neon_css.dart`) so consumers get it for free instead of stapling it into site CSS.
- `arcane_jaspr_neon` rebuilt as a dark-first "gamer" theme (replaces the prior neutralized skeleton). Distilled from the QualityNode aesthetic: the default `NeonTheme.green` is an emerald-to-cyan palette, with seven other neon variants. The palette is fully seeded from `NeonTheme` via `lightSeed`/`darkSeed` (like the shadcn and neubrutalism themes); the dark seed enables `accentGlow`, so shadows carry a neon glow. New `NeonCss` supplies a restrained, glow-and-gradient component layer (Oxanium display font, uniform accent frames, uppercase tracked badges, accent focus rings) — every rule scoped to `#arcane-root.arcane-theme-neon`, so the shadcn and neubrutalism themes are unaffected. `NeonCss` also styles the documentation knowledge-base chrome (top bar, sidebar, content grid, TOC) so the Neon docs render correctly (the bespoke Neon docs layout was retired in `arcane_lexicon`; Neon now uses the standard chrome). Neon is back in the golden snapshot tests.

## [3.3.0] - 2026-05-7

### Changed

- **Flutter-First Primary Surface**
  - `package:arcane_jaspr/arcane_jaspr.dart` now exposes a curated Flutter-shaped surface instead of re-exporting raw Jaspr and DOM APIs
  - Added `Widget`, `StatelessWidget`, `StatefulWidget`, `State`, `InheritedWidget`, `BuildContext`, `Key`, and the normal `runApp` path on the primary import
  - Moved low-level HTML wrappers and raw Jaspr escape hatches onto explicit secondary imports

- **Secondary Surface Split**
  - Added `package:arcane_jaspr/flutter.dart`
  - Added `package:arcane_jaspr/html.dart`
  - Added `package:arcane_jaspr/web.dart`
  - Updated package internals that still needed low-level access to import those surfaces explicitly

- **Developer Experience Reset**
  - Removed HTML-first wrappers from the primary docs path and rewrote the default documentation flow around the Flutter-first authoring model
  - Added plain Jaspr versus Arcane Jaspr comparison examples in the docs intro to explain the intended Flutter-like goal directly
  - Reworked the docs demo system around a central registry and generated component catalog output to keep examples and counts in sync
  - Updated the repo-owned Oracular ArcaneJaspr templates to teach the new primary surface instead of old Jaspr component base classes

### Added

- **Primary Surface Guardrails**
  - Added `tool/check_primary_surface.dart` to scan docs, demos, and templates for banned primary-surface examples such as old component base classes, `htmlFor`, and explicit generic angle-bracket usage

### Removed

- **Counter Smoke App**
  - Removed the temporary counter smoke app fixture created during the parity reset work

## [2.9.1] - Unreleased

### Changed

**Props Consolidation - Shared Type System**
- Created `lib/core/shared/size.dart` with unified `ComponentSize` enum supporting both naming conventions:
  - `sm`, `md`, `lg` (preferred)
  - `small`, `medium`, `large` (aliases pointing to same values)
- Created `lib/core/shared/variants.dart` with standardized variant enums:
  - `ColorVariant`: primary, secondary, destructive, success, warning, info
  - `StyleVariant`: solid, outline, ghost, link
- Updated 25+ props files to use shared types instead of component-specific enums
- Standardized on "destructive" naming (not "error") across all components

**ArcaneMenuItem Refactored to Sealed Classes**
- Converted `ArcaneMenuItem` from single class with boolean flags to sealed class hierarchy
- New type-safe menu item classes:
  - `MenuItemAction` - Standard clickable menu item with label, icon, shortcut
  - `MenuItemSeparator` - Visual divider between menu items
  - `MenuItemCheckbox` - Toggleable checkbox menu item
  - `MenuItemRadio` - Radio button menu item (mutually exclusive selection)
  - `MenuItemSubmenu` - Nested submenu container
  - `MenuItemLabel` - Non-interactive label/header
- All menu renderers (DropdownMenu, ContextMenu, Menubar) updated to use pattern matching
- Enables compile-time exhaustiveness checking for menu item handling

**Form Components Unified into SimpleForm**
- Merged `NewsletterForm` and `WaitlistForm` into unified `SimpleForm` component
- New `SimpleFormProps` with factory constructors:
  - `SimpleFormProps.newsletter()` - Email signup with inline layout
  - `SimpleFormProps.waitlist()` - Waitlist form with optional name collection
  - `SimpleFormProps.contact()` - Contact form with name, email, message
- New `SimpleFormField` class for flexible field definitions:
  - `SimpleFormFieldType`: text, email, password, phone, url, textarea
  - Custom validation via `validator` callback
  - Labels, placeholders, hints, and required field support
- Convenience wrapper components:
  - `ArcaneSimpleForm` - General purpose form
  - `ArcaneNewsletterForm` - Email signup (uses SimpleForm internally)
  - `ArcaneWaitlistForm` - Waitlist form (uses SimpleForm internally)
  - `ArcaneContactForm` - Contact form (uses SimpleForm internally)

### Removed

**Form Component Files Deleted**
- Removed `lib/core/props/newsletter_form_props.dart` (use `SimpleFormProps`)
- Removed `lib/stylesheets/shadcn/renderers/newsletter_form.dart` (use `simple_form.dart`)
- Removed `lib/component/form/newsletter_form.dart` (use `simple_form.dart`)

### Added

**ArcaneIcon Semantic Aliases**
- Added `ArcaneIcon.key()` alias mapping to `key-round` icon for intuitive usage in security-related UI
- Added `ArcaneIcon.map()` alias for the map icon (resolves conflict with Dart's `Map` type)

### Fixed

**Browser Scrollbar Styling**
- `ArcaneApp` now injects stylesheet CSS into the document `<head>` using `Document.head()` instead of inside the `#arcane-root` div
- `ArcaneApp` now adds the brightness class (`dark`/`light`) to the `<html>` element using `Document.html()`
- `CssGenerator` now outputs CSS variables on `html.dark`/`html.light` selectors in addition to `.dark`/`.light`, enabling scrollbar pseudo-elements to access theme variables
- Document-level scrollbars now properly inherit theme colors (`--background`, `--primary`) and match the styling of other scrollbars

### Changed

**Redesigned Light Themes for Richer Surfaces**
- `PaletteGenerator` light mode tinting increased for more visible surface contrast:
  - Secondary: 6% darken + 12% primary blend (was 4%/8%)
  - Accent: 10% darken + 18% primary blend (was 6%/12%)
  - Border: 18% darken + 10% primary blend (was 12%/6%)
  - Card: 2% darken + 5% primary blend (was 1%/3%)
  - Muted: 5% darken + 10% primary blend (was 3%/6%)
- `ShadcnTheme` pastel themes now use white backgrounds with richer tinted surfaces:
  - All pastel themes changed from tinted backgrounds to clean white (`0xFFffffff`)
  - Explicit secondary/accent colors provide visible contrast against white
  - Professional aesthetic with clearly distinguishable surface layers
- `NeonTheme` now includes bold, gaming-inspired light surface colors:
  - Each theme (green, red, blue, purple, cyan, pink, orange, rainbow) defines explicit `lightSecondary`, `lightAccent`, and `lightBorder`
  - Light surfaces are intentionally more saturated for gaming aesthetic
  - Example: green theme uses mint surfaces (`0xFFd1fae5`, `0xFFa7f3d0`, `0xFF6ee7b7`)
- `NeonStylesheet.lightSeed` updated to use explicit theme colors instead of auto-derivation

**ArcaneMap Theme Integration**
- `MapStyle` now uses CSS variables by default for theme-aware styling:
  - Default constructor uses `var(--card)`, `var(--muted)`, `var(--border)`, `var(--primary)`, etc.
  - Added `MapStyle.themed` constant (default behavior, uses CSS variables)
  - Existing `MapStyle.dark` and `MapStyle.light` still available with explicit hex colors
- Added `arcaneMapCss` constant with comprehensive styling:
  - **ShadCN (base)**: Clean map styling with theme variable integration
  - Hover effects on regions and location pins
  - Debug tooltip styling using theme colors
  - **Neon (overrides)**: Cyberpunk map effects
  - Glowing region hover effects with `drop-shadow`
  - Pulsing pin animation (`arcane-map-pin-pulse`)
  - Neon-styled debug tooltips with text shadows
- Added `data-active="true"` attribute to active regions for CSS targeting

**ArcaneFlexiCards Smooth Animation**
- Redesigned height animation to use CSS Grid `grid-template-rows` technique:
  - `0fr` to `1fr` transition provides smooth, natural height animation
  - No more abrupt "jumping" when long text is revealed
  - Footer animates smoothly alongside text content
- Text no longer "shuffles" during resize:
  - Inner content wrapper with `overflow: hidden` and `min-height: 0`
  - Opacity fades in sync with height animation
- Improved transition timing with `cubic-bezier(0.4, 0, 0.2, 1)` easing
- Non-hovered cards now shrink to `0.8x` when another card is hovered
- Added `.hovered` CSS class for additional styling hooks
- **Neon renderer enhancements**:
  - Icon glows on hover with `box-shadow`
  - Title changes to primary color with text shadow on hover
  - Card background tints toward primary on hover
  - Border glows with neon effect

**Improved TOC and Sidebar Tree Styles**
- `arcaneTocTreeLinesCss` - Complete rewrite with proper tree line visualization:
  - **ShadCN (base)**: Clean, subtle tree lines using `var(--border)` color
  - Added scrollbar styling for `.kb-toc` and `.toc-container` classes
  - Uses `::before` for horizontal branches and `::after` for vertical connectors
  - Proper last-child handling with L-bend effect (vertical line stops at center for last item)
  - Fading tree lines at deeper nesting levels
  - Single-child detection to hide unnecessary tree lines
  - Smaller, more subtle link styling (12px font, refined padding)
  - **Neon (overrides)**: Glowing tree lines with `var(--primary)` color
  - Thicker 2px lines with `box-shadow` glow effects
  - Border-left accent on links with glowing active states
  - Monospace font for headers
- `arcaneSidebarTreeStyles` - Complete rewrite matching Neon website patterns:
  - **ShadCN (base)**: Clean tree lines with subtle borders
  - Added `.sidebar-tree` container class support
  - Consistent tree line implementation using `::before`/`::after` pseudo-elements
  - Added collapsible section styles (`.sidebar-details`, `.sidebar-summary`, `.sidebar-chevron`)
  - Added animated chevron icon for expand/collapse
  - Proper `.sidebar-link` styling with hover and active states
  - Fading tree lines at deeper nesting levels
  - **Neon (overrides)**: Cyberpunk glowing tree lines
  - Thicker 2px primary-colored lines with glow effects
  - Border-left accent styling with straight left edges
  - Prominent glow on active states with inset box-shadow
  - Monospace font for section headers and summaries

### Added

**Project Conventions**
- Documented sitemap generation: Use `--sitemap-domain=<domain>` with `jaspr build`
- Documented favicon convention: Place `icon.png` in `web/assets/` directory
- Updated `ArcaneDocsLayout` to use `assets/icon.png` for favicon with apple-touch-icon support

**Documentation Components (migrated from arcane_lexicon)**
- `ArcaneDocsLayout` - Documentation-style layout with fixed header, sidebar, main content, and optional TOC
- `ArcaneToc` - Table of contents component with tree-line visual connectors
- `ArcanePageNav` - Previous/Next page navigation component for documentation
- `TocEntry` and `PageNavItem` data classes for navigation

**Content Utilities**
- `calculateReadingTime()` - Calculate estimated reading time from markdown content
- `ReadingTimeResult` class with minutes, wordCount, and formatted text getter
- `String.readingTime` extension for convenient reading time calculation

**Prose CSS Styles**
- `arcaneProseStyles` - Typography styles for markdown content (headings, paragraphs, lists, links, blockquotes, tables)
- `arcaneProseCodeStyles` - Syntax highlighting for code blocks (light/dark modes with GitHub-inspired colors)
- `arcaneCodeCopyButtonStyles` - Copy button styles for code blocks
- `arcaneCalloutStyles` - Callout/admonition block styles (note, tip, important, warning, caution)
- `arcaneSidebarTreeStyles` - Tree-line navigation styles for sidebars
- `arcaneTocTreeLinesCss` - Tree-line styles for table of contents
- `arcaneAllDocsStyles` - Combined constant with all documentation styles
- `arcaneDocsLayoutResponsiveCss` - Responsive breakpoint styles for docs layout
- `arcanePageNavCss` - Hover styles for page navigation
