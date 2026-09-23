import 'package:arcane_jaspr/component/navigation/toc.dart'
    show arcaneTocTreeLinesCss;
import 'package:arcane_jaspr/component/view/map/map_style.dart'
    show arcaneMapCss;
import 'package:arcane_jaspr/util/content/prose_styles.dart';

import 'package:arcane_jaspr_shadcn/src/shadcn_theme.dart';

class ShadcnCss {
  static const String _lexiconCss = '''
#arcane-root.arcane-theme-shadcn {
  --shadcn-subtle-line: color-mix(in srgb, var(--border) 52%, transparent);
  --shadcn-hairline: color-mix(in srgb, var(--border) 38%, transparent);
  --shadcn-panel-fill: color-mix(in srgb, var(--background) 90%, var(--secondary));
  --shadcn-panel-highlight: color-mix(in srgb, var(--primary) 9%, var(--background));
  --shadcn-control-fill: color-mix(in srgb, var(--accent) 52%, var(--background));
  --shadcn-control-hover: color-mix(in srgb, var(--accent) 74%, var(--background));
}

html.dark #arcane-root.arcane-theme-shadcn,
#arcane-root.dark.arcane-theme-shadcn {
  --shadcn-subtle-line: color-mix(in srgb, var(--border) 64%, transparent);
  --shadcn-hairline: color-mix(in srgb, var(--border) 46%, transparent);
  --shadcn-panel-fill: color-mix(in srgb, var(--background) 82%, var(--secondary));
  --shadcn-panel-highlight: color-mix(in srgb, var(--primary) 14%, var(--background));
  --shadcn-control-fill: color-mix(in srgb, var(--accent) 72%, var(--background));
  --shadcn-control-hover: color-mix(in srgb, var(--accent) 84%, var(--primary));
}

html:has(#arcane-root.arcane-theme-shadcn),
html:has(#arcane-root.arcane-theme-shadcn) body,
#arcane-root.arcane-theme-shadcn,
#arcane-root.arcane-theme-shadcn * {
  scrollbar-width: thin;
  scrollbar-color: color-mix(in srgb, var(--border) 72%, transparent) transparent;
}

html:has(#arcane-root.arcane-theme-shadcn)::-webkit-scrollbar,
html:has(#arcane-root.arcane-theme-shadcn) body::-webkit-scrollbar,
#arcane-root.arcane-theme-shadcn *::-webkit-scrollbar {
  width: 0.5rem;
  height: 0.5rem;
}

html:has(#arcane-root.arcane-theme-shadcn)::-webkit-scrollbar-track,
html:has(#arcane-root.arcane-theme-shadcn) body::-webkit-scrollbar-track,
#arcane-root.arcane-theme-shadcn *::-webkit-scrollbar-track {
  background: transparent;
}

html:has(#arcane-root.arcane-theme-shadcn)::-webkit-scrollbar-thumb,
html:has(#arcane-root.arcane-theme-shadcn) body::-webkit-scrollbar-thumb,
#arcane-root.arcane-theme-shadcn *::-webkit-scrollbar-thumb {
  background: color-mix(in srgb, var(--border) 72%, transparent);
  border: 2px solid transparent;
  border-radius: var(--radius-xs);
  background-clip: padding-box;
}

html:has(#arcane-root.arcane-theme-shadcn)::-webkit-scrollbar-thumb:hover,
html:has(#arcane-root.arcane-theme-shadcn) body::-webkit-scrollbar-thumb:hover,
#arcane-root.arcane-theme-shadcn *::-webkit-scrollbar-thumb:hover {
  background: color-mix(in srgb, var(--foreground) 28%, var(--border));
}

#arcane-root.arcane-theme-shadcn .arcane-scaffold {
  min-height: 100vh !important;
  display: flex !important;
  flex-direction: column !important;
  padding-top: 0 !important;
  background: var(--background) !important;
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-shadcn .arcane-scaffold-header {
  position: sticky !important;
  top: 0 !important;
  left: auto !important;
  right: auto !important;
  z-index: 40 !important;
  height: 3.5rem !important;
  min-height: 3.5rem !important;
  padding: 0 !important;
  border-bottom: 1px solid var(--shadcn-hairline) !important;
  border-bottom-color: var(--shadcn-hairline) !important;
  background: var(--background) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-shadcn .arcane-scaffold-body {
  display: grid !important;
  align-items: start !important;
  gap: 0 !important;
  padding: 0 !important;
  overflow: visible !important;
}

#arcane-root.arcane-theme-shadcn
  .arcane-scaffold-body:not([data-has-sidebar]):not([data-has-secondary]) {
  grid-template-columns: minmax(0, 1fr) !important;
}

#arcane-root.arcane-theme-shadcn
  .arcane-scaffold-body[data-has-sidebar]:not([data-has-secondary]) {
  grid-template-columns: minmax(15rem, 17.5rem) minmax(0, 1fr) !important;
}

#arcane-root.arcane-theme-shadcn
  .arcane-scaffold-body:not([data-has-sidebar])[data-has-secondary] {
  grid-template-columns: minmax(0, 1fr) minmax(15rem, 18rem) !important;
}

#arcane-root.arcane-theme-shadcn
  .arcane-scaffold-body[data-has-sidebar][data-has-secondary] {
  grid-template-columns:
    minmax(15rem, 17.5rem) minmax(0, 1fr)
    minmax(15rem, 18rem) !important;
}

#arcane-root.arcane-theme-shadcn .arcane-scaffold-sidebar,
#arcane-root.arcane-theme-shadcn .arcane-scaffold-secondary {
  border-color: var(--shadcn-hairline) !important;
  background: var(--shadcn-panel-fill) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-shadcn .arcane-scaffold-sidebar.arcane-scaffold-sidebar {
  position: sticky !important;
  top: 3.5rem !important;
  left: auto !important;
  right: auto !important;
  bottom: auto !important;
  align-self: start !important;
  width: 17.5rem !important;
  border-right: 1px solid var(--shadcn-hairline) !important;
  height: max-content !important;
  max-height: none !important;
  min-height: 0 !important;
  overflow: visible !important;
  padding: 0 !important;
}

#arcane-root.arcane-theme-shadcn .arcane-scaffold-main.arcane-scaffold-main {
  min-width: 0 !important;
  width: 100% !important;
  max-width: none !important;
  min-height: 0 !important;
  margin-left: 0 !important;
  padding: 0 !important;
  border: 0 !important;
  overflow: visible !important;
}

#arcane-root.arcane-theme-shadcn .kb-topbar {
  position: sticky;
  top: 0;
  z-index: 50;
  border: 0;
  border-bottom: 1px solid var(--shadcn-hairline);
  background: var(--background);
  box-shadow: none;
}

#arcane-root.arcane-theme-shadcn .arcane-scaffold-header .kb-topbar {
  border-bottom: 0 !important;
}

#arcane-root.arcane-theme-shadcn .kb-topbar-inner {
  width: 100%;
  max-width: none;
  height: 3.5rem;
  min-height: 3.5rem;
  padding: 0 1.5rem;
  gap: 1.25rem;
}

#arcane-root.arcane-theme-shadcn .kb-topbar-left,
#arcane-root.arcane-theme-shadcn .kb-topbar-right {
  min-width: 0;
  gap: 0.875rem;
}

#arcane-root.arcane-theme-shadcn .kb-topbar-left {
  flex: 1 1 auto;
}

#arcane-root.arcane-theme-shadcn .kb-topbar-right {
  flex: 0 1 auto;
  padding: 0;
  border: 0;
  border-radius: 0;
  background: transparent;
}

#arcane-root.arcane-theme-shadcn .kb-topbar-nav {
  min-width: 0;
  margin-left: 0.25rem;
  padding: 0;
  gap: 1.25rem;
  border: 0;
  border-radius: 0;
  background: transparent;
}

#arcane-root.arcane-theme-shadcn .kb-topbar-brand {
  height: auto;
  padding: 0;
  gap: 0;
  border: 0;
  border-radius: 0;
  background: transparent;
  color: var(--foreground);
  box-shadow: none;
  font-size: 0.875rem;
  font-weight: 600;
  line-height: 1;
  text-decoration: none;
}

#arcane-root.arcane-theme-shadcn .kb-topbar-brand-icon {
  display: none;
}

#arcane-root.arcane-theme-shadcn .kb-topbar-brand-label {
  color: var(--foreground);
}

#arcane-root.arcane-theme-shadcn .kb-style-switcher {
  flex: 0 0 auto;
  flex-wrap: nowrap;
}

#arcane-root.arcane-theme-shadcn .kb-topbar-link {
  position: relative;
  height: auto;
  padding: 0.125rem 0;
  border: 0;
  border-radius: 0;
  background: transparent;
  color: var(--muted-foreground);
  box-shadow: none;
  font-size: 0.875rem;
  font-weight: 500;
  line-height: 1;
  text-decoration: none;
}

#arcane-root.arcane-theme-shadcn .kb-topbar-link:hover,
#arcane-root.arcane-theme-shadcn .kb-topbar-link.active {
  background: transparent;
  color: var(--foreground);
  box-shadow: none;
}

#arcane-root.arcane-theme-shadcn .kb-topbar-link.active {
  font-weight: 600;
}

#arcane-root.arcane-theme-shadcn .kb-topbar-link::after {
  content: '';
  position: absolute;
  left: 0;
  right: 0;
  bottom: -0.7rem;
  height: 2px;
  border-radius: 1px;
  background: transparent;
}

#arcane-root.arcane-theme-shadcn .kb-topbar-link.active::after {
  background: var(--foreground);
}

#arcane-root.arcane-theme-shadcn .arcane-scaffold-sidebar .kb-sidebar {
  position: relative !important;
  top: auto !important;
  width: 100% !important;
  height: max-content !important;
  max-height: none !important;
  min-height: 0 !important;
  padding: 0.375rem !important;
  overflow: visible !important;
}

#arcane-root.arcane-theme-shadcn .arcane-scaffold-sidebar .kb-sidebar-panel {
  min-height: 0 !important;
}

/* Docs knowledge-base sidebar (rendered directly under .kb-scaffold, not the
   arcane scaffold). Pin it directly below the 3.5rem sticky topbar and let it
   scroll on its own instead of forcing the whole page to scroll. The inline
   --kb-sidebar-rail-top (56px) otherwise double-counts the topbar height,
   leaving a gap above the nav. */
#arcane-root.arcane-theme-shadcn .shadcn-kb-sidebar {
  top: 3.5rem;
  max-height: calc(100vh - 3.5rem);
  overflow-y: auto;
}

#arcane-root.arcane-theme-shadcn .sidebar-header {
  margin: 0 0 0.5rem;
  padding: 0.625rem;
  border: 1px solid var(--shadcn-hairline);
  border-radius: var(--radius-md);
  background: var(--shadcn-panel-highlight);
  box-shadow: 0 1px 0 color-mix(in srgb, var(--foreground) 4%, transparent);
}

#arcane-root.arcane-theme-shadcn .sidebar-nav {
  padding: 0.375rem 0.125rem 0.625rem !important;
  gap: 0.375rem !important;
}

#arcane-root.arcane-theme-shadcn .sidebar-section {
  margin-bottom: 0.375rem;
}

#arcane-root.arcane-theme-shadcn .sidebar-section-header {
  padding: 0.375rem 0.5rem 0.25rem;
  color: var(--muted-foreground);
  font-size: 0.6875rem;
  font-weight: 600;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

#arcane-root.arcane-theme-shadcn .sidebar-tree {
  padding-left: 0.75rem;
  margin-left: 0.25rem;
  gap: 0.25rem;
}

#arcane-root.arcane-theme-shadcn .kb-topbar-github,
#arcane-root.arcane-theme-shadcn .kb-theme-toggle,
#arcane-root.arcane-theme-shadcn .kb-stylesheet-select,
#arcane-root.arcane-theme-shadcn .kb-palette-select,
#arcane-root.arcane-theme-shadcn .kb-hamburger {
  height: 2.125rem;
  border: 1px solid var(--shadcn-hairline);
  background: var(--background);
  border-radius: var(--radius);
  box-shadow: none;
}

#arcane-root.arcane-theme-shadcn .kb-topbar-github,
#arcane-root.arcane-theme-shadcn .kb-theme-toggle,
#arcane-root.arcane-theme-shadcn .kb-hamburger {
  width: 2.125rem;
}

#arcane-root.arcane-theme-shadcn .kb-topbar .kb-hamburger {
  display: none !important;
}

@media (max-width: 900px) {
  #arcane-root.arcane-theme-shadcn .kb-topbar .kb-hamburger {
    display: inline-flex !important;
  }
}

#arcane-root.arcane-theme-shadcn .kb-topbar-github:hover,
#arcane-root.arcane-theme-shadcn .kb-theme-toggle:hover,
#arcane-root.arcane-theme-shadcn .kb-stylesheet-select:hover,
#arcane-root.arcane-theme-shadcn .kb-palette-select:hover,
#arcane-root.arcane-theme-shadcn .kb-hamburger:hover {
  background: var(--shadcn-control-hover);
  border-color: var(--shadcn-subtle-line);
}

#arcane-root.arcane-theme-shadcn .kb-search-input,
#arcane-root.arcane-theme-shadcn .sidebar-search input {
  height: 2.125rem;
  border-color: var(--shadcn-hairline);
  background: var(--background);
  border-radius: var(--radius);
}

#arcane-root.arcane-theme-shadcn .kb-search-input:focus,
#arcane-root.arcane-theme-shadcn .sidebar-search input:focus {
  border-color: color-mix(in srgb, var(--ring) 42%, transparent);
  background: var(--background);
  box-shadow: 0 0 0 2px color-mix(in srgb, var(--ring) 16%, transparent);
}

#arcane-root.arcane-theme-shadcn .search-results {
  border-color: var(--shadcn-subtle-line);
  border-radius: var(--radius-md);
  box-shadow: 0 10px 28px -22px rgba(0, 0, 0, 0.42);
}

#arcane-root.arcane-theme-shadcn .sidebar-tabs {
  background: var(--shadcn-control-fill);
  border-radius: var(--radius);
}

#arcane-root.arcane-theme-shadcn .sidebar-tab {
  border-radius: calc(var(--radius) - 2px);
}

#arcane-root.arcane-theme-shadcn .sidebar-tab.active {
  box-shadow: none;
}

#arcane-root.arcane-theme-shadcn .sidebar-summary,
#arcane-root.arcane-theme-shadcn .sidebar-link {
  border-radius: calc(var(--radius) - 2px);
  color: color-mix(in srgb, var(--foreground) 78%, var(--muted-foreground));
  outline: 1px solid transparent;
  outline-offset: -1px;
}

#arcane-root.arcane-theme-shadcn .sidebar-summary:hover,
#arcane-root.arcane-theme-shadcn .sidebar-details[open] > .sidebar-summary,
#arcane-root.arcane-theme-shadcn .sidebar-link:hover,
#arcane-root.arcane-theme-shadcn .sidebar-link.active {
  background: var(--shadcn-control-hover);
  color: var(--foreground);
  outline-color: var(--shadcn-subtle-line);
}

#arcane-root.arcane-theme-shadcn .sidebar-link.active {
  box-shadow: none;
}

#arcane-root.arcane-theme-shadcn .sidebar-tree > .sidebar-section::before,
#arcane-root.arcane-theme-shadcn .sidebar-tree > .sidebar-section::after,
#arcane-root.arcane-theme-shadcn .sidebar-tree-item::before,
#arcane-root.arcane-theme-shadcn .sidebar-tree-item::after,
#arcane-root.arcane-theme-shadcn .sidebar-tree-item:not(:last-child)::after {
  content: none !important;
  display: none !important;
  background: transparent !important;
}

#arcane-root.arcane-theme-shadcn .toc-content > ul > li::before,
#arcane-root.arcane-theme-shadcn .toc-content > ul > li::after,
#arcane-root.arcane-theme-shadcn .toc-content ul ul li::before,
#arcane-root.arcane-theme-shadcn .toc-content ul ul li::after {
  background: var(--shadcn-hairline) !important;
}

#arcane-root.arcane-theme-shadcn .kb-toc-panel .toc {
  padding: 0.125rem 0 0;
  border: 0 !important;
  border-radius: 0 !important;
  background: transparent !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-shadcn .kb-toc-panel .toc-title {
  border-bottom: 0 !important;
  padding-bottom: 0.125rem;
  margin-bottom: 0.5rem;
}

#arcane-root.arcane-theme-shadcn .toc-content a {
  border-radius: calc(var(--radius) - 2px);
  background: transparent;
}

#arcane-root.arcane-theme-shadcn .toc-content a:hover,
#arcane-root.arcane-theme-shadcn .toc-content a.toc-active {
  background: var(--shadcn-control-hover);
}

#arcane-root.arcane-theme-shadcn .kb-main-area {
  min-width: 0 !important;
  width: 100% !important;
  overflow: visible !important;
}

#arcane-root.arcane-theme-shadcn .kb-content-area {
  display: grid !important;
  grid-template-columns: minmax(0, 1fr) !important;
  align-items: start !important;
  width: 100% !important;
  max-width: var(--container-2xl, 90rem) !important;
  margin: 0 auto !important;
  gap: clamp(1.75rem, 3vw, 3rem) !important;
  padding: clamp(1.75rem, 3vw, 3rem) clamp(1.5rem, 4vw, 3.5rem) !important;
}

/* Reserve the right-hand TOC column only when a table of contents is actually
   present (prose pages with headings). TOC-less pages (e.g. component docs)
   render a single centered column instead of leaving an empty 17rem gap. */
@media (min-width: 1201px) {
  #arcane-root.arcane-theme-shadcn .kb-content-area:has(.kb-toc-panel) {
    grid-template-columns: minmax(0, 1fr) minmax(12rem, 17rem) !important;
  }
}

#arcane-root.arcane-theme-shadcn .kb-article-panel {
  min-width: 0 !important;
  width: 100% !important;
  max-width: 68rem !important;
  margin-left: auto !important;
  margin-right: auto !important;
}

#arcane-root.arcane-theme-shadcn .kb-page-metadata,
#arcane-root.arcane-theme-shadcn .kb-tags-footer,
#arcane-root.arcane-theme-shadcn .prose h2,
#arcane-root.arcane-theme-shadcn .prose hr,
#arcane-root.arcane-theme-shadcn .prose blockquote,
#arcane-root.arcane-theme-shadcn .prose th,
#arcane-root.arcane-theme-shadcn .prose td,
#arcane-root.arcane-theme-shadcn .prose pre {
  border-color: var(--shadcn-hairline) !important;
}

#arcane-root.arcane-theme-shadcn .prose th {
  background: var(--shadcn-control-fill);
}

#arcane-root.arcane-theme-shadcn .arcane-demo-preview-scope,
#arcane-root.arcane-theme-shadcn .arcane-demo-code {
  border-color: var(--shadcn-subtle-line) !important;
  border-radius: var(--radius-md);
  box-shadow: none !important;
}

#arcane-root.arcane-theme-shadcn .arcane-demo-panel {
  padding: 1.5rem !important;
  border: 1px solid var(--shadcn-subtle-line) !important;
  border-radius: var(--radius-md) !important;
  background: color-mix(in srgb, var(--card) 96%, var(--background)) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-shadcn .arcane-demo-kicker,
#arcane-root.arcane-theme-shadcn .arcane-demo-code-label {
  color: var(--muted-foreground) !important;
}

#arcane-root.arcane-theme-shadcn .arcane-demo-section-title {
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-shadcn .arcane-demo-preview-scope {
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
  border-width: 1px !important;
  background: color-mix(in srgb, var(--card) 96%, var(--background)) !important;
}

#arcane-root.arcane-theme-shadcn .arcane-demo-preview-scope > .arcane-box {
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
}

#arcane-root.arcane-theme-shadcn .arcane-demo-missing {
  border: 1px solid var(--shadcn-subtle-line) !important;
  border-radius: var(--radius-md) !important;
  background: var(--background) !important;
  color: var(--foreground) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-shadcn .arcane-demo-missing-icon {
  border: 1px solid color-mix(in srgb, var(--warning, #f59e0b) 42%, var(--border)) !important;
  border-radius: var(--radius-sm) !important;
  background: color-mix(in srgb, var(--warning, #f59e0b) 16%, var(--background)) !important;
  color: color-mix(in srgb, var(--warning, #f59e0b) 74%, var(--foreground)) !important;
}

#arcane-root.arcane-theme-shadcn .arcane-demo-missing-title {
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-shadcn .arcane-demo-missing-body {
  color: var(--muted-foreground) !important;
}

@media (max-width: 900px) {
  #arcane-root.arcane-theme-shadcn .arcane-scaffold-sidebar.arcane-scaffold-sidebar {
    position: static !important;
    top: auto !important;
    height: auto !important;
    max-height: none !important;
    min-height: 0 !important;
    overflow: visible !important;
  }
}


#arcane-root.arcane-theme-shadcn .kb-topbar::before,
#arcane-root.arcane-theme-shadcn .kb-topbar::after {
  content: none !important;
  display: none !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-shadcn .kb-toc-panel {
  position: sticky !important;
  top: 5rem !important;
  align-self: flex-start !important;
  width: 100% !important;
  max-height: none !important;
  overflow: visible !important;
}

@media (max-width: 1200px) {
  #arcane-root.arcane-theme-shadcn .kb-content-area {
    grid-template-columns: minmax(0, 1fr) !important;
  }

  #arcane-root.arcane-theme-shadcn .kb-toc-panel {
    display: none !important;
  }
}

@media (max-width: 900px) {
  #arcane-root.arcane-theme-shadcn
    .arcane-scaffold-body:not([data-has-sidebar]):not([data-has-secondary]),
  #arcane-root.arcane-theme-shadcn
    .arcane-scaffold-body[data-has-sidebar]:not([data-has-secondary]),
  #arcane-root.arcane-theme-shadcn
    .arcane-scaffold-body:not([data-has-sidebar])[data-has-secondary],
  #arcane-root.arcane-theme-shadcn
    .arcane-scaffold-body[data-has-sidebar][data-has-secondary] {
    grid-template-columns: minmax(0, 1fr) !important;
  }

  #arcane-root.arcane-theme-shadcn .arcane-scaffold-sidebar.arcane-scaffold-sidebar {
    position: static !important;
    width: auto !important;
  }

  #arcane-root.arcane-theme-shadcn .kb-content-area {
    padding: 1.25rem !important;
  }
}


#arcane-root.arcane-theme-shadcn .kb-landing-hero {
  background: var(--card);
}

#arcane-root.arcane-theme-shadcn .kb-landing-prose {
  display: grid;
  gap: clamp(1.5rem, 2.4vw, 2.4rem);
}

#arcane-root.arcane-theme-shadcn .kb-landing-prose > * + * {
  margin-top: 0;
}

#arcane-root.arcane-theme-shadcn .kb-landing-grid {
  gap: clamp(1.25rem, 2vw, 1.8rem);
  margin-top: 1.25rem;
  margin-bottom: 1.5rem;
}

#arcane-root.arcane-theme-shadcn .kb-landing-band {
  gap: clamp(1.45rem, 2.4vw, 2.2rem);
  margin-top: 1.25rem;
  padding: clamp(1.5rem, 2.4vw, 2.25rem);
}

#arcane-root.arcane-theme-shadcn .kb-landing-terminal-body,
#arcane-root.arcane-theme-shadcn .kb-landing-list {
  gap: 1rem;
}

#arcane-root.arcane-theme-shadcn .kb-landing-card:hover {
  border-color: color-mix(in srgb, var(--primary) 42%, var(--border));
  box-shadow: none;
}

''';

