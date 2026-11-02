const String asciiCss = r'''
#arcane-root.arcane-theme-ascii {
  --background: #f2f1ee;
  --foreground: #101014;
  --card: #f9f8f5;
  --card-foreground: #101014;
  --card-hover: #eeede9;
  --popover: #f9f8f5;
  --popover-foreground: #101014;
  --primary: #101014;
  --primary-foreground: #ffffff;
  --secondary: #e8e7e3;
  --secondary-foreground: #35343a;
  --muted: #e8e7e3;
  --muted-foreground: #66635f;
  --accent: #e3e1dc;
  --accent-foreground: #101014;
  --border: #d3d0c9;
  --input: #84817c;
  --ring: #101014;
  --background-rgb: 242, 241, 238;
  --foreground-rgb: 16, 16, 20;
  --card-rgb: 249, 248, 245;
  --primary-rgb: 16, 16, 20;
  --secondary-rgb: 232, 231, 227;
  --accent-rgb: 227, 225, 220;
  --muted-rgb: 102, 99, 95;
  --border-rgb: 211, 208, 201;
  --sidebar: var(--background);
  --sidebar-foreground: var(--foreground);
  --sidebar-border: var(--border);
  --sidebar-accent: var(--accent);
  --sidebar-accent-foreground: var(--foreground);
  --ascii-rule: var(--border);
  --ascii-soft-rule: color-mix(in srgb, var(--border) 45%, transparent);
  --ascii-duration: 220ms;
  --ascii-ease: cubic-bezier(0.22, 1, 0.36, 1);
  --font-sans: 'Geist', 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
  --font-heading: var(--font-sans);
  --font-mono: 'Geist Mono', 'IBM Plex Mono', 'Hack', 'SFMono-Regular', Consolas, 'Liberation Mono', monospace;
  --font-control: var(--font-mono);
  --radius: 0;
  --radius-xs: 0;
  --radius-sm: 0;
  --radius-md: 0;
  --shadow-xs: none;
  --shadow-sm: none;
  --shadow-md: 0 0 0 1px var(--ascii-soft-rule);
  --shadow-lg: 0 12px 40px -24px color-mix(in srgb, var(--foreground) 30%, transparent);
  --shadow-xl: var(--shadow-lg);
  --transition: var(--ascii-duration) var(--ascii-ease);
  --transition-slow: 360ms var(--ascii-ease);
  --transition-slower: 560ms var(--ascii-ease);
  --shadcn-control-border: var(--input);
  --shadcn-focus-ring: 0 0 0 2px var(--background), 0 0 0 4px var(--ring);
  --shadcn-focus-border: var(--ring);
  --shadcn-input-background: var(--card);
  --shadcn-switch-track: var(--muted);
  --shadcn-switch-thumb-off: var(--muted-foreground);
  --shadcn-switch-thumb-on: var(--primary);
  --shadcn-hairline: var(--ascii-soft-rule);
  --shadcn-subtle-line: var(--ascii-rule);
  --shadcn-panel-fill: var(--background);
  --shadcn-panel-highlight: var(--muted);
  --shadcn-control-fill: var(--card);
  --shadcn-control-hover: var(--accent);
  font-family: var(--font-sans);
  color: var(--foreground);
  background: var(--background);
  font-variant-numeric: tabular-nums;
  -webkit-font-smoothing: antialiased;
}

html.dark #arcane-root.arcane-theme-ascii,
#arcane-root.dark.arcane-theme-ascii {
  --background: #101014;
  --foreground: #f2f1ee;
  --card: #18181c;
  --card-foreground: #f2f1ee;
  --card-hover: #26262b;
  --popover: #18181c;
  --popover-foreground: #f2f1ee;
  --primary: #e9e8e3;
  --primary-foreground: #101014;
  --secondary: #26262b;
  --secondary-foreground: #deddd8;
  --muted: #26262b;
  --muted-foreground: #aaa9b0;
  --accent: #303037;
  --accent-foreground: #f2f1ee;
  --border: #35353c;
  --input: #7a7a82;
  --ring: #e9e8e3;
  --background-rgb: 16, 16, 20;
  --foreground-rgb: 242, 241, 238;
  --card-rgb: 24, 24, 28;
  --primary-rgb: 233, 232, 227;
  --secondary-rgb: 38, 38, 43;
  --accent-rgb: 48, 48, 55;
  --muted-rgb: 170, 169, 176;
  --border-rgb: 53, 53, 60;
  --sidebar: var(--background);
  --sidebar-foreground: var(--foreground);
  --sidebar-border: var(--border);
  --sidebar-accent: var(--accent);
  --sidebar-accent-foreground: var(--foreground);
  --shadcn-control-border: var(--input);
  --shadcn-input-background: var(--card);
  --shadcn-switch-track: var(--muted);
  --shadcn-switch-thumb-off: var(--muted-foreground);
  --shadcn-switch-thumb-on: var(--primary);
  --shadcn-hairline: var(--ascii-soft-rule);
  --shadcn-subtle-line: var(--ascii-rule);
  --shadcn-panel-fill: var(--background);
  --shadcn-panel-highlight: var(--muted);
  --shadcn-control-fill: var(--card);
  --shadcn-control-hover: var(--accent);
  color-scheme: dark;
}

#arcane-root.arcane-theme-ascii :is(h1, h2, h3, h4, h5, h6) {
  font-family: var(--font-heading);
  font-weight: 500;
  letter-spacing: -0.045em;
  text-wrap: balance;
}

#arcane-root.arcane-theme-ascii :is(button, input, textarea, select, code, kbd) {
  font-family: var(--font-mono);
}

#arcane-root.arcane-theme-ascii :is(button, a, input, textarea, select, summary, [tabindex]):focus-visible {
  outline: 2px solid var(--ring) !important;
  outline-offset: 3px;
}

#arcane-root.arcane-theme-ascii .arcane-command-input:focus-visible {
  outline: none !important;
}

#arcane-root.arcane-theme-ascii .arcane-command-search-row:has(> .arcane-command-input:focus-visible) {
  outline: 2px solid var(--ring);
  outline-offset: -2px;
}

#arcane-root.arcane-theme-ascii :is(.arcane-button, .arcane-cycle-button) {
  position: relative;
  font-family: var(--font-mono);
  letter-spacing: -0.015em;
  transition: color var(--transition), background-color var(--transition), border-color var(--transition), box-shadow var(--transition) !important;
}

#arcane-root.arcane-theme-ascii :is(.arcane-button, .arcane-cycle-button):active:not(:disabled) {
  filter: brightness(0.92);
}

#arcane-root.arcane-theme-ascii :is(.arcane-card, .arcane-feature-card, .arcane-flexi-card, .arcane-stat-card, .arcane-pricing-card, .arcane-cta-card, .arcane-testimonial-card, .ascii-surface) {
  transition: border-color var(--transition), background-color var(--transition), box-shadow var(--transition);
}

#arcane-root.arcane-theme-ascii :is(.arcane-card.clickable, .arcane-card[data-variant='interactive'], a.arcane-feature-card, button.arcane-feature-card, a.arcane-flexi-card, button.arcane-flexi-card):is(:hover, :focus-visible) {
  --shadcn-card-shadow: 0 0 0 1px var(--input);
  --shadcn-card-background: var(--card-hover);
  border-color: var(--input);
}

#arcane-root.arcane-theme-ascii :is(.arcane-tab, .arcane-tab-bar-item, .arcane-toggle-button, .arcane-toggle-group-item, .arcane-pagination-link, .arcane-select-option, .arcane-dropdown-item, .arcane-context-menu-item, .arcane-menubar-item, .arcane-menubar-trigger, .arcane-command-item, .arcane-time-picker-option, .arcane-calendar-day, .arcane-sidebar-item, .arcane-breadcrumb-link) {
  transition: background-color var(--transition), color var(--transition), border-color var(--transition), box-shadow var(--transition);
}

#arcane-root.arcane-theme-ascii :is(.arcane-tabs-list, .arcane-tab-bar) {
  border: 1px solid var(--ascii-rule);
  background: transparent !important;
  border-radius: 0 !important;
  gap: 0.25rem;
}

#arcane-root.arcane-theme-ascii :is(.arcane-tab, .arcane-tab-bar-item)[aria-selected='true'] {
  --shadcn-item-background: var(--foreground);
  --shadcn-item-foreground: var(--background);
  --shadcn-control-shadow: none;
  background: var(--foreground) !important;
  color: var(--background) !important;
}

#arcane-root.arcane-theme-ascii :is(.arcane-text-input, .arcane-textarea, .arcane-select, .arcane-otp-digit, .arcane-date-picker-trigger, .arcane-time-picker-trigger) {
  caret-color: var(--primary);
  transition: border-color var(--transition), background-color var(--transition), box-shadow var(--transition);
}

#arcane-root.arcane-theme-ascii :is(.arcane-text-input, .arcane-textarea)::placeholder {
  color: var(--muted-foreground);
  opacity: 1;
}

#arcane-root.arcane-theme-ascii :is(.arcane-text-input-wrapper, .arcane-textarea-wrapper, .arcane-select-wrapper, .arcane-date-picker, .arcane-time-picker, .arcane-otp-input, .arcane-input-group, .arcane-input-group-item) {
  min-width: 0;
  max-width: 100%;
}

#arcane-root.arcane-theme-ascii .arcane-input-group-item:has(input, select, textarea),
#arcane-root.arcane-theme-ascii .arcane-input-group-item:has(input, select, textarea) > div {
  flex: 1 1 0;
  min-width: 0;
}

#arcane-root.arcane-theme-ascii :is(.arcane-toggle-switch, .arcane-toggle-thumb, .arcane-slider-thumb, .arcane-progress, .arcane-progress-indicator) {
  border-radius: 0 !important;
}

#arcane-root.arcane-theme-ascii .arcane-toggle-switch {
  --shadcn-control-border-color: var(--input);
  --shadcn-switch-thumb-on: var(--shadcn-switch-active);
}

#arcane-root.arcane-theme-ascii .arcane-toggle-switch[data-arcane-state='selected'] {
  --shadcn-switch-background: var(--accent);
}

#arcane-root.arcane-theme-ascii .arcane-toggle-switch[data-color='secondary'] {
  --shadcn-switch-thumb-on: var(--secondary-foreground);
}

#arcane-root.arcane-theme-ascii :is(.arcane-checkbox-wrapper, .arcane-toggle-wrapper, .arcane-radio-item) {
  min-width: 0;
}

#arcane-root.arcane-theme-ascii .arcane-checkbox-wrapper > div:last-child:not(.arcane-checkbox) {
  min-width: 0;
}

#arcane-root.arcane-theme-ascii .arcane-checkbox-wrapper > div:last-child > span,
#arcane-root.arcane-theme-ascii .arcane-toggle-label {
  line-height: 1.5 !important;
  overflow-wrap: anywhere;
}

#arcane-root.arcane-theme-ascii .arcane-checkbox[data-arcane-state='selected'] {
  --shadcn-checkbox-border: var(--input);
}

#arcane-root.arcane-theme-ascii .arcane-checkbox-indicator,
#arcane-root.arcane-theme-ascii .arcane-select-option-checkmark,
#arcane-root.arcane-theme-ascii .arcane-select-option-check > span,
#arcane-root.arcane-theme-ascii .arcane-menu-indicator {
  width: var(--shadcn-checkbox-glyph, 0.875rem);
  height: var(--shadcn-checkbox-glyph, 0.875rem);
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  line-height: 1;
  animation: ascii-appear 160ms var(--ascii-ease);
}

#arcane-root.arcane-theme-ascii :is(.arcane-select-option-checkmark, .arcane-select-option-check > span, .arcane-menu-indicator) {
  display: inline-flex;
}

#arcane-root.arcane-theme-ascii :is(.arcane-checkbox-indicator, .arcane-select-option-checkmark, .arcane-select-option-check > span, .arcane-menu-indicator) > i {
  display: none !important;
}

#arcane-root.arcane-theme-ascii .arcane-checkbox-indicator::after,
#arcane-root.arcane-theme-ascii .arcane-select-option-checkmark::after,
#arcane-root.arcane-theme-ascii .arcane-select-option-check > span::after,
#arcane-root.arcane-theme-ascii [role='menuitemcheckbox'] > .arcane-menu-indicator::after {
  content: '';
  box-sizing: border-box;
  width: calc(var(--shadcn-checkbox-glyph, 0.875rem) * 0.36);
  height: calc(var(--shadcn-checkbox-glyph, 0.875rem) * 0.64);
  border-right: 2px solid currentColor;
  border-bottom: 2px solid currentColor;
  transform: translateY(-12%) rotate(45deg);
}

#arcane-root.arcane-theme-ascii [role='menuitemradio'] > .arcane-menu-indicator::after {
  content: '';
  width: 0.375rem;
  height: 0.375rem;
  border: 1px solid currentColor;
  background: currentColor;
  border-radius: 50%;
}

#arcane-root.arcane-theme-ascii :is(.arcane-radio-card, .arcane-radio-button):has(input:focus-visible),
#arcane-root.arcane-theme-ascii .arcane-radio-input:focus-visible + .arcane-radio-circle {
  outline: 2px solid var(--ring) !important;
  outline-offset: 3px;
  box-shadow: none;
}

#arcane-root.arcane-theme-ascii input:is([type='checkbox'], [type='radio']) {
  accent-color: var(--primary);
}

#arcane-root.arcane-theme-ascii .arcane-circular-progress {
  display: grid !important;
  grid-template-columns: minmax(0, 1fr);
  grid-template-rows: var(--arcane-circular-progress-size, 80px);
  justify-items: center;
  gap: 0;
  height: auto !important;
  width: fit-content !important;
  max-width: 100%;
}

#arcane-root.arcane-theme-ascii .arcane-circular-progress:has(.arcane-circular-progress-label) {
  grid-template-rows: var(--arcane-circular-progress-size, 80px) auto;
  gap: 0.5rem;
}

#arcane-root.arcane-theme-ascii .arcane-circular-progress > [data-arcane-intrinsic-shape='circular-progress-ring'] {
  position: relative !important;
  grid-area: 1 / 1;
  width: var(--arcane-circular-progress-size, 80px) !important;
  height: var(--arcane-circular-progress-size, 80px) !important;
}

#arcane-root.arcane-theme-ascii .arcane-circular-progress-center { display: contents !important; }
#arcane-root.arcane-theme-ascii .arcane-circular-progress-percentage { grid-area: 1 / 1; line-height: 1.2; }
#arcane-root.arcane-theme-ascii .arcane-circular-progress-label {
  grid-area: 2 / 1;
  max-width: 100%;
  overflow-wrap: anywhere;
  text-align: center;
  line-height: 1.4;
}

#arcane-root.arcane-theme-ascii .arcane-slider-track,
#arcane-root.arcane-theme-ascii .arcane-progress {
  background: var(--muted) !important;
  outline: 1px solid var(--ascii-rule);
  outline-offset: 2px;
}

#arcane-root.arcane-theme-ascii .arcane-progress-indicator {
  background-image: repeating-linear-gradient(90deg, transparent 0, transparent 6px, var(--background) 6px, var(--background) 8px);
  transition: transform var(--ascii-progress-duration, 560ms) var(--ascii-ease), width var(--ascii-progress-duration, 560ms) var(--ascii-ease) !important;
}

#arcane-root.arcane-theme-ascii .arcane-progress-indicator.indeterminate {
  animation-timing-function: ease-in-out !important;
}

#arcane-root.arcane-theme-ascii .arcane-loading-spinner {
  position: relative;
  border: 0 !important;
  animation: none !important;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

#arcane-root.arcane-theme-ascii .arcane-loading-spinner::after {
  content: '+' / '';
  font: 600 1em / 1 var(--font-mono);
  animation: ascii-loading-glyph 800ms steps(1, end) infinite;
}

#arcane-root.arcane-theme-ascii .arcane-skeleton {
  background-image: repeating-linear-gradient(90deg, transparent 0, transparent 6px, var(--background) 6px, var(--background) 8px) !important;
}

#arcane-root.arcane-theme-ascii .arcane-skeleton.animate {
  animation: ascii-loading-pulse 1800ms ease-in-out infinite !important;
}

#arcane-root.arcane-theme-ascii :is(.arcane-cta-card-button, .arcane-pricing-card-cta) {
  transition: color var(--transition), background-color var(--transition), border-color var(--transition);
}

#arcane-root.arcane-theme-ascii .arcane-pricing-card-cta:hover { background-color: var(--accent) !important; border-color: var(--input) !important; }
#arcane-root.arcane-theme-ascii .arcane-cta-card-button:hover { filter: brightness(0.92); }

#arcane-root.arcane-theme-ascii .arcane-calendar-day-other-month { color: var(--muted-foreground); opacity: 1; }
#arcane-root.arcane-theme-ascii .arcane-calendar-day-disabled { opacity: 0.4; }
#arcane-root.arcane-theme-ascii .arcane-calendar-weekdays { padding-block: 0.5rem; border-block: 1px solid var(--ascii-soft-rule); }
#arcane-root.arcane-theme-ascii .arcane-calendar-day-today { border-color: var(--input); }

#arcane-root.arcane-theme-ascii .arcane-chart-track { outline: 1px solid var(--ascii-soft-rule); outline-offset: 2px; }
#arcane-root.arcane-theme-ascii .arcane-chart-fill {
  background-image: repeating-linear-gradient(90deg, transparent 0, transparent 6px, var(--background) 6px, var(--background) 8px);
  transform-origin: left center;
  animation: ascii-draw 700ms var(--ascii-ease);
}

#arcane-root.arcane-theme-ascii :is(.arcane-dialog, .arcane-sheet-panel, .arcane-drawer, .arcane-popover, .arcane-dropdown-content, .arcane-context-menu, .arcane-command, .arcane-toast, .arcane-tooltip) {
  border-radius: 0 !important;
  border-color: var(--input) !important;
  box-shadow: var(--shadow-lg);
}

#arcane-root.arcane-theme-ascii :is(.arcane-dialog, .arcane-popover, .arcane-dropdown-content, .arcane-context-menu, .arcane-command, .arcane-tooltip) {
  animation: ascii-surface-enter 220ms var(--ascii-ease) !important;
}

#arcane-root.arcane-theme-ascii :is(.arcane-accordion-content, .arcane-disclosure-content, .arcane-tab-content, .arcane-empty-state, .arcane-alert, .ascii-enter) {
  animation: ascii-appear 220ms var(--ascii-ease);
}

#arcane-root.arcane-theme-ascii :is(.arcane-data-table, .arcane-static-table) {
  font-variant-numeric: tabular-nums;
  border-collapse: collapse;
}

#arcane-root.arcane-theme-ascii :is(.arcane-data-table th, .arcane-static-table th) {
  font-size: 0.6875rem;
  font-weight: 500;
  font-family: var(--font-mono);
  letter-spacing: 0.06em;
  text-transform: uppercase;
  background: var(--muted);
  color: var(--muted-foreground);
}

#arcane-root.arcane-theme-ascii :is(.arcane-data-table-row, .arcane-static-table tr) {
  transition: background-color var(--transition);
}

#arcane-root.arcane-theme-ascii :is(.arcane-status-badge, .arcane-badge, .arcane-kbd) {
  border-radius: 0 !important;
  font-family: var(--font-mono);
  letter-spacing: 0.025em;
}

#arcane-root.arcane-theme-ascii hr.arcane-separator,
#arcane-root.arcane-theme-ascii .ascii-divider {
  border: 0;
  height: 1px;
  background: var(--ascii-rule);
}

#arcane-root.arcane-theme-ascii :is(.arcane-spec-row, .arcane-slot-counter, .arcane-slot-counter-card) {
  font-variant-numeric: tabular-nums;
  animation: ascii-appear 180ms var(--ascii-ease);
}

#arcane-root.arcane-theme-ascii .arcane-spec-row { gap: 0.75rem; }
#arcane-root.arcane-theme-ascii .arcane-spec-row::after {
  content: '';
  flex: 1 1 auto;
  order: 1;
  min-width: 1rem;
  border-bottom: 1px dotted var(--ascii-rule);
}
#arcane-root.arcane-theme-ascii .arcane-spec-row-value { order: 2; text-align: end; }

#arcane-root.arcane-theme-ascii :is(.shadcn-gallery-tile, .shadcn-top-announcement-bar, .shadcn-inline-hero-banner, .arcane-flexi-card-simple) {
  border-radius: 0 !important;
  transition: background-color var(--transition), border-color var(--transition), box-shadow var(--transition);
  animation: ascii-appear 220ms var(--ascii-ease);
}

#arcane-root.arcane-theme-ascii :is(a.shadcn-gallery-tile, button.shadcn-gallery-tile):is(:hover, :focus-visible) {
  border-color: var(--input);
  box-shadow: 0 0 0 1px var(--input);
}

#arcane-root.arcane-theme-ascii :is(.arcane-native-select, .arcane-field-select) {
  border-color: var(--input);
  background: var(--card);
  color: var(--foreground);
  transition: background-color var(--transition), border-color var(--transition);
}

#arcane-root.arcane-theme-ascii .ascii-surface {
  border: 1px solid var(--ascii-rule);
  border-radius: 0;
  background: var(--card);
  color: var(--card-foreground);
}

#arcane-root.arcane-theme-ascii .ascii-label {
  font-family: var(--font-mono);
  font-size: 0.6875rem;
  line-height: 1.6;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: var(--muted-foreground);
}

#arcane-root.arcane-theme-ascii .ascii-readout {
  font-family: var(--font-mono);
  font-variant-numeric: tabular-nums;
  letter-spacing: -0.035em;
}

#arcane-root.arcane-theme-ascii :is(.kb-topbar, .kb-sidebar, .kb-sidebar-panel) {
  background: var(--background) !important;
  border-color: var(--ascii-rule) !important;
}

#arcane-root.arcane-theme-ascii :is(.kb-nav-group-label, .kb-sidebar-group-title, .kb-toc-title) {
  font-family: var(--font-mono);
}

#arcane-root.arcane-theme-ascii :is(.kb-topbar-link, .kb-sidebar-link, .kb-nav-link) {
  transition: color var(--transition), background-color var(--transition);
}

#arcane-root.arcane-theme-ascii :is(.kb-topbar-brand, .kb-topbar-link, .kb-prose, .prose) {
  font-family: var(--font-sans);
}

#arcane-root.arcane-theme-ascii :is(.kb-prose, .prose) {
  line-height: 1.75;
}

#arcane-root.arcane-theme-ascii :is(.kb-prose, .prose) :is(h2, h3) {
  letter-spacing: -0.035em;
}

#arcane-root.arcane-theme-ascii :is(.kb-prose, .prose) blockquote {
  padding: 1rem 1.25rem;
  border: 1px solid var(--ascii-rule);
  color: var(--muted-foreground);
  font-style: normal;
}

#arcane-root.arcane-theme-ascii .toc-title {
  border: 0 !important;
  outline: 0;
  box-shadow: none !important;
  background: transparent !important;
  padding: 0 0 0.75rem !important;
  font-family: var(--font-mono);
  font-size: 0.625rem;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: var(--muted-foreground);
}

@media (min-width: 901px) {
  #arcane-root.arcane-theme-ascii .sidebar-header.kb-sidebar-header-mobile-only { display: none !important; }
}

.ascii-datum {
  display: flex;
  align-items: center;
  min-width: 0;
  gap: 0.625rem;
  font-family: var(--font-mono, monospace);
  font-size: 0.625rem;
  line-height: 1.6;
  letter-spacing: 0.08em;
  color: var(--muted-foreground, currentColor);
}

.ascii-datum-label { text-transform: uppercase; overflow-wrap: anywhere; }
.ascii-datum-value { font-variant-numeric: tabular-nums; overflow-wrap: anywhere; text-align: end; }
.ascii-datum-mark { flex: 0 0 auto; color: var(--foreground, currentColor); }
.ascii-datum-rule { flex: 1 1 auto; min-width: 1rem; height: 1px; background: var(--ascii-rule, currentColor); transform-origin: left center; }
.ascii-datum[data-animated='true'] .ascii-datum-rule { animation: ascii-draw 700ms var(--ascii-ease, ease-out) both; }

.ascii-text { font-family: inherit; overflow-wrap: anywhere; }
.ascii-text-char { position: relative; white-space: pre-wrap; }
.ascii-text-letter { animation: ascii-decode-letter var(--ascii-char-duration) var(--ascii-ease, ease-out) var(--ascii-char-delay) both; }
.ascii-text[data-motion='typewriter'] .ascii-text-letter { animation-name: ascii-appear; animation-timing-function: steps(1, end); }
.ascii-text[data-motion='decode'] .ascii-text-char::before {
  content: attr(data-glyph) / '';
  position: absolute;
  inset: 0;
  overflow: hidden;
  font-family: var(--font-mono, monospace);
  color: currentColor;
  animation: ascii-decode-glyph var(--ascii-char-duration) steps(1, end) var(--ascii-char-delay) both;
}
.ascii-text-cursor { opacity: 0; animation: ascii-cursor 600ms steps(1, end) 4; }

@keyframes ascii-appear { from { opacity: 0; } to { opacity: 1; } }
@keyframes ascii-surface-enter { from { opacity: 0; translate: 0 4px; } to { opacity: 1; translate: 0 0; } }
@keyframes ascii-decode-letter { 0%, 60% { opacity: 0; } 100% { opacity: 1; } }
@keyframes ascii-draw { from { transform: scaleX(0); } to { transform: scaleX(1); } }
@keyframes ascii-decode-glyph {
  0% { content: attr(data-glyph) / ''; opacity: 0; }
  12% { content: attr(data-glyph) / ''; opacity: 0.55; }
  30% { content: attr(data-glyph-next) / ''; opacity: 0.55; }
  48% { content: attr(data-glyph-last) / ''; opacity: 0.45; }
  66%, 100% { content: attr(data-glyph-last) / ''; opacity: 0; }
}
@keyframes ascii-cursor { 0%, 49% { opacity: 0.75; } 50%, 100% { opacity: 0; } }
@keyframes ascii-loading-glyph { 0%, 100% { content: '+' / ''; } 25% { content: 'x' / ''; } 50% { content: ':' / ''; } 75% { content: '=' / ''; } }
@keyframes ascii-loading-pulse { 0%, 100% { opacity: 0.45; } 50% { opacity: 0.9; } }

@media (hover: none) and (pointer: coarse) {
  #arcane-root.arcane-theme-ascii :is(.arcane-button, .arcane-cycle-button, .arcane-tab, .arcane-tab-bar-item, .arcane-toggle-button, .arcane-toggle-group-item, .arcane-pagination-link, .arcane-select, .arcane-text-input:not([data-arcane-field-inner]), .arcane-text-input-container, .arcane-textarea, .arcane-date-picker-trigger, .arcane-time-picker-trigger, .arcane-dropdown-item, .arcane-context-menu-item, .arcane-menubar-item, .arcane-command-item, .arcane-calendar-day, .arcane-calendar-nav-btn) {
    min-height: 2.75rem;
  }
  #arcane-root.arcane-theme-ascii .arcane-text-input[data-arcane-field-inner] { min-height: calc(2.75rem - 2px); }
  #arcane-root.arcane-theme-ascii :is(.arcane-tabs-list, .arcane-tab-bar) { min-height: 3.25rem; }
  #arcane-root.arcane-theme-ascii .arcane-calendar-nav-btn { min-width: 2.75rem; }
  #arcane-root.arcane-theme-ascii .arcane-button[data-size^='icon'] { min-width: 2.75rem; }
  #arcane-root.arcane-theme-ascii :is(.arcane-checkbox-wrapper, .arcane-toggle-wrapper, .arcane-radio-item) { min-height: 2.75rem; }
}

#arcane-root.arcane-theme-ascii[data-ascii-motion='off'],
#arcane-root.arcane-theme-ascii [data-ascii-motion='off'] {
  --transition: 0s;
  --transition-slow: 0s;
  --transition-slower: 0s;
  --ascii-progress-duration: 0s;
}

[data-ascii-motion='off'],
[data-ascii-motion='off'] *:not(.ascii-orbit-track):not(.ascii-orbit-counterturn),
[data-ascii-motion='off'] *::before,
[data-ascii-motion='off'] *::after {
  animation: none !important;
  transition: none !important;
  scroll-behavior: auto !important;
}

[data-ascii-motion='off'] .ascii-text-char::before { display: none; }
[data-ascii-motion='off'] .ascii-text-letter { opacity: 1; }

@media (prefers-reduced-motion: reduce) {
  #arcane-root.arcane-theme-ascii {
    --transition: 0s;
    --transition-slow: 0s;
    --transition-slower: 0s;
    --ascii-progress-duration: 0s;
  }
  #arcane-root.arcane-theme-ascii *:not(.ascii-orbit-track):not(.ascii-orbit-counterturn),
  #arcane-root.arcane-theme-ascii *::before,
  #arcane-root.arcane-theme-ascii *::after,
  .ascii-text *, .ascii-text *::before, .ascii-datum * {
    animation: none !important;
    transition: none !important;
    scroll-behavior: auto !important;
  }
  .ascii-text-char::before { display: none; }
  .ascii-text-letter { opacity: 1; }
  .ascii-datum-rule { transform: none; }
}

@media (forced-colors: active) {
  #arcane-root.arcane-theme-ascii :focus-visible { outline: 2px solid Highlight !important; }
  #arcane-root.arcane-theme-ascii .arcane-command-search-row:has(> .arcane-command-input:focus-visible) {
    outline-color: Highlight;
  }
  #arcane-root.arcane-theme-ascii :is(.arcane-button, .arcane-card, .ascii-surface) { border: 1px solid ButtonText; }
  #arcane-root.arcane-theme-ascii .arcane-checkbox {
    border-color: ButtonText !important;
  }
  #arcane-root.arcane-theme-ascii .arcane-checkbox-indicator { color: ButtonText !important; }
  #arcane-root.arcane-theme-ascii .arcane-toggle-switch { border-color: ButtonText !important; }
  #arcane-root.arcane-theme-ascii .arcane-toggle-thumb { border: 1px solid ButtonText; background: ButtonText !important; forced-color-adjust: none; box-sizing: border-box; }
  #arcane-root.arcane-theme-ascii [data-arcane-intrinsic-shape='radio-dot'] { background: ButtonText !important; forced-color-adjust: none; }
  #arcane-root.arcane-theme-ascii .arcane-circular-progress > [data-arcane-intrinsic-shape='circular-progress-ring'] {
    background: conic-gradient(Highlight 0deg var(--arcane-circular-progress-angle), CanvasText var(--arcane-circular-progress-angle) 360deg) !important;
    forced-color-adjust: none;
  }
  .ascii-datum-rule { background: CanvasText; }
  #arcane-root.arcane-theme-ascii .arcane-progress-indicator { background: Highlight !important; }
}
''';
