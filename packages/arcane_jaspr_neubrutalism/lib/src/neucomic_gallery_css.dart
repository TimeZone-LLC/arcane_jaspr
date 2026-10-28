/// Comic strips join fitted artwork and its credits in one inked panel.
class NeuComicGalleryCss {
  const NeuComicGalleryCss._();

  static const String styles = r'''
#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-gallery {
  --arcane-gallery-decoration-clearance: 7px;
  position: relative;
  container-name: arcane-comic-gallery;
  container-type: inline-size;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-gallery-tile {
  --arcane-gallery-panel-angle: -1.2deg;
  position: relative;
  border: 3px solid var(--neucomic-ink) !important;
  border-radius: 0 !important;
  background: var(--neucomic-paper, var(--card)) !important;
  color: var(--neucomic-paper-ink, var(--foreground)) !important;
  box-shadow: 6px 6px 0 var(--neucomic-ink) !important;
  overflow: hidden;
  text-decoration: none !important;
  transform: rotate(var(--arcane-gallery-panel-rotation, 0deg)) !important;
  transform-origin: center;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-gallery-tile:nth-child(6n + 2) {
  --arcane-gallery-panel-angle: 1.5deg;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-gallery-tile:nth-child(6n + 3) {
  --arcane-gallery-panel-angle: 0deg;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-gallery-tile:nth-child(6n + 4) {
  --arcane-gallery-panel-angle: -.8deg;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-gallery-tile:nth-child(6n + 5) {
  --arcane-gallery-panel-angle: 1.3deg;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-gallery-tile:nth-child(6n + 6) {
  --arcane-gallery-panel-angle: -.35deg;
}

@container arcane-comic-gallery (min-width: 601px) {
  #arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-gallery-tile {
    --arcane-gallery-panel-angle: -2.5deg;
  }

  #arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-gallery-tile:nth-child(6n + 2) {
    --arcane-gallery-panel-angle: 3deg;
  }

  #arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-gallery-tile:nth-child(6n + 4) {
    --arcane-gallery-panel-angle: 2deg;
  }

  #arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-gallery-tile:nth-child(6n + 5) {
    --arcane-gallery-panel-angle: -3deg;
  }

  #arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-gallery-tile:nth-child(6n + 6) {
    --arcane-gallery-panel-angle: .6deg;
  }
}

@media (max-width: 600px) {
  #arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-gallery {
    column-gap: 28px !important;
    row-gap: 32px !important;
    padding: 16px 14px !important;
  }
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-gallery-tile-media {
  border: 0;
  padding: 0;
  border-radius: 0;
  background: transparent;
  box-shadow: none;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-gallery-tile-caption, .neubrutalism-gallery-tile-footer) {
  border: 0;
  border-radius: 0;
  background: var(--neucomic-paper, var(--card));
  box-shadow: none;
  color: var(--neucomic-paper-ink, var(--foreground));
  font-family: var(--font-sans);
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-gallery-tile-caption {
  justify-content: center;
  align-items: stretch;
  gap: 1px;
  padding: 5px 10px 6px;
  border-top: 3px solid var(--neucomic-ink);
  min-height: 50px;
  font-style: normal;
  text-transform: none;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-gallery-tile-footer {
  padding: 0 12px 10px;
  font-size: .8125rem;
  line-height: 20px;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-gallery-tile-title, .neubrutalism-gallery-tile-meta) {
  display: block;
  min-width: 0;
  overflow: hidden;
  overflow-wrap: anywhere;
  text-transform: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-gallery-tile-title {
  width: auto;
  max-width: 100%;
  padding: 0;
  border: 0;
  background: transparent;
  font-family: 'Comic Neue', var(--font-sans) !important;
  font-size: 17px !important;
  font-weight: 700 !important;
  font-style: italic;
  line-height: 20px !important;
  letter-spacing: 0 !important;
  text-transform: uppercase !important;
  color: var(--neucomic-paper-ink, var(--foreground)) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-gallery-tile-meta {
  font-family: var(--font-sans) !important;
  font-size: 12px !important;
  font-weight: 400 !important;
  line-height: 16px !important;
  letter-spacing: 0 !important;
  color: var(--neucomic-paper-muted, var(--muted-foreground)) !important;
}

@media (hover: hover) {
  #arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-gallery-tile:hover {
    outline: 2px solid var(--ring);
    outline-offset: 0;
  }
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-gallery-tile:focus-visible,
#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-gallery-tile:focus-within {
  outline: 3px solid var(--ring) !important;
  outline-offset: 3px;
}

@media (prefers-reduced-motion: reduce) {
  #arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-gallery-tile {
    transition: none;
  }
}
''';
}