  const ShadcnCss._();

  static String componentCss(ShadcnTheme theme) {
    final String neutralOverrides = theme == ShadcnTheme.midnight
        ? '''
#arcane-root.arcane-theme-shadcn {
  --card: #ffffff;
  --card-foreground: #09090b;
  --popover: #ffffff;
  --popover-foreground: #09090b;
  --muted: #f4f4f5;
  --muted-foreground: #696970;
  --accent: #f4f4f5;
  --accent-foreground: #18181b;
  --border: #e4e4e7;
  --input: #e4e4e7;
}

html.dark #arcane-root.arcane-theme-shadcn,
#arcane-root.dark.arcane-theme-shadcn {
  --background: #050505;
  --foreground: #F7F4EC;
  --card: #111111;
  --card-foreground: #F7F4EC;
  --card-hover: #1A1A1A;
  --popover: #1A1A1A;
  --popover-foreground: #F7F4EC;
  --muted: #111111;
  --muted-foreground: #A8A39A;
  --accent: #1A1A1A;
  --accent-foreground: #F7F4EC;
  --border: #2C2C2C;
  --input: #232323;
}
'''
        : '';

    return '''
$neutralOverrides

#arcane-root.arcane-theme-shadcn {
  --shadcn-control-border: color-mix(in srgb, var(--foreground) 48%, var(--background));
}

#arcane-root.arcane-theme-shadcn .arcane-button {
  background-color: var(--shadcn-button-background);
  color: var(--shadcn-button-foreground);
  border: 1px solid transparent;
}

#arcane-root.arcane-theme-shadcn .arcane-button[data-variant='primary'] {
  --shadcn-button-background: var(--primary);
  --shadcn-button-foreground: var(--primary-foreground);
}

#arcane-root.arcane-theme-shadcn .arcane-button[data-variant='secondary'] {
  --shadcn-button-background: var(--secondary);
  --shadcn-button-foreground: var(--secondary-foreground);
}

#arcane-root.arcane-theme-shadcn .arcane-button[data-variant='outline'] {
  --shadcn-button-background: var(--background);
  --shadcn-button-foreground: var(--foreground);
  border-color: var(--shadcn-control-border);
}

#arcane-root.arcane-theme-shadcn .arcane-button[data-variant='ghost'] {
  --shadcn-button-background: transparent;
  --shadcn-button-foreground: var(--foreground);
}

#arcane-root.arcane-theme-shadcn .arcane-button[data-variant='link'] {
  --shadcn-button-background: transparent;
  --shadcn-button-foreground: var(--primary);
  text-underline-offset: 4px;
}

#arcane-root.arcane-theme-shadcn .arcane-button[data-variant='destructive'] {
  --shadcn-button-background: var(--destructive);
  --shadcn-button-foreground: var(--destructive-foreground);
}

#arcane-root.arcane-theme-shadcn .arcane-button[data-variant='success'] {
  --shadcn-button-background: var(--success);
  --shadcn-button-foreground: var(--success-foreground);
}

#arcane-root.arcane-theme-shadcn .arcane-button[data-variant='warning'] {
  --shadcn-button-background: var(--warning);
  --shadcn-button-foreground: var(--warning-foreground);
}

#arcane-root.arcane-theme-shadcn .arcane-button[data-variant='info'] {
  --shadcn-button-background: var(--info);
  --shadcn-button-foreground: var(--info-foreground);
}

#arcane-root.arcane-theme-shadcn .arcane-button:hover:not([data-disabled='true']) {
  background-color: color-mix(in srgb, var(--shadcn-button-background) 88%, var(--shadcn-button-foreground));
  color: var(--shadcn-button-foreground);
}

#arcane-root.arcane-theme-shadcn
  .arcane-button:is([data-variant='outline'], [data-variant='ghost']):hover:not([data-disabled='true']) {
  background-color: var(--accent);
  color: var(--accent-foreground);
}

#arcane-root.arcane-theme-shadcn .arcane-button[data-variant='link']:hover:not([data-disabled='true']) {
  background-color: transparent;
  text-decoration-thickness: 2px;
}

.arcane-button,
.arcane-text-input,
.arcane-textarea,
.arcane-select,
.arcane-select-option,
.arcane-dropdown-item,
.arcane-context-menu-item,
.arcane-tab,
.arcane-tab-bar-item,
.arcane-menubar-trigger,
.arcane-dialog-close,
.arcane-sheet-close,
.arcane-drawer-close,
.arcane-checkbox,
.arcane-radio-circle,
.arcane-toggle-switch,
.arcane-pagination-link,
.arcane-date-picker-trigger,
.arcane-otp-digit,
.arcane-calendar-day,
.arcane-calendar-nav-btn {
  transition:
    color var(--transition),
    background-color var(--transition),
    border-color var(--transition),
    box-shadow var(--transition),
    opacity var(--transition),
    transform var(--transition);
}

.arcane-text-input:hover:not(:disabled),
.arcane-select:hover:not(:disabled):not(.disabled),
.arcane-select-option:hover:not(:disabled):not(.disabled),
.arcane-dropdown-item:hover:not(.disabled),
.arcane-context-menu-item:hover:not(.disabled),
.arcane-tab:hover:not(.disabled),
.arcane-tab-bar-item:hover:not(.disabled),
.arcane-menubar-trigger:hover,
.arcane-dialog-close:hover,
.arcane-sheet-close:hover,
.arcane-drawer-close:hover,
.arcane-pagination-link:hover:not(:disabled):not(.disabled),
.arcane-date-picker-trigger:hover:not(:disabled),
.arcane-calendar-day:hover:not(:disabled),
.arcane-calendar-nav-btn:hover:not(:disabled) {
  background-color: var(--accent);
  color: var(--accent-foreground);
}

.arcane-button:focus-visible,
.arcane-text-input:focus-visible,
.arcane-textarea:focus-visible,
.arcane-select:focus-visible,
.arcane-select-option:focus-visible,
.arcane-dropdown-item:focus-visible,
.arcane-context-menu-item:focus-visible,
.arcane-tab:focus-visible,
.arcane-tab-bar-item:focus-visible,
.arcane-menubar-trigger:focus-visible,
.arcane-dialog-close:focus-visible,
.arcane-sheet-close:focus-visible,
.arcane-drawer-close:focus-visible,
.arcane-checkbox:focus-visible,
.arcane-radio-input:focus-visible + .arcane-radio-circle,
.arcane-toggle-switch:focus-visible,
.arcane-pagination-link:focus-visible,
.arcane-date-picker-trigger:focus-visible,
.arcane-otp-digit:focus-visible,
.arcane-calendar-day:focus-visible,
.arcane-calendar-nav-btn:focus-visible {
  outline: none;
  box-shadow: 0 0 0 2px var(--background), 0 0 0 4px var(--ring);
}

.arcane-button:disabled,
.arcane-button[data-disabled='true'],
.arcane-button.disabled,
.arcane-text-input:disabled,
.arcane-text-input[data-disabled='true'],
.arcane-textarea:disabled,
.arcane-textarea[data-disabled='true'],
.arcane-select:disabled,
.arcane-select[data-disabled='true'],
.arcane-select.disabled,
.arcane-select-option:disabled,
.arcane-select-option[data-disabled='true'],
.arcane-select-option.disabled,
.arcane-dropdown-item[data-disabled='true'],
.arcane-dropdown-item.disabled,
.arcane-context-menu-item[data-disabled='true'],
.arcane-context-menu-item.disabled,
.arcane-tab[data-disabled='true'],
.arcane-tab.disabled,
.arcane-tab-bar-item[data-disabled='true'],
.arcane-tab-bar-item.disabled,
.arcane-menubar-trigger[data-disabled='true'],
.arcane-checkbox[data-disabled='true'],
.arcane-radio-item[data-disabled='true'],
.arcane-toggle-switch[data-disabled='true'],
.arcane-pagination-link:disabled,
.arcane-pagination-link[data-disabled='true'],
.arcane-pagination-link.disabled,
.arcane-date-picker-trigger:disabled,
.arcane-date-picker-trigger[data-disabled='true'],
.arcane-otp-digit:disabled,
.arcane-otp-digit[data-disabled='true'],
.arcane-calendar-day:disabled,
.arcane-calendar-day[data-disabled='true'],
.arcane-calendar-nav-btn:disabled {
  pointer-events: none;
  opacity: 0.5;
}

/* Open/active *triggers* take the accent highlight. The dropdown *panel*
   (.arcane-dropdown-menu) is deliberately absent: it is a popover surface, and
   painting it with --accent would drop it off the --popover token pair the rest
   of the floating surfaces share. */
.arcane-select[data-open='true'],
.arcane-menubar-trigger[data-state='open'],
.arcane-date-picker-trigger[data-state='open'],
.arcane-tab[data-state='active'],
.arcane-tab-bar-item[data-state='active'],
.arcane-select-option[data-state='checked'],
.arcane-dropdown-item[data-state='checked'],
.arcane-context-menu-item[data-state='checked'],
.arcane-menubar-item[data-state='checked'] {
  background-color: var(--accent);
  color: var(--accent-foreground);
}

.arcane-select[data-open='true'],
.arcane-date-picker-trigger[data-state='open'],
.arcane-calendar-day[data-state='selected'] {
  border-color: var(--ring);
}

#arcane-root.arcane-theme-shadcn .arcane-checkbox[data-arcane-state='selected'] {
  --shadcn-checkbox-background: var(--shadcn-checkbox-fill);
  --shadcn-checkbox-indicator: inline-flex;
}

#arcane-root.arcane-theme-shadcn .arcane-toggle-switch[data-arcane-state='selected'] {
  --shadcn-switch-background: var(--shadcn-switch-active);
  --shadcn-switch-border: transparent;
  --shadcn-switch-offset: var(--shadcn-switch-travel);
}

.arcane-textarea::placeholder {
  color: var(--muted-foreground);
  opacity: 1;
}

.arcane-textarea[data-readonly='true'] {
  background-color: var(--muted);
  color: var(--muted-foreground);
  caret-color: var(--muted-foreground);
  cursor: default;
}

.arcane-text-input[data-error='true'],
.arcane-select[data-error='true'],
.arcane-otp-digit.error,
.arcane-textarea[data-error='true'] {
  border-color: var(--destructive);
}

#arcane-root.arcane-theme-shadcn
  :is(.arcane-radio-item, .arcane-radio-card, .arcane-radio-button):has(input:checked) {
  --shadcn-radio-dot-opacity: 1;
  --shadcn-radio-border: var(--primary);
  --shadcn-radio-ink: var(--primary);
  --shadcn-radio-indicator-width: 5px;
  --shadcn-radio-card-background: var(--accent);
  --shadcn-radio-button-background: var(--primary);
  --shadcn-radio-button-ink: var(--primary-foreground);
}

#arcane-root.arcane-theme-shadcn
  :is(.arcane-radio-card, .arcane-radio-button):has(input:focus-visible) {
  outline: 2px solid var(--ring);
  outline-offset: 2px;
}

@media (forced-colors: active) {
  #arcane-root.arcane-theme-shadcn :focus-visible {
    outline: 2px solid Highlight !important;
    outline-offset: 2px;
    box-shadow: none;
  }
}

/* ============================================
   PROSE - ShadCN Clean Typography
   ============================================ */
.prose {
  max-width: 65ch;
  color: var(--foreground);
  line-height: 1.75;
}

.prose h1, .prose h2, .prose h3,
.prose h4, .prose h5, .prose h6 {
  color: var(--foreground);
  font-weight: 600;
  line-height: 1.25;
  margin-top: 2rem;
  margin-bottom: 1rem;
}

.prose h1 { font-size: 2.25rem; margin-top: 0; }
.prose h2 {
  font-size: 1.5rem;
  border-bottom: 1px solid var(--border);
  padding-bottom: 0.5rem;
}
.prose h3 { font-size: 1.25rem; }
.prose h4 { font-size: 1.125rem; }

.prose p {
  margin-bottom: 1.25rem;
}

.prose a {
  color: var(--primary);
  text-decoration: underline;
  text-underline-offset: 2px;
  transition: color 0.15s ease;
}

.prose a:hover {
  opacity: 0.8;
}

.prose strong, .prose b {
  font-weight: 600;
}

.prose ul, .prose ol {
  margin-bottom: 1.25rem;
  padding-left: 1.5rem;
}

.prose li {
  margin-bottom: 0.5rem;
}

.prose li::marker {
  color: var(--muted-foreground);
}

.prose blockquote {
  border-left: 4px solid var(--border);
  padding-left: 1rem;
  margin: 1.5rem 0;
  font-style: italic;
  color: var(--muted-foreground);
}

.prose hr {
  border: none;
  border-top: 1px solid var(--border);
  margin: 2rem 0;
}

.prose table {
  width: 100%;
  border-collapse: collapse;
  margin: 1.5rem 0;
}

.prose th, .prose td {
  border: 1px solid var(--border);
  padding: 0.75rem;
  text-align: left;
}

.prose th {
  background: var(--muted);
  font-weight: 600;
}

.prose img {
  max-width: 100%;
  height: auto;
  border-radius: var(--radius-md);
  margin: 1.5rem 0;
}

/* Nested cards are sub-surfaces: a card inside another card drops its frame so
   stacked panels do not border twice. Re-assert a frame on the inner card with
   decoration:/styles:. */
#arcane-root.arcane-theme-shadcn .arcane-card .arcane-card:not([data-arcane-decorated]) {
  background: transparent !important;
  border-color: transparent !important;
  box-shadow: none !important;
}

/* Code blocks */
.prose pre {
  background: var(--muted);
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  padding: 1rem 1.25rem;
  overflow-x: auto;
  margin: 1.5rem 0;
}

.prose code {
  font-family: var(--font-mono);
  font-size: 0.875em;
}

.prose :not(pre) > code {
  background: var(--muted);
  padding: 0.125rem 0.375rem;
  border-radius: var(--radius-sm);
  font-size: 0.875em;
}

/* Syntax highlighting - Light */
.prose .hljs-keyword { color: #d73a49; }
.prose .hljs-string { color: #032f62; }
.prose .hljs-number { color: #005cc5; }
.prose .hljs-function, .prose .hljs-title { color: #6f42c1; }
.prose .hljs-comment { color: #6a737d; font-style: italic; }
.prose .hljs-variable { color: #e36209; }
.prose .hljs-class, .prose .hljs-built_in { color: #22863a; }

/* Syntax highlighting - Dark */
.dark .prose .hljs-keyword { color: #ff7b72; }
.dark .prose .hljs-string { color: #a5d6ff; }
.dark .prose .hljs-number { color: #79c0ff; }
.dark .prose .hljs-function, .dark .prose .hljs-title { color: #d2a8ff; }
.dark .prose .hljs-comment { color: #8b949e; font-style: italic; }
.dark .prose .hljs-variable { color: #ffa657; }
.dark .prose .hljs-class, .dark .prose .hljs-built_in { color: #7ee787; }

/* Tree Lines for Disclosure/Navigation
   Each item draws its own connectors:
   - ::before = horizontal branch to content
   - ::after = vertical line down to next sibling (except last item = L-connector)
*/
.arcane-tree-lines {
  position: relative;
  --tree-indent: 1rem;
  --tree-line-color: var(--border);
}

/* Each direct child is a tree item */
.arcane-tree-lines > * {
  position: relative;
  padding-left: var(--tree-indent);
}

/* Horizontal branch from vertical line to content */
.arcane-tree-lines > *::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  width: calc(var(--tree-indent) - 4px);
  height: 1px;
  background: var(--tree-line-color);
}

/* Vertical line segment - connects this item to the next */
.arcane-tree-lines > *::after {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 1px;
  background: var(--tree-line-color);
}

/* Last item: L-connector - vertical line only goes to the horizontal branch */
.arcane-tree-lines > *:last-child::after {
  bottom: 50%;
}

/* First item: start vertical line from horizontal branch */
.arcane-tree-lines > *:first-child::after {
  top: 50%;
}

/* Only child: just horizontal branch, no vertical */
.arcane-tree-lines > *:only-child::after {
  display: none;
}

/* Nested tree lines - progressively lighter for visual hierarchy */
.arcane-tree-lines .arcane-tree-lines {
  --tree-line-color: color-mix(in srgb, var(--border) 70%, transparent);
}

.arcane-tree-lines .arcane-tree-lines .arcane-tree-lines {
  --tree-line-color: color-mix(in srgb, var(--border) 50%, transparent);
}

.arcane-tree-lines .arcane-tree-lines .arcane-tree-lines .arcane-tree-lines {
  --tree-line-color: color-mix(in srgb, var(--border) 35%, transparent);
}

$arcaneSidebarTreeStyles

$arcaneSidebarComponentStyles

$arcaneMapCss

$arcaneTocTreeLinesCss

$_lexiconCss
''';
  }
}
