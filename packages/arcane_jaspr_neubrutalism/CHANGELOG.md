# Changelog

## x.x.x

### Added

- NeuComic paper, exposed-edge, backing-sheet, ink, muted-text, and print-pattern tokens for coordinated light and dark page surfaces.
- NeuComic galleries join complete artwork, title, and artist in fitted comic-strip panels with proportionate desktop rows and natural-ratio mobile panels.

- Opt-in rounded corners across Classic and NeuComic through `NeubrutalismStylesheet(rounded: true)` and live preview controls.
- A Print Club component gallery covering every renderer slot in Classic and NeuComic, in light and dark mode.
- Shared control and surface animations, reduced-motion behavior, and visibility-aware slot counters.

- `NeubrutalismVariant.neuComic` adds paper surfaces, comic panel and caption styles, halftone dots, crosshatching, and embedded Bangers/Comic Neue fonts in light and dark mode.
- Embedded Syne, Space Grotesk, Inter, and Space Mono fonts with their OFL licenses; no host asset setup or remote font requests are required.
- `NeubrutalismTheme.redBlack` combines red accents, neutral near-black surfaces, off-white text, and hard shadows.

### Changed

- Give NeuComic gallery panels integrated paper captions, 3px ink frames, hard offset shadows, and pronounced desktop and mobile tilts bounded by the available gutter and edge space.
- Give NeuComic square checked/unchecked switch indicators inside 44px hit targets, rectangular slider thumbs, matte rails, and explicit focus, validation, disabled, and selected states while preserving Classic geometry.
- Give NeuComic quiet paper and charcoal surfaces, muted red primary actions, dark structural ink, readable control boundaries, and compact integrated captions.

- Replace repeated three-color dot overlays with a configurable single-ink tint utility and illustration screens whose dot areas produce the local tones and overprinted colors.

- Give NeuComic overlays layered paper edges and small tilted headings; confine subtle print patterns to short labels and selected chapter tabs while keeping fields, panel bodies, and artwork clear.
- Keep Classic switches square by default, with larger thumbs, consistent shadows, and optional rounded tracks and thumbs.
- Use warm charcoal and cream in dark mode, with black structural edges and hard shadows; keep greyscale neutral and redBlack's distinct surfaces.
- Match neubrutalism.com typography roles, light palette, square corners, 3px outlines, and 3/5/8/12px hard-shadow tiers.
- Use readable body typography, larger default buttons and cards, monospace badges, square radio indicators, and flat semantic toast fills.

### Fixed

- NeuComic dialog and sheet titles wrap inside their framed heading at enlarged text sizes.
- NeuComic rows stay aligned at fractional widths and resize to fit captions and footers added after initial packing.
- Measure gallery caption and footer space before transforms so panel rotation cannot inflate strip rows.
- NeuComic strip rows preserve artwork ratios, source order, caption space, and row alignment across viewport changes and appended items.
- NeuComic field focus uses contrast-safe theme ink even when a custom accent matches the field background.
- Version preview artwork, CSS, and JavaScript URLs by content so rebuilt styles replace cached assets.
- Scale switch tracks and thumbs consistently and align both preview headers to a shared 44px control height.
- Add breathing room to sidebar groups, counter labels, and scroll-panel content without changing their navigation or scrolling behavior.
- Give accordions one coherent frame, readable rotating chevrons, and correct single-open grouping.
- Advance PIN focus after each digit and support keyboard correction and pasted codes through the shared input runtime.
- Restore focus to the actual button after closing menus opened with arrow keys.
- Match focus outlines to theme ink in light mode and cream text in dark mode instead of browser-like blue.

- Style mega menus consistently and support touch, keyboard navigation, outside dismissal, and focus return in mega menus and menubars.

- Keep drawers, toasts, command palettes, floating hints, and time pickers inside narrow viewports.
- Give popovers a single click owner and restore outside dismissal after hydration.

- Keep card families, table headers and selected rows, avatars, shortcuts, breadcrumbs, OTP fields, and slider boundaries readable in both appearances.
- Reflow pagination, flexible cards, and pricing grids on narrow screens without breaking action labels.
- Use readable body lettering for dense NeuComic controls while retaining display lettering for headings.

