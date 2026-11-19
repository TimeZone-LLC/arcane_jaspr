/// Sidebar tree-line navigation styles.
///
/// Provides visual tree connectors for hierarchical navigation.
/// Uses proper ::before for horizontal branches and ::after for vertical lines
/// with correct last-child handling for the L-bend effect.
const String arcaneSidebarTreeStyles = '''
/* ============================================
   SIDEBAR HEADER & BRAND - ShadCN Style (Default)
   Clean, minimal design with clear hierarchy
   ============================================ */
.sidebar-header {
  padding: 1rem;
  border-bottom: 1px solid var(--border);
  display: flex;
  flex-direction: column;
  gap: 0.875rem;
}

.sidebar-brand {
  padding-bottom: 0;
}

.sidebar-brand-link {
  text-decoration: none;
}

.sidebar-brand-title {
  font-weight: 700;
  font-size: 1.0625rem;
  color: var(--foreground);
  letter-spacing: -0.01em;
  line-height: 1.2;
}

.sidebar-brand-subtitle {
  font-size: 0.6875rem;
  color: var(--muted-foreground);
  margin-top: 0.125rem;
  letter-spacing: 0.02em;
}

/* Navigation tabs */
.sidebar-tabs {
  display: flex;
  gap: 0.25rem;
  padding: 0.25rem;
  background: var(--muted);
  border-radius: var(--radius);
}

.sidebar-tab {
  flex: 1;
  padding: 0.375rem 0.5rem;
  font-size: 0.75rem;
  font-weight: 500;
  color: var(--muted-foreground);
  text-decoration: none;
  text-align: center;
  border-radius: var(--radius);
  transition: color 0.15s ease, background 0.15s ease;
}

.sidebar-tab:hover {
  color: var(--foreground);
}

.sidebar-tab.active {
  background: var(--background);
  color: var(--foreground);
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.05);
}

/* Search and controls row */
.sidebar-controls {
  display: flex;
  gap: 0.5rem;
  align-items: center;
}

.sidebar-search {
  flex: 1;
  position: relative;
}

.sidebar-search input {
  width: 100%;
  padding: 0.5rem 0.75rem 0.5rem 2rem;
  font-size: 0.8125rem;
  color: var(--foreground);
  background: var(--muted);
  border: 1px solid transparent;
  border-radius: var(--radius);
  outline: none;
  transition: border-color 0.15s ease, background 0.15s ease;
}

.sidebar-search input::placeholder {
  color: var(--muted-foreground);
}

.sidebar-search input:focus {
  border-color: var(--ring);
  background: var(--background);
}

.sidebar-search .search-icon {
  position: absolute;
  left: 0.625rem;
  top: 50%;
  transform: translateY(-50%);
  color: var(--muted-foreground);
  pointer-events: none;
}

/* Theme toggle button */
.sidebar-theme-toggle {
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--muted);
  border: none;
  border-radius: var(--radius);
  color: var(--muted-foreground);
  cursor: pointer;
  transition: color 0.15s ease, background 0.15s ease;
}

.sidebar-theme-toggle:hover {
  color: var(--foreground);
  background: color-mix(in srgb, var(--muted) 150%, transparent);
}

/* Show/hide icons based on theme. Light is the base case: `:not(.dark)`
   would match any ancestor, so it cannot express "outside dark mode". */
.theme-icon-dark { display: block; }
.theme-icon-light { display: none; }
.dark .theme-icon-dark { display: none; }
.dark .theme-icon-light { display: block; }

/* ============================================
   SIDEBAR SECTIONS - ShadCN Visual Styles
   ============================================ */
.sidebar-section-header {
  font-size: 0.75rem;
  font-weight: 600;
  color: var(--muted-foreground);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

/* Folder summaries - ShadCN visual styling */
.sidebar-summary {
  font-size: 0.8125rem;
  font-weight: 600;
  color: var(--foreground);
  background: transparent;
  border: none;
  border-radius: var(--radius);
  transition: all 0.2s ease;
}

.sidebar-summary:hover {
  background: var(--muted);
  color: var(--foreground);
}

/* Expanded folder - ShadCN subtle highlight */
.sidebar-details[open] > .sidebar-summary {
  background: var(--muted);
  color: var(--foreground);
}

.sidebar-details[open] > .sidebar-summary:hover {
  background: color-mix(in srgb, var(--muted) 150%, transparent);
}

/* Chevron visual styling - ShadCN */
.sidebar-chevron {
  opacity: 0.6;
}

.sidebar-summary:hover .sidebar-chevron {
  opacity: 1;
}

.sidebar-details[open] > .sidebar-summary .sidebar-chevron {
  opacity: 1;
}

/* Nested folder styling - decreasing opacity */
.sidebar-tree .sidebar-summary {
  font-size: 0.8125rem;
  color: var(--muted-foreground);
  opacity: 0.9;
}

.sidebar-tree .sidebar-tree .sidebar-summary {
  opacity: 0.85;
}

.sidebar-tree .sidebar-tree .sidebar-tree .sidebar-summary {
  opacity: 0.8;
}

/* Tree connector colors - ShadCN (var(--border)) */
.sidebar-tree > .sidebar-section::before,
.sidebar-tree > .sidebar-section::after {
  background: var(--border);
}

/* ============================================
   SIDEBAR NAVIGATION - Tree Lines
   Supports leaves (links) and folders (disclosures)
   ============================================ */
.sidebar-tree-nav {
  position: relative;
}

.sidebar-tree {
  position: relative;
  display: flex;
  flex-direction: column;
  padding-left: 0.75rem;
  margin-left: 0.5rem;
  margin-top: 0.25rem;
}

.sidebar-tree-items {
  position: relative;
  display: flex;
  flex-direction: column;
  padding-left: 0.75rem;
  margin-left: 0.5rem;
  margin-top: 0.25rem;
}

/* Tree item with horizontal branch and vertical connector */
.sidebar-tree-item {
  position: relative;
}

/* Horizontal branch line */
.sidebar-tree-item::before {
  content: '';
  position: absolute;
  left: -0.75rem;
  top: 50%;
  width: 0.5rem;
  height: 1px;
  background: var(--border);
}

/* Vertical line segment - connects this item to the next (not on last item) */
.sidebar-tree-item:not(:last-child)::after {
  content: '';
  position: absolute;
  left: -0.75rem;
  top: 0;
  bottom: 0;
  width: 1px;
  background: var(--border);
}

/* First item extends vertical line up to connect to parent */
.sidebar-tree-item:first-child::after {
  top: 0;
}

/* Last item only draws vertical line from top to center (L-bend) */
.sidebar-tree-item:last-child::after {
  content: '';
  position: absolute;
  left: -0.75rem;
  top: 0;
  height: 50%;
  width: 1px;
  background: var(--border);
}

/* Single child - hide tree lines, show dot */
.sidebar-tree-items:has(> .sidebar-tree-item:only-child) > .sidebar-tree-item::before,
.sidebar-tree-items:has(> .sidebar-tree-item:only-child) > .sidebar-tree-item::after {
  display: none;
}

/* Nested details within tree - inherits tree styling */
.sidebar-tree .sidebar-details,
.sidebar-tree-items .sidebar-details {
  margin-left: -0.75rem;
}

.sidebar-tree .sidebar-details .sidebar-summary,
.sidebar-tree-items .sidebar-details .sidebar-summary {
  padding: 0.25rem 0.5rem;
  font-size: 0.75rem;
  font-weight: 500;
  text-transform: none;
  letter-spacing: normal;
}

.sidebar-tree .sidebar-details .sidebar-tree,
.sidebar-tree-items .sidebar-details .sidebar-tree-items {
  margin-left: 0.5rem;
  padding-left: 0.75rem;
  margin-top: 0;
}

/* Navigation link styling. Flex centers the label when a theme sets a
   minimum row height. */
.sidebar-link {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.375rem 0.625rem;
  font-size: 0.8125rem;
  color: var(--muted-foreground);
  text-decoration: none;
  border-radius: var(--radius);
  transition: color 0.15s ease, background 0.15s ease;
}

.sidebar-link:hover {
  color: var(--foreground);
  background: var(--muted);
}

/* Active state */
.sidebar-link.active {
  color: var(--accent-foreground);
  font-weight: 500;
  background: var(--accent);
}

/* Collapsible section styles */
.sidebar-details {
  border: none;
}

.sidebar-details > summary {
  list-style: none;
}

.sidebar-details > summary::-webkit-details-marker {
  display: none;
}

.sidebar-summary {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 0.75rem;
  font-size: 0.75rem;
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.025em;
  color: var(--muted-foreground);
  cursor: pointer;
  border-radius: var(--radius);
  transition: color 0.15s ease, background 0.15s ease;
  user-select: none;
}

.sidebar-summary:hover {
  color: var(--foreground);
  background: var(--muted);
}

/* Chevron icon for collapsible */
.sidebar-chevron {
  margin-left: auto;
  width: 14px;
  height: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: transform 0.15s ease;
}

.sidebar-chevron::before {
  content: '';
  width: 5px;
  height: 5px;
  border-right: 1.5px solid var(--muted-foreground);
  border-bottom: 1.5px solid var(--muted-foreground);
  transform: rotate(-45deg);
  transition: transform 0.15s ease;
}

.sidebar-details[open] .sidebar-chevron::before {
  transform: rotate(45deg);
}

/* Nested depth styling - fading lines */
.sidebar-tree-items .sidebar-tree-items .sidebar-tree-item::before,
.sidebar-tree-items .sidebar-tree-items .sidebar-tree-item::after {
  background: color-mix(in srgb, var(--border) 70%, transparent);
}

.sidebar-tree-items .sidebar-tree-items .sidebar-tree-items .sidebar-tree-item::before,
.sidebar-tree-items .sidebar-tree-items .sidebar-tree-items .sidebar-tree-item::after {
  background: color-mix(in srgb, var(--border) 50%, transparent);
}

/* No tree lines variant */
.sidebar-tree-items.no-tree-lines .sidebar-tree-item::before,
.sidebar-tree-items.no-tree-lines .sidebar-tree-item::after,
.sidebar-tree-items.no-tree-lines .sidebar-details::before {
  display: none;
}

/* Sidebar hover enhancement */
aside a:hover {
  background: var(--muted) !important;
}
''';


