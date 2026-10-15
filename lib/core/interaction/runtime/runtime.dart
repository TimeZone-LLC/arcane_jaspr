library;

import 'runtime_core_js.dart';
import 'runtime_surfaces_js.dart';
import 'runtime_state_js.dart';
import 'runtime_slider_js.dart';
import 'runtime_command_js.dart';
import 'runtime_cycle_js.dart';
import 'runtime_calendar_js.dart';
import 'runtime_time_js.dart';
import 'runtime_form_theme_js.dart';
import 'runtime_dispatch_js.dart';

const String _runtimeBaseCss = r'''
[data-arcane-surface][hidden] { display: none !important; }
[data-arcane-overlay-open] { overflow: hidden; }
[data-arcane-toast-surface] {
  position: fixed;
  z-index: 99999;
  bottom: 1rem;
  right: 1rem;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  pointer-events: none;
}
[data-arcane-toast-surface] .arcane-toast { pointer-events: auto; }
[data-arcane-tab-panel][hidden] { display: none !important; }
[data-arcane-panel-content][hidden] { display: none !important; }
[data-arcane-command-item][hidden] { display: none !important; }
[data-arcane-command-group][hidden] { display: none !important; }
[data-arcane-command-empty][hidden] { display: none !important; }
[data-arcane-command-item][data-arcane-state="active"] {
  background-color: var(--accent, rgba(127,127,127,0.1));
}
[data-arcane-calendar] {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  width: min(100%, 20rem);
  min-width: min(18rem, 100%);
  box-sizing: border-box;
}
[data-arcane-calendar] .arcane-calendar-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 0.5rem;
}
[data-arcane-calendar] .arcane-calendar-label {
  flex: 1;
  text-align: center;
  font-weight: 500;
}
[data-arcane-calendar] .arcane-calendar-nav,
[data-arcane-calendar] .arcane-calendar-today {
  background: transparent;
  border: 1px solid var(--border, rgba(127,127,127,0.2));
  border-radius: var(--radius-xs, 0.25rem);
  padding: 0.25rem 0.5rem;
  cursor: pointer;
  font: inherit;
  color: inherit;
}
[data-arcane-calendar] .arcane-calendar-weekdays {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 0.25rem;
  font-size: 0.75rem;
  text-transform: uppercase;
  opacity: 0.7;
  text-align: center;
}
[data-arcane-calendar][data-arcane-show-week-numbers="true"] .arcane-calendar-weekdays {
  grid-template-columns: 2rem repeat(7, 1fr);
}
[data-arcane-calendar] .arcane-calendar-grid {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 0.25rem;
}
[data-arcane-calendar][data-arcane-show-week-numbers="true"] .arcane-calendar-grid {
  grid-template-columns: 2rem repeat(7, 1fr);
}
[data-arcane-calendar] .arcane-calendar-weeknum {
  text-align: center;
  font-size: 0.75rem;
  opacity: 0.5;
  padding: 0.25rem 0;
}
[data-arcane-calendar] .arcane-calendar-day {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 100%;
  min-width: 2.25rem;
  min-height: 2.25rem;
  aspect-ratio: 1 / 1;
  background: transparent;
  border: 1px solid transparent;
  border-radius: var(--radius-xs, 0.25rem);
  padding: 0;
  cursor: pointer;
  font: inherit;
  color: inherit;
  text-align: center;
  box-sizing: border-box;
}
[data-arcane-calendar] .arcane-calendar-day:hover:not(:disabled) {
  background: var(--muted, rgba(127,127,127,0.1));
}
[data-arcane-calendar] .arcane-calendar-day-other-month { opacity: 0.4; }
[data-arcane-calendar] .arcane-calendar-day-disabled { opacity: 0.3; cursor: not-allowed; }
[data-arcane-calendar] .arcane-calendar-day-today {
  border-color: var(--primary, currentColor);
}
[data-arcane-calendar] .arcane-calendar-day-selected,
[data-arcane-calendar] .arcane-calendar-day-pending,
[data-arcane-calendar] .arcane-calendar-day-range-start,
[data-arcane-calendar] .arcane-calendar-day-range-end {
  background: var(--primary, currentColor);
  color: var(--primary-foreground, white);
}
[data-arcane-calendar] .arcane-calendar-day-in-range:not(.arcane-calendar-day-range-start):not(.arcane-calendar-day-range-end) {
  background: var(--accent, rgba(127,127,127,0.2));
}
[data-arcane-gallery-draggable="true"] [data-arcane-draggable-item="true"] {
  position: relative;
  translate:
    var(--arcane-drag-x, 0px)
    var(--arcane-drag-y, 0px);
}
/* Drag cursors resolve through --arcane-drag-cursor / --arcane-drag-cursor-active
   so a theme can re-point them wholesale (the Win95 theme has no hand cursor at
   all). Unset, they fall back to the modern grab/grabbing pair. */
[data-arcane-gallery-draggable="true"] [data-arcane-drag-handle="true"] {
  cursor: var(--arcane-drag-cursor, grab);
  user-select: none;
}
[data-arcane-gallery-draggable="true"] .is-arcane-gallery-dragging,
[data-arcane-gallery-draggable="true"] .is-arcane-gallery-dragging [data-arcane-drag-handle="true"] {
  cursor: var(--arcane-drag-cursor-active, grabbing);
}
[data-arcane-gallery-draggable="true"] .is-arcane-gallery-dragging {
  will-change: translate;
}
[data-arcane-gallery-draggable="true"].is-arcane-gallery-drag-active {
  user-select: none;
}
.arcane-gallery-drag-announcer {
  position: fixed;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}
@media (pointer: coarse) {
  [data-arcane-gallery-draggable="true"] [data-arcane-drag-handle="true"] {
    cursor: default;
  }
}
''';

String buildArcaneInteractivityRuntime({bool minify = false}) {
  final StringBuffer buffer = StringBuffer();
  buffer.writeln('(function() {');
  buffer.writeln("  'use strict';");
  buffer.writeln(runtimeCoreJs);
  buffer.writeln(runtimeSurfacesJs);
  buffer.writeln(runtimeGroupsJs);
  buffer.writeln(runtimeTabsJs);
  buffer.writeln(runtimePanelsJs);
  buffer.writeln(runtimeStepperJs);
  buffer.writeln(runtimePaginationJs);
  buffer.writeln(runtimeCarouselJs);
  buffer.writeln(runtimeSliderJs);
  buffer.writeln(runtimeCommandJs);
  buffer.writeln(runtimeCycleJs);
  buffer.writeln(runtimeCalendarJs);
  buffer.writeln(runtimeTimeJs);
  buffer.writeln(runtimeFormJs);
  buffer.writeln(runtimeThemeJs);
  buffer.writeln(runtimeToastJs);
  buffer.writeln(runtimeCopyJs);
  buffer.writeln(runtimeNavJs);
  buffer.writeln(runtimeDispatchJs);
  buffer.writeln(runtimeDelegationJs);
  buffer.writeln(runtimeBootstrapJs);
  buffer.writeln('})();');
  return buffer.toString();
}

String buildArcaneInteractivityCss() => _runtimeBaseCss;

String get arcaneInteractivityRuntimeJs => buildArcaneInteractivityRuntime();

String get arcaneInteractivityRuntimeCss => buildArcaneInteractivityCss();
