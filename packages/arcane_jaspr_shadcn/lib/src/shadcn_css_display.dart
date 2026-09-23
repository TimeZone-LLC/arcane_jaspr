/// Display and data rules for the ShadCN renderer: card family, badge,
/// alert, separator, skeleton, progress, slider, tables, kbd and avatar.
///
/// Concatenated into [ShadcnCss.componentCss] after the token block so the
/// rules can rely on every `--shadcn-*` variable.
///
/// Renderers emit their resting look inline. State (hover, focus, selection)
/// reaches them through the `var(--shadcn-*, fallback)` hooks they reference
/// inline, which the rules below flip:
/// - `--shadcn-card-background` / `--shadcn-card-shadow`: interactive cards.
/// - `--shadcn-item-background` / `--shadcn-item-foreground`: table rows,
///   time-picker options and picker triggers.
/// - `--shadcn-table-row-border`: data-table row divider.
/// - `--shadcn-slider-thumb-shadow`: slider thumb hover/focus ring.
/// - `--shadcn-control-shadow` / `--shadcn-control-border-color`: picker
///   triggers (the date-picker focus rule sits with the controls in
///   shadcn_css.dart).
/// - `--shadcn-alert-dismiss-opacity`: alert dismiss button.
const String shadcnDisplayCss = '''
/* Card family: interactive and linked cards shift their surface on hover;
   the elevated ones also lift. Flat, outlined and ghost cards keep their
   resting `none` shadow, so only the focus ring reaches them. */
#arcane-root.arcane-theme-shadcn .arcane-card.clickable:hover,
#arcane-root.arcane-theme-shadcn .arcane-card[data-variant="interactive"]:hover,
#arcane-root.arcane-theme-shadcn a.arcane-feature-card:hover,
#arcane-root.arcane-theme-shadcn button.arcane-feature-card:hover,
#arcane-root.arcane-theme-shadcn a.arcane-flexi-card:hover,
#arcane-root.arcane-theme-shadcn button.arcane-flexi-card:hover {
  --shadcn-card-background: color-mix(in srgb, var(--card) 96%, var(--foreground));
}

#arcane-root.arcane-theme-shadcn .arcane-card.clickable:not([data-variant="flat"]):not([data-variant="outlined"]):not([data-variant="ghost"]):hover,
#arcane-root.arcane-theme-shadcn .arcane-card[data-variant="interactive"]:hover,
#arcane-root.arcane-theme-shadcn a.arcane-feature-card:hover,
#arcane-root.arcane-theme-shadcn button.arcane-feature-card:hover,
#arcane-root.arcane-theme-shadcn a.arcane-flexi-card:hover,
#arcane-root.arcane-theme-shadcn button.arcane-flexi-card:hover {
  --shadcn-card-shadow: var(--shadow-md);
}

#arcane-root.arcane-theme-shadcn .arcane-card.clickable:focus-visible,
#arcane-root.arcane-theme-shadcn a.arcane-feature-card:focus-visible,
#arcane-root.arcane-theme-shadcn button.arcane-feature-card:focus-visible,
#arcane-root.arcane-theme-shadcn a.arcane-flexi-card:focus-visible,
#arcane-root.arcane-theme-shadcn button.arcane-flexi-card:focus-visible {
  outline: none;
  --shadcn-card-shadow: var(--shadcn-focus-ring);
}

/* Alert dismiss */
#arcane-root.arcane-theme-shadcn .arcane-alert-dismiss:hover,
#arcane-root.arcane-theme-shadcn .arcane-alert-dismiss:focus-visible {
  --shadcn-alert-dismiss-opacity: 1;
}

#arcane-root.arcane-theme-shadcn .arcane-alert-dismiss:focus-visible {
  outline: none;
  box-shadow: var(--shadcn-focus-ring);
}

/* Progress: indeterminate indicator sweeps across the track. */
@keyframes arcane-progress-indeterminate {
  from { transform: translateX(-100%); }
  to { transform: translateX(200%); }
}

@media (prefers-reduced-motion: reduce) {
  #arcane-root.arcane-theme-shadcn .arcane-skeleton,
  #arcane-root.arcane-theme-shadcn .arcane-progress-indicator.indeterminate {
    animation: none !important;
  }
}

/* Slider thumb: hover:ring-4 ring-ring/50, focus uses the shared ring. */
#arcane-root.arcane-theme-shadcn .arcane-slider-thumb:hover,
#arcane-root.arcane-theme-shadcn .arcane-slider-thumb:active {
  --shadcn-slider-thumb-shadow: var(--shadow-sm), 0 0 0 4px color-mix(in srgb, var(--ring) 50%, transparent);
}

#arcane-root.arcane-theme-shadcn .arcane-slider-thumb:focus-visible {
  outline: none;
  --shadcn-slider-thumb-shadow: var(--shadow-sm), var(--shadcn-focus-ring);
}

/* Tables: header hairline, muted/50 row hover, muted selection. */
#arcane-root.arcane-theme-shadcn .arcane-data-table-header > tr,
#arcane-root.arcane-theme-shadcn .arcane-static-table > thead > tr {
  border-bottom: 1px solid var(--border);
}

#arcane-root.arcane-theme-shadcn .arcane-data-table-body > tr:last-child {
  --shadcn-table-row-border: 0;
}

#arcane-root.arcane-theme-shadcn .arcane-data-table-row:hover,
#arcane-root.arcane-theme-shadcn .arcane-static-table > tbody > tr:hover {
  --shadcn-item-background: color-mix(in srgb, var(--muted) 50%, transparent);
}

#arcane-root.arcane-theme-shadcn .arcane-data-table-row.selected,
#arcane-root.arcane-theme-shadcn .arcane-data-table-row.selected:hover {
  --shadcn-item-background: var(--muted);
}

#arcane-root.arcane-theme-shadcn .arcane-data-table td,
#arcane-root.arcane-theme-shadcn .arcane-static-table td {
  vertical-align: middle;
}

/* The shared static-table base fixes body padding inline; TableCell is p-2. */
#arcane-root.arcane-theme-shadcn .arcane-static-table > tbody > tr > td {
  padding: 0.5rem !important;
}

/* Picker triggers are outline buttons: accent hover, shared focus ring. The
   date-picker focus rule lives with the other controls in shadcn_css.dart. */
#arcane-root.arcane-theme-shadcn .arcane-date-picker-trigger:hover:not(:disabled),
#arcane-root.arcane-theme-shadcn .arcane-time-picker-trigger:hover:not(:disabled) {
  --shadcn-item-background: var(--accent);
  --shadcn-item-foreground: var(--accent-foreground);
}

#arcane-root.arcane-theme-shadcn .arcane-time-picker-trigger:focus-visible {
  outline: none;
  --shadcn-control-shadow: var(--shadow-xs), var(--shadcn-focus-ring);
  --shadcn-control-border-color: var(--shadcn-focus-border);
}

#arcane-root.arcane-theme-shadcn .arcane-date-picker-trigger[data-error="true"]:focus-visible,
#arcane-root.arcane-theme-shadcn .arcane-time-picker.error .arcane-time-picker-trigger:focus-visible {
  --shadcn-control-shadow: var(--shadow-xs), 0 0 0 3px color-mix(in oklab, var(--destructive) 20%, transparent);
  --shadcn-control-border-color: var(--destructive);
}

/* Time-picker options behave like menu items. */
#arcane-root.arcane-theme-shadcn .arcane-time-picker-option:not(.selected):hover {
  --shadcn-item-background: var(--accent);
  --shadcn-item-foreground: var(--accent-foreground);
}

#arcane-root.arcane-theme-shadcn .arcane-time-picker-option:focus-visible {
  outline: none;
  box-shadow: var(--shadcn-focus-ring);
}
''';
