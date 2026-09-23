# Changelog

## x.x.x

### Changed

- Deepened light accent palettes and refreshed semantic colors so primary,
  success, warning, information, and error text meet 4.5:1 contrast on generated
  page and card surfaces in both color modes.
- Moved button colors and hover states into theme CSS while retaining literal
  instance style overrides, consistent control borders, and underlined links.
- Scoped midnight palette overrides to the ShadCN root and added visible radio
  card focus and a forced-colors focus fallback.

### Fixed

- Checkbox indicators and switch colors and thumbs now follow runtime selection
  changes without requiring a client rebuild.
- Hydrated switches update once per click or keyboard activation.
- All radio variants follow native selection without a client rebuild, retain
  native required state, and keep a stable card perimeter when selection changes.
- SizedBox preserves finite dimensions beside expanded dimensions; Row and
  Column consistently honor mainAxisSize, and Wrap supports vertical flow.

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
