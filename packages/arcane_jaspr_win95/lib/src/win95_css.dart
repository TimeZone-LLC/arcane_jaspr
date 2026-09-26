import 'package:arcane_jaspr/component/navigation/toc.dart'
    show arcaneTocTreeLinesCss;
import 'package:arcane_jaspr/component/view/map/map_style.dart'
    show arcaneMapCss;
import 'package:arcane_jaspr/theme/palette_generator.dart';
import 'package:arcane_jaspr/util/content/prose_styles.dart'
    show arcaneAllDocsStyles;

import 'package:arcane_jaspr_win95/src/win95_cursor_assets.dart';
import 'package:arcane_jaspr_win95/src/win95_loader_assets.dart';
import 'package:arcane_jaspr_win95/src/win95_loader_palette.dart';
import 'package:arcane_jaspr_win95/src/win95_pixel_assets.dart';
import 'package:arcane_jaspr_win95/src/win95_theme.dart';

/// Component CSS for the Windows 95 theme.
///
/// A pixel-faithful recreation of the classic Win95 desktop, built entirely from
/// the signature layered-inset "3D" bevels: raised control faces (buttons,
/// panels, tabs), sunken wells (inputs, progress, group boxes), solid navy
/// title bars, segmented progress meters, chunky beveled scrollbars, and
/// dotted focus rectangles. Everything is sharp-cornered (`border-radius: 0`),
/// nothing is blurred, and hover states are intentionally absent — Win95 controls
/// only react on press.
///
/// Every rule is scoped to `#arcane-root.arcane-theme-win95` so it can never
/// affect the shadcn, neon, or neubrutalism themes. The 3D shading is exposed as
/// `--w95-*` custom properties (composed into `--w95-raised` / `--w95-pressed` /
/// `--w95-sunken` / `--w95-window-frame` box-shadow recipes) which the dark
/// silver block simply re-points, so every bevel inverts for free.
class Win95Css {
  const Win95Css._();

  static String _hex(int argb) {
    final int r = (argb >> 16) & 0xFF;
    final int g = (argb >> 8) & 0xFF;
    final int b = argb & 0xFF;
    return '#${r.toRadixString(16).padLeft(2, '0')}'
        '${g.toRadixString(16).padLeft(2, '0')}'
        '${b.toRadixString(16).padLeft(2, '0')}';
  }

