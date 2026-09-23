# Changelog

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
