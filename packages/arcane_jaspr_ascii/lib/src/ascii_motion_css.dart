const String asciiMotionCss = r'''
.ascii-orbit {
  --ascii-orbit-state: paused;
  position: relative;
  inline-size: 100%;
  aspect-ratio: 1;
  min-inline-size: 0;
  color: var(--foreground, #25251f);
  isolation: isolate;
  container-type: inline-size;
}
.ascii-orbit-guides { position: absolute; inset: 0; pointer-events: none; }
.ascii-orbit-ring {
  position: absolute;
  inset: 18%;
  border: 1px solid color-mix(in srgb, currentColor 20%, transparent);
  border-radius: 50%;
}
.ascii-orbit-ring:nth-child(2) { inset: 29%; }
.ascii-orbit-ring:nth-child(3) { inset: 40%; }
.ascii-orbit-ring::before, .ascii-orbit-ring::after {
  content: '+';
  position: absolute;
  top: 50%;
  font: 400 0.7rem/1 var(--font-mono, monospace);
  color: var(--muted-foreground, #66665d);
  transform: translate(-50%, -50%);
}
.ascii-orbit-ring::before { left: 0; }
.ascii-orbit-ring::after { left: 100%; }
.ascii-orbit-origin { position: absolute; inset: 50% auto auto 50%; transform: translate(-50%, -50%); opacity: 0.5; }
.ascii-orbit-track {
  position: absolute;
  inset: var(--ascii-orbit-inset);
  transform: rotate(var(--ascii-orbit-phase));
  animation: ascii-orbit-turn var(--ascii-orbit-duration, 120s) linear infinite;
  animation-play-state: var(--ascii-orbit-state);
  pointer-events: none;
}
.ascii-orbit-point {
  position: absolute;
  inset: 0 auto auto 50%;
  inline-size: max-content;
  max-inline-size: min(10rem, 28cqi);
  transform: translate(-50%, -50%);
  pointer-events: auto;
  overflow-wrap: anywhere;
}
.ascii-orbit-counterturn {
  transform: rotate(var(--ascii-orbit-counterphase));
  animation: ascii-orbit-counterturn var(--ascii-orbit-duration, 120s) linear infinite;
  animation-play-state: var(--ascii-orbit-state);
}
.ascii-orbit-mark { display: block; font: 400 0.9rem/1 var(--font-mono, monospace); }
.ascii-orbit[data-ascii-motion-state="running"] { --ascii-orbit-state: running; }
.ascii-orbit:is(:hover, :focus-within, [data-animated="false"], [data-ascii-motion-state="paused"]),
[data-ascii-motion="off"] .ascii-orbit,
.ascii-orbit[data-ascii-motion="off"] { --ascii-orbit-state: paused; }
@keyframes ascii-orbit-turn {
  from { transform: rotate(var(--ascii-orbit-phase)); }
  to { transform: rotate(calc(var(--ascii-orbit-phase) + 1turn)); }
}
@keyframes ascii-orbit-counterturn {
  from { transform: rotate(var(--ascii-orbit-counterphase)); }
  to { transform: rotate(calc(var(--ascii-orbit-counterphase) - 1turn)); }
}
.ascii-reveal { min-inline-size: 0; }
.ascii-reveal[data-ascii-reveal="waiting"] { opacity: 0; transform: translateY(0.75rem); }
.ascii-reveal[data-ascii-reveal="entered"] {
  animation: ascii-reveal-enter var(--ascii-reveal-duration, 700ms) cubic-bezier(0.22, 1, 0.36, 1) var(--ascii-reveal-delay, 0ms) both;
}
.ascii-reveal[data-ascii-motion-state="paused"] { animation-play-state: paused; }
.ascii-reveal:is(:focus-within, [data-animated="false"], [data-ascii-motion="off"]),
[data-ascii-motion="off"] .ascii-reveal {
  opacity: 1;
  transform: none;
  animation: none;
}
@keyframes ascii-reveal-enter {
  from { opacity: 0; transform: translateY(0.75rem); }
  to { opacity: 1; transform: translateY(0); }
}
@media (prefers-reduced-motion: reduce) {
  .ascii-orbit { --ascii-orbit-state: paused !important; }
  .ascii-reveal { opacity: 1 !important; transform: none !important; animation: none !important; }
}
''';
