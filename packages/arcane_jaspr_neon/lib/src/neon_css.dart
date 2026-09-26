import 'package:arcane_jaspr/component/navigation/toc.dart'
    show arcaneTocTreeLinesCss;
import 'package:arcane_jaspr/component/view/map/map_style.dart'
    show arcaneMapCss;
import 'package:arcane_jaspr/util/content/prose_styles.dart'
    show arcaneAllDocsStyles;

import 'package:arcane_jaspr_neon/src/neon_theme.dart';

/// Component CSS for the green and grayscale Neon theme.
///
/// Every rule is scoped to `#arcane-root.arcane-theme-neon` so it can never
/// affect the shadcn or neubrutalism themes. Colors come from the seeded palette
/// variables (`--primary`, `--card`, `--border`, `--shadow-*`, …) which the
/// stylesheet derives from [NeonTheme].
class NeonCss {
  const NeonCss._();

  static String _hex(int argb) {
    final int r = (argb >> 16) & 0xFF;
    final int g = (argb >> 8) & 0xFF;
    final int b = argb & 0xFF;
    return '#${r.toRadixString(16).padLeft(2, '0')}'
        '${g.toRadixString(16).padLeft(2, '0')}'
        '${b.toRadixString(16).padLeft(2, '0')}';
  }

