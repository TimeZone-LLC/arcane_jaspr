# Changelog

## x.x.x

### Changed

- Refined green text contrast separately from solid control fills, strengthened
  form-control borders, and aligned button and input sizes at 32, 40, and 48px.
- Added complete native radio presentations for standard, card, and button
  variants with labels, descriptions, required/disabled states, and visible focus.
- Added checkbox labels, descriptions, sizes, and a checkmark in place of the
  placeholder text mark.

### Fixed

- Radio controls now support native keyboard selection and form submission;
  their visual state follows both native and runtime changes.
- Hydrated radios retain their checked property after selection changes, and
  switches update once per click or keyboard activation.
- Checkbox marks and switch thumbs follow runtime selection changes, and tabs
  recognize the selected state emitted by their renderer.
- Prefixed and suffixed text fields retain one complete, correctly sized control
  perimeter; disabled menu items no longer receive hover highlights.
- SizedBox expands infinite dimensions without invalid CSS; Row and Column
  honor mainAxisSize consistently, and Wrap supports vertical flow.

## 4.0.0 - 2026-08-31

### Changed

- Dropdown, submenu, select, and navigation menu overlays now use one
  transparent frosted surface with an opaque reduced-transparency fallback;
  cards and other content surfaces remain flat.
- Card-like renderers now use the bounded `md` radius and surface markers;
  keyboard-key borders are uniform instead of bottom-heavy.
- Command palettes now render as bounded viewport modals with one framed
  dialog, a flat scrollable results list, and explicit search/footer regions.
- Button rendering now consumes core's single typed semantic icon slot; the
  obsolete automatic-arrow transition hook was removed.
- Rounded cards and alerts now use complete accent borders instead of clipped
  top strips or thick left edges.
- Rebuilt Neon around one green palette, grayscale surfaces, flat controls, and
  compact radii; removed card lift, decorative glow, glass, and gradient styles.
- Removed external font loading in favor of the bundled Akzidenz Grotesk Pro,
  ITC Avant Garde, and Hack font families.
- Removed the obsolete empty remote-stylesheet override after core deleted the
  external stylesheet API.
- Text fields, textareas, select triggers, and search controls now focus by
  changing one uniform border instead of stacking an outline or shadow around
  the existing control edge.

### Removed

- Removed the floating, modal, ticker, progress, sidebar, takeover, and toast
  promo renderers; the retained top and inline announcements are flat links.

### Fixed

- Non-native select triggers now own complete control geometry, and their
  viewport-bounded popovers have stable width, scrolling, and overlay layering.
- Non-native select popovers are anchored outside document flow, and searchable
  selects now style the input itself instead of framing its wrapper.
- Disclosure summaries now suppress the browser marker, keep their content and
  one plain plus indicator on a single row, and rotate that indicator when open.

## 3.3.0

- Align package version and Arcane Jaspr dependency with the 3.3.0 core release.
- Require the current Jaspr 0.23.1 dependency line.
- Export `NeonKnowledgeBaseRenderers` (moved here from `arcane_lexicon`). The
  package now depends on `arcane_lexicon` and owns its docs-chrome renderers, so a
  lexicon site selects this theme's chrome via
  `knowledgeBaseRenderers: const NeonKnowledgeBaseRenderers()`.

## 3.1.0

- Initial standalone Neon renderer package for Arcane Jaspr.
- Adds Neon component and adaptive layout renderers.
