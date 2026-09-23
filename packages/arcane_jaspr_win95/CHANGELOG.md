# Changelog

## 5.0.2 - 2026-09-23

### Fixed

- The slider thumb starts at the current value instead of the left edge; the
  renderer now emits the value position inline.

## 5.0.1 - 2026-09-23

### Fixed

- The minimize caption glyph sits one face row above the bevel (rows 9-10)
  instead of touching it, matching the Windows 95 button.

## 5.0.0 - 2026-09-23

### Added

- Caption button sprites `--w95-caption-buttons` (minimize, maximize and
  close at 50x14), `--w95-caption-min-max` (32x14) and `--w95-caption-close`
  (16x14): bevelled 16x14 caps with stepped pixel glyphs, re-pointed by the
  dark scheme. Gallery window captions and the command palette caption bar
  show the caption buttons again.
- `--w95-window-frame`, the top-level window bevel (light and white top-left,
  shadow and black bottom-right), distinct from the push-button bevel.
- Etched group boxes for `fieldset` and `.win95-fieldset`; `ArcaneFormSection`
  renders its title as the legend inside the frame.
- Pixel-art tokens `--w95-radio-ring`, `--w95-radio-mask`, `--w95-scroll-up`,
  `--w95-scroll-down`, `--w95-scroll-left`, `--w95-scroll-right` and
  `--w95-slider-thumb`, with dark variants.

### Changed

- Use native radio inputs across standard, card, and button variants, with
  browser keyboard navigation and form semantics. CSS integrations that target
  radio option attributes must target the nested `.win95-radio-control` input.
- Align the dark seed with dark silver surfaces and the selected appearance
  scheme. Pair accent and semantic colors with readable foregrounds.
- Match Flutter sizing in Row, Column, and SizedBox: maximum axes fill available
  space, and infinite dimensions fill their own axis without losing finite sizes.
- Dialogs, drawers, sheets, menus, popovers, select and picker dropdowns, the
  mega menu, the command palette, the scaffold window and gallery tiles use
  `--w95-window-frame`; buttons keep the push-button bevel.
- `--w95-dark` is `#000000` and light disabled text is `#808080` over the
  existing white emboss.
- Radio buttons are the 12x12 four-shade bitmap with a 4x4 dot; check box wells
  are 13px around the 7x7 tick; scroll arrows are stepped 7x4 bitmaps and a
  pressed arrow flattens to a 1px frame with the glyph nudged one pixel.
- The progress trough uses the 1px sunken bevel; the slider drops its value
  fill and pairs a 4px sunken channel with an 11x21 pointed thumb.
- Menubar titles highlight only while their menu is open.
- `--w95-ctl-min`, `--w95-ctl-max` and `--w95-ctl-close` share the caption
  sprite pixel geometry, and the page-level scrollbar resolves through
  `--w95-*` tokens declared on `<html>`.

### Fixed

- Restore radio option descriptions, icons, layout, gap, and grid columns. Button
  variants use full control faces instead of tiny circular indicators.
- Keep disabled text separate from bevel shadow colors, preserve disabled
  select captions on hover, and show keyboard focus on the selection bar.
- Honor `maxDropdownHeight` with a scrollable option list and keep multi-select
  checkmarks visible inside their own sunken wells.
- Route switch label clicks through their native associated control once and
  follow runtime selection when painting switches and checkbox marks.
- Preserve control boundaries, native radio marks, and focus in forced colors.
- Correct documentation that described dark silver as High Contrast Black and
  advertised the removed `Win95Chrome.everything` value.
- The dialog, drawer and sheet close glyph is the stepped 8x7 bitmap cross
  instead of an anti-aliased stroke, and its pressed state moves by one whole
  pixel.
- The active tab paints its 1px white and black edges above the inner bevel.
- The command palette caption bar sits inside the palette window instead of
  against the full-screen overlay.
- Renderer documentation described an OLED design language.

### Removed

- Dark-scheme copies of the scrollbar arrow rules; the dark block re-points the
  arrow tokens instead.

## 4.0.0 - 2026-08-31

### Added

- `Win95LoaderPalette` and `Win95Stylesheet.loaderPalette` select one bundled
  pixel-art APNG hourglass (`win98`, `amber`, or `gameboy`) for every loading
  surface in the theme. The lossless 26×26 source scales through CSS with
  pixel-preserving rendering.
- Runtime text-override hooks `--w95-title-text-in` and
  `--w95-selection-text-in` (mirroring the `--nb-on-accent-in` contract in
  `arcane_jaspr_neubrutalism`). The caption text, `::selection` text,
  `--primary-foreground`, and `--accent-foreground` were fixed `#ffffff`,
  which is illegible when a host re-tints the title bars/selection with a
  light accent via `--w95-title-b-in` / `--w95-selection-in`; hosts can now
  supply a luminance-derived readable foreground alongside the accent.
  Unset, both fall back to the stock white.

### Fixed