/// ArcaneSidebar component tree-line styles.
///
/// Tree-line styling for ArcaneSidebar components.
const String arcaneSidebarComponentStyles = '''
/* ============================================
   ARCANE SIDEBAR COMPONENTS - Tree Lines
   Tree-line styling for ArcaneSidebar components
   ============================================ */

/* Submenu content and group items containers get tree-line treatment */
.arcane-sidebar-submenu-content,
.arcane-sidebar-group-items {
  position: relative;
  display: flex;
  flex-direction: column;
}

/* Each sidebar item in a submenu or group gets tree connectors */
.arcane-sidebar-submenu-content > .arcane-sidebar-item,
.arcane-sidebar-group-items > .arcane-sidebar-item {
  position: relative;
}

/* Horizontal branch line */
.arcane-sidebar-submenu-content > .arcane-sidebar-item::before,
.arcane-sidebar-group-items > .arcane-sidebar-item::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  width: 0.5rem;
  height: 1px;
  background: var(--border);
}

/* Vertical line segment - connects this item to the next */
.arcane-sidebar-submenu-content > .arcane-sidebar-item:not(:last-child)::after,
.arcane-sidebar-group-items > .arcane-sidebar-item:not(:last-child)::after {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  width: 1px;
  background: var(--border);
}

/* Last item - L-bend connector */
.arcane-sidebar-submenu-content > .arcane-sidebar-item:last-child::after,
.arcane-sidebar-group-items > .arcane-sidebar-item:last-child::after {
  content: '';
  position: absolute;
  left: 0;
  top: 0;
  height: 50%;
  width: 1px;
  background: var(--border);
}

/* Single child - hide tree lines */
.arcane-sidebar-submenu-content:has(> .arcane-sidebar-item:only-child) > .arcane-sidebar-item::before,
.arcane-sidebar-submenu-content:has(> .arcane-sidebar-item:only-child) > .arcane-sidebar-item::after,
.arcane-sidebar-group-items:has(> .arcane-sidebar-item:only-child) > .arcane-sidebar-item::before,
.arcane-sidebar-group-items:has(> .arcane-sidebar-item:only-child) > .arcane-sidebar-item::after {
  display: none;
}

/* Adjust padding to accommodate tree lines */
.arcane-sidebar-submenu-content > .arcane-sidebar-item,
.arcane-sidebar-group-items > .arcane-sidebar-item {
  padding-left: 1rem !important;
}

''';

/// All sidebar styles combined.
const String arcaneAllSidebarStyles =
    '''
$arcaneSidebarTreeStyles

$arcaneSidebarComponentStyles
''';