  static String componentCss(
    Win95Theme theme,
    Win95LoaderPalette loaderPalette,
  ) {
    final String desktop = _hex(theme.desktop);
    final String desktopForeground = PaletteGenerator.toHex(
      PaletteGenerator.contrastingForeground(theme.desktop),
    );
    final String titleA = _hex(theme.titleStart);
    final String titleB = _hex(theme.titleEnd);
    final String selection = _hex(theme.accent);
    final String accentForeground = _hex(
      PaletteGenerator.contrastingForeground(theme.titleEnd),
    );
    final String lightLink = _hex(PaletteGenerator.darken(theme.accent, 0.18));
    final String darkLink = _hex(PaletteGenerator.lighten(theme.titleEnd, 0.5));
    final String loaderDataUri = switch (loaderPalette) {
      Win95LoaderPalette.win98 => win95LoaderWin98DataUri,
      Win95LoaderPalette.amber => win95LoaderAmberDataUri,
      Win95LoaderPalette.gameboy => win95LoaderGameboyDataUri,
    };
    // The hourglass is pixel art, so a HiDPI display must be handed the sheet
    // that lands 1:1 on its device pixels instead of a bilinear upscale of the
    // 1x frames. These feed the `image-set()` on `.arcane-loader`.
    final String loaderDataUri2x = switch (loaderPalette) {
      Win95LoaderPalette.win98 => win95LoaderWin98DataUri2x,
      Win95LoaderPalette.amber => win95LoaderAmberDataUri2x,
      Win95LoaderPalette.gameboy => win95LoaderGameboyDataUri2x,
    };
    final String loaderDataUri3x = switch (loaderPalette) {
      Win95LoaderPalette.win98 => win95LoaderWin98DataUri3x,
      Win95LoaderPalette.amber => win95LoaderAmberDataUri3x,
      Win95LoaderPalette.gameboy => win95LoaderGameboyDataUri3x,
    };

    return '''
/* ============================================================
   WINDOWS 95 THEME — scoped to .arcane-theme-win95.
   Faithful 3D bevels, silver faces, navy title bars.
   ============================================================ */

#arcane-root.arcane-theme-win95 {
  /* --- Palette overrides (win the cascade via id+class specificity) --- */
  --background: #c0c0c0;
  --foreground: #000000;
  --card: #c0c0c0;
  --card-foreground: #000000;
  --card-hover: #c0c0c0;
  --popover: #c0c0c0;
  --popover-foreground: #000000;
  --secondary: #c0c0c0;
  --secondary-foreground: #000000;
  --muted: #c0c0c0;
  --muted-foreground: #404040;
  --primary: var(--w95-selection-in, $selection);
  --primary-foreground: var(--w95-selection-text-in, #ffffff);
  --accent: var(--w95-title-b-in, $titleB);
  --accent-foreground: var(--w95-title-text-in, $accentForeground);
  --border: #808080;
  --input: #ffffff;
  --ring: var(--w95-selection-in, $selection);
  --destructive: #a00000;
  --destructive-foreground: #ffffff;
  --success: #005800;
  --success-foreground: #ffffff;
  --warning: #644800;
  --warning-foreground: #ffffff;
  --info: $lightLink;
  --info-foreground: #ffffff;
  --w95-link: $lightLink;
  /* COLOR_GRAYTEXT. Every greyed label also carries the white emboss (see the
     engraved-label rules), which is what keeps it legible on the face. */
  --w95-disabled-text: #808080;
  --navbar: #c0c0c0;
  --code-background: #ffffff;
  --radius: 0;

  /* Windows 95 interpolated nothing: every state change — hover, press, open,
     close, expand — landed in a single repaint. The core theme emits these
     timing tokens as `150ms ease` and friends, and dozens of renderers hand
     them straight to the DOM as inline styles, so zeroing them here is the one
     edit that reaches all of those at their source. --arcane-* are aliases of
     the four above, but a custom property substitutes var() on the element it
     is DECLARED on (:root), so the alias inherits an already-resolved
     `150ms ease` and has to be re-zeroed by name rather than left to cascade. */
  --transition-fast: 0s;
  --transition: 0s;
  --transition-slow: 0s;
  --transition-slower: 0s;
  --arcane-transition-fast: 0s;
  --arcane-transition: 0s;
  --arcane-transition-slow: 0s;
  --arcane-transition-slower: 0s;

  /* --- Win95 3D primitives (light / silver) --- */
  --w95-face: #c0c0c0;
  --w95-face-text: #000000;
  --w95-hilite: #ffffff;   /* outer top-left highlight */
  --w95-light: #dfdfdf;    /* inner top-left */
  --w95-shadow: #808080;   /* inner bottom-right */
  --w95-dark: #000000;     /* outer bottom-right */
  --w95-field: #ffffff;
  --w95-field-text: #000000;
  --w95-field-placeholder: #666666;
  /* The desktop backdrop, title-bar color and selection accept a runtime
     override (--w95-*-in) so a host app can re-tint them from an account accent
     without a rebuild; unset, they fall back to this appearance scheme. The
     matching text hooks (--w95-title-text-in / --w95-selection-text-in) let the
     host keep caption and selection text readable on a light accent — the
     stock white only suits the dark stock schemes. The silver control face and
     bevels above stay fixed across every accent. */
  --w95-desktop: var(--w95-desktop-in, $desktop);
  --w95-desktop-text: var(--w95-desktop-text-in, $desktopForeground);
  --arcane-app-background: var(--w95-desktop);
  --arcane-app-foreground: var(--w95-desktop-text);
  --w95-title-a: var(--w95-title-a-in, $titleA);
  --w95-title-b: var(--w95-title-b-in, $titleB);
  --w95-title-text: var(--w95-title-text-in, #ffffff);
  /* COLOR_INACTIVECAPTION / COLOR_INACTIVECAPTIONTEXT. One colour, not two:
     an inactive caption was a solid fill in Windows 95, and the second stop a
     gradient would need is a Windows 98 concept. */
  --w95-title-inactive-a: #808080;
  --w95-title-inactive-text: #c0c0c0;
  --w95-selection: var(--w95-selection-in, $selection);
  --w95-selection-text: var(--w95-selection-text-in, #ffffff);
  --w95-loader-image: url("$loaderDataUri");
  /* Shared caption fill (one source for every title bar). Windows 95 painted
     captions SOLID — the navy->cyan gradient is a Windows 98 feature — so this
     resolves to --w95-title-a alone. A host that wants the 98 look redeclares
     --w95-title-bar in its own rule (same scope, later in the cascade); both
     --w95-title-a and --w95-title-b stay defined so that gradient still works. */
  --w95-title-bar: var(--w95-title-a);

  /* --- Composed bevel recipes --- */
  --w95-raised:
    inset -1px -1px 0 var(--w95-dark),
    inset 1px 1px 0 var(--w95-hilite),
    inset -2px -2px 0 var(--w95-shadow),
    inset 2px 2px 0 var(--w95-light);
  --w95-pressed:
    inset -1px -1px 0 var(--w95-hilite),
    inset 1px 1px 0 var(--w95-dark),
    inset -2px -2px 0 var(--w95-light),
    inset 2px 2px 0 var(--w95-shadow);
  --w95-sunken:
    inset -1px -1px 0 var(--w95-hilite),
    inset 1px 1px 0 var(--w95-shadow),
    inset -2px -2px 0 var(--w95-light),
    inset 2px 2px 0 var(--w95-dark);
  /* Windows, menus and popups: the frame DrawEdge gives a top-level window
     swaps the two top-left shades of the push button, so its outer ring is
     #dfdfdf and its inner ring white (bottom-right stays #808080 inside
     black). First-listed shadows paint on top, so the outer 1px ring is
     declared before the inner one exactly as in --w95-raised. */
  --w95-window-frame:
    inset -1px -1px 0 var(--w95-dark),
    inset 1px 1px 0 var(--w95-light),
    inset -2px -2px 0 var(--w95-shadow),
    inset 2px 2px 0 var(--w95-hilite);
  --w95-raised-thin:
    inset -1px -1px 0 var(--w95-shadow),
    inset 1px 1px 0 var(--w95-hilite);
  --w95-sunken-thin:
    inset -1px -1px 0 var(--w95-hilite),
    inset 1px 1px 0 var(--w95-shadow);

  /* --- Caption buttons: minimize / maximize / close ---
     Drawn as pixel art, never as text or vector strokes. A literal "_" sits
     ON the font's baseline and an anti-aliased stroke smears across two
     pixels, while every Win95 caption glyph was a fixed bitmap. Each cap is a
     16x14 raised face (outer top-left white, inner top-left #dfdfdf, inner
     bottom-right #808080, outer bottom-right black) carrying a black glyph:
     a 6x2 minimize bar at x4-9/y9-10, a 9x9 maximize box with a 2px top edge
     at x3-11/y2-10, and the stepped 8x7 close cross at x4-11/y3-9.
     --w95-caption-buttons is the full 50x14 row (minimize and maximize
     touching, a 2px gap, then close), --w95-caption-min-max the 32x14 pair,
     and --w95-caption-close the lone cap. Bevel colours cannot follow
     currentColor, so the dark block re-points all three at dark variants.
     They are decorative backgrounds for captions with no window manager
     behind them; a real control (the dialog close) is a button carrying the
     shape-only --w95-ctl-* masks below, which follow its text colour. */
  --w95-caption-buttons: url("$win95CaptionButtonsLight");
  --w95-caption-min-max: url("$win95CaptionMinMaxLight");
  --w95-caption-close: url("$win95CaptionCloseLight");
  /* The same three glyphs as masks in a 10x10 cell. Centred in a 16x14 cap
     the cell sits at offset (3, 2), which puts each glyph on exactly the
     pixels the sprites above use. */
  --w95-ctl-min: url("$win95ControlMinimizeMask");
  --w95-ctl-max: url("$win95ControlMaximizeMask");
  --w95-ctl-close: url("$win95ControlCloseMask");

  /* The checkbox tick, drawn for the same reason the window controls are: a
     font glyph (U+2714 or a literal "x") changes weight, width and baseline
     with every fallback in the stack, and the Win95 mark was a fixed 7x7
     bitmap. Two two-pixel-thick strokes — a short one descending right to the
     vertex at column 2, a long one climbing right to the tip at column 6 —
     authored one pixel per path run in a 7x7 cell and painted as a mask so it
     follows --w95-field-text. */
  --w95-check: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 7 7'%3E%3Cpath fill='%23000000' d='M0 3h1v2H0zM1 4h1v2H1zM2 5h1v2H2zM3 4h1v2H3zM4 3h1v2H4zM5 2h1v2H5zM6 1h1v2H6z'/%3E%3C/svg%3E");

  /* --- Control bitmaps (see win95_pixel_assets.dart) ---
     The radio ring and its circular mask, the 7x4 stepped scroll arrows, and
     the pointed trackbar thumb. Bevel and glyph colours are baked, so the
     dark block re-points each coloured token; the mask is shape-only. */
  --w95-radio-ring: url("$win95RadioRingLight");
  --w95-radio-mask: url("$win95RadioMask");
  --w95-scroll-up: url("$win95ScrollUpLight");
  --w95-scroll-down: url("$win95ScrollDownLight");
  --w95-scroll-left: url("$win95ScrollLeftLight");
  --w95-scroll-right: url("$win95ScrollRightLight");
  --w95-slider-thumb: url("$win95SliderThumbLight");

  /* --- Cursors: the stock Win95 bitmap set ---
     Win95 drew its cursors as hand-authored 1x bitmaps, and the set contained
     NO hand/pointer and no open/closed "grab" hand at all — those are IE and
     NeXT idioms. Every pointing surface this theme owns therefore resolves to
     one of these instead of the visitor's modern OS cursor. Each value is the
     pixel-art PNG (generated by tool/bundle_win95_cursors.dart), its hotspot in
     source pixels, then a keyword fallback for browsers that refuse the image.
     Host apps reference these directly (e.g. cursor: var(--w95-cursor-arrow))
     rather than naming a modern keyword. */
  --w95-cursor-arrow: url("$win95CursorArrowDataUri") 0 0, default;
  --w95-cursor-wait: url("$win95CursorWaitDataUri") 6 10, wait;
  --w95-cursor-ibeam: url("$win95CursorIbeamDataUri") 2 8, text;
  --w95-cursor-crosshair: url("$win95CursorCrossDataUri") 7 7, crosshair;
  /* IDC_NO — shown only while dragging over a target that refuses the drop.
     A greyed-out control kept the plain arrow; its engraved label was the
     affordance. Exposed for host apps that implement drag and drop. */
  --w95-cursor-no: url("$win95CursorNoDataUri") 8 8, not-allowed;
  /* The one non-shell cursor: Internet Explorer's link hand. Scoped to real
     hypertext below and nowhere else — buttons, tabs and menu items kept the
     arrow in Win95. */
  --w95-cursor-hand: url("$win95CursorHandDataUri") 2 0, pointer;
  /* SIZEALL — Win95 showed this only for keyboard move mode (Alt+Space, M),
     never for a title-bar drag, which kept the plain arrow throughout. */
  --w95-cursor-move: url("$win95CursorMoveDataUri") 9 9, move;
  --w95-cursor-ns: url("$win95CursorSizeNsDataUri") 4 9, ns-resize;
  --w95-cursor-ew: url("$win95CursorSizeEwDataUri") 9 4, ew-resize;
  --w95-cursor-nwse: url("$win95CursorSizeNwseDataUri") 7 7, nwse-resize;
  --w95-cursor-nesw: url("$win95CursorSizeNeswDataUri") 7 7, nesw-resize;
  /* Re-point the core drag seam (gallery handles, carousel track) at the arrow;
     unset, those rules resolve to the modern grab/grabbing pair. */
  --arcane-drag-cursor: var(--w95-cursor-arrow);
  --arcane-drag-cursor-active: var(--w95-cursor-arrow);
  /* Core scripts write these two seams as inline cursors (number-input spinners
     and the resizable splitter). Unset, they fall back to the modern keywords
     the other themes want. */
  --arcane-step-cursor: var(--w95-cursor-arrow);
  --arcane-step-cursor-disabled: var(--w95-cursor-arrow);
  --arcane-resize-cursor-ew: var(--w95-cursor-ew);
  --arcane-resize-cursor-ns: var(--w95-cursor-ns);

  color: var(--foreground);
  font-family: var(--font-sans);
}

/* Dark mode — a dimmed "dark silver" Windows 95: dark 3D control faces with
   real, visible bevels (lighter-grey highlight, near-black shadow), dark input
   wells, and the active appearance scheme's colours carried through (the
   desktop is the scheme colour mixed toward black; the title bars + selection
   keep the scheme's own hues) so the five palettes stay distinct in dark. */
#arcane-root.arcane-theme-win95.dark {
  --background: color-mix(in srgb, $desktop 30%, #050505);
  --foreground: #ffffff;
  --card: #3a3a3a;
  --card-foreground: #ffffff;
  --card-hover: #464646;
  --popover: #3a3a3a;
  --popover-foreground: #ffffff;
  --secondary: #3a3a3a;
  --secondary-foreground: #ffffff;
  --muted: #2a2a2a;
  --muted-foreground: #bcbcbc;
  --primary: var(--w95-selection-in, $selection);
  --primary-foreground: var(--w95-selection-text-in, #ffffff);
  --border: #4a4a4a;
  --input: #242424;
  --ring: var(--w95-selection-in, $selection);
  --destructive: #ff8080;
  --destructive-foreground: #000000;
  --success: #80d080;
  --success-foreground: #000000;
  --warning: #e8ce80;
  --warning-foreground: #000000;
  --info: $darkLink;
  --info-foreground: #000000;
  --w95-link: $darkLink;
  --w95-disabled-text: #aaaaaa;

  --w95-face: #3a3a3a;
  --w95-face-text: #ffffff;
  --w95-hilite: #8e8e8e;
  --w95-light: #646464;
  --w95-shadow: #1c1c1c;
  --w95-dark: #000000;
  --w95-field: #242424;
  --w95-field-text: #ffffff;
  --w95-field-placeholder: #bcbcbc;
  --w95-desktop: var(--w95-desktop-in, color-mix(in srgb, $desktop 30%, #050505));
  --w95-desktop-text: var(--w95-desktop-text-in, #ffffff);
  --arcane-app-foreground: var(--w95-desktop-text);
  --w95-title-a: var(--w95-title-a-in, $titleA);
  --w95-title-b: var(--w95-title-b-in, $titleB);
  --w95-title-text: var(--w95-title-text-in, #ffffff);
  --w95-title-inactive-a: #2a2a2a;
  --w95-title-inactive-text: #8e8e8e;
  --w95-selection: var(--w95-selection-in, $selection);
  --w95-selection-text: var(--w95-selection-text-in, #ffffff);
  --w95-caption-buttons: url("$win95CaptionButtonsDark");
  --w95-caption-min-max: url("$win95CaptionMinMaxDark");
  --w95-caption-close: url("$win95CaptionCloseDark");
  --w95-radio-ring: url("$win95RadioRingDark");
  --w95-scroll-up: url("$win95ScrollUpDark");
  --w95-scroll-down: url("$win95ScrollDownDark");
  --w95-scroll-left: url("$win95ScrollLeftDark");
  --w95-scroll-right: url("$win95ScrollRightDark");
  --w95-slider-thumb: url("$win95SliderThumbDark");
}

#arcane-root.arcane-theme-win95 ::selection {
  background: var(--w95-selection);
  color: var(--w95-selection-text);
}

/* A page is a real Win95 window surface, not bare text on the desktop canvas.
   This keeps normal and muted page text paired with the silver face in light
   mode and the dark face in High Contrast Black. */
#arcane-root.arcane-theme-win95 .arcane-page {
  background: var(--w95-face);
  color: var(--w95-face-text);
  box-shadow: var(--w95-raised);
}

/* Enable the Win95 ::-webkit-scrollbar styling below: the core base CSS sets the
   standard `scrollbar-width: thin` + `scrollbar-color`, and modern Chrome IGNORES
   all ::-webkit-scrollbar pseudo rules when either standard property is set. Reset
   them to auto within the theme so our chunky beveled scrollbars actually render. */
#arcane-root.arcane-theme-win95,
#arcane-root.arcane-theme-win95 * {
  scrollbar-width: auto !important;
  scrollbar-color: auto !important;
}

/* Global sharpening: no rounded corners, no blur, dotted focus rectangles. */
#arcane-root.arcane-theme-win95 :focus-visible {
  outline: 1px dotted var(--w95-face-text);
  outline-offset: -4px;
}

/* ---------- Buttons ---------- */

#arcane-root.arcane-theme-win95 .win95-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.4rem;
  font-family: var(--font-sans);
  font-weight: 400;
  font-size: 1.219rem;
  line-height: 1;
  white-space: nowrap;
  border: none;
  border-radius: 0;
  background: var(--w95-face);
  color: var(--w95-face-text);
  box-shadow: var(--w95-raised);
  cursor: var(--w95-cursor-arrow);
  text-decoration: none;
  padding: 0.4rem 0.9rem;
  min-height: 1.6rem;
  transition: none;
}

#arcane-root.arcane-theme-win95 .win95-button[data-size="sm"] {
  padding: 0.28rem 0.65rem;
  font-size: 1.125rem;
  min-height: 1.35rem;
}
#arcane-root.arcane-theme-win95 .win95-button[data-size="lg"] {
  padding: 0.55rem 1.2rem;
  font-size: 1.35rem;
}
#arcane-root.arcane-theme-win95 .win95-button[data-size="iconSm"] {
  padding: 0.3rem;
  width: 1.85rem;
  height: 1.85rem;
}
#arcane-root.arcane-theme-win95 .win95-button[data-size="iconMd"] {
  padding: 0.4rem;
  width: 2.2rem;
  height: 2.2rem;
}
#arcane-root.arcane-theme-win95 .win95-button[data-size="iconLg"] {
  padding: 0.55rem;
  width: 2.7rem;
  height: 2.7rem;
}

/* Every button is a silver 3D face — Win95 has no colored buttons. The default
   push button is identified by a 1px SOLID BLACK rectangle drawn OUTSIDE the
   raised bevel — the only cue for "this is what Enter does". It has to be a
   real border, not an inset shadow: box-shadows paint first-listed on top, so
   an inset ring behind --w95-raised (which already covers a full 1px ring on
   every side) was 100% occluded and never rendered at all. The border-box
   sizing keeps the outer footprint identical to a normal button so a row of
   buttons stays aligned. */
#arcane-root.arcane-theme-win95 .win95-button[data-variant="primary"] {
  box-sizing: border-box;
  border: 1px solid var(--w95-dark);
  box-shadow: var(--w95-raised);
}
#arcane-root.arcane-theme-win95 .win95-button[data-variant="secondary"],
#arcane-root.arcane-theme-win95 .win95-button[data-variant="accent"],
#arcane-root.arcane-theme-win95 .win95-button[data-variant="success"],
#arcane-root.arcane-theme-win95 .win95-button[data-variant="warning"],
#arcane-root.arcane-theme-win95 .win95-button[data-variant="info"] {
  background: var(--w95-face);
  color: var(--w95-face-text);
}
/* Destructive keeps the silver 3D face but must still read as dangerous: a
   maroon bold label plus a 1px maroon ring drawn just inside the bevel (the
   same device as the primary button's default ring). Dark mode brightens the
   red so it stays legible on the dark control face. */
#arcane-root.arcane-theme-win95 .win95-button[data-variant="destructive"] {
  box-sizing: border-box;
  background: var(--w95-face);
  color: var(--destructive);
  font-weight: 700;
  border: 1px solid var(--destructive);
  box-shadow: var(--w95-raised);
}
#arcane-root.arcane-theme-win95 .win95-button[data-variant="outline"] {
  background: var(--w95-face);
  color: var(--w95-face-text);
}
/* Ghost buttons keep a thin raised face (Office-toolbar style) instead of bare
   text: with no chrome at all they disappeared entirely on dark surfaces. */
#arcane-root.arcane-theme-win95 .win95-button[data-variant="ghost"] {
  background: var(--w95-face);
  color: var(--w95-face-text);
  box-shadow: var(--w95-raised-thin);
}
#arcane-root.arcane-theme-win95 .win95-button[data-variant="ghost"]:hover:not([data-disabled="true"]) {
  box-shadow: var(--w95-raised);
  background: var(--w95-face);
}
#arcane-root.arcane-theme-win95 .win95-button[data-variant="ghost"]:active:not([data-disabled="true"]) {
  box-shadow: var(--w95-pressed);
}
#arcane-root.arcane-theme-win95 .win95-button[data-variant="link"] {
  background: transparent;
  box-shadow: none;
  color: var(--w95-link);
  padding-left: 0;
  padding-right: 0;
  text-decoration: underline;
  text-underline-offset: 2px;
}

/* Press: swap the bevel and nudge the label down-right, like a real button. */
#arcane-root.arcane-theme-win95 .win95-button:active:not([data-disabled="true"]):not([data-variant="link"]):not([data-variant="ghost"]) {
  box-shadow: var(--w95-pressed);
  padding-top: calc(0.4rem + 1px);
  padding-left: calc(0.9rem + 1px);
  padding-bottom: calc(0.4rem - 1px);
  padding-right: calc(0.9rem - 1px);
}
#arcane-root.arcane-theme-win95 .win95-button[data-disabled="true"] {
  color: var(--w95-disabled-text);
  text-shadow: 1px 1px 0 var(--w95-hilite);
  cursor: var(--w95-cursor-arrow);
}

#arcane-root.arcane-theme-win95 .win95-button-group,
#arcane-root.arcane-theme-win95 .win95-button-panel {
  display: inline-flex;
  gap: 0.4rem;
  flex-wrap: wrap;
}

/* ---------- Surfaces (cards, popovers, menus, dialogs) ---------- */

#arcane-root.arcane-theme-win95 .win95-card,
#arcane-root.arcane-theme-win95 .win95-popover,
#arcane-root.arcane-theme-win95 .win95-dropdown-menu,
#arcane-root.arcane-theme-win95 .win95-select-dropdown,
#arcane-root.arcane-theme-win95 .win95-command-dialog,
#arcane-root.arcane-theme-win95 .win95-command-list,
#arcane-root.arcane-theme-win95 .win95-toast,
#arcane-root.arcane-theme-win95 .win95-accordion,
#arcane-root.arcane-theme-win95 .win95-empty-state {
  background: var(--w95-face);
  color: var(--w95-face-text);
  border: none;
  border-radius: 0;
  box-shadow: var(--w95-raised);
}

#arcane-root.arcane-theme-win95 .win95-card {
  position: relative;
  padding: 1rem;
  transition: none;
}
#arcane-root.arcane-theme-win95 .win95-card[data-variant="flat"] {
  box-shadow: var(--w95-raised-thin);
}
#arcane-root.arcane-theme-win95 .win95-card[data-variant="ghost"] {
  box-shadow: none;
  background: transparent;
}
#arcane-root.arcane-theme-win95 .win95-card[data-variant="outlined"] {
  box-shadow: var(--w95-sunken);
  background: var(--w95-face);
}
#arcane-root.arcane-theme-win95 .win95-card[data-variant="interactive"],
#arcane-root.arcane-theme-win95 .win95-card.clickable {
  cursor: var(--w95-cursor-arrow);
}
#arcane-root.arcane-theme-win95 .win95-card[data-variant="interactive"]:active,
#arcane-root.arcane-theme-win95 .win95-card.clickable:active {
  box-shadow: var(--w95-pressed);
}
/* Nested cards are sub-surfaces: a win95 card inside another win95 card drops
   its raised bevel + face so stacked panels do not emboss twice. Re-assert a
   frame on the inner card with decoration:/styles:. */
#arcane-root.arcane-theme-win95 .win95-card .win95-card:not([data-arcane-decorated]) {
  background: transparent !important;
  border-color: transparent !important;
  box-shadow: none !important;
}

/* Dropdown / popover / select surfaces sit slightly tighter and float. */
#arcane-root.arcane-theme-win95 .win95-dropdown-menu,
#arcane-root.arcane-theme-win95 .win95-popover,
#arcane-root.arcane-theme-win95 .win95-select-dropdown {
  padding: 2px;
  box-shadow: var(--w95-window-frame);
}

/* ---------- Window chrome: navy title bars (configurable) ---------- */

/* The command palette is a semantic titled window. It is the containing block
   for its own caption: the render base gives it no position, so without this
   the absolutely positioned bar resolved against the full-screen overlay. */
#arcane-root.arcane-theme-win95 .win95-command-dialog {
  position: relative;
  padding-top: calc(2px + 22px);
}
#arcane-root.arcane-theme-win95:not(.win95-chrome-minimal) .win95-command-dialog::before {
  content: '';
  position: absolute;
  top: 3px;
  left: 3px;
  right: 3px;
  height: 18px;
  background: var(--w95-title-bar);
}
/* Caption buttons in the bar's top-right corner, 2px in from its edges. The
   caption carries no text: the palette's search field is its only label. */
#arcane-root.arcane-theme-win95:not(.win95-chrome-minimal) .win95-command-dialog::after {
  content: '';
  position: absolute;
  top: 5px;
  right: 5px;
  width: 50px;
  height: 14px;
  background: var(--w95-caption-buttons) no-repeat center / 50px 14px;
  pointer-events: none;
}

/* ---------- Gallery: titled windows on the teal desktop ---------- */
/*
   The showcase surface. The gallery paints the classic Win95 teal DESKTOP; each
   tile is a fully-chromed application WINDOW: the silver window frame (the
   shared --w95-window-frame recipe), a solid navy title bar (the shared
   --w95-title-bar fill) carrying the artwork's REAL, accessible title text
   plus the decorative caption buttons (--w95-caption-buttons), the media as
   the window's client area, and an optional raised status strip footer.
   Sharp corners, hard 1px bevels only.
   The render base emits the media FIRST, so the header is lifted above it with
   order:-1 rather than duplicating the DOM. */

#arcane-root.arcane-theme-win95 .win95-gallery {
  background: var(--w95-desktop);
  padding: 0.75rem;
}

/* Each tile is a silver window in the shared window frame. */
#arcane-root.arcane-theme-win95 .win95-gallery-tile {
  position: relative;
  gap: 2px;
  padding: 3px;
  background: var(--w95-face);
  color: var(--w95-face-text);
  border: 1px solid var(--w95-dark);
  box-shadow: var(--w95-window-frame);
  border-radius: 0;
  transition: none;
}

/* Link tiles press in like a real window control. */
#arcane-root.arcane-theme-win95 a.win95-gallery-tile:active {
  box-shadow: var(--w95-pressed);
}

/* Header = the solid navy title bar (reuses the shared --w95-title-bar fill).
   order:-1 lifts it above the media the render base emits first. The caption is
   also the window's drag grip, and Win95 kept the plain ARROW over it for the
   whole move — the 4-way SIZEALL cursor belonged to keyboard move mode only. */
#arcane-root.arcane-theme-win95 .win95-gallery-tile-header {
  order: -1;
  position: relative;
  display: flex;
  flex-direction: column;
  justify-content: center;
  gap: 1px;
  min-height: 18px;
  padding: 2px 58px 2px 6px;
  background: var(--w95-title-bar);
  color: var(--w95-title-text);
  cursor: var(--w95-cursor-arrow);
  user-select: none;
}

/* Decorative caption buttons, 2px in from the caption's right edge and centred
   on its height: a caption holding a title and a meta line runs taller than
   the 18px minimum, and auto margins keep the 14px row centred on it (2px in
   from the top and bottom of an 18px bar) instead of pinned to its top edge.
   The 58px right padding keeps a long title clear of the 50px row plus a gap.
   They stay the same on an inactive window: Windows 95 recoloured only the
   caption fill and text on deactivation, never the buttons. */
#arcane-root.arcane-theme-win95 .win95-gallery-tile-header::after {
  content: '';
  position: absolute;
  top: 0;
  bottom: 0;
  right: 2px;
  margin: auto 0;
  width: 50px;
  height: 14px;
  background: var(--w95-caption-buttons) no-repeat center / 50px 14px;
  pointer-events: none;
}

/* Inactive window caption: solid gray face, silver text — the Windows Standard
   scheme's COLOR_INACTIVECAPTION / COLOR_INACTIVECAPTIONTEXT pair. Pressing a
   caption ACTIVATED that window in Win95, so the flip to navy (and the previous
   window's flip to gray) is the primary feedback of a drag. The drag runtime
   stamps data-w95-active on every tile of a win95 gallery when one is grabbed;
   a host app that owns its own window manager sets the same attribute. Tiles
   with no attribute stay active, so a gallery that is never touched reads as a
   deck of navy captions exactly as before. */
#arcane-root.arcane-theme-win95 [data-w95-active="false"] .win95-gallery-tile-header {
  background: var(--w95-title-inactive-a);
  --w95-title-text: var(--w95-title-inactive-text);
}

/* Real, accessible window caption. */
#arcane-root.arcane-theme-win95 .win95-gallery-tile-title {
  min-width: 0;
  font-weight: 700;
  font-size: 1.125rem;
  line-height: 1.15;
  color: var(--w95-title-text);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* Secondary caption (author / subtitle), dimmed on the caption bar. */
#arcane-root.arcane-theme-win95 .win95-gallery-tile-meta {
  min-width: 0;
  font-size: 1rem;
  line-height: 1.15;
  color: var(--w95-title-text);
  opacity: 0.78;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* Media = the window's client area, flush under the title bar (the base sizes
   it by aspect ratio and marks it position:relative so overlay badges anchor
   to it). */
#arcane-root.arcane-theme-win95 .win95-gallery-tile-media {
  background: var(--w95-field);
}

/* Footer = a raised status strip along the window's bottom edge. */
#arcane-root.arcane-theme-win95 .win95-gallery-tile-footer {
  padding: 3px 5px;
  background: var(--w95-face);
  color: var(--w95-face-text);
  box-shadow: var(--w95-raised-thin);
  font-size: 1rem;
}

/* ---------- Outline (wireframe) window drag ---------- */
/*
   Windows 95 moved a window by XOR-ing a wireframe of its bounds onto the
   screen: the window itself did not budge until the drop, when it repainted
   once at the new position. Full-content dragging ("show window contents while
   dragging") was an opt-in Plus! feature that only became the default in 98.
   The core gallery drag runtime switches to that model for any gallery inside
   this theme and parks this element on the pointer-tracked bounds; every other
   theme keeps the live full-content translate.

   mix-blend-mode: difference over a white frame reproduces the XOR inversion
   against whatever the outline crosses, and 4px is SM_CXFRAME — the sizing
   border Win95 drew the outline with. One outline exists at a time, it is not
   animated, and it leaves no trail. */
#arcane-root.arcane-theme-win95 .arcane-gallery-drag-outline {
  position: fixed;
  box-sizing: border-box;
  border: 4px solid #ffffff;
  background: transparent;
  border-radius: 0;
  mix-blend-mode: difference;
  pointer-events: none;
  z-index: 2147483000;
}

/* No hand cursors anywhere in the drag path: the core runtime's grab/grabbing
   pair is right for the modern themes and wrong for this one, where a drag was
   the plain arrow from press to release. */
#arcane-root.arcane-theme-win95 [data-arcane-gallery-draggable="true"] [data-arcane-drag-handle="true"],
#arcane-root.arcane-theme-win95 [data-arcane-gallery-draggable="true"] .is-arcane-gallery-dragging,
#arcane-root.arcane-theme-win95 [data-arcane-gallery-draggable="true"] .is-arcane-gallery-dragging [data-arcane-drag-handle="true"] {
  cursor: var(--w95-cursor-arrow);
}

/* Win95 held the capture for the whole move loop, so nothing else on the
   desktop reacted and nothing could be selected mid-drag. */
#arcane-root.arcane-theme-win95 [data-arcane-gallery-draggable="true"].is-arcane-gallery-drag-active,
#arcane-root.arcane-theme-win95 [data-arcane-gallery-draggable="true"].is-arcane-gallery-drag-active * {
  user-select: none;
  cursor: var(--w95-cursor-arrow);
}

/* Splitter grips take the matching resize double-arrow bitmap. The win95
   renderer already emits the token inline; the core renderer emits
   col-resize/row-resize, so reaching that markup needs !important. */
#arcane-root.arcane-theme-win95 .win95-resizable.horizontal .win95-resizable-handle,
#arcane-root.arcane-theme-win95 .arcane-resizable[data-direction="horizontal"] .arcane-resizable-handle {
  cursor: var(--w95-cursor-ew) !important;
}
#arcane-root.arcane-theme-win95 .win95-resizable.vertical .win95-resizable-handle,
#arcane-root.arcane-theme-win95 .arcane-resizable:not([data-direction="horizontal"]) .arcane-resizable-handle {
  cursor: var(--w95-cursor-ns) !important;
}

/* ---------- Feature / icon / pricing / testimonial cards ---------- */

#arcane-root.arcane-theme-win95 .win95-feature-card,
#arcane-root.arcane-theme-win95 .win95-icon-card,
#arcane-root.arcane-theme-win95 .win95-pricing-card,
#arcane-root.arcane-theme-win95 .win95-testimonial-card {
  background: var(--w95-face);
  color: var(--w95-face-text);
  border: none;
  border-radius: 0;
  box-shadow: var(--w95-raised);
  transition: none;
}
#arcane-root.arcane-theme-win95 a.win95-feature-card:active,
#arcane-root.arcane-theme-win95 .win95-feature-card.clickable:active,
#arcane-root.arcane-theme-win95 a.win95-icon-card:active,
#arcane-root.arcane-theme-win95 .win95-icon-card.clickable:active {
  box-shadow: var(--w95-pressed);
}

/* ---------- Dropdown / command / select items ---------- */

#arcane-root.arcane-theme-win95 .win95-dropdown-item,
#arcane-root.arcane-theme-win95 .win95-command-item,
#arcane-root.arcane-theme-win95 .win95-select-option {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.3rem 0.5rem;
  border-radius: 0;
  cursor: var(--w95-cursor-arrow);
  color: var(--w95-face-text);
  font-size: 1.219rem;
  transition: none;
}
#arcane-root.arcane-theme-win95 .win95-dropdown-item:hover,
#arcane-root.arcane-theme-win95 .win95-command-item:hover,
#arcane-root.arcane-theme-win95 .win95-command-item[aria-selected="true"],
#arcane-root.arcane-theme-win95 .win95-select-option:hover:not(:disabled):not(.disabled) {
  background: var(--w95-selection);
  color: var(--w95-selection-text);
}
#arcane-root.arcane-theme-win95 .win95-dropdown-label,
#arcane-root.arcane-theme-win95 .win95-command-group-heading {
  padding: 0.3rem 0.5rem;
  font-size: 1.125rem;
  font-weight: 700;
  color: var(--w95-face-text);
}
#arcane-root.arcane-theme-win95 .win95-dropdown-divider {
  height: 2px;
  background: transparent;
  box-shadow: inset 0 1px 0 var(--w95-shadow), inset 0 2px 0 var(--w95-hilite);
  margin: 0.3rem 0.1rem;
  border: none;
}

/* ---------- Inputs (sunken white wells) ---------- */

#arcane-root.arcane-theme-win95 .win95-text-input,
#arcane-root.arcane-theme-win95 .win95-select-trigger,
#arcane-root.arcane-theme-win95 .win95-command-input,
#arcane-root.arcane-theme-win95 .win95-select-search,
#arcane-root.arcane-theme-win95 .win95-otp-digit {
  width: 100%;
  background: var(--w95-field);
  color: var(--w95-field-text);
  border: none;
  border-radius: 0;
  box-shadow: var(--w95-sunken);
  padding: 0.3rem 0.4rem;
  font-family: var(--font-sans);
  font-size: 1.219rem;
  transition: none;
}

/* Text-entry color contract. Core ArcaneField controls carry generic inline
   theme colors, while bare native inputs can inherit browser color-scheme
   defaults. Pin every textual edit well to the Win95 field tokens so typed
   text, carets, and autofilled/WebKit text remain readable in both classic
   light mode and High Contrast Black. Non-text controls stay out of scope. */
#arcane-root.arcane-theme-win95
  :is(
    input.win95-text-input,
    input.win95-command-input,
    input.win95-select-search,
    input.win95-otp-digit,
    input.arcane-field-input,
    input:not([type]),
    input[type="text"],
    input[type="search"],
    input[type="email"],
    input[type="password"],
    input[type="url"],
    input[type="tel"],
    input[type="number"],
    input[type="date"],
    input[type="datetime-local"],
    input[type="time"],
    input[type="month"],
    input[type="week"],
    select.arcane-field-select,
    textarea
  ) {
  color: var(--w95-field-text) !important;
  background-color: var(--w95-field) !important;
  caret-color: var(--w95-field-text) !important;
  -webkit-text-fill-color: var(--w95-field-text) !important;
  opacity: 1 !important;
}

#arcane-root.arcane-theme-win95
  :is(
    input.win95-text-input,
    input.win95-command-input,
    input.win95-select-search,
    input.arcane-field-input,
    input:not([type]),
    input[type="text"],
    input[type="search"],
    input[type="email"],
    input[type="password"],
    input[type="url"],
    input[type="tel"],
    input[type="number"],
    textarea
  )::placeholder {
  color: var(--w95-field-placeholder) !important;
  -webkit-text-fill-color: var(--w95-field-placeholder) !important;
  opacity: 1 !important;
}

#arcane-root.arcane-theme-win95
  :is(
    input.win95-text-input,
    input.win95-command-input,
    input.win95-select-search,
    input.win95-otp-digit,
    input.arcane-field-input,
    input:not([type]),
    input[type="text"],
    input[type="search"],
    input[type="email"],
    input[type="password"],
    input[type="url"],
    input[type="tel"],
    input[type="number"],
    input[type="date"],
    input[type="datetime-local"],
    input[type="time"],
    input[type="month"],
    input[type="week"],
    select.arcane-field-select,
    textarea
  ):focus {
  outline: 1px dotted var(--w95-field-text) !important;
  outline-offset: -3px !important;
}

#arcane-root.arcane-theme-win95 .win95-otp-digit {
  width: 2.4rem;
  text-align: center;
  font-weight: 700;
}
#arcane-root.arcane-theme-win95 .win95-text-input::placeholder,
#arcane-root.arcane-theme-win95 .win95-command-input::placeholder {
  color: var(--w95-field-placeholder);
}
#arcane-root.arcane-theme-win95 .win95-text-input:focus,
#arcane-root.arcane-theme-win95 .win95-select-trigger:focus,
#arcane-root.arcane-theme-win95 .win95-command-input:focus,
#arcane-root.arcane-theme-win95 .win95-select-search:focus,
#arcane-root.arcane-theme-win95 .win95-otp-digit:focus {
  outline: 1px dotted var(--w95-field-text);
  outline-offset: -3px;
  box-shadow: var(--w95-sunken);
}
#arcane-root.arcane-theme-win95 .win95-select-trigger {
  cursor: var(--w95-cursor-arrow);
}
#arcane-root.arcane-theme-win95 .win95-select-label {
  color: var(--w95-face-text) !important;
  font-family: var(--font-sans) !important;
  font-size: 1rem !important;
  letter-spacing: normal !important;
  text-transform: none !important;
  margin-bottom: 0.3rem !important;
}
#arcane-root.arcane-theme-win95 .win95-text-input-wrapper {
  display: flex;
  flex-direction: column;
  gap: 0.3rem;
}
#arcane-root.arcane-theme-win95 .win95-text-input-error,
#arcane-root.arcane-theme-win95 .win95-select-error,
#arcane-root.arcane-theme-win95 .win95-radio-group-error {
  color: var(--destructive);
  font-size: 1.125rem;
}
#arcane-root.arcane-theme-win95.dark .win95-text-input-error,
#arcane-root.arcane-theme-win95.dark .win95-select-error,
#arcane-root.arcane-theme-win95.dark .win95-radio-group-error {
  color: var(--destructive);
}
#arcane-root.arcane-theme-win95 .win95-text-input-helper,
#arcane-root.arcane-theme-win95 .win95-select-helper,
#arcane-root.arcane-theme-win95 .win95-radio-group-helper {
  color: var(--w95-face-text);
  font-size: 1.125rem;
}
#arcane-root.arcane-theme-win95 .win95-select.error .win95-select-trigger,
#arcane-root.arcane-theme-win95 .win95-text-input[data-error="true"] {
  outline: 1px solid var(--destructive);
  outline-offset: -3px;
}

/* ---------- Checkbox / radio / toggle ---------- */

/* The Win95 check box is a 13x13 sunken well: a 2px bevel around a 9x9 field
   that centres the 7x7 tick with a whole pixel on every side. */
#arcane-root.arcane-theme-win95 .win95-checkbox-box {
  position: relative;
  width: 13px;
  height: 13px;
  border: none;
  border-radius: 0;
  background: var(--w95-field);
  box-shadow: var(--w95-sunken);
  transition: none;
}
#arcane-root.arcane-theme-win95 .win95-checkbox-box[data-arcane-state="selected"],
#arcane-root.arcane-theme-win95 input:checked + .win95-checkbox-box {
  background: var(--w95-field);
  box-shadow: var(--w95-sunken);
}
/* The tick is drawn geometry (--w95-check), not a character: U+2714 lands at a
   different weight, width and baseline in every font in the fallback stack,
   which is the same failure the window-control masks were introduced to end. */
#arcane-root.arcane-theme-win95 .win95-checkbox-box[data-state="checked"]::after,
#arcane-root.arcane-theme-win95 .win95-checkbox-box[data-arcane-state="selected"]::after,
#arcane-root.arcane-theme-win95 input:checked + .win95-checkbox-box::after {
  content: '';
  position: absolute;
  inset: 0;
  margin: auto;
  width: 7px;
  height: 7px;
  background-color: var(--w95-field-text);
  -webkit-mask-image: var(--w95-check);
  mask-image: var(--w95-check);
  -webkit-mask-repeat: no-repeat;
  mask-repeat: no-repeat;
  -webkit-mask-position: center;
  mask-position: center;
  -webkit-mask-size: 7px 7px;
  mask-size: 7px 7px;
}
/* A disabled check box fills its well with the button face and greys the
   tick; the caption is engraved with the other disabled labels below. */
#arcane-root.arcane-theme-win95 .win95-checkbox-box[data-disabled="true"] {
  background: var(--w95-face);
}
#arcane-root.arcane-theme-win95 .win95-checkbox-box[data-disabled="true"]::after {
  background-color: var(--w95-disabled-text);
}
#arcane-root.arcane-theme-win95 .win95-checkbox-wrapper[data-disabled="true"] span {
  color: inherit !important;
}

/* Bare native check boxes and radios (hosts that skip ArcaneCheckbox and
   ArcaneRadioGroup) take the same 13px well and 7x7 tick. The tick is seven
   1x2 columns in the field text colour, so it follows the scheme without a
   pseudo-element on the input. Switch-role inputs are left to their host. */
#arcane-root.arcane-theme-win95 input[type="checkbox"]:not([role="switch"]) {
  --w95-bare-well: var(--w95-field);
  --w95-bare-tick: var(--w95-field-text);
  appearance: none !important;
  -webkit-appearance: none !important;
  box-sizing: border-box !important;
  flex: 0 0 13px;
  width: 13px !important;
  height: 13px !important;
  padding: 0 !important;
  border: 0 !important;
  border-radius: 0 !important;
  background: var(--w95-bare-well) !important;
  box-shadow: var(--w95-sunken) !important;
  accent-color: auto !important;
}
#arcane-root.arcane-theme-win95 input[type="checkbox"]:not([role="switch"]):disabled {
  --w95-bare-well: var(--w95-face);
  --w95-bare-tick: var(--w95-disabled-text);
}
#arcane-root.arcane-theme-win95 input[type="checkbox"]:not([role="switch"]):checked {
  background:
    linear-gradient(var(--w95-bare-tick), var(--w95-bare-tick)) 3px 6px / 1px 2px no-repeat,
    linear-gradient(var(--w95-bare-tick), var(--w95-bare-tick)) 4px 7px / 1px 2px no-repeat,
    linear-gradient(var(--w95-bare-tick), var(--w95-bare-tick)) 5px 8px / 1px 2px no-repeat,
    linear-gradient(var(--w95-bare-tick), var(--w95-bare-tick)) 6px 7px / 1px 2px no-repeat,
    linear-gradient(var(--w95-bare-tick), var(--w95-bare-tick)) 7px 6px / 1px 2px no-repeat,
    linear-gradient(var(--w95-bare-tick), var(--w95-bare-tick)) 8px 5px / 1px 2px no-repeat,
    linear-gradient(var(--w95-bare-tick), var(--w95-bare-tick)) 9px 4px / 1px 2px no-repeat,
    var(--w95-bare-well) !important;
}
#arcane-root.arcane-theme-win95 input[type="checkbox"]:not([role="switch"]):focus-visible {
  outline: 1px dotted var(--w95-face-text) !important;
  outline-offset: 1px !important;
}
/* Win95 had no toggle switch — render it in-idiom: a sunken track with a raised
   square thumb that slides. */
#arcane-root.arcane-theme-win95 .win95-toggle-switch {
  position: relative;
  display: inline-flex;
  align-items: center;
  flex-shrink: 0;
  width: 2.6rem;
  height: 1.3rem;
  border: none;
  border-radius: 0;
  background: var(--w95-field);
  box-shadow: var(--w95-sunken);
  padding: 2px;
  cursor: var(--w95-cursor-arrow);
  transition: none;
}
#arcane-root.arcane-theme-win95 .win95-toggle-switch[data-arcane-state="selected"] {
  background: var(--w95-selection);
}
#arcane-root.arcane-theme-win95 .win95-toggle-switch[data-disabled="true"] {
  opacity: 0.5;
  cursor: var(--w95-cursor-arrow);
}
#arcane-root.arcane-theme-win95 .win95-toggle-thumb {
  width: 1.15rem;
  height: 1.05rem;
  border-radius: 0;
  background: var(--w95-face);
  box-shadow: var(--w95-raised);
  transition: none;
}
#arcane-root.arcane-theme-win95 .win95-toggle-switch[data-arcane-state="selected"] .win95-toggle-thumb {
  transform: translateX(1.15rem);
}

/* ---------- Tabs (raised notched folders) ---------- */

#arcane-root.arcane-theme-win95 .win95-tabs-list,
#arcane-root.arcane-theme-win95 .win95-tab-bar {
  display: inline-flex;
  gap: 0;
  padding: 0;
  background: transparent;
  border: none;
  border-radius: 0;
  box-shadow: none;
  position: relative;
  z-index: 1;
}
#arcane-root.arcane-theme-win95 .win95-tabs-trigger,
#arcane-root.arcane-theme-win95 .win95-tab-bar-item {
  padding: 0.35rem 0.85rem;
  border: none;
  border-radius: 0;
  background: var(--w95-face);
  color: var(--w95-face-text);
  box-shadow: var(--w95-raised);
  font-family: var(--font-sans);
  font-size: 1.219rem;
  font-weight: 400;
  cursor: var(--w95-cursor-arrow);
  margin-right: 2px;
  transition: none;
}
#arcane-root.arcane-theme-win95 .win95-tabs-trigger.active,
#arcane-root.arcane-theme-win95 .win95-tab-bar-item.active {
  background: var(--w95-face);
  color: var(--w95-face-text);
  padding: 0.45rem 0.95rem 0.35rem;
  position: relative;
  z-index: 2;
}
#arcane-root.arcane-theme-win95 .win95-tabs-content {
  padding: 1rem;
  background: var(--w95-face);
  box-shadow: var(--w95-raised);
  margin-top: -1px;
}

/* ---------- Alerts (message-box panels) ---------- */

#arcane-root.arcane-theme-win95 .win95-alert {
  display: flex;
  gap: 0.75rem;
  padding: 0.9rem 1rem;
  border-radius: 0;
  border: none;
  box-shadow: var(--w95-raised);
  background: var(--w95-face);
  color: var(--w95-face-text);
}
#arcane-root.arcane-theme-win95 .win95-alert[data-variant="destructive"] { color: var(--destructive); }
#arcane-root.arcane-theme-win95 .win95-alert[data-variant="success"] { color: var(--success); }
#arcane-root.arcane-theme-win95 .win95-alert[data-variant="warning"] { color: var(--warning); }
#arcane-root.arcane-theme-win95 .win95-alert[data-variant="info"] { color: var(--info); }
#arcane-root.arcane-theme-win95 .win95-alert-title { font-weight: 700; color: var(--w95-face-text); }
#arcane-root.arcane-theme-win95 .win95-alert-description { color: var(--w95-face-text); }
#arcane-root.arcane-theme-win95 .win95-alert-dismiss {
  margin-left: auto;
  background: var(--w95-face);
  box-shadow: var(--w95-raised);
  border: none;
  border-radius: 0;
  width: 1.1rem;
  height: 1.1rem;
  color: var(--w95-face-text);
  cursor: var(--w95-cursor-arrow);
}
#arcane-root.arcane-theme-win95 .win95-alert-dismiss:active { box-shadow: var(--w95-pressed); }

/* ---------- Badges / status (thin raised chips) ---------- */

#arcane-root.arcane-theme-win95 .win95-badge,
#arcane-root.arcane-theme-win95 .win95-status-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.35rem;
  padding: 0.1rem 0.5rem;
  border-radius: 0;
  font-size: 1.125rem;
  font-weight: 400;
  letter-spacing: 0;
  text-transform: none;
  border: none;
  box-shadow: var(--w95-raised-thin);
  background: var(--w95-face);
  color: var(--w95-face-text);
}
#arcane-root.arcane-theme-win95 .win95-status-indicator {
  width: 0.5rem;
  height: 0.5rem;
  border-radius: 0;
  background: currentColor;
  box-shadow: var(--w95-sunken-thin);
}
#arcane-root.arcane-theme-win95 .win95-status-label {
  font-weight: 700;
}

/* ---------- Progress (segmented sunken meter) ----------
   The trough's client area is the silver control face inside a sunken bevel,
   not the white edit-field colour: the gutters between the navy blocks read
   #c0c0c0 in every Win95 copy/install dialog. The bevel is the thin 1px one
   (#808080 top-left, white bottom-right), not the 2px edit-well recipe, and
   the 2px padding leaves a 1px face gutter inside it. */

#arcane-root.arcane-theme-win95 .win95-progress,
#arcane-root.arcane-theme-win95 .win95-progress-track {
  background: var(--w95-face);
  box-shadow: var(--w95-sunken-thin);
  border-radius: 0;
  overflow: hidden;
  padding: 2px;
  min-height: 1.1rem;
}
/* Fixed-pitch blocks anchored to the left inner edge: a 16px navy chunk on an
   18px stride, so the segment phase never drifts with the control's width.
   The fill width itself comes from the renderer as an inline percentage. */
#arcane-root.arcane-theme-win95 .win95-progress-indicator {
  height: 100%;
  min-height: 0.7rem;
  border-radius: 0;
  box-shadow: none;
  background-color: transparent;
  background-image: linear-gradient(
    90deg,
    var(--w95-selection) 0 16px,
    transparent 16px 18px
  );
  background-size: 18px 100%;
  background-repeat: repeat-x;
  transition: none;
}
/* Win95 had no marquee/indeterminate meter — that arrived with the XP-era
   common controls. Work of unknown length showed the hourglass, so the bar
   and its trough drop out and the hourglass takes their place. */
#arcane-root.arcane-theme-win95 .win95-progress-indicator.indeterminate {
  min-height: 26px;
  background-color: transparent;
  background-image: var(--w95-loader-image);
  background-size: 26px 26px;
  background-repeat: no-repeat;
  background-position: center;
  image-rendering: -moz-crisp-edges;
  image-rendering: crisp-edges;
  image-rendering: pixelated;
}
#arcane-root.arcane-theme-win95 .win95-progress:has(.win95-progress-indicator.indeterminate),
#arcane-root.arcane-theme-win95 .win95-progress-track:has(> .win95-progress-indicator.indeterminate) {
  background: transparent;
  box-shadow: none;
  padding: 0;
}
/* ---------- Group box (etched frame) ----------
   A Win95 group box is an ETCHED rectangle: a #808080 line with a white line
   one pixel inside it on the top and left edges, and one pixel outside it on
   the bottom and right. The border is the grey line; the inset shadow draws
   the inner white and the outer shadow the trailing white, so the frame keeps
   the fieldset's native legend gap. The caption sits on the dialog face with
   two pixels of face either side, which is what breaks the etched line. */
#arcane-root.arcane-theme-win95 fieldset,
#arcane-root.arcane-theme-win95 .win95-fieldset {
  margin: 0 1px 1px 0;
  padding: 6px 10px 10px;
  border: 1px solid var(--w95-shadow);
  border-radius: 0;
  box-shadow: inset 1px 1px 0 var(--w95-hilite), 1px 1px 0 var(--w95-hilite);
  color: var(--w95-face-text);
  min-width: 0;
}
#arcane-root.arcane-theme-win95 fieldset > legend,
#arcane-root.arcane-theme-win95 .win95-fieldset > legend {
  padding: 0 2px;
  background: var(--w95-face);
  color: var(--w95-face-text);
  font-weight: 400;
}

/* ---------- Misc components ---------- */

#arcane-root.arcane-theme-win95 .win95-avatar {
  border-radius: 0;
  border: none;
  box-shadow: var(--w95-raised-thin);
  overflow: hidden;
  background: var(--w95-face);
}
#arcane-root.arcane-theme-win95 .win95-avatar-status {
  border: 2px solid var(--w95-face);
  border-radius: 50%;
}
/* Etched groove separators. */
#arcane-root.arcane-theme-win95 .win95-separator {
  background: transparent;
  border: none;
}
#arcane-root.arcane-theme-win95 .win95-separator:not(.win95-separator-vertical) {
  height: 2px;
  width: 100%;
  box-shadow: inset 0 1px 0 var(--w95-shadow), inset 0 2px 0 var(--w95-hilite);
}
#arcane-root.arcane-theme-win95 .win95-separator-vertical {
  width: 2px;
  align-self: stretch;
  box-shadow: inset 1px 0 0 var(--w95-shadow), inset 2px 0 0 var(--w95-hilite);
}
#arcane-root.arcane-theme-win95 .win95-kbd {
  font-family: var(--font-mono);
  font-size: 1.2em;
  padding: 0.1rem 0.4rem;
  border: none;
  border-radius: 0;
  box-shadow: var(--w95-raised-thin);
  background: var(--w95-face);
  color: var(--w95-face-text);
}
#arcane-root.arcane-theme-win95 .win95-breadcrumb-separator {
  color: var(--w95-face-text);
}
#arcane-root.arcane-theme-win95 .win95-empty-state {
  text-align: center;
  padding: 2rem;
}
#arcane-root.arcane-theme-win95 .win95-empty-state-icon { color: var(--w95-disabled-text); }
#arcane-root.arcane-theme-win95 .win95-empty-state-title { font-weight: 700; }
#arcane-root.arcane-theme-win95 .win95-empty-state-description { color: var(--w95-face-text); }
#arcane-root.arcane-theme-win95 .win95-toast-title { font-weight: 700; }
#arcane-root.arcane-theme-win95 .win95-toast-description { color: var(--w95-face-text); }

/* Chunky beveled scrollbars are defined once, further down (search for
   "========== scrollbar =========="). An earlier copy of the block used to sit
   here and was entirely dead — the later one wins on source order and carries
   !important on every declaration — so the two definitions disagreed about the
   track dither with no way to tell which was in effect. */

/* ---------- Sidebar + scaffold chrome ---------- */

#arcane-root.arcane-theme-win95 .win95-sidebar {
  background: var(--w95-face);
  border: none;
  box-shadow: inset -1px 0 0 var(--w95-hilite), inset -2px 0 0 var(--w95-shadow);
}
#arcane-root.arcane-theme-win95 .win95-sidebar-group-label {
  letter-spacing: 0;
  text-transform: none;
  font-size: 1.125rem;
  font-weight: 700;
  color: var(--w95-face-text);
}
#arcane-root.arcane-theme-win95 .win95-sidebar-separator {
  height: 2px;
  background: transparent;
  box-shadow: inset 0 1px 0 var(--w95-shadow), inset 0 2px 0 var(--w95-hilite);
}

/* ---------- Scaffold chrome (Windows 95 desktop reframe) ---------- */
/* The real ArcaneScaffold title, navigation, actions, sidebars, and footer stay
   in the DOM and receive Win95 chrome here. Static pseudo-element taskbars,
   clocks, menus, and caption buttons are intentionally absent: controls that
   look actionable must be backed by real elements and behavior. */

/* --- Teal desktop backdrop --- */
/* The arrow is the shell's ground state, not a per-control opt-in: the desktop,
   the maximized window, its caption and its whole client area all showed it.
   `cursor` inherits, so this single declaration dresses the entire subtree and
   the handful of genuine exceptions (edit wells take the I-beam, busy regions
   the hourglass, splitters the resize double-arrows, hypertext the IE hand)
   override it further down. A `*` selector here would defeat those. */
#arcane-root.arcane-theme-win95 {
  background: var(--w95-desktop);
  min-height: 100vh;
  cursor: var(--w95-cursor-arrow);
}

/* Form controls carry `cursor: default` in the UA sheet, which beats the
   inherited value above, so they have to name the arrow themselves. Text-entry
   inputs are deliberately absent: they take the I-beam further down. */
#arcane-root.arcane-theme-win95 button,
#arcane-root.arcane-theme-win95 summary,
#arcane-root.arcane-theme-win95 label,
#arcane-root.arcane-theme-win95 input[type="checkbox"],
#arcane-root.arcane-theme-win95 input[type="radio"],
#arcane-root.arcane-theme-win95 input[type="button"],
#arcane-root.arcane-theme-win95 input[type="submit"],
#arcane-root.arcane-theme-win95 input[type="reset"],
#arcane-root.arcane-theme-win95 input[type="range"],
#arcane-root.arcane-theme-win95 input[type="color"],
#arcane-root.arcane-theme-win95 input[type="file"] {
  cursor: var(--w95-cursor-arrow);
}

/* Hypertext is the one place the hand belongs. It was never a shell cursor —
   IE brought it, and only for links inside a document — so it is scoped to
   unadorned anchors and prose links, never to anchors dressed as buttons,
   cards, tiles, or navigation chrome, which all stayed on the arrow. */
#arcane-root.arcane-theme-win95 a[href]:not([class]),
#arcane-root.arcane-theme-win95 .prose a[href],
#arcane-root.arcane-theme-win95 .kb-landing-prose a[href] {
  cursor: var(--w95-cursor-hand);
}

/* Shift+hover coordinate picking on maps: the core script marks the element,
   the theme supplies IDC_CROSS instead of the host OS crosshair. */
#arcane-root.arcane-theme-win95 .arcane-map-picking {
  cursor: var(--w95-cursor-crosshair) !important;
}

/* Unscoped core chrome that hard-codes the hand. These are controls — a copy
   button, a theme switch, an Explorer-style tree header — and every one of
   them was arrow territory in Win95. */
#arcane-root.arcane-theme-win95 .code-copy-button,
#arcane-root.arcane-theme-win95 .sidebar-theme-toggle,
#arcane-root.arcane-theme-win95 .sidebar-summary {
  cursor: var(--w95-cursor-arrow);
}

/* --- The maximized application window --- */
#arcane-root.arcane-theme-win95 .arcane-scaffold {
  position: relative;
  min-height: calc(100vh - 4px) !important;
  margin: 2px !important;
  display: flex !important;
  flex-direction: column !important;
  padding: 2px !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-window-frame);
  font-size: 16.5px;
}

/* --- Title bar (the outer scaffold header becomes the window caption) --- */
#arcane-root.arcane-theme-win95 .arcane-scaffold-header {
  position: relative !important;
  top: auto !important;
  left: auto !important;
  right: auto !important;
  z-index: auto !important;
  height: auto !important;
  min-height: 0 !important;
  margin: 0 0 1px !important;
  padding: 0 !important;
  display: flex !important;
  flex-wrap: wrap !important;
  align-items: center !important;
  gap: 0 !important;
  border: 0 !important;
  background: var(--w95-face) !important;
  box-shadow: none !important;
  backdrop-filter: none !important;
  -webkit-backdrop-filter: none !important;
}

/* Real scaffold title as the navy caption bar + 16x16 window icon. */
#arcane-root.arcane-theme-win95 .arcane-scaffold-title {
  box-sizing: border-box !important;
  flex: 1 0 100% !important;
  min-width: 0 !important;
  width: 100% !important;
  height: 20px !important;
  margin: 0 !important;
  padding: 0 6px 0 22px !important;
  font-weight: 700 !important;
  font-size: 16.5px !important;
  line-height: 20px !important;
  color: var(--w95-title-text) !important;
  white-space: nowrap !important;
  overflow: hidden !important;
  text-overflow: ellipsis !important;
  background:
    url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16'%3E%3Crect x='1' y='2' width='14' height='12' fill='%23ffffff' stroke='%23000000'/%3E%3Crect x='2' y='3' width='12' height='3' fill='%23000080'/%3E%3Crect x='3' y='8' width='10' height='1' fill='%23808080'/%3E%3Crect x='3' y='10' width='10' height='1' fill='%23808080'/%3E%3C/svg%3E") 3px center / 16px 16px no-repeat,
    var(--w95-title-bar) !important;
}

/* --- Menu bar + toolbar (the inner kb-topbar) --- */
#arcane-root.arcane-theme-win95 .kb-topbar,
#arcane-root.arcane-theme-win95 .arcane-scaffold-header .kb-topbar {
  display: block !important;
  position: static !important;
  top: auto !important;
  z-index: auto;
  border: 0 !important;
  border-radius: 0 !important;
  background: var(--w95-face) !important;
  box-shadow: none !important;
  backdrop-filter: none !important;
  -webkit-backdrop-filter: none !important;
}

#arcane-root.arcane-theme-win95 .kb-topbar::after {
  content: none;
}

#arcane-root.arcane-theme-win95 .kb-topbar.kb-topbar-bottom {
  box-shadow: inset 0 1px 0 var(--w95-hilite) !important;
}

/* Raised toolbar strip holding the live controls. */
#arcane-root.arcane-theme-win95 .kb-topbar-inner {
  display: flex !important;
  align-items: center;
  width: 100%;
  max-width: none;
  height: auto;
  min-height: 30px;
  padding: 3px 4px;
  gap: 3px;
  background: var(--w95-face);
  box-shadow: var(--w95-raised-thin);
}

#arcane-root.arcane-theme-win95 .kb-topbar-left,
#arcane-root.arcane-theme-win95 .kb-topbar-right {
  min-width: 0;
  gap: 3px;
  padding: 0;
  border: 0;
  border-radius: 0;
  background: transparent;
}

#arcane-root.arcane-theme-win95 .kb-topbar-left {
  flex: 1 1 auto;
}

#arcane-root.arcane-theme-win95 .kb-topbar-right {
  flex: 0 1 auto;
}

#arcane-root.arcane-theme-win95 .kb-topbar-nav {
  min-width: 0;
  margin-left: 2px;
  padding: 0;
  gap: 2px;
  border: 0;
  border-radius: 0;
  background: transparent;
}

/* Toolbar brand -> the Start button: a raised silver face carrying the
   waving four-pane flag and the bold site name. It presses in on :active
   (bevel inverts, contents nudge 1px down-right) and, being the brand
   link, still navigates to the homepage. */
#arcane-root.arcane-theme-win95 .kb-topbar-brand {
  height: 22px;
  padding: 0 8px 0 5px;
  gap: 5px;
  border: 0;
  border-radius: 0;
  background: var(--w95-face);
  color: var(--w95-face-text);
  box-shadow: var(--w95-raised);
  font-size: 16.5px;
  font-weight: 700;
  line-height: 1;
  text-decoration: none;
  text-shadow: none;
  cursor: var(--w95-cursor-arrow);
}

/* Win95 reacts on press, not hover: keep the raised face, no fade. */
#arcane-root.arcane-theme-win95 .kb-topbar-brand:hover {
  opacity: 1;
  background: var(--w95-face);
  box-shadow: var(--w95-raised);
}

#arcane-root.arcane-theme-win95 .kb-topbar-brand:active {
  box-shadow: var(--w95-pressed);
}

#arcane-root.arcane-theme-win95 .kb-topbar-brand:active::before,
#arcane-root.arcane-theme-win95 .kb-topbar-brand:active .kb-topbar-brand-label {
  transform: translate(1px, 1px);
}

/* The waving flag, drawn as a pseudo so it renders for both the
   initial-span and logo-img brand variants (both stay hidden below). */
#arcane-root.arcane-theme-win95 .kb-topbar-brand::before {
  content: "";
  flex: 0 0 auto;
  width: 16px;
  height: 16px;
  background: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16'%3E%3Cpath fill='%23ff0000' d='M2 3 7 2v5H2z'/%3E%3Cpath fill='%2300a800' d='M8 2 14 3v4H8z'/%3E%3Cpath fill='%230000ff' d='M2 8h5v5l-5-1z'/%3E%3Cpath fill='%23ffff00' d='M8 8h6v4l-6 1z'/%3E%3C/svg%3E") center / 16px 16px no-repeat;
}

/* HCB dark: pure-blue sinks into the #3a3a3a face; brighten that pane. */
#arcane-root.arcane-theme-win95.dark .kb-topbar-brand::before {
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16'%3E%3Cpath fill='%23ff0000' d='M2 3 7 2v5H2z'/%3E%3Cpath fill='%2300a800' d='M8 2 14 3v4H8z'/%3E%3Cpath fill='%234a6cff' d='M2 8h5v5l-5-1z'/%3E%3Cpath fill='%23ffff00' d='M8 8h6v4l-6 1z'/%3E%3C/svg%3E");
}

#arcane-root.arcane-theme-win95 .kb-topbar-brand-icon,
#arcane-root.arcane-theme-win95 .kb-topbar-logo {
  display: none;
}

#arcane-root.arcane-theme-win95 .kb-topbar-brand-label {
  color: var(--w95-face-text);
}

/* Top-bar nav links behave like flat menu entries: navy bar on hover/active,
   no sliding underline, no neon glow. */
#arcane-root.arcane-theme-win95 .kb-topbar-link {
  position: relative;
  height: 22px;
  display: inline-flex;
  align-items: center;
  padding: 0 8px;
  border: 0;
  border-radius: 0;
  background: transparent;
  color: var(--w95-face-text);
  box-shadow: none;
  font-size: 16.5px;
  font-weight: 400;
  line-height: 1;
  text-decoration: none;
  text-shadow: none;
}

#arcane-root.arcane-theme-win95 .kb-topbar-link:hover,
#arcane-root.arcane-theme-win95 .kb-topbar-link.active {
  background: var(--w95-selection);
  color: var(--w95-selection-text);
  text-shadow: none;
  box-shadow: none;
}

#arcane-root.arcane-theme-win95 .kb-topbar-link.active {
  font-weight: 400;
}

#arcane-root.arcane-theme-win95 .kb-topbar-link::after,
#arcane-root.arcane-theme-win95 .kb-topbar-link.active::after {
  content: none !important;
  display: none !important;
}

#arcane-root.arcane-theme-win95 .kb-style-switcher {
  flex: 0 0 auto;
  flex-wrap: nowrap;
  gap: 3px;
  background: transparent;
}

/* Toolbar buttons: raised silver faces that press in on :active. */
#arcane-root.arcane-theme-win95 .kb-topbar-github,
#arcane-root.arcane-theme-win95 .kb-theme-toggle,
#arcane-root.arcane-theme-win95 .kb-stylesheet-select,
#arcane-root.arcane-theme-win95 .kb-palette-select,
#arcane-root.arcane-theme-win95 .kb-hamburger {
  height: 22px;
  min-height: 22px;
  border: 0;
  border-radius: 0;
  background: var(--w95-face);
  color: var(--w95-face-text);
  box-shadow: var(--w95-raised);
  font-size: 16.5px;
}

#arcane-root.arcane-theme-win95 .kb-topbar-github,
#arcane-root.arcane-theme-win95 .kb-theme-toggle,
#arcane-root.arcane-theme-win95 .kb-hamburger {
  width: 22px;
  padding: 0;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

#arcane-root.arcane-theme-win95 .kb-stylesheet-select,
#arcane-root.arcane-theme-win95 .kb-palette-select {
  /* A native <select> renders its value in the macOS system font (appearance
     auto makes the control ignore the theme font, and <select> does not inherit
     font-family). Strip the native chrome and force the pixel font + a Win95
     dropdown arrow. background-image is !important so the hover/active background
     shorthand cannot wipe the arrow. */
  appearance: none;
  -webkit-appearance: none;
  font-family: "Pixelated MS Sans Serif", "MS Sans Serif", "Microsoft Sans Serif", Tahoma, "Segoe UI", sans-serif;
  font-weight: 400;
  padding: 0 15px 0 4px;
  background-image: url("data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' width='7' height='4' viewBox='0 0 7 4'><path fill='%23000000' d='M0 0 L7 0 L3.5 4 Z'/></svg>") !important;
  background-repeat: no-repeat !important;
  background-position: right 4px center !important;
}
/* Dark-mode dropdown arrow: white on the dark face. */
#arcane-root.arcane-theme-win95.dark .kb-stylesheet-select,
#arcane-root.arcane-theme-win95.dark .kb-palette-select {
  background-image: url("data:image/svg+xml,<svg xmlns='http://www.w3.org/2000/svg' width='7' height='4' viewBox='0 0 7 4'><path fill='%23ffffff' d='M0 0 L7 0 L3.5 4 Z'/></svg>") !important;
}

#arcane-root.arcane-theme-win95 .kb-topbar-github:active,
#arcane-root.arcane-theme-win95 .kb-theme-toggle:active,
#arcane-root.arcane-theme-win95 .kb-stylesheet-select:active,
#arcane-root.arcane-theme-win95 .kb-palette-select:active,
#arcane-root.arcane-theme-win95 .kb-hamburger:active {
  background: var(--w95-face);
  box-shadow: var(--w95-pressed);
}

/* Win95 controls react on press, not hover -- neutralize the neon hover tint. */
#arcane-root.arcane-theme-win95 .kb-topbar-github:hover,
#arcane-root.arcane-theme-win95 .kb-theme-toggle:hover,
#arcane-root.arcane-theme-win95 .kb-stylesheet-select:hover,
#arcane-root.arcane-theme-win95 .kb-palette-select:hover,
#arcane-root.arcane-theme-win95 .kb-hamburger:hover {
  background: var(--w95-face);
  border: 0;
}

#arcane-root.arcane-theme-win95 .kb-theme-toggle .theme-icon-light,
#arcane-root.arcane-theme-win95 .kb-theme-toggle .theme-icon-dark {
  color: var(--w95-face-text);
}

#arcane-root.arcane-theme-win95 .kb-topbar .kb-hamburger {
  display: none !important;
}

@media (max-width: 900px) {
  #arcane-root.arcane-theme-win95 .kb-topbar .kb-hamburger {
    display: inline-flex !important;
  }
}

/* --- Search box: a sunken white field, no focus glow --- */
#arcane-root.arcane-theme-win95 .kb-search {
  background: transparent;
}

#arcane-root.arcane-theme-win95 .kb-search-input,
#arcane-root.arcane-theme-win95 .sidebar-search input {
  height: 22px;
  padding: 3px 4px;
  border: 0 !important;
  border-radius: 0 !important;
  background: var(--w95-field) !important;
  color: var(--w95-field-text) !important;
  box-shadow: var(--w95-sunken) !important;
  font-size: 16.5px;
}

#arcane-root.arcane-theme-win95 .kb-search-input:focus,
#arcane-root.arcane-theme-win95 .sidebar-search input:focus {
  border: 0 !important;
  outline: none !important;
  background: var(--w95-field) !important;
  box-shadow: var(--w95-sunken) !important;
}

#arcane-root.arcane-theme-win95 .kb-search-input::selection {
  background: var(--w95-selection);
  color: var(--w95-selection-text);
}

#arcane-root.arcane-theme-win95 .kb-search-icon {
  color: var(--w95-disabled-text);
}

/* Autocomplete results: a raised silver panel with a single hard drop offset. */
#arcane-root.arcane-theme-win95 .search-results {
  border: 0 !important;
  border-radius: 0 !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-raised) !important;
}

/* --- Body grid + Explorer sidebar well + main client --- */
#arcane-root.arcane-theme-win95 .arcane-scaffold-body {
  display: grid !important;
  align-items: stretch !important;
  gap: 3px !important;
  padding: 3px !important;
  background: var(--w95-face) !important;
  overflow: visible !important;
}

#arcane-root.arcane-theme-win95
  .arcane-scaffold-body:not([data-has-sidebar]):not([data-has-secondary]) {
  grid-template-columns: minmax(0, 1fr) !important;
}

#arcane-root.arcane-theme-win95
  .arcane-scaffold-body[data-has-sidebar]:not([data-has-secondary]) {
  grid-template-columns: minmax(13rem, 16rem) minmax(0, 1fr) !important;
}

#arcane-root.arcane-theme-win95
  .arcane-scaffold-body:not([data-has-sidebar])[data-has-secondary] {
  grid-template-columns: minmax(0, 1fr) minmax(13rem, 18rem) !important;
}

#arcane-root.arcane-theme-win95
  .arcane-scaffold-body[data-has-sidebar][data-has-secondary] {
  grid-template-columns:
    minmax(13rem, 16rem) minmax(0, 1fr)
    minmax(13rem, 18rem) !important;
}

/* Sidebar cell = sunken white Explorer well (fills the column height). */
#arcane-root.arcane-theme-win95 .arcane-scaffold-sidebar {
  border: 0 !important;
  background: var(--w95-field) !important;
  box-shadow: var(--w95-sunken) !important;
  overflow: visible !important;
}

#arcane-root.arcane-theme-win95 .arcane-scaffold-sidebar.arcane-scaffold-sidebar {
  position: static !important;
  top: auto !important;
  left: auto !important;
  right: auto !important;
  bottom: auto !important;
  align-self: stretch !important;
  width: auto !important;
  height: auto !important;
  max-height: none !important;
  min-height: 0 !important;
  border: 0 !important;
  padding: 0 !important;
  overflow: visible !important;
}

#arcane-root.arcane-theme-win95 .arcane-scaffold-main.arcane-scaffold-main {
  min-width: 0 !important;
  width: 100% !important;
  max-width: none !important;
  min-height: 0 !important;
  align-self: stretch !important;
  margin: 0 !important;
  padding: 0 !important;
  border: 0 !important;
  background: transparent !important;
  overflow: visible !important;
}

/* KB structural wrappers stay transparent -- the scaffold layer draws the frame. */
#arcane-root.arcane-theme-win95 .kb-page-shell,
#arcane-root.arcane-theme-win95 .kb-scaffold,
#arcane-root.arcane-theme-win95 .kb-layout-body,
#arcane-root.arcane-theme-win95 .kb-style-slot {
  background: transparent;
  box-shadow: none;
}

/* Inner sidebar: the scrolling tree rail, pinned below the chrome. */
#arcane-root.arcane-theme-win95 .kb-sidebar,
#arcane-root.arcane-theme-win95 .arcane-scaffold-sidebar .kb-sidebar {
  position: sticky !important;
  top: 6px !important;
  width: 100% !important;
  height: max-content !important;
  max-height: calc(100vh - 44px) !important;
  min-height: 0 !important;
  padding: 4px !important;
  background: transparent !important;
  border: 0 !important;
  box-shadow: none !important;
  overflow-y: auto !important;
  color: var(--w95-face-text);
  font-size: 16.5px;
  line-height: 16px;
}

#arcane-root.arcane-theme-win95 .kb-sidebar-panel {
  min-height: 0 !important;
  background: transparent;
}

/* Optional sidebar header (brand block) as a small raised group. */
#arcane-root.arcane-theme-win95 .sidebar-header {
  margin: 0 0 4px !important;
  padding: 4px !important;
  border: 0 !important;
  border-radius: 0 !important;
  background: var(--w95-face) !important;
  box-shadow: var(--w95-raised-thin) !important;
}

#arcane-root.arcane-theme-win95 .sidebar-brand-title {
  color: var(--w95-face-text);
  font-weight: 700;
}

#arcane-root.arcane-theme-win95 .sidebar-brand-subtitle {
  color: var(--w95-disabled-text);
}

#arcane-root.arcane-theme-win95 .sidebar-controls {
  gap: 3px;
}

#arcane-root.arcane-theme-win95 .sidebar-nav {
  padding: 2px !important;
  gap: 1px !important;
}

#arcane-root.arcane-theme-win95 .sidebar-section {
  margin-bottom: 2px;
}

/* Plain bold folder-group labels (no modern uppercase tracking). */
#arcane-root.arcane-theme-win95 .sidebar-section-header {
  padding: 2px 4px;
  color: var(--w95-face-text);
  font-size: 16.5px;
  font-weight: 700;
  letter-spacing: 0;
  text-transform: none;
}

#arcane-root.arcane-theme-win95 .sidebar-chevron,
#arcane-root.arcane-theme-win95 .sidebar-chevron-icon,
#arcane-root.arcane-theme-win95 .sidebar-icon,
#arcane-root.arcane-theme-win95 .sidebar-icon-svg {
  color: var(--w95-face-text);
}

/* Tree rows: black text, sharp, selection-driven (not hover-driven). */
#arcane-root.arcane-theme-win95 .sidebar-summary,
#arcane-root.arcane-theme-win95 .sidebar-link {
  border-radius: 0;
  color: var(--w95-face-text);
  outline: 0;
  padding-top: 1px;
  padding-bottom: 1px;
  font-size: 16.5px;
  line-height: 16px;
}

#arcane-root.arcane-theme-win95 .sidebar-summary:hover,
#arcane-root.arcane-theme-win95 .sidebar-details[open] > .sidebar-summary,
#arcane-root.arcane-theme-win95 .sidebar-link:hover {
  background: transparent;
  color: var(--w95-face-text);
  outline: 0;
}

#arcane-root.arcane-theme-win95 .sidebar-link.active {
  background: var(--w95-selection);
  color: var(--w95-selection-text);
  outline: 1px dotted var(--w95-hilite);
  outline-offset: -3px;
  text-shadow: none;
  box-shadow: none;
}

#arcane-root.arcane-theme-win95 .sidebar-link.active .sidebar-icon,
#arcane-root.arcane-theme-win95 .sidebar-link.active .sidebar-icon-svg {
  color: var(--w95-selection-text);
}

/* Explorer connector lines: a dotted vertical trunk (background) plus a short
   dotted horizontal elbow per row (re-enabling the guides the flat theme hid). */
#arcane-root.arcane-theme-win95 .sidebar-tree {
  position: relative;
  padding-left: 14px !important;
  margin-left: 6px !important;
  margin-top: 0 !important;
  gap: 0 !important;
  background:
    repeating-linear-gradient(to bottom, var(--w95-shadow) 0 1px, transparent 1px 2px)
    left 4px top 0 / 1px 100% no-repeat;
}

#arcane-root.arcane-theme-win95 .sidebar-tree-item {
  position: relative;
}

#arcane-root.arcane-theme-win95 .sidebar-tree-item::before {
  content: "";
  display: block;
  position: absolute;
  left: -10px;
  top: 9px;
  width: 8px;
  height: 0;
  border-top: 1px dotted var(--w95-shadow);
}

#arcane-root.arcane-theme-win95 .sidebar-tree-item::after {
  content: none;
}

/* --- Main content: a raised "document window" with a navy caption --- */
#arcane-root.arcane-theme-win95 .kb-main-area {
  min-width: 0 !important;
  width: 100% !important;
  background: transparent !important;
  overflow: visible !important;
}

#arcane-root.arcane-theme-win95 .kb-content-area {
  position: relative;
  display: grid !important;
  grid-template-columns: minmax(0, 1fr) !important;
  align-items: start !important;
  width: 100% !important;
  max-width: none !important;
  margin: 0 !important;
  gap: 12px !important;
  padding: 12px !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-raised) !important;
}

@media (min-width: 1201px) {
  #arcane-root.arcane-theme-win95 .kb-content-area:has(.kb-toc-panel) {
    grid-template-columns: minmax(0, 1fr) minmax(12rem, 15rem) !important;
  }
}

/* The article body = a sunken white page inside the document window. */
#arcane-root.arcane-theme-win95 .kb-article-panel {
  min-width: 0 !important;
  width: 100% !important;
  max-width: 68rem !important;
  margin-left: auto !important;
  margin-right: auto !important;
  padding: 16px 20px 20px !important;
  background: var(--w95-field) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-sunken) !important;
}

#arcane-root.arcane-theme-win95 .kb-landing-page {
  background: var(--w95-field) !important;
  color: var(--w95-face-text) !important;
}

/* Keep all reading text solidly black on the white page. */
#arcane-root.arcane-theme-win95 .kb-article-panel .prose,
#arcane-root.arcane-theme-win95 .kb-page-title,
#arcane-root.arcane-theme-win95 .kb-page-description,
#arcane-root.arcane-theme-win95 .kb-tags-footer-label {
  color: var(--w95-face-text) !important;
}

/* Breadcrumbs styled as an Explorer address strip. */
#arcane-root.arcane-theme-win95 .kb-breadcrumbs {
  margin-bottom: 12px;
  padding: 3px 6px;
  background: var(--w95-field);
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-sunken-thin);
}

#arcane-root.arcane-theme-win95 .kb-page-metadata,
#arcane-root.arcane-theme-win95 .kb-tags-footer {
  border-color: var(--w95-disabled-text) !important;
  color: var(--w95-face-text) !important;
}

#arcane-root.arcane-theme-win95 .kb-page-metadata-item {
  /* --w95-shadow is a bevel colour (#808080 light / near-black dark) -> unreadable
     as text in dark mode. Use the theme-aware muted text token instead. */
  color: var(--muted-foreground) !important;
}

/* Pagination cards = raised silver buttons. */
#arcane-root.arcane-theme-win95 .kb-page-nav {
  border-top: 1px solid var(--w95-shadow);
}

#arcane-root.arcane-theme-win95 .kb-page-nav-link {
  padding: 8px 10px !important;
  border: 0 !important;
  border-radius: 0 !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-raised) !important;
}

#arcane-root.arcane-theme-win95 .kb-page-nav-link:active {
  box-shadow: var(--w95-pressed) !important;
}

/* --- Table of contents = a sunken "Contents" panel --- */
#arcane-root.arcane-theme-win95 .kb-toc-panel {
  position: sticky !important;
  top: 34px !important;
  align-self: flex-start !important;
  width: 100% !important;
  max-height: calc(100vh - 72px) !important;
  padding: 8px !important;
  background: var(--w95-field) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-sunken) !important;
  overflow: auto !important;
}

#arcane-root.arcane-theme-win95 .kb-toc-panel .toc {
  padding: 0;
  border: 0 !important;
  border-radius: 0 !important;
  background: transparent !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-win95 .kb-toc-panel .toc-title {
  border-bottom: 1px solid var(--w95-shadow) !important;
  padding-bottom: 3px;
  margin-bottom: 6px;
  color: var(--w95-face-text);
  font-weight: 700;
}

#arcane-root.arcane-theme-win95 .toc-content {
  color: var(--w95-face-text);
}

#arcane-root.arcane-theme-win95 .toc-content a {
  border-radius: 0;
  background: transparent;
  color: var(--w95-face-text);
}

#arcane-root.arcane-theme-win95 .toc-content a:hover,
#arcane-root.arcane-theme-win95 .toc-content a.toc-active {
  background: var(--w95-selection);
  color: var(--w95-selection-text);
}

#arcane-root.arcane-theme-win95 .toc-content > ul > li::before,
#arcane-root.arcane-theme-win95 .toc-content > ul > li::after,
#arcane-root.arcane-theme-win95 .toc-content ul ul li::before,
#arcane-root.arcane-theme-win95 .toc-content ul ul li::after {
  background: var(--w95-shadow) !important;
}

/* --- Demo panels = beveled Win95 boxes (raised frame, sunken wells) --- */
#arcane-root.arcane-theme-win95 .kb-demo-shell {
  background: transparent;
}

#arcane-root.arcane-theme-win95 .arcane-demo-panel {
  padding: 10px !important;
  border: 0 !important;
  border-radius: 0 !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-raised) !important;
}

#arcane-root.arcane-theme-win95 .arcane-demo-preview-scope,
#arcane-root.arcane-theme-win95 .arcane-demo-code {
  border: 0 !important;
  border-radius: 0 !important;
  background: var(--w95-field) !important;
  box-shadow: var(--w95-sunken) !important;
}

#arcane-root.arcane-theme-win95 .arcane-demo-preview-scope {
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
}

#arcane-root.arcane-theme-win95 .arcane-demo-preview-scope > .arcane-box {
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
}

#arcane-root.arcane-theme-win95 .arcane-demo-kicker,
#arcane-root.arcane-theme-win95 .arcane-demo-code-label {
  /* Readable in both modes -- --w95-shadow goes near-black on the dark panel. */
  color: var(--muted-foreground) !important;
}

#arcane-root.arcane-theme-win95 .arcane-demo-section-title {
  color: var(--w95-face-text) !important;
}

#arcane-root.arcane-theme-win95 .kb-missing-demo,
#arcane-root.arcane-theme-win95 .arcane-demo-missing {
  border: 0 !important;
  border-radius: 0 !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-raised) !important;
}

#arcane-root.arcane-theme-win95 .kb-missing-demo-icon,
#arcane-root.arcane-theme-win95 .arcane-demo-missing-icon {
  border: 0 !important;
  border-radius: 0 !important;
  background: var(--w95-field) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-sunken-thin) !important;
}

#arcane-root.arcane-theme-win95 .kb-missing-demo-title,
#arcane-root.arcane-theme-win95 .arcane-demo-missing-title {
  color: var(--w95-face-text) !important;
}

#arcane-root.arcane-theme-win95 .kb-missing-demo-body,
#arcane-root.arcane-theme-win95 .arcane-demo-missing-body {
  color: var(--w95-disabled-text) !important;
}

/* --- Landing chrome: beveled panels, no gradients / glow --- */
#arcane-root.arcane-theme-win95 .kb-landing-hero {
  padding: 16px;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-raised);
}

#arcane-root.arcane-theme-win95 .kb-landing-prose {
  display: grid;
  gap: 16px;
}

#arcane-root.arcane-theme-win95 .kb-landing-prose > * + * {
  margin-top: 0;
}

#arcane-root.arcane-theme-win95 .kb-landing-grid {
  gap: 12px;
  margin-top: 16px;
  margin-bottom: 16px;
}

#arcane-root.arcane-theme-win95 .kb-landing-band {
  gap: 16px;
  margin-top: 16px;
  padding: 16px;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-raised);
}

#arcane-root.arcane-theme-win95 .kb-landing-terminal-body,
#arcane-root.arcane-theme-win95 .kb-landing-list {
  gap: 12px;
}

#arcane-root.arcane-theme-win95 .kb-landing-card {
  border: 0 !important;
  border-radius: 0 !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-raised) !important;
}

/* Cards are not buttons -- no press/hover state change. */
#arcane-root.arcane-theme-win95 .kb-landing-card:hover {
  border: 0 !important;
  box-shadow: var(--w95-raised) !important;
}

/* --- Responsive collapse --- */
@media (max-width: 1200px) {
  #arcane-root.arcane-theme-win95 .kb-content-area {
    grid-template-columns: minmax(0, 1fr) !important;
  }

  #arcane-root.arcane-theme-win95 .kb-toc-panel {
    display: none !important;
  }
}

@media (max-width: 900px) {
  #arcane-root.arcane-theme-win95
    .arcane-scaffold-body:not([data-has-sidebar]):not([data-has-secondary]),
  #arcane-root.arcane-theme-win95
    .arcane-scaffold-body[data-has-sidebar]:not([data-has-secondary]),
  #arcane-root.arcane-theme-win95
    .arcane-scaffold-body:not([data-has-sidebar])[data-has-secondary],
  #arcane-root.arcane-theme-win95
    .arcane-scaffold-body[data-has-sidebar][data-has-secondary] {
    grid-template-columns: minmax(0, 1fr) !important;
  }

  #arcane-root.arcane-theme-win95 .arcane-scaffold-sidebar.arcane-scaffold-sidebar {
    align-self: start !important;
  }

  #arcane-root.arcane-theme-win95 .kb-sidebar {
    position: static !important;
    top: auto !important;
    max-height: none !important;
    overflow: visible !important;
  }

  #arcane-root.arcane-theme-win95 .kb-content-area {
    padding: 8px !important;
  }
}

/* ============================================================
   LAYOUT FIX: the .arcane-scaffold* layer is absent in some docs
   builds, so re-anchor the window frame, body grid, and sidebar
   well onto the real kb-* layer. All visible controls remain real
   DOM elements supplied by that application.
   ============================================================ */

/* The whole docs app = one maximized Win95 window on the teal desktop. */
#arcane-root.arcane-theme-win95 .kb-scaffold {
  position: relative !important;
  display: flex !important;
  flex-direction: column !important;
  margin: 3px !important;
  padding: 2px !important;
  background: var(--w95-face) !important;
  box-shadow: var(--w95-raised) !important;
  min-height: calc(100vh - 6px) !important;
  overflow: visible !important;
}

/* Body = flex row: a fixed Explorer tree well + a flexible document pane. */
#arcane-root.arcane-theme-win95 .kb-layout-body {
  display: flex !important;
  flex-direction: row !important;
  align-items: stretch !important;
  gap: 3px !important;
  padding: 3px !important;
  background: var(--w95-face) !important;
  box-shadow: none !important;
  overflow: visible !important;
}

/* Explorer tree = fixed-width SUNKEN white well (was full-width -> broke). */
#arcane-root.arcane-theme-win95 .kb-sidebar,
#arcane-root.arcane-theme-win95 .arcane-scaffold-sidebar .kb-sidebar {
  flex: 0 0 15rem !important;
  width: 15rem !important;
  max-width: 15rem !important;
  min-width: 0 !important;
  align-self: stretch !important;
  position: sticky !important;
  top: 3px !important;
  height: max-content !important;
  /* Leave room for the real topbar while keeping the Explorer tree scrollable. */
  max-height: calc(100vh - 72px) !important;
  padding: 3px !important;
  background: var(--w95-field) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-sunken) !important;
  overflow-y: auto !important;
  font-size: 16.5px !important;
  line-height: 16px !important;
}

/* Document pane fills the remaining width. */
#arcane-root.arcane-theme-win95 .kb-main-area {
  flex: 1 1 0 !important;
  min-width: 0 !important;
  width: auto !important;
  background: transparent !important;
  box-shadow: none !important;
}
#arcane-root.arcane-theme-win95 .kb-content-area {
  display: grid !important;
  grid-template-columns: minmax(0, 1fr) !important;
  min-width: 0 !important;
  width: auto !important;
  padding: 0 !important;
  background: transparent !important;
}
@media (min-width: 1120px) {
  #arcane-root.arcane-theme-win95 .kb-content-area:has(.kb-toc-panel) {
    grid-template-columns: minmax(0, 1fr) 14rem !important;
    gap: 3px !important;
  }
}

/* The article = a raised silver document window with readable black text. */
#arcane-root.arcane-theme-win95 .kb-article-panel {
  min-width: 0 !important;
  width: auto !important;
  max-width: none !important;
  margin: 0 !important;
  padding: 12px 16px !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-raised) !important;
}
#arcane-root.arcane-theme-win95 .kb-article-panel .prose,
#arcane-root.arcane-theme-win95 .kb-article-panel p,
#arcane-root.arcane-theme-win95 .kb-article-panel li,
#arcane-root.arcane-theme-win95 .kb-article-panel td,
#arcane-root.arcane-theme-win95 .kb-breadcrumbs,
#arcane-root.arcane-theme-win95 .kb-page-title {
  color: var(--w95-face-text) !important;
}

/* TOC = a small raised note pinned to the right. */
#arcane-root.arcane-theme-win95 .kb-toc-panel {
  align-self: start !important;
  padding: 4px !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-raised-thin) !important;
  /* Match the Explorer tree's topbar reservation. */
  position: sticky !important;
  top: 3px !important;
  max-height: calc(100vh - 72px) !important;
  overflow-y: auto !important;
}

/* --- Landing "terminal/browser" mock -> Win95 title bar + window buttons.
   arcane_lexicon renders it with macOS red/yellow/green traffic-light dots;
   recolor the bar navy and turn the round dots into beveled square Win95
   window-control buttons bearing the _ [] X glyphs. --- */
#arcane-root.arcane-theme-win95 .kb-landing-terminal-bar {
  background: var(--w95-title-bar) !important;
  border-radius: 0 !important;
  padding: 3px 4px !important;
  display: flex !important;
  align-items: center !important;
  gap: 3px !important;
}
#arcane-root.arcane-theme-win95 .kb-landing-terminal-dot {
  width: 16px !important;
  height: 14px !important;
  border-radius: 0 !important;
  background: var(--w95-face) !important;
  box-shadow: var(--w95-raised) !important;
  color: var(--w95-face-text) !important;
  display: inline-flex !important;
  align-items: center !important;
  justify-content: center !important;
  line-height: 1 !important;
}
/* One drawn glyph per button (see --w95-ctl-min / -max / -close) painted with
   the button's own face text colour, so each glyph lands on the same pixels as
   the caption sprites instead of on a font's baseline. */
#arcane-root.arcane-theme-win95 .kb-landing-terminal-dot:nth-child(-n + 3)::after {
  content: "";
  width: 10px;
  height: 10px;
  background-color: currentColor;
  -webkit-mask-repeat: no-repeat;
  mask-repeat: no-repeat;
  -webkit-mask-position: center;
  mask-position: center;
  -webkit-mask-size: 10px 10px;
  mask-size: 10px 10px;
}
#arcane-root.arcane-theme-win95 .kb-landing-terminal-dot:nth-child(1)::after {
  -webkit-mask-image: var(--w95-ctl-min);
  mask-image: var(--w95-ctl-min);
}
#arcane-root.arcane-theme-win95 .kb-landing-terminal-dot:nth-child(2)::after {
  -webkit-mask-image: var(--w95-ctl-max);
  mask-image: var(--w95-ctl-max);
}
#arcane-root.arcane-theme-win95 .kb-landing-terminal-dot:nth-child(3)::after {
  -webkit-mask-image: var(--w95-ctl-close);
  mask-image: var(--w95-ctl-close);
}
/* Window controls belong on the RIGHT in Windows, not the left. */
#arcane-root.arcane-theme-win95 .kb-landing-terminal-bar {
  justify-content: flex-end !important;
}

/* ============================================================
   MAJOR COMPONENT PASS: Win95 has no rounded corners. Kill every
   border-radius in the theme scope (arcane_lexicon content cards,
   buttons, chips and any unstyled component were rounded soft
   boxes) and give the lexicon content surfaces proper 3D bevels.
   Radio buttons are a 12x12 bitmap (--w95-radio-ring), not a rounded box;
   only status dots are re-asserted round below.
   ============================================================ */
#arcane-root.arcane-theme-win95 *,
#arcane-root.arcane-theme-win95 *::before,
#arcane-root.arcane-theme-win95 *::after {
  border-radius: 0 !important;
}

/* ============================================================
   The same hard reset for MOTION. Windows 95 interpolated nothing: menus and
   dialogs appeared fully drawn on the frame the mouse went down, hover states
   flipped in one repaint, and panes resized in a single step. Zeroing the
   timing tokens (see the root block) reaches everything that spends
   var(--transition), but core render bases and the interactivity scripts also
   write literal `transition: 0.2s ease` and `animation: … forwards` as INLINE
   styles, and an inline declaration outranks any stylesheet rule that is not
   !important. One blanket kill-switch is the only thing that reaches those,
   and it makes the per-component `transition: none` declarations elsewhere in
   this sheet redundant rather than load-bearing.
   Two things deliberately survive it: the hourglass loader is an animated
   background-image, not a CSS animation, and `transform` is untouched because
   popovers and tooltips use it for positioning, not for movement. Anything
   that was only made VISIBLE by an entrance keyframe has to be pinned opaque
   alongside — see the CTA card below.
   ============================================================ */
#arcane-root.arcane-theme-win95 *,
#arcane-root.arcane-theme-win95 *::before,
#arcane-root.arcane-theme-win95 *::after {
  transition: none !important;
  animation: none !important;
}
/* CTA cards emit `opacity: 0` inline and rely on an entrance keyframe to fade
   themselves in, so killing the animation alone would leave them invisible
   forever. This is the standing pairing for any element revealed BY animation. */
#arcane-root.arcane-theme-win95 .win95-cta-card {
  opacity: 1 !important;
}
/* Status dots remain circular. */
#arcane-root.arcane-theme-win95 .win95-avatar-status {
  border-radius: 50% !important;
}

/* arcane_lexicon card-like containers -> raised silver panels. */
#arcane-root.arcane-theme-win95 .kb-landing-hero,
#arcane-root.arcane-theme-win95 .kb-landing-card,
#arcane-root.arcane-theme-win95 .kb-landing-terminal,
#arcane-root.arcane-theme-win95 .kb-landing-band,
#arcane-root.arcane-theme-win95 .kb-landing-list-item,
#arcane-root.arcane-theme-win95 .kb-landing-recommended,
#arcane-root.arcane-theme-win95 .kb-callout,
#arcane-root.arcane-theme-win95 .kb-note,
#arcane-root.arcane-theme-win95 .kb-related-card,
#arcane-root.arcane-theme-win95 .kb-related-pages-card {
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  border: 0 !important;
  box-shadow: var(--w95-raised) !important;
}
/* Sunken inner wells (e.g. the terminal rows). */
#arcane-root.arcane-theme-win95 .kb-landing-terminal-row {
  background: var(--w95-field) !important;
  color: var(--w95-field-text) !important;
  border: 0 !important;
  box-shadow: var(--w95-sunken-thin) !important;
}
/* Lexicon CTA links -> raised Win95 buttons that press in. */
#arcane-root.arcane-theme-win95 .kb-landing-primary,
#arcane-root.arcane-theme-win95 .kb-landing-secondary {
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  border: 0 !important;
  box-shadow: var(--w95-raised) !important;
  text-decoration: none !important;
}
#arcane-root.arcane-theme-win95 .kb-landing-primary:active,
#arcane-root.arcane-theme-win95 .kb-landing-secondary:active {
  box-shadow: var(--w95-pressed) !important;
}
/* Small kicker / index labels -> thin raised chips. */
#arcane-root.arcane-theme-win95 .kb-landing-kicker,
#arcane-root.arcane-theme-win95 .kb-landing-list-index {
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  border: 0 !important;
  box-shadow: var(--w95-raised-thin) !important;
}

/* ============================================================
   POLISH PASSES: icon/search centering, menu-bar word spacing,
   focus/border cleanup, and an accurate Win95 Explorer tree.
   ============================================================ */
/* ===== icons ===== */
/* ============================================================
   PASS 1 — Topbar icon-buttons + search icon centering (Win95)
   ============================================================ */

/* --- All three topbar icon-buttons: 22x22 sharp beveled squares --- */
#arcane-root.arcane-theme-win95 .kb-topbar-github,
#arcane-root.arcane-theme-win95 .kb-theme-toggle,
#arcane-root.arcane-theme-win95 .kb-hamburger {
  width: 22px !important;
  min-width: 22px !important;
  height: 22px !important;
  min-height: 22px !important;
  padding: 0 !important;
  border: 0 !important;
  border-radius: 0 !important;
  align-items: center !important;
  justify-content: center !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-raised) !important;
  font-size: 16.5px !important;
}

/* github + theme-toggle are always visible -> force flex box for centering.
   Hamburger's display stays owned by the base .kb-topbar .kb-hamburger rule
   (none at desktop, inline-flex under 900px), so we do NOT touch it here. */
#arcane-root.arcane-theme-win95 .kb-topbar-github,
#arcane-root.arcane-theme-win95 .kb-theme-toggle {
  display: inline-flex !important;
}

/* Press in on :active (raised -> pressed). */
#arcane-root.arcane-theme-win95 .kb-topbar-github:active,
#arcane-root.arcane-theme-win95 .kb-theme-toggle:active,
#arcane-root.arcane-theme-win95 .kb-hamburger:active {
  background: var(--w95-face) !important;
  box-shadow: var(--w95-pressed) !important;
}

/* Win95 reacts on press, not hover: keep the raised face, no tint. */
#arcane-root.arcane-theme-win95 .kb-topbar-github:hover,
#arcane-root.arcane-theme-win95 .kb-theme-toggle:hover,
#arcane-root.arcane-theme-win95 .kb-hamburger:hover {
  background: var(--w95-face) !important;
  border: 0 !important;
  box-shadow: var(--w95-raised) !important;
}

/* Inner glyph of github + hamburger: 16x16, perfectly centered, no stray margins. */
#arcane-root.arcane-theme-win95 .kb-topbar-github > i,
#arcane-root.arcane-theme-win95 .kb-topbar-github > svg,
#arcane-root.arcane-theme-win95 .kb-topbar-github i,
#arcane-root.arcane-theme-win95 .kb-topbar-github svg,
#arcane-root.arcane-theme-win95 .kb-hamburger > i,
#arcane-root.arcane-theme-win95 .kb-hamburger > svg,
#arcane-root.arcane-theme-win95 .kb-hamburger i,
#arcane-root.arcane-theme-win95 .kb-hamburger svg {
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
  width: 16px !important;
  height: 16px !important;
  font-size: 24px !important;
  line-height: 1 !important;
  margin: 0 !important;
  color: var(--w95-face-text) !important;
}

/* --- Theme toggle: make the ACTIVE sun/moon glyph actually render ---
   Visibility mirrors the base rules: light mode shows .theme-icon-dark,
   dark mode shows .theme-icon-light. We replicate that mapping but as a
   centered 16x16 flex box so the glyph is no longer 0x0. */
#arcane-root.arcane-theme-win95:not(.dark) .kb-theme-toggle .theme-icon-dark,
#arcane-root.arcane-theme-win95.dark .kb-theme-toggle .theme-icon-light {
  display: inline-flex !important;
  align-items: center !important;
  justify-content: center !important;
  width: 16px !important;
  height: 16px !important;
  line-height: 1 !important;
  margin: 0 !important;
  color: var(--w95-face-text) !important;
}

/* Keep the inactive glyph hidden (guards against un-hiding it). */
#arcane-root.arcane-theme-win95:not(.dark) .kb-theme-toggle .theme-icon-light,
#arcane-root.arcane-theme-win95.dark .kb-theme-toggle .theme-icon-dark {
  display: none !important;
}

/* Size the lucide font glyph / svg inside whichever span is visible. */
#arcane-root.arcane-theme-win95 .kb-theme-toggle .theme-icon-light > i,
#arcane-root.arcane-theme-win95 .kb-theme-toggle .theme-icon-light > svg,
#arcane-root.arcane-theme-win95 .kb-theme-toggle .theme-icon-light i,
#arcane-root.arcane-theme-win95 .kb-theme-toggle .theme-icon-light svg,
#arcane-root.arcane-theme-win95 .kb-theme-toggle .theme-icon-dark > i,
#arcane-root.arcane-theme-win95 .kb-theme-toggle .theme-icon-dark > svg,
#arcane-root.arcane-theme-win95 .kb-theme-toggle .theme-icon-dark i,
#arcane-root.arcane-theme-win95 .kb-theme-toggle .theme-icon-dark svg {
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
  width: 16px !important;
  height: 16px !important;
  font-size: 24px !important;
  line-height: 1 !important;
  margin: 0 !important;
  color: var(--w95-face-text) !important;
}

/* --- Search box: pull the magnifier off the text --- */
/* Make the search container the positioning context for the icon. */
#arcane-root.arcane-theme-win95 .kb-search {
  position: relative !important;
}

/* Reserve room on the left so typed/placeholder text clears the icon. */
#arcane-root.arcane-theme-win95 .kb-search-input {
  padding: 3px 4px 3px 26px !important;
}

/* Pin the 16x16 magnifier ~6px from the left edge, vertically centered. */
#arcane-root.arcane-theme-win95 .kb-search-icon {
  position: absolute !important;
  left: 6px !important;
  top: 50% !important;
  transform: translateY(-50%) !important;
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
  width: 16px !important;
  height: 16px !important;
  font-size: 24px !important;
  line-height: 1 !important;
  margin: 0 !important;
  pointer-events: none !important;
  color: var(--w95-disabled-text) !important;
  z-index: 1 !important;
}

#arcane-root.arcane-theme-win95 .kb-search-icon > svg,
#arcane-root.arcane-theme-win95 .kb-search-icon svg {
  width: 16px !important;
  height: 16px !important;
}

/* --- Win95 chrome/label text is never tracked or uppercased --- */
#arcane-root.arcane-theme-win95 .sidebar-section-header,
#arcane-root.arcane-theme-win95 .win95-sidebar-group-label,
#arcane-root.arcane-theme-win95 .win95-dropdown-label,
#arcane-root.arcane-theme-win95 .win95-command-group-heading,
#arcane-root.arcane-theme-win95 .win95-status-label,
#arcane-root.arcane-theme-win95 .arcane-demo-kicker,
#arcane-root.arcane-theme-win95 .arcane-demo-code-label,
#arcane-root.arcane-theme-win95 .arcane-demo-section-title,
#arcane-root.arcane-theme-win95 .kb-landing-kicker,
#arcane-root.arcane-theme-win95 .kb-landing-list-index,
#arcane-root.arcane-theme-win95 .kb-toc-title,
#arcane-root.arcane-theme-win95 .toc-title,
#arcane-root.arcane-theme-win95 .kicker {
  letter-spacing: normal !important;
  text-transform: none !important;
}

/* ===== outlines ===== */
/* ===== PASS 3 — dotted focus rectangles + flat borders -> bevels ===== */

/* 1. Single global keyboard-focus indicator: the Win95 focus rect is a 1px
   DOTTED black rectangle inset into the control. This is appended last with
   !important so it supersedes the older -4px-offset rule and neutralizes any
   solid/colored focus ring left on generic elements. Box-shadow is untouched
   so intentional sunken-on-focus fields keep their bevel (not a glow). */
#arcane-root.arcane-theme-win95 :focus-visible {
  outline: 1px dotted var(--w95-face-text) !important;
  outline-offset: -3px !important;
}

/* The selected + focused Explorer tree row keeps a WHITE dotted rectangle on
   its navy selection bar -- black dots would vanish on navy. Re-asserted with
   !important so the global rule above cannot recolor it to black. */
#arcane-root.arcane-theme-win95 .sidebar-link.active {
  outline: 1px dotted var(--w95-hilite) !important;
  outline-offset: -3px !important;
}

/* 2. Flat single-line dividers -> etched Win95 grooves (dark pixel over a light
   pixel), matching the .win95-separator convention already used in this sheet.

   Pagination separator: the line above the raised nav buttons (like the groove
   above OK/Cancel in a dialog). */
#arcane-root.arcane-theme-win95 .kb-page-nav {
  border-top: 0 !important;
  box-shadow: inset 0 1px 0 var(--w95-shadow), inset 0 2px 0 var(--w95-hilite) !important;
  padding-top: 12px !important;
}

/* "Contents" heading underline inside the sunken TOC well. */
#arcane-root.arcane-theme-win95 .kb-toc-panel .toc-title {
  border-bottom: 0 !important;
  box-shadow: inset 0 -1px 0 var(--w95-hilite), inset 0 -2px 0 var(--w95-shadow) !important;
}

/* ===== tree ===== */
/* ============================================================
   PASS 4 — Accurate Windows 95 Explorer tree (sidebar)
   ============================================================ */

/* Lay group headers out as a simple left-aligned row so the [+]/[-] node
   box and the label sit together (covers both the docs
   .sidebar-section-header variant and the native <details> .sidebar-summary
   variant). */
#arcane-root.arcane-theme-win95 .sidebar-section-header,
#arcane-root.arcane-theme-win95 .sidebar-summary {
  display: flex !important;
  align-items: center !important;
  justify-content: flex-start !important;
  gap: 0 !important;
}

/* 1a. Hide the modern chevron / icon SVG on the group headers. Scoped to
       headers/summaries only so leaf .sidebar-link icons are untouched. */
#arcane-root.arcane-theme-win95 .sidebar-section-header .sidebar-icon,
#arcane-root.arcane-theme-win95 .sidebar-section-header .sidebar-icon-svg,
#arcane-root.arcane-theme-win95 .sidebar-section-header .sidebar-chevron,
#arcane-root.arcane-theme-win95 .sidebar-section-header > svg,
#arcane-root.arcane-theme-win95 .sidebar-summary .sidebar-icon,
#arcane-root.arcane-theme-win95 .sidebar-summary .sidebar-icon-svg,
#arcane-root.arcane-theme-win95 .sidebar-summary .sidebar-chevron,
#arcane-root.arcane-theme-win95 .sidebar-summary > svg {
  display: none !important;
}

/* Kill the native <summary> disclosure triangle so only our box shows. */
#arcane-root.arcane-theme-win95 .sidebar-summary {
  list-style: none !important;
}
#arcane-root.arcane-theme-win95 .sidebar-summary::-webkit-details-marker {
  display: none !important;
}
#arcane-root.arcane-theme-win95 .sidebar-summary::marker {
  content: "" !important;
}

/* 1b. Classic Win95 tree node box: a small (~11px) WHITE field square with a
       thin gray border and a black glyph, placed to the LEFT of the label.
       Default glyph is '-' because groups render expanded by default. */
#arcane-root.arcane-theme-win95 .sidebar-section-header::before,
#arcane-root.arcane-theme-win95 .sidebar-summary::before {
  content: "-" !important;
  display: inline-flex !important;
  align-items: center !important;
  justify-content: center !important;
  box-sizing: border-box !important;
  flex: 0 0 auto !important;
  width: 11px !important;
  height: 11px !important;
  margin-right: 5px !important;
  vertical-align: middle !important;
  background: var(--w95-field) !important;
  border: 1px solid var(--w95-shadow) !important;
  box-shadow: none !important;
  color: var(--w95-field-text) !important;
  font-family: "MS Sans Serif", Tahoma, Geneva, sans-serif !important;
  font-size: 13.5px !important;
  font-weight: 700 !important;
  line-height: 1 !important;
  text-align: center !important;
}

/* Collapsed groups -> '+'. */
#arcane-root.arcane-theme-win95 .sidebar-details:not([open]) > .sidebar-summary::before,
#arcane-root.arcane-theme-win95 .sidebar-section-header[aria-expanded="false"]::before,
#arcane-root.arcane-theme-win95 .sidebar-section-header.collapsed::before,
#arcane-root.arcane-theme-win95 .sidebar-section-header.is-collapsed::before,
#arcane-root.arcane-theme-win95 .sidebar-section-header.is-closed::before,
#arcane-root.arcane-theme-win95 .sidebar-section.collapsed > .sidebar-section-header::before {
  content: "+" !important;
}

/* Expanded groups -> '-' (reinforces the default against any cascade). */
#arcane-root.arcane-theme-win95 .sidebar-details[open] > .sidebar-summary::before,
#arcane-root.arcane-theme-win95 .sidebar-section-header[aria-expanded="true"]::before,
#arcane-root.arcane-theme-win95 .sidebar-section-header.is-open::before,
#arcane-root.arcane-theme-win95 .sidebar-section-header.open::before,
#arcane-root.arcane-theme-win95 .sidebar-section-header.expanded::before,
#arcane-root.arcane-theme-win95 .sidebar-section-header.active::before {
  content: "-" !important;
}

/* 2. Win95 dotted tree connectors: a 1px dotted vertical trunk down the left
      of each group's nested items + a short dotted horizontal elbow to every
      row. Items are indented ~14px (1px border + 13px padding) to make room. */
#arcane-root.arcane-theme-win95 .sidebar-tree {
  position: relative !important;
  margin-left: 7px !important;
  margin-top: 0 !important;
  padding-left: 13px !important;
  gap: 0 !important;
  border-left: 1px dotted var(--w95-shadow) !important;
  background-image: none !important;
}

#arcane-root.arcane-theme-win95 .sidebar-tree-item {
  position: relative !important;
}

#arcane-root.arcane-theme-win95 .sidebar-tree-item::before {
  content: "" !important;
  position: absolute !important;
  left: -13px !important;
  top: 9px !important;
  width: 11px !important;
  height: 0 !important;
  border-top: 1px dotted var(--w95-shadow) !important;
  background: none !important;
}

#arcane-root.arcane-theme-win95 .sidebar-tree-item::after {
  content: none !important;
}

/* ============================================================
   COMPONENT PASS: calendar/pickers, sliders, tables, selects,
   avatar/media/progress, accordion/tabs, chart/feedback.
   ============================================================ */
/* ================= calendar ================= */
/* ============================================================
   CALENDAR + DATE / TIME PICKERS — Win95 date-time control.
   The weekday row and the day grid are laid out as real 7-col
   grids (the critical fix); the panel is a raised silver control
   with a sunken white day well and navy selection.
   ============================================================ */

/* ---------- Calendar panel: raised silver Win95 control ---------- */
#arcane-root.arcane-theme-win95 .arcane-calendar.arcane-calendar--win95 {
  display: flex !important;
  flex-direction: column !important;
  gap: 3px !important;
  width: max-content !important;
  max-width: 100% !important;
  padding: 4px !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-raised) !important;
  font-family: var(--font-sans) !important;
}

/* Header: month/year label flanked by prev/next arrow buttons */
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-header {
  display: flex !important;
  align-items: center !important;
  gap: 3px !important;
  padding: 1px 2px !important;
}
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-label {
  flex: 1 1 auto !important;
  text-align: center !important;
  font-weight: 700 !important;
  font-size: 1.1rem !important;
  line-height: 1.2 !important;
  color: var(--w95-face-text) !important;
  white-space: nowrap !important;
}

/* Nav (prev/next) + today buttons: small raised silver Win95 buttons */
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-nav-btn {
  display: inline-flex !important;
  align-items: center !important;
  justify-content: center !important;
  min-width: 1.7rem !important;
  height: 1.7rem !important;
  padding: 0 0.3rem !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-raised) !important;
  font-family: var(--font-sans) !important;
  font-size: 1.05rem !important;
  line-height: 1 !important;
  cursor: var(--w95-cursor-arrow) !important;
  transition: none !important;
}
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-nav-btn:active:not([disabled]) {
  box-shadow: var(--w95-pressed) !important;
  padding-top: 1px !important;
  padding-left: calc(0.3rem + 1px) !important;
  padding-bottom: 0 !important;
  padding-right: calc(0.3rem - 1px) !important;
}

/* Today row + today button */
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-today-row {
  display: flex !important;
  justify-content: center !important;
  padding: 0 2px !important;
}
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-today {
  min-width: 0 !important;
  height: auto !important;
  padding: 0.15rem 0.7rem !important;
  font-size: 0.95rem !important;
}

/* ---------- Weekday header row: real 7-column grid ---------- */
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-weekdays {
  display: grid !important;
  grid-template-columns: repeat(7, 1fr) !important;
  gap: 1px !important;
  padding: 2px 3px !important;
  margin: 0 !important;
}
/* When week numbers are shown, prepend an auto column for the "#" gutter. */
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-weekdays:has(.arcane-calendar-week-num) {
  grid-template-columns: auto repeat(7, 1fr) !important;
}
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-weekday {
  display: inline-flex !important;
  align-items: center !important;
  justify-content: center !important;
  min-width: 1.9rem !important;
  min-height: 1.4rem !important;
  text-align: center !important;
  font-size: 0.95rem !important;
  font-weight: 700 !important;
  line-height: 1 !important;
  color: var(--w95-face-text) !important;
}
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-weekday.arcane-calendar-week-num {
  min-width: 0 !important;
  padding: 0 0.25rem !important;
  color: var(--muted-foreground) !important;
}

/* ---------- Day grid: real 7-column grid inside a sunken white well ---------- */
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-grid {
  display: grid !important;
  grid-template-columns: repeat(7, 1fr) !important;
  gap: 1px !important;
  padding: 3px !important;
  background: var(--w95-field) !important;
  color: var(--w95-field-text) !important;
  box-shadow: var(--w95-sunken) !important;
}
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-grid:has(.arcane-calendar-weeknum) {
  grid-template-columns: auto repeat(7, 1fr) !important;
}
/* Week-number gutter cells inside the grid */
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-weeknum {
  display: inline-flex !important;
  align-items: center !important;
  justify-content: center !important;
  min-width: 0 !important;
  padding: 0 0.25rem !important;
  font-size: 0.85rem !important;
  color: var(--muted-foreground) !important;
}

/* Day cells: square-ish, centered, flat white ground */
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-day {
  display: inline-flex !important;
  align-items: center !important;
  justify-content: center !important;
  min-width: 1.9rem !important;
  min-height: 1.7rem !important;
  padding: 0 !important;
  background: transparent !important;
  color: var(--w95-field-text) !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: none !important;
  font-family: var(--font-sans) !important;
  font-size: 1.05rem !important;
  line-height: 1 !important;
  cursor: var(--w95-cursor-arrow) !important;
  transition: none !important;
}
/* Hover: navy highlight, like the Win95 MonthCalendar */
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-day:hover:not([disabled]):not(.arcane-calendar-day-disabled) {
  background: var(--w95-selection) !important;
  color: var(--w95-selection-text) !important;
}
/* Days outside the current month: greyed */
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-day.arcane-calendar-day-other-month {
  color: var(--w95-disabled-text) !important;
}
/* Today: dotted focus rectangle around the number */
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-day.arcane-calendar-day-today,
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-day[data-today="true"] {
  outline: 1px dotted var(--w95-field-text) !important;
  outline-offset: -2px !important;
}
/* Range fill */
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-day.arcane-calendar-day-in-range,
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-day.arcane-calendar-day-pending {
  background: var(--w95-selection) !important;
  color: var(--w95-selection-text) !important;
}
/* Selected day / range endpoints: solid navy (wins over hover + today) */
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-day.arcane-calendar-day-selected,
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-day.arcane-calendar-day-range-start,
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-day.arcane-calendar-day-range-end,
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-day[data-selected="true"],
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-day[aria-selected="true"],
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-day[data-state="selected"] {
  background: var(--w95-selection) !important;
  color: var(--w95-selection-text) !important;
  outline: 1px dotted var(--w95-selection-text) !important;
  outline-offset: -2px !important;
}
/* Disabled days */
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-day.arcane-calendar-day-disabled,
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-day[disabled],
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-day[data-disabled="true"] {
  color: var(--w95-disabled-text) !important;
  background: transparent !important;
  cursor: var(--w95-cursor-arrow) !important;
}

/* ============================================================
   DATE PICKER
   ============================================================ */

/* Wrapper (isolated from the dropdown, which shares .win95-date-picker) */
#arcane-root.arcane-theme-win95 .win95-date-picker:not(.win95-date-picker-dropdown) {
  position: relative !important;
  display: inline-flex !important;
  flex-direction: column !important;
  gap: 0.3rem !important;
  width: max-content !important;
  min-width: 12rem !important;
}

/* Trigger: sunken white combobox field with a leading calendar icon */
#arcane-root.arcane-theme-win95 .win95-date-picker-trigger,
#arcane-root.arcane-theme-win95 .win95-time-picker-trigger {
  display: inline-flex !important;
  align-items: center !important;
  gap: 0.4rem !important;
  width: 100% !important;
  min-height: 1.9rem !important;
  padding: 0.3rem 0.4rem !important;
  background: var(--w95-field) !important;
  color: var(--w95-field-text) !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-sunken) !important;
  font-family: var(--font-sans) !important;
  font-size: 1.05rem !important;
  line-height: 1.2 !important;
  text-align: left !important;
  cursor: var(--w95-cursor-arrow) !important;
  transition: none !important;
}
#arcane-root.arcane-theme-win95 .win95-date-picker[data-size="sm"] .win95-date-picker-trigger,
#arcane-root.arcane-theme-win95 .win95-time-picker[data-size="sm"] .win95-time-picker-trigger {
  min-height: 1.7rem !important;
  font-size: 0.95rem !important;
}
#arcane-root.arcane-theme-win95 .win95-date-picker[data-size="lg"] .win95-date-picker-trigger,
#arcane-root.arcane-theme-win95 .win95-time-picker[data-size="lg"] .win95-time-picker-trigger {
  min-height: 2.2rem !important;
  font-size: 1.1rem !important;
}
#arcane-root.arcane-theme-win95 .win95-date-picker-trigger:focus,
#arcane-root.arcane-theme-win95 .win95-time-picker-trigger:focus {
  outline: 1px dotted var(--w95-field-text) !important;
  outline-offset: -3px !important;
  box-shadow: var(--w95-sunken) !important;
}
/* Leading icon */
#arcane-root.arcane-theme-win95 .win95-date-picker-trigger > span:first-child,
#arcane-root.arcane-theme-win95 .win95-time-picker-trigger > span:first-child {
  display: inline-flex !important;
  align-items: center !important;
  flex: 0 0 auto !important;
  color: var(--w95-field-text) !important;
}
/* Display text */
#arcane-root.arcane-theme-win95 .win95-date-picker-trigger [data-arcane-calendar-display] {
  flex: 1 1 auto !important;
  overflow: hidden !important;
  text-overflow: ellipsis !important;
  white-space: nowrap !important;
  text-align: left !important;
}
/* Clear ("x") affordance */
#arcane-root.arcane-theme-win95 .win95-date-picker-clear,
#arcane-root.arcane-theme-win95 .win95-time-picker-clear {
  display: inline-flex !important;
  align-items: center !important;
  justify-content: center !important;
  flex: 0 0 auto !important;
  margin-left: auto !important;
  width: 1.3rem !important;
  height: 1.3rem !important;
  color: var(--w95-field-text) !important;
  cursor: var(--w95-cursor-arrow) !important;
}
#arcane-root.arcane-theme-win95 .win95-date-picker-clear:hover,
#arcane-root.arcane-theme-win95 .win95-time-picker-clear:hover {
  background: var(--w95-selection) !important;
  color: var(--w95-selection-text) !important;
}
/* Disabled trigger */
#arcane-root.arcane-theme-win95 .win95-date-picker.disabled .win95-date-picker-trigger,
#arcane-root.arcane-theme-win95 .win95-time-picker-trigger.disabled {
  color: var(--w95-disabled-text) !important;
  cursor: var(--w95-cursor-arrow) !important;
}

/* Dropdown: floating silver popup in the window frame hosting the calendar */
#arcane-root.arcane-theme-win95 .win95-date-picker-dropdown {
  /* The core emits no JS positioner for this popup, so the base leaves it at a
     placeholder position:fixed;top:4px;left:4px (viewport corner, under content).
     Anchor it to the trigger instead. Fallback: absolute in the relative wrapper
     (correct location, but clipped by any overflow:hidden ancestor). */
  position: absolute !important;
  inset: auto !important;
  top: 100% !important;
  left: 0 !important;
  z-index: 60 !important;
  margin-top: 2px !important;
  padding: 3px !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-window-frame) !important;
}
/* Preferred: CSS anchor positioning pins the popup below the trigger with
   position:fixed, so it escapes clipping ancestors (e.g. the docs demo box) and
   floats on top. Each dropdown binds to its own preceding trigger by DOM order,
   so multiple pickers on one page stay independent. */
@supports (anchor-name: --a) {
  #arcane-root.arcane-theme-win95 .win95-date-picker-trigger {
    anchor-name: --w95-dp-anchor;
  }
  #arcane-root.arcane-theme-win95 .win95-date-picker-dropdown {
    position: fixed !important;
    position-anchor: --w95-dp-anchor;
    top: anchor(bottom) !important;
    left: anchor(left) !important;
    right: auto !important;
    bottom: auto !important;
    z-index: 9500 !important;
  }
}
/* Calendar nested in the popup: drop its own panel bevel to avoid double 3D */
#arcane-root.arcane-theme-win95 .win95-date-picker-dropdown .arcane-calendar.arcane-calendar--win95 {
  box-shadow: none !important;
  padding: 0 !important;
  background: transparent !important;
}

/* ============================================================
   TIME PICKER
   ============================================================ */

/* Wrapper (isolated from the dropdown, which shares .win95-time-picker) */
#arcane-root.arcane-theme-win95 .win95-time-picker:not(.win95-time-picker-dropdown) {
  position: relative !important;
  display: inline-flex !important;
  flex-direction: column !important;
  gap: 0.3rem !important;
  width: max-content !important;
  min-width: 12rem !important;
}

/* Dropdown: floating raised panel, holds the columns row + actions row */
#arcane-root.arcane-theme-win95 .win95-time-picker-dropdown {
  position: absolute !important;
  z-index: 50 !important;
  display: flex !important;
  flex-direction: column !important;
  gap: 4px !important;
  margin-top: 2px !important;
  padding: 4px !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-window-frame) !important;
}

/* Columns row */
#arcane-root.arcane-theme-win95 .win95-time-picker-dropdown > div:first-child {
  display: flex !important;
  align-items: flex-start !important;
  gap: 4px !important;
}
/* Each column */
#arcane-root.arcane-theme-win95 .win95-time-picker-dropdown > div:first-child > div {
  display: flex !important;
  flex-direction: column !important;
  gap: 3px !important;
}
/* Column labels (Hour / Minute / Period) */
#arcane-root.arcane-theme-win95 .win95-time-picker-dropdown > div:first-child > div > span {
  display: block !important;
  text-align: center !important;
  font-weight: 700 !important;
  font-size: 0.9rem !important;
  color: var(--w95-face-text) !important;
}
/* Scrollable option list wells (Hour / Minute) sit in sunken white fields */
#arcane-root.arcane-theme-win95 .win95-time-picker-dropdown > div:first-child > div > div {
  display: flex !important;
  flex-direction: column !important;
  min-width: 2.8rem !important;
  max-height: 8.5rem !important;
  overflow-y: auto !important;
  overflow-x: hidden !important;
  padding: 2px !important;
  background: var(--w95-field) !important;
  color: var(--w95-field-text) !important;
  box-shadow: var(--w95-sunken) !important;
}
/* Option buttons: flat list rows, navy on hover/selected */
#arcane-root.arcane-theme-win95 .win95-time-picker-option {
  display: block !important;
  width: 100% !important;
  padding: 0.15rem 0.5rem !important;
  background: transparent !important;
  color: var(--w95-field-text) !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: none !important;
  font-family: var(--font-sans) !important;
  font-size: 1rem !important;
  line-height: 1.3 !important;
  text-align: center !important;
  cursor: var(--w95-cursor-arrow) !important;
  transition: none !important;
}
#arcane-root.arcane-theme-win95 .win95-time-picker-option:hover {
  background: var(--w95-selection) !important;
  color: var(--w95-selection-text) !important;
}
#arcane-root.arcane-theme-win95 .win95-time-picker-option.selected {
  background: var(--w95-selection) !important;
  color: var(--w95-selection-text) !important;
}
/* Actions row (Cancel / Confirm) — buttons already styled by .win95-button */
#arcane-root.arcane-theme-win95 .win95-time-picker-dropdown > div:last-child {
  display: flex !important;
  justify-content: flex-end !important;
  gap: 4px !important;
  margin-top: 2px !important;
}

/* ================= sliders ================= */
/* ============================================================
   SLIDER (Win95 trackbar) + RANGE SLIDER
   DOM: .win95-slider > .win95-slider-track-container
          > .win95-slider-track > .win95-slider-track-fill
          + .win95-slider-thumb (x1 value, or x2 lo/hi)
        plus .win95-slider-value
   Renderer emits empty style maps, so everything is styled here.
   The runtime JS sets `fill.style.width/left/right` and
   `thumb.style.left` as INLINE styles on interaction, so those
   dynamic properties are intentionally declared WITHOUT !important
   (a non-important rule loses to inline, letting JS win after
   interaction while still providing a sane initial position).
   ============================================================ */

#arcane-root.arcane-theme-win95 .win95-slider {
  color: var(--w95-face-text) !important;
}

/* Hit area holds the thumb; base already sets position:relative +
   flex/align-items:center inline. Reinforce the essentials. */
#arcane-root.arcane-theme-win95 .win95-slider-track-container {
  position: relative !important;
  display: flex !important;
  align-items: center !important;
  min-height: 22px !important;
  cursor: var(--w95-cursor-arrow) !important;
}

/* The trackbar channel: a 4px groove that is nothing but the 2px sunken
   bevel top and bottom, vertically centred by the flex container. */
#arcane-root.arcane-theme-win95 .win95-slider-track {
  position: relative !important;
  width: 100% !important;
  height: 4px !important;
  box-sizing: border-box !important;
  background: var(--w95-face) !important;
  box-shadow: var(--w95-sunken) !important;
  border: none !important;
  border-radius: 0 !important;
  overflow: hidden !important;
}

/* The Win95 trackbar never filled its channel up to the value: the thumb's
   position is the only readout, so the runtime's fill element stays hidden. */
#arcane-root.arcane-theme-win95 .win95-slider-track-fill {
  display: none !important;
}

/* The pointed trackbar thumb (--w95-slider-thumb, 11x21). `left` (the value
   position) is set inline by the JS — declared without !important so JS wins;
   left:0 seeds the pre-interaction position. The offsets are whole pixels so
   the bitmap never lands on a half pixel: 5px puts the centre column on the
   value, and 10px hangs the thumb from the channel's centre line (top: 50% of
   the hit area, where the flex container centres the track) so the 4px
   channel crosses the thumb's body at rows 8-11 and the point hangs below. */
#arcane-root.arcane-theme-win95 .win95-slider-thumb {
  position: absolute !important;
  top: 50% !important;
  left: 0;
  width: 11px !important;
  height: 21px !important;
  box-sizing: border-box !important;
  transform: translate(-5px, -10px) !important;
  background: var(--w95-slider-thumb) no-repeat 0 0 / 11px 21px !important;
  box-shadow: none !important;
  border: none !important;
  border-radius: 0 !important;
  z-index: 2 !important;
  /* The trackbar thumb kept the plain arrow at rest and while dragged; the
     grab/grabbing hands never existed in Win95. */
  cursor: var(--w95-cursor-arrow) !important;
  touch-action: none !important;
}

/* Readable numeric label. Kept modest — fonts are already x1.5. */
#arcane-root.arcane-theme-win95 .win95-slider-value {
  color: var(--w95-face-text) !important;
  font-size: 0.8rem !important;
  line-height: 1.2 !important;
}

/* ============================================================
   TOGGLE SWITCH (Win95 idiom: sunken track + raised square thumb)
   DOM: label.win95-toggle-wrapper
          > button.win95-toggle-switch(.active/[data-state=checked])
              > span.win95-toggle-thumb
          + span.win95-toggle-label
   ============================================================ */

#arcane-root.arcane-theme-win95 .win95-toggle-wrapper {
  display: inline-flex !important;
  align-items: center !important;
  gap: 0.5rem !important;
  cursor: var(--w95-cursor-arrow) !important;
}

/* Sunken well the thumb rides in. */
#arcane-root.arcane-theme-win95 .win95-toggle-switch {
  position: relative !important;
  display: inline-flex !important;
  align-items: center !important;
  flex-shrink: 0 !important;
  width: 44px !important;
  height: 22px !important;
  padding: 3px !important;
  box-sizing: border-box !important;
  background: var(--w95-field) !important;
  box-shadow: var(--w95-sunken) !important;
  border: none !important;
  border-radius: 0 !important;
  cursor: var(--w95-cursor-arrow) !important;
  transition: none !important;
}
#arcane-root.arcane-theme-win95 .win95-toggle-switch[data-arcane-state="selected"] {
  background: var(--w95-selection) !important;
}
#arcane-root.arcane-theme-win95 .win95-toggle-switch[data-disabled="true"],
#arcane-root.arcane-theme-win95 .win95-toggle-switch:disabled {
  opacity: 0.5 !important;
  cursor: var(--w95-cursor-arrow) !important;
}

/* Raised silver square grip; inner height = 22 - 2*3 = 16px. */
#arcane-root.arcane-theme-win95 .win95-toggle-thumb {
  width: 16px !important;
  height: 16px !important;
  box-sizing: border-box !important;
  background: var(--w95-face) !important;
  box-shadow: var(--w95-raised) !important;
  border: none !important;
  border-radius: 0 !important;
  transition: none !important;
}

/* Travel = inner width (44 - 2*3 = 38) - thumb (16) = 22px. */
#arcane-root.arcane-theme-win95 .win95-toggle-switch[data-arcane-state="selected"] .win95-toggle-thumb {
  transform: translateX(22px) !important;
}

#arcane-root.arcane-theme-win95 .win95-toggle-label {
  color: var(--w95-face-text) !important;
  font-size: 0.8rem !important;
  line-height: 1.2 !important;
}

/* ================= tables ================= */
/* ===== GROUP 3 — TABLES (Win95) ===== */

/* Scroll containers = sunken white wells */
#arcane-root.arcane-theme-win95 .win95-static-table-container,
#arcane-root.arcane-theme-win95 .win95-data-table-container,
#arcane-root.arcane-theme-win95 .win95-kv-table {
  background: var(--w95-field) !important;
  color: var(--w95-field-text) !important;
  box-shadow: var(--w95-sunken) !important;
  padding: 3px !important;
  overflow: auto !important;
  border: 0 !important;
}

/* The table itself: flush field, thin gridlines drawn by cells */
#arcane-root.arcane-theme-win95 .win95-static-table,
#arcane-root.arcane-theme-win95 .win95-data-table {
  border-collapse: separate !important;
  border-spacing: 0 !important;
  width: 100% !important;
  margin: 0 !important;
  background: var(--w95-field) !important;
  color: var(--w95-field-text) !important;
  border: 0 !important;
}

/* Header cells = raised beveled silver buttons */
#arcane-root.arcane-theme-win95 .win95-static-table th,
#arcane-root.arcane-theme-win95 .win95-data-table th {
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-raised-thin) !important;
  font-weight: 700 !important;
  padding: 2px 8px !important;
  text-align: left !important;
  border: 0 !important;
  white-space: nowrap !important;
}

/* Body cells = white field with thin gray gridlines; beat inline color/padding */
#arcane-root.arcane-theme-win95 .win95-static-table td,
#arcane-root.arcane-theme-win95 .win95-data-table td {
  padding: 2px 8px !important;
  color: var(--w95-field-text) !important;
  background: var(--w95-field) !important;
  border-top: 0 !important;
  border-left: 0 !important;
  border-right: 1px solid var(--w95-shadow) !important;
  border-bottom: 1px solid var(--w95-shadow) !important;
}

/* Selected / hovered rows = navy selection (override the inline td color too) */
#arcane-root.arcane-theme-win95 .win95-data-table-row.selected td,
#arcane-root.arcane-theme-win95 .win95-data-table-row.clickable:hover td,
#arcane-root.arcane-theme-win95 .win95-static-table tbody tr:hover td {
  background: var(--w95-selection) !important;
  color: var(--w95-selection-text) !important;
}

/* Empty-state placeholder = sunken well */
#arcane-root.arcane-theme-win95 .win95-data-table-empty {
  background: var(--w95-field) !important;
  color: var(--w95-field-text) !important;
  box-shadow: var(--w95-sunken) !important;
  padding: 24px !important;
  border: 0 !important;
}

/* Key-value table = property grid: raised key strip, white value cell */
#arcane-root.arcane-theme-win95 .win95-kv-table-key {
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-raised-thin) !important;
  font-weight: 700 !important;
  padding: 2px 8px !important;
  border-right: 0 !important;
}
#arcane-root.arcane-theme-win95 .win95-kv-table-value {
  background: var(--w95-field) !important;
  color: var(--w95-field-text) !important;
  padding: 2px 8px !important;
}
#arcane-root.arcane-theme-win95 .win95-kv-table-row {
  border-bottom-color: var(--w95-disabled-text) !important;
}

/* Markdown / prose tables = same beveled treatment (table is its own well) */
#arcane-root.arcane-theme-win95 .prose table {
  border-collapse: separate !important;
  border-spacing: 0 !important;
  width: 100% !important;
  margin: 12px 0 !important;
  background: var(--w95-field) !important;
  color: var(--w95-field-text) !important;
  box-shadow: var(--w95-sunken) !important;
  border: 2px solid var(--w95-field) !important;
}
#arcane-root.arcane-theme-win95 .prose th {
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-raised-thin) !important;
  font-weight: 700 !important;
  padding: 2px 8px !important;
  text-align: left !important;
  border: 0 !important;
}
#arcane-root.arcane-theme-win95 .prose td {
  background: var(--w95-field) !important;
  color: var(--w95-field-text) !important;
  padding: 2px 8px !important;
  border-top: 0 !important;
  border-left: 0 !important;
  border-right: 1px solid var(--w95-shadow) !important;
  border-bottom: 1px solid var(--w95-shadow) !important;
}
#arcane-root.arcane-theme-win95 .prose tbody tr:hover td {
  background: var(--w95-selection) !important;
  color: var(--w95-selection-text) !important;
}

/* ================= selects ================= */
/* ===================================================================
   GROUP 4 — SELECTS (native + custom) + COMBOBOX
   =================================================================== */

/* ---------- Native <select class="arcane-select"> ----------
   ArcaneSelect writes modern inline styles (1px border, 0.375rem radius, a
   px size table) and draws its chevron as the sibling
   .arcane-native-select-chevron span. Win95 turns the select into the same
   sunken field as the custom select trigger and turns that span into the
   raised arrow button, so the control shows exactly one arrow in both
   schemes. */
#arcane-root.arcane-theme-win95 .arcane-select {
  background-color: var(--w95-field) !important;
  color: var(--w95-field-text) !important;
  box-shadow: var(--w95-sunken) !important;
  border: 0 !important;
  border-radius: 0 !important;
  /* Same height table as the Win95 text input (sm 38 / md 46 / lg 54) so a
     select beside text fields in one row lines up. */
  height: 38px !important;
  padding: 2px calc(1.15rem + 8px) 2px 6px !important;
  font-family: var(--font-sans) !important;
  font-size: 1.219rem !important;
  line-height: normal !important;
  cursor: var(--w95-cursor-arrow) !important;
  transition: none !important;
}
#arcane-root.arcane-theme-win95 .arcane-select[data-size="md"] {
  height: 46px !important;
}
#arcane-root.arcane-theme-win95 .arcane-select[data-size="lg"] {
  height: 54px !important;
}
#arcane-root.arcane-theme-win95 .arcane-native-select-chevron {
  top: 2px !important;
  right: 2px !important;
  bottom: 2px !important;
  width: 1.15rem !important;
  transform: none !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-raised-thin) !important;
}
#arcane-root.arcane-theme-win95 .arcane-native-select-chevron :is(svg, i) {
  display: none !important;
}
#arcane-root.arcane-theme-win95 .arcane-native-select-chevron::after {
  content: '';
  width: 0;
  height: 0;
  border-left: 4px solid transparent;
  border-right: 4px solid transparent;
  border-top: 5px solid var(--w95-face-text);
}
#arcane-root.arcane-theme-win95 .arcane-select:disabled + .arcane-native-select-chevron::after {
  border-top-color: var(--w95-disabled-text);
}
#arcane-root.arcane-theme-win95 .arcane-select-wrapper > label {
  font-family: var(--font-sans) !important;
  font-weight: 700 !important;
  font-size: 1rem !important;
  color: var(--w95-face-text) !important;
}
#arcane-root.arcane-theme-win95 .arcane-select:focus {
  outline: 1px dotted var(--w95-field-text) !important;
  outline-offset: -3px !important;
  box-shadow: var(--w95-sunken) !important;
}
#arcane-root.arcane-theme-win95 .arcane-select:disabled {
  color: var(--w95-disabled-text) !important;
  cursor: var(--w95-cursor-arrow) !important;
}
#arcane-root.arcane-theme-win95 .arcane-select-wrapper {
  display: flex !important;
  flex-direction: column !important;
  gap: 0.3rem !important;
}
#arcane-root.arcane-theme-win95 .arcane-select-error {
  color: var(--destructive) !important;
  font-size: 1.125rem !important;
}

/* ---------- Custom select trigger (.win95-select-trigger) ----------
   Sunken white field (inherited from the input group) laid out as a flex
   row with a RAISED square arrow button pinned to the right. The chevron
   is always the trigger's last-child span. */
#arcane-root.arcane-theme-win95 .win95-select-trigger {
  display: flex !important;
  align-items: center !important;
  gap: 0 !important;
  padding: 2px 2px 2px 6px !important;
  min-height: 1.9rem !important;
  height: auto !important;
  cursor: var(--w95-cursor-arrow) !important;
}
#arcane-root.arcane-theme-win95 .win95-select-trigger > span:last-child {
  flex: 0 0 auto !important;
  align-self: stretch !important;
  width: 1.15rem !important;
  min-width: 1.15rem !important;
  margin-left: 4px !important;
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-raised-thin) !important;
  border-radius: 0 !important;
}
#arcane-root.arcane-theme-win95 .win95-select-trigger > span:last-child :is(svg, i) {
  display: none !important;
}
#arcane-root.arcane-theme-win95 .win95-select-trigger > span:last-child::after {
  content: '' !important;
  width: 0 !important;
  height: 0 !important;
  border-left: 4px solid transparent !important;
  border-right: 4px solid transparent !important;
  border-top: 5px solid var(--w95-face-text) !important;
}

/* ---------- Custom select dropdown surface ----------
   Silver floating menu in the window frame, sharp corners. It stacks like
   the popup menus so fields positioned later in the form cannot paint over
   the open list. */
#arcane-root.arcane-theme-win95 .win95-select-dropdown {
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  border: 0 !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-window-frame) !important;
  padding: 2px !important;
  z-index: 1000 !important;
}

/* ---------- Custom select options ---------- */
#arcane-root.arcane-theme-win95 .win95-select-option {
  display: flex !important;
  align-items: center !important;
  gap: 0.5rem !important;
  width: 100% !important;
  padding: 0.3rem 0.5rem !important;
  border: 0 !important;
  border-radius: 0 !important;
  background: transparent !important;
  color: var(--w95-face-text) !important;
  cursor: var(--w95-cursor-arrow) !important;
  text-align: left !important;
  font-family: var(--font-sans) !important;
  font-size: 1.219rem !important;
  transition: none !important;
}
#arcane-root.arcane-theme-win95 .win95-select-option:hover:not(:disabled):not(.disabled),
#arcane-root.arcane-theme-win95 .win95-select-option:focus-visible:not(:disabled),
#arcane-root.arcane-theme-win95 .win95-select-option.selected:not(:disabled):not(.disabled),
#arcane-root.arcane-theme-win95 .win95-select-option[data-arcane-state="selected"]:not(:disabled):not(.disabled),
#arcane-root.arcane-theme-win95 .win95-select-option[aria-selected="true"]:not(:disabled):not(.disabled) {
  --foreground: var(--w95-selection-text);
  --muted-foreground: var(--w95-selection-text);
  background: var(--w95-selection) !important;
  color: var(--w95-selection-text) !important;
}
#arcane-root.arcane-theme-win95 .win95-select-option.disabled,
#arcane-root.arcane-theme-win95 .win95-select-option:disabled {
  color: var(--w95-disabled-text) !important;
  cursor: var(--w95-cursor-arrow) !important;
}
#arcane-root.arcane-theme-win95 .win95-select-option:disabled:hover {
  background: transparent !important;
  color: var(--w95-disabled-text) !important;
}
#arcane-root.arcane-theme-win95 .win95-select-option:disabled * {
  color: inherit !important;
}
#arcane-root.arcane-theme-win95 .win95-select-option:focus-visible {
  outline-color: var(--w95-selection-text) !important;
}

/* Multi-select rows carry the check box well and its --w95-check tick, drawn
   from the row's live selection state so the tick follows runtime toggles.
   The render base's lucide glyph is hidden. */
#arcane-root.arcane-theme-win95 .win95-select-option-check {
  background: var(--w95-field);
  box-shadow: var(--w95-sunken);
}
#arcane-root.arcane-theme-win95 .win95-select-option-check > * {
  display: none !important;
}
#arcane-root.arcane-theme-win95 .win95-select-option[data-arcane-state="selected"] .win95-select-option-check::after {
  content: '';
  position: absolute;
  inset: 0;
  margin: auto;
  width: 7px;
  height: 7px;
  background-color: var(--w95-field-text);
  -webkit-mask-image: var(--w95-check);
  mask-image: var(--w95-check);
  -webkit-mask-size: 7px 7px;
  mask-size: 7px 7px;
}
#arcane-root.arcane-theme-win95 .win95-select-option:disabled .win95-select-option-check {
  background: var(--w95-face);
}
#arcane-root.arcane-theme-win95 .win95-select-option:disabled .win95-select-option-check::after {
  background-color: var(--w95-disabled-text);
}

/* ---------- Custom select search box (wrapper div + inner input) ---------- */
#arcane-root.arcane-theme-win95 .win95-select-search {
  padding: 2px !important;
  background: transparent !important;
  box-shadow: none !important;
  border: 0 !important;
}
#arcane-root.arcane-theme-win95 .win95-select-search input {
  width: 100% !important;
  background: var(--w95-field) !important;
  color: var(--w95-field-text) !important;
  border: 0 !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-sunken) !important;
  padding: 0.3rem 0.4rem !important;
  font-family: var(--font-sans) !important;
  font-size: 1.219rem !important;
  outline: none !important;
}
#arcane-root.arcane-theme-win95 .win95-select-search input:focus {
  outline: 1px dotted var(--w95-field-text) !important;
  outline-offset: -3px !important;
}

/* ---------- Legacy combobox (.arcane-combobox-*) ----------
   ArcaneCombobox actually renders through the select renderer above; these
   mirror the sunken-field + raised-arrow + navy-menu treatment for the
   script-driven combobox DOM. */
#arcane-root.arcane-theme-win95 .arcane-combobox {
  position: relative !important;
}
#arcane-root.arcane-theme-win95 .arcane-combobox-trigger {
  position: relative !important;
  width: 100% !important;
  background: var(--w95-field) !important;
  color: var(--w95-field-text) !important;
  border: 0 !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-sunken) !important;
  padding: 0.3rem 1.7rem 0.3rem 0.5rem !important;
  min-height: 1.9rem !important;
  text-align: left !important;
  font-family: var(--font-sans) !important;
  font-size: 1.219rem !important;
  cursor: var(--w95-cursor-arrow) !important;
}
#arcane-root.arcane-theme-win95 .arcane-combobox-trigger::after {
  content: '' !important;
  position: absolute !important;
  top: 50% !important;
  right: 5px !important;
  width: 1.15rem !important;
  height: 1.15rem !important;
  transform: translateY(-50%) !important;
  background: var(--w95-face) !important;
  box-shadow: var(--w95-raised-thin) !important;
  z-index: 1 !important;
}
#arcane-root.arcane-theme-win95 .arcane-combobox-trigger::before {
  content: '' !important;
  position: absolute !important;
  top: 50% !important;
  right: 10px !important;
  width: 0 !important;
  height: 0 !important;
  transform: translateY(-50%) !important;
  border-left: 4px solid transparent !important;
  border-right: 4px solid transparent !important;
  border-top: 5px solid var(--w95-face-text) !important;
  z-index: 2 !important;
}
#arcane-root.arcane-theme-win95 .arcane-combobox-dropdown {
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  border: 0 !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-window-frame) !important;
  padding: 2px !important;
}
#arcane-root.arcane-theme-win95 .arcane-combobox-option {
  display: flex !important;
  align-items: center !important;
  gap: 0.5rem !important;
  width: 100% !important;
  padding: 0.3rem 0.5rem !important;
  border: 0 !important;
  border-radius: 0 !important;
  background: transparent !important;
  color: var(--w95-face-text) !important;
  cursor: var(--w95-cursor-arrow) !important;
  text-align: left !important;
  font-family: var(--font-sans) !important;
  font-size: 1.219rem !important;
}
#arcane-root.arcane-theme-win95 .arcane-combobox-option:hover,
#arcane-root.arcane-theme-win95 .arcane-combobox-option.selected,
#arcane-root.arcane-theme-win95 .arcane-combobox-option[aria-selected="true"] {
  background: var(--w95-selection) !important;
  color: var(--w95-selection-text) !important;
}
#arcane-root.arcane-theme-win95 .arcane-combobox-search {
  width: 100% !important;
  background: var(--w95-field) !important;
  color: var(--w95-field-text) !important;
  border: 0 !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-sunken) !important;
  padding: 0.3rem 0.4rem !important;
  margin-bottom: 2px !important;
  font-family: var(--font-sans) !important;
  font-size: 1.219rem !important;
  outline: none !important;
}

/* ================= avatar ================= */
/* ============================================================
   GROUP 5 - Avatar + Media + Progress Ring + Spinners + Image + Icon
   ============================================================ */

/* ---------- Avatar: fixed small square with a raised silver bevel ---------- */
#arcane-root.arcane-theme-win95 .win95-avatar {
  display: inline-flex !important;
  flex: 0 0 auto !important;
  width: 2.5rem !important;
  height: 2.5rem !important;
  position: relative !important;
  overflow: hidden !important;
  box-sizing: border-box !important;
  border: 0 !important;
  border-radius: 0 !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-raised-thin) !important;
}
#arcane-root.arcane-theme-win95 .win95-avatar-inner {
  width: 100% !important;
  height: 100% !important;
}
/* Photo sits flush inside the raised frame (no inner sunken clash). */
#arcane-root.arcane-theme-win95 .win95-avatar img,
#arcane-root.arcane-theme-win95 .win95-avatar-inner img {
  box-shadow: none !important;
  background: transparent !important;
}
/* Status: small round dot pinned to the corner. */
#arcane-root.arcane-theme-win95 .win95-avatar-status {
  position: absolute !important;
  bottom: 0 !important;
  right: 0 !important;
  width: 0.65rem !important;
  height: 0.65rem !important;
  box-sizing: border-box !important;
  background: #008000 !important;
  border: 2px solid var(--w95-face) !important;
  box-shadow: none !important;
  border-radius: 50% !important;
}
/* Avatar-group "+N" overflow -> raised silver chip. */
#arcane-root.arcane-theme-win95 .arcane-avatar-overflow {
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  border: 0 !important;
  box-shadow: var(--w95-raised-thin) !important;
  font-size: 0.8rem !important;
}
/* Avatar badge -> small beveled chip, keep its status colour. */
#arcane-root.arcane-theme-win95 .arcane-avatar-badge {
  border: 0 !important;
  box-shadow: var(--w95-raised-thin) !important;
}

/* ---------- Circular progress (ring) -> framed sunken gauge ---------- */
#arcane-root.arcane-theme-win95 .win95-circular-progress {
  display: inline-flex !important;
  align-items: center !important;
  justify-content: center !important;
  position: relative !important;
  box-sizing: border-box !important;
  width: 3.5rem !important;
  height: 3.5rem !important;
  padding: 0 !important;
  overflow: hidden !important;
  background: var(--w95-field) !important;
  color: var(--w95-field-text) !important;
  box-shadow: var(--w95-sunken) !important;
}
/* The base ring div carries no class -> style the first child as the gauge.
   Win95 shipped no circular progress control at all, so this is the closest
   period-plausible reading: a hard-stop navy arc on the silver control face,
   masked into a chunky ring so the numeric readout stays legible in the hole.
   The renderer feeds the swept angle in as --w95-gauge-pct; there is no
   easing, so the arc snaps to each new value the way a Win95 meter would. */
#arcane-root.arcane-theme-win95 .win95-circular-progress > div:first-child {
  position: absolute !important;
  inset: 0.3rem !important;
  border-radius: 50% !important;
  background: conic-gradient(
    var(--w95-selection) 0 var(--w95-gauge-pct, 0%),
    var(--w95-face) var(--w95-gauge-pct, 0%) 100%
  ) !important;
  -webkit-mask: radial-gradient(circle closest-side, transparent 0 68%, #000 68% 100%) !important;
  mask: radial-gradient(circle closest-side, transparent 0 68%, #000 68% 100%) !important;
  box-shadow: none !important;
  transition: none !important;
  pointer-events: none !important;
}
/* Centre readout sits above the bezel. */
#arcane-root.arcane-theme-win95 .win95-circular-progress > div:nth-child(2) {
  position: relative !important;
  z-index: 1 !important;
}
#arcane-root.arcane-theme-win95 .win95-circular-progress span {
  font-weight: 700 !important;
  line-height: 1 !important;
  color: var(--w95-selection) !important;
}
#arcane-root.arcane-theme-win95 .win95-circular-progress > div:nth-child(2) > span:first-child {
  font-size: 0.9rem !important;
}
#arcane-root.arcane-theme-win95 .win95-circular-progress > div:nth-child(2) > span:nth-child(2) {
  font-size: 0.65rem !important;
  color: var(--w95-field-text) !important;
}

/* ---------- Loaders -> palette-selected animated Windows hourglass ----------
   The art is a 26x26 bitmap, and pixel art only survives at 1:1 or a whole
   integer multiple. Callers ask for 16px, 20px, 24px and 40px, every one of
   which is a fractional scale that shears rows out of the hourglass rather
   than crisping it, so --arcane-loader-size is snapped DOWN to the nearest
   multiple of 26 with 26px as the floor. `background-size: contain` on a box
   that is already a whole multiple then lands the frames on the pixel grid.
   The first width/height pair is the fallback for engines without round(). */
#arcane-root.arcane-theme-win95 .arcane-loader {
  display: inline-block !important;
  box-sizing: border-box !important;
  flex-shrink: 0 !important;
  width: 26px !important;
  height: 26px !important;
  width: max(26px, round(down, var(--arcane-loader-size, 26px), 26px)) !important;
  height: max(26px, round(down, var(--arcane-loader-size, 26px), 26px)) !important;
  vertical-align: middle !important;
  background-color: transparent !important;
  background-image: var(--w95-loader-image) !important;
  /* HiDPI: hand the display the sheet drawn at its own device resolution
     instead of letting it upscale the 1x frames. Written as literal URLs
     rather than through the custom property so that an engine without
     image-set() drops this declaration and keeps the 1x line above. */
  background-image: image-set(
    url("$loaderDataUri") 1x,
    url("$loaderDataUri2x") 2x,
    url("$loaderDataUri3x") 3x
  ) !important;
  background-position: center !important;
  background-repeat: no-repeat !important;
  background-size: contain !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: none !important;
  animation: none !important;
  transition: none !important;
  image-rendering: -moz-crisp-edges;
  image-rendering: crisp-edges;
  image-rendering: pixelated !important;
}

/* ---------- Images -> sunken Win95 frame; broken images sit in a well ---------- */
#arcane-root.arcane-theme-win95 img,
#arcane-root.arcane-theme-win95 .win95-image {
  box-shadow: var(--w95-sunken-thin) !important;
}
/* Image card is the well behind the picture (shows through when the img is broken). */
#arcane-root.arcane-theme-win95 .arcane-image-card {
  background: var(--w95-field) !important;
  color: var(--w95-field-text) !important;
  box-shadow: var(--w95-sunken-thin) !important;
}

/* ---------- Icons -> keep centred; inline px sizing (12-48px) still wins ---------- */
#arcane-root.arcane-theme-win95 svg {
  vertical-align: middle !important;
  flex-shrink: 0 !important;
}

/* ================= accordion ================= */
/* ============================================================
   GROUP 6 — Accordion / Disclosure / OTP / Tabs / Breadcrumbs
   Authentic Win95 3D bevels. All overrides use !important to
   beat the render-base inline styles.
   ============================================================ */

/* ---------- Accordion (raised header bars + [+]/[-] box) ---------- */

/* Root is a flat stack, not an outer framed panel — each header carries
   its own raised bevel. Override the shared surface raised shadow. */
#arcane-root.arcane-theme-win95 .win95-accordion {
  background: transparent !important;
  box-shadow: none !important;
  padding: 0 !important;
  gap: 3px !important;
}
#arcane-root.arcane-theme-win95 .win95-accordion > details {
  background: transparent !important;
  box-shadow: none !important;
  border: none !important;
}

/* Header = raised Win95 push-bar that presses in on :active. */
#arcane-root.arcane-theme-win95 .win95-accordion summary {
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-raised) !important;
  padding: 0.4rem 0.6rem !important;
  gap: 0.6rem !important;
  list-style: none !important;
  transition: none !important;
}
#arcane-root.arcane-theme-win95 .win95-accordion summary:active {
  box-shadow: var(--w95-pressed) !important;
}
#arcane-root.arcane-theme-win95 .win95-accordion summary::-webkit-details-marker {
  display: none !important;
}
#arcane-root.arcane-theme-win95 .win95-accordion summary::marker {
  content: '' !important;
}

/* Title text -> plain Win95 system font. */
#arcane-root.arcane-theme-win95 .win95-accordion summary > div:first-child {
  font-family: var(--font-sans) !important;
  font-weight: 700 !important;
  font-size: 1.05rem !important;
  letter-spacing: normal !important;
  line-height: 1.3 !important;
  color: var(--w95-face-text) !important;
}

/* Expand indicator: a small WHITE field box holding a [+] (closed) or
   [-] (open) glyph — the classic Win95 tree/collapse control. The modern
   chevron <i>/svg inside is hidden. */
#arcane-root.arcane-theme-win95 .win95-accordion .faq-chevron {
  width: 1rem !important;
  min-width: 1rem !important;
  height: 1rem !important;
  padding: 0 !important;
  display: inline-flex !important;
  align-items: center !important;
  justify-content: center !important;
  background: var(--w95-field) !important;
  color: var(--w95-field-text) !important;
  box-shadow: none !important;
  border: 1px solid var(--w95-shadow) !important;
  font-family: var(--font-sans) !important;
  font-weight: 700 !important;
  font-size: 0.9rem !important;
  line-height: 1 !important;
}
#arcane-root.arcane-theme-win95 .win95-accordion .faq-chevron > * {
  display: none !important;
}
#arcane-root.arcane-theme-win95 .win95-accordion details:not([open]) .faq-chevron::before {
  content: '+' !important;
}
#arcane-root.arcane-theme-win95 .win95-accordion details[open] .faq-chevron::before {
  content: '-' !important;
}

/* Panel body = recessed silver area seated under the header. */
#arcane-root.arcane-theme-win95 .win95-accordion summary + div {
  padding: 0.6rem 0.7rem !important;
  border-top: none !important;
  background: var(--w95-face) !important;
  box-shadow: var(--w95-sunken-thin) !important;
  margin: 0 0.1rem !important;
}
#arcane-root.arcane-theme-win95 .win95-accordion summary + div > div {
  padding-top: 0 !important;
  font-size: 1rem !important;
  line-height: 1.5 !important;
  color: var(--w95-face-text) !important;
}

/* ---------- Disclosure / Expander (twisty triangle, indented body) ---------- */

#arcane-root.arcane-theme-win95 .win95-disclosure {
  background: transparent !important;
  box-shadow: none !important;
  border: none !important;
}
#arcane-root.arcane-theme-win95 .win95-disclosure-summary {
  display: flex !important;
  align-items: center !important;
  gap: 0.4rem !important;
  padding: 0.2rem 0.1rem !important;
  cursor: var(--w95-cursor-arrow) !important;
  list-style: none !important;
  -webkit-user-select: none !important;
  user-select: none !important;
  font-family: var(--font-sans) !important;
  font-weight: 700 !important;
  font-size: 1.05rem !important;
  color: var(--w95-face-text) !important;
}
#arcane-root.arcane-theme-win95 .win95-disclosure-summary::-webkit-details-marker {
  display: none !important;
}
#arcane-root.arcane-theme-win95 .win95-disclosure-summary::marker {
  content: '' !important;
}
#arcane-root.arcane-theme-win95 .win95-disclosure-summary-content {
  color: var(--w95-face-text) !important;
}

/* Triangle twisty: sits on the LEFT, points right when closed, down when open. */
#arcane-root.arcane-theme-win95 .win95-disclosure-chevron {
  order: -1 !important;
  flex: 0 0 auto !important;
  display: inline-block !important;
  font-size: 0.7rem !important;
  line-height: 1 !important;
  color: var(--w95-face-text) !important;
  transform: rotate(-90deg) !important;
  transition: none !important;
}
#arcane-root.arcane-theme-win95 .win95-disclosure[open] .win95-disclosure-chevron {
  transform: rotate(0deg) !important;
}

/* Body indented under the label. */
#arcane-root.arcane-theme-win95 .win95-disclosure-content {
  padding: 0.3rem 0 0.4rem 1.3rem !important;
  border-top: none !important;
  font-size: 1rem !important;
  line-height: 1.5 !important;
  color: var(--w95-face-text) !important;
}

/* ---------- OTP input (row of small sunken white field boxes) ---------- */

#arcane-root.arcane-theme-win95 .win95-otp-input {
  display: flex !important;
  flex-direction: column !important;
  gap: 0.4rem !important;
}
#arcane-root.arcane-theme-win95 .win95-otp-input > span:first-child {
  font-family: var(--font-sans) !important;
  font-weight: 700 !important;
  font-size: 1rem !important;
  color: var(--w95-face-text) !important;
}
#arcane-root.arcane-theme-win95 .win95-otp-digits {
  display: inline-flex !important;
  align-items: center !important;
  gap: 0.3rem !important;
}
#arcane-root.arcane-theme-win95 .win95-otp-digits > span {
  font-weight: 700 !important;
  color: var(--w95-face-text) !important;
}
#arcane-root.arcane-theme-win95 .win95-otp-digit {
  width: 1.7rem !important;
  min-width: 1.7rem !important;
  height: 2rem !important;
  padding: 0 !important;
  text-align: center !important;
  font-family: var(--font-sans) !important;
  font-weight: 700 !important;
  font-size: 1.1rem !important;
  background: var(--w95-field) !important;
  color: var(--w95-field-text) !important;
  border: none !important;
  box-shadow: var(--w95-sunken) !important;
}
#arcane-root.arcane-theme-win95 .win95-otp-digit:focus {
  outline: 1px dotted var(--w95-field-text) !important;
  outline-offset: -3px !important;
  box-shadow: var(--w95-sunken) !important;
}

/* ---------- Tabs (classic folder — active tab connects to panel) ---------- */

/* Kill the base column gap so the active tab can meet the panel. */
#arcane-root.arcane-theme-win95 .win95-tabs {
  gap: 0 !important;
}

#arcane-root.arcane-theme-win95 .win95-tabs-list,
#arcane-root.arcane-theme-win95 .win95-tab-bar {
  display: inline-flex !important;
  align-items: flex-end !important;
  gap: 0 !important;
  padding: 0 !important;
  margin: 0 !important;
  background: transparent !important;
  box-shadow: none !important;
  position: relative !important;
  z-index: 2 !important;
}

/* Base tab = raised silver folder tab. */
#arcane-root.arcane-theme-win95 .win95-tabs-trigger,
#arcane-root.arcane-theme-win95 .win95-tab-bar-item {
  position: relative !important;
  padding: 0.3rem 0.85rem !important;
  margin: 0 !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-raised) !important;
  font-family: var(--font-sans) !important;
  font-size: 1.05rem !important;
  font-weight: 400 !important;
  letter-spacing: normal !important;
  text-transform: none !important;
  cursor: var(--w95-cursor-arrow) !important;
  transition: none !important;
}

/* Inactive tabs sit slightly lower and shorter (recessed). */
#arcane-root.arcane-theme-win95 .win95-tabs-trigger:not(.active) {
  margin-bottom: 2px !important;
  padding-top: 0.28rem !important;
  padding-bottom: 0.28rem !important;
}

/* Active tab: brought forward, taller, NO bottom bevel so it fuses into
   the panel below. Top+left raised highlight, right dark edge only. The
   first-listed shadow paints on top, so each 1px outer edge is declared
   before the 2px inner one; the reverse order buried the white and black
   edges under the wider light and shadow bands. */
#arcane-root.arcane-theme-win95 .win95-tabs-trigger.active {
  z-index: 3 !important;
  margin-bottom: 0 !important;
  padding: 0.42rem 0.95rem 0.44rem !important;
  box-shadow:
    inset 1px 1px 0 var(--w95-hilite),
    inset 2px 2px 0 var(--w95-light),
    inset -1px 0 0 var(--w95-dark),
    inset -2px 0 0 var(--w95-shadow) !important;
}

/* Content panel rises 2px under the tab row; the active tab overlaps it. */
#arcane-root.arcane-theme-win95 .win95-tabs-content {
  padding: 0.85rem !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-raised) !important;
  margin-top: -2px !important;
  position: relative !important;
  z-index: 1 !important;
}

/* Content-less tab bar: the selected item reads as pressed-in. */
#arcane-root.arcane-theme-win95 .win95-tab-bar-item.active {
  box-shadow: var(--w95-pressed) !important;
  padding: 0.32rem 0.87rem !important;
}

/* ---------- Breadcrumbs (plain Win95 text, no pills) ---------- */

#arcane-root.arcane-theme-win95 .win95-breadcrumbs {
  font-family: var(--font-sans) !important;
  color: var(--w95-face-text) !important;
}
#arcane-root.arcane-theme-win95 .win95-breadcrumb-link,
#arcane-root.arcane-theme-win95 .win95-breadcrumb-button {
  background: transparent !important;
  border: none !important;
  box-shadow: none !important;
  padding: 0 !important;
  color: var(--w95-face-text) !important;
  text-decoration: none !important;
  font-family: var(--font-sans) !important;
  cursor: var(--w95-cursor-arrow) !important;
}
/* The crumb that actually navigates is hypertext, so it takes the IE hand; its
   sibling button is a control and keeps the arrow set above. */
#arcane-root.arcane-theme-win95 a.win95-breadcrumb-link[href] {
  cursor: var(--w95-cursor-hand) !important;
}
#arcane-root.arcane-theme-win95 .win95-breadcrumb-link:focus,
#arcane-root.arcane-theme-win95 .win95-breadcrumb-button:focus {
  outline: 1px dotted var(--w95-face-text) !important;
  outline-offset: 1px !important;
}
#arcane-root.arcane-theme-win95 .win95-breadcrumb-current {
  color: var(--w95-face-text) !important;
  font-weight: 700 !important;
}
#arcane-root.arcane-theme-win95 .win95-breadcrumb-separator {
  color: var(--w95-disabled-text) !important;
  font-family: var(--font-sans) !important;
  user-select: none !important;
  padding: 0 0.1rem !important;
}

/* ================= chart ================= */
/* ===================================================================
   GROUP 7 — Chart, Skeleton, Stat cards, Pagination, EmptyState polish
   =================================================================== */

/* ---------- Chart: framed Win95 plotting well ---------- */
/* Base emits: .win95-chart > [span title][span desc] then one row per
   point: div( span.label , div.track( div.fill ) , span.value ). None of
   the inner nodes carry classes, so they are targeted structurally. */
#arcane-root.arcane-theme-win95 .win95-chart {
  display: flex !important;
  flex-direction: column !important;
  gap: 0.5rem !important;
  padding: 0.75rem !important;
  background: var(--w95-field) !important;
  color: var(--w95-field-text) !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-sunken) !important;
}
/* Title / description sit as direct span children -> small black text. */
#arcane-root.arcane-theme-win95 .win95-chart > span {
  font-size: 0.9rem !important;
  line-height: 1.3 !important;
  color: var(--w95-field-text) !important;
}
#arcane-root.arcane-theme-win95 .win95-chart > span:first-child {
  font-weight: 700 !important;
}
/* Each data point row: label | track | value laid out on one baseline. */
#arcane-root.arcane-theme-win95 .win95-chart > div {
  display: flex !important;
  align-items: center !important;
  gap: 0.5rem !important;
}
/* Axis labels + values: small black text, no wrap. */
#arcane-root.arcane-theme-win95 .win95-chart > div > span {
  font-size: 0.8rem !important;
  color: var(--w95-field-text) !important;
  white-space: nowrap !important;
}
#arcane-root.arcane-theme-win95 .win95-chart > div > span:first-child {
  flex: 0 0 auto !important;
  min-width: 4.5rem !important;
}
#arcane-root.arcane-theme-win95 .win95-chart > div > span:last-child {
  flex: 0 0 auto !important;
  min-width: 2rem !important;
  text-align: right !important;
  font-weight: 700 !important;
  font-variant-numeric: tabular-nums !important;
}
/* Track: sunken white well the bar sits inside. */
#arcane-root.arcane-theme-win95 .win95-chart > div > div {
  flex: 1 1 auto !important;
  height: 16px !important;
  padding: 0 !important;
  background: var(--w95-field) !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-sunken-thin) !important;
  overflow: hidden !important;
}
/* Fill bar: navy selection, sharp edges. Width comes from the inline style. */
#arcane-root.arcane-theme-win95 .win95-chart > div > div > div {
  height: 100% !important;
  background: var(--w95-selection) !important;
  border-radius: 0 !important;
  box-shadow: none !important;
}

/* ---------- Skeletons: dithered sunken placeholder wells ----------
   Win95 had no skeleton-placeholder idea at all. Its stand-in for a region
   with nothing in it yet is the 2x2 checkerboard dither of white and silver —
   the same 50% pattern the scrollbar track is painted with — inside a sunken
   well, so an unloaded block reads as empty rather than as flat grey paint. */
#arcane-root.arcane-theme-win95 .win95-skeleton {
  background-color: #ffffff !important;
  background-image:
    linear-gradient(45deg, #c0c0c0 25%, transparent 25%, transparent 75%, #c0c0c0 75%),
    linear-gradient(45deg, #c0c0c0 25%, transparent 25%, transparent 75%, #c0c0c0 75%) !important;
  background-size: 2px 2px !important;
  background-position: 0 0, 1px 1px !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-sunken-thin) !important;
  /* Win95 placeholders do not shimmer. */
  animation: none !important;
  transition: none !important;
}

/* ---------- Stat cards: raised silver panel + sunken readout well ---------- */
#arcane-root.arcane-theme-win95 .win95-stat-card {
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-raised) !important;
}
/* Icon badge -> thin raised chip. */
#arcane-root.arcane-theme-win95 .win95-stat-card-icon {
  background: var(--w95-face) !important;
  color: var(--w95-selection) !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-raised-thin) !important;
}
/* Value row (the only non-icon direct div child) -> beveled sunken well
   that hugs the number, like a Win95 numeric readout. */
#arcane-root.arcane-theme-win95 .win95-stat-card > div:not(.win95-stat-card-icon) {
  align-self: flex-start !important;
  padding: 0.15rem 0.5rem !important;
  background: var(--w95-field) !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-sunken-thin) !important;
}
/* The big number reads as field text; the trend span keeps its up/down colour. */
#arcane-root.arcane-theme-win95 .win95-stat-card > div:not(.win95-stat-card-icon) > span:first-child {
  color: var(--w95-field-text) !important;
}

/* ---------- Pagination: raised numbered buttons, current = pressed ---------- */
#arcane-root.arcane-theme-win95 .win95-pagination {
  gap: 2px !important;
}
#arcane-root.arcane-theme-win95 .win95-pagination-button {
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-raised) !important;
  font-weight: 700 !important;
  transition: none !important;
}
#arcane-root.arcane-theme-win95 .win95-pagination-button:active:not(.disabled) {
  box-shadow: var(--w95-pressed) !important;
}
/* Current page stays visually pressed / sunken. */
#arcane-root.arcane-theme-win95 .win95-pagination-button.active {
  box-shadow: var(--w95-pressed) !important;
  color: var(--w95-face-text) !important;
}
#arcane-root.arcane-theme-win95 .win95-pagination-button.disabled {
  opacity: 0.5 !important;
  color: var(--w95-disabled-text) !important;
  box-shadow: var(--w95-raised) !important;
}
#arcane-root.arcane-theme-win95 .win95-pagination-ellipsis {
  color: var(--w95-face-text) !important;
}

/* ---------- EmptyState: verified raised silver panel; lay out its content ---------- */
#arcane-root.arcane-theme-win95 .win95-empty-state-content {
  display: flex !important;
  flex-direction: column !important;
  align-items: center !important;
  gap: 0.5rem !important;
}
#arcane-root.arcane-theme-win95 .win95-empty-state-actions {
  display: flex !important;
  justify-content: center !important;
  gap: 0.5rem !important;
  margin-top: 0.5rem !important;
}

/* Docs article prose scaled to the +50% default (arcane_lexicon's prose styles
   are appended after this, so id+class specificity + !important wins). */
#arcane-root.arcane-theme-win95 .kb-article-panel .prose,
#arcane-root.arcane-theme-win95 .kb-article-panel .prose p,
#arcane-root.arcane-theme-win95 .kb-article-panel .prose ul,
#arcane-root.arcane-theme-win95 .kb-article-panel .prose ol,
#arcane-root.arcane-theme-win95 .kb-article-panel .prose li,
#arcane-root.arcane-theme-win95 .kb-article-panel .prose blockquote,
#arcane-root.arcane-theme-win95 .kb-article-panel .prose td,
#arcane-root.arcane-theme-win95 .kb-page-description {
  font-size: 1.5rem !important;
  line-height: 1.5 !important;
}

/* ============================================================
   POLISH 2: Win95 scrollbar w/ arrow buttons, Start-button flag,
   bounded title bars, menu-bar spacing, cleaner tree + de-treed TOC.
   ============================================================ */
/* ========== scrollbar ==========
   SM_CXVSCROLL / SM_CYHSCROLL is 16 in Windows 95 and every part of the control
   — arrow buttons, glyphs, thumb — is measured off that module, so the width
   has to be exactly 16px or the 16x16 arrow art lands off the pixel grid.
   Track and thumb resolve through --w95-field / --w95-face rather than literal
   #ffffff / #c0c0c0 so the dark appearance scheme re-points the dither for
   free; a hard-coded white checkerboard was the brightest thing on screen in
   High Contrast. */
#arcane-root.arcane-theme-win95 ::-webkit-scrollbar {
  width: 16px !important;
  height: 16px !important;
}
#arcane-root.arcane-theme-win95 ::-webkit-scrollbar-track {
  background-color: var(--w95-field) !important;
  background-image:
    linear-gradient(45deg, var(--w95-face) 25%, transparent 25%, transparent 75%, var(--w95-face) 75%),
    linear-gradient(45deg, var(--w95-face) 25%, transparent 25%, transparent 75%, var(--w95-face) 75%) !important;
  background-size: 2px 2px !important;
  background-position: 0 0, 1px 1px !important;
  box-shadow: none !important;
  border-radius: 0 !important;
}
#arcane-root.arcane-theme-win95 ::-webkit-scrollbar-thumb {
  background: var(--w95-face) !important;
  background-image: none !important;
  box-shadow: var(--w95-raised) !important;
  border: none !important;
  border-radius: 0 !important;
  min-height: 20px !important;
  min-width: 20px !important;
}
#arcane-root.arcane-theme-win95 ::-webkit-scrollbar-button {
  display: block !important;
  width: 16px !important;
  height: 16px !important;
  background-color: var(--w95-face) !important;
  box-shadow: var(--w95-raised) !important;
  border: none !important;
  border-radius: 0 !important;
  background-repeat: no-repeat !important;
  background-position: center center !important;
  background-size: 16px 16px !important;
}
#arcane-root.arcane-theme-win95 ::-webkit-scrollbar-button:vertical:decrement {
  background-image: var(--w95-scroll-up) !important;
}
#arcane-root.arcane-theme-win95 ::-webkit-scrollbar-button:vertical:increment {
  background-image: var(--w95-scroll-down) !important;
}
#arcane-root.arcane-theme-win95 ::-webkit-scrollbar-button:horizontal:decrement {
  background-image: var(--w95-scroll-left) !important;
}
#arcane-root.arcane-theme-win95 ::-webkit-scrollbar-button:horizontal:increment {
  background-image: var(--w95-scroll-right) !important;
}
/* A pressed scroll arrow did not invert its bevel like a push button: it went
   FLAT, a single #808080 line on all four sides, and the glyph stepped one
   pixel down-right. The arrow art is the full 16x16 cell, so the step is a
   whole-pixel background offset. */
#arcane-root.arcane-theme-win95 ::-webkit-scrollbar-button:active {
  box-shadow: inset 0 0 0 1px var(--w95-shadow) !important;
  background-position: 1px 1px !important;
}
#arcane-root.arcane-theme-win95 ::-webkit-scrollbar-button:vertical:start:increment,
#arcane-root.arcane-theme-win95 ::-webkit-scrollbar-button:vertical:end:decrement,
#arcane-root.arcane-theme-win95 ::-webkit-scrollbar-button:horizontal:start:increment,
#arcane-root.arcane-theme-win95 ::-webkit-scrollbar-button:horizontal:end:decrement {
  display: none !important;
}
#arcane-root.arcane-theme-win95 ::-webkit-scrollbar-corner {
  background: var(--w95-face) !important;
}

/* ========== titlebars ========== */
/* Landing terminal mock: inset the whole client area (navy bar + body) 3px
   inside the card's raised frame, so the silver frame shows around the bar.
   The bar keeps its [_][]X dots on the RIGHT (justify-content:flex-end). */
#arcane-root.arcane-theme-win95 .kb-landing-terminal {
  padding: 3px !important;
}

/* ========== trees ========== */
/* ============================================================
   POLISH 5 — Crisp sidebar tree + clean TOC (no Explorer lines)
   ============================================================ */

/* ---- A. SIDEBAR TREE — keep the [+]/[-] node boxes, drop the dotted guides ---- */

/* Group-header / summary node box: a small (~10px) flat WHITE field square with
   a 1px gray border and a solid black +/- glyph perfectly centered, sitting in a
   consistent left gutter. Overrides the earlier 11px/13.5px box. */
#arcane-root.arcane-theme-win95 .sidebar-section-header::before,
#arcane-root.arcane-theme-win95 .sidebar-summary::before {
  width: 10px !important;
  height: 10px !important;
  margin-right: 6px !important;
  padding: 0 !important;
  background: var(--w95-field) !important;
  border: 1px solid var(--w95-shadow) !important;
  box-shadow: none !important;
  color: var(--w95-field-text) !important;
  font-family: "MS Sans Serif", Tahoma, Geneva, sans-serif !important;
  font-size: 10px !important;
  font-weight: 700 !important;
  line-height: 1 !important;
  text-align: center !important;
}

/* Tree body: clean indentation only. Remove the dotted vertical trunk (border /
   background gradient) for a crisp, uncluttered Win95 look. */
#arcane-root.arcane-theme-win95 .sidebar-tree {
  position: static !important;
  margin-left: 0 !important;
  margin-top: 0 !important;
  padding-left: 16px !important;
  gap: 0 !important;
  border-left: 0 !important;
  background: none !important;
  background-image: none !important;
}

#arcane-root.arcane-theme-win95 .sidebar-tree-item {
  position: static !important;
}

/* Remove the dotted horizontal elbows on each row. */
#arcane-root.arcane-theme-win95 .sidebar-tree-item::before,
#arcane-root.arcane-theme-win95 .sidebar-tree-item::after {
  content: none !important;
  display: none !important;
  border: 0 !important;
  background: none !important;
}

/* Leaf rows: single-line black text, no hover fill (selection-driven, not
   hover-driven). Selection behaviour itself is re-asserted below. */
#arcane-root.arcane-theme-win95 .sidebar-tree .sidebar-link {
  padding: 1px 6px !important;
  border-radius: 0 !important;
  color: var(--w95-face-text) !important;
  font-size: 16.5px !important;
  line-height: 17px !important;
  white-space: nowrap !important;
  overflow: hidden !important;
  text-overflow: ellipsis !important;
}

/* Re-assert the navy selection bar on the active leaf so the crisp generic
   leaf-color rule above cannot recolor it (equal specificity, later source). */
#arcane-root.arcane-theme-win95 .sidebar-tree .sidebar-link.active,
#arcane-root.arcane-theme-win95 .sidebar-link.active {
  background: var(--w95-selection) !important;
  color: var(--w95-selection-text) !important;
}
#arcane-root.arcane-theme-win95 .sidebar-tree .sidebar-link.active .sidebar-icon,
#arcane-root.arcane-theme-win95 .sidebar-tree .sidebar-link.active .sidebar-icon-svg {
  color: var(--w95-selection-text) !important;
}

/* ---- B. TOC ("On this page") — a table of contents is NOT a file tree ---- */

/* Neutralize the Explorer tree connectors injected by arcaneTocTreeLinesCss
   (and the earlier win95 recolor of them). */
#arcane-root.arcane-theme-win95 .kb-toc-panel .toc-content > ul > li::before,
#arcane-root.arcane-theme-win95 .kb-toc-panel .toc-content > ul > li::after,
#arcane-root.arcane-theme-win95 .kb-toc-panel .toc-content ul ul li::before,
#arcane-root.arcane-theme-win95 .kb-toc-panel .toc-content ul ul li::after,
#arcane-root.arcane-theme-win95 .kb-toc-panel .toc-content li::before,
#arcane-root.arcane-theme-win95 .kb-toc-panel .toc-content li::after {
  content: none !important;
  display: none !important;
  background: none !important;
  border: 0 !important;
}

/* Remove any tree trunks / left rails from the TOC containers and rows. */
#arcane-root.arcane-theme-win95 .kb-toc-panel .toc,
#arcane-root.arcane-theme-win95 .kb-toc-panel .toc-content,
#arcane-root.arcane-theme-win95 .kb-toc-panel .toc-content ul,
#arcane-root.arcane-theme-win95 .kb-toc-panel .toc-list,
#arcane-root.arcane-theme-win95 .kb-toc-panel li {
  background-image: none !important;
  border-left: 0 !important;
  list-style: none !important;
}

/* Clean, simple Win95 indentation: flush top level, ~12px per nested level. */
#arcane-root.arcane-theme-win95 .kb-toc-panel .toc-content > ul {
  padding-left: 0 !important;
  margin-left: 0 !important;
}
#arcane-root.arcane-theme-win95 .kb-toc-panel .toc-content ul ul {
  padding-left: 12px !important;
  margin-left: 0 !important;
  margin-top: 0 !important;
}

/* "On this page" heading: a small bold label (keeps its etched groove). */
#arcane-root.arcane-theme-win95 .kb-toc-panel .toc-title {
  padding: 0 0 3px 0 !important;
  margin: 0 0 5px 0 !important;
  color: var(--w95-face-text) !important;
  font-size: 15px !important;
  font-weight: 700 !important;
  letter-spacing: normal !important;
  text-transform: none !important;
}

/* TOC links: small black text on a single line, no hover fill. */
#arcane-root.arcane-theme-win95 .kb-toc-panel .toc-content a {
  display: block !important;
  margin: 0 !important;
  padding: 1px 6px !important;
  border-radius: 0 !important;
  background: transparent !important;
  color: var(--w95-face-text) !important;
  font-size: 15px !important;
  line-height: 17px !important;
  white-space: nowrap !important;
  overflow: hidden !important;
  text-overflow: ellipsis !important;
}
#arcane-root.arcane-theme-win95 .kb-toc-panel .toc-content a:hover {
  background: transparent !important;
  color: var(--w95-face-text) !important;
}

/* Active TOC item: navy Win95 selection bar. */
#arcane-root.arcane-theme-win95 .kb-toc-panel .toc-content a.toc-active {
  background: var(--w95-selection) !important;
  color: var(--w95-selection-text) !important;
  font-weight: 400 !important;
}

/* ============================================================
   OVERLAYS + POLISH: drawer/sheet/dialog/command/menus/tooltip/
   toast (were invisible) + clock, table hover, window controls.
   ============================================================ */
/* ========== drawer ========== */
/* ============================================================
   Drawer — slide-out Win95 window (overlay was transparent)
   ============================================================ */

/* Modal scrim behind the panel. */
#arcane-root.arcane-theme-win95 .win95-drawer-overlay {
  background: rgba(0, 0, 0, 0.45) !important;
}

/* Opaque silver window. data-position is on the overlay, so the panel edge
   anchoring is handled by the render base; we only supply the surface, the
   window frame and a small gutter inside it. */
#arcane-root.arcane-theme-win95 .win95-drawer {
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-window-frame) !important;
  border: none !important;
  border-radius: 0 !important;
  padding: 3px !important;
}

/* No directional drop shadow: Windows 95 had no blurred shadow and no alpha
   compositing anywhere, so a 10px gaussian under a silver panel was the single
   most modern artifact in this sheet. The raised bevel is the panel's edge and
   the 45%-black scrim above already separates it from the page. */

/* Header → solid navy title bar. */
#arcane-root.arcane-theme-win95 .win95-drawer-header {
  background: var(--w95-title-bar) !important;
  color: var(--w95-title-text) !important;
  min-height: 20px !important;
  padding: 2px 3px 2px 6px !important;
  border-bottom: none !important;
  align-items: center !important;
  flex-shrink: 0 !important;
}
/* Force the title slot white + bold (excludes the close button, which is a
   sibling <button>, not inside the header slot's <div>). */
#arcane-root.arcane-theme-win95 .win95-drawer-header > div,
#arcane-root.arcane-theme-win95 .win95-drawer-header > div * {
  color: var(--w95-title-text) !important;
  font-weight: 700 !important;
  letter-spacing: 0.02em;
}

/* The title-bar close button is styled with the dialog's, below. */

/* Body → silver face, black text. */
#arcane-root.arcane-theme-win95 .win95-drawer-content {
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
}

/* Footer → silver face with a raised horizontal separator on top. */
#arcane-root.arcane-theme-win95 .win95-drawer-footer {
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  border-top: none !important;
  box-shadow: inset 0 1px 0 var(--w95-shadow), inset 0 2px 0 var(--w95-hilite) !important;
}

/* ============================================================
   Sheet — bottom / edge Win95 panel (overlay was transparent)
   ============================================================ */

#arcane-root.arcane-theme-win95 .win95-sheet-overlay {
  background: rgba(0, 0, 0, 0.45) !important;
}

#arcane-root.arcane-theme-win95 .win95-sheet {
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-window-frame) !important;
  border: none !important;
  border-radius: 0 !important;
  padding: 3px !important;
}
/* Same as the drawer: the bevel is the edge, the scrim is the separation, and
   Win95 drew no blurred shadow under anything. */

/* Drag handle → a small raised Win95 grip (square, not a rounded pill). */
#arcane-root.arcane-theme-win95 .win95-sheet-drag-handle > div {
  border-radius: 0 !important;
  width: 44px !important;
  height: 5px !important;
  background: var(--w95-face) !important;
  box-shadow: var(--w95-raised-thin) !important;
  opacity: 1 !important;
}

/* Header → solid navy title bar (title + description forced white). */
#arcane-root.arcane-theme-win95 .win95-sheet-header {
  background: var(--w95-title-bar) !important;
  color: var(--w95-title-text) !important;
  min-height: 20px !important;
  padding: 3px 3px 3px 6px !important;
  border-bottom: none !important;
  align-items: center !important;
  flex-shrink: 0 !important;
}
#arcane-root.arcane-theme-win95 .win95-sheet-header > div,
#arcane-root.arcane-theme-win95 .win95-sheet-header > div * {
  color: var(--w95-title-text) !important;
}
#arcane-root.arcane-theme-win95 .win95-sheet-header h2 {
  font-weight: 700 !important;
  margin: 0 !important;
  letter-spacing: 0.02em;
}

/* The sheet's close button is styled with the dialog's, below. */

#arcane-root.arcane-theme-win95 .win95-sheet-content {
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
}
#arcane-root.arcane-theme-win95 .win95-sheet-footer {
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  border-top: none !important;
  box-shadow: inset 0 1px 0 var(--w95-shadow), inset 0 2px 0 var(--w95-hilite) !important;
}

/* ========== dialog ========== */
/* ============================================================
   PASS 2 — DIALOG + CONFIRM/ALERT DIALOG + COMMAND PALETTE
   These overlay surfaces rendered with transparent panels and no
   scrim/positioning (the theme never styled their win95-* classes,
   and the framework does not position them generically). Make them
   opaque raised Win95 windows over a semi-transparent scrim.
   ============================================================ */

/* ---------- Modal overlays / scrims (dialog + command) ---------- */

#arcane-root.arcane-theme-win95 .win95-dialog-overlay,
#arcane-root.arcane-theme-win95 .win95-command-overlay {
  position: fixed !important;
  inset: 0 !important;
  z-index: 1000 !important;
  display: flex !important;
  justify-content: center !important;
  box-sizing: border-box !important;
  overflow-y: auto !important;
  background: rgba(0, 0, 0, 0.45) !important;
}
#arcane-root.arcane-theme-win95 .win95-dialog-overlay {
  align-items: center !important;
  padding: 1.5rem 1rem !important;
}
#arcane-root.arcane-theme-win95 .win95-command-overlay {
  align-items: flex-start !important;
  padding: 10vh 1rem 1rem 1rem !important;
}
/* Keep the runtime's closed-surface hide winning over the !important
   display above (higher specificity + later, so [hidden] hides). */
#arcane-root.arcane-theme-win95 .win95-dialog-overlay[hidden],
#arcane-root.arcane-theme-win95 .win95-command-overlay[hidden] {
  display: none !important;
}

/* ---------- Dialog window (also used by confirm/alert) ---------- */

#arcane-root.arcane-theme-win95 .win95-dialog {
  position: relative !important;
  display: flex !important;
  flex-direction: column !important;
  box-sizing: border-box !important;
  max-height: calc(100vh - 3rem) !important;
  padding: 3px !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-window-frame) !important;
  font-family: var(--font-sans) !important;
  /* The shared modal script scales the window to 0.95 on close and back to 1
     on open. With transitions dead that would simply snap to a shrunken window
     for the 150ms before the overlay is hidden, so the transform is pinned off:
     a Win95 dialog appeared and vanished at full size. */
  transform: none !important;
}

/* Solid navy title bar inset 3px inside the silver window frame. */
#arcane-root.arcane-theme-win95 .win95-dialog-title {
  flex: 0 0 auto !important;
  display: flex !important;
  align-items: center !important;
  box-sizing: border-box !important;
  height: 20px !important;
  min-height: 20px !important;
  margin: 0 0 3px 0 !important;
  padding: 0 24px 0 6px !important;
  background: var(--w95-title-bar) !important;
  color: var(--w95-title-text) !important;
  font-family: var(--font-sans) !important;
  font-size: 16.5px !important;
  font-weight: 700 !important;
  letter-spacing: normal !important;
  line-height: 20px !important;
  white-space: nowrap !important;
  overflow: hidden !important;
  text-overflow: ellipsis !important;
}

/* Caption button on the right of the title bar. A Win95 caption control is a
   16x14 raised control face carrying the stepped 8x7 bitmap cross — the same
   pixels as the close cap in --w95-caption-buttons — so the live one is built
   the same way instead of at 22x18 with a thin bevel and a text character.
   font-size: 0 collapses the U+2715 the shared render base emits (no theme can
   remove that text node), and the mask paints --w95-ctl-close in its place, so
   the mark can no longer shift weight or baseline with the font fallback. */
#arcane-root.arcane-theme-win95 .win95-dialog-close,
#arcane-root.arcane-theme-win95 .win95-drawer-close,
#arcane-root.arcane-theme-win95 .win95-sheet-close {
  flex-shrink: 0 !important;
  box-sizing: border-box !important;
  width: 16px !important;
  height: 14px !important;
  min-width: 16px !important;
  margin: 0 !important;
  padding: 0 !important;
  display: inline-flex !important;
  align-items: center !important;
  justify-content: center !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-raised) !important;
  font-size: 0 !important;
  line-height: 0 !important;
  cursor: var(--w95-cursor-arrow) !important;
}
#arcane-root.arcane-theme-win95 .win95-dialog-close::after,
#arcane-root.arcane-theme-win95 .win95-drawer-close::after,
#arcane-root.arcane-theme-win95 .win95-sheet-close::after {
  content: '' !important;
  width: 10px;
  height: 10px;
  background-color: currentColor;
  -webkit-mask-image: var(--w95-ctl-close);
  mask-image: var(--w95-ctl-close);
  -webkit-mask-repeat: no-repeat;
  mask-repeat: no-repeat;
  -webkit-mask-position: center;
  mask-position: center;
  -webkit-mask-size: 10px 10px;
  mask-size: 10px 10px;
}
/* Pressed: the bevel inverts and the glyph steps one pixel down-right. The
   padding does the nudge because the button is border-box at a fixed 16x14:
   2px top/left leaves an even 14x12 content box, so the centred 10x10 cell
   lands at (4, 3) — one whole pixel from its resting (3, 2). A 1px pad left
   an odd box and centred the cell on a half pixel, which blurred the glyph. */
#arcane-root.arcane-theme-win95 .win95-dialog-close:active,
#arcane-root.arcane-theme-win95 .win95-drawer-close:active,
#arcane-root.arcane-theme-win95 .win95-sheet-close:active {
  box-shadow: var(--w95-pressed) !important;
  padding: 2px 0 0 2px !important;
}
#arcane-root.arcane-theme-win95 .win95-dialog-close {
  position: absolute !important;
  top: 6px !important;
  right: 5px !important;
  z-index: 2 !important;
}

/* Body: opaque silver client area, black (theme foreground) text. */
#arcane-root.arcane-theme-win95 .win95-dialog-content {
  flex: 1 1 auto !important;
  overflow-y: auto !important;
  padding: 12px 14px !important;
  color: var(--w95-face-text) !important;
  font-family: var(--font-sans) !important;
}

/* Footer: OK/Cancel Win95 buttons, right-aligned. The default (primary)
   button already gets its extra 1px ring from the .win95-button rules. */
#arcane-root.arcane-theme-win95 .win95-dialog-actions {
  flex: 0 0 auto !important;
  display: flex !important;
  justify-content: flex-end !important;
  gap: 6px !important;
  margin: 0 !important;
  padding: 8px 14px 12px 14px !important;
}

/* Confirm / alert dialogs reuse the dialog window; keep their icon and
   centered message legible on the silver face in both light and dark. */
#arcane-root.arcane-theme-win95 .win95-confirm-dialog-content,
#arcane-root.arcane-theme-win95 .win95-confirm-dialog-icon {
  color: var(--w95-face-text) !important;
}

/* ---------- Command palette window ---------- */

/* Opaque silver window; the navy caption bar and its buttons are the
   .win95-command-dialog::before / ::after pseudo-elements above. */
#arcane-root.arcane-theme-win95 .win95-command-dialog {
  width: min(560px, calc(100vw - 2rem)) !important;
  max-width: 560px !important;
  max-height: 70vh !important;
  display: flex !important;
  flex-direction: column !important;
  box-sizing: border-box !important;
  padding: 26px 3px 3px 3px !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-window-frame) !important;
}

/* Search row (icon + input). */
#arcane-root.arcane-theme-win95 .win95-command-dialog > div:first-child {
  flex: 0 0 auto !important;
  display: flex !important;
  align-items: center !important;
  gap: 6px !important;
  padding: 4px 6px 6px 6px !important;
}
#arcane-root.arcane-theme-win95 .win95-command-dialog > div:first-child > span {
  flex: 0 0 auto !important;
  display: inline-flex !important;
  align-items: center !important;
  color: var(--w95-disabled-text) !important;
}

/* Sunken white search field. Force background/border past the input's
   inline background:transparent;border:none (why it looked faint). */
#arcane-root.arcane-theme-win95 .win95-command-input {
  flex: 1 1 auto !important;
  width: auto !important;
  background: var(--w95-field) !important;
  color: var(--w95-field-text) !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-sunken) !important;
  padding: 3px 5px !important;
  font-family: var(--font-sans) !important;
  font-size: 1.125rem !important;
}
#arcane-root.arcane-theme-win95 .win95-command-input::placeholder {
  color: var(--w95-field-placeholder) !important;
}

/* Results area = a sunken white listbox well. */
#arcane-root.arcane-theme-win95 .win95-command-list {
  flex: 1 1 auto !important;
  overflow-y: auto !important;
  margin: 0 6px !important;
  padding: 2px !important;
  background: var(--w95-field) !important;
  color: var(--w95-field-text) !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-sunken) !important;
}

/* Rows highlight navy (selection) on hover / keyboard selection. */
#arcane-root.arcane-theme-win95 .win95-command-item {
  color: var(--w95-field-text) !important;
}
#arcane-root.arcane-theme-win95 .win95-command-item:hover:not(.disabled),
#arcane-root.arcane-theme-win95 .win95-command-item[aria-selected="true"],
#arcane-root.arcane-theme-win95 .win95-command-item[data-arcane-state="active"],
#arcane-root.arcane-theme-win95 .win95-command-item.selected {
  background: var(--w95-selection) !important;
  color: var(--w95-selection-text) !important;
}
#arcane-root.arcane-theme-win95 .win95-command-item:hover:not(.disabled) span,
#arcane-root.arcane-theme-win95 .win95-command-item[aria-selected="true"] span,
#arcane-root.arcane-theme-win95 .win95-command-item[data-arcane-state="active"] span,
#arcane-root.arcane-theme-win95 .win95-command-item.selected span {
  color: var(--w95-selection-text) !important;
}

/* Small bold group labels. */
#arcane-root.arcane-theme-win95 .win95-command-group-heading {
  padding: 4px 6px 2px 6px !important;
  font-weight: 700 !important;
  color: var(--w95-field-text) !important;
}

/* Keyboard-hint footer: etched top divider, laid out inline. */
#arcane-root.arcane-theme-win95 .win95-command-dialog > div:last-child {
  flex: 0 0 auto !important;
  display: flex !important;
  align-items: center !important;
  gap: 14px !important;
  margin: 6px 3px 0 3px !important;
  padding: 4px 6px !important;
  box-shadow: inset 0 1px 0 var(--w95-shadow), inset 0 2px 0 var(--w95-hilite) !important;
  color: var(--w95-face-text) !important;
  font-size: 0.9rem !important;
}

/* ========== menus ========== */
/* ============================================================
   PASS 3 — Menus + Popover + Tooltip (Win95)
   Overlay surfaces (context menu, dropdown menu, menubar,
   popover, tooltip) whose win95-* classes were never styled.
   Every menu/popover panel carries .win95-popover, so that is
   the master surface selector; anchored surfaces are positioned
   (position:fixed) and shown/hidden by the runtime surface JS,
   so here we only supply the Win95 look.
   ============================================================ */

/* ---------- Opaque silver popup surface in the window frame ---------- */
/* Covers: popover, context-menu, dropdown-menu, all submenus,
   menubar dropdown content + submenu, Floating rich popover. */
#arcane-root.arcane-theme-win95 .win95-popover,
#arcane-root.arcane-theme-win95 .win95-context-menu,
#arcane-root.arcane-theme-win95 .win95-context-menu-submenu,
#arcane-root.arcane-theme-win95 .win95-dropdown-menu,
#arcane-root.arcane-theme-win95 .win95-dropdown-submenu,
#arcane-root.arcane-theme-win95 .win95-menubar-content,
#arcane-root.arcane-theme-win95 .win95-menubar-submenu,
#arcane-root.arcane-theme-win95 .win95-floating-content.win95-popover {
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-window-frame) !important;
  padding: 2px !important;
  min-width: 160px !important;
  font-size: 1.219rem !important;
  z-index: 1000 !important;
  opacity: 1 !important;
}

/* ---------- Menu items (context / dropdown / menubar dropdown) ---------- */
#arcane-root.arcane-theme-win95 .win95-context-menu-item,
#arcane-root.arcane-theme-win95 .win95-dropdown-item,
#arcane-root.arcane-theme-win95 .win95-menubar-item {
  position: relative !important;
  display: flex !important;
  align-items: center !important;
  gap: 0.5rem !important;
  width: 100% !important;
  padding: 2px 22px 2px 8px !important;
  background: transparent !important;
  color: var(--w95-face-text) !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: none !important;
  font-family: var(--font-sans) !important;
  font-size: 1.219rem !important;
  line-height: 1.5 !important;
  text-align: left !important;
  white-space: nowrap !important;
  cursor: var(--w95-cursor-arrow) !important;
  outline: none !important;
  transition: none !important;
  opacity: 1 !important;
}

/* Inner label / shortcut / icon spans follow the item's colour
   (black normally, white on highlight, grey when disabled). */
#arcane-root.arcane-theme-win95 .win95-context-menu-item span,
#arcane-root.arcane-theme-win95 .win95-context-menu-item svg,
#arcane-root.arcane-theme-win95 .win95-dropdown-item span,
#arcane-root.arcane-theme-win95 .win95-dropdown-item svg,
#arcane-root.arcane-theme-win95 .win95-menubar-item span,
#arcane-root.arcane-theme-win95 .win95-menubar-item svg {
  color: inherit !important;
}

/* Room for the checkbox/radio indicator gutter. */
#arcane-root.arcane-theme-win95 .win95-context-menu-item.checkbox,
#arcane-root.arcane-theme-win95 .win95-context-menu-item.radio,
#arcane-root.arcane-theme-win95 .win95-dropdown-item.checkbox,
#arcane-root.arcane-theme-win95 .win95-dropdown-item.radio,
#arcane-root.arcane-theme-win95 .win95-menubar-item.checkbox,
#arcane-root.arcane-theme-win95 .win95-menubar-item.radio {
  padding-left: 24px !important;
}

/* Check and bullet indicators: the check box's --w95-check tick and a 6x6
   bitmap bullet in the item colour (black, white on the navy highlight, grey
   when disabled), centred in the 24px gutter. The shared lucide glyphs are
   hidden. */
#arcane-root.arcane-theme-win95 :is(.win95-dropdown-item, .win95-context-menu-item, .win95-menubar-item) > .arcane-menu-indicator {
  left: 6px !important;
  top: 0 !important;
  bottom: 0 !important;
  margin: auto 0 !important;
  display: block !important;
  font-size: 0 !important;
  background-color: currentColor !important;
}
#arcane-root.arcane-theme-win95 :is(.win95-dropdown-item, .win95-context-menu-item, .win95-menubar-item) > .arcane-menu-indicator > * {
  display: none !important;
}
#arcane-root.arcane-theme-win95 :is(.win95-dropdown-item, .win95-context-menu-item, .win95-menubar-item).checkbox > .arcane-menu-indicator {
  width: 7px !important;
  height: 7px !important;
  -webkit-mask-image: var(--w95-check) !important;
  mask-image: var(--w95-check) !important;
  -webkit-mask-size: 7px 7px !important;
  mask-size: 7px 7px !important;
}
#arcane-root.arcane-theme-win95 :is(.win95-dropdown-item, .win95-context-menu-item, .win95-menubar-item).radio > .arcane-menu-indicator {
  width: 6px !important;
  height: 6px !important;
  background-color: transparent !important;
  background-image:
    linear-gradient(currentColor, currentColor),
    linear-gradient(currentColor, currentColor),
    linear-gradient(currentColor, currentColor) !important;
  background-position: 2px 0, 1px 1px, 0 2px !important;
  background-size: 2px 6px, 4px 4px, 6px 2px !important;
  background-repeat: no-repeat !important;
}

/* Highlight: navy bar with white text on hover / keyboard highlight,
   but never on a disabled item. */
#arcane-root.arcane-theme-win95 .win95-context-menu-item:hover:not(.disabled):not([data-disabled="true"]),
#arcane-root.arcane-theme-win95 .win95-context-menu-item[data-highlighted]:not(.disabled):not([data-disabled="true"]),
#arcane-root.arcane-theme-win95 .win95-context-menu-item[aria-selected="true"]:not(.disabled):not([data-disabled="true"]),
#arcane-root.arcane-theme-win95 .win95-dropdown-item:hover:not(.disabled):not([data-disabled="true"]),
#arcane-root.arcane-theme-win95 .win95-dropdown-item[data-highlighted]:not(.disabled):not([data-disabled="true"]),
#arcane-root.arcane-theme-win95 .win95-dropdown-item[aria-selected="true"]:not(.disabled):not([data-disabled="true"]),
#arcane-root.arcane-theme-win95 .win95-menubar-item:hover:not(.disabled):not([data-disabled="true"]),
#arcane-root.arcane-theme-win95 .win95-menubar-item[data-highlighted]:not(.disabled):not([data-disabled="true"]),
#arcane-root.arcane-theme-win95 .win95-menubar-item[aria-selected="true"]:not(.disabled):not([data-disabled="true"]) {
  background: var(--w95-selection) !important;
  color: var(--w95-selection-text) !important;
}

/* Disabled items: solid Win95 grey, no highlight. */
#arcane-root.arcane-theme-win95 .win95-context-menu-item.disabled,
#arcane-root.arcane-theme-win95 .win95-context-menu-item[data-disabled="true"],
#arcane-root.arcane-theme-win95 .win95-dropdown-item.disabled,
#arcane-root.arcane-theme-win95 .win95-dropdown-item[data-disabled="true"],
#arcane-root.arcane-theme-win95 .win95-dropdown-item:disabled,
#arcane-root.arcane-theme-win95 .win95-menubar-item.disabled,
#arcane-root.arcane-theme-win95 .win95-menubar-item[aria-disabled="true"] {
  color: var(--w95-disabled-text) !important;
  background: transparent !important;
  cursor: var(--w95-cursor-arrow) !important;
  opacity: 1 !important;
  pointer-events: none !important;
}

/* ---------- Separators: 2px etched groove ---------- */
#arcane-root.arcane-theme-win95 .win95-context-menu-separator,
#arcane-root.arcane-theme-win95 .win95-menubar-separator,
#arcane-root.arcane-theme-win95 .win95-dropdown-divider {
  height: 2px !important;
  margin: 3px 2px !important;
  padding: 0 !important;
  background: transparent !important;
  border: none !important;
  box-shadow: inset 0 1px 0 var(--w95-shadow), inset 0 2px 0 var(--w95-hilite) !important;
}

/* ---------- Section labels inside menus ---------- */
#arcane-root.arcane-theme-win95 .win95-context-menu-label,
#arcane-root.arcane-theme-win95 .win95-menubar-label {
  padding: 2px 8px !important;
  font-size: 1.125rem !important;
  font-weight: 700 !important;
  letter-spacing: 0 !important;
  text-transform: none !important;
  color: var(--w95-disabled-text) !important;
  background: transparent !important;
  user-select: none !important;
}

/* ---------- Menubar strip ---------- */
#arcane-root.arcane-theme-win95 .win95-menubar {
  display: flex !important;
  align-items: stretch !important;
  gap: 0 !important;
  padding: 1px !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-raised-thin) !important;
  font-size: 1.219rem !important;
}

#arcane-root.arcane-theme-win95 .win95-menubar-trigger {
  display: inline-flex !important;
  align-items: center !important;
  padding: 3px 9px !important;
  background: transparent !important;
  color: var(--w95-face-text) !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: none !important;
  font-family: inherit !important;
  font-size: 1.219rem !important;
  line-height: 1 !important;
  cursor: var(--w95-cursor-arrow) !important;
  transition: none !important;
}

/* Menubar trigger highlights navy only while its menu is open. A Win95 menu
   bar showed nothing on hover until a menu had been opened with a click or
   Alt; from then on the open title tracks the pointer through the scripts. */
#arcane-root.arcane-theme-win95 .win95-menubar-trigger[aria-expanded="true"],
#arcane-root.arcane-theme-win95 .win95-menubar-menu.open .win95-menubar-trigger {
  background: var(--w95-selection) !important;
  color: var(--w95-selection-text) !important;
}

/* Menubar dropdown panel: win95 supplies no inline position, so drop
   it below the trigger. Silver surface comes from .win95-popover above. */
#arcane-root.arcane-theme-win95 .win95-menubar-content {
  position: absolute !important;
  top: 100% !important;
  left: 0 !important;
  margin-top: 1px !important;
  min-width: 180px !important;
  z-index: 1000 !important;
}

/* Menubar submenu: base renders it display:none inline — reveal on hover. */
#arcane-root.arcane-theme-win95 .win95-menubar-submenu {
  z-index: 1001 !important;
}
#arcane-root.arcane-theme-win95 .win95-menubar-item.submenu-trigger:hover > .win95-menubar-submenu {
  display: block !important;
}

/* ---------- Tooltip: classic pale-yellow info box ---------- */
/* .win95-tooltip is on both the CSS tooltip and the stateful text
   tooltip; the rich popover uses .win95-popover instead, so this
   never touches popovers. Thin flat black border is the one
   intentional exception to the bevel rule. */
#arcane-root.arcane-theme-win95 .win95-tooltip {
  background: #ffffe1 !important;
  color: #000000 !important;
  border: 1px solid #000000 !important;
  border-radius: 0 !important;
  box-shadow: none !important;
  padding: 2px 5px !important;
  font-size: 1rem !important;
  line-height: 1.3 !important;
  white-space: nowrap !important;
  z-index: 2000 !important;
}

/* The SCRIPTED tooltip (TooltipScripts) builds a different element entirely —
   .arcane-tooltip, written with an inline cssText carrying an 8px radius, a
   blurred drop shadow, a dark surface colour and a 150ms cross-fade — so the
   .win95-tooltip rules above never touched it. Restate it as the Win95 info
   box: pale-yellow fill, 1px flat black border, no shadow, no fade. The inline
   `transform: translateX(-50%)` is POSITIONING and is deliberately left alone;
   only the interpolation is gone (the global reset above kills it). */
#arcane-root.arcane-theme-win95 .arcane-tooltip {
  background: #ffffe1 !important;
  color: #000000 !important;
  border: 1px solid #000000 !important;
  border-radius: 0 !important;
  box-shadow: none !important;
  padding: 2px 5px !important;
  font-family: var(--font-sans) !important;
  font-size: 1rem !important;
  font-weight: 400 !important;
  line-height: 1.3 !important;
}
/* Win95 tooltips were a plain rectangle — no callout tail. The scripted arrow
   is an 8x8 box rotated into a diamond; it has no Win95 equivalent. */
#arcane-root.arcane-theme-win95 .arcane-tooltip-arrow {
  display: none !important;
}

/* CSS-only tooltip (win95 renderer returns empty inline styles):
   position and hide by default. The shared Arcane tooltip contract reveals it
   on both pointer hover and keyboard focus-within. */
#arcane-root.arcane-theme-win95 .win95-floating-trigger {
  position: relative !important;
  display: inline-flex !important;
}
#arcane-root.arcane-theme-win95 .win95-floating-tooltip {
  position: absolute !important;
  bottom: 100% !important;
  left: 0 !important;
  margin-bottom: 6px !important;
  opacity: 0 !important;
  visibility: hidden !important;
  pointer-events: none !important;
  transition: none !important;
  z-index: 2000 !important;
}
/* Per-side placement driven by the trigger's data-tooltip-position. */
#arcane-root.arcane-theme-win95 .win95-floating-trigger[data-tooltip-position="top"] .win95-floating-tooltip,
#arcane-root.arcane-theme-win95 .win95-floating-trigger[data-tooltip-position="topStart"] .win95-floating-tooltip,
#arcane-root.arcane-theme-win95 .win95-floating-trigger[data-tooltip-position="topEnd"] .win95-floating-tooltip {
  top: auto !important;
  bottom: 100% !important;
  margin: 0 0 6px 0 !important;
}
#arcane-root.arcane-theme-win95 .win95-floating-trigger[data-tooltip-position="bottom"] .win95-floating-tooltip,
#arcane-root.arcane-theme-win95 .win95-floating-trigger[data-tooltip-position="bottomStart"] .win95-floating-tooltip,
#arcane-root.arcane-theme-win95 .win95-floating-trigger[data-tooltip-position="bottomEnd"] .win95-floating-tooltip {
  bottom: auto !important;
  top: 100% !important;
  margin: 6px 0 0 0 !important;
}
#arcane-root.arcane-theme-win95 .win95-floating-trigger[data-tooltip-position="top"] .win95-floating-tooltip,
#arcane-root.arcane-theme-win95 .win95-floating-trigger[data-tooltip-position="bottom"] .win95-floating-tooltip {
  left: 50% !important;
  transform: translateX(-50%) !important;
}
#arcane-root.arcane-theme-win95 .win95-floating-trigger[data-tooltip-position="topEnd"] .win95-floating-tooltip,
#arcane-root.arcane-theme-win95 .win95-floating-trigger[data-tooltip-position="bottomEnd"] .win95-floating-tooltip {
  left: auto !important;
  right: 0 !important;
}
#arcane-root.arcane-theme-win95 .win95-floating-trigger[data-tooltip-position="left"] .win95-floating-tooltip {
  bottom: auto !important;
  right: 100% !important;
  left: auto !important;
  top: 50% !important;
  transform: translateY(-50%) !important;
  margin: 0 6px 0 0 !important;
}
#arcane-root.arcane-theme-win95 .win95-floating-trigger[data-tooltip-position="right"] .win95-floating-tooltip {
  bottom: auto !important;
  left: 100% !important;
  top: 50% !important;
  transform: translateY(-50%) !important;
  margin: 0 0 0 6px !important;
}

/* Win95 tooltips/popovers have no arrow. */
#arcane-root.arcane-theme-win95 .win95-floating-arrow {
  display: none !important;
}

/* ========== toast ========== */
#arcane-root.arcane-theme-win95 .win95-toast {
  display: flex !important;
  align-items: flex-start !important;
  gap: 8px !important;
  box-sizing: border-box !important;
  min-width: 240px !important;
  max-width: 380px !important;
  padding: 8px 10px !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-raised) !important;
  font-family: inherit !important;
  transition: none !important;
}

#arcane-root.arcane-theme-win95 .win95-toast-icon {
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
  flex-shrink: 0 !important;
  width: 20px !important;
  height: 20px !important;
  margin-top: 1px !important;
  font-weight: 700 !important;
}

#arcane-root.arcane-theme-win95 .win95-toast-content {
  flex: 1 1 auto !important;
  min-width: 0 !important;
}

#arcane-root.arcane-theme-win95 .win95-toast-title {
  font-family: inherit !important;
  font-size: 12px !important;
  font-weight: 700 !important;
  letter-spacing: 0 !important;
  line-height: 1.2 !important;
  color: var(--w95-face-text) !important;
  margin: 0 0 2px 0 !important;
}

#arcane-root.arcane-theme-win95 .win95-toast-message {
  font-family: inherit !important;
  font-size: 11px !important;
  line-height: 1.35 !important;
  color: var(--w95-face-text) !important;
}

#arcane-root.arcane-theme-win95 .win95-toast-description {
  font-family: inherit !important;
  font-size: 11px !important;
  line-height: 1.35 !important;
  color: var(--w95-face-text) !important;
  margin-top: 3px !important;
}

#arcane-root.arcane-theme-win95 .win95-toast-action {
  display: inline-block !important;
  margin-top: 6px !important;
  padding: 2px 12px !important;
  font-family: inherit !important;
  font-size: 11px !important;
  line-height: 1.4 !important;
  color: var(--w95-face-text) !important;
  background: var(--w95-face) !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-raised-thin) !important;
  cursor: var(--w95-cursor-arrow) !important;
  transition: none !important;
}
#arcane-root.arcane-theme-win95 .win95-toast-action:active {
  box-shadow: var(--w95-pressed) !important;
}
#arcane-root.arcane-theme-win95 .win95-toast-action:focus-visible {
  outline: 1px dotted var(--w95-face-text) !important;
  outline-offset: -4px !important;
}

#arcane-root.arcane-theme-win95 .win95-toast-dismiss {
  flex-shrink: 0 !important;
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
  width: 18px !important;
  height: 18px !important;
  margin: -1px -2px 0 0 !important;
  padding: 0 !important;
  font-family: inherit !important;
  font-size: 10px !important;
  font-weight: 700 !important;
  line-height: 1 !important;
  color: var(--w95-face-text) !important;
  background: var(--w95-face) !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-raised-thin) !important;
  cursor: var(--w95-cursor-arrow) !important;
  transition: none !important;
}
#arcane-root.arcane-theme-win95 .win95-toast-dismiss:active {
  box-shadow: var(--w95-pressed) !important;
}
#arcane-root.arcane-theme-win95 .win95-toast-dismiss:focus-visible {
  outline: 1px dotted var(--w95-face-text) !important;
  outline-offset: -4px !important;
}

#arcane-root.arcane-theme-win95 .win95-toast-container {
  background: transparent !important;
  box-shadow: none !important;
  border: none !important;
  border-radius: 0 !important;
}

/* ---------- Runtime toast surface ----------
   The imperative toast pipeline builds its shell with inline styles: a 12px
   radius, a blurred drop shadow, an emerald accent, and a fade/slide/scale
   entry driven from JS. It correctly emits the .arcane-loader hourglass, and
   the toaster is appended inside #arcane-root, so the contradiction is only in
   the card around it. None of those inline styles carry !important, so this
   block re-states the shell as a Win95 notification: raised silver panel, hard
   bevels, square corners, and instant appearance. */
#arcane-root.arcane-theme-win95 .arcane-toaster {
  gap: 6px !important;
  background: transparent !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: none !important;
}
#arcane-root.arcane-theme-win95 .arcane-toast {
  box-sizing: border-box !important;
  min-width: 240px !important;
  max-width: 380px !important;
  padding: 8px 10px !important;
  gap: 8px !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-raised) !important;
  font-family: var(--font-sans) !important;
  /* Win95 notifications appeared instantly and vanished instantly. */
  opacity: 1 !important;
  transform: none !important;
  animation: none !important;
  transition: none !important;
}
/* The script paints the icon wrapper and the two text spans with the emerald
   accent scale and a 14px/600 web type ramp; both are re-pointed here. */
#arcane-root.arcane-theme-win95 .arcane-toast > div:first-child {
  color: var(--w95-face-text) !important;
  flex-shrink: 0 !important;
}
#arcane-root.arcane-theme-win95 .arcane-toast span {
  font-family: var(--font-sans) !important;
  font-size: 12px !important;
  line-height: 1.35 !important;
  color: var(--w95-face-text) !important;
}
#arcane-root.arcane-theme-win95 .arcane-toast span:first-child {
  font-weight: 700 !important;
}
#arcane-root.arcane-theme-win95 .arcane-toast-action,
#arcane-root.arcane-theme-win95 .arcane-toast-close {
  min-width: 20px !important;
  padding: 2px 8px !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  border: none !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-raised-thin) !important;
  font-family: var(--font-sans) !important;
  font-size: 12px !important;
  font-weight: 400 !important;
  cursor: var(--w95-cursor-arrow) !important;
  transition: none !important;
}
#arcane-root.arcane-theme-win95 .arcane-toast-action:active,
#arcane-root.arcane-theme-win95 .arcane-toast-close:active {
  box-shadow: var(--w95-pressed) !important;
}
#arcane-root.arcane-theme-win95 .arcane-toast-action:focus-visible,
#arcane-root.arcane-theme-win95 .arcane-toast-close:focus-visible {
  outline: 1px dotted var(--w95-face-text) !important;
  outline-offset: -4px !important;
}
/* The auto-dismiss countdown strip animates its own width; Win95 message
   windows had no such thing, so it is removed rather than recoloured. */
#arcane-root.arcane-theme-win95 .arcane-toast-progress {
  display: none !important;
}

/* ========== small ========== */
/* ---------- TABLE ROW HOVER ----------
   Only interactive (clickable) body data rows highlight on hover;
   selection is a persistent state. Non-interactive static tables must
   NOT show a hover highlight, and header cells must never invert. */

/* Neutralize the broken static-table hover: static rows are read-only,
   so keep them on the white field (gridlines untouched). */
#arcane-root.arcane-theme-win95 .win95-static-table tbody tr:hover td {
  background: var(--w95-field) !important;
  color: var(--w95-field-text) !important;
}

/* Header cells stay raised silver even when the header row is hovered. */
#arcane-root.arcane-theme-win95 .win95-static-table tr:hover th,
#arcane-root.arcane-theme-win95 .win95-data-table tr:hover th {
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-raised-thin) !important;
}

/* Only clickable data rows (and the selected state) invert to navy. */
#arcane-root.arcane-theme-win95 .win95-data-table-row.selected td,
#arcane-root.arcane-theme-win95 .win95-data-table-row.clickable:hover td {
  background: var(--w95-selection) !important;
  color: var(--w95-selection-text) !important;
}

/* ============================================================
   PAGE-LEVEL (document) SCROLLBAR. The document scroll lives on
   <html>, OUTSIDE #arcane-root, so the scoped scrollbar rules
   above cannot reach it and the root's --w95-* tokens do not
   inherit up. <html> therefore declares the handful of tokens its
   scrollbar spends, self-scoped via :has() so they only exist
   while a Win95 root is present, and the dark copy re-points them
   exactly as the root's dark block does.
   ============================================================ */
html:has(#arcane-root.arcane-theme-win95) {
  scrollbar-width: auto !important;
  scrollbar-color: auto !important;
  --w95-face: #c0c0c0;
  --w95-hilite: #ffffff;
  --w95-light: #dfdfdf;
  --w95-shadow: #808080;
  --w95-dark: #000000;
  --w95-field: #ffffff;
  --w95-raised:
    inset -1px -1px 0 var(--w95-dark),
    inset 1px 1px 0 var(--w95-hilite),
    inset -2px -2px 0 var(--w95-shadow),
    inset 2px 2px 0 var(--w95-light);
  --w95-scroll-up: url("$win95ScrollUpLight");
  --w95-scroll-down: url("$win95ScrollDownLight");
  --w95-scroll-left: url("$win95ScrollLeftLight");
  --w95-scroll-right: url("$win95ScrollRightLight");
}
html.dark:has(#arcane-root.arcane-theme-win95) {
  --w95-face: #3a3a3a;
  --w95-hilite: #8e8e8e;
  --w95-light: #646464;
  --w95-shadow: #1c1c1c;
  --w95-dark: #000000;
  --w95-field: #242424;
  --w95-scroll-up: url("$win95ScrollUpDark");
  --w95-scroll-down: url("$win95ScrollDownDark");
  --w95-scroll-left: url("$win95ScrollLeftDark");
  --w95-scroll-right: url("$win95ScrollRightDark");
}
html:has(#arcane-root.arcane-theme-win95)::-webkit-scrollbar {
  width: 16px;
  height: 16px;
}
/* Squared corners, like the in-app scrollbars (the global border-radius:0 rule
   is scoped to #arcane-root and never reaches these <html> scrollbar pseudos). */
html:has(#arcane-root.arcane-theme-win95)::-webkit-scrollbar-track,
html:has(#arcane-root.arcane-theme-win95)::-webkit-scrollbar-thumb,
html:has(#arcane-root.arcane-theme-win95)::-webkit-scrollbar-button,
html:has(#arcane-root.arcane-theme-win95)::-webkit-scrollbar-corner {
  border-radius: 0 !important;
}
html:has(#arcane-root.arcane-theme-win95)::-webkit-scrollbar-track {
  background-color: var(--w95-field);
  background-image:
    linear-gradient(45deg, var(--w95-face) 25%, transparent 25%, transparent 75%, var(--w95-face) 75%),
    linear-gradient(45deg, var(--w95-face) 25%, transparent 25%, transparent 75%, var(--w95-face) 75%);
  background-size: 2px 2px;
  background-position: 0 0, 1px 1px;
}
html:has(#arcane-root.arcane-theme-win95)::-webkit-scrollbar-thumb {
  background: var(--w95-face);
  box-shadow: var(--w95-raised);
  min-height: 20px;
  min-width: 20px;
}
html:has(#arcane-root.arcane-theme-win95)::-webkit-scrollbar-button {
  display: block;
  width: 16px;
  height: 16px;
  background-color: var(--w95-face);
  box-shadow: var(--w95-raised);
  background-repeat: no-repeat;
  background-position: 0 0;
  background-size: 16px 16px;
}
html:has(#arcane-root.arcane-theme-win95)::-webkit-scrollbar-button:vertical:decrement {
  background-image: var(--w95-scroll-up);
}
html:has(#arcane-root.arcane-theme-win95)::-webkit-scrollbar-button:vertical:increment {
  background-image: var(--w95-scroll-down);
}
html:has(#arcane-root.arcane-theme-win95)::-webkit-scrollbar-button:horizontal:decrement {
  background-image: var(--w95-scroll-left);
}
html:has(#arcane-root.arcane-theme-win95)::-webkit-scrollbar-button:horizontal:increment {
  background-image: var(--w95-scroll-right);
}
html:has(#arcane-root.arcane-theme-win95)::-webkit-scrollbar-button:active {
  box-shadow: inset 0 0 0 1px var(--w95-shadow);
  background-position: 1px 1px;
}
html:has(#arcane-root.arcane-theme-win95)::-webkit-scrollbar-button:vertical:start:increment,
html:has(#arcane-root.arcane-theme-win95)::-webkit-scrollbar-button:vertical:end:decrement,
html:has(#arcane-root.arcane-theme-win95)::-webkit-scrollbar-button:horizontal:start:increment,
html:has(#arcane-root.arcane-theme-win95)::-webkit-scrollbar-button:horizontal:end:decrement {
  display: none;
}
html:has(#arcane-root.arcane-theme-win95)::-webkit-scrollbar-corner {
  background: var(--w95-face);
}

/* ================= Component refinement pass (audit fixes) ================= */
/* ===== refine:buttons ===== */
/* Form action buttons: the form renderer sets INLINE background:var(--primary)
   (navy) / var(--background) (teal desktop) plus a flat grey border, which beat
   the .win95-button class rules — Win95 buttons are ALWAYS a silver 3D face,
   never a colored fill. Neutralize the inline color/border/transition; the 3D
   bevel (submit = data-variant=primary → raised + extra dark ring; cancel =
   outline → plain raised) and the :active press already come from the
   .win95-button cascade these buttons carry. */
#arcane-root.arcane-theme-win95 .win95-form-submit-btn,
#arcane-root.arcane-theme-win95 .win95-form-cancel-btn {
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  border: none !important;
  transition: none !important;
}

/* Cycle button: the Win95 renderer emits no fill/bevel and there is no CSS for
   .win95-cycle-button, so it fell through to a bare browser button. Give it the
   standard silver raised 3D face; the base already supplies inline sizing. */
#arcane-root.arcane-theme-win95 .win95-cycle-button {
  background: var(--w95-face);
  color: var(--w95-face-text);
  border: none;
  border-radius: 0;
  box-shadow: var(--w95-raised);
}
#arcane-root.arcane-theme-win95 .win95-cycle-button:active:not(.disabled) {
  box-shadow: var(--w95-pressed);
}
#arcane-root.arcane-theme-win95 .win95-cycle-button.disabled {
  color: var(--w95-disabled-text);
  text-shadow: 1px 1px 0 var(--w95-hilite);
  cursor: var(--w95-cursor-arrow);
}

/* Toggle button: the Win95 renderer emits an empty style map (no sizing, no
   fill, no bevel) and there is no CSS for .win95-toggle-button, so it rendered
   as a bare browser button. Style it as a full silver raised 3D button; when
   toggled on it presses in (sunken bevel), like a Win95 toolbar toggle. */
#arcane-root.arcane-theme-win95 .win95-toggle-button {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.4rem;
  font-family: var(--font-sans);
  font-weight: 400;
  font-size: 1.219rem;
  line-height: 1;
  white-space: nowrap;
  padding: 0.4rem 0.9rem;
  min-height: 1.6rem;
  background: var(--w95-face);
  color: var(--w95-face-text);
  border: none;
  border-radius: 0;
  box-shadow: var(--w95-raised);
  cursor: var(--w95-cursor-arrow);
  transition: none;
}
#arcane-root.arcane-theme-win95 .win95-toggle-button.active,
#arcane-root.arcane-theme-win95 .win95-toggle-button[aria-pressed="true"],
#arcane-root.arcane-theme-win95 .win95-toggle-button[data-state="on"] {
  box-shadow: var(--w95-pressed);
  padding-top: calc(0.4rem + 1px);
  padding-left: calc(0.9rem + 1px);
  padding-bottom: calc(0.4rem - 1px);
  padding-right: calc(0.9rem - 1px);
}
#arcane-root.arcane-theme-win95 .win95-toggle-button:active:not(.disabled) {
  box-shadow: var(--w95-pressed);
}
#arcane-root.arcane-theme-win95 .win95-toggle-button.disabled {
  color: var(--w95-disabled-text);
  text-shadow: 1px 1px 0 var(--w95-hilite);
  cursor: var(--w95-cursor-arrow);
}

/* ===== refine:inputs ===== */
/* Core fields render an inline modern 1px-border rounded box. Force the text,
   textarea, and select variants into the same Win95 SUNKEN edit well. */
#arcane-root.arcane-theme-win95 .arcane-textarea,
#arcane-root.arcane-theme-win95 .arcane-field-textarea,
#arcane-root.arcane-theme-win95 .arcane-field-input,
#arcane-root.arcane-theme-win95 .arcane-field-select {
  background: var(--w95-field) !important;
  color: var(--w95-field-text) !important;
  border: 0 !important;
  border-radius: 0 !important;
  box-shadow: var(--w95-sunken) !important;
  font-family: var(--font-sans) !important;
  outline: none !important;
  transition: none !important;
}
/* Every edit control took the Win95 I-beam, whether or not it was editable —
   a read-only field still let you select its text. Checkboxes, radios, and the
   button-like input types are not edit wells, so they keep the arrow, and a
   select is a dropdown rather than a field. All bitmap art, never the host
   OS's modern set. */
#arcane-root.arcane-theme-win95 input:not([type="checkbox"]):not([type="radio"]):not([type="button"]):not([type="submit"]):not([type="reset"]):not([type="range"]):not([type="color"]):not([type="file"]),
#arcane-root.arcane-theme-win95 textarea,
#arcane-root.arcane-theme-win95 .arcane-textarea,
#arcane-root.arcane-theme-win95 .arcane-field-textarea,
#arcane-root.arcane-theme-win95 .arcane-field-input,
#arcane-root.arcane-theme-win95 .win95-command-input {
  cursor: var(--w95-cursor-ibeam) !important;
}
#arcane-root.arcane-theme-win95 select,
#arcane-root.arcane-theme-win95 .arcane-field-select {
  cursor: var(--w95-cursor-arrow) !important;
}

/* Busy work showed the hourglass — the same art the inline loader animates,
   and in Win95 the CURSOR was its primary form: a window doing work swapped
   the pointer for its whole client area. [data-busy] on the root is the hook
   for an app-wide wait; aria-busy covers a single region. A control in
   data-state="loading" is busy, not forbidden, so it takes the hourglass and
   never the circle-slash — that mark meant "this drop will be refused". */
#arcane-root.arcane-theme-win95[data-busy="true"],
#arcane-root.arcane-theme-win95[data-busy="true"] *,
#arcane-root.arcane-theme-win95 [aria-busy="true"],
#arcane-root.arcane-theme-win95 [aria-busy="true"] *,
#arcane-root.arcane-theme-win95 [data-state="loading"],
#arcane-root.arcane-theme-win95 [data-state="loading"] *,
#arcane-root.arcane-theme-win95 .arcane-loader,
#arcane-root.arcane-theme-win95 .arcane-loading,
#arcane-root.arcane-theme-win95 .arcane-loading * {
  cursor: var(--w95-cursor-wait) !important;
}

#arcane-root.arcane-theme-win95 .arcane-textarea::placeholder,
#arcane-root.arcane-theme-win95 .arcane-field-textarea::placeholder {
  color: var(--w95-field-placeholder) !important;
  -webkit-text-fill-color: var(--w95-field-placeholder) !important;
  opacity: 1 !important;
}
#arcane-root.arcane-theme-win95 .arcane-textarea:focus,
#arcane-root.arcane-theme-win95 .arcane-field-textarea:focus,
#arcane-root.arcane-theme-win95 .arcane-field-input:focus,
#arcane-root.arcane-theme-win95 .arcane-field-select:focus {
  outline: 1px dotted var(--w95-field-text) !important;
  outline-offset: -3px !important;
  box-shadow: var(--w95-sunken) !important;
}

#arcane-root.arcane-theme-win95 .arcane-textarea:disabled {
  opacity: 0.5 !important;
  cursor: var(--w95-cursor-arrow) !important;
}

/* Read-only is not disabled: the caret was gone but the text stayed
   selectable, so the I-beam stayed too. */
#arcane-root.arcane-theme-win95 .arcane-textarea[data-readonly="true"] {
  cursor: var(--w95-cursor-ibeam) !important;
}

#arcane-root.arcane-theme-win95 .arcane-textarea[data-error="true"] {
  outline: 1px solid var(--destructive) !important;
  outline-offset: -3px !important;
}


#arcane-root.arcane-theme-win95 .arcane-textarea-label > span {
  color: var(--destructive) !important;
}


/* Match the text-input error treatment, including the high-contrast mode. */
#arcane-root.arcane-theme-win95 .arcane-textarea-error {
  color: var(--destructive) !important;
  font-size: 1.125rem !important;
}
#arcane-root.arcane-theme-win95 .arcane-textarea-helper {
  color: var(--w95-face-text) !important;
  font-size: 1.125rem !important;
}

/* Field wrapper: renderer emits bare <label>/<p> with no classes and no Win95
   rules. Stack them and give small helper text + red error (the trailing <p>,
   which is always the error node, is the last child). */
#arcane-root.arcane-theme-win95 .win95-field-wrapper {
  display: flex !important;
  flex-direction: column !important;
  gap: 0.3rem !important;
}
#arcane-root.arcane-theme-win95 .win95-field-wrapper > label {
  font-family: var(--font-sans) !important;
  font-weight: 700 !important;
  font-size: 1rem !important;
  color: var(--w95-face-text) !important;
}
#arcane-root.arcane-theme-win95 .win95-field-wrapper > p {
  margin: 0 !important;
  font-size: 1.125rem !important;
  color: var(--muted-foreground) !important;
}
#arcane-root.arcane-theme-win95 .win95-field-wrapper > p:last-child {
  color: var(--destructive) !important;
}

/* ===== refine:toggles ===== */
/* Checkbox: the box holds the drawn tick (--w95-check) as its ::after and
   nothing else, so no text may leak into it — a host that slots its own child
   in must not push the well out of its 13px square. */
#arcane-root.arcane-theme-win95 .win95-checkbox-box {
  font-size: 0 !important;
}
#arcane-root.arcane-theme-win95 .win95-checkbox-box[data-arcane-state="unselected"]::after {
  content: none;
}

/* ===== refine:cards ===== */
#arcane-root.arcane-theme-win95 .win95-status-indicator {
  border-radius: 50% !important;
  box-shadow: none !important;
}

/* ===== refine:tables ===== */
/* Separator: force the etched groove to win over the neutralized renderer's
   inline flat fill (background-color: var(--border) #808080) and 1px height.
   The existing rules (win95_css ~747-760) lack !important, so inline styles
   defeated the groove and the separator rendered as a flat grey line.
   Exclude the labeled variant, whose root also matches :not(-vertical). */
#arcane-root.arcane-theme-win95 .win95-separator:not(.win95-separator-vertical):not(.win95-separator-with-label) {
  height: 2px !important;
  background: transparent !important;
  box-shadow: inset 0 1px 0 var(--w95-shadow), inset 0 2px 0 var(--w95-hilite) !important;
}
#arcane-root.arcane-theme-win95 .win95-separator-vertical {
  width: 2px !important;
  background: transparent !important;
  box-shadow: inset 1px 0 0 var(--w95-shadow), inset 2px 0 0 var(--w95-hilite) !important;
}

/* Progress value readout: a plain text line under the meter (visible in the
   docs demo via showValue: true), never a second segmented strip. */
#arcane-root.arcane-theme-win95 .win95-progress-value {
  background: transparent !important;
  background-image: none !important;
  color: var(--w95-face-text) !important;
  font-size: 0.75rem !important;
  line-height: 1.2 !important;
  text-align: right !important;
  padding: 1px 2px 0 !important;
}

/* Radio layouts share native controls, including keyboard selection. */
#arcane-root.arcane-theme-win95 .win95-radio-group {
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
  min-width: 0;
  color: var(--w95-face-text);
}
#arcane-root.arcane-theme-win95 .win95-radio-group-label {
  font-weight: 700;
}
#arcane-root.arcane-theme-win95 .win95-radio-group-options {
  display: flex;
  flex-direction: column;
  min-width: 0;
}
#arcane-root.arcane-theme-win95 .win95-radio-group[data-layout="horizontal"] .win95-radio-group-options {
  flex-direction: row;
  flex-wrap: wrap;
}
#arcane-root.arcane-theme-win95 .win95-radio-group[data-layout="grid"] .win95-radio-group-options {
  display: grid;
}
#arcane-root.arcane-theme-win95 .win95-radio-option,
#arcane-root.arcane-theme-win95 .win95-radio-card,
#arcane-root.arcane-theme-win95 .win95-radio-button {
  position: relative;
  display: flex;
  align-items: center;
  gap: 0.5rem;
  min-width: 0;
  min-height: 24px;
  color: var(--w95-face-text);
  font-family: var(--font-sans);
  cursor: var(--w95-cursor-arrow);
}
/* The Win95 radio is a 12x12 bitmap, not a bevelled circle: an outer arc
   (#808080 top-left, white bottom-right) around an inner arc (black top-left,
   #dfdfdf bottom-right). The ring is the --w95-radio-ring sprite over the
   control's own field colour, and --w95-radio-mask clips the square box to
   the bitmap circle so nothing paints in its corners. Bare native radios
   outside ArcaneRadioGroup take the same bitmap. */
#arcane-root.arcane-theme-win95 :is(.win95-radio-control, input[type="radio"]) {
  appearance: none;
  flex: 0 0 12px;
  width: 12px;
  height: 12px;
  margin: 0;
  padding: 0;
  border: 0;
  border-radius: 0 !important;
  box-shadow: none;
  background: var(--w95-radio-ring) 0 0 / 12px 12px no-repeat, var(--w95-field);
  -webkit-mask: var(--w95-radio-mask) 0 0 / 12px 12px no-repeat;
  mask: var(--w95-radio-mask) 0 0 / 12px 12px no-repeat;
}
/* The 4x4 dot with its corners clipped, drawn as a 2x4 and a 4x2 block in the
   field text colour so it follows the scheme. */
#arcane-root.arcane-theme-win95 :is(.win95-radio-control, input[type="radio"]):checked {
  background:
    linear-gradient(var(--w95-field-text), var(--w95-field-text)) 5px 4px / 2px 4px no-repeat,
    linear-gradient(var(--w95-field-text), var(--w95-field-text)) 4px 5px / 4px 2px no-repeat,
    var(--w95-radio-ring) 0 0 / 12px 12px no-repeat,
    var(--w95-field);
}
/* Disabled: the button face shows through the ring and the dot greys. */
#arcane-root.arcane-theme-win95 :is(.win95-radio-control, input[type="radio"]):disabled {
  background: var(--w95-radio-ring) 0 0 / 12px 12px no-repeat, var(--w95-face);
}
#arcane-root.arcane-theme-win95 :is(.win95-radio-control, input[type="radio"]):checked:disabled {
  background:
    linear-gradient(var(--w95-disabled-text), var(--w95-disabled-text)) 5px 4px / 2px 4px no-repeat,
    linear-gradient(var(--w95-disabled-text), var(--w95-disabled-text)) 4px 5px / 4px 2px no-repeat,
    var(--w95-radio-ring) 0 0 / 12px 12px no-repeat,
    var(--w95-face);
}
#arcane-root.arcane-theme-win95 .win95-radio-caption {
  display: flex;
  flex: 1;
  flex-direction: column;
  gap: 0.2rem;
  min-width: 0;
  overflow-wrap: anywhere;
}
#arcane-root.arcane-theme-win95 .win95-radio-description {
  color: var(--muted-foreground);
  font-size: 0.875em;
  line-height: 1.4;
}
/* With a description the caption grows downward, so the circle pins to the
   first 18px caption line instead of centring on the whole block. */
#arcane-root.arcane-theme-win95 .win95-radio-option:has(.win95-radio-description) {
  align-items: flex-start;
}
#arcane-root.arcane-theme-win95 .win95-radio-option:has(.win95-radio-description) > .win95-radio-control {
  margin-top: 3px;
}
#arcane-root.arcane-theme-win95 .win95-radio-icon {
  display: inline-flex;
  flex: 0 0 auto;
}
#arcane-root.arcane-theme-win95 .win95-radio-card,
#arcane-root.arcane-theme-win95 .win95-radio-button {
  padding: 0.5rem 0.75rem;
  background: var(--w95-face);
  box-shadow: var(--w95-raised);
}
#arcane-root.arcane-theme-win95 .win95-radio-card:has(.win95-radio-control:checked) {
  outline: 1px solid var(--w95-face-text);
  outline-offset: -1px;
  box-shadow: var(--w95-pressed);
}
#arcane-root.arcane-theme-win95 .win95-radio-button:has(.win95-radio-control:checked),
#arcane-root.arcane-theme-win95 .win95-radio-button:active:not([data-disabled="true"]) {
  box-shadow: var(--w95-pressed);
}
#arcane-root.arcane-theme-win95 .win95-radio-button .win95-radio-control {
  position: absolute;
  width: 1px;
  height: 1px;
  overflow: hidden;
  clip-path: inset(50%);
}
#arcane-root.arcane-theme-win95 .win95-radio-option:has(.win95-radio-control:focus-visible),
#arcane-root.arcane-theme-win95 .win95-radio-card:has(.win95-radio-control:focus-visible),
#arcane-root.arcane-theme-win95 .win95-radio-button:has(.win95-radio-control:focus-visible) {
  outline: 1px dotted var(--w95-face-text) !important;
  outline-offset: 1px !important;
}
#arcane-root.arcane-theme-win95 .win95-radio-control:focus-visible {
  outline: none !important;
}
#arcane-root.arcane-theme-win95 .win95-radio-option[data-disabled="true"],
#arcane-root.arcane-theme-win95 .win95-radio-card[data-disabled="true"],
#arcane-root.arcane-theme-win95 .win95-radio-button[data-disabled="true"] {
  color: var(--w95-disabled-text);
  text-shadow: 1px 1px 0 var(--w95-hilite);
}
#arcane-root.arcane-theme-win95 [data-disabled="true"] > .win95-radio-caption .win95-radio-description {
  color: inherit;
}

/* ===== Themed not-found surface ===== */
/* Arcane owns generic copy and recovery links; Win95 contributes only the
   recognizable full-screen system-error presentation. Applications can still
   supply their own brand, diagnostic code and destinations without global
   key handlers or route assumptions. */
#arcane-root.arcane-theme-win95 .arcane-not-found {
  min-height: 100vh !important;
  min-height: 100dvh !important;
  padding: clamp(1.25rem, 6vw, 4rem) !important;
  background: #0000a8 !important;
  color: #ffffff !important;
  font-family: var(--font-sans) !important;
}

#arcane-root.arcane-theme-win95
  .arcane-not-found[data-arcane-not-found-standalone="false"] {
  min-height: 100% !important;
}

#arcane-root.arcane-theme-win95 .arcane-not-found-surface {
  width: min(100%, 62rem) !important;
  border: 0 !important;
  border-radius: 0 !important;
  background: transparent !important;
  color: #ffffff !important;
  box-shadow: none !important;
  overflow: visible !important;
}

#arcane-root.arcane-theme-win95 .arcane-not-found-banner {
  width: fit-content !important;
  max-width: 100% !important;
  margin: 0 auto 1.5rem !important;
  padding: 0.15rem 0.65rem !important;
  border: 0 !important;
  border-radius: 0 !important;
  background: #c0c0c0 !important;
  color: #0000a8 !important;
  font-size: 1rem !important;
  letter-spacing: 0 !important;
  text-transform: none !important;
}

#arcane-root.arcane-theme-win95 .arcane-not-found-content {
  gap: 1.25rem !important;
  padding: 0 !important;
}

#arcane-root.arcane-theme-win95 .arcane-not-found-title {
  color: #ffffff !important;
  font-size: clamp(1.25rem, 4vw, 2rem) !important;
  line-height: 1.25 !important;
  letter-spacing: 0 !important;
  text-align: center !important;
}

#arcane-root.arcane-theme-win95 .arcane-not-found-description {
  max-width: 68ch !important;
  margin-inline: auto !important;
  color: #ffffff !important;
  font-size: 1rem !important;
  line-height: 1.5 !important;
  text-align: center !important;
}

#arcane-root.arcane-theme-win95 .arcane-not-found-path {
  justify-content: center !important;
  max-width: 68ch !important;
  margin-inline: auto !important;
  padding: 0 !important;
  border: 0 !important;
  border-radius: 0 !important;
  background: transparent !important;
  color: #ffffff !important;
  font-size: 1rem !important;
  text-align: center !important;
}

#arcane-root.arcane-theme-win95 .arcane-not-found-path-value {
  color: #ffffff !important;
  font-family: var(--font-sans) !important;
}

#arcane-root.arcane-theme-win95 .arcane-not-found-actions {
  justify-content: center !important;
}

#arcane-root.arcane-theme-win95 .arcane-not-found-action {
  min-height: 0 !important;
  padding: 0.25rem 0.4rem !important;
  border: 0 !important;
  border-radius: 0 !important;
  background: transparent !important;
  color: #ffffff !important;
  text-decoration: underline !important;
}

#arcane-root.arcane-theme-win95 .arcane-not-found-action-primary {
  padding: 0.4rem 0.8rem !important;
  border: 0 !important;
  background: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  box-shadow: var(--w95-raised) !important;
  text-decoration: none !important;
}

#arcane-root.arcane-theme-win95 .arcane-not-found-action-primary:active {
  box-shadow: var(--w95-pressed) !important;
  transform: translate(1px, 1px) !important;
}

#arcane-root.arcane-theme-win95 .arcane-not-found-action:focus-visible {
  outline: 1px dotted currentColor !important;
  outline-offset: 2px !important;
}

#arcane-root.arcane-theme-win95 .arcane-not-found-diagnostic {
  color: #ffffff !important;
  font-family: var(--font-sans) !important;
  font-size: 0.875rem !important;
  text-align: center !important;
}

/* The core mega-menu panel writes its surface inline: a 0.375rem radius, a
   1px --border hairline and a 25px/10px blurred double shadow. The radius and
   its entrance keyframe are handled by the two blanket resets, but an inline
   box-shadow needs an !important rule to beat it, so the panel is restated as
   a silver menu in the window frame. Its inline `transform: translateX(-50%)`
   is centring, not motion, and is left alone. */
#arcane-root.arcane-theme-win95 .arcane-mega-menu-panel {
  background-color: var(--w95-face) !important;
  color: var(--w95-face-text) !important;
  border: none !important;
  box-shadow: var(--w95-window-frame) !important;
  padding: 2px !important;
}

/* ============================================================
   The engraved disabled label. Windows 95 drew EVERY greyed caption twice
   (DrawState/DSS_DISABLED): the text in COLOR_GRAYTEXT with a COLOR_BTNHILIGHT
   copy offset one pixel down-right behind it. Only three controls in this sheet
   carried the emboss; the rest set flat grey, which reads as a modern web
   disabled state. Both colours are tokens so the dark scheme inverts them.
   ============================================================ */
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-day.arcane-calendar-day-disabled,
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-day[disabled],
#arcane-root.arcane-theme-win95 .arcane-calendar--win95 .arcane-calendar-day[data-disabled="true"],
#arcane-root.arcane-theme-win95 .win95-date-picker.disabled .win95-date-picker-trigger,
#arcane-root.arcane-theme-win95 .win95-time-picker-trigger.disabled,
#arcane-root.arcane-theme-win95 .win95-select-option.disabled,
#arcane-root.arcane-theme-win95 .win95-select-option:disabled,
#arcane-root.arcane-theme-win95 .win95-pagination-button.disabled,
#arcane-root.arcane-theme-win95 .win95-context-menu-item.disabled,
#arcane-root.arcane-theme-win95 .win95-context-menu-item[data-disabled="true"],
#arcane-root.arcane-theme-win95 .win95-dropdown-item.disabled,
#arcane-root.arcane-theme-win95 .win95-dropdown-item[data-disabled="true"],
#arcane-root.arcane-theme-win95 .win95-dropdown-item:disabled,
#arcane-root.arcane-theme-win95 .win95-menubar-item.disabled,
#arcane-root.arcane-theme-win95 .win95-menubar-item[aria-disabled="true"],
#arcane-root.arcane-theme-win95 .win95-checkbox-wrapper[data-disabled="true"],
#arcane-root.arcane-theme-win95 .arcane-select:disabled,
#arcane-root.arcane-theme-win95 .arcane-textarea:disabled {
  color: var(--w95-disabled-text) !important;
  text-shadow: 1px 1px 0 var(--w95-hilite) !important;
}

/* ============================================================
   Focus rectangles that land where Windows 95 drew them: around the LABEL.
   The single global :focus-visible rule insets the dotted rect 3px, which is
   right for a push button but wrong for a checkbox — the render base puts the
   tabindex on the 13px check well, so the rect became a ~7px dotted square
   inside the well itself instead of a rectangle around the caption.
   ============================================================ */
/* Only suppress the well's own rect when there IS a caption block to move it
   to; a checkbox rendered without a label keeps its focus mark. */
#arcane-root.arcane-theme-win95 .win95-checkbox-wrapper:has(> div:nth-child(2)) .win95-checkbox-box:focus-visible {
  outline: none !important;
}
#arcane-root.arcane-theme-win95 .win95-checkbox-wrapper:has(.win95-checkbox-box:focus-visible) > div:nth-child(2) {
  outline: 1px dotted var(--w95-face-text) !important;
  outline-offset: 1px !important;
}
/* A standard radio is a single <label> holding the circle and the caption
   text, so the rect goes around the option rather than inside it — a -3px
   inset would cut through the 12px bitmap circle. */
#arcane-root.arcane-theme-win95 .win95-radio-option:focus-visible {
  outline: 1px dotted var(--w95-face-text) !important;
  outline-offset: 1px !important;
}
/* Tabs inherit the global rule; pin the inset explicitly so the active tab's
   asymmetric bevel cannot clip it. */
#arcane-root.arcane-theme-win95 .win95-tabs-trigger:focus-visible {
  outline: 1px dotted var(--w95-face-text) !important;
  outline-offset: -3px !important;
}

/* System high contrast removes bevel shadows; retain real control edges. */
@media (forced-colors: active) {
  #arcane-root.arcane-theme-win95,
  #arcane-root.arcane-theme-win95.dark {
    --w95-face: ButtonFace;
    --w95-face-text: ButtonText;
    --w95-field: Canvas;
    --w95-field-text: CanvasText;
    --w95-selection: Highlight;
    --w95-selection-text: HighlightText;
    --w95-title-a: Highlight;
    --w95-title-text: HighlightText;
    --w95-disabled-text: GrayText;
  }
  #arcane-root.arcane-theme-win95 :is(
    button, input, select, textarea, .win95-checkbox-box,
    .win95-radio-card, .win95-radio-button, .win95-toggle-thumb
  ) {
    border: 1px solid ButtonText !important;
  }
  #arcane-root.arcane-theme-win95 :is(.win95-radio-control, input[type="radio"]) {
    appearance: auto;
    -webkit-mask: none;
    mask: none;
  }
  #arcane-root.arcane-theme-win95 .win95-select-trigger > span:last-child::after {
    border-top-color: ButtonText !important;
    forced-color-adjust: none;
  }
  #arcane-root.arcane-theme-win95 .win95-radio-button:has(.win95-radio-control:checked) {
    outline: 2px solid Highlight;
    outline-offset: -3px;
  }
  #arcane-root.arcane-theme-win95 .win95-checkbox-box::after {
    background-color: CanvasText;
    forced-color-adjust: none;
  }
  #arcane-root.arcane-theme-win95 :focus-visible {
    outline: 2px solid Highlight !important;
    outline-offset: 2px !important;
  }
  #arcane-root.arcane-theme-win95 .win95-radio-control:focus-visible {
    outline: none !important;
  }
  #arcane-root.arcane-theme-win95 .win95-radio-option:has(.win95-radio-control:focus-visible),
  #arcane-root.arcane-theme-win95 .win95-radio-card:has(.win95-radio-control:focus-visible),
  #arcane-root.arcane-theme-win95 .win95-radio-button:has(.win95-radio-control:focus-visible) {
    outline: 2px solid Highlight !important;
    outline-offset: 2px !important;
  }
}

/* ---------- Shared docs / prose / TOC / map (variable-driven) ---------- */

$arcaneAllDocsStyles

$arcaneMapCss

$arcaneTocTreeLinesCss
''';
  }
}
