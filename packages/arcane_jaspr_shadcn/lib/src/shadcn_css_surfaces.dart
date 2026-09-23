/// Overlay and navigation rules for the ShadCN renderer: dialog, sheet,
/// drawer, tooltip, popover, dropdown, context menu, menubar, command,
/// tabs, accordion, toast, pagination, breadcrumbs and sidebar.
///
/// Concatenated into [ShadcnCss.componentCss] after the token block so the
/// rules can rely on every `--shadcn-*` variable.
///
/// Renderers emit their resting look inline. State (hover, focus, open,
/// selection) reaches them through the `var(--x, fallback)` hooks they
/// reference inline, which the rules below flip:
/// - `--shadcn-item-background` / `--shadcn-item-foreground`: context-menu,
///   menubar, command, pagination and tab items, breadcrumb links, the toast
///   dismiss control and the sidebar toggle.
/// - `--arcane-menu-item-background` / `--arcane-menu-item-foreground`:
///   dropdown items (the theme-neutral hooks of the shared dropdown base).
/// - `--shadcn-control-shadow` / `--shadcn-control-border-color`: focus rings
///   and the active tab/page outline.
/// - `--shadcn-dialog-close-opacity`: dialog, sheet and drawer close control.
/// - `--shadcn-breadcrumb-gap`: breadcrumb list spacing.
/// Every hooked element resets its hooks to `initial`, so a hovered or open
/// parent (a submenu trigger, say) never leaks its state into nested items.
const String shadcnSurfacesCss = '''
/* v4 sidebar token family. */
#arcane-root.arcane-theme-shadcn {
  --sidebar: #fafafa;
  --sidebar-foreground: #0a0a0a;
  --sidebar-border: #e5e5e5;
  --sidebar-accent: #f5f5f5;
  --sidebar-accent-foreground: #171717;
}

html.dark #arcane-root.arcane-theme-shadcn,
#arcane-root.dark.arcane-theme-shadcn {
  --sidebar: #171717;
  --sidebar-foreground: #fafafa;
  --sidebar-border: #262626;
  --sidebar-accent: #262626;
  --sidebar-accent-foreground: #fafafa;
}

/* Keyframes the sheet, drawer and toast renderers reference inline. */
@keyframes arcane-slide-left {
  from { transform: translateX(100%); }
  to { transform: translateX(0); }
}

@keyframes arcane-slide-right {
  from { transform: translateX(-100%); }
  to { transform: translateX(0); }
}

@keyframes arcane-slide-up {
  from { transform: translateY(100%); }
  to { transform: translateY(0); }
}

@keyframes arcane-slide-down {
  from { transform: translateY(-100%); }
  to { transform: translateY(0); }
}

@keyframes arcane-toast-enter {
  from { opacity: 0; transform: translateY(1rem); }
  to { opacity: 1; transform: translateY(0); }
}

@keyframes arcane-toast-exit {
  from { opacity: 1; transform: translateY(0); }
  to { opacity: 0; transform: translateY(1rem); }
}

/* State hooks start unset on every hooked element. */
#arcane-root.arcane-theme-shadcn :is(
  .arcane-context-menu-item,
  .arcane-menubar-item,
  .arcane-menubar-trigger,
  .arcane-command-item,
  .arcane-pagination-link,
  .arcane-tab,
  .arcane-tab-bar-item,
  .arcane-breadcrumb-link,
  .arcane-accordion-trigger,
  .arcane-toast-close,
  .arcane-toast-action,
  .arcane-sidebar-toggle,
  .arcane-dialog-close,
  .arcane-sheet-close,
  .arcane-drawer-close
) {
  --shadcn-item-background: initial;
  --shadcn-item-foreground: initial;
  --shadcn-control-shadow: initial;
  --shadcn-control-border-color: initial;
  --shadcn-dialog-close-opacity: initial;
}

/* Dropdown items. Action items carry the hooks inline; checkbox, radio and
   submenu rows take them here, which also keeps checked rows unfilled. Menu
   rows show focus with the accent fill (v4 `focus:bg-accent`), not a ring. */
#arcane-root.arcane-theme-shadcn .arcane-dropdown-item {
  --arcane-menu-item-background: initial;
  --arcane-menu-item-foreground: initial;
  --shadcn-control-shadow: initial;
  background-color: var(--arcane-menu-item-background, transparent);
  color: var(--arcane-menu-item-foreground, inherit);
  box-shadow: none;
  line-height: 1.25rem;
}

#arcane-root.arcane-theme-shadcn .arcane-dropdown-item[data-disabled="true"] {
  --arcane-menu-item-foreground: var(--popover-foreground);
}

#arcane-root.arcane-theme-shadcn
  .arcane-dropdown-item:is(:hover, :focus-visible):not([aria-disabled="true"]):not([data-disabled="true"]),
#arcane-root.arcane-theme-shadcn .arcane-dropdown-item[aria-expanded="true"] {
  --arcane-menu-item-background: var(--accent);
  --arcane-menu-item-foreground: var(--accent-foreground);
}

#arcane-root.arcane-theme-shadcn
  .arcane-dropdown-item[data-variant="destructive"]:is(:hover, :focus-visible):not([aria-disabled="true"]):not([data-disabled="true"]) {
  --arcane-menu-item-background: color-mix(in srgb, var(--destructive) 10%, transparent);
  --arcane-menu-item-foreground: var(--destructive);
}

/* Context menu, menubar and command rows. */
#arcane-root.arcane-theme-shadcn
  .arcane-context-menu-item:is(:hover, :focus-visible):not([aria-disabled="true"]):not([data-disabled="true"]),
#arcane-root.arcane-theme-shadcn .arcane-context-menu-item[aria-expanded="true"],
#arcane-root.arcane-theme-shadcn
  .arcane-menubar-item:is(:hover, :focus-visible):not([aria-disabled="true"]):not([data-disabled="true"]),
#arcane-root.arcane-theme-shadcn .arcane-menubar-item[aria-expanded="true"],
#arcane-root.arcane-theme-shadcn
  .arcane-menubar-trigger:is(:hover, :focus-visible):not([aria-disabled="true"]):not([data-disabled="true"]),
#arcane-root.arcane-theme-shadcn .arcane-menubar-trigger[aria-expanded="true"],
#arcane-root.arcane-theme-shadcn
  .arcane-command-item:is(:hover, :focus-visible):not([aria-disabled="true"]):not([data-disabled="true"]),
#arcane-root.arcane-theme-shadcn .arcane-command-item[data-arcane-state="active"] {
  --shadcn-item-background: var(--accent);
  --shadcn-item-foreground: var(--accent-foreground);
}

#arcane-root.arcane-theme-shadcn
  .arcane-context-menu-item.destructive:is(:hover, :focus-visible):not([aria-disabled="true"]):not([data-disabled="true"]),
#arcane-root.arcane-theme-shadcn
  .arcane-menubar-item[data-variant="destructive"]:is(:hover, :focus-visible):not([aria-disabled="true"]):not([data-disabled="true"]) {
  --shadcn-item-background: color-mix(in srgb, var(--destructive) 10%, transparent);
  --shadcn-item-foreground: var(--destructive);
}

html.dark #arcane-root.arcane-theme-shadcn
  .arcane-dropdown-item[data-variant="destructive"]:is(:hover, :focus-visible):not([aria-disabled="true"]):not([data-disabled="true"]),
#arcane-root.dark.arcane-theme-shadcn
  .arcane-dropdown-item[data-variant="destructive"]:is(:hover, :focus-visible):not([aria-disabled="true"]):not([data-disabled="true"]) {
  --arcane-menu-item-background: color-mix(in srgb, var(--destructive) 20%, transparent);
}

html.dark #arcane-root.arcane-theme-shadcn
  :is(.arcane-context-menu-item.destructive, .arcane-menubar-item[data-variant="destructive"]):is(:hover, :focus-visible):not([aria-disabled="true"]):not([data-disabled="true"]),
#arcane-root.dark.arcane-theme-shadcn
  :is(.arcane-context-menu-item.destructive, .arcane-menubar-item[data-variant="destructive"]):is(:hover, :focus-visible):not([aria-disabled="true"]):not([data-disabled="true"]) {
  --shadcn-item-background: color-mix(in srgb, var(--destructive) 20%, transparent);
}

/* Menubar submenus open on hover, keyboard focus or aria-expanded. */
#arcane-root.arcane-theme-shadcn .arcane-menubar-submenu {
  display: none;
}

#arcane-root.arcane-theme-shadcn
  .arcane-menubar-item.submenu-trigger:is(:hover, :focus-within, [aria-expanded="true"]) > .arcane-menubar-submenu {
  display: block;
}

#arcane-root.arcane-theme-shadcn .arcane-command-input::placeholder {
  color: var(--muted-foreground);
}

/* Tabs: v4 triggers read foreground in light and muted-foreground in dark;
   the active trigger lifts onto the background with shadow-xs. */
#arcane-root.arcane-theme-shadcn
  :is(.arcane-tab, .arcane-tab-bar-item):is([aria-selected="true"], [data-state="active"]) {
  --shadcn-item-background: var(--background);
  --shadcn-item-foreground: var(--foreground);
  --shadcn-control-shadow: var(--shadow-xs);
}

html.dark #arcane-root.arcane-theme-shadcn :is(.arcane-tab, .arcane-tab-bar-item),
#arcane-root.dark.arcane-theme-shadcn :is(.arcane-tab, .arcane-tab-bar-item) {
  --shadcn-item-foreground: var(--muted-foreground);
}

html.dark #arcane-root.arcane-theme-shadcn
  :is(.arcane-tab, .arcane-tab-bar-item):is([aria-selected="true"], [data-state="active"]),
#arcane-root.dark.arcane-theme-shadcn
  :is(.arcane-tab, .arcane-tab-bar-item):is([aria-selected="true"], [data-state="active"]) {
  --shadcn-item-background: color-mix(in srgb, var(--input) 30%, transparent);
  --shadcn-item-foreground: var(--foreground);
  --shadcn-control-border-color: var(--input);
}

#arcane-root.arcane-theme-shadcn
  :is(.arcane-tab, .arcane-tab-bar-item):hover:not([aria-disabled="true"]):not([data-disabled="true"]) {
  --shadcn-item-foreground: var(--foreground);
}

/* Focus rings: v4 `focus-visible:border-ring focus-visible:ring-[3px]`. */
#arcane-root.arcane-theme-shadcn .arcane-tab:focus-visible:not([aria-disabled="true"]),
#arcane-root.arcane-theme-shadcn .arcane-tab-bar-item:focus-visible:not([aria-disabled="true"]),
#arcane-root.arcane-theme-shadcn .arcane-pagination-link:focus-visible:not([aria-disabled="true"]) {
  outline: none;
  --shadcn-control-shadow: var(--shadcn-focus-ring);
  --shadcn-control-border-color: var(--shadcn-focus-border);
}

#arcane-root.arcane-theme-shadcn
  :is(.arcane-tab, .arcane-tab-bar-item):is([aria-selected="true"], [data-state="active"]):focus-visible,
#arcane-root.arcane-theme-shadcn .arcane-pagination-link[aria-current="page"]:focus-visible {
  --shadcn-control-shadow: var(--shadow-xs), var(--shadcn-focus-ring);
}

#arcane-root.arcane-theme-shadcn :is(
  .arcane-breadcrumb-link,
  .arcane-accordion-trigger,
  .arcane-toast-close,
  .arcane-toast-action,
  .arcane-sidebar-toggle
):focus-visible {
  outline: none;
  --shadcn-control-shadow: var(--shadcn-focus-ring);
}

/* Dialog, sheet and drawer close: v4 `opacity-70 hover:opacity-100`. */
#arcane-root.arcane-theme-shadcn
  :is(.arcane-dialog-close, .arcane-sheet-close, .arcane-drawer-close):hover {
  --shadcn-dialog-close-opacity: 1;
}

#arcane-root.arcane-theme-shadcn
  :is(.arcane-dialog-close, .arcane-sheet-close, .arcane-drawer-close):focus-visible {
  outline: none;
  --shadcn-dialog-close-opacity: 1;
  --shadcn-control-shadow: var(--shadcn-focus-ring);
}

/* Pagination: ghost items take the accent on hover. */
#arcane-root.arcane-theme-shadcn
  .arcane-pagination-link:hover:not([aria-disabled="true"]):not([data-disabled="true"]) {
  --shadcn-item-background: var(--accent);
  --shadcn-item-foreground: var(--accent-foreground);
}

/* Breadcrumbs: v4 `gap-1.5 sm:gap-2.5`, `size-3.5` separators, links shift
   to the foreground on hover. */
@media (min-width: 640px) {
  #arcane-root.arcane-theme-shadcn .arcane-breadcrumb-list {
    --shadcn-breadcrumb-gap: 0.625rem;
  }
}

#arcane-root.arcane-theme-shadcn .arcane-breadcrumb-separator > i {
  width: 0.875rem !important;
  height: 0.875rem !important;
  font-size: 0.875rem !important;
}

#arcane-root.arcane-theme-shadcn .arcane-breadcrumb-link:hover {
  --shadcn-item-foreground: var(--foreground);
}

/* Accordion and disclosure: native markers off, underline on hover, the
   Lucide chevron turns when the row opens. */
#arcane-root.arcane-theme-shadcn .arcane-accordion-trigger::-webkit-details-marker,
#arcane-root.arcane-theme-shadcn .arcane-disclosure-summary::-webkit-details-marker {
  display: none;
}

#arcane-root.arcane-theme-shadcn .arcane-accordion-trigger:hover .arcane-accordion-title {
  text-decoration: underline;
}

#arcane-root.arcane-theme-shadcn
  .arcane-accordion-item[open] > .arcane-accordion-trigger .arcane-accordion-chevron,
#arcane-root.arcane-theme-shadcn
  .arcane-disclosure[open] > .arcane-disclosure-summary .arcane-disclosure-chevron {
  transform: rotate(180deg);
}

/* The disclosure frame clips overflow, so its ring sits inside the summary. */
#arcane-root.arcane-theme-shadcn .arcane-disclosure-summary:focus-visible {
  outline: 3px solid color-mix(in oklab, var(--ring) 50%, transparent);
  outline-offset: -3px;
}

/* Toast dismiss and action controls. */
#arcane-root.arcane-theme-shadcn .arcane-toast-close:hover {
  --shadcn-item-background: var(--accent);
  --shadcn-item-foreground: var(--accent-foreground);
}

#arcane-root.arcane-theme-shadcn .arcane-toast-action:hover {
  opacity: 0.9;
}

/* Runtime toasts (ARCANE.toast.show) mount outside #arcane-root and carry no
   inline styles, so the Sonner surface is applied here in full. */
html:has(#arcane-root.arcane-theme-shadcn) [data-arcane-toast-surface] {
  z-index: 1200;
}

html:has(#arcane-root.arcane-theme-shadcn) [data-arcane-toast-surface] .arcane-toast {
  position: relative;
  display: flex;
  flex-direction: column;
  gap: 0.125rem;
  box-sizing: border-box;
  width: 356px;
  max-width: calc(100vw - 2rem);
  padding: 1rem 2.75rem 1rem 1rem;
  border: 1px solid var(--border);
  border-radius: var(--radius-md);
  background: var(--popover);
  color: var(--popover-foreground);
  box-shadow: var(--shadow-lg);
  font-size: 0.8125rem;
  line-height: 1.5;
  opacity: 0;
  transform: translateY(1rem);
  transition: opacity 200ms ease, transform 200ms ease;
}

html:has(#arcane-root.arcane-theme-shadcn) [data-arcane-toast-surface] .arcane-toast.arcane-toast-shown {
  opacity: 1;
  transform: translateY(0);
}

html:has(#arcane-root.arcane-theme-shadcn) [data-arcane-toast-surface] .arcane-toast-title {
  font-weight: 500;
}

html:has(#arcane-root.arcane-theme-shadcn)
  [data-arcane-toast-surface] .arcane-toast-title + .arcane-toast-message {
  color: var(--muted-foreground);
}

html:has(#arcane-root.arcane-theme-shadcn) [data-arcane-toast-surface] .arcane-toast-close {
  position: absolute;
  top: 1rem;
  right: 1rem;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 20px;
  height: 20px;
  padding: 0;
  border: 1px solid var(--border);
  border-radius: var(--radius-sm);
  background: var(--popover);
  color: var(--popover-foreground);
  font: inherit;
  line-height: 1;
  cursor: pointer;
}

html:has(#arcane-root.arcane-theme-shadcn) [data-arcane-toast-surface] .arcane-toast-close:hover {
  background: var(--accent);
  color: var(--accent-foreground);
}

html:has(#arcane-root.arcane-theme-shadcn) [data-arcane-toast-surface] .arcane-toast-close:focus-visible {
  outline: none;
  box-shadow: var(--shadcn-focus-ring, 0 0 0 3px color-mix(in oklab, var(--ring) 50%, transparent));
}

/* Sidebar. The shared sidebar bases emit links, section headers and submenu
   summaries without inline styles; v4 SidebarMenuButton is `h-8 rounded-md
   px-2 text-sm` with a `--sidebar-accent` hover and active fill. Background
   is !important to clear the core `aside a:hover` rule. */
#arcane-root.arcane-theme-shadcn .arcane-sidebar > .sidebar-header {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  margin: 0;
  padding: 0.5rem;
  border: 0;
  border-bottom: 1px solid var(--sidebar-border);
  border-radius: 0;
  background: transparent;
  box-shadow: none;
}

#arcane-root.arcane-theme-shadcn .arcane-sidebar > .sidebar-nav {
  padding: 0.5rem !important;
  gap: 0.5rem !important;
}

#arcane-root.arcane-theme-shadcn .arcane-sidebar .sidebar-section {
  margin: 0;
}

#arcane-root.arcane-theme-shadcn .arcane-sidebar .sidebar-tree {
  gap: 0.25rem;
}

#arcane-root.arcane-theme-shadcn .arcane-sidebar .sidebar-section-header {
  display: flex;
  align-items: center;
  height: 2rem;
  padding: 0 0.5rem;
  color: color-mix(in srgb, var(--sidebar-foreground) 70%, transparent);
  font-size: 0.75rem;
  font-weight: 500;
  letter-spacing: normal;
  text-transform: none;
}

#arcane-root.arcane-theme-shadcn .arcane-sidebar .sidebar-tree-item > .sidebar-link,
#arcane-root.arcane-theme-shadcn .arcane-sidebar .sidebar-section > .sidebar-details > .sidebar-summary {
  --shadcn-item-background: initial;
  --shadcn-item-foreground: initial;
  --shadcn-control-shadow: initial;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  box-sizing: border-box;
  width: 100%;
  height: 2rem;
  padding: 0 0.5rem;
  border: 0;
  border-radius: var(--radius-sm);
  outline: none;
  background: var(--shadcn-item-background, transparent) !important;
  color: var(--shadcn-item-foreground, var(--sidebar-foreground));
  box-shadow: var(--shadcn-control-shadow, none);
  font: inherit;
  font-size: 0.875rem;
  font-weight: 400;
  line-height: 1.25rem;
  letter-spacing: normal;
  text-align: left;
  text-decoration: none;
  text-transform: none;
  opacity: 1;
  cursor: pointer;
}

#arcane-root.arcane-theme-shadcn .arcane-sidebar .sidebar-tree-item > .sidebar-link:hover,
#arcane-root.arcane-theme-shadcn .arcane-sidebar .sidebar-tree-item > .sidebar-link.active,
#arcane-root.arcane-theme-shadcn .arcane-sidebar .sidebar-section > .sidebar-details > .sidebar-summary:hover,
#arcane-root.arcane-theme-shadcn .arcane-sidebar .arcane-sidebar-toggle:hover {
  --shadcn-item-background: var(--sidebar-accent);
  --shadcn-item-foreground: var(--sidebar-accent-foreground);
}

#arcane-root.arcane-theme-shadcn .arcane-sidebar .sidebar-tree-item > .sidebar-link.active {
  font-weight: 500;
}

#arcane-root.arcane-theme-shadcn .arcane-sidebar .sidebar-tree-item > .sidebar-link:focus-visible,
#arcane-root.arcane-theme-shadcn .arcane-sidebar .sidebar-section > .sidebar-details > .sidebar-summary:focus-visible {
  --shadcn-control-shadow: var(--shadcn-focus-ring);
}

@media (prefers-reduced-motion: reduce) {
  #arcane-root.arcane-theme-shadcn :is(
    .arcane-dialog-overlay,
    .arcane-dialog,
    .arcane-sheet-backdrop,
    .arcane-sheet-panel,
    .arcane-drawer-backdrop,
    .arcane-drawer,
    .arcane-command-overlay,
    .arcane-command-dialog,
    .arcane-toast
  ) {
    animation: none !important;
  }

  #arcane-root.arcane-theme-shadcn :is(.arcane-accordion-chevron, .arcane-disclosure-chevron) {
    transition: none !important;
  }
}
''';
