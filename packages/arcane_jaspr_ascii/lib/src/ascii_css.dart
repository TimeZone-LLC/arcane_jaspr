const String asciiCss = r'''
#arcane-root.arcane-theme-ascii {
  --background: #f6f5f0;
  --foreground: #242822;
  --card: #fbfaf6;
  --card-foreground: #242822;
  --card-hover: #eef0e7;
  --popover: #fbfaf6;
  --popover-foreground: #242822;
  --primary: #314e39;
  --primary-foreground: #ffffff;
  --secondary: #eaece3;
  --secondary-foreground: #343c2f;
  --muted: #eaece3;
  --muted-foreground: #5c6458;
  --accent: #e0e6d9;
  --accent-foreground: #242822;
  --border: #a0a898;
  --input: #7b8573;
  --ring: #314e39;
  --background-rgb: 246, 245, 240;
  --foreground-rgb: 36, 40, 34;
  --card-rgb: 251, 250, 246;
  --primary-rgb: 49, 78, 57;
  --secondary-rgb: 234, 236, 227;
  --accent-rgb: 224, 230, 217;
  --muted-rgb: 92, 100, 88;
  --border-rgb: 160, 168, 152;
  --sidebar: var(--background);
  --sidebar-foreground: var(--foreground);
  --sidebar-border: var(--border);
  --sidebar-accent: var(--accent);
  --sidebar-accent-foreground: var(--foreground);
  --ascii-rule: var(--border);
  --ascii-soft-rule: color-mix(in srgb, var(--border) 45%, transparent);
  --ascii-duration: 180ms;
  --ascii-ease: cubic-bezier(0.2, 0.75, 0.25, 1);
  --font-sans: 'Geist Mono', 'IBM Plex Mono', 'Hack', 'SFMono-Regular', Consolas, 'Liberation Mono', monospace;
  --font-heading: var(--font-sans);
  --font-mono: var(--font-sans);
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
  --transition-slow: 240ms var(--ascii-ease);
  --transition-slower: 320ms var(--ascii-ease);
  --shadcn-control-border: var(--input);
  --shadcn-focus-ring: 0 0 0 2px var(--background), 0 0 0 4px var(--ring);
  --shadcn-focus-border: var(--ring);
  --shadcn-input-background: var(--card);
  --shadcn-switch-track: var(--input);
  --shadcn-switch-thumb-off: var(--background);
  --shadcn-switch-thumb-on: var(--background);
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
  --background: #111310;
  --foreground: #e8ebe3;
  --card: #191c17;
  --card-foreground: #e8ebe3;
  --card-hover: #252a22;
  --popover: #191c17;
  --popover-foreground: #e8ebe3;
  --primary: #b1cba1;
  --primary-foreground: #152015;
  --secondary: #252a22;
  --secondary-foreground: #d6ddcf;
  --muted: #252a22;
  --muted-foreground: #a2ad99;
  --accent: #30382a;
  --accent-foreground: #e8ebe3;
  --border: #616d58;
  --input: #7c8b71;
  --ring: #b1cba1;
  --background-rgb: 17, 19, 16;
  --foreground-rgb: 232, 235, 227;
  --card-rgb: 25, 28, 23;
  --primary-rgb: 177, 203, 161;
  --secondary-rgb: 37, 42, 34;
  --accent-rgb: 48, 56, 42;
  --muted-rgb: 162, 173, 153;
  --border-rgb: 97, 109, 88;
  --sidebar: var(--background);
  --sidebar-foreground: var(--foreground);
  --sidebar-border: var(--border);
  --sidebar-accent: var(--accent);
  --sidebar-accent-foreground: var(--foreground);
  --shadcn-control-border: var(--input);
  --shadcn-input-background: var(--card);
  --shadcn-switch-track: var(--input);
  --shadcn-switch-thumb-off: var(--background);
  --shadcn-switch-thumb-on: var(--background);
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

#arcane-root.arcane-theme-ascii :is(.arcane-button, .arcane-cycle-button) {
  position: relative;
  letter-spacing: -0.015em;
  transition: color var(--transition), background-color var(--transition), border-color var(--transition), box-shadow var(--transition) !important;
}

#arcane-root.arcane-theme-ascii .arcane-button:not([data-size^='icon']):not([data-variant='link'])::before,
#arcane-root.arcane-theme-ascii .arcane-button:not([data-size^='icon']):not([data-variant='link'])::after {
  display: inline-block;
  opacity: 0.55;
  transition: opacity var(--transition), transform var(--transition);
}

#arcane-root.arcane-theme-ascii .arcane-button:not([data-size^='icon']):not([data-variant='link'])::before { content: '[' / ''; }
#arcane-root.arcane-theme-ascii .arcane-button:not([data-size^='icon']):not([data-variant='link'])::after { content: ']' / ''; }
#arcane-root.arcane-theme-ascii .arcane-button:is(:hover, :focus-visible)::before { opacity: 1; transform: translateX(-2px); }
#arcane-root.arcane-theme-ascii .arcane-button:is(:hover, :focus-visible)::after { opacity: 1; transform: translateX(2px); }

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

#arcane-root.arcane-theme-ascii :is(.arcane-toggle-switch, .arcane-toggle-switch-thumb, .arcane-slider-thumb, .arcane-progress, .arcane-progress-indicator) {
  border-radius: 0 !important;
}

#arcane-root.arcane-theme-ascii .arcane-toggle-switch-thumb {
  transition: transform var(--transition), background-color var(--transition) !important;
}

#arcane-root.arcane-theme-ascii .arcane-checkbox-indicator {
  animation: ascii-appear 120ms steps(2, end);
}

#arcane-root.arcane-theme-ascii .arcane-slider-track,
#arcane-root.arcane-theme-ascii .arcane-progress {
  background: var(--muted) !important;
  outline: 1px solid var(--ascii-rule);
  outline-offset: 2px;
}

#arcane-root.arcane-theme-ascii .arcane-progress-indicator {
  background-image: repeating-linear-gradient(90deg, transparent 0, transparent 6px, var(--background) 6px, var(--background) 8px);
  transition: transform 320ms steps(12, end), width 320ms steps(12, end) !important;
}

#arcane-root.arcane-theme-ascii .arcane-progress-indicator.indeterminate {
  animation-timing-function: steps(16, end) !important;
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
  animation: ascii-loading-pulse 1600ms steps(6, end) infinite !important;
}

#arcane-root.arcane-theme-ascii :is(.arcane-cta-card-button, .arcane-pricing-card-cta) {
  transition: color var(--transition), background-color var(--transition), border-color var(--transition);
}

#arcane-root.arcane-theme-ascii :is(.arcane-cta-card-button, .arcane-pricing-card-cta)::before,
#arcane-root.arcane-theme-ascii :is(.arcane-cta-card-button, .arcane-pricing-card-cta)::after {
  display: inline-block;
  opacity: 0.55;
  transition: opacity var(--transition), transform var(--transition);
}

#arcane-root.arcane-theme-ascii :is(.arcane-cta-card-button, .arcane-pricing-card-cta)::before { content: '[' / ''; }
#arcane-root.arcane-theme-ascii :is(.arcane-cta-card-button, .arcane-pricing-card-cta)::after { content: ']' / ''; }
#arcane-root.arcane-theme-ascii :is(.arcane-cta-card-button, .arcane-pricing-card-cta):is(:hover, :focus-visible)::before { opacity: 1; transform: translateX(-2px); }
#arcane-root.arcane-theme-ascii :is(.arcane-cta-card-button, .arcane-pricing-card-cta):is(:hover, :focus-visible)::after { opacity: 1; transform: translateX(2px); }
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
  animation: ascii-draw 560ms steps(12, end);
}

#arcane-root.arcane-theme-ascii :is(.arcane-dialog, .arcane-sheet-panel, .arcane-drawer, .arcane-popover, .arcane-dropdown-content, .arcane-context-menu, .arcane-command, .arcane-toast, .arcane-tooltip) {
  border-radius: 0 !important;
  border-color: var(--input) !important;
  box-shadow: var(--shadow-lg);
}

#arcane-root.arcane-theme-ascii :is(.arcane-dialog, .arcane-popover, .arcane-dropdown-content, .arcane-context-menu, .arcane-command, .arcane-tooltip) {
  animation: ascii-appear 160ms steps(4, end) !important;
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
  letter-spacing: 0.08em;
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

#arcane-root.arcane-theme-ascii :is(.kb-topbar-brand, .kb-topbar-link, .kb-nav-group-label, .kb-sidebar-group-title, .kb-toc-title, .kb-prose, .prose) {
  font-family: var(--font-mono);
}

#arcane-root.arcane-theme-ascii :is(.kb-topbar-link, .kb-sidebar-link, .kb-nav-link) {
  transition: color var(--transition), background-color var(--transition);
}

#arcane-root.arcane-theme-ascii :is(.kb-prose, .prose) {
  line-height: 1.8;
}

#arcane-root.arcane-theme-ascii :is(.kb-prose, .prose) :is(h2, h3) {
  letter-spacing: -0.035em;
}

#arcane-root.arcane-theme-ascii :is(.kb-prose, .prose) blockquote {
  padding: 1rem 1.25rem;
  border: 1px dashed var(--ascii-rule);
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

.ascii-text { font-family: var(--font-mono, monospace); overflow-wrap: anywhere; }
.ascii-text-char { position: relative; white-space: pre-wrap; }
.ascii-text-letter { animation: ascii-appear var(--ascii-char-duration) steps(1, end) var(--ascii-char-delay) both; }
.ascii-text[data-motion='decode'] .ascii-text-char::before {
  content: attr(data-glyph) / '';
  position: absolute;
  inset: 0;
  color: currentColor;
  animation: ascii-decode-glyph var(--ascii-char-duration) steps(2, end) var(--ascii-char-delay) both;
}
.ascii-text-cursor { opacity: 0; animation: ascii-cursor 600ms steps(1, end) 4; }

@keyframes ascii-appear { from { opacity: 0; } to { opacity: 1; } }
@keyframes ascii-draw { from { transform: scaleX(0); } to { transform: scaleX(1); } }
@keyframes ascii-decode-glyph { 0%, 55% { opacity: 0.65; } 100% { opacity: 0; } }
@keyframes ascii-cursor { 0%, 49% { opacity: 0.75; } 50%, 100% { opacity: 0; } }
@keyframes ascii-loading-glyph { 0%, 100% { content: '+' / ''; } 25% { content: 'x' / ''; } 50% { content: ':' / ''; } 75% { content: '=' / ''; } }
@keyframes ascii-loading-pulse { 0%, 100% { opacity: 0.45; } 50% { opacity: 0.9; } }

@media (hover: none) and (pointer: coarse) {
  #arcane-root.arcane-theme-ascii :is(.arcane-button, .arcane-cycle-button, .arcane-tab, .arcane-tab-bar-item, .arcane-pagination-link, .arcane-select, .arcane-dropdown-item, .arcane-context-menu-item, .arcane-menubar-item, .arcane-command-item, .arcane-calendar-day) {
    min-height: 2.75rem;
  }
  #arcane-root.arcane-theme-ascii .arcane-button[data-size^='icon'] { min-width: 2.75rem; }
}

[data-ascii-motion='off'],
[data-ascii-motion='off'] *,
[data-ascii-motion='off'] *::before,
[data-ascii-motion='off'] *::after {
  animation: none !important;
  transition: none !important;
  scroll-behavior: auto !important;
}

[data-ascii-motion='off'] .ascii-text-char::before { display: none; }
[data-ascii-motion='off'] .ascii-text-letter { opacity: 1; }

@media (prefers-reduced-motion: reduce) {
  #arcane-root.arcane-theme-ascii *,
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
  #arcane-root.arcane-theme-ascii :is(.arcane-button, .arcane-card, .ascii-surface) { border: 1px solid ButtonText; }
  .ascii-datum-rule { background: CanvasText; }
  #arcane-root.arcane-theme-ascii .arcane-progress-indicator { background: Highlight !important; }
}
''';
