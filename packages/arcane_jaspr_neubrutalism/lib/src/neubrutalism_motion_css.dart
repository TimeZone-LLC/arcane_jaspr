/// State-driven print motion shared by Classic and NeuComic.
class NeubrutalismMotionCss {
  const NeubrutalismMotionCss._();

  static const String styles = r'''
#arcane-root.arcane-theme-neubrutalism {
  --nb-motion-fast: 110ms;
  --nb-motion-state: 160ms;
  --nb-motion-enter: 180ms;
  --nb-motion-ease: cubic-bezier(.2, .75, .25, 1);
  --nb-motion-settle: cubic-bezier(.2, .8, .3, 1);
  --nb-motion-distance: 6px;
  --nb-motion-pop: 1.01;
  --nb-motion-mark: 1.06;
  --nb-transition: var(--nb-motion-state) var(--nb-motion-ease);
  --nb-transition-fast: var(--nb-motion-fast) var(--nb-motion-ease);
}

#arcane-root.arcane-theme-neubrutalism.neucomic {
  --nb-motion-state: 180ms;
  --nb-motion-enter: 220ms;
  --nb-motion-settle: cubic-bezier(.18, .85, .3, 1);
  --nb-motion-distance: 9px;
  --nb-motion-pop: 1.025;
  --nb-motion-mark: 1.12;
}

/* Native controls retain their positioning transforms and instance styles. */
#arcane-root.arcane-theme-neubrutalism :is(
  .neubrutalism-button, .neubrutalism-cycle-button,
  .neubrutalism-dropdown-trigger, .neubrutalism-dropdown-item,
  .neubrutalism-context-menu-item, .neubrutalism-menubar-trigger,
  .neubrutalism-menubar-item, .neubrutalism-select-option,
  .neubrutalism-time-picker-option,
  .neubrutalism-command-item, .neubrutalism-tab,
  .neubrutalism-tabs-trigger, .neubrutalism-tab-bar-item,
  .neubrutalism-toggle-group-item, .neubrutalism-radio-button,
  .neubrutalism-radio-card, .neubrutalism-pagination-link,
  .neubrutalism-sidebar-link, .neubrutalism-sidebar-collapse,
  .neubrutalism-breadcrumb-link, .neubrutalism-toast-action,
  .neubrutalism-toast-dismiss, .neubrutalism-dialog-close,
  .neubrutalism-sheet-close, .neubrutalism-drawer-close,
  .neubrutalism-calendar-day, .arcane-calendar-nav, .arcane-calendar-today
) {
  transition: transform var(--nb-transition),
    box-shadow var(--nb-transition), background-color var(--nb-transition),
    border-color var(--nb-transition), color var(--nb-transition);
}

#arcane-root.arcane-theme-neubrutalism :is(
  .neubrutalism-text-input, .neubrutalism-textarea,
  .neubrutalism-native-select, .neubrutalism-select,
  .neubrutalism-select-trigger, .neubrutalism-date-picker-trigger,
  .neubrutalism-time-picker-trigger, .neubrutalism-otp-digit,
  .neubrutalism-checkbox, .neubrutalism-toggle-switch,
  .neubrutalism-radio-circle, .neubrutalism-data-table-row,
  .neubrutalism-static-table-row, .neubrutalism-item.clickable
) {
  transition: transform var(--nb-transition),
    box-shadow var(--nb-transition), background-color var(--nb-transition),
    border-color var(--nb-transition), color var(--nb-transition);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-toggle-switch-thumb {
  transition: transform var(--nb-motion-state) var(--nb-motion-settle);
}

#arcane-root.arcane-theme-neubrutalism :is(
  .neubrutalism-disclosure-chevron, .neubrutalism-accordion .faq-chevron,
  .neubrutalism-select-chevron
) {
  transition: transform var(--nb-motion-state) var(--nb-motion-settle);
}

#arcane-root.arcane-theme-neubrutalism :is(
  .neubrutalism-card.clickable, a.neubrutalism-gallery-tile,
  .neubrutalism-gallery-tile[data-arcane-draggable-item="true"],
  a.neubrutalism-feature-card, a.neubrutalism-icon-card
):not([data-arcane-decorated]) {
  transition: transform var(--nb-transition), box-shadow var(--nb-transition);
}

/* Closing surfaces stop accepting input immediately; the runtime still owns
   hidden, focus restoration, and its transition-end completion. */
#arcane-root.arcane-theme-neubrutalism [data-arcane-surface][data-arcane-state="closed"],
#arcane-root.arcane-theme-neubrutalism [data-arcane-surface][data-arcane-state="closed"] * {
  pointer-events: none !important;
}

@media (prefers-reduced-motion: no-preference) {
  #arcane-root.arcane-theme-neubrutalism :is(
    .neubrutalism-button, .neubrutalism-cycle-button,
    .neubrutalism-toggle-group-item, .neubrutalism-radio-button,
    .neubrutalism-tabs-trigger, .neubrutalism-tab-bar-item,
    .neubrutalism-pagination-link, .neubrutalism-toast-action,
    .neubrutalism-dialog-close, .neubrutalism-sheet-close,
    .neubrutalism-drawer-close
  ):not(:disabled, [aria-disabled="true"], [data-disabled="true"],
    [data-arcane-decorated]):active {
    animation: nb-press var(--nb-motion-fast) var(--nb-motion-ease);
  }

  #arcane-root.arcane-theme-neubrutalism :is(
    .neubrutalism-checkbox[data-state="checked"],
    .neubrutalism-checkbox[data-state="indeterminate"],
    .neubrutalism-radio-option[data-state="checked"]:not([data-disabled="true"]) .neubrutalism-radio-dot,
    .neubrutalism-toggle-group-item[data-state="on"],
    .neubrutalism-radio-button[data-state="checked"],
    .neubrutalism-tabs-trigger[data-state="active"],
    .neubrutalism-tab-bar-item[data-state="active"],
    .neubrutalism-calendar-day[data-selected="true"]
  ):not([aria-disabled="true"], [data-disabled="true"],
    [data-arcane-decorated]) {
    animation: nb-mark-settle var(--nb-motion-enter) var(--nb-motion-settle);
  }

  #arcane-root.arcane-theme-neubrutalism .neubrutalism-slider-thumb:not(
    [data-disabled="true"], [data-state="disabled"]
  ):is(:focus-visible, :active) {
    animation: nb-mark-settle var(--nb-motion-enter) var(--nb-motion-settle);
  }

  #arcane-root.arcane-theme-neubrutalism .neubrutalism-disclosure[open] > .neubrutalism-disclosure-content,
  #arcane-root.arcane-theme-neubrutalism .neubrutalism-accordion > details[open] > div,
  #arcane-root.arcane-theme-neubrutalism .neubrutalism-tabs-content,
  #arcane-root.arcane-theme-neubrutalism [data-arcane-tab-panel][data-arcane-state="active"]:not([hidden]) {
    animation: nb-content-enter var(--nb-motion-enter) var(--nb-motion-ease);
  }

  #arcane-root.arcane-theme-neubrutalism :is(
    .neubrutalism-floating-content, .neubrutalism-popover,
    .neubrutalism-tooltip, .neubrutalism-dropdown-menu,
    .neubrutalism-dropdown-submenu, .neubrutalism-context-menu,
    .neubrutalism-menubar-content, .neubrutalism-select-content,
    .neubrutalism-date-picker-dropdown, .neubrutalism-time-picker-dropdown
  ) {
    --nb-enter-x: 0px;
    --nb-enter-y: calc(-1 * var(--nb-motion-distance));
    transform-origin: center top;
    transition: opacity var(--nb-motion-fast) var(--nb-motion-ease);
  }

  #arcane-root.arcane-theme-neubrutalism [data-arcane-actual-placement="top"] {
    --nb-enter-y: var(--nb-motion-distance);
    transform-origin: center bottom;
  }

  #arcane-root.arcane-theme-neubrutalism [data-arcane-actual-placement="left"] {
    --nb-enter-x: var(--nb-motion-distance);
    --nb-enter-y: 0px;
    transform-origin: right center;
  }

  #arcane-root.arcane-theme-neubrutalism [data-arcane-actual-placement="right"] {
    --nb-enter-x: calc(-1 * var(--nb-motion-distance));
    --nb-enter-y: 0px;
    transform-origin: left center;
  }

  #arcane-root.arcane-theme-neubrutalism :is(
    .neubrutalism-floating-content, .neubrutalism-popover,
    .neubrutalism-tooltip, .neubrutalism-dropdown-menu,
    .neubrutalism-dropdown-submenu, .neubrutalism-context-menu,
    .neubrutalism-menubar-content, .neubrutalism-select-content,
    .neubrutalism-date-picker-dropdown, .neubrutalism-time-picker-dropdown
  ):is([data-arcane-state="open"], [data-state="open"]):not([hidden]) {
    animation: nb-surface-enter var(--nb-motion-enter) var(--nb-motion-settle);
  }

  #arcane-root.arcane-theme-neubrutalism :is(
    .neubrutalism-floating-content, .neubrutalism-popover,
    .neubrutalism-tooltip, .neubrutalism-dropdown-menu,
    .neubrutalism-dropdown-submenu, .neubrutalism-context-menu,
    .neubrutalism-menubar-content, .neubrutalism-select-content,
    .neubrutalism-date-picker-dropdown, .neubrutalism-time-picker-dropdown
  )[data-arcane-state="closed"] {
    opacity: 0;
  }

  #arcane-root.arcane-theme-neubrutalism :is(
    .neubrutalism-dialog-overlay, .neubrutalism-sheet-overlay,
    .neubrutalism-drawer-overlay, .neubrutalism-command-overlay
  )[data-arcane-state] {
    transition: opacity var(--nb-motion-state) var(--nb-motion-ease);
  }

  #arcane-root.arcane-theme-neubrutalism :is(
    .neubrutalism-dialog-overlay, .neubrutalism-sheet-overlay,
    .neubrutalism-drawer-overlay, .neubrutalism-command-overlay
  )[data-arcane-state="open"] {
    animation: nb-scrim-enter var(--nb-motion-state) var(--nb-motion-ease);
  }

  #arcane-root.arcane-theme-neubrutalism :is(
    .neubrutalism-dialog-overlay, .neubrutalism-sheet-overlay,
    .neubrutalism-drawer-overlay, .neubrutalism-command-overlay
  )[data-arcane-state="closed"] {
    opacity: 0;
  }

  #arcane-root.arcane-theme-neubrutalism [data-arcane-state="open"] > :is(
    .neubrutalism-dialog, .neubrutalism-confirm-dialog,
    .neubrutalism-alert-dialog, .neubrutalism-command-dialog
  ) {
    --nb-enter-x: 0px;
    --nb-enter-y: var(--nb-motion-distance);
    animation: nb-surface-enter var(--nb-motion-enter) var(--nb-motion-settle);
  }

  #arcane-root.arcane-theme-neubrutalism :is(
    .neubrutalism-sheet-overlay, .neubrutalism-drawer-overlay
  ) {
    --nb-enter-x: 0px;
    --nb-enter-y: 18px;
  }

  #arcane-root.arcane-theme-neubrutalism :is(
    .neubrutalism-sheet-overlay, .neubrutalism-drawer-overlay
  )[data-position="top"] { --nb-enter-y: -18px; }

  #arcane-root.arcane-theme-neubrutalism :is(
    .neubrutalism-sheet-overlay, .neubrutalism-drawer-overlay
  )[data-position="left"] { --nb-enter-x: -18px; --nb-enter-y: 0px; }

  #arcane-root.arcane-theme-neubrutalism :is(
    .neubrutalism-sheet-overlay, .neubrutalism-drawer-overlay
  )[data-position="right"] { --nb-enter-x: 18px; --nb-enter-y: 0px; }

  #arcane-root.arcane-theme-neubrutalism [data-arcane-state="open"] > :is(
    .neubrutalism-sheet, .neubrutalism-drawer
  ) {
    animation: nb-panel-enter var(--nb-motion-enter) var(--nb-motion-ease);
  }

  #arcane-root.arcane-theme-neubrutalism .neubrutalism-toast:not(
    .exiting, [data-arcane-decorated]
  ) {
    --nb-enter-x: 0px;
    --nb-enter-y: var(--nb-motion-distance);
    animation: nb-surface-enter var(--nb-motion-enter) var(--nb-motion-settle);
  }

  #arcane-root.arcane-theme-neubrutalism .neubrutalism-toast.exiting {
    pointer-events: none;
  }

  #arcane-root.arcane-theme-neubrutalism .neubrutalism-slot-counter[data-fixed="true"] .neubrutalism-slot-counter-value {
    animation: nb-mark-settle var(--nb-motion-enter) var(--nb-motion-settle);
  }

  #arcane-root.arcane-theme-neubrutalism [data-error="true"]:not([data-arcane-decorated]) {
    animation: nb-error-settle var(--nb-motion-enter) ease-in-out;
  }

  /* The old skeleton reset is !important. Only opt-in, uncustomized loading
     placeholders override it; animate:false and explicit animations stay still. */
  #arcane-root.arcane-theme-neubrutalism .neubrutalism-skeleton.animate:not([style*="animation"]) {
    animation: nb-loading-ink 1400ms ease-in-out infinite !important;
  }

  #arcane-root.arcane-theme-neubrutalism .neubrutalism-progress-fill:not(.indeterminate) {
    transition: width 240ms var(--nb-motion-ease);
  }

  @media (hover: hover) {
    #arcane-root.arcane-theme-neubrutalism :is(
      a.neubrutalism-gallery-tile, a.neubrutalism-feature-card,
      a.neubrutalism-icon-card
    ):not([data-arcane-decorated], .is-arcane-gallery-dragging):hover {
      transform: translate(-2px, -2px);
      box-shadow: var(--nb-shadow-lg);
    }
  }

  #arcane-root.arcane-theme-neubrutalism :is(
    a.neubrutalism-gallery-tile, a.neubrutalism-feature-card,
    a.neubrutalism-icon-card
  ):not([data-arcane-decorated], .is-arcane-gallery-dragging):focus-visible {
    transform: translate(-2px, -2px);
    box-shadow: var(--nb-shadow-lg);
  }

  #arcane-root.arcane-theme-neubrutalism :is(
    a.neubrutalism-gallery-tile, a.neubrutalism-feature-card,
    a.neubrutalism-icon-card
  ):not([data-arcane-decorated], .is-arcane-gallery-dragging):active {
    transform: translate(2px, 2px);
    box-shadow: var(--nb-shadow-xs);
  }

  #arcane-root.arcane-theme-neubrutalism .neubrutalism-gallery-tile.is-arcane-gallery-dragging {
    transition: box-shadow var(--nb-transition-fast);
    box-shadow: var(--nb-shadow-lg);
  }
}

@keyframes nb-press {
  from { scale: .97; }
  to { scale: 1; }
}

@keyframes nb-mark-settle {
  0% { scale: .9; }
  65% { scale: var(--nb-motion-mark); }
  100% { scale: 1; }
}

@keyframes nb-content-enter {
  from { opacity: .35; translate: 0 4px; }
  to { opacity: 1; translate: 0 0; }
}

/* Individual transforms compose with centered dialogs, anchored popovers,
   and caller-authored transform values instead of replacing them. */
@keyframes nb-surface-enter {
  0% { opacity: 0; translate: var(--nb-enter-x, 0px) var(--nb-enter-y, 6px); scale: .96; }
  70% { opacity: 1; translate: 0 0; scale: var(--nb-motion-pop); }
  100% { opacity: 1; translate: 0 0; scale: 1; }
}

@keyframes nb-panel-enter {
  from { opacity: .4; translate: var(--nb-enter-x) var(--nb-enter-y); }
  to { opacity: 1; translate: 0 0; }
}

@keyframes nb-scrim-enter {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes nb-error-settle {
  0%, 100% { translate: 0 0; }
  33% { translate: -2px 0; }
  66% { translate: 2px 0; }
}

@keyframes nb-loading-ink {
  0%, 100% { opacity: .55; }
  50% { opacity: .85; }
}

@keyframes neubrutalism-progress-indeterminate {
  0% { transform: translateX(-110%); }
  100% { transform: translateX(260%); }
}

@media (prefers-reduced-motion: reduce) {
  #arcane-root.arcane-theme-neubrutalism,
  #arcane-root.arcane-theme-neubrutalism.neucomic {
    --nb-motion-fast: 0ms;
    --nb-motion-state: 0ms;
    --nb-motion-enter: 0ms;
  }

  html #arcane-root.arcane-theme-neubrutalism,
  html #arcane-root.arcane-theme-neubrutalism *,
  html #arcane-root.arcane-theme-neubrutalism *::before,
  html #arcane-root.arcane-theme-neubrutalism *::after,
  html #arcane-root.arcane-theme-neubrutalism .arcane-scaffold-sidebar,
  html #arcane-root.arcane-theme-neubrutalism .kb-layout-body > .kb-sidebar {
    animation: none !important;
    transition: none !important;
    scroll-behavior: auto !important;
  }
}
''';
}
