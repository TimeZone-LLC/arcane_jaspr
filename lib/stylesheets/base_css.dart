library;

class ArcaneBaseCss {
  const ArcaneBaseCss._();

  static const String shared = '''
@font-face {
  font-family: 'lucide';
  src: url('/assets/fonts/lucide/lucide.woff2') format('woff2'),
       url('/fonts/lucide/lucide.woff2') format('woff2'),
       url('assets/fonts/lucide/lucide.woff2') format('woff2'),
       url('fonts/lucide/lucide.woff2') format('woff2'),
       url('../assets/fonts/lucide/lucide.woff2') format('woff2'),
       url('../fonts/lucide/lucide.woff2') format('woff2'),
       url('../../assets/fonts/lucide/lucide.woff2') format('woff2'),
       url('../../fonts/lucide/lucide.woff2') format('woff2'),
       url('/assets/fonts/lucide/lucide.woff') format('woff'),
       url('/fonts/lucide/lucide.woff') format('woff'),
       url('assets/fonts/lucide/lucide.woff') format('woff'),
       url('fonts/lucide/lucide.woff') format('woff'),
       url('../assets/fonts/lucide/lucide.woff') format('woff'),
       url('../fonts/lucide/lucide.woff') format('woff'),
       url('../../assets/fonts/lucide/lucide.woff') format('woff'),
       url('../../fonts/lucide/lucide.woff') format('woff'),
       url('/assets/fonts/lucide/lucide.ttf') format('truetype'),
       url('/fonts/lucide/lucide.ttf') format('truetype'),
       url('assets/fonts/lucide/lucide.ttf') format('truetype'),
       url('fonts/lucide/lucide.ttf') format('truetype'),
       url('../assets/fonts/lucide/lucide.ttf') format('truetype'),
       url('../fonts/lucide/lucide.ttf') format('truetype'),
       url('../../assets/fonts/lucide/lucide.ttf') format('truetype'),
       url('../../fonts/lucide/lucide.ttf') format('truetype');
  font-weight: normal;
  font-style: normal;
  font-display: block;
}

*, *::before, *::after {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

/* Author-level display rules must never override the native hidden contract. */
[hidden] {
  display: none !important;
}

.arcane-mega-menu-trigger {
  color: var(--muted-foreground);
}

.arcane-mega-menu-trigger[aria-expanded="true"] {
  color: var(--foreground);
}

.arcane-mega-menu-trigger[aria-expanded="true"] > [aria-hidden="true"] {
  transform: rotate(180deg);
}

html, body {
  height: 100%;
  font-family: var(--font-sans);
  background-color: var(--background);
  color: var(--foreground);
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

* {
  scrollbar-width: thin;
  scrollbar-color: var(--primary) transparent;
}

*::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

*::-webkit-scrollbar-track {
  background: transparent;
}

*::-webkit-scrollbar-thumb {
  background: var(--primary);
  border-radius: var(--radius-xs);
  border: 2px solid transparent;
  background-clip: padding-box;
}

*::-webkit-scrollbar-thumb:hover {
  background: color-mix(in srgb, var(--primary) 80%, white);
  border: 2px solid transparent;
  background-clip: padding-box;
}

*::-webkit-scrollbar-corner {
  background: transparent;
}

html.dark, html.dark body,
html.light, html.light body {
  scrollbar-width: thin;
  scrollbar-color: var(--primary) var(--background);
}

html::-webkit-scrollbar,
body::-webkit-scrollbar {
  width: 8px;
  height: 8px;
}

html.dark::-webkit-scrollbar-track,
html.dark body::-webkit-scrollbar-track,
html.light::-webkit-scrollbar-track,
html.light body::-webkit-scrollbar-track {
  background: var(--background);
}

html.dark::-webkit-scrollbar-thumb,
html.dark body::-webkit-scrollbar-thumb,
html.light::-webkit-scrollbar-thumb,
html.light body::-webkit-scrollbar-thumb {
  background: var(--primary);
  border-radius: var(--radius-xs);
  border: 2px solid transparent;
  background-clip: padding-box;
}

html.dark::-webkit-scrollbar-thumb:hover,
html.dark body::-webkit-scrollbar-thumb:hover,
html.light::-webkit-scrollbar-thumb:hover,
html.light body::-webkit-scrollbar-thumb:hover {
  background: color-mix(in srgb, var(--primary) 80%, white);
  border: 2px solid transparent;
  background-clip: padding-box;
}

html.dark::-webkit-scrollbar-corner,
html.dark body::-webkit-scrollbar-corner,
html.light::-webkit-scrollbar-corner,
html.light body::-webkit-scrollbar-corner {
  background: var(--background);
}

::selection {
  background: var(--primary);
  color: var(--primary-foreground);
}

::-moz-selection {
  background: var(--primary);
  color: var(--primary-foreground);
}

.focus-ring:focus-visible {
  outline: none;
  box-shadow: 0 0 0 2px var(--background), 0 0 0 4px var(--ring);
}

/* Native single-select values reserve enough inline space for either the
   browser arrow or the renderer-owned Arcane chevron. ArcaneSelect renders its
   own glyph as a sibling so controls never depend on a background image. */
#arcane-root select:not([multiple]) {
  padding-inline-end: 40px;
}

/* Text fields use one focus perimeter. When a prefix/suffix shell owns the
   border, its inner input must stay borderless and shadowless; focus changes
   the shell border instead of painting a second ring around the input. Win95
   keeps its intentional inset dotted focus rectangle. */
#arcane-root:not(.arcane-theme-win95)
  [data-arcane-field-shell="true"]:focus-within {
  outline: none !important;
  border-color: var(--ring, var(--primary)) !important;
  box-shadow: none !important;
}

#arcane-root:not(.arcane-theme-win95)
  [data-arcane-field-shell="true"]
  > input[data-arcane-field-inner="true"][data-arcane-field-control="true"] {
  border: 0 !important;
  outline: none !important;
  box-shadow: none !important;
}

#arcane-root:not(.arcane-theme-win95)
  [data-arcane-field-shell="true"]
  > input[data-arcane-field-inner="true"][data-arcane-field-control="true"]:focus-visible,
#arcane-root:not(.arcane-theme-win95)
  [data-arcane-field-control="true"][data-arcane-field-control="true"][data-arcane-field-control="true"]:focus-visible,
#arcane-root.arcane-theme-neon select:not([multiple]):focus-visible {
  outline: none !important;
  border-color: var(--ring, var(--primary)) !important;
  box-shadow: none !important;
  transform: none !important;
}

/* Field: shadcn Field, FieldGroup and FieldSet. Responsive fields follow the
   nearest field group's width (shadcn's @md/field-group), never the viewport.
   Themes tune the control height the label lines up with through
   --arcane-field-control-height. */
[data-slot="field-set"] {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  min-width: 0;
  border: 0;
}

[data-slot="field-legend"] {
  margin-bottom: 0.75rem;
  font-size: 1rem;
  font-weight: var(--font-weight-medium, 500);
}

[data-slot="field-legend"][data-variant="label"] {
  font-size: 0.875rem;
}

[data-slot="field-group"] {
  container: field-group / inline-size;
  display: flex;
  flex-direction: column;
  gap: 1.75rem;
  width: 100%;
}

[data-slot="field-group"] > [data-slot="field-group"] {
  gap: 1rem;
}

[data-slot="field"] {
  display: flex;
  gap: 0.75rem;
  width: 100%;
  min-width: 0;
}

[data-slot="field"][data-invalid="true"] {
  color: var(--destructive);
}

[data-slot="field"]:is([data-orientation="vertical"], [data-orientation="responsive"]) {
  flex-direction: column;
}

[data-slot="field"]:is([data-orientation="vertical"], [data-orientation="responsive"]) > * {
  width: 100%;
}

[data-slot="field"][data-orientation="horizontal"] {
  flex-direction: row;
  align-items: center;
}

[data-slot="field"][data-orientation="horizontal"] > [data-slot="field-label"] {
  flex: auto;
}

[data-slot="field"][data-orientation="horizontal"]:has(> [data-slot="field-content"]) {
  align-items: flex-start;
}

[data-slot="field"][data-orientation="horizontal"]:has(> [data-slot="field-content"]) > :is([role="checkbox"], [role="radio"]) {
  margin-top: 1px;
}

[data-slot="field"][data-orientation="horizontal"][data-label-width="true"] > [data-slot="field-label"] {
  flex: 0 0 var(--arcane-field-label-width);
  min-height: var(--arcane-field-control-height, 2.25rem);
}

[data-slot="field"][data-orientation="horizontal"][data-label-width="true"] > :not([data-slot="field-label"]) {
  flex: 1 1 0%;
  min-width: 0;
}

@container field-group (min-width: 28rem) {
  [data-slot="field"][data-orientation="responsive"] {
    flex-direction: row;
    align-items: center;
  }

  [data-slot="field"][data-orientation="responsive"] > * {
    width: auto;
  }

  [data-slot="field"][data-orientation="responsive"] > [data-slot="field-label"] {
    flex: auto;
  }

  [data-slot="field"][data-orientation="responsive"]:has(> [data-slot="field-content"]) {
    align-items: flex-start;
  }

  [data-slot="field"][data-orientation="responsive"]:has(> [data-slot="field-content"]) > :is([role="checkbox"], [role="radio"]) {
    margin-top: 1px;
  }

  [data-slot="field"][data-orientation="responsive"][data-label-width="true"] > [data-slot="field-label"] {
    flex: 0 0 var(--arcane-field-label-width);
    min-height: var(--arcane-field-control-height, 2.25rem);
  }

  [data-slot="field"][data-orientation="responsive"][data-label-width="true"] > :not([data-slot="field-label"]) {
    flex: 1 1 0%;
    min-width: 0;
  }
}

[data-slot="field-content"] {
  display: flex;
  flex: 1 1 0%;
  flex-direction: column;
  gap: 0.375rem;
  min-width: 0;
  line-height: 1.375;
}

[data-slot="field-label"] {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  width: fit-content;
  min-width: 0;
  font-size: 0.875rem;
  font-weight: var(--font-weight-medium, 500);
  line-height: 1.375;
  overflow-wrap: anywhere;
  user-select: none;
}

:is(label[data-slot="field-label"], [data-slot="field-label"] > label)[for] {
  cursor: pointer;
}

[data-slot="field-label"] .arcane-field-required {
  color: var(--destructive);
}

[data-slot="field"][data-disabled="true"] [data-slot="field-label"],
[data-slot="field"][data-disabled="true"] [data-slot="field-label"] > label {
  opacity: 0.5;
  cursor: not-allowed;
}

/* Choice card: a label wrapping a whole field. */
[data-slot="field-label"]:has(> [data-slot="field"]) {
  flex-direction: column;
  width: 100%;
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
}

[data-slot="field-label"] > [data-slot="field"] {
  padding: 1rem;
}

[data-slot="field-label"]:has([data-state="checked"], [aria-checked="true"], :checked) {
  border-color: var(--primary);
  background-color: color-mix(in srgb, var(--primary) 5%, transparent);
}

[data-slot="field-description"] {
  color: var(--muted-foreground);
  font-size: 0.875rem;
  font-weight: var(--font-weight-normal, 400);
  line-height: 1.5;
}

[data-slot="field"][data-orientation="horizontal"] [data-slot="field-description"] {
  text-wrap: balance;
}

[data-slot="field-description"]:nth-last-child(2) {
  margin-top: -0.25rem;
}

[data-slot="field-description"]:last-child {
  margin-top: 0;
}

[data-slot="field-legend"][data-variant="legend"] + [data-slot="field-description"] {
  margin-top: -0.375rem;
}

[data-slot="field-description"] a {
  text-decoration: underline;
  text-underline-offset: 4px;
}

[data-slot="field-description"] a:hover {
  color: var(--primary);
}

[data-slot="field-error"] {
  color: var(--destructive);
  font-size: 0.875rem;
  font-weight: var(--font-weight-normal, 400);
}

[data-slot="field-error"] ul {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  margin-left: 1rem;
  list-style: disc;
}

[data-slot="field-separator"] {
  position: relative;
  height: 1.25rem;
  margin: -0.5rem 0;
  font-size: 0.875rem;
}

[data-slot="field-separator"] > .arcane-field-separator-line {
  position: absolute;
  top: 50%;
  right: 0;
  left: 0;
  height: 1px;
  background-color: var(--border);
}

[data-slot="field-separator-content"] {
  position: relative;
  display: block;
  width: fit-content;
  margin: 0 auto;
  padding: 0 0.5rem;
  background-color: var(--background);
  color: var(--muted-foreground);
}
/* Field end */

/* A surface nested inside any other surface becomes an open content region,
   so a card inside a card or a dialog loses its second frame. The renderer
   owns this marker, so custom classes and per-instance styles cannot restore
   it. Floating layers (popovers, hover cards, menus, context menus, command
   palettes, dialogs, sheets and drawers) are separate windows and keep their
   own frame wherever they are nested. */
[data-arcane-surface]
  [data-arcane-surface]:not([data-arcane-surface="popover"], [data-arcane-surface="hovercard"], [data-arcane-surface="menu"], [data-arcane-surface="context-menu"], [data-arcane-surface="command"], [data-arcane-surface="dialog"], [data-arcane-surface="sheet"], [data-arcane-surface="drawer"]) {
  background: transparent !important;
  border-color: transparent !important;
  box-shadow: none !important;
}

/* Native control popups (select option lists, date pickers, scrollbars)
   follow the app brightness instead of the operating system setting. */
#arcane-root.light {
  color-scheme: light;
}

#arcane-root.dark {
  color-scheme: dark;
}

/* iOS Safari zooms the viewport when a focused text control renders below
   16px. Keep each theme's desktop type scale while flooring native controls on
   touch-oriented devices. !important is required because renderers emit their
   configured control size inline. */
@media (pointer: coarse) {
  #arcane-root :is(input, textarea, select) {
    font-size: max(16px, 1em) !important;
  }
}

@media (prefers-reduced-motion: reduce) {
  .arcane-carousel-track {
    animation: none !important;
  }
}

.arcane-loader {
  display: inline-block;
  box-sizing: border-box;
  flex-shrink: 0;
  width: var(--arcane-loader-size, 24px);
  height: var(--arcane-loader-size, 24px);
  border: 2px solid var(--arcane-loader-color, currentColor);
  border-right-color: transparent;
  border-radius: 50%;
  animation: arcane-spin 0.75s linear infinite;
  vertical-align: middle;
}

@keyframes arcane-spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
}

@keyframes arcane-fade-in {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes arcane-fade-out {
  from { opacity: 1; }
  to { opacity: 0; }
}

@keyframes arcane-slide-in-up {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes arcane-slide-in-down {
  from { opacity: 0; transform: translateY(-10px); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes arcane-slide-in-left {
  from { opacity: 0; transform: translateX(-10px); }
  to { opacity: 1; transform: translateX(0); }
}

@keyframes arcane-slide-in-right {
  from { opacity: 0; transform: translateX(10px); }
  to { opacity: 1; transform: translateX(0); }
}

@keyframes arcane-scale-in {
  from { opacity: 0; transform: scale(0.95); }
  to { opacity: 1; transform: scale(1); }
}

@keyframes arcane-scale-out {
  from { opacity: 1; transform: scale(1); }
  to { opacity: 0; transform: scale(0.95); }
}

@keyframes arcane-bounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}

@keyframes arcane-pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}

@keyframes arcane-dropdown-fade {
  from { opacity: 0; transform: scale(0.95) translateY(-4px); }
  to { opacity: 1; transform: scale(1) translateY(0); }
}

.arcane-button:hover:not([disabled]) {
  filter: brightness(0.95);
}

.arcane-button:active:not([disabled]) {
  filter: brightness(0.9);
}

@keyframes scroll-carousel {
  0% { transform: translateX(0); }
  100% { transform: translateX(-50%); }
}

.arcane-carousel-track:hover {
  animation-play-state: paused;
}

.arcane-carousel-track.dragging {
  animation: none !important;
  cursor: var(--arcane-drag-cursor-active, grabbing);
}

.arcane-carousel-track.dragging * {
  pointer-events: none;
}

.arcane-carousel-track.resuming {
  transition: none;
}

/* Shift-held coordinate picking on a map. The script toggles the class instead
   of writing an inline cursor so themes can swap the glyph. */
.arcane-map-picking {
  cursor: crosshair;
}

.arcane-page {
  --arcane-page-max-width: 72rem;
  --arcane-page-inline-gutter: clamp(1rem, 4vw, 3rem);
  width: 100%;
  max-width: var(--arcane-page-max-width);
  min-width: 0;
  margin-inline: auto;
  padding-block: clamp(1.25rem, 3vw, 3rem);
  padding-inline: var(--arcane-page-inline-gutter);
  display: grid;
  grid-template-columns: minmax(0, 1fr);
  gap: clamp(1.25rem, 2.5vw, 2.25rem);
  color: var(--foreground);
}

.arcane-page[data-arcane-page-standalone="false"] {
  padding-block: clamp(0.75rem, 2vw, 1.5rem);
}

.arcane-page-wide {
  --arcane-page-max-width: 90rem;
}

.arcane-page-reading {
  --arcane-page-max-width: 48rem;
}

.arcane-page-workbench {
  --arcane-page-max-width: 100rem;
}

.arcane-page-full,
.arcane-page-media {
  --arcane-page-max-width: 100%;
}

.arcane-page-full {
  --arcane-page-inline-gutter: 0px;
}

.arcane-page-media {
  --arcane-page-inline-gutter: clamp(0.5rem, 1.5vw, 1.5rem);
}

.arcane-page-header {
  min-width: 0;
  display: flex;
  flex-wrap: wrap;
  align-items: flex-end;
  justify-content: space-between;
  gap: clamp(1rem, 3vw, 2rem);
  padding-bottom: clamp(1rem, 2vw, 1.625rem);
  border-bottom: 1px solid var(--border);
}

.arcane-page-heading {
  flex: 1 1 32rem;
  min-width: 0;
  max-width: 52rem;
  display: grid;
  gap: 0.45rem;
}

.arcane-page-eyebrow {
  color: var(--muted-foreground);
  font-size: 0.7rem;
  font-weight: 700;
  letter-spacing: 0.1em;
  line-height: 1.35;
  text-transform: uppercase;
}

.arcane-page-title {
  min-width: 0;
  color: var(--foreground);
  font-size: clamp(2rem, 4vw, 3.25rem);
  letter-spacing: -0.035em;
  line-height: 1.04;
  overflow-wrap: anywhere;
  text-wrap: balance;
}

.arcane-page-description {
  min-width: 0;
  max-width: 45rem;
  color: var(--muted-foreground);
  font-size: 0.98rem;
  line-height: 1.55;
  overflow-wrap: anywhere;
  text-wrap: pretty;
}

.arcane-page-actions {
  flex: 0 1 auto;
  min-width: 0;
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: flex-end;
  gap: 0.5rem;
}

.arcane-page-body {
  width: 100%;
  min-width: 0;
}

.arcane-page-reading .arcane-page-header {
  align-items: flex-start;
}

.arcane-page-reading .arcane-page-actions {
  justify-content: flex-start;
}

@media (max-width: 48rem) {
  .arcane-page-header {
    flex-direction: column;
    align-items: stretch;
  }

  .arcane-page-heading {
    flex-basis: auto;
    width: 100%;
  }

  .arcane-page-actions {
    width: 100%;
    justify-content: flex-start;
  }
}

.arcane-not-found {
  min-height: 100vh;
  min-height: 100dvh;
  display: grid;
  place-items: center;
  padding: clamp(1rem, 4vw, 3rem);
  background: var(--arcane-app-background, var(--background));
  color: var(--foreground);
}

.arcane-not-found[data-arcane-not-found-standalone="false"] {
  min-height: 100%;
  padding-block: clamp(1rem, 3vw, 2rem);
}

.arcane-not-found-surface {
  width: min(100%, 42rem);
  overflow: hidden;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  background: var(--card);
  color: var(--card-foreground);
}

.arcane-not-found-banner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
  min-width: 0;
  padding: 0.75rem 1rem;
  border-bottom: 1px solid var(--border);
  background: var(--muted);
  color: var(--muted-foreground);
  font-size: 0.75rem;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.arcane-not-found-application {
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.arcane-not-found-code {
  flex: 0 0 auto;
  font-variant-numeric: tabular-nums;
}

.arcane-not-found-content {
  display: grid;
  gap: 1rem;
  padding: clamp(1.25rem, 4vw, 2.25rem);
}

.arcane-not-found-title {
  color: inherit;
  font-size: clamp(1.75rem, 6vw, 3rem);
  line-height: 1.08;
  letter-spacing: -0.035em;
}

.arcane-not-found-description {
  max-width: 58ch;
  color: var(--muted-foreground);
  line-height: 1.65;
}

.arcane-not-found-path {
  display: flex;
  flex-wrap: wrap;
  gap: 0.4rem 0.65rem;
  min-width: 0;
  padding: 0.75rem;
  border: 1px solid var(--border);
  border-radius: calc(var(--radius) * 0.75);
  background: var(--muted);
  color: var(--muted-foreground);
  font-size: 0.875rem;
}

.arcane-not-found-path-label {
  flex: 0 0 auto;
  font-weight: 600;
}

.arcane-not-found-path-value {
  min-width: 0;
  overflow-wrap: anywhere;
  color: var(--foreground);
}

.arcane-not-found-actions {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 0.75rem;
}

.arcane-not-found-action {
  display: inline-flex;
  min-height: 2.5rem;
  align-items: center;
  justify-content: center;
  padding: 0.55rem 0.9rem;
  border: 1px solid var(--border);
  border-radius: var(--radius);
  background: var(--card);
  color: var(--card-foreground);
  font-weight: 600;
  line-height: 1.2;
  text-decoration: none;
}

.arcane-not-found-action:hover {
  background: var(--accent);
  color: var(--accent-foreground);
}

.arcane-not-found-action-primary {
  border-color: var(--primary);
  background: var(--primary);
  color: var(--primary-foreground);
}

.arcane-not-found-action-primary:hover {
  filter: brightness(0.95);
}

.arcane-not-found-action:focus-visible {
  outline: 2px solid var(--ring);
  outline-offset: 2px;
}

.arcane-not-found-diagnostic {
  color: var(--muted-foreground);
  font-family: var(--font-mono, monospace);
  font-size: 0.75rem;
  overflow-wrap: anywhere;
}
''';
}
