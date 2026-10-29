class NeuComicSurfacesCss {
  const NeuComicSurfacesCss._();

  static const String styles = r'''
#arcane-root.arcane-theme-neubrutalism.neucomic {
  --neucomic-overlay-shadow: 3px 3px 0 var(--neucomic-paper-edge), 4px 4px 0 var(--neucomic-ink), 7px 7px 0 var(--neucomic-paper-under), 8px 8px 0 var(--neucomic-ink);
  --neucomic-menu-shadow: 2px 2px 0 var(--neucomic-paper-edge), 3px 3px 0 var(--neucomic-ink);
}

/* Cards frame an independent object; statistics and supporting rows stay flat. */
#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-card, .arcane-structured-card, .neubrutalism-feature-card, .neubrutalism-icon-card, .neubrutalism-pricing-card, .neubrutalism-flexi-card):not([data-arcane-decorated]) {
  border: 3px solid var(--arcane-card-accent, var(--neucomic-ink)) !important;
  border-radius: var(--neucomic-panel-radius) !important;
  background: var(--neucomic-paper) !important;
  color: var(--neucomic-paper-ink) !important;
  box-shadow: none !important;
  transform: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .arcane-structured-card:not([data-arcane-decorated]) > :is(.arcane-structured-card-header, .arcane-structured-card-footer) {
  border: 0 !important;
  background: transparent !important;
  padding: 1.25rem 1.25rem 0 !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .arcane-structured-card:not([data-arcane-decorated]) > .arcane-structured-card-header {
  font-weight: 700;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .arcane-structured-card:not([data-arcane-decorated]) > .arcane-structured-card-body {
  padding: .75rem 1.25rem !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .arcane-structured-card:not([data-arcane-decorated]) > .arcane-structured-card-footer {
  padding: .5rem 1.25rem 1.25rem !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-flexi-card-simple {
  border: 0 !important;
  border-bottom: 1px solid var(--border) !important;
  border-radius: 0 !important;
  background: transparent !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .arcane-skeleton-card {
  border: 0 !important;
  background: transparent !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-card[data-variant="ghost"]:not([data-arcane-decorated]) {
  border: 0 !important;
  border-radius: 0 !important;
  background: transparent !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-card[data-variant="outlined"]:not([data-arcane-decorated]) {
  background: transparent !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-card.clickable, .neubrutalism-feature-card.clickable, a.neubrutalism-feature-card, .neubrutalism-icon-card.clickable, a.neubrutalism-icon-card):not([data-arcane-decorated]):hover {
  background: color-mix(in srgb, var(--primary) 5%, var(--card)) !important;
  box-shadow: 3px 3px 0 var(--neucomic-print-ink) !important;
  transform: translate(-1px, -1px) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-feature-card-icon, .neubrutalism-icon-card-icon, .neubrutalism-cta-card-icon, .neubrutalism-pricing-card-icon):not([data-arcane-accent]) {
  border: 0 !important;
  border-radius: 0 !important;
  background: transparent !important;
  color: var(--primary) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-cta-card:not([data-arcane-decorated]) {
  border: 3px solid var(--arcane-card-accent, var(--neucomic-print-ink)) !important;
  border-radius: var(--neucomic-panel-radius) !important;
  background: var(--neucomic-narration) !important;
  color: var(--neucomic-narration-ink) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-cta-card:not([data-arcane-decorated]) > :is(h3, p, .neubrutalism-cta-card-icon) {
  color: var(--neucomic-narration-ink) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-cta-card > h3 {
  font: 400 clamp(1.6rem, 3vw, 2rem)/1.1 var(--font-display) !important;
  letter-spacing: .02em !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-stat-card:not([data-arcane-decorated]) {
  padding: 1rem .25rem !important;
  border: 0 !important;
  border-bottom: 1px solid var(--border) !important;
  border-radius: 0 !important;
  background: transparent !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-stat-card > span:first-of-type {
  font: 600 .8rem/1.4 var(--font-sans) !important;
  letter-spacing: 0 !important;
  text-transform: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-stat-card > div > span:first-child {
  font-size: 2.2rem !important;
  font-weight: 750 !important;
  letter-spacing: -.035em !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-testimonial-card:not([data-arcane-decorated]) {
  position: relative;
  overflow: visible !important;
  margin-bottom: 22px;
  padding: 1.5rem 1.75rem !important;
  border: 3px solid var(--neucomic-ink) !important;
  border-radius: 30px 36px 28px 34px !important;
  background: var(--card) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-testimonial-card:not([data-arcane-decorated])::before,
#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-testimonial-card:not([data-arcane-decorated])::after {
  content: '';
  position: absolute;
  pointer-events: none;
  clip-path: polygon(0 0, 100% 0, 0 100%);
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-testimonial-card:not([data-arcane-decorated])::before {
  left: 32px;
  bottom: -24px;
  width: 28px;
  height: 25px;
  background: var(--neucomic-ink);
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-testimonial-card:not([data-arcane-decorated])::after {
  left: 35px;
  bottom: -17px;
  width: 20px;
  height: 22px;
  background: var(--card);
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-testimonial-card-quote {
  color: var(--primary) !important;
  font-family: var(--font-display) !important;
}

/* Modal edges carry the weight of a comic page panel. */
#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-dialog-overlay {
  padding: min(1.5rem, 24px) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-dialog, .neubrutalism-sheet, .neubrutalism-drawer, .neubrutalism-command-dialog) {
  border: 3px solid var(--neucomic-ink) !important;
  border-radius: var(--neucomic-panel-radius) !important;
  background: var(--neucomic-paper) !important;
  color: var(--neucomic-paper-ink) !important;
  box-shadow: var(--neucomic-overlay-shadow) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-dialog {
  padding: clamp(24px, 4vw, 36px) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-dialog-title,
#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-sheet-header h2 {
  box-sizing: border-box;
  min-width: 0;
  width: fit-content;
  max-width: calc(100% - 36px);
  white-space: normal;
  overflow-wrap: anywhere;
  margin: 0 0 20px !important;
  padding: 6px 12px !important;
  border: 2px solid var(--neucomic-ink);
  background: var(--neucomic-paper-under);
  background-image: var(--neucomic-print-pattern);
  background-size: var(--neucomic-print-size) var(--neucomic-print-size);
  color: var(--neucomic-paper-ink) !important;
  box-shadow: 2px 2px 0 var(--neucomic-ink);
  transform: rotate(-.8deg);
  transform-origin: left center;
  font: 400 clamp(1.8rem, 4vw, 2.3rem)/1.1 var(--font-display) !important;
  letter-spacing: .015em !important;
  text-transform: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-dialog-content, .neubrutalism-sheet-content, .neubrutalism-drawer-content) {
  font-family: var(--font-sans) !important;
  font-size: .9375rem;
  line-height: 1.65;
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-dialog-actions {
  flex-wrap: wrap;
  gap: 10px !important;
  margin-top: 28px !important;
  padding-top: 20px;
  border-top: 1px solid var(--border);
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-sheet-header, .neubrutalism-drawer-header, .neubrutalism-sheet-footer, .neubrutalism-drawer-footer) {
  padding: 20px 24px !important;
  border-color: var(--border) !important;
  background: transparent !important;
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-drawer-header > div {
  font: 400 1.85rem/1.1 var(--font-display) !important;
  letter-spacing: .015em !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-dialog-close, .neubrutalism-sheet-close, .neubrutalism-drawer-close) {
  width: 36px !important;
  height: 36px !important;
  border: 2px solid transparent !important;
  border-radius: 50% !important;
  background: transparent !important;
  color: var(--foreground) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-dialog-close, .neubrutalism-sheet-close, .neubrutalism-drawer-close):hover {
  border-color: var(--neucomic-control-ink) !important;
  background: var(--muted) !important;
  transform: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-confirm-dialog-icon {
  border: 2px solid var(--neucomic-ink) !important;
  border-radius: 50% !important;
  background: var(--muted) !important;
  color: var(--foreground) !important;
  box-shadow: none !important;
}

/* Detached menus get a small ink shadow; attached toolbars stay open. */
#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-dropdown-menu, .neubrutalism-dropdown-submenu, .neubrutalism-context-menu, .neubrutalism-menubar-content, .neubrutalism-select-content, .neubrutalism-date-picker-dropdown, .neubrutalism-time-picker-dropdown, .neubrutalism-popover, .arcane-mega-menu-panel) {
  border: 2px solid var(--neucomic-ink) !important;
  border-radius: var(--neucomic-panel-radius) !important;
  background: var(--neucomic-paper) !important;
  color: var(--neucomic-paper-ink) !important;
  box-shadow: var(--neucomic-menu-shadow) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-tooltip {
  padding: 9px 12px !important;
  border: 2px solid var(--neucomic-print-ink) !important;
  border-radius: 14px 16px 14px 3px !important;
  background: var(--neucomic-narration) !important;
  color: var(--neucomic-narration-ink) !important;
  box-shadow: none !important;
  font: 500 .8rem/1.45 var(--font-sans) !important;
  text-transform: none !important;
  letter-spacing: 0 !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-menubar, .neubrutalism-toolbar, .neubrutalism-button-group, .neubrutalism-button-panel) {
  border: 0 !important;
  border-radius: 0 !important;
  background: transparent !important;
  box-shadow: none !important;
}

/* Notice color sits in the symbol and fill, never in a one-sided stripe. */
#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-alert, .neubrutalism-toast) {
  --neucomic-notice-accent: var(--primary);
  border: 2px solid var(--neucomic-ink) !important;
  border-radius: var(--neucomic-panel-radius) !important;
  background: var(--card) !important;
  color: var(--foreground) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-alert, .neubrutalism-toast)[data-variant="success"] { --neucomic-notice-accent: var(--success); }
#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-alert, .neubrutalism-toast)[data-variant="info"] { --neucomic-notice-accent: var(--info); }
#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-alert, .neubrutalism-toast)[data-variant="warning"] { --neucomic-notice-accent: var(--warning); }
#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-alert, .neubrutalism-toast):is([data-variant="destructive"], [data-variant="error"]) { --neucomic-notice-accent: var(--destructive); }

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-alert[data-variant="warning"] {
  border-color: var(--neucomic-print-ink) !important;
  background: var(--neucomic-narration) !important;
  color: var(--neucomic-narration-ink) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-alert-icon {
  width: 26px !important;
  height: 26px !important;
  border: 1px solid var(--neucomic-ink) !important;
  border-radius: 50% !important;
  background: var(--neucomic-notice-accent) !important;
  color: var(--nb-ink) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-alert-title, .neubrutalism-toast-title) {
  font: 700 .9rem/1.4 var(--font-sans) !important;
  color: inherit !important;
  letter-spacing: 0 !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-alert-description, .neubrutalism-toast-message, .neubrutalism-toast-description) {
  font: 400 .875rem/1.55 var(--font-sans) !important;
  color: inherit !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-toast:not([data-arcane-decorated]) {
  border: 2px solid var(--neucomic-ink) !important;
  border-radius: var(--neucomic-panel-radius) !important;
  background: var(--neucomic-paper) !important;
  color: var(--neucomic-paper-ink) !important;
  box-shadow: var(--neucomic-overlay-shadow) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-badge, .neubrutalism-status-badge) {
  border: 2px solid var(--neucomic-ink) !important;
  border-radius: 1px !important;
  padding: 2px 6px !important;
  box-shadow: none !important;
  font: 800 .75rem/1.4 var(--font-sans) !important;
  letter-spacing: 0 !important;
  text-transform: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-status-label {
  font: 600 .75rem/1.4 var(--font-sans) !important;
  letter-spacing: 0 !important;
  text-transform: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-status-indicator {
  width: 7px !important;
  height: 7px !important;
  border: 0 !important;
  box-shadow: none !important;
}

/* The ledger uses rules and alignment rather than another surrounding card. */
#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-data-table-container, .neubrutalism-static-table-container, .neubrutalism-kv-table) {
  border: 0 !important;
  border-radius: 0 !important;
  background: transparent !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-data-table-header, .neubrutalism-static-table thead) {
  border-bottom: 2px solid var(--neucomic-ink) !important;
  background: transparent !important;
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-data-table, .neubrutalism-static-table) th {
  padding: 14px 16px !important;
  font: 700 .8rem/1.4 var(--font-sans) !important;
  text-transform: none !important;
  letter-spacing: 0 !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-data-table, .neubrutalism-static-table) td {
  padding: 14px 16px !important;
  color: var(--foreground);
  font: 400 .875rem/1.5 var(--font-sans);
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-data-table-row, .neubrutalism-static-table tbody tr, .neubrutalism-kv-table-row) {
  border: 0 !important;
  border-bottom: 1px solid var(--border) !important;
  background: transparent !important;
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-data-table-row.selected {
  background: var(--neucomic-selection) !important;
  color: var(--neucomic-selection-ink) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-data-table-row.selected td {
  color: var(--neucomic-selection-ink) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-kv-table-key, .neubrutalism-kv-table-value) {
  padding: 14px 0 !important;
  border: 0 !important;
  background: transparent !important;
  font: 400 .875rem/1.5 var(--font-sans) !important;
  letter-spacing: 0 !important;
  text-transform: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-kv-table-key { color: var(--muted-foreground) !important; }

/* Disclosures share one panel perimeter and internal ink rules. */
#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-accordion, .neubrutalism-disclosure-group) {
  border: 2px solid var(--neucomic-ink) !important;
  border-radius: 0 !important;
  background: transparent !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-disclosure {
  border: 2px solid var(--neucomic-ink);
  border-radius: var(--neucomic-panel-radius);
  background: var(--card);
  box-shadow: none;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-disclosure-group > .neubrutalism-disclosure,
#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-accordion > details {
  border: 0;
  border-radius: 0;
  background: transparent;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-disclosure-group > .neubrutalism-disclosure + .neubrutalism-disclosure,
#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-accordion > details + details {
  border-top: 1px solid var(--border);
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-disclosure-summary, .neubrutalism-accordion > details > summary) {
  min-height: 56px;
  padding: 16px;
  font: 650 .9375rem/1.45 var(--font-sans);
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-disclosure-summary, .neubrutalism-accordion > details > summary):hover {
  background: color-mix(in srgb, var(--primary) 5%, var(--card));
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-disclosure-chevron, .neubrutalism-accordion-chevron) {
  width: 26px;
  height: 26px;
  border: 1px solid var(--neucomic-ink);
  border-radius: 50%;
  background: var(--card);
}

/* Sidebar selection is one complete ink shape; hierarchy comes from spacing. */
#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-sidebar {
  border: 2px solid var(--neucomic-ink) !important;
  border-radius: var(--neucomic-panel-radius) !important;
  background: var(--neucomic-paper) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-sidebar > .sidebar-header {
  padding: 20px 18px !important;
  font: 400 1.7rem/1.1 var(--font-display) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-sidebar :is(.sidebar-link, .sidebar-summary) {
  border: 2px solid transparent !important;
  border-radius: 1px !important;
  background: transparent !important;
  color: var(--foreground) !important;
  box-shadow: none !important;
  transform: none !important;
  font: 550 .875rem/1.4 var(--font-sans) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-sidebar :is(.sidebar-link:hover, .sidebar-summary:hover) {
  border-color: var(--neucomic-control-ink) !important;
  background: var(--muted) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-sidebar .sidebar-link.active {
  border-color: var(--neucomic-control-ink) !important;
  background: var(--neucomic-selection) !important;
  color: var(--neucomic-selection-ink) !important;
  font-weight: 800 !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-sidebar :is(.neubrutalism-sidebar-group-label, .sidebar-section-header) {
  width: fit-content !important;
  max-width: 100%;
  padding: 4px 7px !important;
  border: 1px solid var(--neucomic-ink) !important;
  background: var(--neucomic-paper-under) !important;
  background-image: var(--neucomic-print-pattern) !important;
  background-size: var(--neucomic-print-size) var(--neucomic-print-size) !important;
  color: var(--neucomic-paper-ink) !important;
  transform: rotate(-.8deg);
  transform-origin: left center;
  font: 650 .75rem/1.4 var(--font-sans) !important;
  letter-spacing: 0 !important;
  text-transform: none !important;
}

/* Loading silhouettes describe content without impersonating outlined fields. */
#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-skeleton {
  border: 0 !important;
  background: color-mix(in srgb, var(--foreground) 12%, var(--card)) !important;
  box-shadow: none !important;
  opacity: 1 !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-progress-track {
  min-height: 10px;
  border: 2px solid var(--neucomic-ink) !important;
  border-radius: 3px !important;
  background: var(--card) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-progress-fill {
  border: 0 !important;
  border-radius: 0 !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-circular-progress-percentage, .neubrutalism-circular-progress-label) {
  font-family: var(--font-sans) !important;
  letter-spacing: 0 !important;
  text-transform: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-empty-state-icon {
  border: 0 !important;
  border-radius: 0 !important;
  background: transparent !important;
  color: var(--primary) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-empty-state-title {
  font: 700 1.125rem/1.4 var(--font-sans) !important;
  letter-spacing: -.015em !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-empty-state-description { font-weight: 400 !important; }

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-chart, .neubrutalism-slot-counter-card, .neubrutalism-scroll-rail, .neubrutalism-resizable):not([data-arcane-decorated]) {
  border: 2px solid var(--neucomic-ink) !important;
  border-radius: var(--neucomic-panel-radius) !important;
  background: var(--card) !important;
  color: var(--foreground) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-slot-counter {
  border: 0 !important;
  border-radius: 0 !important;
  background: transparent !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neucomic-panel {
  border: 3px solid var(--neucomic-ink);
  border-radius: var(--neucomic-panel-radius);
  background: var(--neucomic-paper);
  color: var(--neucomic-paper-ink);
  box-shadow: var(--neucomic-menu-shadow);
}

@media (max-width: 600px) {
  #arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-dialog { padding: 24px 20px !important; }
  #arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-dialog-close, .neubrutalism-sheet-close, .neubrutalism-drawer-close) { width: 44px !important; height: 44px !important; }
  #arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-dialog-actions > * { flex: 1 1 auto; }
}

@media (forced-colors: active), print {
  html.light #arcane-root.arcane-theme-neubrutalism.neucomic,
  html.dark #arcane-root.arcane-theme-neubrutalism.neucomic,
  #arcane-root.light.arcane-theme-neubrutalism.neucomic,
  #arcane-root.dark.arcane-theme-neubrutalism.neucomic {
    --neucomic-overlay-shadow: none;
    --neucomic-menu-shadow: none;
    --neucomic-print-pattern: none;
  }
}
''';
}