- Keep switch thumbs inside their tracks with balanced clearance in every size and synchronize their position with runtime selection.
- Keep input placeholders and validation messages readable in light and dark appearances.
- Match prefix and suffix input borders and hard shadows to standalone fields.
- Separate readable dark control boundaries from structural ink, including live tab, radio, checkbox, and switch selection states; preserve explicit card borders and runtime line overrides.
- Keep dark validation text readable on the warmer panel surfaces and terminal text readable on its dark background.
- Preserve flat, outlined, ghost, and decorated card styles, with borderless ghost buttons.
- Keep radio labels readable and selection indicators synchronized during pointer and keyboard interaction.
- Dark palette seeds and renderer CSS now resolve surfaces from the same theme configuration.
- Font stacks include system fallbacks when a host does not bundle the optional product fonts.
- Tall dialogs keep headers and actions inside the viewport while the form body scrolls independently.
- Tab lists and tab bars wrap inside narrow panels without clipping keyboard focus or long labels.
- Both select APIs use styled listboxes with keyboard navigation, typeahead, disabled options, form validation, and reset support.
- Keyboard focus rings remain visible on fields and selector triggers with inline outline resets.
- Field wrapper labels associate with their input through `fieldId`.

## [6.0.0] - 2026-10-15

### Changed

- Requires Arcane Jaspr 6.0.0.

- The selected tab bar item carries `.selected`, and the bar and items also
  carry `arcane-tab-bar` and `arcane-tab-bar-item`.

### Fixed

- Homepage and documentation links point to the live docs at https://timezone-llc.github.io/arcane_jaspr/ instead of the retired ArcaneArts Pages address.

## 5.0.1 - 2026-09-23

### Fixed

- The slider thumb keeps its centre on the value after a runtime drag; it is
  positioned with a bare percentage and a centring transform.

## 5.0.0 - 2026-09-23

### Changed

- Flex layouts share Flutter main-axis sizing with the other renderers.
- Wrap layouts support horizontal and vertical directions.

### Fixed

- SizedBox preserves a finite dimension when its other axis expands.

## 4.0.0 - 2026-08-31

### Added

- Runtime override hooks for the theme's identity colors, mirroring the
  `--w95-*-in` contract in `arcane_jaspr_win95`: `--nb-accent-in` (accent),
  `--nb-on-accent-in` (readable foreground on the accent), `--nb-line-in`
  (ink border), and `--nb-dark-bg-in` (dark canvas). Every consumer now reads
  `var(--nb-*-in, stock)`, so a host
  app can re-tint the whole system from an account accent at runtime without
  a rebuild; with the hooks unset the stock look is unchanged.

### Changed

- Flexi cards and card-style empty states now identify nested surfaces for
  automatic frame flattening.
- Button rendering now consumes core's single typed semantic icon slot; the
  obsolete automatic-arrow transition hook was removed.
- Replaced Google-hosted Archivo Black, Space Grotesk, and JetBrains Mono with
  the committed product font assets and removed remote stylesheet loading.
- Accent alerts and knowledge-base callouts now color the complete border
  instead of thickening only the left edge of a rounded surface.
- Dark mode readability overhaul. The dark canvas now mixes only 8% of the
  accent over a neutral near-black (was 18%, which washed the page in an
  olive-brown under the yellow theme), cards sit on a slightly lighter
  neutral base so they separate from the canvas, and inputs/selects render
  on the lighter muted control paper instead of the near-black card color.
- Dark hard shadows are visible again: the shadow color's alpha rises from
  0.48 to 0.82, the ink line mixes 72% (was 54%) of the inverse-black, the
  dark `--border` lightens from #54545A to #686870, and the dark shadow
  offsets grow from 1/2/3/4/5px to 2/3/4/6/8px so the signature hard-offset
  language survives on dark surfaces.

### Removed

- Removed the hard-shadow color override; structural shadows remain neutral in
  every appearance mode.
- Removed the floating, modal, ticker, progress, sidebar, takeover, and toast
  promo renderers; the retained top and inline announcements are flat links.
- Removed stale promotion-badge and retired promo-family CSS hooks. The retained
  announcement renderers now own their flat, neutral presentation directly.

## 3.3.0

- Align package version and Arcane Jaspr dependency with the 3.3.0 core release.
- Require the current Jaspr 0.23.1 dependency line.
- Export `NeubrutalismKnowledgeBaseRenderers` (moved here from `arcane_lexicon`).
  The package now depends on `arcane_lexicon` and owns its docs-chrome renderers,
  so a lexicon site selects this theme's chrome via
  `knowledgeBaseRenderers: const NeubrutalismKnowledgeBaseRenderers()`.

## 3.1.0

- Initial standalone Neubrutalism renderer package for Arcane Jaspr.
- Adds Neubrutalism component and adaptive layout renderers.