  static String componentCss(NeonTheme theme) {
    final String primary = _hex(theme.color);

    return '''
/* ============================================================
   NEON THEME: green and neutral. Scoped to .arcane-theme-neon.
   ============================================================ */

#arcane-root.arcane-theme-neon {
  --neon-primary: $primary;
  --neon-accent-ink: #065f46;
  --neon-control-border: #858585;
  --input: var(--card);
  --neon-overlay-shadow: 0 18px 48px rgba(0, 0, 0, 0.32);
  --neon-overlay-frost: rgba(var(--card-rgb), 0.78);
  --arcane-nav-dropdown-background: var(--neon-overlay-frost);
}

html.dark #arcane-root.arcane-theme-neon,
#arcane-root.dark.arcane-theme-neon {
  --neon-accent-ink: #34d399;
  --neon-control-border: #707070;
}

#arcane-root.arcane-theme-neon ::selection {
  background: rgba(var(--primary-rgb), 0.35);
  color: var(--foreground);
}

#arcane-root.arcane-theme-neon :focus-visible {
  outline: 2px solid var(--primary);
  outline-offset: 2px;
}

/* ---------- Buttons ---------- */

#arcane-root.arcane-theme-neon .neon-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  font-family: inherit;
  font-weight: 600;
  line-height: 1.25;
  min-height: 2.5rem;
  box-sizing: border-box;
  white-space: nowrap;
  border: 1px solid transparent;
  border-radius: var(--radius-sm);
  cursor: pointer;
  text-decoration: none;
  transition: background var(--transition), border-color var(--transition),
    color var(--transition);
  padding: 0.5rem 1rem;
  font-size: var(--font-size-sm);
}

#arcane-root.arcane-theme-neon .neon-button[data-size="sm"] {
  min-height: 2rem;
  padding: 0.375rem 0.75rem;
  font-size: var(--font-size-xs);
}
#arcane-root.arcane-theme-neon .neon-button[data-size="lg"] {
  min-height: 3rem;
  padding: 0.625rem 1.25rem;
  font-size: var(--font-size-base);
}
#arcane-root.arcane-theme-neon .neon-button[data-size="iconSm"] {
  min-height: 2rem;
  padding: 0.375rem;
  width: 2rem;
  height: 2rem;
}
#arcane-root.arcane-theme-neon .neon-button[data-size="iconMd"] {
  padding: 0.5rem;
  width: 2.5rem;
  height: 2.5rem;
}
#arcane-root.arcane-theme-neon .neon-button[data-size="iconLg"] {
  min-height: 3rem;
  padding: 0.625rem;
  width: 3rem;
  height: 3rem;
}

#arcane-root.arcane-theme-neon .neon-button[data-variant="primary"] {
  background: var(--primary);
  color: var(--primary-foreground);
}
#arcane-root.arcane-theme-neon .neon-button[data-variant="secondary"] {
  background: var(--secondary);
  color: var(--secondary-foreground);
  border-color: var(--border);
}
#arcane-root.arcane-theme-neon .neon-button[data-variant="outline"] {
  background: transparent;
  color: var(--neon-accent-ink);
  border-color: color-mix(in srgb, var(--primary) 55%, var(--border));
}
#arcane-root.arcane-theme-neon .neon-button[data-variant="ghost"] {
  background: transparent;
  color: var(--foreground);
}
#arcane-root.arcane-theme-neon .neon-button[data-variant="link"] {
  background: transparent;
  color: var(--neon-accent-ink);
  padding-left: 0;
  padding-right: 0;
  text-decoration: underline;
  text-underline-offset: 3px;
}
#arcane-root.arcane-theme-neon .neon-button[data-variant="destructive"] {
  background: var(--destructive);
  color: var(--destructive-foreground);
}
#arcane-root.arcane-theme-neon .neon-button[data-variant="success"] {
  background: var(--success);
  color: var(--success-foreground);
}
#arcane-root.arcane-theme-neon .neon-button[data-variant="warning"] {
  background: var(--warning);
  color: var(--warning-foreground);
}
#arcane-root.arcane-theme-neon .neon-button[data-variant="info"] {
  background: var(--info);
  color: var(--info-foreground);
}

#arcane-root.arcane-theme-neon
  .neon-button:hover:not([data-disabled="true"]):not([data-variant="link"]):not([data-variant="ghost"]) {
  border-color: color-mix(in srgb, var(--primary) 68%, var(--border));
}
#arcane-root.arcane-theme-neon
  .neon-button[data-variant="outline"]:hover:not([data-disabled="true"]) {
  background: rgba(var(--primary-rgb), 0.12);
}
#arcane-root.arcane-theme-neon
  .neon-button[data-variant="ghost"]:hover:not([data-disabled="true"]) {
  background: rgba(var(--primary-rgb), 0.12);
  color: var(--neon-accent-ink);
}
#arcane-root.arcane-theme-neon
  .neon-button:active:not([data-disabled="true"]) {
  opacity: 0.88;
}
#arcane-root.arcane-theme-neon .neon-button[data-disabled="true"] {
  pointer-events: none;
  opacity: 0.5;
  cursor: not-allowed;
}

#arcane-root.arcane-theme-neon .neon-button-group {
  display: inline-flex;
  gap: 0.5rem;
}
#arcane-root.arcane-theme-neon .neon-button-panel {
  display: flex;
  gap: 0.5rem;
  flex-wrap: wrap;
}

/* ---------- Disclosure ---------- */

#arcane-root.arcane-theme-neon .neon-disclosure-summary::-webkit-details-marker {
  display: none;
}
#arcane-root.arcane-theme-neon .neon-disclosure-summary::marker {
  content: '';
}
#arcane-root.arcane-theme-neon
  .neon-disclosure[open] > .neon-disclosure-summary > .neon-disclosure-chevron {
  transform: rotate(45deg);
}

/* ---------- Surfaces (cards, popovers, menus, dialogs) ---------- */

#arcane-root.arcane-theme-neon .neon-card,
#arcane-root.arcane-theme-neon .neon-popover,
#arcane-root.arcane-theme-neon .neon-dropdown-menu,
#arcane-root.arcane-theme-neon .neon-select-dropdown,
#arcane-root.arcane-theme-neon .neon-command-dialog,
#arcane-root.arcane-theme-neon .neon-command-list,
#arcane-root.arcane-theme-neon .neon-toast,
#arcane-root.arcane-theme-neon .neon-accordion,
#arcane-root.arcane-theme-neon .neon-empty-state {
  background: var(--card);
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  color: var(--card-foreground);
}

#arcane-root.arcane-theme-neon .neon-card {
  position: relative;
  padding: 1.25rem;
  transition: background var(--transition), border-color var(--transition);
}
#arcane-root.arcane-theme-neon .neon-card[data-variant="elevated"] {
  box-shadow: none;
}
#arcane-root.arcane-theme-neon .neon-card[data-variant="elevated"],
#arcane-root.arcane-theme-neon .neon-card[data-variant="interactive"],
#arcane-root.arcane-theme-neon .neon-card.clickable {
  border-color: var(--border);
}
#arcane-root.arcane-theme-neon .neon-card[data-variant="flat"] {
  box-shadow: none;
}
#arcane-root.arcane-theme-neon .neon-card[data-variant="outlined"] {
  background: transparent;
}
#arcane-root.arcane-theme-neon .neon-card[data-variant="ghost"] {
  background: transparent;
  border-color: transparent;
}
/* Nested cards collapse to unframed content. Neon permits one visible surface
   perimeter per hierarchy level. */
#arcane-root.arcane-theme-neon .neon-card .neon-card {
  background: transparent !important;
  border: 0 !important;
  border-radius: 0 !important;
  box-shadow: none !important;
}
#arcane-root.arcane-theme-neon .neon-card[data-variant="interactive"],
#arcane-root.arcane-theme-neon .neon-card.clickable {
  cursor: pointer;
}
#arcane-root.arcane-theme-neon .neon-card[data-variant="interactive"]:hover,
#arcane-root.arcane-theme-neon .neon-card.clickable:hover {
  background: var(--card-hover);
  border-color: var(--primary);
}

/* ---------- Feature / icon cards ---------- */

#arcane-root.arcane-theme-neon .neon-feature-card,
#arcane-root.arcane-theme-neon .neon-icon-card {
  transition: background var(--transition), border-color var(--transition);
}
#arcane-root.arcane-theme-neon a.neon-feature-card:hover,
#arcane-root.arcane-theme-neon .neon-feature-card.clickable:hover,
#arcane-root.arcane-theme-neon a.neon-icon-card:hover,
#arcane-root.arcane-theme-neon .neon-icon-card.clickable:hover {
  background: var(--card-hover);
}

/* ---------- Pricing / testimonial cards ---------- */

#arcane-root.arcane-theme-neon .neon-pricing-card,
#arcane-root.arcane-theme-neon .neon-testimonial-card {
  transition: border-color var(--transition);
}

/* ---------- Dropdown / popover / command items ---------- */

#arcane-root.arcane-theme-neon .neon-dropdown-menu,
#arcane-root.arcane-theme-neon .neon-dropdown-submenu,
#arcane-root.arcane-theme-neon .neon-select-dropdown,
#arcane-root.arcane-theme-neon .arcane-nav-dropdown-panel {
  background: var(--neon-overlay-frost);
  backdrop-filter: blur(18px);
  -webkit-backdrop-filter: blur(18px);
  box-shadow: var(--neon-overlay-shadow);
}

@media (prefers-reduced-transparency: reduce) {
  #arcane-root.arcane-theme-neon {
    --neon-overlay-frost: var(--card);
  }

  #arcane-root.arcane-theme-neon .neon-dropdown-menu,
  #arcane-root.arcane-theme-neon .neon-dropdown-submenu,
  #arcane-root.arcane-theme-neon .neon-select-dropdown,
  #arcane-root.arcane-theme-neon .arcane-nav-dropdown-panel {
    background: var(--card);
    backdrop-filter: none;
    -webkit-backdrop-filter: none;
  }
}

#arcane-root.arcane-theme-neon .neon-dropdown-menu,
#arcane-root.arcane-theme-neon .neon-popover,
#arcane-root.arcane-theme-neon .neon-select-dropdown {
  padding: 0.35rem;
  box-shadow: var(--neon-overlay-shadow);
}
#arcane-root.arcane-theme-neon .neon-dropdown-item,
#arcane-root.arcane-theme-neon .neon-command-item,
#arcane-root.arcane-theme-neon .neon-select-option {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.45rem 0.6rem;
  border-radius: var(--radius-sm);
  cursor: pointer;
  color: var(--foreground);
  transition: background var(--transition), color var(--transition);
}
#arcane-root.arcane-theme-neon .neon-dropdown-item:hover:not([data-disabled="true"]),
#arcane-root.arcane-theme-neon .neon-dropdown-item:focus-visible:not([data-disabled="true"]),
#arcane-root.arcane-theme-neon .neon-command-item:hover:not([data-disabled="true"]),
#arcane-root.arcane-theme-neon .neon-command-item[aria-selected="true"],
#arcane-root.arcane-theme-neon .neon-select-option:hover:not([data-disabled="true"]) {
  background: rgba(var(--primary-rgb), 0.14);
  color: var(--neon-accent-ink);
}
#arcane-root.arcane-theme-neon .neon-dropdown-label,
#arcane-root.arcane-theme-neon .neon-command-group-heading {
  padding: 0.35rem 0.6rem;
  font-size: var(--font-size-xs);
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--muted-foreground);
}
#arcane-root.arcane-theme-neon .neon-dropdown-divider {
  height: 1px;
  background: var(--border);
  margin: 0.35rem 0;
  border: none;
}

/* ---------- Inputs ---------- */

#arcane-root.arcane-theme-neon .neon-text-input,
#arcane-root.arcane-theme-neon .neon-select-trigger,
#arcane-root.arcane-theme-neon .neon-command-input,
#arcane-root.arcane-theme-neon .neon-select-search input,
#arcane-root.arcane-theme-neon .neon-otp-digit {
  width: 100%;
  min-width: 0;
  min-height: 2.5rem;
  box-sizing: border-box;
  background: var(--input);
  border: 1px solid var(--neon-control-border);
  border-radius: var(--radius-md);
  padding: 0.5rem 0.75rem;
  color: var(--foreground);
  font: inherit;
  transition: border-color var(--transition);
}
#arcane-root.arcane-theme-neon .neon-otp-digit {
  width: 2.75rem;
  text-align: center;
  font-weight: 600;
}
#arcane-root.arcane-theme-neon .neon-text-input::placeholder,
#arcane-root.arcane-theme-neon .neon-textarea::placeholder,
#arcane-root.arcane-theme-neon .neon-command-input::placeholder,
#arcane-root.arcane-theme-neon .neon-select-search input::placeholder {
  color: var(--muted-foreground);
  opacity: 1;
}
#arcane-root.arcane-theme-neon .neon-text-input:focus,
#arcane-root.arcane-theme-neon .neon-textarea:focus,
#arcane-root.arcane-theme-neon .neon-select-trigger:focus,
#arcane-root.arcane-theme-neon .neon-command-input:focus,
#arcane-root.arcane-theme-neon .neon-select-search input:focus,
#arcane-root.arcane-theme-neon .neon-otp-digit:focus {
  outline: none;
  border-color: var(--primary);
  box-shadow: none;
}
#arcane-root.arcane-theme-neon .neon-text-input-wrapper,
#arcane-root.arcane-theme-neon .neon-textarea-wrapper {
  display: flex;
  flex-direction: column;
  gap: 0.35rem;
}
#arcane-root.arcane-theme-neon .neon-text-input-error,
#arcane-root.arcane-theme-neon .neon-textarea-error,
#arcane-root.arcane-theme-neon .neon-select-error,
#arcane-root.arcane-theme-neon .neon-radio-group-error {
  color: var(--destructive);
  font-size: var(--font-size-xs);
}
#arcane-root.arcane-theme-neon .neon-text-input-helper,
#arcane-root.arcane-theme-neon .neon-textarea-helper,
#arcane-root.arcane-theme-neon .neon-select-helper,
#arcane-root.arcane-theme-neon .neon-radio-group-helper {
  color: var(--muted-foreground);
  font-size: var(--font-size-xs);
}
#arcane-root.arcane-theme-neon .neon-select.error .neon-select-trigger,
#arcane-root.arcane-theme-neon .neon-text-input[data-error="true"],
#arcane-root.arcane-theme-neon .neon-textarea[data-error="true"] {
  border-color: var(--destructive);
}

#arcane-root.arcane-theme-neon .neon-textarea:disabled {
  pointer-events: none;
  opacity: 0.5;
  cursor: not-allowed;
}

#arcane-root.arcane-theme-neon .neon-textarea[data-readonly="true"] {
  background: var(--muted);
  color: var(--muted-foreground);
  caret-color: var(--muted-foreground);
  cursor: default;
}

/* ---------- Checkbox / radio / toggle ---------- */

#arcane-root.arcane-theme-neon .neon-checkbox-box {
  width: 1.125rem;
  height: 1.125rem;
  box-sizing: border-box;
  margin-top: 0.0625rem;
  border: 1px solid var(--neon-control-border);
  border-radius: var(--radius-sm);
  background: var(--input);
  color: var(--primary-foreground);
  transition: background-color var(--transition), border-color var(--transition);
}
#arcane-root.arcane-theme-neon .neon-checkbox-box[data-state="checked"]:not([data-arcane-state]),
#arcane-root.arcane-theme-neon .neon-checkbox-box[data-arcane-state="selected"],
#arcane-root.arcane-theme-neon input:checked + .neon-checkbox-box {
  background: var(--primary);
  border-color: var(--primary);
}
#arcane-root.arcane-theme-neon .neon-checkbox-indicator {
  display: none;
}
#arcane-root.arcane-theme-neon .neon-checkbox-box[data-arcane-state="selected"] .neon-checkbox-indicator {
  display: inline-flex;
}
#arcane-root.arcane-theme-neon .neon-checkbox-wrapper[data-size="sm"] .neon-checkbox-box {
  width: 1rem;
  height: 1rem;
}
#arcane-root.arcane-theme-neon .neon-checkbox-wrapper[data-size="lg"] .neon-checkbox-box {
  width: 1.375rem;
  height: 1.375rem;
}
#arcane-root.arcane-theme-neon .neon-toggle-wrapper {
  display: inline-flex;
  align-items: center;
  gap: 0.625rem;
  cursor: pointer;
}
#arcane-root.arcane-theme-neon .neon-toggle-label {
  font-size: var(--font-size-sm);
  line-height: 1.4;
}
#arcane-root.arcane-theme-neon .neon-toggle-switch {
  position: relative;
  display: inline-flex;
  align-items: center;
  flex-shrink: 0;
  width: 2.5rem;
  height: 1.4rem;
  border: none;
  border-radius: var(--radius-sm);
  background: var(--border);
  padding: 2px;
  cursor: pointer;
  transition: background var(--transition);
}
#arcane-root.arcane-theme-neon .neon-toggle-switch[data-state="checked"]:not([data-arcane-state]),
#arcane-root.arcane-theme-neon .neon-toggle-switch[data-arcane-state="selected"],
#arcane-root.arcane-theme-neon .neon-toggle-switch.active:not([data-arcane-state]) {
  background: var(--primary);
}
#arcane-root.arcane-theme-neon .neon-toggle-switch[data-disabled="true"] {
  opacity: 0.5;
  cursor: not-allowed;
}
#arcane-root.arcane-theme-neon .neon-toggle-thumb {
  width: 1rem;
  height: 1rem;
  border-radius: 50%;
  background: #ffffff;
  transition: transform var(--transition);
}
#arcane-root.arcane-theme-neon .neon-toggle-switch[data-state="checked"]:not([data-arcane-state]) .neon-toggle-thumb,
#arcane-root.arcane-theme-neon .neon-toggle-switch[data-arcane-state="selected"] .neon-toggle-thumb,
#arcane-root.arcane-theme-neon .neon-toggle-switch.active:not([data-arcane-state]) .neon-toggle-thumb {
  transform: translateX(1.1rem);
}
#arcane-root.arcane-theme-neon .neon-radio-group {
  display: flex;
  flex-direction: column;
  gap: 0.625rem;
  min-width: 0;
}
#arcane-root.arcane-theme-neon .neon-radio-group-label,
#arcane-root.arcane-theme-neon .neon-radio-label {
  font-size: var(--font-size-sm);
  font-weight: 600;
  line-height: 1.4;
}
#arcane-root.arcane-theme-neon .neon-radio-description {
  font-size: var(--font-size-sm);
  color: var(--muted-foreground);
  line-height: 1.5;
}
#arcane-root.arcane-theme-neon .neon-radio-content {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  min-width: 0;
}
#arcane-root.arcane-theme-neon .neon-radio-option,
#arcane-root.arcane-theme-neon .neon-radio-card,
#arcane-root.arcane-theme-neon .neon-radio-button {
  position: relative;
  display: flex;
  align-items: flex-start;
  gap: 0.625rem;
  min-width: 0;
  cursor: pointer;
}
#arcane-root.arcane-theme-neon .neon-radio-input {
  position: absolute;
  width: 1px;
  height: 1px;
  margin: 0;
  opacity: 0;
}
#arcane-root.arcane-theme-neon .neon-radio-circle {
  width: 1.125rem;
  height: 1.125rem;
  flex-shrink: 0;
  box-sizing: border-box;
  margin-top: 0.0625rem;
  border: 1px solid var(--neon-control-border);
  border-radius: 50%;
  background: var(--input);
}
#arcane-root.arcane-theme-neon .neon-radio-input:checked + .neon-radio-circle {
  border: 5px solid var(--primary);
}
#arcane-root.arcane-theme-neon .neon-radio-input:focus-visible {
  outline: none;
}
#arcane-root.arcane-theme-neon .neon-radio-option:has(input:focus-visible) .neon-radio-circle,
#arcane-root.arcane-theme-neon .neon-radio-card:has(input:focus-visible),
#arcane-root.arcane-theme-neon .neon-radio-button:has(input:focus-visible) {
  outline: 2px solid var(--primary);
  outline-offset: 2px;
}
#arcane-root.arcane-theme-neon .neon-radio-card,
#arcane-root.arcane-theme-neon .neon-radio-button {
  padding: 0.75rem;
  border: 1px solid var(--neon-control-border);
  border-radius: var(--radius-sm);
  background: var(--card);
  transition: border-color var(--transition), background-color var(--transition);
}
#arcane-root.arcane-theme-neon .neon-radio-card:has(input:checked),
#arcane-root.arcane-theme-neon .neon-radio-button:has(input:checked) {
  border-color: var(--primary);
  background: var(--primary-container);
}
#arcane-root.arcane-theme-neon .neon-radio-button {
  align-items: center;
  min-height: 2.5rem;
  padding: 0.5rem 0.875rem;
}
#arcane-root.arcane-theme-neon .neon-radio-button .neon-radio-circle {
  display: none;
}
#arcane-root.arcane-theme-neon :is(.neon-radio-option, .neon-radio-card, .neon-radio-button)[data-disabled="true"] {
  opacity: 0.5;
  cursor: not-allowed;
}
#arcane-root.arcane-theme-neon .neon-radio-group[aria-invalid="true"]
  :is(.neon-radio-card, .neon-radio-button, .neon-radio-circle) {
  border-color: var(--destructive);
}

/* ---------- Tabs ---------- */

#arcane-root.arcane-theme-neon .neon-tabs-list,
#arcane-root.arcane-theme-neon .neon-tab-bar {
  display: inline-flex;
  gap: 0.25rem;
  padding: 0.25rem;
  background: var(--secondary);
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
}
#arcane-root.arcane-theme-neon .neon-tabs-trigger,
#arcane-root.arcane-theme-neon .neon-tab-bar-item {
  padding: 0.375rem 0.75rem;
  border: none;
  background: transparent;
  color: var(--muted-foreground);
  border-radius: var(--radius-sm);
  font: inherit;
  font-weight: 600;
  cursor: pointer;
  transition: all var(--transition);
}
#arcane-root.arcane-theme-neon .neon-tabs-trigger:hover,
#arcane-root.arcane-theme-neon .neon-tab-bar-item:hover {
  color: var(--foreground);
}
#arcane-root.arcane-theme-neon .neon-tabs-trigger.active,
#arcane-root.arcane-theme-neon .neon-tabs-trigger[data-state="active"],
#arcane-root.arcane-theme-neon .neon-tab-bar-item.selected,
#arcane-root.arcane-theme-neon .neon-tab-bar-item[data-state="active"] {
  background: var(--card);
  color: var(--neon-accent-ink);
  outline: 1px solid var(--border);
}
#arcane-root.arcane-theme-neon .neon-tabs-content {
  padding-top: 1rem;
}

@media (forced-colors: active) {
  #arcane-root.arcane-theme-neon :focus-visible {
    outline-color: Highlight;
  }
  #arcane-root.arcane-theme-neon .neon-radio-input:checked + .neon-radio-circle {
    border-color: Highlight;
  }
}

/* ---------- Alerts ---------- */

#arcane-root.arcane-theme-neon .neon-alert {
  display: flex;
  gap: 0.75rem;
  padding: 1rem;
  border-radius: var(--radius-md);
  border: 2px solid var(--primary);
  background: var(--card);
}
#arcane-root.arcane-theme-neon .neon-alert[data-variant="destructive"] {
  border-color: var(--destructive);
}
#arcane-root.arcane-theme-neon .neon-alert[data-variant="success"] {
  border-color: var(--success);
}
#arcane-root.arcane-theme-neon .neon-alert[data-variant="warning"] {
  border-color: var(--warning);
}
#arcane-root.arcane-theme-neon .neon-alert[data-variant="info"] {
  border-color: var(--info);
}
#arcane-root.arcane-theme-neon .neon-alert-title {
  font-weight: 700;
}
#arcane-root.arcane-theme-neon .neon-alert-description {
  color: var(--muted-foreground);
}
#arcane-root.arcane-theme-neon .neon-alert-dismiss {
  margin-left: auto;
  background: transparent;
  border: none;
  color: var(--muted-foreground);
  cursor: pointer;
}

/* ---------- Badges / status ---------- */

#arcane-root.arcane-theme-neon .neon-status-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  padding: 0.2rem 0.6rem;
  border-radius: var(--radius-sm);
  font-size: var(--font-size-xs);
  font-weight: 700;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  border: 1px solid color-mix(in srgb, var(--primary) 35%, transparent);
  background: rgba(var(--primary-rgb), 0.16);
  color: var(--neon-accent-ink);
}
#arcane-root.arcane-theme-neon .neon-status-indicator {
  width: 0.5rem;
  height: 0.5rem;
  border-radius: 50%;
  background: currentColor;
}
#arcane-root.arcane-theme-neon .neon-status-label {
  text-transform: uppercase;
  letter-spacing: 0.04em;
  font-weight: 700;
}

/* ---------- Progress ---------- */

#arcane-root.arcane-theme-neon .neon-progress,
#arcane-root.arcane-theme-neon .neon-progress-track {
  background: var(--secondary);
  border-radius: var(--radius-xs);
  overflow: hidden;
}
#arcane-root.arcane-theme-neon .neon-progress-indicator,
#arcane-root.arcane-theme-neon .neon-progress-value {
  height: 100%;
  background: var(--primary);
  border-radius: var(--radius-xs);
}
#arcane-root.arcane-theme-neon .neon-loading-spinner {
  color: var(--neon-accent-ink);
}

/* ---------- Misc components ---------- */

#arcane-root.arcane-theme-neon .neon-avatar {
  border-radius: 50%;
  border: 1px solid var(--border);
  overflow: hidden;
  background: var(--secondary);
}
#arcane-root.arcane-theme-neon .neon-avatar-status {
  border: 2px solid var(--background);
}
#arcane-root.arcane-theme-neon .neon-separator {
  background: var(--border);
  border: none;
}
#arcane-root.arcane-theme-neon .neon-separator:not(.neon-separator-vertical) {
  height: 1px;
  width: 100%;
}
#arcane-root.arcane-theme-neon .neon-separator-vertical {
  width: 1px;
  align-self: stretch;
}
#arcane-root.arcane-theme-neon .neon-kbd {
  font-family: var(--font-mono);
  font-size: 0.8em;
  padding: 0.1rem 0.4rem;
  border: 1px solid var(--border);
  border-radius: var(--radius-sm);
  background: var(--secondary);
  color: var(--foreground);
}
#arcane-root.arcane-theme-neon .neon-breadcrumb-separator {
  color: var(--muted-foreground);
}
#arcane-root.arcane-theme-neon .neon-empty-state {
  text-align: center;
  padding: 2rem;
}
#arcane-root.arcane-theme-neon .neon-empty-state-icon {
  color: var(--muted-foreground);
}
#arcane-root.arcane-theme-neon .neon-empty-state-title {
  font-weight: 700;
}
#arcane-root.arcane-theme-neon .neon-empty-state-description {
  color: var(--muted-foreground);
}
#arcane-root.arcane-theme-neon .neon-toast-title {
  font-weight: 700;
}
#arcane-root.arcane-theme-neon .neon-toast-description {
  color: var(--muted-foreground);
}

/* ---------- Sidebar + scaffold chrome ---------- */

#arcane-root.arcane-theme-neon .neon-sidebar {
  background: var(--card);
  border-right: 1px solid var(--border);
}
#arcane-root.arcane-theme-neon .neon-sidebar-group-label {
  text-transform: uppercase;
  letter-spacing: 0.06em;
  font-size: var(--font-size-xs);
  font-weight: 700;
  color: var(--muted-foreground);
}
#arcane-root.arcane-theme-neon .neon-sidebar-separator {
  height: 1px;
  background: var(--border);
}

/* ---------- Docs chrome layout (scaffold + kb-*) ---------- */

#arcane-root.arcane-theme-neon .arcane-scaffold {
  min-height: 100vh !important;
  display: flex !important;
  flex-direction: column !important;
  padding-top: 0 !important;
  background: var(--background) !important;
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neon .arcane-scaffold-header {
  position: sticky !important;
  top: 0 !important;
  left: auto !important;
  right: auto !important;
  z-index: 40 !important;
  height: 3.5rem !important;
  min-height: 3.5rem !important;
  padding: 0 !important;
  border-bottom: 1px solid var(--border) !important;
  border-bottom-color: var(--border) !important;
  background: var(--background) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neon .arcane-scaffold-body {
  display: grid !important;
  grid-template-columns: minmax(15rem, 17.5rem) minmax(0, 1fr) !important;
  align-items: start !important;
  gap: 0 !important;
  padding: 0 !important;
  overflow: visible !important;
}

#arcane-root.arcane-theme-neon .arcane-scaffold-sidebar,
#arcane-root.arcane-theme-neon .arcane-scaffold-secondary {
  border-color: var(--border) !important;
  background: var(--card) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neon .arcane-scaffold-sidebar.arcane-scaffold-sidebar {
  position: sticky !important;
  top: 3.5rem !important;
  left: auto !important;
  right: auto !important;
  bottom: auto !important;
  align-self: start !important;
  width: 17.5rem !important;
  border-right: 1px solid var(--border) !important;
  height: max-content !important;
  max-height: none !important;
  min-height: 0 !important;
  overflow: visible !important;
  padding: 0 !important;
}

#arcane-root.arcane-theme-neon .arcane-scaffold-main.arcane-scaffold-main {
  min-width: 0 !important;
  width: 100% !important;
  max-width: none !important;
  min-height: 0 !important;
  margin-left: 0 !important;
  padding: 0 !important;
  border: 0 !important;
  overflow: visible !important;
}

#arcane-root.arcane-theme-neon .kb-topbar {
  position: sticky;
  top: 0;
  z-index: 50;
  border: 0;
  border-bottom: 1px solid var(--border);
  background: var(--background);
  box-shadow: none;
}

#arcane-root.arcane-theme-neon .arcane-scaffold-header .kb-topbar {
  border-bottom: 0 !important;
}

#arcane-root.arcane-theme-neon .kb-topbar-inner {
  width: 100%;
  max-width: none;
  height: 3.5rem;
  min-height: 3.5rem;
  padding: 0 1.5rem;
  gap: 1.25rem;
}

#arcane-root.arcane-theme-neon .kb-topbar-left,
#arcane-root.arcane-theme-neon .kb-topbar-right {
  min-width: 0;
  gap: 0.875rem;
}

#arcane-root.arcane-theme-neon .kb-topbar-left {
  flex: 1 1 auto;
}

#arcane-root.arcane-theme-neon .kb-topbar-right {
  flex: 0 1 auto;
  padding: 0;
  border: 0;
  border-radius: 0;
  background: transparent;
}

#arcane-root.arcane-theme-neon .kb-topbar-nav {
  min-width: 0;
  margin-left: 0.25rem;
  padding: 0;
  gap: 1.25rem;
  border: 0;
  border-radius: 0;
  background: transparent;
}

#arcane-root.arcane-theme-neon .kb-topbar-brand {
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

#arcane-root.arcane-theme-neon .kb-topbar-brand-icon {
  display: none;
}

#arcane-root.arcane-theme-neon .kb-topbar-brand-label {
  color: var(--foreground);
}

#arcane-root.arcane-theme-neon .kb-style-switcher {
  flex: 0 0 auto;
  flex-wrap: nowrap;
}

#arcane-root.arcane-theme-neon .kb-topbar-link {
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

#arcane-root.arcane-theme-neon .kb-topbar-link:hover,
#arcane-root.arcane-theme-neon .kb-topbar-link.active {
  background: transparent;
  color: var(--neon-accent-ink);
  box-shadow: none;
}

#arcane-root.arcane-theme-neon .kb-topbar-link.active {
  font-weight: 600;
}

#arcane-root.arcane-theme-neon .kb-topbar-link::after {
  content: '';
  position: absolute;
  left: 0;
  right: 0;
  bottom: -0.7rem;
  height: 2px;
  background: transparent;
}

#arcane-root.arcane-theme-neon .kb-topbar-link.active::after {
  background: var(--primary);
}

#arcane-root.arcane-theme-neon .arcane-scaffold-sidebar .kb-sidebar {
  position: relative !important;
  top: auto !important;
  width: 100% !important;
  height: max-content !important;
  max-height: none !important;
  min-height: 0 !important;
  padding: 0.375rem !important;
  overflow: visible !important;
}

#arcane-root.arcane-theme-neon .arcane-scaffold-sidebar .kb-sidebar-panel {
  min-height: 0 !important;
}

/* Docs knowledge-base sidebar: pin it directly below the 3.5rem sticky topbar
   (the inline --kb-sidebar-rail-top otherwise double-counts the topbar height,
   leaving a gap above the nav) and give it its own scroll rail instead of
   forcing the whole page to scroll. Targets the generic `.kb-sidebar` so it
   applies whatever the renderer prefix is (neon-kb-sidebar, default-kb-sidebar). */
#arcane-root.arcane-theme-neon .kb-sidebar {
  top: 3.5rem;
  max-height: calc(100vh - 3.5rem);
  overflow-y: auto;
}

#arcane-root.arcane-theme-neon .sidebar-header {
  margin: 0 0 0.5rem;
  padding: 0.625rem;
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  background: var(--card);
  box-shadow: none;
}

#arcane-root.arcane-theme-neon .sidebar-nav {
  padding: 0.375rem 0.125rem 0.625rem !important;
  gap: 0.375rem !important;
}

#arcane-root.arcane-theme-neon .sidebar-section {
  margin-bottom: 0.375rem;
}

#arcane-root.arcane-theme-neon .sidebar-section-header {
  padding: 0.375rem 0.5rem 0.25rem;
  color: var(--muted-foreground);
  font-size: 0.6875rem;
  font-weight: 600;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

#arcane-root.arcane-theme-neon .sidebar-tree {
  padding-left: 0.75rem;
  margin-left: 0.25rem;
  gap: 0.25rem;
  /* Space the first child away from the parent summary at every nesting level
     (deeper subfolders otherwise rendered flush against their header). */
  margin-top: 0.25rem;
}

#arcane-root.arcane-theme-neon .kb-topbar-github,
#arcane-root.arcane-theme-neon .kb-theme-toggle,
#arcane-root.arcane-theme-neon .kb-stylesheet-select,
#arcane-root.arcane-theme-neon .kb-palette-select,
#arcane-root.arcane-theme-neon .kb-hamburger {
  height: 2.125rem;
  border: 1px solid var(--border);
  background: var(--background);
  border-radius: var(--radius);
  box-shadow: none;
}

#arcane-root.arcane-theme-neon .kb-topbar-github,
#arcane-root.arcane-theme-neon .kb-theme-toggle,
#arcane-root.arcane-theme-neon .kb-hamburger {
  width: 2.125rem;
}

#arcane-root.arcane-theme-neon .kb-topbar .kb-hamburger {
  display: none !important;
}

@media (max-width: 900px) {
  #arcane-root.arcane-theme-neon .kb-topbar .kb-hamburger {
    display: inline-flex !important;
  }
}

#arcane-root.arcane-theme-neon .kb-topbar-github:hover,
#arcane-root.arcane-theme-neon .kb-theme-toggle:hover,
#arcane-root.arcane-theme-neon .kb-stylesheet-select:hover,
#arcane-root.arcane-theme-neon .kb-palette-select:hover,
#arcane-root.arcane-theme-neon .kb-hamburger:hover {
  background: rgba(var(--primary-rgb), 0.12);
  border-color: var(--border);
}

#arcane-root.arcane-theme-neon .kb-search-input,
#arcane-root.arcane-theme-neon .sidebar-search input {
  height: 2.125rem;
  border-color: var(--border);
  background: var(--background);
  border-radius: var(--radius);
}

#arcane-root.arcane-theme-neon .kb-search-input:focus,
#arcane-root.arcane-theme-neon .sidebar-search input:focus {
  border-color: var(--primary);
  background: var(--background);
  outline: 2px solid var(--primary);
  outline-offset: 1px;
}

#arcane-root.arcane-theme-neon .search-results {
  border-color: var(--border);
  border-radius: var(--radius-md);
  box-shadow: var(--neon-overlay-shadow);
}

#arcane-root.arcane-theme-neon .sidebar-tabs {
  background: var(--secondary);
  border-radius: var(--radius);
}

#arcane-root.arcane-theme-neon .sidebar-tab {
  border-radius: calc(var(--radius) - 2px);
}

#arcane-root.arcane-theme-neon .sidebar-tab.active {
  box-shadow: none;
}

#arcane-root.arcane-theme-neon .sidebar-summary,
#arcane-root.arcane-theme-neon .sidebar-link {
  border-radius: calc(var(--radius) - 2px);
  color: color-mix(in srgb, var(--foreground) 78%, var(--muted-foreground));
  outline: 1px solid transparent;
  outline-offset: -1px;
}

#arcane-root.arcane-theme-neon .sidebar-summary:hover,
#arcane-root.arcane-theme-neon .sidebar-details[open] > .sidebar-summary,
#arcane-root.arcane-theme-neon .sidebar-link:hover {
  background: rgba(var(--primary-rgb), 0.12);
  color: var(--foreground);
  outline-color: var(--border);
}

#arcane-root.arcane-theme-neon .sidebar-link.active {
  background: rgba(var(--primary-rgb), 0.12);
  color: var(--neon-accent-ink);
  outline-color: var(--border);
  box-shadow: none;
}

#arcane-root.arcane-theme-neon .sidebar-tree > .sidebar-section::before,
#arcane-root.arcane-theme-neon .sidebar-tree > .sidebar-section::after,
#arcane-root.arcane-theme-neon .sidebar-tree-item::before,
#arcane-root.arcane-theme-neon .sidebar-tree-item::after,
#arcane-root.arcane-theme-neon .sidebar-tree-item:not(:last-child)::after {
  content: none !important;
  display: none !important;
  background: transparent !important;
}

#arcane-root.arcane-theme-neon .toc-content > ul > li::before,
#arcane-root.arcane-theme-neon .toc-content > ul > li::after,
#arcane-root.arcane-theme-neon .toc-content ul ul li::before,
#arcane-root.arcane-theme-neon .toc-content ul ul li::after {
  background: var(--border) !important;
}

#arcane-root.arcane-theme-neon .kb-toc-panel .toc {
  padding: 0.125rem 0 0;
  border: 0 !important;
  border-radius: 0 !important;
  background: transparent !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neon .kb-toc-panel .toc-title {
  border-bottom: 0 !important;
  padding-bottom: 0.125rem;
  margin-bottom: 0.5rem;
}

#arcane-root.arcane-theme-neon .toc-content a {
  border-radius: calc(var(--radius) - 2px);
  background: transparent;
}

#arcane-root.arcane-theme-neon .toc-content a:hover,
#arcane-root.arcane-theme-neon .toc-content a.toc-active {
  background: rgba(var(--primary-rgb), 0.12);
}

#arcane-root.arcane-theme-neon .kb-main-area {
  min-width: 0 !important;
  width: 100% !important;
  overflow: visible !important;
}

#arcane-root.arcane-theme-neon .kb-content-area {
  display: grid !important;
  grid-template-columns: minmax(0, 1fr) !important;
  align-items: start !important;
  width: 100% !important;
  max-width: var(--container-2xl, 90rem) !important;
  margin: 0 auto !important;
  gap: clamp(1.75rem, 3vw, 3rem) !important;
  padding: clamp(1.75rem, 3vw, 3rem) clamp(1.5rem, 4vw, 3.5rem) !important;
}

@media (min-width: 1201px) {
  #arcane-root.arcane-theme-neon .kb-content-area:has(.kb-toc-panel) {
    grid-template-columns: minmax(0, 1fr) minmax(12rem, 17rem) !important;
  }
}

#arcane-root.arcane-theme-neon .kb-article-panel {
  min-width: 0 !important;
  width: 100% !important;
  max-width: 68rem !important;
  margin-left: auto !important;
  margin-right: auto !important;
}

#arcane-root.arcane-theme-neon .kb-page-metadata,
#arcane-root.arcane-theme-neon .kb-tags-footer {
  border-color: var(--border) !important;
}

#arcane-root.arcane-theme-neon .arcane-demo-preview-scope,
#arcane-root.arcane-theme-neon .arcane-demo-code {
  border-color: var(--border) !important;
  border-radius: 0;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neon .arcane-demo-panel {
  padding: 0 !important;
  border: 0 !important;
  border-radius: 0 !important;
  background: transparent !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neon .arcane-demo-kicker,
#arcane-root.arcane-theme-neon .arcane-demo-code-label {
  color: var(--muted-foreground) !important;
}

#arcane-root.arcane-theme-neon .arcane-demo-section-title {
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neon .arcane-demo-preview-scope {
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
  border-width: 1px !important;
  background: var(--card) !important;
}

#arcane-root.arcane-theme-neon .arcane-demo-preview-scope > .arcane-box {
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
}

#arcane-root.arcane-theme-neon .arcane-demo-missing {
  border: 1px solid var(--border) !important;
  border-radius: var(--radius-md) !important;
  background: var(--background) !important;
  color: var(--foreground) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neon .arcane-demo-missing-icon {
  border: 1px solid color-mix(in srgb, var(--warning) 42%, var(--border)) !important;
  border-radius: var(--radius-sm) !important;
  background: color-mix(in srgb, var(--warning) 16%, var(--background)) !important;
  color: color-mix(in srgb, var(--warning) 74%, var(--foreground)) !important;
}

#arcane-root.arcane-theme-neon .arcane-demo-missing-title {
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neon .arcane-demo-missing-body {
  color: var(--muted-foreground) !important;
}

@media (max-width: 900px) {
  #arcane-root.arcane-theme-neon .arcane-scaffold-sidebar.arcane-scaffold-sidebar {
    position: static !important;
    top: auto !important;
    height: auto !important;
    max-height: none !important;
    min-height: 0 !important;
    overflow: visible !important;
  }
}

#arcane-root.arcane-theme-neon .kb-topbar::before,
#arcane-root.arcane-theme-neon .kb-topbar::after {
  content: none !important;
  display: none !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neon .kb-toc-panel {
  position: sticky !important;
  top: 5rem !important;
  align-self: flex-start !important;
  width: 100% !important;
  max-height: none !important;
  overflow: visible !important;
}

@media (max-width: 1200px) {
  #arcane-root.arcane-theme-neon .kb-content-area {
    grid-template-columns: minmax(0, 1fr) !important;
  }

  #arcane-root.arcane-theme-neon .kb-toc-panel {
    display: none !important;
  }
}

@media (max-width: 900px) {
  #arcane-root.arcane-theme-neon .arcane-scaffold-body {
    grid-template-columns: minmax(0, 1fr) !important;
  }

  #arcane-root.arcane-theme-neon .arcane-scaffold-sidebar.arcane-scaffold-sidebar {
    position: static !important;
    width: auto !important;
  }

  #arcane-root.arcane-theme-neon .kb-content-area {
    padding: 1.25rem !important;
  }
}

#arcane-root.arcane-theme-neon .kb-landing-hero {
  background: var(--background);
}

#arcane-root.arcane-theme-neon .kb-landing-prose {
  display: grid;
  gap: clamp(1.5rem, 2.4vw, 2.4rem);
}

#arcane-root.arcane-theme-neon .kb-landing-prose > * + * {
  margin-top: 0;
}

#arcane-root.arcane-theme-neon .kb-landing-grid {
  gap: clamp(1.25rem, 2vw, 1.8rem);
  margin-top: 1.25rem;
  margin-bottom: 1.5rem;
}

#arcane-root.arcane-theme-neon .kb-landing-band {
  gap: clamp(1.45rem, 2.4vw, 2.2rem);
  margin-top: 1.25rem;
  padding: clamp(1.5rem, 2.4vw, 2.25rem);
}

#arcane-root.arcane-theme-neon .kb-landing-terminal-body,
#arcane-root.arcane-theme-neon .kb-landing-list {
  gap: 1rem;
}

#arcane-root.arcane-theme-neon .kb-landing-card:hover {
  border-color: var(--primary);
}

/* ---------- Shared docs / prose / TOC / map (variable-driven) ---------- */

$arcaneAllDocsStyles

$arcaneMapCss

$arcaneTocTreeLinesCss
''';
  }
}
