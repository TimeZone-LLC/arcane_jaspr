class NeuComicCss {
  const NeuComicCss._();

  static const int lightPaper = 0xFFFAF9F6;
  static const int lightPanel = 0xFFFFFFFF;
  static const int lightInk = 0xFF171717;
  static const int darkPaper = 0xFF17191C;
  static const int darkPanel = 0xFF24272C;
  static const int darkBorder = 0xFF767B83;
  static const int redAccent = 0xFFD42D38;
  static const int darkRedAccent = 0xFFB85C50;

  static const String styles = r'''
html.light #arcane-root.arcane-theme-neubrutalism.neucomic,
html.dark #arcane-root.arcane-theme-neubrutalism.neucomic,
#arcane-root.light.arcane-theme-neubrutalism.neucomic,
#arcane-root.dark.arcane-theme-neubrutalism.neucomic,
#arcane-root.arcane-theme-neubrutalism.neucomic {
  --font-display: 'Bangers', Impact, 'Arial Narrow', sans-serif;
  --font-sans: 'Inter', Arial, Helvetica, sans-serif;
  --font-heading: var(--font-sans);
  --font-body: var(--font-sans);
  --background: #FAF9F6;
  --foreground: #171717;
  --secondary-background: #FFFFFF;
  --card: var(--secondary-background);
  --card-foreground: var(--foreground);
  --card-hover: var(--muted);
  --popover: var(--card);
  --popover-foreground: var(--foreground);
  --muted: #ECECEA;
  --muted-foreground: #555555;
  --secondary: var(--muted);
  --secondary-foreground: var(--foreground);
  --accent: var(--muted);
  --accent-foreground: var(--foreground);
  --border: #D2D2D2;
  --input: var(--card);
  --ring: var(--foreground);
  --nb-ink: #171717;
  --nb-line: var(--nb-line-in, #171717);
  --nb-control-line: var(--nb-line-in, #171717);
  --nb-shadow-color: #171717;
  --nb-paper: var(--card);
  --nb-paper-soft: var(--muted);
  --nb-on-background: var(--foreground);
  --nb-on-secondary-background: var(--foreground);
  --nb-on-card: var(--foreground);
  --nb-on-paper: var(--foreground);
  --nb-on-paper-soft: var(--foreground);
  --nb-control-paper: var(--card);
  --nb-control-foreground: var(--foreground);
  --nb-surface-foreground: var(--foreground);
  --nb-accent-hot: var(--nb-accent);
  --nb-on-accent-hot: var(--nb-on-accent);
  --nb-accent-cool: var(--muted);
  --nb-on-accent-cool: var(--foreground);
  --nb-switch-thumb: #FFFFFF;
  --nb-selection-bg: var(--muted);
  --nb-selection-line: transparent;
  --nb-landing-band-bg: var(--card);
  --nb-on-landing-band: var(--foreground);
  --nb-border-thin: 1px;
  --nb-border-base: 1px;
  --nb-border-thick: 2px;
  --nb-shadow-xs: none;
  --nb-shadow-sm: none;
  --nb-shadow-md: none;
  --nb-shadow-lg: none;
  --nb-shadow-xl: none;
  --nb-shadow-accent-md: none;
  --nb-shadow-hot-md: none;
  --nb-shadow-cool-md: none;
  --nb-translate-press: none;
  --nb-translate-press-md: none;
  --nb-translate-press-lg: none;
  --nb-radius-tight: 2px;
  --nb-radius-soft: 3px;
  --nb-radius-soft-lg: 2px;
  --nb-switch-track-radius: 0;
  --nb-switch-thumb-radius: 0;
  --neucomic-control-radius: 2px 0 2px 0;
  --neucomic-field-radius: 2px;
  --neucomic-panel-radius: 1px;
  --neucomic-ink: var(--foreground);
  --neucomic-paper: color-mix(in srgb, var(--card) 92%, #D7C7A4);
  --neucomic-paper-edge: #DED5C3;
  --neucomic-paper-under: #E9E2D3;
  --neucomic-paper-ink: var(--foreground);
  --neucomic-paper-muted: var(--muted-foreground);
  --neucomic-print-pattern: radial-gradient(circle at 1px 1px, color-mix(in srgb, currentColor 12%, transparent) .6px, transparent .8px);
  --neucomic-control-ink: var(--foreground);
  --neucomic-slider-fill: #70747B;
  --neucomic-slider-thumb: var(--card);
  --neucomic-print-ink: #171717;
  --neucomic-narration: #F1EDE4;
  --neucomic-narration-ink: #171717;
  --neucomic-selection: var(--nb-accent-in, #E5DFD2);
  --neucomic-selection-ink: var(--nb-on-accent-in, #171717);
  --neucomic-action-shadow: 3px 3px 0 var(--neucomic-print-ink);
  --radius-sm: 2px;
  --nb-motion-distance: 3px;
  --nb-motion-pop: 1;
  --nb-motion-mark: 1;
  --neucomic-print-size: 4px;
  --neucomic-dot-radius: 1px;
  --neucomic-dot-ink: #79838E;
  --neucomic-halftone: radial-gradient(circle, var(--neucomic-dot-ink) var(--neucomic-dot-radius), transparent calc(var(--neucomic-dot-radius) + .1px));
  --neucomic-hatch: none;
  background-image: none !important;
  font-size: 1rem;
  line-height: 1.5;
}

#arcane-root.arcane-theme-neubrutalism.neucomic.neubrutalism-rounded {
  --nb-switch-track-radius: 0;
  --nb-switch-thumb-radius: 0;
}

#arcane-root.arcane-theme-neubrutalism.neucomic.neubrutalism-red {
  --nb-accent: var(--nb-accent-in, #D42D38);
  --nb-on-accent: var(--nb-on-accent-in, #FFFFFF);
  --nb-on-main: var(--nb-on-accent);
  --main-foreground: var(--nb-on-accent);
}

html.dark #arcane-root.arcane-theme-neubrutalism.neucomic,
#arcane-root.dark.arcane-theme-neubrutalism.neucomic {
  --background: var(--nb-dark-bg-in, #17191C);
  --foreground: #D8D4CA;
  --secondary-background: #24272C;
  --muted: #30343A;
  --muted-foreground: #A6A39B;
  --border: #50545A;
  --ring: var(--foreground);
  --nb-accent: var(--nb-accent-in, #B85C50);
  --nb-on-accent: var(--nb-on-accent-in, #000000);
  --nb-on-main: var(--nb-on-accent);
  --main-foreground: var(--nb-on-accent);
  --nb-line: var(--nb-line-in, #111315);
  --nb-control-line: var(--nb-line-in, #767B83);
  --nb-shadow-color: #111315;
  --neucomic-ink: #111315;
  --neucomic-paper: var(--card);
  --neucomic-paper-edge: #55534D;
  --neucomic-paper-under: #303136;
  --neucomic-print-ink: #111315;
  --neucomic-control-ink: var(--nb-line-in, #767B83);
  --neucomic-slider-fill: #767B83;
  --neucomic-slider-thumb: #D8D4CA;
  --neucomic-narration: #2D3035;
  --neucomic-narration-ink: #D8D4CA;
  --neucomic-selection: var(--nb-accent-in, #383D44);
  --neucomic-selection-ink: var(--nb-on-accent-in, #D8D4CA);
  --neucomic-action-shadow: 2px 2px 0 #111315;
  --neucomic-dot-ink: #50545A;
  --neucomic-hatch: none;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(h1, h2, .neubrutalism-display, .font-display, .display) {
  font-family: var(--font-display);
  font-weight: 400;
  letter-spacing: .015em;
  line-height: 1.05;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(h3, h4, h5, h6) {
  font-family: var(--font-sans);
  font-weight: 700;
  letter-spacing: -.02em;
  line-height: 1.25;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-button, .neubrutalism-cta-card-button, .neubrutalism-pricing-card-cta, .neubrutalism-toggle-button, .neubrutalism-cycle-button, .neubrutalism-tab, .neubrutalism-tabs-trigger, .neubrutalism-tab-bar-item, .neubrutalism-radio-button, .neubrutalism-toggle-group-item, .neubrutalism-menubar-trigger, .arcane-mega-menu-trigger, .neubrutalism-calendar-today-btn) {
  font-family: var(--font-sans) !important;
  font-size: .8125rem !important;
  font-weight: 800 !important;
  letter-spacing: .045em !important;
  line-height: 1.35 !important;
  text-transform: uppercase !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-button, .neubrutalism-cta-card-button, .neubrutalism-pricing-card-cta, .neubrutalism-toggle-button, .neubrutalism-cycle-button, .neubrutalism-radio-button, .neubrutalism-toggle-group-item):not([data-arcane-decorated]) {
  border: 2px solid var(--neucomic-control-ink) !important;
  border-radius: var(--neucomic-control-radius) !important;
  box-shadow: none !important;
  transform: none !important;
  animation: none !important;
  transition: border-color 120ms ease, transform 120ms ease, box-shadow 120ms ease !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-button[data-size="sm"] {
  min-height: 2.25rem !important;
  padding: .5rem .8rem !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-button[data-size="md"] {
  min-height: 2.625rem !important;
  padding: .625rem 1.1rem !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-button[data-size="lg"] {
  min-height: 3.125rem !important;
  padding: .8rem 1.4rem !important;
  font-size: .9375rem !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-button:is([data-variant="primary"], [data-variant="default"]), .neubrutalism-cta-card-button, .neubrutalism-pricing-card-cta):not([data-arcane-decorated]) {
  border-width: 3px !important;
  background: var(--nb-accent) !important;
  color: var(--nb-on-accent) !important;
  box-shadow: var(--neucomic-action-shadow) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-button:is([data-variant="primary"], [data-variant="default"]), .neubrutalism-cta-card-button, .neubrutalism-pricing-card-cta):hover:not(:disabled, [data-disabled="true"], [data-arcane-decorated]) {
  transform: translateY(-1px) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-button:is([data-variant="primary"], [data-variant="default"]), .neubrutalism-cta-card-button, .neubrutalism-pricing-card-cta):active:not(:disabled, [data-disabled="true"], [data-arcane-decorated]) {
  transform: translate(3px, 3px) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-button:is([data-variant="secondary"], [data-variant="outline"]):not([data-arcane-decorated]) {
  background: var(--neucomic-paper) !important;
  color: var(--neucomic-paper-ink) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-button:is([data-variant="secondary"], [data-variant="outline"]):hover:not(:disabled, [data-disabled="true"], [data-arcane-decorated]) {
  background: var(--muted) !important;
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-button:is([data-variant="ghost"], [data-variant="link"]):not([data-arcane-decorated]) {
  border: 2px solid transparent !important;
  background: transparent !important;
  color: var(--foreground) !important;
  box-shadow: none !important;
  transform: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-button:is([data-variant="ghost"], [data-variant="link"]):hover:not(:disabled, [data-disabled="true"], [data-arcane-decorated]) {
  background: var(--muted) !important;
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-button:is(:disabled, [data-disabled="true"]):not([data-arcane-decorated]) {
  box-shadow: none !important;
  transform: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-text-input-wrapper > label, .neubrutalism-textarea-label, .neubrutalism-select-label, .neubrutalism-radio-group-label, .neubrutalism-date-picker > span:first-child, .neubrutalism-time-picker > span:first-child, .neubrutalism-otp-input > span:first-child, .neubrutalism-field-label, .neubrutalism-field-label-row > label, .neubrutalism-slider-label) {
  font-family: var(--font-sans) !important;
  font-size: .75rem !important;
  font-weight: 800 !important;
  line-height: 1.4 !important;
  letter-spacing: .055em !important;
  text-transform: uppercase !important;
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-text-input:where(:not([data-arcane-field-inner="true"])), .neubrutalism-text-input-container, .neubrutalism-textarea, .neubrutalism-select-trigger, .neubrutalism-native-select, .arcane-select, .neubrutalism-otp-digit, .neubrutalism-date-picker-trigger, .neubrutalism-time-picker-trigger, .neubrutalism-select-search :where(input), .neubrutalism-command-input, textarea):not([data-arcane-decorated]) {
  border: 2px solid var(--neucomic-control-ink) !important;
  border-radius: var(--neucomic-field-radius) !important;
  background: var(--card) !important;
  color: var(--foreground) !important;
  font-family: var(--font-sans) !important;
  font-size: 1rem !important;
  font-weight: 500 !important;
  line-height: 1.5 !important;
  letter-spacing: 0 !important;
  text-transform: none !important;
  box-shadow: none !important;
  transform: none !important;
  animation: none !important;
  transition: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-text-input-container {
  min-width: 0;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-text-input[data-arcane-field-inner="true"] {
  min-width: 0;
  border: none !important;
  border-radius: var(--neucomic-field-radius) !important;
  background: transparent !important;
  color: var(--foreground) !important;
  font-family: var(--font-sans) !important;
  font-weight: 500 !important;
  box-shadow: none !important;
  transform: none !important;
  transition: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-text-input-prefix, .neubrutalism-text-input-suffix) {
  align-self: stretch;
  color: var(--muted-foreground) !important;
  font-family: var(--font-sans);
  font-size: .875rem;
  font-weight: 700;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-text-input, .neubrutalism-text-input-container, .neubrutalism-textarea, .neubrutalism-select-trigger, .neubrutalism-date-picker-trigger, .neubrutalism-time-picker-trigger, .neubrutalism-otp-digit):is([data-error="true"], [aria-invalid="true"]):not([data-arcane-decorated]),
#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-otp-input[data-state="error"] .neubrutalism-otp-digit,
#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-time-picker.error .neubrutalism-time-picker-trigger {
  border-color: var(--nb-error-foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-text-input, .neubrutalism-text-input-container, .neubrutalism-textarea, .neubrutalism-select-trigger, .neubrutalism-date-picker-trigger, .neubrutalism-time-picker-trigger, .neubrutalism-otp-digit):is(:disabled, [data-disabled="true"]):not([data-arcane-decorated]) {
  background: var(--muted) !important;
  color: var(--muted-foreground) !important;
  border-color: var(--muted-foreground) !important;
  cursor: not-allowed;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-text-input, .neubrutalism-textarea, .neubrutalism-command-input, .neubrutalism-select-search :where(input), textarea)::placeholder {
  color: var(--muted-foreground) !important;
  font-weight: 400;
  opacity: 1;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-select-trigger, .neubrutalism-date-picker-trigger, .neubrutalism-time-picker-trigger) {
  min-height: 2.75rem;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-select-chevron, .neubrutalism-date-picker-clear, .neubrutalism-time-picker-clear) {
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-otp-digit {
  font-size: 1.125rem !important;
  font-weight: 800 !important;
  font-variant-numeric: tabular-nums;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-otp-digit[data-state="filled"] {
  background: var(--muted) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-radio-card, .neubrutalism-radio-button, .neubrutalism-toggle-button, .neubrutalism-cycle-button, .neubrutalism-toggle-group-item) {
  border: 2px solid var(--neucomic-control-ink) !important;
  border-radius: var(--neucomic-control-radius) !important;
  background: var(--card) !important;
  color: var(--foreground) !important;
  box-shadow: none !important;
  transform: none !important;
  animation: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-toggle-group {
  gap: .375rem !important;
  padding: 0 !important;
  border: none !important;
  background: transparent !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-radio-card, .neubrutalism-radio-button, .neubrutalism-toggle-button, .neubrutalism-toggle-group-item):is([data-state="checked"], [data-state="on"]) {
  background: var(--neucomic-selection) !important;
  color: var(--neucomic-selection-ink) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-radio-card[data-state="checked"] :is(.neubrutalism-radio-label, .neubrutalism-radio-description) {
  color: var(--neucomic-selection-ink) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-radio-card, .neubrutalism-radio-button, .neubrutalism-toggle-button, .neubrutalism-cycle-button, .neubrutalism-toggle-group-item):hover:not([data-state="on"], [data-state="checked"], :disabled, [data-disabled="true"]) {
  background: var(--muted) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-checkbox-wrapper, .neubrutalism-toggle-switch) {
  --neucomic-choice-fill: var(--nb-accent);
  --neucomic-choice-ink: var(--nb-on-accent);
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-checkbox-wrapper, .neubrutalism-toggle-switch)[data-variant="secondary"] {
  --neucomic-choice-fill: var(--foreground);
  --neucomic-choice-ink: var(--background);
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-checkbox-wrapper, .neubrutalism-toggle-switch)[data-variant="destructive"] {
  --neucomic-choice-fill: var(--destructive);
  --neucomic-choice-ink: var(--destructive-foreground);
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-checkbox-wrapper, .neubrutalism-toggle-switch)[data-variant="success"] {
  --neucomic-choice-fill: var(--success);
  --neucomic-choice-ink: var(--success-foreground);
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-checkbox-wrapper, .neubrutalism-toggle-switch)[data-variant="warning"] {
  --neucomic-choice-fill: var(--warning);
  --neucomic-choice-ink: var(--warning-foreground);
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-checkbox-wrapper, .neubrutalism-toggle-switch)[data-variant="info"] {
  --neucomic-choice-fill: var(--info);
  --neucomic-choice-ink: var(--info-foreground);
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-checkbox {
  border: 2px solid var(--neucomic-control-ink) !important;
  border-radius: 1px !important;
  box-shadow: none !important;
  transform: none !important;
  animation: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-checkbox:is([data-state="checked"], [data-state="indeterminate"]) {
  background: var(--neucomic-choice-fill) !important;
  color: var(--neucomic-choice-ink) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-checkbox > span {
  color: inherit !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-radio-option, .neubrutalism-radio-card, .neubrutalism-radio-button, .neubrutalism-toggle-group-item, .neubrutalism-select-option, .neubrutalism-dropdown-item, .neubrutalism-menubar-item)[data-disabled="true"] {
  opacity: .45 !important;
  cursor: not-allowed;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-select-option-check {
  border: 2px solid var(--neucomic-control-ink) !important;
  border-radius: 1px !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-data-table, .neubrutalism-data-table-container, .neubrutalism-static-table-container) input[type="checkbox"] {
  appearance: none;
  -webkit-appearance: none;
  display: inline-grid;
  place-content: center;
  box-sizing: border-box;
  width: 20px;
  height: 20px;
  margin: 0;
  border: 2px solid var(--neucomic-control-ink);
  border-radius: 1px;
  background: var(--card);
  vertical-align: middle;
  cursor: pointer;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-data-table, .neubrutalism-data-table-container, .neubrutalism-static-table-container) input[type="checkbox"]:is(:checked, :indeterminate) {
  background: var(--neucomic-selection);
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-data-table, .neubrutalism-data-table-container, .neubrutalism-static-table-container) input[type="checkbox"]:checked::before {
  content: '';
  width: 5px;
  height: 9px;
  border-right: 2px solid var(--neucomic-selection-ink);
  border-bottom: 2px solid var(--neucomic-selection-ink);
  transform: translateY(-1px) rotate(45deg);
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-data-table, .neubrutalism-data-table-container, .neubrutalism-static-table-container) input[type="checkbox"]:indeterminate::before {
  content: '';
  width: 8px;
  height: 2px;
  background: var(--neucomic-selection-ink);
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-radio-circle {
  border: 2px solid var(--neucomic-control-ink) !important;
  border-radius: 50% !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-radio-dot {
  border-radius: 50% !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-radio-option[data-state="checked"] .neubrutalism-radio-circle {
  background: var(--neucomic-selection) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-radio-option[data-state="checked"] .neubrutalism-radio-dot {
  background: var(--neucomic-selection-ink) !important;
}

/* The square indicator sits inside a larger keyboard and pointer target. */
#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-toggle-switch {
  --neucomic-switch-size: 24px;
  --nb-switch-travel: 0px !important;
  width: 44px !important;
  height: 44px !important;
  padding: 0 !important;
  border: 0 !important;
  border-radius: 0 !important;
  background: transparent !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-toggle-switch[data-size="sm"] {
  --neucomic-switch-size: 20px;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-toggle-switch[data-size="lg"] {
  --neucomic-switch-size: 28px;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-toggle-switch::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  box-sizing: border-box;
  width: var(--neucomic-switch-size);
  height: var(--neucomic-switch-size);
  border: 2px solid var(--neucomic-control-ink);
  border-radius: 0;
  background: var(--card);
  transform: translate(-50%, -50%);
  pointer-events: none;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-toggle-switch::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  box-sizing: border-box;
  width: calc(var(--neucomic-switch-size) * .25);
  height: calc(var(--neucomic-switch-size) * .45);
  border: solid var(--neucomic-choice-ink);
  border-width: 0 2px 2px 0;
  transform: translate(-50%, -60%) rotate(45deg);
  opacity: 0;
  pointer-events: none;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-toggle-switch[aria-checked="true"]::before {
  background: var(--neucomic-choice-fill);
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-toggle-switch[aria-checked="true"]::after {
  opacity: 1;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-toggle-switch-thumb {
  display: none !important;
  border-radius: 0 !important;
  transform: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-slider-track-container {
  min-height: 40px;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-slider-track {
  height: 4px !important;
  border: 0 !important;
  border-radius: 0 !important;
  background: var(--border) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-slider-fill, .neubrutalism-slider-track-fill) {
  border: 0 !important;
  border-radius: 0 !important;
  background: var(--neucomic-slider-fill) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-slider-thumb {
  width: 22px !important;
  height: 26px !important;
  border: 2px solid var(--neucomic-ink) !important;
  border-radius: 0 !important;
  background: var(--neucomic-slider-thumb) !important;
  box-shadow: none !important;
  animation: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-slider[data-size="sm"] .neubrutalism-slider-thumb {
  width: 18px !important;
  height: 22px !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-slider[data-size="lg"] .neubrutalism-slider-thumb {
  width: 24px !important;
  height: 30px !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-slider-thumb[data-state="active"]:hover {
  transform: translate(-50%, -50%) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-slider-value {
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic input[type="range"] {
  appearance: none;
  -webkit-appearance: none;
  min-height: 40px;
  border: 0 !important;
  border-radius: 0 !important;
  background: transparent !important;
  cursor: pointer;
}

#arcane-root.arcane-theme-neubrutalism.neucomic input[type="range"]::-webkit-slider-runnable-track {
  height: 4px;
  border: 0;
  border-radius: 0;
  background: var(--border);
}

#arcane-root.arcane-theme-neubrutalism.neucomic input[type="range"]::-webkit-slider-thumb {
  appearance: none;
  -webkit-appearance: none;
  width: 22px;
  height: 26px;
  margin-top: -11px;
  border: 2px solid var(--neucomic-ink);
  border-radius: 0;
  background: var(--neucomic-slider-thumb);
  box-shadow: none;
}

#arcane-root.arcane-theme-neubrutalism.neucomic input[type="range"]::-moz-range-track {
  height: 4px;
  border: 0;
  border-radius: 0;
  background: var(--border);
}

#arcane-root.arcane-theme-neubrutalism.neucomic input[type="range"]::-moz-range-thumb {
  width: 18px;
  height: 22px;
  border: 2px solid var(--neucomic-ink);
  border-radius: 0;
  background: var(--neucomic-slider-thumb);
  box-shadow: none;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-tabs-list, .neubrutalism-tab-bar) {
  gap: .375rem !important;
  padding: .25rem !important;
  border: none !important;
  background: transparent !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-tab, .neubrutalism-tabs-trigger, .neubrutalism-tab-bar-item) {
  min-height: 2.625rem;
  padding: .625rem .95rem !important;
  border: 2px solid transparent !important;
  border-radius: var(--neucomic-control-radius) !important;
  background: transparent !important;
  color: var(--muted-foreground) !important;
  box-shadow: none !important;
  transform: none !important;
  animation: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-tab, .neubrutalism-tabs-trigger, .neubrutalism-tab-bar-item):hover:not([data-disabled="true"]) {
  background: var(--muted) !important;
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-tab, .neubrutalism-tabs-trigger, .neubrutalism-tab-bar-item):is([data-state="active"], [aria-selected="true"]) {
  border-color: var(--neucomic-control-ink) !important;
  background: var(--neucomic-selection) !important;
  background-image: var(--neucomic-print-pattern) !important;
  background-size: var(--neucomic-print-size) var(--neucomic-print-size) !important;
  color: var(--neucomic-selection-ink) !important;
  box-shadow: 2px 2px 0 var(--neucomic-paper-edge) !important;
  transform: rotate(-.7deg) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-tabs-badge {
  border: 1px solid currentColor !important;
  border-radius: 1px !important;
  background: transparent !important;
  color: inherit !important;
  font-family: var(--font-sans) !important;
  font-size: .6875rem !important;
  font-weight: 800 !important;
  letter-spacing: 0 !important;
  line-height: 1.35 !important;
  padding: .1rem .3rem !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-dropdown-item, .neubrutalism-context-menu-item, .neubrutalism-select-option, .neubrutalism-menubar-item, .neubrutalism-menubar-trigger, .arcane-mega-menu-trigger, .arcane-mega-menu-item, .neubrutalism-command-item, .neubrutalism-time-picker-option) {
  border: 2px solid transparent !important;
  border-radius: 1px !important;
  font-family: var(--font-sans) !important;
  font-size: .875rem !important;
  font-weight: 600 !important;
  line-height: 1.4 !important;
  box-shadow: none !important;
  transform: none !important;
  animation: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-dropdown-item, .neubrutalism-context-menu-item, .neubrutalism-select-option, .neubrutalism-menubar-item, .neubrutalism-menubar-trigger, .arcane-mega-menu-trigger, .arcane-mega-menu-item, .neubrutalism-command-item, .neubrutalism-time-picker-option):is(:hover, :focus-visible, [data-highlighted="true"]):not([data-disabled="true"], :disabled) {
  background: var(--muted) !important;
  color: var(--foreground) !important;
  border-color: var(--neucomic-control-ink) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-dropdown-item, .neubrutalism-select-option, .neubrutalism-menubar-item, .neubrutalism-command-item, .neubrutalism-time-picker-option):is([aria-selected="true"], [aria-checked="true"], [data-state="checked"], .selected) {
  background: var(--neucomic-selection) !important;
  color: var(--neucomic-selection-ink) !important;
  border-color: var(--neucomic-control-ink) !important;
  font-weight: 800 !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-dropdown-label, .neubrutalism-context-menu-label, .neubrutalism-command-group-heading) {
  width: fit-content !important;
  max-width: calc(100% - 12px);
  margin: 8px 6px 10px !important;
  padding: 4px 7px !important;
  border: 1px solid var(--neucomic-ink) !important;
  border-radius: 0 !important;
  background: var(--neucomic-paper-under) !important;
  background-image: var(--neucomic-print-pattern) !important;
  background-size: var(--neucomic-print-size) var(--neucomic-print-size) !important;
  color: var(--neucomic-paper-ink) !important;
  box-shadow: 1px 1px 0 var(--neucomic-ink) !important;
  transform: rotate(-.8deg);
  transform-origin: left center;
  font-family: var(--font-sans) !important;
  font-size: .6875rem !important;
  font-weight: 800 !important;
  letter-spacing: .06em !important;
  text-transform: uppercase !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-calendar-day, .arcane-calendar-day, .neubrutalism-calendar-nav-btn, .neubrutalism-calendar-today-btn, .neubrutalism-pagination-link) {
  border: 2px solid transparent !important;
  border-radius: 1px !important;
  background: transparent !important;
  color: var(--foreground) !important;
  font-family: var(--font-sans) !important;
  font-weight: 700 !important;
  box-shadow: none !important;
  transform: none !important;
  animation: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-calendar-day, .arcane-calendar-day, .neubrutalism-calendar-nav-btn, .neubrutalism-calendar-today-btn, .neubrutalism-pagination-link):hover:not(:disabled, [aria-disabled="true"], [data-disabled="true"]) {
  background: var(--muted) !important;
  border-color: var(--neucomic-control-ink) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-calendar-day, .arcane-calendar-day):is([data-today="true"], .arcane-calendar-day-today) {
  border-color: var(--neucomic-control-ink) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-calendar-day, .arcane-calendar-day):is([data-selected="true"], .arcane-calendar-day-selected, .arcane-calendar-day-range-start, .arcane-calendar-day-range-end),
#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-pagination-link[data-state="active"] {
  background: var(--neucomic-selection) !important;
  color: var(--neucomic-selection-ink) !important;
  border-color: var(--neucomic-control-ink) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .arcane-calendar-day-in-range:not(.arcane-calendar-day-range-start, .arcane-calendar-day-range-end) {
  background: var(--muted) !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :focus-visible:not([data-arcane-field-inner="true"]) {
  outline: 2px solid var(--ring) !important;
  outline-offset: 3px !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic :is(.neubrutalism-text-input:not([data-arcane-field-inner="true"]), .neubrutalism-textarea, .neubrutalism-select-trigger, .neubrutalism-date-picker-trigger, .neubrutalism-time-picker-trigger, .neubrutalism-otp-digit, .neubrutalism-select-search :where(input), .neubrutalism-command-input, textarea):focus,
#arcane-root.arcane-theme-neubrutalism.neucomic .neubrutalism-form-select button.neubrutalism-select-trigger[data-arcane-field-control="true"]:focus,
#arcane-root.arcane-theme-neubrutalism.neucomic [data-arcane-field-shell="true"]:focus-within:not(.arcane-native-select-shell) {
  outline: 2px solid var(--ring) !important;
  outline-offset: 3px !important;
  box-shadow: none !important;
  transform: none !important;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neucomic-caption {
  display: inline-block;
  max-width: 100%;
  padding: .35em .6em;
  border: 2px solid var(--neucomic-print-ink);
  border-radius: 0;
  background: var(--neucomic-narration);
  color: var(--neucomic-narration-ink);
  font-family: var(--font-sans);
  font-size: .8125rem;
  font-weight: 600;
  line-height: 1.4;
  box-shadow: 2px 2px 0 var(--neucomic-paper-edge);
  transform: rotate(-.8deg);
  transform-origin: left center;
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neucomic-halftone {
  background-image: var(--neucomic-halftone);
  background-color: var(--nb-paper);
  background-size: var(--neucomic-print-size) var(--neucomic-print-size);
}

#arcane-root.arcane-theme-neubrutalism.neucomic .neucomic-hatch {
  background-image: var(--neucomic-hatch);
}

@media (prefers-reduced-motion: reduce) {
  #arcane-root.arcane-theme-neubrutalism.neucomic *,
  #arcane-root.arcane-theme-neubrutalism.neucomic *::before,
  #arcane-root.arcane-theme-neubrutalism.neucomic *::after {
    scroll-behavior: auto !important;
    animation: none !important;
    transition: none !important;
  }
}

@media (forced-colors: active) {
  #arcane-root.arcane-theme-neubrutalism.neucomic,
  #arcane-root.arcane-theme-neubrutalism.neucomic * {
    background-image: none !important;
    box-shadow: none !important;
  }
}

@media print {
  #arcane-root.arcane-theme-neubrutalism.neucomic,
  #arcane-root.arcane-theme-neubrutalism.neucomic * {
    background-image: none !important;
    box-shadow: none !important;
  }
  html.dark #arcane-root.arcane-theme-neubrutalism.neucomic,
  html.light #arcane-root.arcane-theme-neubrutalism.neucomic,
  #arcane-root.dark.arcane-theme-neubrutalism.neucomic,
  #arcane-root.light.arcane-theme-neubrutalism.neucomic {
    --background: #FFFFFF;
    --foreground: #171717;
    --secondary-background: #FFFFFF;
    --muted: #FAF9F6;
    --muted-foreground: #555555;
    --border: #D2D2D2;
    --nb-line: #171717;
    --nb-control-line: #79838E;
    --neucomic-paper: #FFFFFF;
    --neucomic-paper-edge: #DED5C3;
    --neucomic-paper-under: #FFFFFF;
  }
}
''';
}
