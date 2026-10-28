import 'dart:math' as math;

import 'package:arcane_jaspr/component/navigation/toc.dart'
    show arcaneTocTreeLinesCss;
import 'package:arcane_jaspr/component/view/map/map_style.dart'
    show arcaneMapCss;
import 'package:arcane_jaspr/util/content/prose_styles.dart';

import 'package:arcane_jaspr_neubrutalism/src/neubrutalism_theme.dart';

class NeubrutalismCss {
  const NeubrutalismCss._();

  static String _hex(int argb) {
    int r = (argb >> 16) & 0xFF;
    int g = (argb >> 8) & 0xFF;
    int b = argb & 0xFF;
    return '#${r.toRadixString(16).padLeft(2, '0')}'
        '${g.toRadixString(16).padLeft(2, '0')}'
        '${b.toRadixString(16).padLeft(2, '0')}';
  }

  static double _linearize(double channel) => channel <= 0.03928
      ? channel / 12.92
      : math.pow((channel + 0.055) / 1.055, 2.4).toDouble();

  static double _luminance(int argb) {
    double r = _linearize(((argb >> 16) & 0xFF) / 255);
    double g = _linearize(((argb >> 8) & 0xFF) / 255);
    double b = _linearize((argb & 0xFF) / 255);
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  static String _foregroundFor(int argb) {
    double luminance = _luminance(argb);
    double blackContrast = (luminance + 0.05) / 0.05;
    double whiteContrast = 1.05 / (luminance + 0.05);
    return blackContrast >= whiteContrast ? '#000000' : '#FFFFFF';
  }

  static int _mix(int first, double firstWeight, int second) {
    double secondWeight = 1 - firstWeight;
    int r =
        ((((first >> 16) & 0xFF) * firstWeight) +
                (((second >> 16) & 0xFF) * secondWeight))
            .round();
    int g =
        ((((first >> 8) & 0xFF) * firstWeight) +
                (((second >> 8) & 0xFF) * secondWeight))
            .round();
    int b = (((first & 0xFF) * firstWeight) + ((second & 0xFF) * secondWeight))
        .round();
    return 0xFF000000 | (r << 16) | (g << 8) | b;
  }

  static String componentCss(NeubrutalismTheme theme) {
    String accentColor = _hex(theme.color);
    String accentHot = _hex(theme.accentHot);
    String accentCool = _hex(theme.accentCool);
    String accentForeground = _foregroundFor(theme.color);
    String accentHotForeground = _foregroundFor(theme.accentHot);
    String accentCoolForeground = _foregroundFor(theme.accentCool);
    String lightSurface = _hex(theme.lightSurface);
    String lightSecondary = _hex(theme.lightSecondary);
    String lightSurfaceForeground = _foregroundFor(theme.lightSurface);
    String lightSecondaryForeground = _foregroundFor(theme.lightSecondary);
    int lightBandColor = _mix(theme.color, 0.72, 0xFFFFFFFF);
    String lightBand = _hex(lightBandColor);
    String lightBandForeground = _foregroundFor(lightBandColor);
    int darkBackgroundColor = theme.darkBackground;
    int darkSecondaryColor = theme.darkSecondary;
    int darkMutedColor = theme.darkMuted;
    int darkCardHoverColor = theme.darkCardHover;
    String darkBackground = _hex(darkBackgroundColor);
    String darkSecondary = _hex(darkSecondaryColor);
    String darkMuted = _hex(darkMutedColor);
    String darkCardHover = _hex(darkCardHoverColor);
    String darkBackgroundForeground = _hex(theme.darkForeground);
    String darkSecondaryForeground = _hex(theme.darkForeground);
    String darkMutedForeground = _hex(theme.darkForeground);
    String darkBorder = _hex(theme.darkBorder);
    String lightBorder = _hex(theme.lightBorder);
    String lightInk = _hex(theme.lightInk);

    return '''
#arcane-root.arcane-theme-neubrutalism {
  --font-sans: 'Inter', Arial, Helvetica, sans-serif;
  --font-heading: 'Space Grotesk', Arial, Helvetica, sans-serif;
  --font-mono: 'Space Mono', 'SFMono-Regular', Consolas, monospace;
  --font-display: 'Syne', 'Space Grotesk', sans-serif;
  --font-body: var(--font-sans);
  --background: $lightSurface;
  --foreground: $lightSurfaceForeground;
  --secondary-background: #FFFFFF;
  --card: #FFFFFF;
  --card-foreground: #000000;
  --popover: #FFFFFF;
  --popover-foreground: #000000;
  --muted: $lightSecondary;
  --muted-foreground: #555555;
  --primary: var(--nb-accent);
  --primary-foreground: var(--nb-on-accent);
  --secondary: $lightSecondary;
  --secondary-foreground: $lightSecondaryForeground;
  --success: #88D498;
  --success-foreground: #000000;
  --warning: #FFD23F;
  --warning-foreground: #000000;
  --destructive: #FF4444;
  --destructive-foreground: #000000;
  --nb-error-foreground: #B42318;
  --info: #74B9FF;
  --info-foreground: #000000;
  --border: $lightBorder;
  --input: #FFFFFF;
  --ring: var(--foreground);
  --main: var(--nb-accent);
  --main-foreground: var(--nb-on-accent-in, $accentForeground);
  --nb-ink: $lightInk;
  --nb-line: var(--nb-line-in, $lightBorder);
  --nb-control-line: var(--nb-line);
  --nb-switch-thumb: var(--nb-paper);
  --nb-shadow-color: #000000;
  --nb-paper: var(--secondary-background);
  --nb-paper-soft: var(--muted);
  --nb-on-background: $lightSurfaceForeground;
  --nb-on-secondary-background: #000000;
  --nb-on-card: #000000;
  --nb-on-paper: #000000;
  --nb-on-paper-soft: $lightSecondaryForeground;
  --nb-on-main: var(--nb-on-accent-in, $accentForeground);
  --nb-on-accent: var(--nb-on-accent-in, $accentForeground);
  --nb-on-accent-hot: $accentHotForeground;
  --nb-on-accent-cool: $accentCoolForeground;
  --nb-on-ink: #FFFFFF;
  --nb-surface-foreground: var(--nb-on-paper);
  --nb-control-paper: var(--nb-paper);
  --nb-control-foreground: var(--nb-on-paper);
  --nb-tooltip-foreground: var(--nb-on-ink);
  --nb-selection-bg: var(--nb-paper-soft);
  --nb-selection-line: var(--nb-line);
  --nb-selection-mark: var(--nb-accent);
  --nb-landing-band-bg: $lightBand;
  --nb-on-landing-band: $lightBandForeground;
  --nb-terminal-bg: #1A1A1A;
  --nb-terminal-foreground: #FFFFFF;
  /* The identity colors accept runtime overrides (--nb-*-in) so a host app can
     re-tint the accent, its readable foreground, the ink line, the hard shadow
     and the dark canvas from an account palette without a rebuild; unset, they
     fall back to this theme's stock scheme (same contract as the --w95-*-in
     hooks in arcane_jaspr_win95). */
  --nb-accent: var(--nb-accent-in, $accentColor);
  --nb-accent-hot: $accentHot;
  --nb-accent-cool: $accentCool;
  --nb-topbar-height: 70px;
  --nb-sidebar-width: 250px;
  --nb-secondary-width: 250px;
  --nb-toc-width: 250px;
  --shadow: var(--nb-shadow-md);

  --nb-border-thin: 2px;
  --nb-border-base: 3px;
  --nb-border-thick: 4px;

  --nb-shadow-xs: 2px 2px 0 0 var(--nb-shadow-color);
  --nb-shadow-sm: 3px 3px 0 0 var(--nb-shadow-color);
  --nb-shadow-md: 5px 5px 0 0 var(--nb-shadow-color);
  --nb-shadow-lg: 8px 8px 0 0 var(--nb-shadow-color);
  --nb-shadow-xl: 12px 12px 0 0 var(--nb-shadow-color);

  --nb-shadow-accent-md: 5px 5px 0 0 var(--nb-accent);
  --nb-shadow-hot-md: 5px 5px 0 0 var(--nb-accent-hot);
  --nb-shadow-cool-md: 5px 5px 0 0 var(--nb-accent-cool);

  --nb-translate-press: translate(2px, 2px);
  --nb-translate-press-md: translate(3px, 3px);
  --nb-translate-press-lg: translate(5px, 5px);

  --nb-radius-tight: 0;
  --nb-radius-soft: 0;
  --nb-radius-soft-lg: 0;
  --nb-switch-track-radius: 0;
  --nb-switch-thumb-radius: 0;
  --radius-xs: var(--nb-radius-tight);
  --radius-sm: 0;
  --radius-md: var(--nb-radius-soft);
  --radius: var(--radius-md);
  --border-radius: var(--nb-radius-soft);

  --nb-transition: 150ms ease;
  --nb-transition-fast: 100ms ease;

  background: var(--background) !important;
}

#arcane-root.arcane-theme-neubrutalism.neubrutalism-rounded {
  --nb-radius-tight: 4px;
  --nb-radius-soft: 8px;
  --nb-radius-soft-lg: 12px;
  --nb-switch-track-radius: 9999px;
  --nb-switch-thumb-radius: 50%;
  --radius-sm: 6px;
}

html:has(#arcane-root.arcane-theme-neubrutalism),
html:has(#arcane-root.arcane-theme-neubrutalism) body,
#arcane-root.arcane-theme-neubrutalism,
#arcane-root.arcane-theme-neubrutalism * {
  scrollbar-width: thin;
  scrollbar-color: var(--nb-accent) var(--background);
}

html:has(#arcane-root.arcane-theme-neubrutalism)::-webkit-scrollbar,
html:has(#arcane-root.arcane-theme-neubrutalism) body::-webkit-scrollbar,
#arcane-root.arcane-theme-neubrutalism *::-webkit-scrollbar {
  width: 0.55rem;
  height: 0.55rem;
}

html:has(#arcane-root.arcane-theme-neubrutalism)::-webkit-scrollbar-track,
html:has(#arcane-root.arcane-theme-neubrutalism) body::-webkit-scrollbar-track,
#arcane-root.arcane-theme-neubrutalism *::-webkit-scrollbar-track {
  background: var(--background);
}

html:has(#arcane-root.arcane-theme-neubrutalism)::-webkit-scrollbar-thumb,
html:has(#arcane-root.arcane-theme-neubrutalism) body::-webkit-scrollbar-thumb,
#arcane-root.arcane-theme-neubrutalism *::-webkit-scrollbar-thumb {
  background: var(--nb-accent);
  border: 2px solid var(--nb-line);
  border-radius: 0;
  background-clip: padding-box;
}

html:has(#arcane-root.arcane-theme-neubrutalism)::-webkit-scrollbar-thumb:hover,
html:has(#arcane-root.arcane-theme-neubrutalism) body::-webkit-scrollbar-thumb:hover,
#arcane-root.arcane-theme-neubrutalism *::-webkit-scrollbar-thumb:hover {
  background: var(--nb-accent-hot);
}

html.light #arcane-root.arcane-theme-neubrutalism,
:not(.dark) #arcane-root.arcane-theme-neubrutalism {
  --background: $lightSurface;
  --foreground: $lightSurfaceForeground;
  --secondary-background: #FFFFFF;
  --card: #FFFFFF;
  --card-foreground: #000000;
  --popover: #FFFFFF;
  --popover-foreground: #000000;
  --muted: $lightSecondary;
  --muted-foreground: #555555;
  --nb-error-foreground: #B42318;
  --accent: var(--main);
  --accent-foreground: var(--nb-on-accent-in, $accentForeground);
  --border: $lightBorder;
  --input: #FFFFFF;
  --ring: var(--foreground);
  --main: var(--nb-accent);
  --main-foreground: var(--nb-on-accent-in, $accentForeground);
  --nb-ink: $lightInk;
  --nb-line: var(--nb-line-in, $lightBorder);
  --nb-control-line: var(--nb-line);
  --nb-switch-thumb: var(--nb-paper);
  --nb-shadow-color: #000000;
  --nb-paper: var(--secondary-background);
  --nb-paper-soft: var(--muted);
  --nb-on-background: $lightSurfaceForeground;
  --nb-on-secondary-background: #000000;
  --nb-on-card: #000000;
  --nb-on-paper: #000000;
  --nb-on-paper-soft: $lightSecondaryForeground;
  --nb-on-main: var(--nb-on-accent-in, $accentForeground);
  --nb-on-accent: var(--nb-on-accent-in, $accentForeground);
  --nb-on-accent-hot: $accentHotForeground;
  --nb-on-accent-cool: $accentCoolForeground;
  --nb-on-ink: #FFFFFF;
  --nb-surface-foreground: var(--nb-on-paper);
  --nb-control-paper: var(--nb-paper);
  --nb-control-foreground: var(--nb-on-paper);
  --nb-tooltip-foreground: var(--nb-on-ink);
  --nb-selection-bg: $lightSecondary;
  --nb-selection-line: $lightBorder;
  --nb-selection-mark: var(--nb-accent);
  --nb-landing-band-bg: $lightBand;
  --nb-on-landing-band: $lightBandForeground;
}

html.dark #arcane-root.arcane-theme-neubrutalism,
#arcane-root.dark.arcane-theme-neubrutalism {
  --background: var(--nb-dark-bg-in, $darkBackground);
  --foreground: $darkBackgroundForeground;
  --secondary-background: $darkSecondary;
  --card: var(--secondary-background);
  --card-foreground: $darkSecondaryForeground;
  --card-hover: $darkCardHover;
  --popover: var(--secondary-background);
  --popover-foreground: $darkSecondaryForeground;
  --muted: $darkMuted;
  --muted-foreground: #BBB8AC;
  --nb-error-foreground: #FF6B6B;
  --secondary: $darkMuted;
  --secondary-foreground: $darkMutedForeground;
  --accent: var(--main);
  --accent-foreground: var(--nb-on-accent-in, $accentForeground);
  --border: $darkBorder;
  --input: var(--secondary-background);
  --ring: var(--foreground);
  --main: var(--nb-accent);
  --main-foreground: var(--nb-on-accent-in, $accentForeground);
  --nb-dark-inverse-black: var(--foreground);
  --nb-on-dark-inverse-black: #000000;
  --nb-ink: $lightInk;
  --nb-line: var(--nb-line-in, #080808);
  --nb-control-line: var(--nb-line-in, var(--border));
  --nb-switch-thumb: var(--foreground);
  --nb-shadow-color: #080808;
  --nb-paper: var(--secondary-background);
  --nb-paper-soft: var(--muted);
  --nb-on-background: $darkBackgroundForeground;
  --nb-on-secondary-background: $darkSecondaryForeground;
  --nb-on-card: $darkSecondaryForeground;
  --nb-on-paper: $darkSecondaryForeground;
  --nb-on-paper-soft: $darkMutedForeground;
  --nb-on-main: var(--nb-on-accent-in, $accentForeground);
  --nb-on-accent: var(--nb-on-accent-in, $accentForeground);
  --nb-on-accent-hot: $accentHotForeground;
  --nb-on-accent-cool: $accentCoolForeground;
  --nb-on-ink: #FFFFFF;
  --nb-surface-foreground: var(--nb-on-paper);
  --nb-control-paper: var(--nb-paper);
  --nb-control-foreground: var(--nb-on-paper);
  --nb-tooltip-foreground: var(--nb-on-ink);
  --nb-selection-bg: var(--muted);
  --nb-selection-line: var(--nb-control-line);
  --nb-selection-mark: var(--nb-accent);
  --nb-landing-band-bg: var(--muted);
  --nb-on-landing-band: var(--foreground);
  --nb-terminal-bg: #080808;
  --nb-terminal-foreground: var(--foreground);
}

html.dark #arcane-root.arcane-theme-neubrutalism::before,
#arcane-root.dark.arcane-theme-neubrutalism::before {
  content: none;
  display: none;
}

:not(.dark) #arcane-root.arcane-theme-neubrutalism::before,
html.light #arcane-root.arcane-theme-neubrutalism::before {
  content: none;
  display: none;
}

#arcane-root.arcane-theme-neubrutalism ::selection {
  background: var(--nb-accent);
  color: var(--nb-on-accent);
}

#arcane-root.arcane-theme-neubrutalism :focus-visible {
  outline: var(--nb-border-base) solid var(--ring) !important;
  outline-offset: 2px;
}

#arcane-root.arcane-theme-neubrutalism [data-arcane-field-shell="true"]:focus-within:not(.arcane-native-select-shell),
#arcane-root.arcane-theme-neubrutalism .neubrutalism-form-select button.neubrutalism-select-trigger[data-arcane-field-control="true"]:focus,
#arcane-root.arcane-theme-neubrutalism .arcane-native-select-shell select.arcane-select[data-arcane-field-control="true"]:focus-visible {
  outline: var(--nb-border-base) solid var(--ring) !important;
  outline-offset: 2px;
}

#arcane-root.arcane-theme-neubrutalism {
  font-family: var(--font-sans);
  font-size: 1rem;
  line-height: 1.7;
  color: var(--foreground);
}

#arcane-root.arcane-theme-neubrutalism .arcane-scaffold-header {
  height: var(--nb-topbar-height) !important;
  min-height: var(--nb-topbar-height) !important;
  padding: 0 1.25rem !important;
  border: 0 !important;
  border-bottom: var(--nb-border-thick) solid var(--nb-line) !important;
  background: var(--secondary-background) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar {
  position: static;
  border: 0;
  background: transparent;
  box-shadow: none;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar-inner {
  min-height: 3.125rem;
  padding: 0.35rem;
  gap: 0.5rem;
  border: var(--nb-border-base) solid var(--nb-line);
  border-radius: var(--nb-radius-soft-lg);
  background: var(--nb-paper);
  box-shadow: none;
}

html.dark #arcane-root.arcane-theme-neubrutalism .kb-topbar-inner {
  background: var(--nb-control-paper);
  color: var(--nb-control-foreground);
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar-left,
#arcane-root.arcane-theme-neubrutalism .kb-topbar-right {
  gap: 0.35rem;
  min-width: 0;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar-left {
  flex: 1 1 auto;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar-right {
  flex: 0 0 auto;
  margin-left: auto;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar-nav {
  margin-left: 0;
  gap: 0.35rem;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar-link,
#arcane-root.arcane-theme-neubrutalism .kb-topbar-github,
#arcane-root.arcane-theme-neubrutalism .kb-theme-toggle,
#arcane-root.arcane-theme-neubrutalism .kb-stylesheet-select,
#arcane-root.arcane-theme-neubrutalism .kb-palette-select,
#arcane-root.arcane-theme-neubrutalism .kb-hamburger {
  height: 2.2rem;
  border: var(--nb-border-thin) solid var(--nb-line);
  border-radius: var(--nb-radius-soft);
  background: var(--nb-paper);
  color: var(--foreground);
  box-shadow: none;
  font-weight: 800;
  text-transform: uppercase;
  transition:
    transform var(--nb-transition),
    box-shadow var(--nb-transition),
    background-color var(--nb-transition),
    color var(--nb-transition);
}

html.dark #arcane-root.arcane-theme-neubrutalism .kb-topbar-link,
html.dark #arcane-root.arcane-theme-neubrutalism .kb-topbar-github,
html.dark #arcane-root.arcane-theme-neubrutalism .kb-theme-toggle,
html.dark #arcane-root.arcane-theme-neubrutalism .kb-stylesheet-select,
html.dark #arcane-root.arcane-theme-neubrutalism .kb-palette-select,
html.dark #arcane-root.arcane-theme-neubrutalism .kb-hamburger {
  background: var(--nb-control-paper);
  color: var(--nb-control-foreground);
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar-link {
  padding: 0 0.7rem;
  text-decoration: none;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar-github,
#arcane-root.arcane-theme-neubrutalism .kb-theme-toggle,
#arcane-root.arcane-theme-neubrutalism .kb-hamburger {
  width: 2.2rem;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar .kb-hamburger {
  display: none !important;
}

@media (max-width: 900px) {
  #arcane-root.arcane-theme-neubrutalism .kb-topbar .kb-hamburger {
    display: inline-flex !important;
  }
}

#arcane-root.arcane-theme-neubrutalism .kb-stylesheet-select {
  min-width: 7.25rem;
}

#arcane-root.arcane-theme-neubrutalism .kb-palette-select {
  min-width: 5.5rem;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar-link:hover,
#arcane-root.arcane-theme-neubrutalism .kb-topbar-link.active,
#arcane-root.arcane-theme-neubrutalism .kb-topbar-github:hover,
#arcane-root.arcane-theme-neubrutalism .kb-theme-toggle:hover,
#arcane-root.arcane-theme-neubrutalism .kb-stylesheet-select:hover,
#arcane-root.arcane-theme-neubrutalism .kb-palette-select:hover,
#arcane-root.arcane-theme-neubrutalism .kb-hamburger:hover {
  transform: none;
  box-shadow: none;
  background: var(--nb-accent);
  color: var(--nb-on-accent);
}

#arcane-root.arcane-theme-neubrutalism .kb-search-input {
  height: 2.2rem;
  border: var(--nb-border-thin) solid var(--nb-line);
  border-radius: var(--nb-radius-soft);
  background: var(--nb-paper);
  color: var(--foreground);
  box-shadow: none;
}

html.dark #arcane-root.arcane-theme-neubrutalism .kb-search-input {
  background: var(--nb-control-paper);
  color: var(--nb-control-foreground);
}

#arcane-root.arcane-theme-neubrutalism .kb-search-input:focus {
  border-color: var(--nb-line);
  box-shadow: none;
}

#arcane-root.arcane-theme-neubrutalism .search-results {
  border: var(--nb-border-base) solid var(--nb-line);
  border-radius: var(--nb-radius-soft-lg);
  background: var(--nb-paper);
  box-shadow: var(--nb-shadow-md);
}

#arcane-root.arcane-theme-neubrutalism h1,
#arcane-root.arcane-theme-neubrutalism h2,
#arcane-root.arcane-theme-neubrutalism h3,
#arcane-root.arcane-theme-neubrutalism h4,
#arcane-root.arcane-theme-neubrutalism h5,
#arcane-root.arcane-theme-neubrutalism h6 {
  font-family: var(--font-heading);
  font-weight: 700;
  letter-spacing: -0.02em;
  line-height: 1.15;
  text-transform: none;
  color: var(--foreground);
}

#arcane-root.arcane-theme-neubrutalism :is(.display, .font-display, .neubrutalism-display) {
  font-family: var(--font-display);
  font-weight: 800;
  line-height: 1;
  letter-spacing: -0.03em;
}

:where(#arcane-root.arcane-theme-neubrutalism) h1 { font-size: clamp(2.5rem, 6vw, 5rem); }
:where(#arcane-root.arcane-theme-neubrutalism) h2 { font-size: clamp(2rem, 4vw, 3.5rem); }
:where(#arcane-root.arcane-theme-neubrutalism) h3 { font-size: clamp(1.5rem, 3vw, 2rem); }
:where(#arcane-root.arcane-theme-neubrutalism) h4 { font-size: clamp(1.25rem, 2vw, 1.5rem); }

#arcane-root.arcane-theme-neubrutalism a {
  color: var(--foreground);
  font-weight: 700;
  text-decoration: underline;
  text-decoration-thickness: 2px;
  text-underline-offset: 3px;
  transition: color var(--nb-transition), background-color var(--nb-transition);
}

#arcane-root.arcane-theme-neubrutalism a:hover {
  color: var(--nb-on-accent);
  background-color: var(--nb-accent);
  text-decoration-color: var(--nb-line);
}

#arcane-root.arcane-theme-neubrutalism strong,
#arcane-root.arcane-theme-neubrutalism b {
  font-weight: 800;
}

#arcane-root.arcane-theme-neubrutalism code,
#arcane-root.arcane-theme-neubrutalism kbd,
#arcane-root.arcane-theme-neubrutalism samp,
#arcane-root.arcane-theme-neubrutalism pre {
  font-family: var(--font-mono) !important;
}

#arcane-root.arcane-theme-neubrutalism .arcane-scaffold-sidebar,
#arcane-root.arcane-theme-neubrutalism .arcane-scaffold-secondary,
#arcane-root.arcane-theme-neubrutalism .arcane-scaffold-footer,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-command-dialog,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-calendar,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-chart,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-data-table-container,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-static-table-container,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-sidebar,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-empty-state-card,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-resizable,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-scroll-area,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-form-section,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-toggle-group,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-slot-counter,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-slot-counter-card,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-kv-table,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-button-panel,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-toolbar,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-button-group,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-panel {
  background-color: var(--nb-paper) !important;
  border: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  box-shadow: var(--nb-shadow-md) !important;
  color: var(--nb-surface-foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism :is(.neubrutalism-feature-card, .neubrutalism-icon-card, .neubrutalism-cta-card, .neubrutalism-stat-card, .neubrutalism-pricing-card, .neubrutalism-testimonial-card):not([data-arcane-decorated]) {
  min-width: 0;
  border: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft-lg) !important;
  box-shadow: var(--nb-shadow-md) !important;
  padding: clamp(1rem, 3vw, 1.5rem) !important;
  overflow-wrap: anywhere;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-feature-card[data-arcane-accent]:not([data-arcane-decorated]) {
  border-color: var(--arcane-card-accent) !important;
}

#arcane-root.arcane-theme-neubrutalism :is(.neubrutalism-feature-card-icon, .neubrutalism-icon-card-icon, .neubrutalism-cta-card-icon, .neubrutalism-stat-card-icon, .neubrutalism-pricing-card-icon) {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 44px;
  height: 44px;
  flex: 0 0 44px;
  border-radius: var(--nb-radius-tight);
  border: var(--nb-border-thin) solid var(--nb-line);
  background: transparent;
  box-shadow: var(--nb-shadow-xs);
}

#arcane-root.arcane-theme-neubrutalism :is(.neubrutalism-feature-card-icon, .neubrutalism-icon-card-icon, .neubrutalism-cta-card-icon, .neubrutalism-stat-card-icon, .neubrutalism-pricing-card-icon):not([data-arcane-accent]) {
  background: var(--nb-accent);
  color: var(--nb-on-accent) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-feature-card-cta {
  text-decoration: underline;
  text-decoration-thickness: 2px;
  text-underline-offset: 4px;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-feature-card-cta:not([data-arcane-accent]) {
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism :is(.neubrutalism-cta-card-button, .neubrutalism-pricing-card-cta) {
  min-height: 44px;
  border: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  box-shadow: var(--nb-shadow-sm);
  font-family: var(--font-sans);
  font-size: 1rem !important;
  font-weight: 700;
  text-decoration: none !important;
}

#arcane-root.arcane-theme-neubrutalism :is(.neubrutalism-cta-card-button, .neubrutalism-pricing-card-cta):not([data-arcane-accent]) {
  background: var(--nb-accent) !important;
  color: var(--nb-on-accent) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-testimonial-card [data-arcane-intrinsic-shape="avatar"]:not(img) {
  border: var(--nb-border-thin) solid var(--nb-line);
  background: var(--nb-accent) !important;
  color: var(--nb-on-accent) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-rating-stars,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-testimonial-card-rating > span:first-child {
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-pagination {
  max-width: 100%;
  flex-wrap: wrap;
  padding: 4px;
  row-gap: .75rem !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-pagination-button {
  flex-shrink: 0;
  min-height: 40px;
  border-radius: var(--nb-radius-soft);
  font-family: var(--font-sans);
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-pagination-button[aria-current="page"] {
  background: var(--nb-accent) !important;
  color: var(--nb-on-accent) !important;
  border: var(--nb-border-base) solid var(--nb-line) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-flexi-cards {
  flex-wrap: wrap;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-flexi-cards > * {
  max-width: 100%;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-flexi-cards-simple {
  grid-template-columns: repeat(auto-fit, minmax(min(100%, 250px), 1fr)) !important;
}

@media (max-width: 600px) {
  #arcane-root.arcane-theme-neubrutalism .neubrutalism-pricing-grid {
    grid-template-columns: minmax(0, 1fr) !important;
  }
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-card.clickable {
  cursor: pointer;
  transition: transform var(--nb-transition), box-shadow var(--nb-transition);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-card.clickable:is([data-variant="elevated"], [data-variant="interactive"]):not([data-arcane-decorated]):hover {
  transform: translate(-2px, -2px);
  box-shadow: var(--nb-shadow-lg) !important;
}
/* Nested cards are sub-surfaces: a neubrutalism card inside another drops its
   block border + hard shadow so stacked panels do not frame twice. Re-assert a
   frame on the inner card with decoration:/styles:. */
#arcane-root.arcane-theme-neubrutalism
  .neubrutalism-card
  .neubrutalism-card:not([data-arcane-decorated]) {
  background-color: transparent !important;
  border-color: transparent !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-card.clickable:is([data-variant="elevated"], [data-variant="interactive"]):not([data-arcane-decorated]):active {
  transform: var(--nb-translate-press);
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-dropdown-menu,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-dropdown-submenu,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-context-menu,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-menubar-content,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-select-content,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-date-picker-dropdown,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-time-picker-dropdown,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-popover,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-tooltip,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-toast:not([data-arcane-decorated]),
#arcane-root.arcane-theme-neubrutalism .neubrutalism-command,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-dialog,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-sheet,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-drawer,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-confirm-dialog,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-alert-dialog {
  background-color: var(--nb-paper) !important;
  border: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  box-shadow: var(--nb-shadow-lg) !important;
  color: var(--nb-surface-foreground) !important;
  backdrop-filter: none !important;
  -webkit-backdrop-filter: none !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-dialog-overlay {
  box-sizing: border-box;
  height: 100dvh;
  overflow: hidden;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-dialog {
  display: flex;
  flex-direction: column;
  box-sizing: border-box;
  min-height: 0;
  max-height: calc(100vh - 3rem);
  max-height: calc(100dvh - 3rem);
  overflow: hidden;
  padding: clamp(1rem, 4vw, 2rem) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-dialog-content {
  flex: 1 1 auto;
  min-height: 0;
  overflow: auto;
  overscroll-behavior: contain;
  padding: 6px;
  margin: 0 -6px;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-dialog-title,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-dialog-actions {
  flex-shrink: 0;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-dialog-actions {
  flex-wrap: wrap;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-dropdown-item,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-context-menu-item,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-menubar-trigger,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-select-option {
  position: relative;
  border: var(--nb-border-thin) solid transparent !important;
  border-radius: var(--nb-radius-tight) !important;
  color: var(--foreground) !important;
  background-color: transparent !important;
  transition:
    transform var(--nb-transition),
    box-shadow var(--nb-transition),
    background-color var(--nb-transition),
    border-color var(--nb-transition),
    color var(--nb-transition);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-dropdown-item:hover:not([data-disabled="true"]),
#arcane-root.arcane-theme-neubrutalism .neubrutalism-dropdown-item:focus-visible:not([data-disabled="true"]),
#arcane-root.arcane-theme-neubrutalism .neubrutalism-dropdown-item[aria-checked="true"],
#arcane-root.arcane-theme-neubrutalism .neubrutalism-context-menu-item:hover:not([data-disabled="true"]),
#arcane-root.arcane-theme-neubrutalism .neubrutalism-context-menu-item:focus-visible:not([data-disabled="true"]),
#arcane-root.arcane-theme-neubrutalism .neubrutalism-menubar-trigger:hover:not([data-disabled="true"]),
#arcane-root.arcane-theme-neubrutalism .neubrutalism-menubar-trigger:focus-visible:not([data-disabled="true"]),
#arcane-root.arcane-theme-neubrutalism .neubrutalism-select-option:hover:not([data-disabled="true"]),
#arcane-root.arcane-theme-neubrutalism .neubrutalism-select-option:focus-visible:not([data-disabled="true"]),
#arcane-root.arcane-theme-neubrutalism .neubrutalism-select-option[aria-selected="true"] {
  background-color: var(--nb-selection-bg) !important;
  border-color: var(--nb-selection-line) !important;
  color: var(--foreground) !important;
  box-shadow: var(--nb-shadow-xs) !important;
  transform: translate(-1px, -1px);
}

html.dark #arcane-root.arcane-theme-neubrutalism .arcane-scaffold-main {
  color: var(--nb-surface-foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-toc-panel {
  width: 14rem !important;
  top: 5rem !important;
  scrollbar-color: var(--nb-line) transparent;
}

#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc {
  padding: 0.625rem !important;
  border: var(--nb-border-thick) solid var(--nb-line) !important;
  border-radius: 0 !important;
  background: var(--nb-paper) !important;
  box-shadow: var(--nb-shadow-lg) !important;
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-title {
  position: relative;
  margin: -0.625rem -0.625rem 0.625rem !important;
  padding: 0.65rem 0.75rem !important;
  border-bottom: var(--nb-border-thick) solid var(--nb-line) !important;
  border-radius: 0 !important;
  background: var(--nb-paper-soft) !important;
  color: var(--foreground) !important;
  font-family: var(--font-heading) !important;
  font-size: 0.75rem !important;
  font-weight: 900 !important;
  letter-spacing: 0.04em !important;
  text-transform: uppercase !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-content > ul,
#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-content ul ul {
  padding-left: 0 !important;
  margin-left: 0 !important;
  margin-top: 0.35rem !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-content li::before,
#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-content li::after {
  display: none !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-content a {
  position: relative;
  display: block;
  margin: 0.25rem 0 !important;
  padding: 0.45rem 0.55rem 0.45rem 1.35rem !important;
  border: var(--nb-border-thin) solid transparent !important;
  border-radius: var(--nb-radius-tight) !important;
  background: transparent !important;
  color: var(--foreground) !important;
  font-family: var(--font-sans);
  font-size: 0.78rem;
  font-weight: 800;
  line-height: 1.25;
  text-decoration: none !important;
  box-shadow: none !important;
  transition:
    transform var(--nb-transition),
    box-shadow var(--nb-transition),
    background-color var(--nb-transition),
    border-color var(--nb-transition);
}

#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-content ul ul a {
  margin-left: 0.7rem !important;
  padding-left: 1.2rem !important;
  font-size: 0.74rem;
  opacity: 0.92;
}

#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-content a::before {
  content: '';
  position: absolute;
  left: 0.45rem;
  top: 50%;
  width: 0.45rem;
  height: 0.45rem;
  border: var(--nb-border-thin) solid var(--nb-line);
  background: var(--nb-paper);
  box-shadow: 2px 2px 0 0 var(--nb-shadow-color);
  transform: translateY(-50%) rotate(45deg);
}

#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-content a:hover,
#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-content a.toc-active {
  background: var(--nb-selection-bg) !important;
  border-color: var(--nb-selection-line) !important;
  color: var(--foreground) !important;
  box-shadow: var(--nb-shadow-xs) !important;
  transform: translate(-1px, -1px);
}

#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-content a:hover::before,
#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-content a.toc-active::before {
  background: var(--nb-selection-mark);
}

html.dark #arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc {
  background: var(--nb-paper) !important;
  border-color: var(--nb-line) !important;
  box-shadow: var(--nb-shadow-xl) !important;
  color: var(--nb-surface-foreground) !important;
}

html.dark #arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-title {
  background: var(--nb-control-paper) !important;
  color: var(--nb-control-foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-tooltip {
  background-color: var(--nb-ink) !important;
  color: var(--nb-tooltip-foreground) !important;
  border: var(--nb-border-thin) solid var(--nb-line) !important;
  box-shadow: var(--nb-shadow-sm) !important;
  font-weight: 700;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-button {
  font-family: var(--font-heading);
  font-weight: 700;
  letter-spacing: 0;
  text-transform: none;
  border: var(--nb-border-base) solid var(--nb-line);
  border-radius: var(--nb-radius-soft) !important;
  box-shadow: var(--nb-shadow-md);
  transition: transform var(--nb-transition-fast), box-shadow var(--nb-transition-fast);
  background-image: none !important;
  filter: none !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-button:hover:not(:disabled):not([data-disabled="true"]) {
  transform: translate(-2px, -2px);
  box-shadow: var(--nb-shadow-lg);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-button:active:not(:disabled):not([data-disabled="true"]) {
  transform: var(--nb-translate-press);
  box-shadow: none;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-button[data-variant="ghost"],
#arcane-root.arcane-theme-neubrutalism .neubrutalism-button[data-variant="link"] {
  border: none !important;
  box-shadow: none !important;
  background-color: transparent !important;
  transform: none !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-button[data-variant="link"] {
  text-decoration: underline;
  text-decoration-thickness: 2px;
  text-underline-offset: 4px;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-button[data-variant="link"]:hover:not(:disabled) {
  transform: none;
  box-shadow: none !important;
  background-color: var(--nb-accent) !important;
  color: var(--nb-on-accent) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-text-input,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-textarea,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-select-trigger,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-native-select,
#arcane-root.arcane-theme-neubrutalism .arcane-select,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-otp-digit,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-date-picker-trigger,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-time-picker-trigger,
#arcane-root.arcane-theme-neubrutalism textarea {
  background-color: var(--nb-control-paper) !important;
  border: var(--nb-border-base) solid var(--nb-control-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  box-shadow: var(--nb-shadow-sm) !important;
  color: var(--nb-control-foreground) !important;
  font-family: var(--font-sans);
  font-size: 1rem !important;
  font-weight: 400;
  transition: box-shadow var(--nb-transition), transform var(--nb-transition);
}

#arcane-root.arcane-theme-neubrutalism .arcane-select[aria-invalid="true"] {
  border-color: var(--destructive) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-select-label {
  display: block;
  margin-bottom: .5rem;
  color: var(--foreground) !important;
  font-family: var(--font-sans) !important;
  font-size: .875rem !important;
  font-weight: 700 !important;
  letter-spacing: .025em !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-select-trigger {
  gap: .75rem;
  min-width: 0;
  text-align: left;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-select-trigger > :first-child {
  min-width: 0;
  overflow: hidden;
  text-overflow: ellipsis;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-select-chevron {
  display: flex;
  flex-shrink: 0;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-select-dropdown {
  padding: .375rem;
  overscroll-behavior: contain;
  scrollbar-gutter: stable;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-select-option {
  width: calc(100% - 8px) !important;
  min-height: 40px;
  overflow-wrap: anywhere;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-select-error {
  margin-top: .5rem;
  color: var(--nb-error-foreground) !important;
  font-size: .875rem;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-select-search input {
  border-color: var(--nb-control-line) !important;
  font-family: var(--font-sans);
  font-size: 1rem !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-text-input:focus,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-text-input:focus-within,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-textarea:focus,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-select-trigger:focus,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-select-trigger[aria-expanded="true"],
#arcane-root.arcane-theme-neubrutalism .neubrutalism-date-picker-trigger:focus,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-time-picker-trigger:focus,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-otp-digit:focus,
#arcane-root.arcane-theme-neubrutalism textarea:focus {
  outline: var(--nb-border-base) solid var(--ring) !important;
  outline-offset: 2px;
  box-shadow: var(--nb-shadow-md) !important;
  transform: translate(-1px, -1px);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-checkbox {
  background-color: var(--nb-paper) !important;
  border: var(--nb-border-base) solid var(--nb-control-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  box-shadow: var(--nb-shadow-xs) !important;
  transition: transform var(--nb-transition), box-shadow var(--nb-transition);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-checkbox:hover:not([data-disabled="true"]) {
  transform: translate(-1px, -1px);
  box-shadow: var(--nb-shadow-sm) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-checkbox[data-state="checked"] {
  border-color: var(--nb-line) !important;
  background-color: var(--nb-accent) !important;
  color: var(--nb-on-accent) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-toggle-switch {
  background-color: var(--nb-paper-soft) !important;
  border: var(--nb-border-base) solid var(--nb-control-line) !important;
  border-radius: var(--nb-switch-track-radius) !important;
  box-shadow: var(--nb-shadow-xs) !important;
  transition: background-color var(--nb-transition), box-shadow var(--nb-transition);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-toggle-switch[data-state="checked"] {
  border-color: var(--nb-line) !important;
  background-color: var(--nb-accent) !important;
  box-shadow: var(--nb-shadow-xs) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-toggle-switch-thumb {
  background-color: var(--nb-switch-thumb) !important;
  border: var(--nb-border-thin) solid var(--nb-line) !important;
  border-radius: var(--nb-switch-thumb-radius) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-toggle-switch[data-state="unchecked"] .neubrutalism-toggle-switch-thumb {
  transform: translateX(0) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-toggle-switch[data-state="checked"] .neubrutalism-toggle-switch-thumb {
  transform: translateX(var(--nb-switch-travel)) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-radio-circle {
  background-color: var(--nb-paper) !important;
  border: var(--nb-border-base) solid var(--nb-control-line) !important;
  border-radius: var(--nb-radius-tight) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-radio-option[data-state="checked"] .neubrutalism-radio-circle {
  border-color: var(--nb-line) !important;
  background-color: var(--nb-accent-hot) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-radio-dot {
  visibility: hidden;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-radio-option[data-state="checked"] .neubrutalism-radio-dot {
  visibility: visible;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-radio-card .neubrutalism-radio-label {
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism :is(.neubrutalism-radio-card, .neubrutalism-radio-button) {
  border-color: var(--nb-control-line) !important;
  background: var(--nb-paper) !important;
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism :is(.neubrutalism-radio-card, .neubrutalism-radio-button)[data-state="checked"] {
  border-color: var(--nb-line) !important;
  background: var(--nb-accent) !important;
  color: var(--nb-on-accent) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-radio-card .neubrutalism-radio-description {
  color: var(--muted-foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-radio-card[data-state="checked"] :is(.neubrutalism-radio-label, .neubrutalism-radio-description) {
  color: var(--nb-on-accent) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-slider-track {
  background-color: var(--nb-paper) !important;
  border: var(--nb-border-base) solid var(--nb-control-line) !important;
  border-radius: var(--nb-radius-soft) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-slider-value {
  color: var(--foreground) !important;
  font-family: var(--font-mono);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-slider-fill {
  background-color: var(--nb-accent) !important;
  border-radius: var(--nb-radius-soft) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-slider-thumb {
  background-color: var(--nb-switch-thumb) !important;
  border: var(--nb-border-base) solid var(--nb-control-line) !important;
  border-radius: var(--nb-radius-tight) !important;
  box-shadow: var(--nb-shadow-xs) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-progress-track {
  background-color: var(--nb-paper) !important;
  border: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  overflow: hidden;
  box-shadow: var(--nb-shadow-xs);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-progress-fill {
  background-color: var(--nb-accent) !important;
  border-right: var(--nb-border-thin) solid var(--nb-line);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-tabs,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-tabs-content {
  min-width: 0;
  max-width: 100%;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-tabs-list,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-tab-bar {
  min-width: 0;
  max-width: 100%;
  box-sizing: border-box;
  flex-wrap: wrap;
  gap: 0.5rem;
  padding: 0.25rem;
  background: transparent;
  border: none;
  box-shadow: none;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-tabs-trigger,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-tab-bar-item {
  min-width: 0;
  max-width: 100%;
  flex-basis: auto !important;
  white-space: normal !important;
  overflow-wrap: anywhere;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-tab,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-tabs-trigger,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-tab-bar-item {
  border: var(--nb-border-base) solid var(--nb-control-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  font-family: var(--font-heading);
  font-weight: 700 !important;
  background-color: var(--nb-paper) !important;
  transition: transform var(--nb-transition), box-shadow var(--nb-transition), background-color var(--nb-transition);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-tab:hover:not([data-disabled="true"]),
#arcane-root.arcane-theme-neubrutalism .neubrutalism-tabs-trigger:hover:not([data-disabled="true"]),
#arcane-root.arcane-theme-neubrutalism .neubrutalism-tab-bar-item:hover:not([data-disabled="true"]) {
  border-color: var(--nb-line) !important;
  background-color: var(--accent) !important;
  color: var(--nb-on-accent) !important;
  transform: translate(-1px, -1px);
  box-shadow: var(--nb-shadow-xs);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-tab[data-state="active"],
#arcane-root.arcane-theme-neubrutalism .neubrutalism-tabs-trigger[data-state="active"],
#arcane-root.arcane-theme-neubrutalism .neubrutalism-tab-bar-item[data-state="active"] {
  border-color: var(--nb-line) !important;
  background-color: var(--nb-accent) !important;
  color: var(--nb-on-accent) !important;
  box-shadow: var(--nb-shadow-xs) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-status-badge,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-kbd {
  border: var(--nb-border-thin) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  box-shadow: var(--nb-shadow-xs);
  font-weight: 700;
  background-color: var(--nb-paper);
  color: var(--nb-surface-foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-avatar-inner {
  border: var(--nb-border-base) solid var(--nb-line) !important;
  background-image: none !important;
  box-shadow: var(--nb-shadow-xs);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-alert {
  border: var(--nb-border-thick) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  box-shadow: var(--nb-shadow-md) !important;
  background-image: none !important;
  font-weight: 600;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-separator {
  background-color: var(--nb-ink) !important;
  border: none !important;
  border-radius: 0 !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-skeleton {
  background-color: var(--nb-paper) !important;
  border: var(--nb-border-thin) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  box-shadow: var(--nb-shadow-xs);
  opacity: 0.55;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-skeleton[data-arcane-intrinsic-shape="skeleton-circle"] {
  border-radius: 50% !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-pagination-link {
  border: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  box-shadow: var(--nb-shadow-xs);
  background-color: var(--nb-paper) !important;
  font-weight: 700;
  transition: transform var(--nb-transition), box-shadow var(--nb-transition);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-pagination-link:hover:not(:disabled) {
  transform: translate(-1px, -1px);
  box-shadow: var(--nb-shadow-sm);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-pagination-link[data-state="active"] {
  background-color: var(--nb-accent) !important;
  color: var(--nb-on-accent) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-breadcrumbs {
  font-weight: 600;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-breadcrumb-link:hover {
  background-color: var(--nb-accent);
  color: var(--nb-on-accent);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-dropdown-item:hover:not([data-disabled="true"]),
#arcane-root.arcane-theme-neubrutalism .neubrutalism-context-menu-item:hover:not([data-disabled="true"]),
#arcane-root.arcane-theme-neubrutalism .neubrutalism-menubar-trigger:hover:not([data-disabled="true"]),
#arcane-root.arcane-theme-neubrutalism .neubrutalism-select-option:hover:not([data-disabled="true"]) {
  background-color: var(--nb-selection-bg) !important;
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-sidebar-link:hover,
#arcane-root.arcane-theme-neubrutalism .sidebar-link:hover {
  background-color: var(--nb-accent) !important;
  color: var(--nb-on-accent) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-sidebar-link.active,
#arcane-root.arcane-theme-neubrutalism .sidebar-link.active {
  background-color: var(--nb-accent) !important;
  color: var(--nb-on-accent) !important;
  border: var(--nb-border-thin) solid var(--nb-line) !important;
  box-shadow: var(--nb-shadow-xs);
  font-weight: 700;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-loading-spinner,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-circular-progress {
  border-color: var(--nb-paper) !important;
  border-right-color: transparent !important;
  border-width: var(--nb-border-base) !important;
}

#arcane-root.arcane-theme-neubrutalism .prose {
  color: var(--foreground);
  line-height: 1.65;
}

#arcane-root.arcane-theme-neubrutalism .prose h1 {
  font-family: var(--font-heading);
  font-size: clamp(2.5rem, 6vw, 5rem);
  font-weight: 700;
  line-height: 1.15;
  letter-spacing: -0.03em;
  margin-top: 0;
  margin-bottom: 1.5rem;
}

#arcane-root.arcane-theme-neubrutalism .prose h2 {
  font-family: var(--font-heading);
  font-size: clamp(2rem, 4vw, 3.5rem);
  font-weight: 700;
  line-height: 1.15;
  letter-spacing: -0.02em;
  border-bottom: var(--nb-border-base) solid var(--nb-line);
  padding-bottom: 0.5rem;
  margin-top: 2.25rem;
  margin-bottom: 1rem;
}

#arcane-root.arcane-theme-neubrutalism .prose h3 {
  font-family: var(--font-heading);
  font-size: clamp(1.5rem, 3vw, 2rem);
  font-weight: 700;
  margin-top: 1.75rem;
  margin-bottom: 0.75rem;
}

#arcane-root.arcane-theme-neubrutalism .prose blockquote {
  border: var(--nb-border-base) solid var(--nb-line);
  background-color: var(--nb-accent-cool);
  color: var(--nb-on-accent-cool);
  padding: 0.75rem 1rem;
  margin: 1.5rem 0;
  font-weight: 600;
  font-style: normal;
}

#arcane-root.arcane-theme-neubrutalism .prose hr {
  border: none;
  border-top: var(--nb-border-base) solid var(--nb-line);
  margin: 2rem 0;
}

#arcane-root.arcane-theme-neubrutalism .prose table {
  width: 100%;
  border-collapse: separate;
  border-spacing: 0;
  border: var(--nb-border-base) solid var(--nb-line);
  border-radius: var(--nb-radius-soft);
  box-shadow: var(--nb-shadow-sm);
  margin: 1.5rem 0;
  overflow: hidden;
}

#arcane-root.arcane-theme-neubrutalism .prose th {
  background-color: var(--nb-accent);
  color: var(--nb-on-accent);
  font-family: var(--font-heading);
  font-weight: 800;
  text-align: left;
  padding: 0.75rem;
  border-bottom: var(--nb-border-base) solid var(--nb-line);
}

#arcane-root.arcane-theme-neubrutalism .prose td {
  padding: 0.75rem;
  border-bottom: var(--nb-border-thin) solid var(--nb-line);
}

#arcane-root.arcane-theme-neubrutalism .prose tr:last-child td {
  border-bottom: none;
}

#arcane-root.arcane-theme-neubrutalism .prose pre {
  background-color: var(--nb-paper);
  border: var(--nb-border-base) solid var(--nb-line);
  border-radius: var(--nb-radius-soft);
  box-shadow: var(--nb-shadow-sm);
  padding: 1rem 1.25rem;
  margin: 1.5rem 0;
  overflow-x: auto;
}

#arcane-root.arcane-theme-neubrutalism .prose :not(pre) > code {
  background-color: var(--nb-accent);
  color: var(--nb-on-accent);
  border: var(--nb-border-thin) solid var(--nb-line);
  border-radius: var(--nb-radius-soft);
  padding: 0.0625rem 0.375rem;
  font-weight: 700;
  font-size: 0.875em;
}

#arcane-root.arcane-theme-neubrutalism .prose img {
  border: var(--nb-border-base) solid var(--nb-line);
  border-radius: var(--nb-radius-soft);
  box-shadow: var(--nb-shadow-md);
  margin: 1.5rem 0;
  max-width: 100%;
  height: auto;
}

#arcane-root.arcane-theme-neubrutalism .prose .hljs-keyword { color: #d73a49; font-weight: 700; }
#arcane-root.arcane-theme-neubrutalism .prose .hljs-string { color: #032f62; font-weight: 600; }
#arcane-root.arcane-theme-neubrutalism .prose .hljs-number { color: #005cc5; font-weight: 600; }
#arcane-root.arcane-theme-neubrutalism .prose .hljs-function,
#arcane-root.arcane-theme-neubrutalism .prose .hljs-title { color: #6f42c1; font-weight: 700; }
#arcane-root.arcane-theme-neubrutalism .prose .hljs-comment { color: #6a737d; font-style: italic; }
#arcane-root.arcane-theme-neubrutalism .prose .hljs-variable { color: #e36209; }
#arcane-root.arcane-theme-neubrutalism .prose .hljs-class,
#arcane-root.arcane-theme-neubrutalism .prose .hljs-built_in { color: #22863a; font-weight: 700; }

html.dark #arcane-root.arcane-theme-neubrutalism .prose .hljs-keyword { color: #ff7b72; }
html.dark #arcane-root.arcane-theme-neubrutalism .prose .hljs-string { color: #a5d6ff; }
html.dark #arcane-root.arcane-theme-neubrutalism .prose .hljs-number { color: #79c0ff; }
html.dark #arcane-root.arcane-theme-neubrutalism .prose .hljs-function,
html.dark #arcane-root.arcane-theme-neubrutalism .prose .hljs-title { color: #d2a8ff; }
html.dark #arcane-root.arcane-theme-neubrutalism .prose .hljs-comment { color: #8b949e; }
html.dark #arcane-root.arcane-theme-neubrutalism .prose .hljs-variable { color: #ffa657; }
html.dark #arcane-root.arcane-theme-neubrutalism .prose .hljs-class,
html.dark #arcane-root.arcane-theme-neubrutalism .prose .hljs-built_in { color: #7ee787; }

@keyframes nb-shake {
  0%, 100% { transform: translateX(0); }
  20%, 60% { transform: translateX(-2px); }
  40%, 80% { transform: translateX(2px); }
}

#arcane-root.arcane-theme-neubrutalism [data-error="true"] {
  animation: nb-shake 220ms ease-in-out;
  border-color: var(--destructive) !important;
}

#arcane-root.arcane-theme-neubrutalism .arcane-theme-neubrutalism {
  background-image: none !important;
  filter: none !important;
  backdrop-filter: none !important;
  -webkit-backdrop-filter: none !important;
  text-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-button[data-variant="primary"],
#arcane-root.arcane-theme-neubrutalism .neubrutalism-button[data-variant="default"] {
  background-color: var(--nb-accent) !important;
  color: var(--nb-on-accent) !important;
  border: var(--nb-border-base) solid var(--nb-line);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-button[data-variant="secondary"] {
  border-color: var(--nb-control-line);
  background-color: var(--nb-paper-soft) !important;
  color: var(--nb-surface-foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-button[data-variant="destructive"] {
  background-color: var(--destructive) !important;
  color: var(--destructive-foreground, var(--nb-paper)) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-button[data-variant="outline"] {
  border-color: var(--nb-control-line);
  background-color: var(--nb-paper) !important;
  color: var(--nb-surface-foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-button[data-variant="ghost"]:hover:not(:disabled):not([data-disabled="true"]),
#arcane-root.arcane-theme-neubrutalism .neubrutalism-button[data-variant="outline"]:hover:not(:disabled):not([data-disabled="true"]) {
  border-color: var(--nb-line);
  background-color: var(--nb-accent) !important;
  color: var(--nb-on-accent) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-slider-track-fill,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-slider-fill {
  background: var(--nb-accent) !important;
  background-image: none !important;
  box-shadow: none !important;
  border-right: var(--nb-border-thin) solid var(--nb-line);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-slider-thumb {
  background: var(--nb-switch-thumb) !important;
  background-image: none !important;
  border: var(--nb-border-base) solid var(--nb-control-line) !important;
  box-shadow: var(--nb-shadow-xs) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-slider-thumb[data-state="active"]:hover {
  transform: translate(-50%, calc(-50% - 1px)) !important;
  box-shadow: var(--nb-shadow-sm) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-status-badge,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-badge {
  background: var(--nb-paper) !important;
  background-image: none !important;
  border: var(--nb-border-thin) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  box-shadow: var(--nb-shadow-sm) !important;
  font-family: var(--font-mono);
  font-size: 0.75rem;
  font-weight: 400 !important;
  letter-spacing: 0.05em;
  text-transform: uppercase;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-badge-primary {
  background: var(--nb-accent) !important;
  color: var(--nb-on-accent) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-badge-successSolid {
  background: var(--success, #22c55e) !important;
  color: var(--success-foreground, #000) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-badge-warningSolid {
  background: var(--warning, #f59e0b) !important;
  color: var(--warning-foreground, #000) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-badge-errorSolid {
  background: var(--destructive) !important;
  color: var(--destructive-foreground, #fff) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-badge-infoSolid {
  background: var(--info, #3b82f6) !important;
  color: var(--info-foreground, #fff) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-badge-secondary,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-badge-status {
  background: var(--nb-paper-soft) !important;
  color: var(--nb-surface-foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-badge-outline {
  background: transparent !important;
  color: var(--nb-surface-foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-status-indicator {
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-toggle-group {
  background: var(--nb-paper) !important;
  border: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  box-shadow: var(--nb-shadow-xs) !important;
  padding: 4px !important;
  gap: 4px !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-toggle-group-item {
  background: transparent !important;
  background-image: none !important;
  border: var(--nb-border-thin) solid transparent !important;
  border-radius: var(--nb-radius-soft) !important;
  box-shadow: none !important;
  color: var(--foreground) !important;
  font-weight: 800 !important;
  transition: transform var(--nb-transition), box-shadow var(--nb-transition), background-color var(--nb-transition);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-toggle-group-item:hover:not([data-disabled="true"]) {
  background: var(--nb-paper-soft) !important;
  border-color: var(--nb-line) !important;
  transform: translate(-1px, -1px);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-toggle-group-item.selected,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-toggle-group-item[data-state="on"] {
  background: var(--nb-accent) !important;
  border-color: var(--nb-line) !important;
  color: var(--nb-on-accent) !important;
  box-shadow: var(--nb-shadow-xs) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-accordion,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-disclosure-group,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-disclosure {
  min-width: 0;
  background: var(--nb-paper);
  border: var(--nb-border-base) solid var(--nb-line);
  border-radius: var(--nb-radius-soft);
  box-shadow: var(--nb-shadow-sm);
  color: var(--nb-surface-foreground);
  overflow: hidden;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-accordion > details,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-disclosure-group > .neubrutalism-disclosure {
  margin: 0;
  border: 0;
  border-radius: 0;
  background: transparent;
  box-shadow: none;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-accordion > details + details,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-disclosure-group > .neubrutalism-disclosure + .neubrutalism-disclosure {
  border-top: var(--nb-border-thin) solid var(--nb-line);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-disclosure-group {
  gap: 0 !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-disclosure-minimal {
  background: transparent;
  border: none;
  box-shadow: none;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-accordion > details > summary,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-disclosure-summary {
  display: flex;
  align-items: center;
  gap: .75rem;
  min-height: 52px;
  padding: .875rem 1.125rem;
  background: transparent;
  color: inherit;
  font-family: var(--font-sans);
  font-size: 1rem;
  font-weight: 700;
  letter-spacing: 0;
  line-height: 1.5;
  list-style: none;
  cursor: pointer;
  user-select: none;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-accordion > details > summary::-webkit-details-marker,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-disclosure-summary::-webkit-details-marker {
  display: none;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-accordion > details > summary:hover,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-disclosure-summary:hover {
  background: var(--nb-paper-soft);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-accordion > details > summary:focus-visible,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-disclosure-summary:focus-visible {
  outline-offset: -4px;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-accordion-title {
  flex: 1;
  min-width: 0;
  overflow-wrap: anywhere;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-accordion-category {
  padding: .125rem .375rem;
  background: var(--nb-accent);
  color: var(--nb-on-accent);
  border: var(--nb-border-thin) solid var(--nb-line);
  border-radius: var(--nb-radius-tight);
  font-size: .75rem;
  font-weight: 700;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-accordion-content {
  padding: 0 1.125rem 1.125rem;
  color: var(--nb-surface-foreground);
  font-size: .9375rem;
  line-height: 1.65;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-disclosure-content {
  color: var(--nb-surface-foreground);
  line-height: 1.65;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-disclosure-chevron,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-accordion .faq-chevron {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  flex: 0 0 24px;
  width: 24px;
  height: 24px;
  background: transparent;
  border: 0;
  color: inherit;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-disclosure[open] > summary > .neubrutalism-disclosure-chevron,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-accordion > details[open] > summary > .faq-chevron {
  transform: rotate(180deg);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-empty-state-icon {
  filter: none !important;
  color: var(--nb-accent) !important;
  background: var(--nb-paper-soft) !important;
  border: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  box-shadow: var(--nb-shadow-sm) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-empty-state-card {
  box-shadow: var(--nb-shadow-md) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-empty-state-title {
  font-family: var(--font-heading) !important;
  font-weight: 900 !important;
  letter-spacing: -0.01em !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-skeleton {
  animation: none !important;
  background-image: none !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-skeleton.animate {
  background-image: none !important;
  animation: none !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-toolbar,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-button-panel,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-button-group {
  padding: 0.5rem !important;
  gap: 0.5rem !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-cycle-button {
  background: var(--nb-paper) !important;
  background-image: none !important;
  border: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  box-shadow: var(--nb-shadow-xs) !important;
  color: var(--foreground) !important;
  font-family: var(--font-heading);
  font-weight: 800;
  transition: transform var(--nb-transition), box-shadow var(--nb-transition);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-cycle-button:hover:not(:disabled) {
  transform: translate(-1px, -1px);
  box-shadow: var(--nb-shadow-sm) !important;
  background: var(--nb-accent) !important;
  color: var(--nb-on-accent) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-cycle-button:active:not(:disabled) {
  transform: var(--nb-translate-press);
  box-shadow: var(--nb-shadow-xs) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-spec-row,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-static-table-row,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-data-table-row {
  border-bottom: var(--nb-border-thin) solid var(--nb-line) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-static-table-row:last-child,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-data-table-row:last-child {
  border-bottom: none !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-static-table thead,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-data-table-header {
  background: var(--nb-accent) !important;
  color: var(--nb-on-accent) !important;
  font-family: var(--font-heading);
  font-weight: 800;
  border-bottom: var(--nb-border-base) solid var(--nb-line) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-data-table-row.selected > td {
  color: inherit !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-fade-edge,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-scroll-shadow {
  display: none !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-scroll-area {
  box-sizing: border-box;
  min-width: 0;
  max-width: 100%;
  padding: 1rem;
  scrollbar-gutter: stable;
  overflow: auto;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-scroll-rail {
  box-sizing: border-box;
  min-width: 0;
  max-width: 100%;
  scrollbar-gutter: stable;
  border-radius: var(--nb-radius-tight);
  background: var(--nb-paper) !important;
  border: var(--nb-border-base) solid var(--nb-line) !important;
  scrollbar-color: var(--nb-line) transparent;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-scroll-rail > div {
  box-sizing: border-box;
  min-width: 0;
  overflow-wrap: anywhere;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-scroll-rail-content {
  padding: 1rem;
  overflow-wrap: anywhere;
  overflow-y: auto;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-slot-counter,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-slot-counter-card {
  box-sizing: border-box;
  min-width: 0;
  max-width: 100%;
  padding: 1rem;
  text-align: center;
  overflow-wrap: anywhere;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-slot-counter > div {
  max-width: 100%;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-slot-counter-row > .neubrutalism-slot-counter {
  flex: 1 1 9rem;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-slot-counter-card > .neubrutalism-slot-counter {
  width: 100%;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-toast-container {
  max-width: calc(100% - var(--nb-toast-offset, 20px) - var(--nb-toast-offset, 20px));
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-toast-container > div {
  min-width: 0;
  max-width: 100%;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-toast:not([data-arcane-decorated]) {
  background: var(--nb-paper) !important;
  background-image: none !important;
  border: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  box-shadow: var(--nb-shadow-md) !important;
  color: var(--foreground) !important;
  font-weight: 400;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-toast[data-variant="success"]:not([data-arcane-decorated]) { background: var(--success) !important; color: var(--success-foreground) !important; }
#arcane-root.arcane-theme-neubrutalism .neubrutalism-toast[data-variant="warning"]:not([data-arcane-decorated]) { background: var(--warning) !important; color: var(--warning-foreground) !important; }
#arcane-root.arcane-theme-neubrutalism .neubrutalism-toast[data-variant="error"]:not([data-arcane-decorated]) { background: #FF6B6B !important; color: #000000 !important; }
#arcane-root.arcane-theme-neubrutalism .neubrutalism-toast[data-variant="info"]:not([data-arcane-decorated]) { background: var(--info) !important; color: var(--info-foreground) !important; }

#arcane-root.arcane-theme-neubrutalism .neubrutalism-toast :is(.neubrutalism-toast-title, .neubrutalism-toast-message, .neubrutalism-toast-description, .neubrutalism-toast-icon, .neubrutalism-toast-dismiss) {
  color: inherit !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-toast-title {
  font-weight: 700 !important;
  letter-spacing: 0 !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-otp-digit {
  font-family: var(--font-mono) !important;
  font-weight: 800 !important;
  text-align: center;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-otp-digit:focus {
  background: var(--nb-paper-soft) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-otp-digit[data-state="filled"] {
  background: var(--nb-accent) !important;
  color: var(--nb-on-accent) !important;
  border-color: var(--nb-line) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-otp-digit.error {
  border-color: var(--destructive) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-otp-input[data-state="error"] > span:last-child {
  color: var(--nb-error-foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-floating,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-popover,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-tooltip {
  background-image: none !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-tooltip {
  border-radius: var(--nb-radius-soft) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-progress-track {
  position: relative;
  overflow: hidden;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-progress-fill {
  background-image: none !important;
  background-color: var(--nb-accent) !important;
  background-blend-mode: normal;
  transition: width var(--nb-transition);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-checkbox[data-state="checked"]::after,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-checkbox[data-state="indeterminate"]::after {
  color: var(--nb-on-accent) !important;
  text-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-radio-option[data-state="checked"] .neubrutalism-radio-circle > div {
  background: var(--nb-on-accent-hot) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-avatar-inner {
  background-image: none !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-avatar-inner.rounded-full {
  border-radius: 50% !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-image,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-image img {
  border-radius: var(--nb-radius-soft);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-image-frame {
  border: var(--nb-border-base) solid var(--nb-line);
  border-radius: var(--nb-radius-soft);
  box-shadow: var(--nb-shadow-md);
  overflow: hidden;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-code-snippet,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-code {
  background: var(--nb-paper) !important;
  background-image: none !important;
  border: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  box-shadow: var(--nb-shadow-sm) !important;
  font-family: var(--font-mono) !important;
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-file-upload {
  background: var(--nb-paper) !important;
  background-image: none !important;
  border: var(--nb-border-base) dashed var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  color: var(--foreground) !important;
  transition: transform var(--nb-transition), box-shadow var(--nb-transition);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-file-upload:hover,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-file-upload[data-dragging="true"] {
  border-color: var(--nb-accent) !important;
  background-color: var(--nb-paper-soft) !important;
  transform: translate(-1px, -1px);
  box-shadow: var(--nb-shadow-sm) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-flexi-card {
  background: var(--nb-paper) !important;
  background-image: none !important;
  border: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  box-shadow: var(--nb-shadow-md) !important;
  color: var(--foreground) !important;
  transition: transform var(--nb-transition), box-shadow var(--nb-transition);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-flexi-card:hover {
  transform: translate(-2px, -2px);
  box-shadow: var(--nb-shadow-lg) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-item {
  background: var(--nb-paper) !important;
  background-image: none !important;
  border: var(--nb-border-thin) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-item.clickable:hover {
  background: var(--nb-paper-soft) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-item.selected {
  background: var(--nb-accent) !important;
  color: var(--nb-on-accent) !important;
  border-color: var(--nb-line) !important;
  box-shadow: var(--nb-shadow-xs) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-chart {
  background: var(--nb-paper) !important;
  background-image: none !important;
  border: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  box-shadow: var(--nb-shadow-sm) !important;
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-calendar {
  background: var(--nb-paper) !important;
  border: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  box-shadow: var(--nb-shadow-md) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-calendar-day {
  border: var(--nb-border-thin) solid transparent !important;
  border-radius: var(--nb-radius-soft) !important;
  font-weight: 700 !important;
  background-image: none !important;
  transition: transform var(--nb-transition), background-color var(--nb-transition);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-calendar-day:hover:not([data-disabled="true"]) {
  background: var(--nb-paper-soft) !important;
  border-color: var(--nb-line) !important;
  transform: translate(-1px, -1px);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-calendar-day[data-selected="true"] {
  background: var(--nb-accent) !important;
  color: var(--nb-on-accent) !important;
  border-color: var(--nb-line) !important;
  box-shadow: var(--nb-shadow-xs) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-calendar-day[data-today="true"] {
  border-color: var(--nb-accent-hot) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-check-list-item {
  background-image: none !important;
  border: var(--nb-border-thin) solid transparent !important;
  border-radius: var(--nb-radius-soft) !important;
  transition: background-color var(--nb-transition), border-color var(--nb-transition);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-check-list-item:hover {
  background: var(--nb-paper-soft) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-check-list-item.checked {
  background: var(--nb-paper-soft) !important;
  border-color: var(--nb-line) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-tabs-badge {
  background: var(--nb-accent) !important;
  color: var(--nb-on-accent) !important;
  border: var(--nb-border-thin) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  font-weight: 900;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-resizable-handle {
  background: var(--nb-line) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-resizable-handle:hover {
  background: var(--nb-accent) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-breadcrumbs-separator {
  color: var(--foreground) !important;
  font-weight: 900;
  opacity: 0.6;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-breadcrumb-current,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-sidebar-group-label {
  color: var(--foreground) !important;
  font-weight: 700;
}

#arcane-root.arcane-theme-neubrutalism :is(.neubrutalism-top-announcement-bar, .neubrutalism-inline-hero-banner) {
  flex-wrap: wrap;
  gap: .75rem 1rem !important;
}

#arcane-root.arcane-theme-neubrutalism :is(.neubrutalism-top-announcement-bar, .neubrutalism-inline-hero-banner) a {
  color: var(--foreground) !important;
  text-decoration-thickness: 2px !important;
}

#arcane-root.arcane-theme-neubrutalism :is(.neubrutalism-top-announcement-bar, .neubrutalism-inline-hero-banner) button {
  min-width: 36px;
  min-height: 36px;
  font-size: 1.5rem;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-context-menu-item,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-dropdown-item,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-menubar-item,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-select-option,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-command-item {
  background: transparent !important;
  background-image: none !important;
  border: none !important;
  border-radius: var(--nb-radius-soft) !important;
  color: var(--foreground) !important;
  font-weight: 600;
  margin: 2px 4px;
  transition: background-color var(--nb-transition);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-context-menu-item[data-disabled="true"],
#arcane-root.arcane-theme-neubrutalism .neubrutalism-dropdown-item[data-disabled="true"],
#arcane-root.arcane-theme-neubrutalism .neubrutalism-menubar-item[data-disabled="true"],
#arcane-root.arcane-theme-neubrutalism .neubrutalism-select-option[data-disabled="true"] {
  opacity: 0.5;
  cursor: not-allowed;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-dropdown-separator,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-context-menu-separator,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-menubar-separator {
  background: var(--nb-line) !important;
  height: 2px !important;
  margin: 4px 0 !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-confirm-dialog-action[data-variant="primary"],
#arcane-root.arcane-theme-neubrutalism .neubrutalism-dialog-action[data-variant="primary"] {
  background: var(--nb-accent) !important;
  color: var(--nb-on-accent) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-confirm-dialog-action[data-variant="destructive"] {
  background: var(--destructive) !important;
  color: var(--destructive-foreground, var(--nb-paper)) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-drawer-handle {
  background: var(--nb-line) !important;
  border-radius: 1px !important;
  height: 4px !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-drawer-header {
  gap: 12px;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-drawer-header > div,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-drawer-content,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-drawer-footer {
  min-width: 0;
  overflow-wrap: anywhere;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-drawer-content {
  min-height: 0;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-text-input::placeholder,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-textarea::placeholder,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-command-input::placeholder,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-select-search::placeholder,
#arcane-root.arcane-theme-neubrutalism textarea::placeholder {
  color: var(--muted-foreground) !important;
  font-weight: 500;
  opacity: 1;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-textarea[data-error="true"] {
  border-color: var(--destructive) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-textarea:disabled {
  pointer-events: none;
  opacity: 0.5;
  cursor: not-allowed;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-textarea[data-readonly="true"] {
  background-color: var(--nb-control-paper, var(--muted)) !important;
  cursor: default;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-field-label {
  font-family: var(--font-heading);
  font-weight: 800;
  letter-spacing: 0;
  text-transform: none;
  color: var(--foreground);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-field-help,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-field-error,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-field-description {
  font-weight: 600;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-field-error,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-text-input-error,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-textarea-error,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-select-error,
#arcane-root.arcane-theme-neubrutalism .arcane-select-error {
  color: var(--nb-error-foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-form-section {
  padding: 1.25rem !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-spec-row .neubrutalism-spec-label {
  font-family: var(--font-heading);
  font-weight: 800;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  color: var(--foreground);
  opacity: 0.7;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-toast-close,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-dialog-close,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-drawer-close,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-promo-dismiss {
  background: transparent !important;
  border: var(--nb-border-thin) solid transparent !important;
  border-radius: var(--nb-radius-soft) !important;
  color: inherit !important;
  cursor: pointer;
  transition: background-color var(--nb-transition), border-color var(--nb-transition);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-toast-close:hover,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-dialog-close:hover,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-drawer-close:hover,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-promo-dismiss:hover {
  background: var(--nb-paper-soft) !important;
  border-color: var(--nb-line) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-card[data-elevated="true"] {
  box-shadow: var(--nb-shadow-lg) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-loading-spinner,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-circular-progress {
  border-color: var(--nb-line) !important;
  border-right-color: var(--nb-accent) !important;
}

$arcaneSidebarTreeStyles

$arcaneSidebarComponentStyles

$arcaneMapCss

$arcaneTocTreeLinesCss

#arcane-root.arcane-theme-neubrutalism,
#arcane-root.arcane-theme-neubrutalism .kb-page-shell,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-scaffold,
#arcane-root.arcane-theme-neubrutalism .arcane-scaffold-body,
#arcane-root.arcane-theme-neubrutalism .arcane-scaffold-main,
#arcane-root.arcane-theme-neubrutalism .kb-main-area {
  background: var(--background) !important;
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .arcane-scaffold {
  display: block !important;
  min-height: 100vh !important;
  box-sizing: border-box !important;
  padding-top: var(--nb-topbar-height) !important;
  background: var(--background) !important;
  color: var(--foreground) !important;
  clip-path: none !important;
  contain: none !important;
  filter: none !important;
  transform: none !important;
  perspective: none !important;
  backdrop-filter: none !important;
  -webkit-backdrop-filter: none !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-scaffold {
  display: flex !important;
  flex-direction: column !important;
  box-sizing: border-box !important;
  width: 100% !important;
  min-height: 100svh !important;
  padding: 0 !important;
  background: var(--background) !important;
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-layout-body {
  display: flex !important;
  align-items: stretch !important;
  flex: 1 1 auto !important;
  width: 100% !important;
  min-height: calc(100svh - var(--nb-topbar-height)) !important;
  margin: 0 !important;
  padding: 0 !important;
  gap: 0 !important;
  background: var(--background) !important;
  color: var(--foreground) !important;
  overflow: visible !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-layout-body > .kb-main-area {
  flex: 1 1 auto !important;
  min-width: 0 !important;
  width: auto !important;
  margin: 0 !important;
  padding: 0 !important;
  background: var(--background) !important;
  color: var(--foreground) !important;
  overflow: visible !important;
}

#arcane-root.arcane-theme-neubrutalism .arcane-scaffold-body {
  display: block !important;
  grid-template-columns: none !important;
  grid-template-rows: none !important;
  min-height: 0 !important;
  padding: 0 !important;
  gap: 0 !important;
  box-sizing: border-box !important;
  clip-path: none !important;
  contain: none !important;
  filter: none !important;
  transform: none !important;
  perspective: none !important;
  backdrop-filter: none !important;
  -webkit-backdrop-filter: none !important;
}

#arcane-root.arcane-theme-neubrutalism .arcane-scaffold-header {
  position: fixed !important;
  top: 0 !important;
  left: 0 !important;
  right: 0 !important;
  z-index: 80 !important;
  display: flex !important;
  align-items: stretch !important;
  box-sizing: border-box !important;
  height: var(--nb-topbar-height) !important;
  min-height: var(--nb-topbar-height) !important;
  padding: 0 1.25rem !important;
  border: 0 !important;
  border-bottom: var(--nb-border-thick) solid var(--nb-line) !important;
  border-radius: 0 !important;
  background: var(--secondary-background) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar {
  position: sticky !important;
  top: 0 !important;
  z-index: 80 !important;
  display: flex !important;
  align-items: stretch !important;
  box-sizing: border-box !important;
  width: 100% !important;
  height: var(--nb-topbar-height) !important;
  min-height: var(--nb-topbar-height) !important;
  padding: 0 1.25rem !important;
  border: 0 !important;
  border-bottom: var(--nb-border-thick) solid var(--nb-line) !important;
  background: var(--background) !important;
  box-shadow: none !important;
  overflow: visible !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar-inner {
  display: flex !important;
  align-items: center !important;
  box-sizing: border-box !important;
  width: 100% !important;
  max-width: none !important;
  height: var(--nb-topbar-height) !important;
  min-height: var(--nb-topbar-height) !important;
  margin: 0 !important;
  padding: 0 !important;
  gap: 0.75rem !important;
  border: 0 !important;
  border-radius: 0 !important;
  background: transparent !important;
  box-shadow: none !important;
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar-left,
#arcane-root.arcane-theme-neubrutalism .kb-topbar-right,
#arcane-root.arcane-theme-neubrutalism .kb-topbar-nav,
#arcane-root.arcane-theme-neubrutalism .kb-style-switcher {
  display: flex !important;
  gap: 0.55rem !important;
  align-items: center !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar-left {
  min-width: 0 !important;
  flex: 1 1 auto !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar-right {
  min-width: 0 !important;
  flex: 0 0 auto !important;
  margin-left: auto !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar-brand {
  display: inline-flex !important;
  align-items: center !important;
  justify-content: flex-start !important;
  gap: 0.45rem !important;
  min-width: 0 !important;
  width: auto !important;
  max-width: min(28vw, 16rem) !important;
  height: 2.45rem !important;
  padding: 0 0.7rem 0 0.5rem !important;
  border: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  background: var(--main) !important;
  color: var(--main-foreground) !important;
  box-shadow: none !important;
  text-decoration: none !important;
  font-family: var(--font-heading) !important;
  font-weight: 900 !important;
  font-size: 1.18rem !important;
  line-height: 1 !important;
  transition: transform var(--nb-transition), box-shadow var(--nb-transition);
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar-brand:hover {
  transform: none !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar-brand-icon {
  display: inline-flex !important;
  align-items: center !important;
  justify-content: center !important;
  flex: 0 0 1.65rem !important;
  width: 1.65rem !important;
  height: 1.65rem !important;
  border: 0 !important;
  border-radius: var(--nb-radius-tight) !important;
  background: transparent !important;
  color: currentColor !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar-logo {
  width: 1.45rem !important;
  height: 1.45rem !important;
  object-fit: contain !important;
  border-radius: var(--nb-radius-tight) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar-brand-label {
  display: inline-block !important;
  min-width: 0 !important;
  overflow: hidden !important;
  text-overflow: ellipsis !important;
  white-space: nowrap !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar-link,
#arcane-root.arcane-theme-neubrutalism .kb-topbar-github,
#arcane-root.arcane-theme-neubrutalism .kb-theme-toggle,
#arcane-root.arcane-theme-neubrutalism .kb-stylesheet-select,
#arcane-root.arcane-theme-neubrutalism .kb-palette-select,
#arcane-root.arcane-theme-neubrutalism .kb-hamburger,
#arcane-root.arcane-theme-neubrutalism .kb-search-input {
  box-sizing: border-box !important;
  display: inline-flex !important;
  align-items: center !important;
  justify-content: center !important;
  height: 2.45rem !important;
  border: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  background: var(--secondary-background) !important;
  color: var(--foreground) !important;
  box-shadow: none !important;
  font-weight: 850 !important;
  text-transform: none !important;
  letter-spacing: 0 !important;
  transition:
    transform var(--nb-transition),
    box-shadow var(--nb-transition),
    background-color var(--nb-transition),
    color var(--nb-transition);
}

#arcane-root.dark.arcane-theme-neubrutalism .kb-topbar-link,
#arcane-root.dark.arcane-theme-neubrutalism .kb-topbar-github,
#arcane-root.dark.arcane-theme-neubrutalism .kb-theme-toggle,
#arcane-root.dark.arcane-theme-neubrutalism .kb-stylesheet-select,
#arcane-root.dark.arcane-theme-neubrutalism .kb-palette-select,
#arcane-root.dark.arcane-theme-neubrutalism .kb-hamburger,
#arcane-root.dark.arcane-theme-neubrutalism .kb-search-input,
html.dark #arcane-root.arcane-theme-neubrutalism .kb-topbar-link,
html.dark #arcane-root.arcane-theme-neubrutalism .kb-topbar-github,
html.dark #arcane-root.arcane-theme-neubrutalism .kb-theme-toggle,
html.dark #arcane-root.arcane-theme-neubrutalism .kb-stylesheet-select,
html.dark #arcane-root.arcane-theme-neubrutalism .kb-palette-select,
html.dark #arcane-root.arcane-theme-neubrutalism .kb-hamburger,
html.dark #arcane-root.arcane-theme-neubrutalism .kb-search-input {
  background: var(--secondary-background) !important;
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar-link {
  padding: 0 0.8rem !important;
  text-decoration: none !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar-github,
#arcane-root.arcane-theme-neubrutalism .kb-theme-toggle,
#arcane-root.arcane-theme-neubrutalism .kb-hamburger {
  width: 2.45rem !important;
  padding: 0 !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar .kb-hamburger {
  display: none !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar-link:hover,
#arcane-root.arcane-theme-neubrutalism .kb-topbar-link.active,
#arcane-root.arcane-theme-neubrutalism .kb-topbar-github:hover,
#arcane-root.arcane-theme-neubrutalism .kb-theme-toggle:hover,
#arcane-root.arcane-theme-neubrutalism .kb-stylesheet-select:hover,
#arcane-root.arcane-theme-neubrutalism .kb-palette-select:hover,
#arcane-root.arcane-theme-neubrutalism .kb-hamburger:hover,
#arcane-root.arcane-theme-neubrutalism .kb-search-input:focus {
  transform: none !important;
  box-shadow: none !important;
  background: var(--main) !important;
  color: var(--main-foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-search {
  display: flex !important;
  align-items: center !important;
  min-width: min(16rem, 24vw) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-search-input {
  width: 100% !important;
  padding-left: 2.25rem !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-search-icon {
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .search-results {
  border: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  background: var(--secondary-background) !important;
  color: var(--foreground) !important;
  box-shadow: var(--nb-shadow-lg) !important;
}

#arcane-root.arcane-theme-neubrutalism .arcane-scaffold-sidebar {
  position: fixed !important;
  top: var(--nb-topbar-height) !important;
  left: 0 !important;
  bottom: 0 !important;
  z-index: 60 !important;
  box-sizing: border-box !important;
  width: var(--nb-sidebar-width) !important;
  height: calc(100svh - var(--nb-topbar-height)) !important;
  max-height: calc(100svh - var(--nb-topbar-height)) !important;
  padding: 0 !important;
  border: 0 !important;
  border-right: var(--nb-border-thick) solid var(--nb-line) !important;
  border-radius: 0 !important;
  background: var(--secondary-background) !important;
  box-shadow: none !important;
  overflow-y: auto !important;
  overflow-x: hidden !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-layout-body > .kb-sidebar {
  position: sticky !important;
  top: var(--nb-topbar-height) !important;
  z-index: 60 !important;
  align-self: flex-start !important;
  flex: 0 0 var(--kb-sidebar-width, var(--nb-sidebar-width)) !important;
  box-sizing: border-box !important;
  width: var(--kb-sidebar-width, var(--nb-sidebar-width)) !important;
  min-width: var(--kb-sidebar-width, var(--nb-sidebar-width)) !important;
  max-width: var(--kb-sidebar-width, var(--nb-sidebar-width)) !important;
  height: calc(100svh - var(--nb-topbar-height)) !important;
  max-height: calc(100svh - var(--nb-topbar-height)) !important;
  margin: 0 !important;
  padding: 0 !important;
  border: 0 !important;
  border-right: var(--nb-border-thick) solid var(--nb-line) !important;
  border-radius: 0 !important;
  background: var(--secondary-background) !important;
  box-shadow: none !important;
  overflow-y: auto !important;
  overflow-x: hidden !important;
  transform: none !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-sidebar-panel {
  position: static !important;
  top: auto !important;
  width: 100% !important;
  height: auto !important;
  max-height: none !important;
  min-height: 100% !important;
  padding: 0 !important;
  border: 0 !important;
  border-radius: var(--nb-radius-soft-lg) !important;
  background: transparent !important;
  box-shadow: none !important;
  overflow: visible !important;
}

#arcane-root.arcane-theme-neubrutalism .sidebar-header {
  padding: 0 !important;
  border: 0 !important;
  border-bottom: var(--nb-border-thick) solid var(--nb-line) !important;
  background: var(--secondary-background) !important;
}

#arcane-root.arcane-theme-neubrutalism .sidebar-brand {
  padding: 1rem !important;
  border-bottom: var(--nb-border-thick) solid var(--nb-line) !important;
  background: var(--main) !important;
  color: var(--main-foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .sidebar-brand a,
#arcane-root.arcane-theme-neubrutalism .sidebar-brand-title,
#arcane-root.arcane-theme-neubrutalism .sidebar-brand-subtitle {
  color: inherit !important;
}

#arcane-root.arcane-theme-neubrutalism .sidebar-brand-title {
  font-family: var(--font-heading) !important;
  font-size: 1.05rem !important;
  font-weight: 950 !important;
  line-height: 1 !important;
  letter-spacing: 0 !important;
}

#arcane-root.arcane-theme-neubrutalism .sidebar-brand-subtitle {
  margin-top: 0.45rem !important;
  font-size: 0.78rem !important;
  font-weight: 750 !important;
  opacity: 0.78 !important;
}

#arcane-root.arcane-theme-neubrutalism .sidebar-controls {
  padding: 0.75rem !important;
  gap: 0.55rem !important;
  border: 0 !important;
  background: var(--secondary-background) !important;
}

#arcane-root.arcane-theme-neubrutalism .sidebar-nav {
  padding: 0 !important;
  gap: 0 !important;
  background: transparent !important;
}

#arcane-root.arcane-theme-neubrutalism .sidebar-section,
#arcane-root.arcane-theme-neubrutalism .sidebar-details,
#arcane-root.arcane-theme-neubrutalism .sidebar-tree,
#arcane-root.arcane-theme-neubrutalism .sidebar-tree-item {
  margin: 0 !important;
  padding: 0 !important;
  border: 0 !important;
  border-radius: 0 !important;
  background: transparent !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism .sidebar-section::before,
#arcane-root.arcane-theme-neubrutalism .sidebar-section::after,
#arcane-root.arcane-theme-neubrutalism .sidebar-details::before,
#arcane-root.arcane-theme-neubrutalism .sidebar-details::after,
#arcane-root.arcane-theme-neubrutalism .sidebar-tree::before,
#arcane-root.arcane-theme-neubrutalism .sidebar-tree::after,
#arcane-root.arcane-theme-neubrutalism .sidebar-tree-item::before,
#arcane-root.arcane-theme-neubrutalism .sidebar-tree-item::after,
#arcane-root.arcane-theme-neubrutalism .sidebar-link::before,
#arcane-root.arcane-theme-neubrutalism .sidebar-link::after,
#arcane-root.arcane-theme-neubrutalism .sidebar-summary::before,
#arcane-root.arcane-theme-neubrutalism .sidebar-summary::after {
  content: none !important;
  display: none !important;
}

#arcane-root.arcane-theme-neubrutalism .sidebar-section-header,
#arcane-root.arcane-theme-neubrutalism .sidebar-summary,
#arcane-root.arcane-theme-neubrutalism .sidebar-link {
  position: relative !important;
  display: flex !important;
  align-items: center !important;
  gap: 0.6rem !important;
  min-height: 2.85rem !important;
  width: 100% !important;
  margin: 0 !important;
  border: 0 !important;
  border-bottom: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: 0 !important;
  background: var(--secondary-background) !important;
  color: var(--foreground) !important;
  box-shadow: none !important;
  text-decoration: none !important;
  font-size: 0.9rem !important;
  font-weight: 800 !important;
  line-height: 1.2 !important;
  transition:
    transform var(--nb-transition),
    background-color var(--nb-transition),
    color var(--nb-transition);
}

#arcane-root.arcane-theme-neubrutalism .sidebar-section-header {
  min-height: 3rem !important;
  padding: 0.8rem 1rem !important;
  background: var(--muted) !important;
  color: var(--foreground) !important;
  font-family: var(--font-heading) !important;
  font-size: 0.8rem !important;
  font-weight: 950 !important;
  letter-spacing: 0.03em !important;
  text-transform: uppercase !important;
}

#arcane-root.arcane-theme-neubrutalism .sidebar-summary {
  padding: 0.75rem 0.8rem 0.75rem 1rem !important;
  cursor: pointer !important;
}

#arcane-root.arcane-theme-neubrutalism .sidebar-link {
  padding: 0.75rem 0.8rem 0.75rem 1.2rem !important;
}

#arcane-root.arcane-theme-neubrutalism .sidebar-tree .sidebar-tree .sidebar-summary,
#arcane-root.arcane-theme-neubrutalism .sidebar-tree .sidebar-tree .sidebar-link {
  padding-left: 1.9rem !important;
}

#arcane-root.arcane-theme-neubrutalism .sidebar-tree .sidebar-tree .sidebar-tree .sidebar-summary,
#arcane-root.arcane-theme-neubrutalism .sidebar-tree .sidebar-tree .sidebar-tree .sidebar-link {
  padding-left: 2.55rem !important;
}

#arcane-root.arcane-theme-neubrutalism .sidebar-tree .sidebar-tree .sidebar-tree .sidebar-tree .sidebar-summary,
#arcane-root.arcane-theme-neubrutalism .sidebar-tree .sidebar-tree .sidebar-tree .sidebar-tree .sidebar-link {
  padding-left: 3.2rem !important;
}

#arcane-root.arcane-theme-neubrutalism .sidebar-icon,
#arcane-root.arcane-theme-neubrutalism .sidebar-chevron,
#arcane-root.arcane-theme-neubrutalism .sidebar-chevron-icon {
  color: currentColor !important;
  opacity: 1 !important;
}

#arcane-root.arcane-theme-neubrutalism .sidebar-link:hover,
#arcane-root.arcane-theme-neubrutalism .sidebar-summary:hover,
#arcane-root.arcane-theme-neubrutalism .sidebar-link.active {
  transform: translate(2px, 2px) !important;
  background: var(--main) !important;
  color: var(--main-foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-sidebar > .sidebar-header {
  padding: 1rem !important;
  border: 0 !important;
  background: transparent !important;
  font-family: var(--font-sans);
  font-weight: 800;
  line-height: 1.4;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-sidebar > .sidebar-nav {
  padding: 0 0.75rem 0.75rem !important;
  gap: 0.75rem !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-sidebar .neubrutalism-sidebar-expanded-only {
  padding: 0 0.25rem 0.25rem;
  color: var(--muted-foreground);
  font-size: 0.875rem;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-sidebar-group {
  gap: 0.375rem !important;
  margin-bottom: 0 !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-sidebar-group-label,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-sidebar .sidebar-section-header {
  min-height: 0 !important;
  padding: 0.25rem 0.375rem 0.375rem !important;
  border: 0 !important;
  background: transparent !important;
  font-family: var(--font-sans) !important;
  font-size: 0.75rem !important;
  font-weight: 700 !important;
  line-height: 1.4 !important;
  letter-spacing: 0.06em !important;
  opacity: 1;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-sidebar :is(.sidebar-section, .sidebar-tree) {
  display: flex;
  flex-direction: column;
  gap: 0.375rem;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-sidebar .sidebar-details[open] > .sidebar-tree {
  padding-top: 0.375rem !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-sidebar :is(.sidebar-link, .sidebar-summary) {
  min-height: 44px !important;
  padding: 0.625rem 0.75rem !important;
  border: var(--nb-border-thin) solid transparent !important;
  border-radius: var(--nb-radius-tight) !important;
  background: transparent !important;
  font-size: 0.9375rem !important;
  line-height: 1.4 !important;
  transform: none !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-sidebar :is(.sidebar-link.active, .sidebar-link:hover, .sidebar-summary:hover) {
  border-color: var(--nb-line) !important;
  background: var(--nb-accent) !important;
  color: var(--nb-on-accent) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-sidebar .neubrutalism-sidebar-separator {
  flex-shrink: 0;
  margin: 0 0.375rem !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-sidebar-footer {
  padding: 0.75rem 1rem 1rem !important;
  gap: 0.75rem !important;
  font-size: 0.875rem;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-sidebar-collapse {
  min-height: 44px;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-sidebar.collapsed > :is(.sidebar-header, .sidebar-nav, .neubrutalism-sidebar-footer) {
  padding-inline: 7px !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-sidebar.collapsed .neubrutalism-sidebar-collapse {
  padding-inline: 0 !important;
}

#arcane-root.arcane-theme-neubrutalism .sidebar-link.active {
  box-shadow: inset -6px 0 0 var(--nb-line) !important;
  font-weight: 950 !important;
}

#arcane-root.arcane-theme-neubrutalism .arcane-scaffold-secondary {
  position: fixed !important;
  top: var(--nb-topbar-height) !important;
  right: 0 !important;
  bottom: 0 !important;
  left: auto !important;
  z-index: 55 !important;
  box-sizing: border-box !important;
  width: var(--nb-toc-width) !important;
  height: calc(100svh - var(--nb-topbar-height)) !important;
  max-height: calc(100svh - var(--nb-topbar-height)) !important;
  margin: 0 !important;
  padding: 0 !important;
  border: 0 !important;
  border-left: var(--nb-border-thick) solid var(--nb-line) !important;
  border-radius: 0 !important;
  clip-path: none !important;
  contain: none !important;
  background: var(--secondary-background) !important;
  background-image: none !important;
  box-shadow: none !important;
  filter: none !important;
  transform: none !important;
  perspective: none !important;
  backdrop-filter: none !important;
  -webkit-backdrop-filter: none !important;
  overflow-y: auto !important;
  overflow-x: hidden !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-toc-panel {
  position: sticky !important;
  top: var(--nb-topbar-height) !important;
  right: auto !important;
  bottom: auto !important;
  left: auto !important;
  z-index: 10 !important;
  box-sizing: border-box !important;
  align-self: start !important;
  justify-self: stretch !important;
  width: var(--nb-toc-width) !important;
  height: auto !important;
  max-height: calc(100svh - var(--nb-topbar-height)) !important;
  margin: clamp(-4.5rem, -5vw, -2.5rem) 0 0 !important;
  padding: 0 !important;
  border: 0 !important;
  border-radius: 0 !important;
  clip-path: none !important;
  contain: none !important;
  background: transparent !important;
  background-image: none !important;
  box-shadow: none !important;
  filter: none !important;
  transform: none !important;
  perspective: none !important;
  backdrop-filter: none !important;
  -webkit-backdrop-filter: none !important;
  overflow-y: visible !important;
  overflow-x: hidden !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc {
  width: 100% !important;
  max-height: calc(100svh - var(--nb-topbar-height) - 1rem) !important;
  padding: 0 !important;
  border: var(--nb-border-thick) solid var(--nb-line) !important;
  border-radius: 0 !important;
  background: var(--secondary-background) !important;
  color: var(--foreground) !important;
  box-shadow: var(--nb-shadow-sm) !important;
  overflow-y: auto !important;
  overflow-x: hidden !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc::before,
#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc::after,
#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-title::before,
#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-title::after {
  content: none !important;
  display: none !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-title {
  display: block !important;
  box-sizing: border-box !important;
  width: 100% !important;
  margin: 0 !important;
  padding: 0.95rem 1rem !important;
  border: 0 !important;
  border-bottom: var(--nb-border-thick) solid var(--nb-line) !important;
  border-radius: 0 !important;
  background: var(--muted) !important;
  color: var(--foreground) !important;
  box-shadow: none !important;
  font-family: var(--font-heading) !important;
  font-size: 1.05rem !important;
  font-weight: 950 !important;
  letter-spacing: 0 !important;
  text-transform: none !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-content {
  display: block !important;
  box-sizing: border-box !important;
  width: 100% !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-content > ul,
#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-content ul,
#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-content li {
  margin: 0 !important;
  padding: 0 !important;
  list-style: none !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-content li::before,
#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-content li::after,
#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-content a::before,
#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-content a::after {
  content: none !important;
  display: none !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-content a {
  display: block !important;
  margin: 0 !important;
  padding: 0.72rem 1rem !important;
  border: 0 !important;
  border-top: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: 0 !important;
  background: var(--secondary-background) !important;
  color: var(--foreground) !important;
  box-shadow: none !important;
  font-size: 0.82rem !important;
  font-weight: 800 !important;
  line-height: 1.25 !important;
  text-decoration: none !important;
  transition:
    transform var(--nb-transition),
    background-color var(--nb-transition),
    color var(--nb-transition);
}

#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-content ul ul a {
  padding-left: 1.65rem !important;
  font-size: 0.78rem !important;
  opacity: 1 !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-content ul ul ul a {
  padding-left: 2.3rem !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-content a:hover,
#arcane-root.arcane-theme-neubrutalism .kb-toc-panel .toc-content a.toc-active {
  transform: translate(2px, 2px) !important;
  background: var(--main) !important;
  color: var(--main-foreground) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism .arcane-scaffold-main {
  position: relative !important;
  margin-left: 0 !important;
  margin-right: 0 !important;
  padding: 0 !important;
  border: 0 !important;
  border-radius: 0 !important;
  clip-path: none !important;
  contain: none !important;
  background: var(--background) !important;
  background-image: none !important;
  background-size: auto !important;
  box-shadow: none !important;
  backdrop-filter: none !important;
  -webkit-backdrop-filter: none !important;
  filter: none !important;
  transform: none !important;
  perspective: none !important;
  overflow: visible !important;
}

#arcane-root.arcane-theme-neubrutalism:has(.kb-sidebar) .arcane-scaffold-main {
  margin-left: var(--nb-sidebar-width) !important;
}

#arcane-root.arcane-theme-neubrutalism:has(.kb-toc-panel) .arcane-scaffold-main {
  margin-right: 0 !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-content-area {
  display: grid !important;
  grid-template-columns: minmax(0, 1fr) var(--nb-toc-width) !important;
  align-items: start !important;
  width: 100% !important;
  max-width: none !important;
  margin: 0 !important;
  padding: clamp(2.5rem, 5vw, 4.5rem) 0 clamp(2.5rem, 5vw, 4.5rem) clamp(1.25rem, 4vw, 3.5rem) !important;
  gap: clamp(1rem, 3vw, 2.5rem) !important;
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-article-panel {
  justify-self: center !important;
  width: min(100%, 760px) !important;
  max-width: 760px !important;
  margin: 0 auto !important;
  padding: 0 !important;
  border: 0 !important;
  border-radius: var(--nb-radius-soft-lg) !important;
  background: transparent !important;
  box-shadow: none !important;
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-page-metadata,
#arcane-root.arcane-theme-neubrutalism .kb-tags-footer,
#arcane-root.arcane-theme-neubrutalism .kb-page-nav,
#arcane-root.arcane-theme-neubrutalism .kb-code-group,
#arcane-root.arcane-theme-neubrutalism .arcane-demo-preview-scope,
#arcane-root.arcane-theme-neubrutalism .kb-callout {
  border: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  background: var(--secondary-background) !important;
  color: var(--foreground) !important;
  box-shadow: var(--nb-shadow-md) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-page-metadata,
#arcane-root.arcane-theme-neubrutalism .kb-tags-footer {
  padding: 0.85rem 1rem !important;
}

#arcane-root.arcane-theme-neubrutalism .arcane-demo-panel {
  width: 100% !important;
  padding: 1.25rem !important;
  border: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  background: var(--secondary-background) !important;
  color: var(--foreground) !important;
  box-shadow: var(--nb-shadow-md) !important;
}

#arcane-root.arcane-theme-neubrutalism .arcane-demo-kicker {
  display: inline-flex !important;
  width: auto !important;
  margin: -1.25rem 0 1rem -1.25rem !important;
  padding: 0.625rem 1rem !important;
  border-right: var(--nb-border-base) solid var(--nb-line) !important;
  border-bottom: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: 0 !important;
  background: color-mix(in srgb, var(--nb-accent) 24%, var(--secondary-background)) !important;
  color: var(--foreground) !important;
  font-family: var(--font-heading) !important;
  font-weight: 900 !important;
}

#arcane-root.arcane-theme-neubrutalism .arcane-demo-section-title,
#arcane-root.arcane-theme-neubrutalism .arcane-demo-code-label {
  color: var(--foreground) !important;
  font-family: var(--font-heading) !important;
  font-weight: 900 !important;
}

#arcane-root.arcane-theme-neubrutalism .arcane-demo-code {
  margin: 1rem 0 0 !important;
  border: 0 !important;
  border-top: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: 0 !important;
  background: var(--secondary-background) !important;
  color: var(--foreground) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism .arcane-demo-preview-scope {
  box-sizing: border-box !important;
  display: flex !important;
  align-items: center !important;
  justify-content: center !important;
  width: 100% !important;
  min-height: clamp(220px, 28vw, 360px) !important;
  padding: 1.25rem !important;
  overflow: visible !important;
  background: var(--secondary-background) !important;
}

#arcane-root.arcane-theme-neubrutalism .arcane-demo-preview-scope > .arcane-box {
  height: auto !important;
  min-height: 0 !important;
}

#arcane-root.arcane-theme-neubrutalism .arcane-demo-preview-scope > * {
  max-width: 100% !important;
}

#arcane-root.arcane-theme-neubrutalism .arcane-demo-missing {
  border: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  background: var(--secondary-background) !important;
  color: var(--foreground) !important;
  box-shadow: var(--nb-shadow-sm) !important;
}

#arcane-root.arcane-theme-neubrutalism .arcane-demo-missing-icon {
  border: var(--nb-border-thin) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  background: var(--main) !important;
  color: var(--main-foreground) !important;
  box-shadow: var(--nb-shadow-xs) !important;
}

#arcane-root.arcane-theme-neubrutalism .arcane-demo-missing-title {
  color: var(--foreground) !important;
  font-family: var(--font-heading) !important;
  font-weight: 900 !important;
}

#arcane-root.arcane-theme-neubrutalism .arcane-demo-missing-body {
  color: color-mix(in srgb, var(--foreground) 72%, var(--background)) !important;
  font-weight: 700 !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-page-nav {
  overflow: visible !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-page-nav-link {
  border: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  background: var(--secondary-background) !important;
  color: var(--foreground) !important;
  box-shadow: var(--nb-shadow-sm) !important;
  text-decoration: none !important;
  transition: transform var(--nb-transition), box-shadow var(--nb-transition);
}

#arcane-root.arcane-theme-neubrutalism .kb-page-nav-link:hover {
  transform: var(--nb-translate-press-md) !important;
  background: var(--main) !important;
  color: var(--main-foreground) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism .prose {
  color: var(--foreground) !important;
  font-size: 1rem !important;
  line-height: 1.72 !important;
}

#arcane-root.arcane-theme-neubrutalism .prose p,
#arcane-root.arcane-theme-neubrutalism .prose li,
#arcane-root.arcane-theme-neubrutalism .prose ul,
#arcane-root.arcane-theme-neubrutalism .prose ol,
#arcane-root.arcane-theme-neubrutalism .prose li > span,
#arcane-root.arcane-theme-neubrutalism .prose li > div {
  color: var(--foreground) !important;
  opacity: 1 !important;
}

#arcane-root.arcane-theme-neubrutalism .prose > .content > p,
#arcane-root.arcane-theme-neubrutalism .prose > .content > ul,
#arcane-root.arcane-theme-neubrutalism .prose > .content > ol,
#arcane-root.arcane-theme-neubrutalism .prose > .content > ul > li,
#arcane-root.arcane-theme-neubrutalism .prose > .content > ol > li {
  color: var(--foreground) !important;
  opacity: 1 !important;
}

#arcane-root.arcane-theme-neubrutalism .prose li::marker {
  color: color-mix(in srgb, var(--foreground) 72%, transparent) !important;
}

#arcane-root.arcane-theme-neubrutalism .prose h1 {
  font-size: clamp(2.5rem, 7vw, 4.5rem) !important;
  line-height: 0.94 !important;
  letter-spacing: 0 !important;
}

#arcane-root.arcane-theme-neubrutalism .prose h2 {
  border-bottom: var(--nb-border-thick) solid var(--nb-line) !important;
}

#arcane-root.arcane-theme-neubrutalism .prose pre,
#arcane-root.arcane-theme-neubrutalism .kb-code-group-body pre {
  border: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  background: var(--secondary-background) !important;
  color: var(--foreground) !important;
  box-shadow: var(--nb-shadow-md) !important;
  font-family: var(--font-mono) !important;
}

#arcane-root.arcane-theme-neubrutalism .prose pre code,
#arcane-root.arcane-theme-neubrutalism .code-block-wrapper pre,
#arcane-root.arcane-theme-neubrutalism .code-block-wrapper code,
#arcane-root.arcane-theme-neubrutalism .kb-code-group-body pre code,
#arcane-root.arcane-theme-neubrutalism .kb-code-group-body code,
#arcane-root.arcane-theme-neubrutalism .arcane-demo-code,
#arcane-root.arcane-theme-neubrutalism .arcane-demo-code code,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-code-snippet,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-code {
  font-family: var(--font-mono) !important;
}

#arcane-root.arcane-theme-neubrutalism .prose .content > .code-block-wrapper {
  margin: 1.5rem 0 !important;
  border: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  background: var(--secondary-background) !important;
  color: var(--foreground) !important;
  box-shadow: var(--nb-shadow-md) !important;
  overflow: hidden !important;
}

#arcane-root.arcane-theme-neubrutalism .code-block-wrapper > pre {
  margin: 0 !important;
  border: 0 !important;
  border-radius: 0 !important;
  background: transparent !important;
  color: var(--foreground) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-code-group {
  margin: 1.5rem 0 !important;
  overflow: hidden !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-code-group-body {
  padding: 0 !important;
  background: var(--secondary-background) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-code-group-body .code-block-wrapper,
#arcane-root.arcane-theme-neubrutalism .kb-code-group-body pre {
  margin: 0 !important;
  border: 0 !important;
  border-radius: 0 !important;
  background: transparent !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-code-group-body .code-block-wrapper + .code-block-wrapper,
#arcane-root.arcane-theme-neubrutalism .kb-code-group-body pre + pre {
  border-top: var(--nb-border-base) solid var(--nb-line) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-code-group-body .code-block-wrapper > pre,
#arcane-root.arcane-theme-neubrutalism .kb-code-group-body > pre {
  padding: 1rem 3.25rem 1rem 1.25rem !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-code-group-title {
  border-bottom: var(--nb-border-base) solid var(--nb-line) !important;
  background: var(--muted) !important;
  color: var(--foreground) !important;
  font-family: var(--font-heading) !important;
  font-weight: 900 !important;
}

#arcane-root.arcane-theme-neubrutalism .prose table,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-data-table-container,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-static-table-container {
  border: var(--nb-border-base) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  background: var(--secondary-background) !important;
  box-shadow: var(--nb-shadow-md) !important;
}

#arcane-root.arcane-theme-neubrutalism .prose th {
  background: var(--main) !important;
  color: var(--main-foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .markdown-alert {
  border: var(--nb-border-thick) solid var(--kb-alert-accent, var(--nb-line)) !important;
  border-radius: var(--nb-radius-soft) !important;
  background: var(--secondary-background) !important;
  color: var(--foreground) !important;
  box-shadow: var(--nb-shadow-sm) !important;
}

#arcane-root.arcane-theme-neubrutalism .markdown-alert-title {
  color: var(--foreground) !important;
  font-family: var(--font-heading) !important;
  font-weight: 900 !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-callout {
  padding: 1rem 1.1rem !important;
  background: var(--secondary-background) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-callout-title {
  font-family: var(--font-heading) !important;
  font-weight: 900 !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-callout-icon {
  border: var(--nb-border-thin) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  background: var(--main) !important;
  color: var(--main-foreground) !important;
  box-shadow: var(--nb-shadow-xs) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-dropdown-item,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-context-menu-item,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-menubar-item,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-select-option,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-command-item {
  border: var(--nb-border-thin) solid transparent !important;
  border-radius: var(--nb-radius-tight) !important;
  background: transparent !important;
  color: var(--foreground) !important;
  box-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-dropdown-item:hover:not([data-disabled="true"]),
#arcane-root.arcane-theme-neubrutalism .neubrutalism-context-menu-item:hover:not([data-disabled="true"]),
#arcane-root.arcane-theme-neubrutalism .neubrutalism-menubar-item:hover:not([data-disabled="true"]),
#arcane-root.arcane-theme-neubrutalism .neubrutalism-menubar-trigger:hover:not([data-disabled="true"]),
#arcane-root.arcane-theme-neubrutalism .neubrutalism-select-option:hover:not([data-disabled="true"]),
#arcane-root.arcane-theme-neubrutalism .neubrutalism-select-option[aria-selected="true"],
#arcane-root.arcane-theme-neubrutalism .neubrutalism-command-item:hover:not([data-disabled="true"]),
#arcane-root.arcane-theme-neubrutalism .neubrutalism-command-item[data-selected="true"] {
  border-color: var(--nb-line) !important;
  background: var(--muted) !important;
  color: var(--foreground) !important;
  box-shadow: var(--nb-shadow-xs) !important;
  transform: translate(-1px, -1px) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-select-option[aria-selected="true"]::before,
#arcane-root.arcane-theme-neubrutalism .neubrutalism-dropdown-item[aria-checked="true"]::before {
  background: var(--main) !important;
}

@media (max-width: 1280px) {
  #arcane-root.arcane-theme-neubrutalism .arcane-scaffold-secondary,
  #arcane-root.arcane-theme-neubrutalism .kb-toc-panel {
    display: none !important;
  }

  #arcane-root.arcane-theme-neubrutalism .arcane-scaffold-main {
    margin-right: 0 !important;
  }
}

@media (max-width: 900px) {
  #arcane-root.arcane-theme-neubrutalism .arcane-scaffold-header {
    padding: 0 0.75rem !important;
  }

  #arcane-root.arcane-theme-neubrutalism .kb-topbar-brand {
    max-width: min(52vw, 18rem) !important;
  }

  #arcane-root.arcane-theme-neubrutalism .kb-topbar-brand-label {
    overflow: hidden !important;
    text-overflow: ellipsis !important;
  }

  #arcane-root.arcane-theme-neubrutalism .kb-topbar-nav,
  #arcane-root.arcane-theme-neubrutalism .kb-topbar-right .kb-search {
    display: none !important;
  }

  #arcane-root.arcane-theme-neubrutalism .kb-topbar .kb-hamburger {
    display: inline-flex !important;
  }

  #arcane-root.arcane-theme-neubrutalism .arcane-scaffold-sidebar {
    width: min(22rem, 92vw) !important;
    transform: translateX(-105%) !important;
    transition: transform var(--nb-transition) !important;
  }

  #arcane-root.arcane-theme-neubrutalism .kb-layout-body {
    display: block !important;
  }

  #arcane-root.arcane-theme-neubrutalism .kb-layout-body > .kb-sidebar {
    position: fixed !important;
    top: var(--nb-topbar-height) !important;
    left: 0 !important;
    bottom: 0 !important;
    width: min(22rem, 92vw) !important;
    min-width: 0 !important;
    max-width: min(22rem, 92vw) !important;
    height: calc(100svh - var(--nb-topbar-height)) !important;
    max-height: calc(100svh - var(--nb-topbar-height)) !important;
    transform: translateX(-105%) !important;
    transition: transform var(--nb-transition) !important;
  }

  #arcane-root.arcane-theme-neubrutalism .arcane-scaffold-sidebar:has(.kb-sidebar.open),
  #arcane-root.arcane-theme-neubrutalism .arcane-scaffold-sidebar.open,
  #arcane-root.arcane-theme-neubrutalism .kb-sidebar.open {
    transform: translateX(0) !important;
  }

  #arcane-root.arcane-theme-neubrutalism .arcane-scaffold-main {
    margin-left: 0 !important;
    margin-right: 0 !important;
  }

  #arcane-root.arcane-theme-neubrutalism .kb-content-area {
    display: block !important;
    grid-template-columns: none !important;
    padding: 1.35rem 1rem 2.5rem !important;
  }

  #arcane-root.arcane-theme-neubrutalism .kb-article-panel {
    max-width: none !important;
  }
}

#arcane-root.neubrutalism-greyscale {
  --background: #F7F7F7;
  --foreground: #050505;
  --secondary-background: #FFFFFF;
  --card: #FFFFFF;
  --card-foreground: #050505;
  --popover: #FFFFFF;
  --popover-foreground: #050505;
  --muted: #DADADA;
  --muted-foreground: #262626;
  --input: #FFFFFF;
  --main: #111111;
  --main-foreground: #FFFFFF;
  --accent: #111111;
  --accent-foreground: #FFFFFF;
  --nb-accent: #111111;
  --nb-on-background: #000000;
  --nb-on-secondary-background: #000000;
  --nb-on-card: #000000;
  --nb-on-paper: #000000;
  --nb-on-paper-soft: #000000;
  --nb-on-main: #FFFFFF;
  --nb-on-accent: #FFFFFF;
  --nb-paper: #FFFFFF;
  --nb-paper-soft: #E2E2E2;
  --nb-control-paper: #FFFFFF;
  --nb-control-foreground: #050505;
  --nb-surface-foreground: #050505;
  --nb-selection-bg: #DADADA;
  --nb-landing-band-bg: #E2E2E2;
  --nb-on-landing-band: #000000;
}

html.light #arcane-root.neubrutalism-greyscale,
:not(.dark) #arcane-root.neubrutalism-greyscale {
  --background: #F7F7F7;
  --foreground: #050505;
  --secondary-background: #FFFFFF;
  --card: #FFFFFF;
  --card-foreground: #050505;
  --popover: #FFFFFF;
  --popover-foreground: #050505;
  --muted: #DADADA;
  --muted-foreground: #262626;
  --main: #111111;
  --main-foreground: #FFFFFF;
  --accent: #111111;
  --accent-foreground: #FFFFFF;
  --nb-accent: #111111;
  --nb-on-background: #000000;
  --nb-on-secondary-background: #000000;
  --nb-on-card: #000000;
  --nb-on-paper: #000000;
  --nb-on-paper-soft: #000000;
  --nb-on-main: #FFFFFF;
  --nb-on-accent: #FFFFFF;
  --nb-paper: #FFFFFF;
  --nb-paper-soft: #E2E2E2;
  --nb-control-paper: #FFFFFF;
  --nb-control-foreground: #050505;
  --nb-surface-foreground: #050505;
  --nb-selection-bg: #DADADA;
  --nb-landing-band-bg: #E2E2E2;
  --nb-on-landing-band: #000000;
}

html.dark #arcane-root.neubrutalism-greyscale,
#arcane-root.dark.neubrutalism-greyscale {
  --background: #101010;
  --foreground: #F4F4F4;
  --secondary-background: #1A1A1A;
  --card: #1D1D1D;
  --card-foreground: #F4F4F4;
  --card-hover: #292929;
  --popover: #1A1A1A;
  --popover-foreground: #F4F4F4;
  --muted: #292929;
  --muted-foreground: #DADADA;
  --border: #797979;
  --input: #202020;
  --main: #EAEAEA;
  --main-foreground: #000000;
  --accent: #EAEAEA;
  --accent-foreground: #000000;
  --nb-accent: #EAEAEA;
  --nb-dark-inverse-black: var(--foreground);
  --nb-on-dark-inverse-black: #000000;
  --nb-line: var(--nb-line-in, #080808);
  --nb-shadow-color: #080808;
  --nb-on-background: #F4F4F4;
  --nb-on-secondary-background: #F4F4F4;
  --nb-on-card: #F4F4F4;
  --nb-on-paper: #F4F4F4;
  --nb-on-paper-soft: #E2E2E2;
  --nb-on-main: #000000;
  --nb-on-accent: #000000;
  --nb-paper: #1D1D1D;
  --nb-paper-soft: #292929;
  --nb-control-paper: #202020;
  --nb-control-foreground: #F4F4F4;
  --nb-tooltip-foreground: #FFFFFF;
  --nb-surface-foreground: #F4F4F4;
  --nb-selection-bg: #292929;
  --nb-selection-line: var(--nb-control-line);
  --nb-landing-band-bg: #292929;
  --nb-on-landing-band: #F4F4F4;
  --nb-terminal-bg: #080808;
  --nb-terminal-foreground: var(--foreground);
}

html.dark #arcane-root.neubrutalism-greyscale .kb-landing-hero,
#arcane-root.dark.neubrutalism-greyscale .kb-landing-hero {
  color: var(--foreground) !important;
}

html.dark #arcane-root.neubrutalism-greyscale .kb-landing-hero h1,
html.dark #arcane-root.neubrutalism-greyscale .kb-landing-hero p,
html.dark #arcane-root.neubrutalism-greyscale .kb-landing-kicker,
#arcane-root.dark.neubrutalism-greyscale .kb-landing-hero h1,
#arcane-root.dark.neubrutalism-greyscale .kb-landing-hero p,
#arcane-root.dark.neubrutalism-greyscale .kb-landing-kicker {
  color: var(--foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-landing-content-area {
  padding: 1.4rem;
  background: var(--background) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-landing-page {
  max-width: none !important;
  background: var(--background) !important;
  color: var(--nb-on-background) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-landing-prose,
#arcane-root.arcane-theme-neubrutalism .kb-landing-grid {
  background: var(--background) !important;
  color: var(--nb-on-background) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-landing-hero,
#arcane-root.arcane-theme-neubrutalism .kb-landing-card,
#arcane-root.arcane-theme-neubrutalism .kb-landing-band,
#arcane-root.arcane-theme-neubrutalism .kb-landing-terminal,
#arcane-root.arcane-theme-neubrutalism .kb-landing-list-item {
  border: var(--nb-border-base) solid var(--nb-line);
  border-radius: var(--nb-radius-soft-lg);
  box-shadow: 0.55rem 0.55rem 0 var(--nb-shadow-color);
}

#arcane-root.arcane-theme-neubrutalism .kb-landing-hero {
  --nb-local-foreground: var(--nb-on-paper);
  background: var(--nb-paper, var(--primary));
  color: var(--nb-local-foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-landing-hero h1 {
  font-family: var(--font-display);
  font-weight: 800;
  line-height: 1;
  letter-spacing: -0.03em;
}

#arcane-root.arcane-theme-neubrutalism .kb-landing-hero h1,
#arcane-root.arcane-theme-neubrutalism .kb-landing-hero p,
#arcane-root.arcane-theme-neubrutalism .kb-landing-kicker,
#arcane-root.arcane-theme-neubrutalism .kb-landing-card h2,
#arcane-root.arcane-theme-neubrutalism .kb-landing-card p,
#arcane-root.arcane-theme-neubrutalism .kb-landing-card a,
#arcane-root.arcane-theme-neubrutalism .kb-landing-actions a,
#arcane-root.arcane-theme-neubrutalism .kb-landing-band h2,
#arcane-root.arcane-theme-neubrutalism .kb-landing-band p,
#arcane-root.arcane-theme-neubrutalism .kb-landing-list-title,
#arcane-root.arcane-theme-neubrutalism .kb-landing-list-copy,
#arcane-root.arcane-theme-neubrutalism .kb-landing-terminal-value {
  color: var(--nb-local-foreground, var(--foreground)) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-landing-kicker,
#arcane-root.arcane-theme-neubrutalism .kb-landing-actions a,
#arcane-root.arcane-theme-neubrutalism .kb-landing-list-index {
  border: var(--nb-border-base) solid var(--nb-line);
  border-radius: var(--nb-radius-soft);
  box-shadow: 0.25rem 0.25rem 0 var(--nb-shadow-color);
}

#arcane-root.arcane-theme-neubrutalism .kb-landing-kicker,
#arcane-root.arcane-theme-neubrutalism .kb-landing-secondary,
#arcane-root.arcane-theme-neubrutalism .kb-landing-terminal,
#arcane-root.arcane-theme-neubrutalism .kb-landing-card,
#arcane-root.arcane-theme-neubrutalism .kb-landing-list-item {
  --nb-local-foreground: var(--nb-on-paper);
  background: var(--nb-paper);
  color: var(--nb-local-foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-landing-primary,
#arcane-root.arcane-theme-neubrutalism .kb-landing-list-index {
  --nb-local-foreground: var(--nb-on-accent);
  background: var(--nb-accent, var(--primary));
  color: var(--nb-local-foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-landing-band {
  --nb-local-foreground: var(--nb-on-landing-band);
  background: var(--nb-landing-band-bg);
  color: var(--nb-local-foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-landing-terminal-row {
  --nb-local-foreground: var(--nb-terminal-foreground);
  border: var(--nb-border-thin) solid var(--nb-line);
  border-radius: var(--nb-radius-tight);
  background: var(--nb-terminal-bg);
  color: var(--nb-local-foreground) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-landing-terminal-row .kb-landing-terminal-label,
#arcane-root.arcane-theme-neubrutalism .kb-landing-terminal-row .kb-landing-terminal-value {
  color: var(--nb-local-foreground) !important;
}

html.dark #arcane-root.arcane-theme-neubrutalism .kb-landing-hero,
#arcane-root.dark.arcane-theme-neubrutalism .kb-landing-hero {
  background: var(--nb-paper, var(--primary));
}

html.dark #arcane-root.arcane-theme-neubrutalism .kb-landing-card,
html.dark #arcane-root.arcane-theme-neubrutalism .kb-landing-list-item,
html.dark #arcane-root.arcane-theme-neubrutalism .kb-landing-secondary,
#arcane-root.dark.arcane-theme-neubrutalism .kb-landing-card,
#arcane-root.dark.arcane-theme-neubrutalism .kb-landing-list-item,
#arcane-root.dark.arcane-theme-neubrutalism .kb-landing-secondary {
  --nb-local-foreground: var(--nb-on-paper);
  background: var(--nb-paper);
  color: var(--nb-local-foreground) !important;
}

html.dark #arcane-root.arcane-theme-neubrutalism .kb-landing-grid,
#arcane-root.dark.arcane-theme-neubrutalism .kb-landing-grid {
  gap: clamp(1.45rem, 2.4vw, 2rem);
  margin-top: 1.35rem;
  margin-bottom: 1.5rem;
  padding-right: 0.45rem;
  padding-bottom: 0.55rem;
}

html.dark #arcane-root.arcane-theme-neubrutalism .kb-landing-band,
#arcane-root.dark.arcane-theme-neubrutalism .kb-landing-band {
  gap: clamp(1.5rem, 2.8vw, 2.15rem);
  margin-top: 1.35rem;
}

html.dark #arcane-root.arcane-theme-neubrutalism .kb-landing-list,
#arcane-root.dark.arcane-theme-neubrutalism .kb-landing-list {
  gap: 1.15rem;
}

html.dark #arcane-root.arcane-theme-neubrutalism .kb-landing-hero,
html.dark #arcane-root.arcane-theme-neubrutalism .kb-landing-card,
html.dark #arcane-root.arcane-theme-neubrutalism .kb-landing-band,
html.dark #arcane-root.arcane-theme-neubrutalism .kb-landing-terminal,
html.dark #arcane-root.arcane-theme-neubrutalism .kb-landing-list-item,
#arcane-root.dark.arcane-theme-neubrutalism .kb-landing-hero,
#arcane-root.dark.arcane-theme-neubrutalism .kb-landing-card,
#arcane-root.dark.arcane-theme-neubrutalism .kb-landing-band,
#arcane-root.dark.arcane-theme-neubrutalism .kb-landing-terminal,
#arcane-root.dark.arcane-theme-neubrutalism .kb-landing-list-item {
  box-shadow: 0.3rem 0.3rem 0 var(--nb-shadow-color);
}

html.dark #arcane-root.arcane-theme-neubrutalism .kb-landing-kicker,
html.dark #arcane-root.arcane-theme-neubrutalism .kb-landing-actions a,
html.dark #arcane-root.arcane-theme-neubrutalism .kb-landing-list-index,
#arcane-root.dark.arcane-theme-neubrutalism .kb-landing-kicker,
#arcane-root.dark.arcane-theme-neubrutalism .kb-landing-actions a,
#arcane-root.dark.arcane-theme-neubrutalism .kb-landing-list-index {
  box-shadow: 0.16rem 0.16rem 0 var(--nb-shadow-color);
}

#arcane-root.arcane-theme-neubrutalism .arcane-scaffold-header,
#arcane-root.arcane-theme-neubrutalism .kb-topbar,
#arcane-root.arcane-theme-neubrutalism .kb-topbar-inner,
html.dark #arcane-root.arcane-theme-neubrutalism .arcane-scaffold-header,
html.dark #arcane-root.arcane-theme-neubrutalism .kb-topbar,
html.dark #arcane-root.arcane-theme-neubrutalism .kb-topbar-inner,
#arcane-root.dark.arcane-theme-neubrutalism .arcane-scaffold-header,
#arcane-root.dark.arcane-theme-neubrutalism .kb-topbar,
#arcane-root.dark.arcane-theme-neubrutalism .kb-topbar-inner {
  box-shadow: none !important;
  filter: none !important;
  text-shadow: none !important;
}

#arcane-root.arcane-theme-neubrutalism .arcane-scaffold-header::before,
#arcane-root.arcane-theme-neubrutalism .arcane-scaffold-header::after,
#arcane-root.arcane-theme-neubrutalism .kb-topbar::before,
#arcane-root.arcane-theme-neubrutalism .kb-topbar::after,
#arcane-root.arcane-theme-neubrutalism .kb-topbar-inner::before,
#arcane-root.arcane-theme-neubrutalism .kb-topbar-inner::after {
  content: none !important;
  display: none !important;
}

#arcane-root.arcane-theme-neubrutalism .arcane-scaffold-header,
#arcane-root.arcane-theme-neubrutalism .kb-topbar,
html.dark #arcane-root.arcane-theme-neubrutalism .arcane-scaffold-header,
html.dark #arcane-root.arcane-theme-neubrutalism .kb-topbar,
#arcane-root.dark.arcane-theme-neubrutalism .arcane-scaffold-header,
#arcane-root.dark.arcane-theme-neubrutalism .kb-topbar {
  border: 0 !important;
  border-bottom: var(--nb-border-thick) solid var(--nb-line) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar-inner,
html.dark #arcane-root.arcane-theme-neubrutalism .kb-topbar-inner,
#arcane-root.dark.arcane-theme-neubrutalism .kb-topbar-inner {
  border: 0 !important;
  background: transparent !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar-brand,
#arcane-root.arcane-theme-neubrutalism .kb-topbar-link,
#arcane-root.arcane-theme-neubrutalism .kb-topbar-github,
#arcane-root.arcane-theme-neubrutalism .kb-theme-toggle,
#arcane-root.arcane-theme-neubrutalism .kb-stylesheet-select,
#arcane-root.arcane-theme-neubrutalism .kb-palette-select,
#arcane-root.arcane-theme-neubrutalism .kb-hamburger,
#arcane-root.arcane-theme-neubrutalism .kb-search-input {
  box-shadow: var(--nb-shadow-sm) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar-brand:hover,
#arcane-root.arcane-theme-neubrutalism .kb-topbar-link:hover,
#arcane-root.arcane-theme-neubrutalism .kb-topbar-link.active,
#arcane-root.arcane-theme-neubrutalism .kb-topbar-github:hover,
#arcane-root.arcane-theme-neubrutalism .kb-theme-toggle:hover,
#arcane-root.arcane-theme-neubrutalism .kb-stylesheet-select:hover,
#arcane-root.arcane-theme-neubrutalism .kb-palette-select:hover,
#arcane-root.arcane-theme-neubrutalism .kb-hamburger:hover,
#arcane-root.arcane-theme-neubrutalism .kb-search-input:focus {
  transform: translate(-1px, -1px) !important;
  box-shadow: var(--nb-shadow-md) !important;
}

#arcane-root.arcane-theme-neubrutalism .kb-topbar-brand:active,
#arcane-root.arcane-theme-neubrutalism .kb-topbar-link:active,
#arcane-root.arcane-theme-neubrutalism .kb-topbar-github:active,
#arcane-root.arcane-theme-neubrutalism .kb-theme-toggle:active,
#arcane-root.arcane-theme-neubrutalism .kb-stylesheet-select:active,
#arcane-root.arcane-theme-neubrutalism .kb-palette-select:active,
#arcane-root.arcane-theme-neubrutalism .kb-hamburger:active,
#arcane-root.arcane-theme-neubrutalism .kb-search-input:active {
  transform: var(--nb-translate-press) !important;
  box-shadow: var(--nb-shadow-xs) !important;
}

#arcane-root.arcane-theme-neubrutalism .arcane-mega-menu-trigger {
  min-height: 44px;
  font-family: var(--font-control) !important;
  font-weight: 700 !important;
  color: var(--foreground) !important;
  background: var(--nb-paper) !important;
  border: var(--nb-border-thin) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft);
  box-shadow: var(--nb-shadow-xs);
}

#arcane-root.arcane-theme-neubrutalism .arcane-mega-menu-panel {
  color: var(--foreground);
  font-family: var(--font-body);
  background: var(--nb-paper) !important;
  border: var(--nb-border-thick) solid var(--nb-line) !important;
  border-radius: var(--nb-radius-soft) !important;
  box-shadow: var(--nb-shadow-md) !important;
  gap: 1rem !important;
  z-index: 1000 !important;
}

#arcane-root.arcane-theme-neubrutalism .arcane-mega-menu-item {
  min-height: 44px;
  font-family: var(--font-control);
  color: var(--foreground);
  border-radius: var(--nb-radius-soft) !important;
}

#arcane-root.arcane-theme-neubrutalism .arcane-mega-menu-item:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

#arcane-root.arcane-theme-neubrutalism :is(
  .arcane-mega-menu-trigger, .arcane-mega-menu-item,
  .neubrutalism-menubar-trigger, .neubrutalism-menubar-item
):focus {
  outline: 3px solid var(--nb-line) !important;
  outline-offset: 2px;
}

#arcane-root.arcane-theme-neubrutalism .arcane-mega-menu-item:hover:not(:disabled),
#arcane-root.arcane-theme-neubrutalism .neubrutalism-menubar-item:focus {
  background: var(--nb-selection-bg) !important;
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-menubar-content {
  overflow-wrap: anywhere;
}

#arcane-root.arcane-theme-neubrutalism :is(.neubrutalism-menubar, .neubrutalism-flexi-card-simple):not([data-arcane-decorated]) {
  border-radius: var(--nb-radius-soft);
}

#arcane-root.arcane-theme-neubrutalism .neubrutalism-resizable-grip {
  border-radius: var(--nb-radius-tight);
}

@media (prefers-reduced-motion: no-preference) {
  #arcane-root.arcane-theme-neubrutalism .arcane-mega-menu-panel {
    --nb-enter-x: 0px;
    --nb-enter-y: calc(-1 * var(--nb-motion-distance));
    transform-origin: center top;
    transition: opacity var(--nb-motion-fast) var(--nb-motion-ease);
  }

  #arcane-root.arcane-theme-neubrutalism .arcane-mega-menu-panel[data-arcane-state="open"]:not([hidden]) {
    animation: nb-surface-enter var(--nb-motion-enter) var(--nb-motion-settle);
  }

  #arcane-root.arcane-theme-neubrutalism .arcane-mega-menu-panel[data-arcane-state="closed"] {
    opacity: 0;
  }
}
''';
  }
}
