# Changelog

## x.x.x

### Added

- Optional `AsciiOrbit` compositions and viewport-triggered `AsciiReveal` entrances, with pause, reduced-motion, and server-rendered fallbacks.

### Changed

- Warm neutral paper and ink palettes pair proportional reading type with monospace controls and annotations.
- Controls, progress, charts, skeletons, and overlays use smooth easing; decode text cycles through glyphs before resolving.
- Button styling uses quiet fills and complete outlines without automatic bracket decorations.
- Checkboxes and selected menu items use crisp geometric marks that remain visible without icon fonts, with consistent sizing across control variants.
- Wrapped control labels use readable line spacing, touch layouts offer larger selection targets, and radio focus outlines follow the visible control.

### Fixed

- Fields share label spacing, control typography, and heights across sizes, including native selects and date/time pickers.
- Touch inputs and actions align; tab containers accommodate their larger targets, and input groups fit narrow panels.
- Command search focus outlines enclose the whole row without clipping.
- Circular progress captions sit below the ring and wrap within the available width.
- Switch thumb styling targets the rendered thumb, and forced-colors mode preserves selection marks and thumb boundaries.
- Switches retain semantic colors with contrasting thumbs, and reduced-motion settings suppress control transitions.

## [1.0.0] - 2026-10-15

### Added

- Ascii light and dark stylesheets for every Arcane renderer family, with fine datum rules, monospace typography, bracketed controls, and stepped loading states.
- Accessible `AsciiText` decode and typewriter motion and `AsciiDatum` animated rules.
- Reduced-motion and forced-colors support, reusable surface and readout classes, and Lexicon styling.

### Fixed

- Calendar grids and chart bars retain their geometry in hydrated applications, and card actions, native fields, and skeleton surfaces use square theme corners.
- Skeletons honor their explicit animation setting.