- Title-bar window controls are drawn geometry instead of text characters.
  The minimize control was a literal `_`, which sits ON the font's baseline
  and therefore hung at the very bottom of its button (visibly far lower
  than the `□` and `✕` beside it, and clipped outright in some font
  fallbacks). All three glyphs are now authored in one 10x10 cell as SVG
  artwork. New `--w95-ctl-min` / `--w95-ctl-max` / `--w95-ctl-close`
  single-glyph mask tokens, applied to the dialog, drawer and sheet close
  buttons and to the landing terminal-mock's three cap buttons, so size,
  weight and vertical placement no longer depend on which font the browser
  resolves. The masks are tinted with `currentColor`, so they follow
  `--w95-title-text` / `--w95-face-text` including the `--w95-*-in` host
  overrides.
- Dark mode `--ring` now honours the `--w95-selection-in` runtime override
  hook like the light block already did, so a host-app accent re-tint also
  recolors dark focus rings.

### Removed

- Removed the network font bundler; the existing bitmap font faces remain a
  committed embedded asset and require no remote source at build or runtime.
- Removed the floating, modal, ticker, progress, sidebar, takeover, and toast
  promo renderers; the retained top and inline announcements are flat links.

### Changed

- Flexi cards and card-style empty states now identify nested surfaces for
  automatic frame flattening.
- Button rendering now consumes core's single typed semantic icon slot; the
  obsolete automatic-arrow transition hook was removed.
- Destructive buttons are no longer identical to every other silver button:
  they keep the 3D face but carry a bold maroon label and a 1px maroon ring
  inside the bevel (brightened red in dark mode) so dangerous actions are
  visually distinct.
- Ghost buttons render as thin raised toolbar buttons (face + thin bevel,
  pressed state on click) instead of bare borderless text, which disappeared
  entirely on dark surfaces.
- Dark "dark silver" scheme contrast: bevel highlights brighten
  (`--w95-hilite` #727272 to #8e8e8e, `--w95-light` #565656 to #646464),
  input wells lighten from #1e1e1e to #242424, and `--border` lightens from
  #202020 to #4a4a4a so sunken field borders and 3D chrome stay visible.
- The decorative `_ [] X` window-control glyphs on gallery tile and card
  captions are dimmed (62% opacity) so they read as painted decoration
  rather than clickable controls.

- Docs-chrome toolbar brand is now a Start button: a raised silver face with the
  waving four-pane flag and the bold site name that presses in on click (bevel
  inverts, contents nudge 1px down-right) and links to the homepage as before.
  A configured site logo image is hidden in this theme in favour of the flag.
  In High Contrast Black dark mode the flag's blue pane brightens so it stays
  visible on the dark control face.

## 3.3.0

- Initial Windows 95 renderer package for Arcane Jaspr.
- Faithful Win95 look built entirely from layered-inset 3D bevels: raised control
  faces (buttons, panels, tabs), sunken wells (inputs, progress, group boxes),
  navy→cyan gradient title bars, segmented progress meters, etched-groove
  separators, chunky beveled scrollbars, and dotted focus rectangles. Sharp
  corners throughout; no blur; press-only interaction.
- Five real appearance schemes (Standard, Rainy Day, Eggplant, Desert, Rose) plus
  a period-accurate High Contrast Black dark mode.
- Configurable window chrome via `Win95Chrome` (classic / everything / minimal).
- Export `Win95KnowledgeBaseRenderers` (moved here from `arcane_lexicon`). The
  package now depends on `arcane_lexicon` and owns its docs-chrome renderers, so a
  lexicon site selects this theme's chrome via
  `knowledgeBaseRenderers: const Win95KnowledgeBaseRenderers()`.
- Self-hosted "Pixelated MS Sans Serif" bitmap font, inlined so the theme is
  authentic offline.
- Component-accuracy pass: form action buttons (Submit/Cancel) are silver 3D
  faces instead of navy/teal fills; cycle and toggle buttons get proper silver
  bevels; textareas and multiline fields render as sunken white wells; standard
  radio options draw a round sunken well with a selected centre dot (previously
  bare text with no control); checkboxes show a single check (the stray literal
  glyph is collapsed); separators use the etched groove, status indicators are
  round, and the progress `%` readout is plain text rather than a second meter
  strip; field wrappers stack label / helper / error.
- Docs-chrome layout: the Explorer sidebar and right-hand TOC now reserve the
  fixed Start-bar height (`max-height: calc(100vh - 96px)`), so the tree, its
  internal scrollbar, and a long TOC stop above the taskbar instead of being
  eclipsed by it.
- Date-picker popup: the calendar dropdown had no position rule and fell through
  to a placeholder `position: fixed; top: 4px; left: 4px`, pinning it to the
  top-left corner behind other content. It now anchors below the trigger via CSS
  anchor positioning (`position: fixed` + `anchor()`), so it escapes clipping
  ancestors and floats on top; a `position: absolute` fallback covers browsers
  without anchor-positioning support.
- Docs-chrome topbar: the stylesheet/palette `<select>` switchers rendered their
  value in the macOS system font (native `appearance` ignores the theme font, and
  `<select>` does not inherit `font-family`); they now use `appearance: none` with
  the explicit pixel-font stack and a Win95 dropdown arrow (black in light, white
  in dark).
- Docs-chrome muted labels (article "min read / Updated" metadata, the "Live
  Demo" / "Code" demo kickers) used `--w95-shadow` for text, which is a bevel
  colour that turns near-black in dark mode and was unreadable on the dark panel.
  They now use the theme-aware `--muted-foreground`, readable in both modes.
